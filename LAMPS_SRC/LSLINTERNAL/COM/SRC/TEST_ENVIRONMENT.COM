$ 	savver=f$verify(0)
$!
$! TEST_ENVIRONMENT.COM - set up testing environment logical names
$!
$! Created by 						BN	05-DEC-1988
$! More functionality added				WJJ	06-Feb-1989
$! HELP changed, CTRL/Z now EXIT not QUIT		PGH	16-Mar-1989
$! LSL$UIL added					PGH	03-Apr-1990
$! Adding packages removes previous identical ones	WJJ	 1-May-1990
$! Add LSL$LITES2CMD, LSL$UID, LSL$CDL			WJJ	 7-Aug-1990
$! Suppress verify properly				PGH	 9-May-1991
$!
$!
$!*****************************************************************************
$! initialisation and introductory message 
$	set noon
$	ws="write SYS$OUTPUT"
$	wo="write lsltest_out"
$	wc="write lsltest_com"
$	wl="!!write SYS$OUTPUT"
$! define working filenames
$	lsltest_tmpfile = "SYS$LOGIN:LSLTEST_''f$getjpi(0,"PID")'.TMP"
$	lsltest_comfile = "SYS$LOGIN:LSLTEST_''f$getjpi(0,"PID")'.COM"
$! set markers to say nothing changed yet
$	defaultroot_changed = 0
$	package_changed = 0
$!
$!------------------------------------------------------------------------------
$!
$	reprompt=0
$	if p1.nes."" then goto c_dispatch	! arguments on command line
$	reprompt=1
$	ws "LSL Testing Environment V1.2. Type HELP or ? for assistance."
$!
$!
$!*****************************************************************************
$! sets up initial TEST> prompt if no commands as initial arguments
$! loop back to here for next command.
$QUESTION:
$	if .not.reprompt then goto EXIT
$	read/end=EXIT/prompt="TEST> " sys$command P1
$	c_line=f$edit(P1,"upcase,trim")
$	if c_line.eqs."" then goto QUESTION
$	P2 = ""
$	P3 = ""
$	P4 = ""
$	P5 = ""
$	n=1
$c_next:
$	param = f$element(n-1, " ", c_line)
$	if param .eqs. " " then goto c_dispatch
$	P'n = param
$	n = n+1
$	goto c_next
$!
$!
$!*****************************************************************************
$! here with a command line split into parts for dispatch.
$c_dispatch:
$	p1len=f$length(p1)
$	p2len=f$length(p2)
$	if P1.eqs."?" then goto HELP
$	if P1.eqs.f$extract(0,p1len,"HELP") then goto HELP
$	if P1.eqs.f$extract(0,p1len,"EXIT") then goto EXIT
$	if P1.eqs.f$extract(0,p1len,"QUIT") then goto QUIT
$	if P1.eqs.f$extract(0,p1len,"TEST") then goto TEST
$	if P1.eqs.f$extract(0,p1len,"DEFAULT") then goto DEFAULT
$	if P1.eqs.f$extract(0,p1len,"CLEAR") then goto CLEAR
$	if P1.eqs.f$extract(0,p1len,"LIST") then goto LIST
$	if P1.eqs.f$extract(0,p1len,"DIRECTORY") then goto DIRECTORY
$	if P1.eqs.f$extract(0,p1len,"SAVE") then goto SAVE
$	if P1.eqs.f$extract(0,p1len,"RESTORE") then goto RESTORE
$	ws "%TEST-W-UNKNCMD, unknown command"
$	ws "\''P1'\"
$	goto QUESTION
$!
$!
$!*****************************************************************************
$!Types out the text below, and returns to the TEST> prompt...
$!
$HELP:
$	type sys$input

  This procedure provides access to directories in which new or non-standard
software can be tested. The logical names (LSL$EXE, LSL$COM...) are normally
threaded through SITE_ROOT and PUBLIC_ROOT. The TEST command will add/remove
specified root:package directories to/from the head of the search-lists. The
default action is to add specified packages on TEST_ROOT. The DEFAULT command
will substitute another root for PUBLIC_ROOT. 

HELP or ?			Type this message.
EXIT				Exit, setting selected environment.
QUIT or CTRL-Z			Quit, without changing environment.
TEST [+/-][root:]package,...	Add(default)/remove packages to/from list.
DEFAULT root			Change DEFAULT root to <rootname>.
CLEAR				Remove all packages from list.
LIST				List the currently selected packages.
DIRECTORY root			List the packages on <rootname> (def. TEST)
SAVE [filename]			Save the current settings for another session
RESTORE [filename]		Restore (default is SYS$LOGIN:LSLTEST.TSV)

  <Roots> are specified by their name part only, eg. PUBLIC, ISSUE, ALPHA, TEST.
Any TEST action and rootname will 'roll' along the list of packages. The
wildcard "*" may be used for an entire root or package name, except that adding
all roots is not permitted! Other wildcarding will get the first translation
only. 

Example:

 $ TEST
 TEST> TEST IMP			! test IMP from TEST root
 TEST> TEST MATRIX,LITES2	! test MATRIX and LITES2 from TEST root
 TEST> TEST ALPHA:TVES,DTMCREATE! test TVES and DTMCREATE from ALPHA root
 TEST> LIST			! show what we have
 TEST> SAVE			! save it for another time
 TEST> EXIT			! all done

$	goto QUESTION
$!
$!*****************************************************************************
$! Save current settings
$SAVE:
$! get default memory in if necessary
$	if f$type(default_root).nes."STRING" then gosub get_defaultroot
$! get package memory in if necessary
$	if f$type(packages_open).nes."INTEGER" then gosub get_packages
$	save_file = f$parse(p2,"SYS$LOGIN:LSLTEST.TSV")
$	save_file = f$element(0,";",save_file)
$	if save_file.eqs."" then goto save_filopnerr
$	on error then goto save_filopnerr
$	if f$search(save_file).nes."" then delete 'save_file';*
$	create 'save_file
$	set noon
$	open/append/err=save_filopnerr  lsltest_sav 'save_file
$! save default_root as first line
$	write lsltest_sav "LSLTESTSAVEFILE"
$	write lsltest_sav default_root
$	close lsltest_sav
$! append package list to save file
$	if packages_open.ne.0 then close lsltest_out
$	packages_open = 0
$	append 'lsltest_tmpfile 'save_file
$	ws "%TEST-I-CURSETSAV, Current settings saved in ''save_file'"
$	goto QUESTION
$!
$save_filopnerr:
$	ws "%TEST-E-FILOPNERR, cannot open file ''save_file'"
$	goto QUESTION
$!
$!*****************************************************************************
$! Restore saved settings
$RESTORE:
$	if f$type(packages_open).nes."INTEGER" then packages_open=0
$	if packages_open.ne.0 then close lsltest_out
$	packages_open = 0
$	save_file = f$parse(p2,"SYS$LOGIN:LSLTEST.TSV")
$	if save_file.eqs."" then goto save_filopnerr
$	open/read/err=save_filopnerr lsltest_in 'save_file
$	read/end=restore_bad lsltest_in line
$	if line.nes."LSLTESTSAVEFILE" then goto restore_bad
$	read/end=restore_bad lsltest_in default_root
$! Create new package list file
$	create 'lsltest_tmpfile
$	open/append lsltest_out 'lsltest_tmpfile
$	packages_open = 1
$restore_next:
$	read/end=restore_no_more lsltest_in line
$	wo line
$	goto restore_next
$!
$restore_no_more:
$	close lsltest_in
$	ws "%TEST-I-CURSETRES, Current settings restored from ''save_file'"
$! set some flags to ensure these get used
$	package_changed = 1
$	defaultroot_changed = 1
$	goto QUESTION
$!
$restore_bad:
$	ws "%TEST-E-SAVFILBAD, saved settings file is bad"
$	goto QUESTION
$!
$!*****************************************************************************
$! Search for packages on root.
$DIRECTORY:
$	if P2 .eqs. "" then P2 = "TEST"
$	directory LSL$'P2'_ROOT:[000000]*.DIR
$	goto QUESTION
$!
$!*****************************************************************************
$! change default root 
$DEFAULT: 
$! get default memory in if necessary
$	if f$type(default_root).nes."STRING" then gosub get_defaultroot
$	ws "Current default root is ",default_root
$	if p2.eqs."" then goto QUESTION
$	if f$trnlnm("LSL$''p2'_ROOT").eqs."" then goto default_noexist
$	if f$trnlnm("LSL$EXE_''p2'").eqs."" then goto default_nolists
$	default_root = P2
$	defaultroot_changed = 1
$	ws "New default root is ", default_root
$	goto QUESTION
$!
$default_noexist:
$	ws "%TEST-E-DEFNOEXIST, default root ''p2' does not exist"
$	goto QUESTION
$!
$default_nolists:
$	ws "%TEST-E-DEFNOLISTS, default root ''p2' search lists not defined"
$	goto QUESTION
$!
$!******************************************************************************
$! display currently testing packages
$LIST:
$! get package memory in if necessary
$	if f$type(packages_open).nes."INTEGER" then gosub get_packages
$	if packages_open .ne. 0 then close lsltest_out
$	packages_open = 0
$	open/read lsltest_in 'lsltest_tmpfile
$	read/end=list_none_at_all lsltest_in line
$	ws "Selected testing packages are :
$list_next:
$	ws "	",line
$	read/end=list_no_more lsltest_in line
$	goto list_next
$list_none_at_all:
$	ws "No packages currently selected"
$list_no_more:
$	close lsltest_in
$!
$! get default memory in if necessary
$	if f$type(default_root).nes."STRING" then gosub get_defaultroot
$	ws "Current default root is ",default_root
$	goto QUESTION
$!
$!*****************************************************************************
$! Clear all packages from list
$CLEAR:
$! Fake up TEST -*:* command
$	P2 = "-*:*"
$	goto TEST
$!
$!*****************************************************************************
$!The real thing - set packages to test
$TEST:	
$! ensure we've read in the package definitions
$	if f$type(packages_open).eqs."" then gosub get_packages
$! Mark package list changed now
$	package_changed = 1
$!
$	element_list = f$edit(p2,"COLLAPSE,UPCASE")
$	if element_list.eqs."" then goto test_end
$!
$	n_elem = 0
$	action = "ADD"
$	root = "TEST"
$test_elem:
$	element = f$element(n_elem, ",", element_list)
$	if element .eqs. "," then goto test_end
$	n_elem = n_elem+1
$	gosub sub_element
$	goto test_elem
$!
$test_end:
$	goto QUESTION
$!
$!------------------------------------------------------------------------------
$!
$sub_element:
$	n1 = 0
$	sign = f$extract(0,1,element)
$	if sign.eqs."-" then action = "REMOVE"
$	if sign.eqs."+" then action = "ADD"
$	if sign.eqs."+" .or. sign.eqs."-" then n1 = 1
$	n2 = f$locate(":",element)
$	n3 = f$length(element)
$	if n2.eqs.n3 then goto element_no_root
$	  root = f$edit(f$extract(n1,n2-n1,element),"COLLAPSE,UPCASE")
$	  n1=n2+1
$element_no_root:
$	package = f$edit(f$extract(n1,n3-n1,element),"COLLAPSE,UPCASE")
$!
$! here with action, root, package set up
$	if action .eqs. "REMOVE" then goto element_remove
$! must be ADD, check for wild root(!), and then REMOVE package first
$	if root.eqs."*" then -
		ws "%TEST-E-ROOTWILD, rootname '*' illegal when adding"
$	if root.eqs."*" then goto element_end
$!
$! here to remove a package
$element_remove:
$! close the reference file if open
$	if packages_open.ne.0 then close lsltest_out
$! copy it to a new version
$	open/read lsltest_in 'lsltest_tmpfile
$	create 'lsltest_tmpfile
$	open/append lsltest_out 'lsltest_tmpfile
$	packages_open = 1
$! to remove everything is easy
$	if root .eqs. "*" .and. package .eqs. "*" -
		then goto element_no_more
$element_next:
$	read/end=element_no_more lsltest_in line
$! test for explicit package name
$	if line .eqs. "''root':''package'" then goto element_next
$! only handle "*" for full root or package at the moment
$	if root.nes."*" .and. package.nes."*" then goto element_copy
$	  lc = f$locate(":",line)
$	  ll = f$length(line)
$	  if root.eqs."*" .and. package.eqs.f$extract(lc+1,ll-lc-1,line) -
		then goto element_next
$	  if package.eqs."*" .and. root.eqs.f$extract(0,lc,line) -
		then goto element_next
$! here to retain line in new version of reference file
$element_copy:
$	wo line
$	goto element_next
$!
$element_no_more:
$	close lsltest_in
$!
$	if action .nes. "ADD" then goto element_end
$!
$! here to ADD a package (after removing it first)
$element_add:
$	wild = 0
$	if package.eqs."*" then wild = 1
$!
$	d_spec = "LSL$''root'_ROOT:[000000]''package'.DIR;1"
$	p_spec = f$parse(d_spec)
$	s_num = 0
$el_s_loop:
$	s_spec = f$search(p_spec)
$	if s_spec .eqs. "" then goto el_s_loop_end
$	s_num = s_num+1
$	sl = f$length(s_spec)
$	s_ket = f$locate("]",s_spec)
$	s_dot = f$locate(".DIR;1",s_spec)
$	s_package = f$extract(s_ket+1,s_dot-s_ket-1,s_spec)
$	if packages_open.eq.0 then open/append lsltest_out 'lsltest_tmpfile
$	packages_open=1
$	wo "''root':''s_package'"
$	if wild.ne.0 then goto el_s_loop
$!
$el_s_loop_end:
$	if s_num.eq.0 then -
		ws "%TEST-W-PACKNOTSEL, Package not selected - ''d_spec'"
$!
$element_end:
$	return
$!
$!******************************************************************************
$!
$!
$!*****************************************************************************
$! here to exit, setting the selected environment
$EXIT:
$! check that something has changed and QUIT if not
$	if package_changed.eq.0 .and. defaultroot_changed.eq.0 then -
		goto QUIT
$! warn the user that this may take a moment
$	ws "%TEST-I-SETUPSEALS, Setting up search lists ..."
$! first remember current settings
$	open/write lsltest_com 'lsltest_comfile
$! check that package list has changed
$	if package_changed.eq.0 then goto ex_rem_dr
$! set logical LSL$TEST_PACKAGES to reflect the current package list
$	if f$trnlnm("LSL$TEST_PACKAGES","LNM$PROCESS").nes."" then -
		deassign LSL$TEST_PACKAGES
$	if packages_open.ne.0 then close lsltest_out
$	packages_open=0
$	open/read lsltest_in 'lsltest_tmpfile
$	prev_line = ""
$	read/end=ex_no_more lsltest_in prev_line
$	wc "$	Define LSL$TEST_PACKAGES -"
$	wl "$	Define LSL$TEST_PACKAGES -"
$ex_line:
$	read/end=ex_no_more lsltest_in line
$	wc prev_line, ",-"
$	wl prev_line, ",-"
$	prev_line = line
$	goto ex_line
$ex_no_more:
$	close lsltest_in
$	if prev_line.eqs."" then goto ex_rem_dr
$	wc prev_line
$	wl prev_line
$!
$! set logical LSL$TEST_DEFAULTROOT to reflect the current default root
$ex_rem_dr:
$! check that defaultroot has changed
$	if defaultroot_changed.eq.0 then goto ex_rem_exec
$	if f$trnlnm("LSL$TEST_DEFAULTROOT","LNM$PROCESS").nes."" then -
		deassign LSL$TEST_DEFAULTROOT
$	wc "$	Define LSL$TEST_DEFAULTROOT ''default_root'"
$	wl "$	Define LSL$TEST_DEFAULTROOT ''default_root'"
$!
$! execute the remember procedure
$ex_rem_exec:
$	close lsltest_com
$	@'lsltest_comfile
$!
$! Now generate the new logical names
$!
$	open/write lsltest_com 'lsltest_comfile
$! check that package list has changed
$	if package_changed.eq.0 then goto ex_gen_dr
$! generate the search lists
$	gosub do_genlists
$!
$! generate the default root
$ex_gen_dr:
$! check that defaultroot has changed
$	if defaultroot_changed.eq.0 then goto ex_gen_exec
$	gosub do_gendefault
$!
$! execute the generate procedure
$ex_gen_exec:
$	close lsltest_com
$	@'lsltest_comfile
$	delete 'lsltest_comfile';*
$!
$	ws "%TEST-I-SEALSSETUP, Search lists set up"
$	goto quit_tidy
$!
$QUIT:
$	ws "%TEST-I-NOMODSMAD, No modifications to TEST environment"
$quit_tidy:
$	if f$type(packages_open).eqs."INTEGER" then delete 'lsltest_tmpfile';*
$	if savver then set verify
$	exit
$!
$!------------------------------------------------------------------------------
$!
$!
$! generate search lists from logical name LSL$TEST_PACKAGES
$!  assuming output command file is already open
$do_genlists:
$!
$	directory_type="COM"
$	logical_name="COM"
$	gosub search_for_directories
$	directory_type="EXE"
$	logical_name="EXE"
$	gosub search_for_directories
$	directory_type="LIB"
$	logical_name="LIBRARY"
$	gosub search_for_directories
$	directory_type="HELP"
$	logical_name="HELP"
$	gosub search_for_directories
$	directory_type="LOOKUP"
$	logical_name="LOOKUP"
$	gosub search_for_directories
$	directory_type="ACCEPT"
$	logical_name="ACCEPT"
$	gosub search_for_directories
$	directory_type="UIL"
$	logical_name="UIL"
$	gosub search_for_directories
$	directory_type="CMD"
$	logical_name="LITES2CMD"
$	gosub search_for_directories
$	directory_type="UID"
$	logical_name="UID"
$	gosub search_for_directories
$	directory_type="CDL"
$	logical_name="CDL"
$	gosub search_for_directories
$!
$	return
$!
$!------------------------------------------------------------------------------
$!
$! subroutine to generate search list for a particular directory type
$!
$search_for_directories:
$	wl "$!"
$	wc "$!"
$	wl "$! Set up search list for .''directory_type directories"
$	wc "$! Set up search list for .''directory_type directories"
$	wl "$!"
$	wc "$!"
$!
$	previous_line=""
$	ngroup=0
$	nline=0
$	nelem=0
$	name=logical_name
$	dname=directory_type
$	if f$trnlnm("LSL$''name'","LNM$PROCESS").nes."" then -
		deassign LSL$'name
$	wl "$	Define	LSL$",name,"  -"
$	wc "$	Define	LSL$",name,"  -"
$search_next:
$	element = f$trnlnm("LSL$TEST_PACKAGES",,nelem)
$	if element.eqs."" then goto search_no_more
$	nelem = nelem+1
$	root = "TEST"
$	package = element
$	colon = f$locate(":",element)
$	elen =  f$length(element) 
$	if colon .eqs. elen then goto search_noroot
$	root = f$extract(0, colon, element)
$	package = f$extract(colon+1, elen-colon-1, element)
$search_noroot:
$	dirspec = "LSL$''root'_ROOT:[''package']''dname'.DIR"
$	if f$search(dirspec).eqs."" then goto search_next
$	if previous_line.eqs."" then goto search_first
$	wl previous_line
$	wc previous_line
$	nline=nline+1
$	if nline.lt.25 then goto search_first
$	nline=0
$	ngroup=ngroup+1
$	wl "		LSL$",name,"''ngroup':"
$	wc "		LSL$",name,"''ngroup':"
$	if f$trnlnm("LSL$''name'''ngroup'","LNM$PROCESS").nes."" then -
		deassign LSL$'name'ngroup
$	wl "$	Define	LSL$",name,"''ngroup'  -"
$	wc "$	Define	LSL$",name,"''ngroup'  -"
$search_first:
$	line = "		LSL$''root'_ROOT:[''package'.''dname'], -"
$	previous_line=line
$	goto search_next
$search_no_more:
$	if previous_line .eqs. "" then goto search_none
$	wl previous_line
$	wc previous_line
$search_none:
$	previous_line="		LSL$''name'_SITE:"
$	wl previous_line
$	wc previous_line
$	return
$!
$!------------------------------------------------------------------------------
$!
$do_gendefault:
$!
$	gosub get_defaultroot
$!	
$	logical_name="COM"
$	gosub set_default
$	logical_name="EXE"
$	gosub set_default
$	logical_name="LIBRARY"
$	gosub set_default
$	logical_name="HELP"
$	gosub set_default
$	logical_name="LOOKUP"
$	gosub set_default
$	logical_name="ACCEPT"
$	gosub set_default
$	logical_name="UIL"
$	gosub set_default
$	return
$!
$!------------------------------------------------------------------------------
$!
$set_default:
$	set_def_name = "LSL$''logical_name'_DEFAULT"
$	set_def_value = "LSL$''logical_name'_''default_root'"
$	if f$trnlnm(set_def_name,"LNM$PROCESS").nes."" then -
		deassign 'set_def_name
$	wl "$	define	''set_def_name'	''set_def_value'"
$	wc "$	define	''set_def_name'	''set_def_value'"
$	return
$!
$!
$!
$!******************************************************************************
$!
$! get record of default root from logical name LSL$TEST_DEFAULTROOT
$get_defaultroot:
$	default_root =  f$trnlnm("LSL$TEST_DEFAULTROOT")
$	if default_root.nes."" then goto gd_end
$! if none yet, translate a de facto sample
$	default_root = f$trnlnm("LSL$EXE_DEFAULT") - "LSL$EXE_"
$! if all else fails, assume PUBLIC
$	if default_root.eqs."" then default_root = "PUBLIC"
$gd_end:
$	return
$!
$!------------------------------------------------------------------------------
$!
$! get record of testing packages from logical name LSL$TEST_PACKAGES
$get_packages:
$	create 'lsltest_tmpfile
$	open/append lsltest_out 'lsltest_tmpfile
$	packages_open = 1
$gp_next:
$	pack = f$trnlnm("LSL$TEST_PACKAGES",,packages_open-1)
$	if pack.eqs."" then goto gp_end
$	packages_open = packages_open+1
$	wo pack
$	goto gp_next
$gp_end:
$	return
$!
