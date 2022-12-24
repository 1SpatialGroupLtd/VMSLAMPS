$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-11-11 15:28:04.000000000 +0000
$! *
$! * This program is free software: you can redistribute it and/or modify
$! * it under the terms of the GNU General Public License as published by
$! * the Free Software Foundation, version 3.
$! *
$! * This program is distributed in the hope that it will be useful, but
$! * WITHOUT ANY WARRANTY; without even the implied warranty of
$! * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
$! * General Public License for more details.
$! *
$! * You should have received a copy of the GNU General Public License
$! * along with this program. If not, see http://www.gnu.org/licenses/.
$!
$! PUBLISH.COM - procedure to administer the transfer of software onto
$! the LSL software distribution tree (LSL$PUBLIC_ROOT).
$!
$! Created						PGH  13-Oct-1986
$! bug with OLD fixed, questions modified		PGH  18-Mar-1987
$! Handle node/logical names better			WJJ  10-Jul-1987
$! Use LSL$ISSUE_ROOT not LSL$PUBLIC_ROOT		WJJ   9-Jun-1988
$! Use BACKUP not COPY to preserve dates		PGH   9-Nov-1988
$! Major revision for new test/publish/issue procedures	PGH  10-Mar-1989
$! remove bad "now deleting Alpha root version" message PGH  20-Apr-1989
$! allow wildcard publish without repeated reason	PGH  15-Aug-1989
$! allow wildcard publish without repeated subdir	PGH  23-Aug-1989
$! fix purging wrong file on publish to TEST root	PGH  05-Apr-1990
$! only check particular package, not whole tree	PGH  04-Jun-1990
$! add defaults for .UID and .LCM files			PGH  04-Jun-1990
$! add since date for wildcards				PGH  19-Jun-1990
$! better default from directory guess			PGH  19-Jun-1990
$! bug fixed with EXIST_CREATED				PGH  26-Jun-1990
$! add exclusion list for searches			TJH  13-Nov-1990
$! exclude all directories				PGH  14-Nov-1990
$! Guess target directories better, fix a few bugs	PGH  12-Oct-1991 (3.0)
$! check LSLPUBLISH rights ID and turn on if available	PGH   4-Feb-1992 (3.1)
$! Add Manager mode					PGH   4-Feb-1992 (3.1)
$! Assume to parallel directory from public		PGH   6-Mar-1992 (3.2)
$! Assume to parallel directory from $XGIS*		PGH   6-Mar-1992 (3.2)
$! Don't check whole package if publish to parallel dir	PGH   6-Mar-1992 (3.2)
$! Now changes default to LSL$XGIS_SOURCE_ROOT if XGIS	TJH  22-Apr-1992 (3.4)
$! deal with sub-sub-subdirectories better		PGH   9-Nov-1992 (3.5)
$! handle Alpha AXP public directory			PGH  21-Jun-1993 (3.5)
$! Remove Alpha AXP public directory			PGH  11-Nov-1994 (3.6)
$!
$	on control_C then goto emergency
$	on error then goto emergency
$	on warning then goto emergency
$	ws="write sys$output"
$	privileged=0
$	retain_privilege=0
$	record_open=0
$	publish_failed=0
$	ws "LSL software version administration (publishing) procedure V3.6"
$!
$! get a command
$!
$Panic:
$	ws "Try HELP if needed."
$ question:
$       read/end=exit/prompt="PUBLISH> " sys$command P1
$	p1=f$edit(p1,"upcase,collapse")
$       if p1 .eqs."" then goto panic
$	clen=f$length(p1)
$	do_help=0
$	do_new=0
$	do_old=0
$	do_test=0
$	do_alpha=0
$	do_beta=0
$	do_axpbeta=0
$	do_gamma=0
$	do_remove=0
$	do_manager=0
$	junk=f$search("qwerty.zxc",1)	! reset any wildcard context
$	junk=f$search("qwerty.zxc",2)	! reset any wildcard context
$	junk=f$search("qwerty.zxc",3)	! reset any wildcard context
$	junk=f$search("qwerty.zxc",4)	! reset any wildcard context
$	junk=f$search("qwerty.zxc")	! reset any wildcard context
$	if f$trnlnm("publish_exc_file") .nes. ""
$	then
$	   close publish_exc_file
$	   delete/nolog/noconfirm sys$scratch:lsl_publish_wild_exclusion.tmp;
$	endif
$	exclude=""
$	exclude_file=""
$	exist_created=""
$	delete_from_alpha=0
$	where=""
$	publish_text="Failure in"
$	old_root="?NONE?"
$	wild_where=0
$	wild_count=0
$	reason="Testing"
$	subdir=""
$	previous_subdir="*UNSET*"
$       if p1.eqs.f$extract(0,clen,"TEST") then goto test
$       if p1.eqs.f$extract(0,clen,"ALPHA") then goto alpha
$       if p1.eqs.f$extract(0,clen,"AXPBETA") then goto axp_beta
$       if p1.eqs.f$extract(0,clen,"BETA") then goto beta
$	if p1.eqs.f$extract(0,clen,"EXIT") then goto exit
$       if p1.eqs.f$extract(0,clen,"GAMMA") then goto gamma
$	if p1.eqs.f$extract(0,clen,"HELP") then goto help
$       if p1.eqs.f$extract(0,clen,"ISSUE") then goto gamma
$       if p1.eqs.f$extract(0,clen,"OLD") then goto old
$	if p1.eqs.f$extract(0,clen,"MANAGER") then goto manager
$       if p1.eqs.f$extract(0,clen,"NEW") then goto tell_new
$       if p1.eqs.f$extract(0,clen,"PUBLIC") then goto beta
$	if p1.eqs.f$extract(0,clen,"QUIT") then goto exit
$	if p1.eqs.f$extract(0,clen,"REMOVE") then goto remove
$	if p1.eqs."?" then goto help
$	ws "%PUBLISH-W-UNKNCMD, unknown command"
$	ws "\''p1'\"
$	goto question
$!
$! ************************************************************************
$!
$! here to differentiate between TEST/ALPHA/BETA/REMOVE
$!
$test:
$	phase="TEST"
$	do_test=1
$	to_root="LSL$TEST_ROOT:"
$	to_rootname="test"
$	from_root="LSL$SOURCE_ROOT:"
$	from_rootname="source"
$	old_root="?NONE?"
$	action="copie"
$	goto new
$!
$alpha:
$	phase="ALPHA"
$	do_alpha=1
$	to_root="LSL$ALPHA_ROOT:"
$	to_rootname="alpha"
$	from_root="LSL$TEST_ROOT:"
$	from_rootname="test"
$	old_root="?NONE?"
$	action="copie"
$	goto new
$!
$beta:
$	phase="BETA"
$	do_beta=1
$	from_root="LSL$ALPHA_ROOT:"
$	from_rootname="alpha"
$	to_root="LSL$PUBLIC_ROOT:"
$	to_rootname="public"
$	old_root="LSL$OLD_PUBLIC_ROOT:"
$	action="copie"
$	goto new
$!
$gamma:
$	phase="GAMMA"
$	do_gamma=1
$	from_root="LSL$PUBLIC_ROOT:"
$	from_rootname="public"
$	to_root="LSL$ISSUE_ROOT:"
$	to_rootname="issue"
$	old_root="LSL$OLD_ISSUE_ROOT:"
$	action="copie"
$	goto new
$!
$axp_beta:
$	ws "%PUBLISH-W-OBSOLETE, command AXPBETA is now obsolete. Use BETA instead.
$	goto question
$!
$remove:
$	phase="REMOVE"
$	do_remove=1
$	from_root="LSL$PUBLIC_ROOT:"
$	from_rootname="public"
$	to_root="LSL$PUBLIC_ROOT:"
$	to_rootname="public"
$	old_root="LSL$OLD_PUBLIC_ROOT:"
$	action="delete"
$	goto new
$!
$!
$! ************************************************************************
$!
$! here to publish a new program
$!
$new:
$	do_new=1
$	current_default=from_root+f$dir()
$	current_dir=f$parse(current_default,,,"directory")
$	current_package=f$element(0,".",current_dir)-"["-"]"
$!!!	current_subdir="."+f$element(1,".",current_dir)-"["-"]"
$	current_subdir=current_dir-"["-"]"-current_package
$	if current_subdir.eqs."." then current_subdir=""
$	if current_subdir.eqs.".." then current_subdir=""
$	current_extension=""
$	ws "The ''phase' stage of publishing ''action's a file on the ''to_root' tree."
$!
$! check our privilege
$!
$	if .not. (do_beta.or.do_gamma.or.do_remove) then goto priv_ok
$	if privileged then goto priv_ok		! previously checked
$check_rights:
$	ws "Checking privilege"
$	set noon
$	define/user sys$output nl:
$	define/user sys$error nl:
$	set rights/enable lslpublish
$	set on
$	rights=f$getjpi("0","PROCESS_RIGHTS")
$	privileged=(f$locate("LSLPUBLISH",rights).lt.f$len(rights))
$	if privileged then ws "Privilege OK"
$	if privileged .and. do_old then goto priv_ok2
$	if privileged .and. do_manager then goto manager_ok
$	if privileged then goto priv_ok
$norights:
$	ws "%PUBLISH-F-NORIGHTS, Insufficient privilege or missing rights identifier"
$	WS "%PUBLISH-I-HINT, rights id LSLPUBLISH is needed to change public roots."
$	WS "%PUBLISH-I-HINT, Go and talk to Paul Hardy or Tim Adams"
$	goto emergency
$!
$! ************************************************************************
$!
$! now get the source of the new program
$!
$priv_ok:
$	ws "Please give the standard software package that includes this file"
$       read/end=question/prompt="Package name [default is ''current_package'] ?  " -
		sys$command what_package
$	what_package=f$edit(what_package,"upcase,collapse")
$	if what_package.nes."" 
$	then 
$	   current_package=what_package
$	   current_subdir=".EXE"
$	   current_extension=".EXE"
$	endif
$! If publishing to test root from LSL$XGIS_SOURCE_ROOT change default from_root
$	if ((current_package.eqs."XGIS" -
        .or. current_package.eqs."HORIZON" -
        .or. current_package.eqs."METROPOLIS" -
        .or. current_package.eqs."OLIGS" -
        .or. f$extract(0,6,current_package).eqs."$XGIS_") -
        .and. (phase.eqs."TEST")) then from_root="LSL$XGIS_SOURCE_ROOT:"
$	current_default=from_root+"["+current_package+current_subdir+"]"+current_extension
$       ws "Please give file specification of file to be ''action'd."
$	ws "Default is:     ",current_default
$       read/end=question/prompt="File specification ?  " -
		sys$command what_file
$	what_file=f$edit(what_file,"upcase,collapse")
$	if what_file.eqs."" then goto question
$	if what_file.eqs."?" then goto question
$	what_node=f$parse(what_file,,,"node")		! given a node?
$	if what_node.nes."" then goto given_node	! OK if so
$	curdef_node=f$parse(current_default,,,"node")	! add default if not
$	what_file=curdef_node+what_file	! so lognames are treated properly
$given_node:
$	from_file=f$parse(what_file,current_default)
$	if from_file.eqs."" then goto no_such_file
$	from_node=f$parse(from_file,,,"node")
$	from_device=f$parse(from_file,,,"device")
$	from_parallel_root=0
$	if from_device.eqs."LSL$TEST_ROOT:" then from_parallel_root=1
$	if from_device.eqs."LSL$ALPHA_ROOT:" then from_parallel_root=1
$	if from_device.eqs."LSL$PUBLIC_ROOT:" then from_parallel_root=1
$	if f$extract(0,5,current_package).eqs."$XGIS" then from_parallel_root=1
$	from_directory=f$parse(from_file,,,"directory")
$	from_name=f$parse(from_file,,,"name")
$	from_type=f$parse(from_file,,,"type")
$	from_version=f$parse(from_file,,,"version")
$	if from_node.eqs.f$trnlnm("SYS$NODE") then from_node=""
$	if from_node.eqs."0::" then from_node=""
$	where=from_node+from_device+from_directory+from_name+from_type+from_version
$	ws "Parsed as:      ",where 
$	wild_where=0
$	if f$locate("*",where).lt.f$len(where) then wild_where=1
$	if f$locate("%",where).lt.f$len(where) then wild_where=1
$	if f$locate("...",where).lt.f$len(where) then wild_where=1
$	wild_count=0
$	since_when=""
$	if .not.wild_where then goto wildcard
$       read/end=question/prompt="Since what date and time [17-Nov-1858] ?  " -
		sys$command since_when
$	since_when=f$edit(since_when,"upcase,trim")
$	if since_when.eqs."" then goto wild_exclude
$	since_cvt=f$cvtime(since_when)
$	ws "Since:          ",since_cvt
$!
$wild_exclude:
$       read/end=question -
		/prompt="Specify files for exclusion e.g. XYZ*.COM; [None] : " -
				sys$command exclude
$	if exclude .eqs."" then goto wildcard
$	exclude=f$edit(exclude,"upcase,trim")
$	exclude=f$parse(exclude,from_file)
$	if exclude.eqs."" then goto no_such_file
$	exc_node=f$parse(exclude,,,"node")
$	exc_device=f$parse(exclude,,,"device")
$	exc_directory=f$parse(exclude,,,"directory")
$	exc_name=f$parse(exclude,,,"name")
$	exc_type=f$parse(exclude,,,"type")
$	exc_version=f$parse(exclude,,,"version")
$	if exc_node.eqs.f$trnlnm("SYS$NODE") then exc_node=""
$	if exc_node.eqs."0::" then exc_node=""
$	exclude=exc_node+exc_device+exc_directory+exc_name+exc_type+exc_version
$	ws "Parsed as:      ",exclude
$	wild_exclude=0
$	if f$locate("*",exclude).lt.f$len(exclude) then wild_exclude=1
$	if f$locate("%",exclude).lt.f$len(exclude) then wild_exclude=1
$	wild_exc_count=0
$	junk=f$search("qwerty.zxc",2)	! reset any wildcard context
$!
$! If single exclusion file don't bother to create a file of exclusion
$! file-specs
$	if .not.wild_exclude
$	then
$	   exclude_file=f$search(exclude,2)
$	   goto wildcard
$	endif
$!
$! ************************************************************************
$!
$! search for the wildcard exclusion clause. Load a temporary file with
$! exclusion file-specs burst from wildcard
$!
$wildexc:
$	exclude_file=f$search(exclude,2)
$	if exclude_file.nes."" then goto got_an_exclusion
$!
$! exclude wildcard complete?
$	if wild_exc_count.ne.0
$	then
$	   close publish_exc_file
$	   goto from_wildcard
$	endif
$	goto no_such_file		! else error
$got_an_exclusion:
$	if wild_exc_count .eq. 0
$	then
$	   open/write publish_exc_file -
			sys$scratch:lsl_publish_wild_exclusion.tmp
$	endif
$	write publish_exc_file exclude_file
$	wild_exc_count=wild_exc_count+1
$	goto wildexc
$!
$! ************************************************************************
$!
$! search for the file
$from_wildcard:
$	junk=f$search("qwerty.zxc",2)	! reset wildcard context
$!
$wildcard:
$	from_file=f$search(where,2)
$	if from_file.nes."" then goto got_a_file
$	if wild_count.ne.0 then goto question	! normal wildcard complete
$	goto no_such_file			! else error
$got_a_file:
$!
$! Test if we are to handle file exclusions
$	if exclude .nes. ""
$	then
$	   if wild_exc_count.eqs.0		! single exclude file
$	   then
$	      if from_file .eqs. exclude_file
$	      then
$	         ws "Skip by exclusion:   ",from_file
$	         goto wildcard
$	      endif
$	   else					! wild-carded exclusion
$!
$! Loop thru all the records in the temporary file containing excluded
$! file-specs 
$	      open/read publish_exc_file -
			sys$scratch:lsl_publish_wild_exclusion.tmp
$exc_loop:
$	      read/end=no_exclude_match publish_exc_file exc_record
$	      if from_file .eqs. exc_record
$	      then
$	         ws "Skip by exclusion:   ",from_file
$	         close publish_exc_file
$	         goto wildcard
$	      endif
$	      goto exc_loop
$!
$no_exclude_match:
$	      close publish_exc_file
$	   endif
$	endif
$!
$! look at what we have found
$	from_created=f$file_attributes(from_file,"CDT")
$	revdate=f$extract(0,11,from_created)
$	revtime=f$extract(12,5,from_created)
$	if since_when.eqs."" then goto since_ok
$	from_cvt=f$cvtime(from_created)
$	if from_cvt.gts.since_cvt then goto since_ok
$	ws "Skip by date:   ",from_file
$!!	ws "Created on:     ",revdate," at ",revtime
$	if wild_where then goto wildcard
$	goto question
$since_ok:
$	ws " "
$	ws "File found:     ",from_file
$	ws "Created on:     ",revdate," at ",revtime
$	from_node=f$parse(from_file,,,"node")
$	from_device=f$parse(from_file,,,"device")
$	from_directory=f$parse(from_file,,,"directory")
$	from_name=f$parse(from_file,,,"name")
$	from_type=f$parse(from_file,,,"type")
$	if from_type.eqs.".DIR"
$	then
$	   ws "Skip directory: ",from_file
$	   if wild_where then goto wildcard
$	   goto question
$	endif
$!
$! we have a file !
$	wild_count=wild_count+1
$	from_spec=from_name+from_type
$	current_default=from_node+from_device+from_directory+from_name+from_type
$!
$! ************************************************************************
$!
$! get confirmation of delete for source if alpha->public
$!
$	if wild_count.gt.1 then goto skip_del_alpha
$	delete_from_alpha=0
$	if .not.do_beta then goto skip_del_alpha
$	if from_device.nes."LSL$ALPHA_ROOT:" then goto skip_del_alpha
$	ws "This procedure will delete this ALPHA_ROOT file after the copy stage."
$       read/end=question/prompt="Do you specially want to keep the ALPHA_ROOT version ?  " -
		sys$command yes
$	yes=f$edit(yes,"upcase,collapse")
$	if yes then goto skip_del_alpha
$	delete_from_alpha=1
$skip_del_alpha:
$!
$! ************************************************************************
$!
$! here with source, get destination
$!
$	confirm_package=0		! set true if multiple packages
$	junk=f$search("qwerty.zxc",3)	! reset wildcard context
$	if from_parallel_root
$	then
$	   likely_place=to_root+from_directory+from_spec+";*"
$	   ws "Assuming target directory structure is the same layout"
$	else
$	   likely_place=to_root+"["+current_package+"...]"+from_spec
$	endif
$get_dest:
$	ws "Searching for:  ",likely_place
$	package_list=""
$	exist_file=""
$	exist_created=""
$next_exist:
$	filespec=f$search(likely_place,3)
$	if filespec.eqs."" then goto all_exist
$	exist_file=filespec
$	ws "Exists as:      ",exist_file
$	exist_created=f$file_attributes(exist_file,"CDT")
$	revdate=f$extract(0,11,exist_created)
$	revtime=f$extract(12,5,exist_created)
$	ws "Created on:     ",revdate," at ",revtime
$	to_file=f$element(0,";",exist_file)
$	to_dir=f$parse(exist_file,,,"directory")
$	package=f$element(0,".",to_dir)-"["
$	ws "Package is:     ",package
$	if do_test then goto got_to		! do copy then purge
$	if do_alpha then goto already_alpha	! error case
$	if .not.confirm_package then goto no_confirm
$       read/end=question/prompt="Is this the right one ?  " -
		sys$command yes
$	yes=f$edit(yes,"upcase,collapse")
$	if .not.yes then goto next_exist
$	package_list=package_list+package+"/"
$	goto all_exist
$no_confirm:
$	package_list=package_list+package+"/"
$	goto next_exist
$all_exist:
$	if package_list.eqs."" then goto no_to
$	second_package=f$element(1,"/",package_list)
$	if second_package.eqs."/" then second_package=""
$	if second_package.nes."" then goto multiple_packages
$!
$! ************************************************************************
$!
$! check for same date on from/to
$got_to:
$	if exist_created.nes.from_created then goto check_old
$	if do_remove then goto check_old
$	WS "%PUBLISH-W-SAMEDATE. New file has the same creation date as old !"
$       read/end=question/prompt="Publish it anyway [N] ?  " -
		sys$command yes
$	yes=f$edit(yes,"upcase,collapse")
$	if yes then goto check_old
$	if wild_where then goto wildcard
$	goto question
$!
$! ************************************************************************
$!
$! check for previous old version (only if public/issue root destination)
$!
$check_old:
$	older_purge=0
$	older_file=""
$	if old_root.eqs."?NONE?" then goto end_check_old
$	likely_place=old_root+to_dir+from_spec+";*"
$	ws "Search for old: ",likely_place
$	junk=f$search("qwerty.zxc",4)	! reset wildcard context
$next_older:
$	filespec=f$search(likely_place,4)
$	if filespec.eqs."" then goto got_older
$	older_file=filespec
$	ws "Exists as:      ",older_file
$	older_created=f$file_attributes(older_file,"CDT")
$	revdate=f$extract(0,11,older_created)
$	revtime=f$extract(12,5,older_created)
$	ws "Created on:     ",revdate," at ",revtime
$	older_revised=f$file_attributes(older_file,"RDT")
$	revdate=f$extract(0,11,older_revised)
$	revtime=f$extract(12,5,older_revised)
$	ws "Revised on:     ",revdate," at ",revtime
$	goto next_older
$got_older:
$	if older_file.eqs."" then goto no_older
$	ws "Older saved versions can be purged when publishing is complete."
$       read/end=question/prompt="Do you want this purge done ?  " -
		sys$command yes
$	if .not.yes then goto end_check_old
$	older_purge=1
$	older_file=f$element(0,";",older_file)
$	goto end_check_old
$no_older:
$	ws "No old version"
$end_check_old:
$!
$! ************************************************************************
$!
$! get final confirmation and reason for change
$!
$get_confirm:
$	if do_test then goto fixed_reason
$	if wild_count.gt.1 then goto fixed_reason
$       read/end=question/prompt="Reason for change ?  " -
		sys$command reason
$	if reason.eqs."" then goto get_confirm
$fixed_reason:
$	ws "Destination is: ",to_file
$	to_type=f$parse(to_file,,,"type")
$	temp_len=f$len(to_file)-f$len(to_type)
$	to_temp=f$extract(0,temp_len,to_file)+".PUBLISH_TMP"
$	if wild_count.gt.1 then goto skip_confirm
$       read/end=question/prompt="Do you want to change your mind ?  " -
		sys$command yes
$	yes=f$edit(yes,"upcase,collapse")
$	if yes then goto question
$skip_confirm:
$	if do_remove then goto no_copy
$	ws "Temp file is:   ",to_temp
$!
$! ************************************************************************
$!
$! actually do the thing
$!
$	ws "Copying to temporary file"
$	set noon
$	backup 'from_file' 'to_temp'
$	if .not.$status then goto copy_failed
$	ws "Renaming temporary file to destination"
$	rename 'to_temp' 'to_file'
$	if .not.$status then goto rename_failed
$	set on
$	ws "New file is:    ",to_file
$no_copy:
$!
$! ************************************************************************
$!
$! delete the source if from alpha root, and to public root
$!
$	if .not.delete_from_alpha then goto skip_delete2
$	ws "Deleting original file from ALPHA_ROOT"
$	delete/log 'from_file'
$skip_delete2:
$!
$! ************************************************************************
$!
$! save the previous one
$!
$	if exist_file.eqs."" then goto no_previous
$	if old_root.eqs."?NONE?" then goto no_previous
$	ws "Saving previous version"
$	set noon
$	set message/nofac/nosever/noident/notext
$	create/dir 'old_root''to_dir'
$	set message/fac/sever/ident/text
$	rename 'exist_file' 'old_root''to_dir'
$	if .not.$status then goto rename_old_failed
$	set on
$	ws "Old file now:   ",old_root,to_dir,from_spec
$!
$! ************************************************************************
$!
$! record the event for posterity
$!
$no_previous:
$	publish_text="New version in"
$	if exist_file.nes."" then publish_text="Replacement version in"
$	if do_remove then publish_text="Version deleted in"
$record:
$	if do_test then goto no_record
$	ws "Recording the event"
$	reason=f$edit(reason,"trim")
$	if reason.eqs."" then reason="Unknown"
$       username=f$edit(f$getjpi("","username"),"collapse")
$	time=f$time()
$	publish_text=publish_text+" package "+package+" by "+-
		username+" at "+time
$	record_file="LSL$ISSUE:PUBLIC.RECORD"
$	wr="write record_file"
$	if f$search(record_file).eqs."" then create 'record_file'
$	open/append record_file 'record_file'
$	record_open=1
$	wr ""
$	wr publish_text
$	if publish_failed then wr "**** Failed in ",failure_mode,"****"
$	if .not.do_manager
$	then
$	  wr     "From:	  ",from_file
$	  wr     "Created:  ",from_created
$	  wr     "To:	  ",to_file
$	endif
$	wr     "Reason:	  ",reason
$	close record_file
$	record_open=0
$no_record:
$	if do_manager then goto exit
$	if do_old then goto question
$!
$! ************************************************************************
$!
$! queue the old one for securing
$!
$	if exist_file.eqs."" then goto no_secure
$	if old_root.eqs."?NONE?" then goto no_secure
$	ws "Queuing the previous version for the SECURE archive"
$	saved_file=old_root+to_dir+from_spec
$	saved_file=f$search(saved_file)
$	if saved_file.eqs."" then goto no_saved_file
$	secure secure 'saved_file'
$	goto no_secure
$no_saved_file:
$	ws "%PUBLISH-E-NOSAVED, unable to find saved file for SECUREing"
$	failure_mode="SECURE"
$	publish_failed=1
$no_secure:
$!
$! ************************************************************************
$!
$! purge the even older one if requested 
$!
$	if publish_failed then goto emergency
$	if .not.older_purge then goto no_purge
$	ws "Purging the older saved previous versions"
$	set noon
$	if older_purge then purge/log 'older_file'
$	set on
$no_purge:
$!
$!
$! ************************************************************************
$!
$! purge the old one of a TEST command.
$!
$	if .not.do_test then goto not_test
$	ws "Purging the previous versions"
$!!!	older_file=f$element(0,";",exist_file)
$	set noon
$	purge/log 'to_file'
$	set on
$not_test:
$!
$! ************************************************************************
$!
$! all done !!!
$!
$	ws "Publishing of ",from_spec, " complete"
$	if wild_where then goto wildcard
$	goto question
$!
$! ************************************************************************
$!
$! here for totally new program
$!
$no_to:
$	to_dir=from_directory
$	to_file=to_root+to_dir+from_spec
$	ws "No previous version found of ",likely_place
$	package=current_package
$get_subdir:
$	if from_parallel_root	! from TEST or ALPHA or PUBLIC, or $XGIS*
$	then	! we can use the same directory spec 
$	  maindir=f$element(0,".",from_directory)-"["-"]"
$	  subdir=from_directory-maindir-"["-"]"
$	  if subdir.eqs."." then subdir=""
$	  if subdir.eqs.".." then subdir=""
$	  to_dir="["+package+subdir+"]"
$	  ws "Defaulting target directory to ",to_dir
$	  goto got_to
$	endif
$	previous_subdir=subdir
$	subdir=""
$	if from_type.eqs.".EXE" then subdir=".EXE"
$	if from_type.eqs.".LIC" then subdir=".EXE"
$	if from_type.eqs.".OLB" then subdir=".LIB"
$	if from_type.eqs.".HLB" then subdir=".HELP"
$	if from_type.eqs.".COM" then subdir=".COM"
$	if from_type.eqs.".UID" then subdir=".UIL"
$	if from_type.eqs.".LCM" then subdir=".CMD"
$	deftext=""
$	if subdir.nes."" then deftext="[Default is ''subdir']
$	if subdir.nes."" .and. subdir.eqs.previous_subdir -
		.and. wild_count.gt.1 then goto fixed_subdir
$       read/end=question/prompt="What subdirectory should it go in ''deftext'?  " -
		sys$command line
$	line=f$edit(line,"upcase,collapse")
$	if line.eqs."" then line=subdir
$	subdir=line
$fixed_subdir:
$	if f$extract(0,1,subdir).nes."." then goto bad_subdir
$	to_dir="["+package+subdir+"]"
$	to_file=to_root+to_dir+from_spec
$	goto got_to
$!
$! ************************************************************************
$!
$! here with multiple packages to sort out
$!
$multiple_packages:
$	ws "PUBLISH-W-MULTIPLE, file exists in more than one package"
$	confirm_package=1		! set true if multiple packages
$	ws "PUBLISH-I-REPEAT, search will be repeated to get confirmation"
$	goto get_dest
$!
$! ************************************************************************
$!
$! OLD command - replace existing version by one from LSL$OLD_xxx_ROOT
$!
$old:
$	do_old=1
$	older_purge=0
$	old_name="PUBLIC"
$	ws "Restore old version of sofware."
$!
$! check our privilege
$!
$	if privileged then goto priv_ok2	! previously checked
$	goto check_rights
$priv_ok2:
$	ws "Old versions would normally be restored from LSL$OLD_PUBLIC_ROOT:"
$	ws "Optionally they can be restored from LSL$OLD_ISSUE_ROOT:"
$       read/end=question/prompt="Do you want an old ISSUE version [Default N] ?  " -
		sys$command yes
$	if yes then old_name="ISSUE"
$	old_root="LSL$OLD_''old_name'_ROOT:"
$	to_root="LSL$''old_name'_ROOT:"
$	ws "Default source: ",old_root,"[*...].exe"
$       read/end=question/prompt="Name of file to be restored ?  " -
		sys$command where
$	where=f$edit(where,"upcase,collapse")
$	if where.eqs."" then goto question
$	if where.eqs."?" then goto question
$	where=f$parse(where,"''to_root'[*...].EXE")
$	ws "Looking for existing ",where
$	junk=f$search("qwerty.zxc")	! reset wildcard context
$	exist_file=f$search(where)
$	if exist_file.eqs."" then goto no_such_file
$	to_file=f$element(0,";",exist_file)
$	to_name=f$parse(to_file,,,"name","no_conceal")
$	to_type=f$parse(to_file,,,"type","no_conceal")
$	to_dir=f$parse(to_file,,,"directory")-"["-"]"
$	package=f$element(0,".",to_dir)
$	ws "Package is:     ",package
$	ws "Public file:    ",exist_file
$	to_created=f$file_attributes(to_file,"CDT")
$	revdate=f$extract(0,11,to_created)
$	revtime=f$extract(12,5,to_created)
$	ws "Created on:     ",revdate," at ",revtime
$	to_dir=f$parse(to_file,,,"directory")
$!
$! ************************************************************************
$!
$! got the target, now find the saved version
$!
$	where=old_root+to_dir+to_name+to_type
$	from_file=f$search(where)
$	if from_file.eqs."" then goto no_such_file
$	ws "Saved file:     ",from_file
$	from_created=f$file_attributes(from_file,"CDT")
$	revdate=f$extract(0,11,from_created)
$	revtime=f$extract(12,5,from_created)
$	ws "Created on:     ",revdate," at ",revtime
$get_reason:
$       read/end=question/prompt="Reason for change ?  " -
		sys$command reason
$	reason=f$edit(reason,"trim")
$	if reason.eqs."" then goto get_reason
$       read/end=question/prompt="Do you want to change your mind ?  " -
		sys$command yes
$	yes=f$edit(yes,"upcase,collapse")
$	if yes then goto question
$!
$! ************************************************************************
$!
$! actually do the thing
$!
$	ws "Renaming:       ",exist_file
$	ws "To:             ",old_root,to_dir,to_name,to_type,"_DUFF"
$	rename 'exist_file' 'old_root''to_dir''to_type'_duff
$	rename 'from_file' 'to_file'
$	ws "Previous ",to_name,to_type," restored from ",old_root
$	publish_text="Old version restored in"
$	goto record
$!
$! ************************************************************************
$!
$! here to give help
$!
$help:
$	type sys$input

This command procedure administers the publishing of LSL software, ie insertion
of new or revised software onto the LSL published software trees.

There are usually three intervening steps on the way to the software issue tree
(LSL$ISSUE_ROOT). These are: initial testing done by the programmer using the
test tree (LSL$TEST_ROOT), Alpha testing, done by Customer Services using the
alpha test tree (LSL$ALPHA_ROOT), and Beta testing done by general LSL users
and selected customers using the beta test tree (LSL$PUBLIC_ROOT). 

At intervals of about 6 months, LSL$PUBLIC_ROOT will be copied to become the
current issue root (LSL$ISSUE_ROOT), from which all standard software issues
are made. 

This PUBLISH procedure is involved moving a new version of software to carry
out the initial, Alpha, and Beta testing. The usual command sequence will be
the programmer will use TEST, then ALPHA commands. Customer Services
will then use the BETA command. Under exceptional circumstances, the GAMMA
command will be used to post a fixed version direct to LSL$ISSUE_ROOT.

Commands may be abbreviated, and currently available are:

HELP or ?	Type this message.
TEST		Put a new version of a software component into TEST tree.
ALPHA		Put a new version of a software component into ALPHA tree.
BETA		Put a new version of a software component into PUBLIC tree.
GAMMA		Put a new version of a software component into ISSUE tree.
OLD		Restore a saved version of software from LSL$OLD_xxx_ROOT:
REMOVE		Remove (delete) a software component from PUBLIC tree.
MANAGER		Allow this process unchecked access to public roots.
PUBLIC		alias for BETA for consistency.
ISSUE		alias for GAMMA for consistency.

The TEST/ALPHA/BETA/GAMMA commands will prompt for the source of the new
version, and may ask for a package in which to put it. 

For the BETA, GAMMA, and REMOVE commands, if there was an existing version on
the public tree, then it is saved in the corresponding LSL$OLD_xxx_ROOT:
directory, and is also queued for secure archiving. 

The OLD command will prompt for the file to restore.

The MANAGER command will enable the rights ID which gives access to the
public and issue roots.

All commands will ask for confirmation before carrying out the operation, after
verifying that the files exist. They will also ask for a reason for the change.
All operations done through PUBLISH are logged in a central file. 
$	goto question
$!
$! ************************************************************************
$!
$! here to tell user that NEW command is removed.
$!
$tell_new:
$	WS "%PUBLISH-W-NONEW, the NEW command has been withdrawn"
$	WS "%PUBLISH-I-HINT, try HELP for information on the TEST/ALPHA/BETA commands"
$	goto question
$!
$! ************************************************************************
$!
$! here to produce a list of packages
$!
$Packages:
$	DIRECTORY 'to_root'[000000]*.dir
$	goto question
$!
$!
$! ************************************************************************
$!
$! here to enable manager mode
$!
$manager:
$	do_manager=1
$	ws "Manager mode, gives privileged access to public roots"
$       read/end=question/prompt="Enable manager mode ?  " -
		sys$command enable_manager
$	if enable_manager
$	then
$	  goto check_rights
$	else
$	  ws "Disabling manager mode"
$	  privileged=1
$	endif
$manager_ok:
$	if enable_manager
$	then
$          read/end=question/prompt="Reason for needing access ?  " -
		sys$command reason
$	   if reason.eqs."" then reason="unspecified"
$	   publish_text="Privileged access granted to"
$	   retain_privilege=1
$	else
$	   publish_text="Privileged access removed for"
$	   reason="Finished"
$	   retain_privilege=0
$	endif
$	package="all"
$	goto record
$!
$! ************************************************************************
$!
$! here for errors
$!
$no_such_package:
$	WS "%PUBLISH-W-NOPACKAGE, No such package as ",package
$	goto question
$!
$no_such_file:
$	if where.eqs."" then where=what_file
$	WS "%PUBLISH-W-NOFILE, No such file as ",where
$	goto question
$!
$bad_subdir:
$	WS "%PUBLISH-W-BADSUB, bad subdirectory ",subdir
$	goto get_subdir
$!
$copy_failed:
$	set on
$	WS "%PUBLISH-F-COPYFAIL, copy to ",to_temp," failed"
$	failure_mode="COPY"
$common_failure:
$	temp_file=f$search(to_temp)
$	if temp_file.eqs."" then goto no_temp
$	WS "%PUBLISH-I-DELETE, the temporary file will now be deleted"
$	delete/noconfirm 'to_temp';*
$	goto orig_ok
$!
$no_temp:
$	WS "%PUBLISH-I-NOTEMP, the temporary file was not created"
$orig_ok:
$	WS "%PUBLISH-I-OK, the original file should still be OK"
$	publish_failed=1
$	goto record
$!
$rename_failed:
$	set on
$	WS "%PUBLISH-F-RENAMEFAIL, rename to ",to_file," failed"
$	failure_mode="RENAME"
$	goto common_failure
$!
$rename_old_failed:
$	set on
$	WS "%PUBLISH-F-RENAMEFAIL, rename of old file to ",old_root,to_dir," failed"
$	WS "%PUBLISH-E-UPTOYOU, please sort this out yourself"
$	WS "%PUBLISH-I-OK, the new file should still be OK"
$	publish_failed=1
$	failure_mode="RENAME OLD"
$	goto record
$!
$already_alpha:
$	WS "%PUBLISH-E-EXISTS, previous version already exists in ''to_root'"
$	WS "%PUBLISH-I-HINT, Go and talk to Customer Services about testing"
$	goto question
$!
$! ************************************************************************
$!
$! here for abnormal exits
$!
$!
$emergency:
$	set noon
$	if record_open then close record_file
$	WS "%PUBLISH-W-ABORT. PUBLISH procedure terminated abnormally"
$!
$! ************************************************************************
$!
$! all done
$!
$exit:
$	if f$trnlnm("publish_exc_file") .nes. ""
$	then
$	   close publish_exc_file
$	   delete/nolog/noconfirm sys$scratch:lsl_publish_wild_exclusion.tmp;
$	endif
$	if privileged .and. (.not.retain_privilege)
$	then
$	   set noon
$	   define/user sys$output nl:
$	   define/user sys$error nl:
$	   set rights/disable lslpublish
$	endif
$	set noverify
$	exit
