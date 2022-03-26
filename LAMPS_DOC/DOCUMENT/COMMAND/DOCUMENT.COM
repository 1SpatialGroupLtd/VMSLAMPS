$	set noverify
$	set noon				! ignore $status settings
$	on control_y then goto only_exit	! <CTRL/Y> is fatal
$!
$! *****************************************************************************
$! DOCUMENT - a command file to manage the creation and maintenance of LSL
$!	      documentation.
$!
$! Copyright (C) Laser-Scan Laboratories Ltd, Cambridge, England
$! Author TJ Ibbs, 6 May 1987 sqq
$!
$! *****************************************************************************
$! Modification		12-Nov-1987	Tony J Ibbs
$! Call a new DUMMY_ROUTINE to force all subroutines to be scanned at the start
$! of a session - this is to overcome a problem with DCL under VMS v4.6
$!
$! Modification		24-Nov-1987	Tony J Ibbs
$! We now have an LN03 printer, on queue LN03_PRINT, command LNPRINT to
$! print on it
$!
$! Modification		25-Nov-1987	Tony J Ibbs
$! Correct a bug in PRINT_FILE - outfile was incorrectly set when a .LNI file
$! was produced
$!
$! Modification		 8-Mar-1988	Tony J Ibbs
$! Amend CREATE_FILES to cope with the new templates for PACKAGE documents
$!
$! Modification		 9-Mar-1988	Tony J Ibbs
$! Delete the global symbols DOC$WIDTH, DOC$SMOOTH and DOC$PRINTER at the end
$!
$! Modification		20-Apr-1988	Tony J Ibbs
$! Modify to work on non-ANSI terminals - ie not using escape sequences
$!
$! Modification		20-May-1988	Tony J Ibbs
$! After calling DOCRNO_SUB, test $status immediately. Previously, used to
$! do an assignment first, which apparently reset $status, so the succeeding
$! tests on its value didn't work...
$!
$! Modification		29-Dec-1988	W. J. James
$! Reflect reorganisation of documentation tree - everything is now on
$! LSL$DOC_ROOT. Old 'top level' stuff is in LSL$DOC_ROOT:[DOC...].
$!
$! Modification		13-Jun-1987	Tony J Ibbs
$! Set DOC$document in the MENU_DOCUMENT_FILE_ACTION menu
$!
$! Modification         26-Jan-1989     S. M. Gutteridge
$! Add new template for Site Visit Reports
$!
$! Modification         02-Apr-1992     Paul Hardy
$! allow interrupt of menu with CTRL/C
$!
$! *****************************************************************************
$! define our standard abbreviations
$!
$	ws  = "write sys$output "
$	wsb = "write sys$output """""
$!
$	TRUE     = 1
$	FALSE	 = 0
$!
$! return values (for $status) from subroutines, etc
$! (note that HAD_EOF and HAD_CTRL are also 'failures')
$!
$	SUCCESS	 = %x10000001		! routine succeeded
$	FAILURE	 = %x10000000		! routine failed
$	HAD_EOF  = %x10000002		! user replied <CTRL/Z> to a question
$	HAD_CTRL = %x10000004		! user interrupted with a <CTRL/Y>
$!
$! and printers that we support
$!
$	DOC$LQprinter   = "LETTER QUALITY PRINTER"
$	DOC$LN03printer = "LASER PRINTER"
$	DOC$Lineprinter = "LINE PRINTER"
$	DOC$Terminal    = "TERMINAL"
$	DOC$Noprinter   = "NOTHING TO PRINT"
$!
$! *****************************************************************************
$! introduce ourselves
$!
$	wsb
$	ws "			    DOCUMENT"
$	wsb
$	ws "    Laser-Scan standard documentation procedure (v1.4, 20-April-1988)"
$	wsb
$!
$! *****************************************************************************
$! ?????????????????????????????????????????????????????????????????????????????
$! Call a dummy subroutine, to force us to scan all of the subroutines before
$! we do anything else. This is to overcome a bug in DCL under VMS v4.6
$!
$	call DUMMY_ROUTINE
$!
$! ?????????????????????????????????????????????????????????????????????????????
$! *****************************************************************************
$! disable <CTRL/Y> (and thus <CTRL/C>) for the next bit
$!
$	on control_y then continue		! <CTRL/Y> is ignored
$!
$! do the things that MUST be completed before the user can be allowed to use
$! <CTRL/Y> to escape
$!
$! - work out whether we are logged in as DOC, or being called as a normal
$!   command procedure
$!
$	DOC_user = f$getjpi("","USERNAME").eqs."DOC         "
$!
$! - remember the current SD environment, so we can restore it when we
$!   exit, if we have not been called by logging on as DOC
$!
$	old_here   = f$trnlnm("HERE")
$	old_there  = f$trnlnm("THERE")
$!
$!!! - make LSL$DOCDISK be concealed, in the same way as LSL$DOC_ROOT already is
$!!!
$!!!	define/translation="CONCEALED"  LSL$DOCDISK  'f$trnlnm("LSL$DOCDISK")
$!
$! - the default editor is EDT
$!
$	default_editor = "EDT/COMMAND=LSL$DOC_COMMAND:EDTINI.EDT"
$!
$! - define the global symbols that we shall need
$!
$	DOC$RESULT   == 0		! to return a result from subroutines
$	DOC$SCREEN   == FALSE		! we have not yet played with the screen
$	DOC$SPELLED  == FALSE		! nor have we spelt anything
$	DOC$NO_MENUS == FALSE		! we want to display menus
$	DOC$EDITOR   == default_editor	! use the default editor
$	DOC$WIDTH    == 80		! and the default screen width
$	DOC$SMOOTH   == TRUE		! TYPE documents with smooth scrolling
$	DOC$PRINTER  == ""		! no printer selected yet
$!
$! the other things that we want to define are all non-critical, so
$! can safely be interrupted by <CTRL/Y>. However, we must now go
$! to an earlier label to tidy up after the things we have just done.          
$!
$  	on control_y then goto final_exit	! <CTRL/Y> is fatal
$!
$! *****************************************************************************
$! if we are not logged in as DOC, look to see if there is an initialisation
$! file to obey
$!
$	gosub check_inifile
$	if .not.$status then goto final_exit
$!
$! work out whether we have the display capabilities that we need
$! - if we don't, warn the user, but carry on anyway.
$!
$	DOC$is_ansi = f$getdvi( f$trnlnm("TT"), "TT_ANSICRT" )
$	if DOC$is_ansi then goto display_is_usable
$!
$	   DOC$SMOOTH == FALSE		! don't try for smooth scroll
$	   DOC$WIDTH  == 80		! width must be 80
$!
$	   ws "%DOC-W-DISPLAY, display is not an ANSI terminal"
$	   ws "-DOC-I-NOMENUS, menu displays will not clear screen, etc"
$	   call PRESS_RETURN
$	   if .not.$status then goto final_exit
$!
$display_is_usable:
$!
$! *****************************************************************************
$! now give them the top level menu, and work out what we want to do
$!
$do_MENU_TOPLEVEL:
$!
$	call MENU_TOPLEVEL
$!
$	if $status.eq.HAD_CTRL then goto do_MENU_TOPLEVEL
$	if $status.eq.HAD_EOF  then goto final_exit
$	if $status.eq.FAILURE  then goto final_exit
$!
$! if we got any other response, then something has gone wrong!
$!
$	ws "%DOC-E-INTERNAL, internal DOCUMENT error"
$	ws "-DOC-I-REPORT, please report the problem with all details"
$	call PRESS_RETURN
$	if .not.$status then goto final_exit
$	goto do_MENU_TOPLEVEL
$!
$! *****************************************************************************
$! come here to exit from the command procedure
$!
$final_exit:
$!
$! don't allow them to stop us now
$!
$	on control_y then continue
$!
$    	if DOC$SCREEN then call UNSET_SCREEN
$!
$! delete the global symbols we used for returning values
$!
$	delete/symbol/global  DOC$RESULT
$	delete/symbol/global  DOC$SCREEN
$	delete/symbol/global  DOC$SPELLED
$	delete/symbol/global  DOC$EDITOR
$	delete/symbol/global  DOC$NO_MENUS
$	delete/symbol/global  DOC$WIDTH
$	delete/symbol/global  DOC$SMOOTH
$	delete/symbol/global  DOC$PRINTER
$!
$!!!! remove our private definition of LSL$DOCDISK
$!!!!
$!!!	deassign/process LSL$DOCDISK
$!
$! if we were an independent user, then redefine the SD environment
$! as it was when we entered DOCUMENT
$!
$	if DOC_user then goto no_need_to_SD
$	   deassign HERE			! remove the old assignments
$	   deassign THERE
$	   if old_there.nes."" then -
	      define   HERE   'old_there'	! pretend we are THERE
$	   sd  'old_here'			! and SD to HERE
$	   write sys$output "%DOC-I-SDBACK," + -
	      " HERE and THERE are now as they were when you called DOCUMENT"
$!
$no_need_to_SD:
$!
$! .............................................................................
$! and finally exit the command procedure
$!
$only_exit:	exit
$! *****************************************************************************

$! =============================================================================
$! CHECK_INIFILE
$! look for an initialisation file
$! -----------------------------------------------------------------------------
$check_inifile:
$!
$! check whether the user has defined an initialisation file to be obeyed
$! - if we are logged on as DOC, then there is not initialisation file
$!
$ 	if DOC_user then goto no_init_file
$!
$! otherwise, look for the logical name LSL$DOC_INITIALISE
$!
$	inifile = f$trnlnm("LSL$DOC_INITIALISE")
$	if inifile.eqs."" then goto no_init_file
$!
$! and check that it does indeed point to a file that exists
$!
$	if f$search(inifile).eqs."" then goto no_init_file
$!
$! so we can obey the file - tell the user, and then do it
$!
$	ws "%DOC-I-INIFILE, obeying LSL$DOC_INITIALISE file ""''inifile'"""
$!
$! the file can sensibly be used to set any of the following global symbols
$!
$!	DOC$NO_MENUS == TRUE			(default is FALSE)
$!	DOC$EDITOR   == "editor command"	(default is EDT/COMMANDS=...)
$!	DOC$WIDTH    == 132			(default is 80)
$!	DOC$SMOOTH   == FALSE			(default is TRUE)
$!
$	@'inifile'
$	if .not.$status then return 'FAILURE'
$!
$! if the user has altered DOC$WIDTH, or DOC$EDITOR, then note that changes
$!
$	if DOC$WIDTH .ne.80             then set terminal/width='DOC$WIDTH'
$	if DOC$EDITOR.ne.default_editor then default_editor = DOC$EDITOR
$!
$no_init_file:
$	return 'SUCCESS'

$! =============================================================================
$! ASK
$! Called to ASK the user a question
$!
$!	P1		the question to ask
$!	DOC$RESULT	the answer to the question
$! -----------------------------------------------------------------------------
$ASK:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$	question = P1 + " "
$!
$! and ask the question
$!
$ask_question:
$	read/end_of_file=eof/error=ask_error -
	    /prompt="''question'" -
	    sys$command  answ
$!
$! and return it...
$!
$	DOC$RESULT == answ
$	exit 'SUCCESS'
$!
$! .............................................................................
$eof:	DOC$RESULT == ""
$	exit 'HAD_EOF'
$!
$ask_error:
$	DOC$RESULT == ""
$	ws "%DOC-E-ASKERR, error in reading response"
$	exit 'FAILURE'
$!
$	ENDSUBROUTINE		! ASK

$! =============================================================================
$! MENU_TOPLEVEL
$! choose what to do, in a general sense
$! -----------------------------------------------------------------------------
$MENU_TOPLEVEL:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$toplevel_repeat:
$	Menu_name  = "TOP-LEVEL"
$	Line_count = 5
$ 	Line1 = "PACKAGE - work on the documentation for a standard package"
$	Line2 = "DOC     - work in the normal DOC directories"
$	Line3 = "INFO    - look at the INFO bulletin"
$  	Line4 = "OPTIONS - choose various options for how DOCUMENT works"
$ 	Line5 = "EXIT    - exit DOCUMENT"
$!
$	CtrlC = "redisplay the TOP-LEVEL menu"
$	CtrlZ = "exit DOCUMENT"
$!
$toplevel_show:
$	call DISPLAY_MENU
$	if .not.$status then exit '$status'
$!
$toplevel_ASK:           
$	call ASK  "Choose the option you want:"
$!
$	if .not.$status then exit '$status'
$	if DOC$RESULT.eqs."?" then goto toplevel_repeat
$ 	if DOC$RESULT.eqs.""  then goto toplevel_ASK
$!
$	answ := 'DOC$RESULT		! upper-case the answer
$!
$ 	if f$locate( answ, "PACKAGE" ).eq.0 then goto do_toplevel_package
$ 	if f$locate( answ, "DOC"     ).eq.0 then goto do_toplevel_doc
$ 	if f$locate( answ, "INFO"    ).eq.0 then goto do_toplevel_info
$ 	if f$locate( answ, "OPTIONS" ).eq.0 then goto do_toplevel_options
$	if f$locate( answ, "EXIT"    ).eq.0 then exit 'HAD_EOF'
$!
$	ws "%DOC-I-INVALID, I don't understand ""''answ'"""
$	goto toplevel_ASK
$!
$! .............................................................................
$! and call the correct menu
$!
$do_toplevel_package:
$	DOC$is_package = TRUE
$	call MENU_PACKAGE_CHOICE
$	goto toplevel_repeat
$!
$do_toplevel_doc:
$	DOC$is_package = FALSE
$	call MENU_DOC
$	goto toplevel_repeat
$!
$do_toplevel_info:
$	call UNSET_SCREEN
$	assign/user TT SYS$INPUT
$	INFO
$	goto toplevel_repeat
$!
$do_toplevel_options:
$	DOC$previous_menu = "TOP-LEVEL"
$	call MENU_OPTIONS
$	goto toplevel_repeat
$!
$	ENDSUBROUTINE		! MENU_TOPLEVEL

$! =============================================================================
$! MENU_PACKAGE_CHOICE
$! work on standard package oriented documentation
$! -----------------------------------------------------------------------------
$MENU_PACKAGE_CHOICE:
$	SUBROUTINE
$	set noon
$    	on control_y then exit 'HAD_CTRL'
$!
$! move into the top of the package documentation tree
$!
$package_choice_repeat:
$	wsb
$      	sd lsl$doc_root:[000000]
$!
$ 	Menu_name = "PACKAGE CHOICE"
$	CtrlZ = "return you to the TOP-LEVEL menu"
$	CtrlC = "return you to the TOP-LEVEL menu"
$!
$package_choice_show:
$	call DISPLAY_FILES  "*.dir"  FALSE
$	if .not.$status then exit '$status'
$!
$package_choice_ASK:
$	call ASK  "Choose the package you want:"
$!                 
$	if .not.$status then exit '$status'
$ 	if DOC$RESULT.eqs."?" then goto package_choice_repeat
$ 	if DOC$RESULT.eqs.""  then goto package_choice_ASK
$!
$	DOC$package := 'DOC$RESULT		! upper-case the answer
$!
$	if f$search( DOC$package+".DIR" ).eqs."" then goto package_doesnt_exist
$!
$! remember where we are, and go down a level
$!
$package_choice_exists:
$	call  MENU_DOCUMENT_CHOICE
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto package_choice_repeat
$!
$! .............................................................................
$package_doesnt_exist:
$	ws "%DOC-E-NOPACKAGE, there is no package called ""''DOC$package'"""
$	call ASK  "Do you want to create it?"
$!
$	if .not.$status then exit '$status'
$ 	if DOC$RESULT.eqs."?" then goto package_choice_repeat
$ 	if DOC$RESULT.eqs.""  then goto package_choice_ASK	! implicit NO
$	if .not.DOC$RESULT    then goto package_choice_ASK	! explicit NO
$!
$	@lsl$doc_command:standard_create_sub
$!
$	if $status.eq.HAD_CTRL then exit '$status'
$	call PRESS_RETURN		! let them see any results
$	goto package_choice_exists	! and go into the package
$!
$	ENDSUBROUTINE		! MENU_PACKAGE_CHOICE

$! =============================================================================
$! MENU_DOCUMENT_CHOICE
$! choose a document from this package
$! -----------------------------------------------------------------------------
$MENU_DOCUMENT_CHOICE:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$document_choice_repeat:
$	wsb                    
$ 	sd  LSL$DOC_ROOT:['DOC$package']
$!
$! work out if there are any .DIR files, and any .RNO files
$!
$	got_dir_files = f$search( "*.DIR" ).nes.""
$	got_rno_files = f$search( "*.RNO" ).nes.""
$!
$	got_both    = got_dir_files.and.got_rno_files
$	got_neither = .not.(got_dir_files.or.got_rno_files)
$!
$! we can thus work out what our question will be
$!
$	question = "Choose the "
$	if got_dir_files                then question = question + "document "
$	if got_both                     then question = question + "or "
$	if got_rno_files.or.got_neither then question = question + "file "
$	question = question + "you want:"
$!
$ 	Menu_name = "DOCUMENT CHOICE"
$	CtrlZ = "return you to the PACKAGE CHOICE menu"
$	CtrlC = "return you to the TOP-LEVEL menu"
$!
$document_choice_show:
$	call DISPLAY_FILES  "*.dir,*.rno"  TRUE
$	if .not.$status then exit '$status'
$!
$document_choice_ASK:
$	call ASK  "''question'"
$!
$	if .not.$status then exit '$status'
$	if DOC$RESULT.eqs."?" then goto document_choice_repeat
$ 	if DOC$RESULT.eqs.""  then goto document_choice_ASK
$!                                  
$	file := 'DOC$RESULT		! upper-case the answer
$!
$! if we have directories, then assume that it is a directory
$! otherwise, if we have .RNO files, assume that it is a runoff file
$!
$	fname = f$parse(file,,,"NAME")
$!
$! the file type will default to .DIR if we have directories, and otherwise
$! it will default to .RNO
$!
$	if      got_dir_files then ftype = f$parse(file,".DIR",,"TYPE")
$	if .not.got_dir_files then ftype = f$parse(file,".RNO",,"TYPE")
$!
$	file = fname+ftype
$!
$	if f$search( file ).nes."" then goto document_choice_exists
$	   if ftype.eqs.".DIR" then ws -
			"%DOC-E-NODIR, there is no directory called ""''file'"""
$	   if ftype.nes.".DIR" then ws -
			"%DOC-E-NOFILE, there is no file called ""''file'"""
$	   call ASK  "Do you want to create it?"
$	   if .not.$status then exit '$status'             
$ 	   if DOC$RESULT.eqs."?" then goto document_choice_repeat
$ 	   if DOC$RESULT.eqs.""  then goto document_choice_ASK
$	   if .not.DOC$RESULT    then goto document_choice_ASK
$	   if ftype.nes.".DIR" then goto dont_create_DIR
$	      call CREATE_DIRECTORY 'fname'
$	      if $status.eq.HAD_CTRL then exit '$status'
$	      goto document_choice_repeat
$dont_create_DIR:
$	   DOC$previous_menu = "DOCUMENT CHOICE"
$	   call CREATE_FILE 'file'
$	   if $status.eq.HAD_CTRL then exit '$status'
$	   goto document_choice_repeat
$!
$! work out what to do now
$! - if it was a .DIR file, then we choose what to do with the document
$! - if it was a .RNO file, then we must work on that file
$!
$document_choice_exists:
$	if ftype.eqs.".DIR" then goto do_menu_document_action
$	if ftype.eqs.".RNO" then goto do_menu_document_file
$	   ws "%DOC-E-UNKPACK," + -
	      " file ""''file'"" is not a directory or a .RNO file"
$	   ws "-DOC-I-IGNORED, it should not be in this PACKAGE directory"
$	   call PRESS_RETURN
$	   if $status.eq.HAD_CTRL then exit '$status'
$	   goto document_choice_repeat
$!
$! .............................................................................
$do_menu_document_action:
$!
$	DOC$directory = fname
$	DOC$previous_menu = "DOCUMENT CHOICE"
$!
$	call  MENU_DOCUMENT_ACTION
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto document_choice_repeat
$!
$! .............................................................................
$do_menu_document_file:
$!
$ 	DOC$file = file
$	DOC$previous_menu = "DOCUMENT CHOICE"
$!
$ 	call  MENU_DOCUMENT_FILE_ACTION
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto document_choice_repeat
$!
$	ENDSUBROUTINE		! MENU_DOCUMENT_CHOICE

$! =============================================================================
$! MENU_DOCUMENT_ACTION
$! choose what to do to a document
$! -----------------------------------------------------------------------------
$MENU_DOCUMENT_ACTION:
$	SUBROUTINE
$     	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$document_action_repeat:
$!
$	error = ""
$	auxer = ""
$	DOC$document = ""
$!
$! work out the name of the document
$! - if there is no document (ie no .SPEC file) then drop into the
$!   file choice menu instead - ie ignore the DOCUMENT ACTION menu
$!   itself
$! - if there is more than one document, we will have to complain
$!   later on
$!
$	lookfor = "LSL$DOC_ROOT:[''DOC$package'.''DOC$directory']*.SPEC"
$!
$	specfile = f$search( lookfor )
$	if specfile.nes."" then goto got_specfile
$	   DOC$document = ""
$	   call MENU_DOCUMENT_FILE_CHOICE
$	   exit '$status'
$!
$got_specfile:
$ 	if f$search( lookfor ).eqs."" then goto display_document_action_menu
$	   error = "%DOC-E-MULDOCMT," + -
		   " there is more than one document defined in this directory"
$	   auxer = "-DOC-I-USEFIRST, the first is the only one available"
$!
$display_document_action_menu:
$	wsb
$	sd  LSL$DOC_ROOT:['DOC$package'.'DOC$directory']
$!
$	DOC$document = f$parse( specfile,,, "NAME" )
$!
$	Menu_name  = "DOCUMENT ACTION"
$	Line_count = 5
$	Line1 = "RUNOFF  - runoff and print ''DOC$document'"
$	Line2 = "FILES   - work on the files in this directory
$	Line3 = "QUEUE   - show what is on the print queues"
$	Line4 = "KILL    - delete an entry from a print queue"
$  	Line5 = "OPTIONS - choose various options for how DOCUMENT works"
$!
$	CtrlZ = "return you to the DOCUMENT CHOICE menu"
$	CtrlC = "return you to the TOP-LEVEL menu"
$!
$document_action_show:
$	call DISPLAY_MENU
$	if .not.$status then exit '$status'
$!
$	if error.eqs."" then goto document_action_ASK
$	   ws error
$	   if auxer.nes."" then ws auxer
$	   wsb
$!
$document_action_ASK:
$	call ASK  "What do you want to do?"
$!
$	if .not.$status then exit '$status'
$	if DOC$RESULT.eqs."?" then goto document_action_repeat
$ 	if DOC$RESULT.eqs.""  then goto document_action_ASK
$!
$	answ := 'DOC$RESULT		! upper-case the answer
$!
$ 	if f$locate( answ, "RUNOFF"  ).eq.0 then goto do_document_runoff
$ 	if f$locate( answ, "FILES"   ).eq.0 then goto do_document_files
$ 	if f$locate( answ, "QUEUE"   ).eq.0 then goto do_document_show
$ 	if f$locate( answ, "KILL"    ).eq.0 then goto do_document_kill
$ 	if f$locate( answ, "OPTIONS" ).eq.0 then goto do_document_options
$!
$	ws "%DOC-I-INVALID, I don't understand ""''answ'"""
$	goto document_action_ASK
$!
$! .............................................................................
$! and call the correct menu
$!
$do_document_runoff:
$ 	if DOC$document.nes."" then goto something_to_runoff
$	   ws "%DOC-E-NODOCMT," + -
		   " there is no document defined in this directory"
$	   ws "-DOC-I-NOPRINT, nothing to runoff and print"
$	   goto document_action_ASK
$!
$something_to_runoff:
$	call MENU_STANDARD_RUNOFF
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto document_action_repeat
$!
$do_document_files:
$	DOC$previous_menu = "DOCUMENT ACTION"
$	call MENU_DOCUMENT_FILE_CHOICE
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto document_action_repeat
$! 
$do_document_show:
$	call UNSET_SCREEN
$	call SHOW_QUEUE
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto document_action_repeat
$!
$do_document_kill:
$	call UNSET_SCREEN
$	call KILL_QUEUE_ENTRY
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto document_action_repeat
$!
$do_document_options:
$	DOC$previous_menu = "DOCUMENT ACTION"
$	call MENU_OPTIONS
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto document_action_repeat
$!
$	ENDSUBROUTINE		! MENU_DOCUMENT_ACTION

$! =============================================================================
$! MENU_STANDARD_RUNOFF
$! use the standard runoff command file to runoff a document and print it
$! -----------------------------------------------------------------------------
$MENU_STANDARD_RUNOFF:   
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$! we will set up the screen ourselves
$!
$	DOC$SCREEN == TRUE	! remember we're playing with the screen
$!
$! assemble and output the header line
$!
$	line = ""
$	line[0,'DOC$WIDTH'] := "STANDARD RUNOFF"
$!
$! ESC [2J		erase screen
$! ESC [7m		display in reverse video
$! ESC [1;1H		move cursor to line 1, column 1
$!
$	ws "[2J[7m[1;1H",line	! output the whole lot
$!
$! ESC [0m		display in normal mode
$! ESC [3;r		scroll from line 3 to bottom of screen
$! ESC [2;1H		move cursor to line 2, column 1
$!
$	ws "[0m[3;r[2;1H"
$!
$! and now define what happens if the control keys are used
$!
$	CtrlZ = "return you to the DOCUMENT ACTION menu"
$	CtrlC = "return you to the TOP-LEVEL menu"
$!
$! and tell them now
$!
$	ws "<CTRL/Z> will ''CtrlZ'"
$	ws "<CTRL/C> will ''CtrlC'"
$	ws "      ?  will repeat the current question"
$	wsb
$!
$! we are thus now ready to obey the command file
$!
$	DOC$original = DOC$document
$ 	@lsl$doc_command:standard_rno_sub
$!
$	if $status then goto print_the_file
$	if $status.eq.HAD_CTRL then exit '$status'
$ 	if $status.eq.HAD_EOF  then exit '$status'
$	if DOC$PRINTER.eqs.DOC$Noprinter then goto Nowt_to_print
$	if DOC$PRINTER.eqs.DOC$Terminal  then goto Nowt_to_print
$	   call ASK "Do you still want to print it?"
$	   if .not.$status then exit '$status'
$	      if DOC$RESULT then goto print_the_file
$	      exit '$status'
$!
$print_the_file:
$	if DOC$PRINTER.eqs.DOC$Noprinter   then goto Nowt_to_print
$	if DOC$PRINTER.eqs.DOC$Terminal    then goto Nowt_to_print
$	if DOC$PRINTER.eqs.DOC$LQprinter   then goto Qume_it
$	if DOC$PRINTER.eqs.DOC$LN03printer then goto LN03_it
$	if DOC$PRINTER.eqs.DOC$Lineprinter then goto Lprint_it
$	   ws "%DOC-E-INTERNAL, internal DOCUMENT error"
$	   ws "-DOC-E-BADPRINT, unknown printer option ""''DOC$PRINTER'"""
$	   ws "-DOC-I-REPORT, please report the problem with all details"
$	   call PRESS_RETURN
$	   exit '$status'
$!
$Nowt_to_print:				! there is nothing to print, or
$	call PRESS_RETURN		! the command file already did it
$	exit '$status'
$!
$Qume_it:
$	LQP/delete  'DOC$RESULT'
$	exit '$status'
$!
$LN03_it:
$	LNPRINT/delete  'DOC$RESULT'
$	exit '$status'
$!
$Lprint_it:
$	PRINT/delete  'DOC$RESULT'
$	exit '$status'
$!
$	ENDSUBROUTINE		! MENU_STANDARD_RUNOFF

$! =============================================================================
$! MENU_DOCUMENT_FILE_CHOICE
$! choose a file from this document
$! -----------------------------------------------------------------------------
$MENU_DOCUMENT_FILE_CHOICE:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$file_choice_repeat:
$	wsb                      
$	sd  LSL$DOC_ROOT:['DOC$package'.'DOC$directory']
$!
$ 	Menu_name = "DOCUMENT FILE CHOICE"
$  	CtrlZ = "return you to the ''DOC$previous_menu' menu"
$	CtrlC = "return you to the TOP-LEVEL menu"
$!
$	call DISPLAY_FILES  "*.com,*.spec,*.hdr,*.hlp,*.rno"  TRUE
$	if .not.$status then exit '$status'
$!
$file_choice_ASK:
$	call ASK  "Choose the file you want:"
$!
$	if .not.$status then exit '$status'
$	if DOC$RESULT.eqs."?" then goto file_choice_repeat
$ 	if DOC$RESULT.eqs.""  then goto file_choice_ASK
$!                                  
$	file := 'DOC$RESULT		! upper-case the answer
$!
$	fname = f$parse(file,,,"NAME")
$	ftype = f$parse(file,".RNO",,"TYPE")	! default to a .RNO file
$!
$	file = fname+ftype
$!
$! check that it is a file we admit to knowing about
$!
$	if ftype.eqs.".RNO" .or. ftype.eqs.".COM"  .or. -
	   ftype.eqs.".HDR" .or. ftype.eqs.".SPEC" .or. -
	   ftype.eqs.".HLP" then goto file_is_ok
$	   ws "%DOC-E-UNKTYPE," + -
	      " file ""''file'"" is not a .RNO, .COM, .HDR, .HLP or .SPEC file"
$	   ws "-DOC-I-IGNORED, it should not be in this PACKAGE directory"
$	   call PRESS_RETURN
$	   if $status.eq.HAD_CTRL then exit '$status'
$	   goto file_choice_repeat
$!
$file_is_ok:
$!
$	if f$search( file ).nes."" then goto file_choice_exists
$	   ws "%DOC-E-NOFILE, there is no file called ""''file'"""
$	   call ASK  "Do you want to create it?"
$	   if .not.$status then exit '$status'
$ 	   if DOC$RESULT.eqs."?" then goto file_choice_repeat
$ 	   if DOC$RESULT.eqs.""  then goto file_choice_ASK
$	   if .not.DOC$RESULT    then goto file_choice_ASK
$	   DOC$previous_menu = "DOCUMENT FILE CHOICE"
$	   call CREATE_FILE 'file'
$	   if $status.eq.HAD_CTRL then exit '$status'
$	   goto file_choice_repeat
$!
$file_choice_exists:
$!
$! remember which file it is, and find out what to do with it
$! - if we are within a document - that is, we have a .SPEC file - then
$!   we will call MENU_DOCUMENT_FILE_ACTION
$! - otherwise, we have a normal file, so call MENU_FILE_ACTION
$!
$	DOC$previous_menu = "DOCUMENT FILE CHOICE"
$	DOC$file = file
$!
$	if DOC$document.eqs."" then goto no_document
$ 	   call  MENU_DOCUMENT_FILE_ACTION
$	   if $status.eq.HAD_CTRL then exit '$status'
$	   goto file_choice_repeat
$!
$no_document:
$ 	   call  MENU_FILE_ACTION
$	   if $status.eq.HAD_CTRL then exit '$status'
$	   goto file_choice_repeat
$!
$	ENDSUBROUTINE		! MENU_DOCUMENT_FILE_CHOICE

$! =============================================================================
$! MENU_DOCUMENT_FILE_ACTION
$! choose what to do to a file within a document directory
$! -----------------------------------------------------------------------------
$MENU_DOCUMENT_FILE_ACTION:
$	SUBROUTINE
$	set noon
$  	on control_y then exit 'HAD_CTRL'
$!
$	DOC$document = f$parse(DOC$file,,,"NAME")
$!
$file_action_repeat:
$	Menu_name  = "DOCUMENT FILE ACTION"
$	Line_count = 8
$	Line1 = "DOCUMENT - runoff and print document ''DOC$document'"
$	Line2 = "EDIT     - edit  ''DOC$file'"
$	Line3 = "RECOVER  - edit  ''DOC$file' recovering an aborted session"
$	Line4 = "PRINT    - print ''DOC$file' by itself (is that sensible?)"
$	Line5 = "SPELL    - check ''DOC$file' with the spelling checker"
$	Line6 = "QUEUE    - show what is on the print queues"
$	Line7 = "KILL     - delete an entry from a print queue"
$  	Line8 = "OPTIONS  - choose various options for how DOCUMENT works"
$!
$	CtrlZ = "return you to the DOCUMENT FILE CHOICE menu"
$	CtrlC = "return you to the TOP-LEVEL menu"
$!
$file_action_show:
$	call DISPLAY_MENU
$	if .not.$status then exit '$status'
$!
$file_action_ASK:
$	call ASK  "What do you want to do?"
$!           
$	if .not.$status then exit '$status'
$	if DOC$RESULT.eqs."?" then goto file_action_repeat
$ 	if DOC$RESULT.eqs.""  then goto file_action_ASK
$!
$	answ := 'DOC$RESULT		! upper-case the answer
$!
$   	if f$locate( answ, "DOCUMENT").eq.0 then goto do_document
$   	if f$locate( answ, "EDIT"    ).eq.0 then goto do_edit
$ 	if f$locate( answ, "RECOVER" ).eq.0 then goto do_recover
$ 	if f$locate( answ, "PRINT"   ).eq.0 then goto do_print
$ 	if f$locate( answ, "SPELL"   ).eq.0 then goto do_spell
$ 	if f$locate( answ, "QUEUE"   ).eq.0 then goto do_show
$ 	if f$locate( answ, "KILL"    ).eq.0 then goto do_kill
$ 	if f$locate( answ, "OPTIONS" ).eq.0 then goto do_options
$!
$	ws "%DOC-I-INVALID, I don't understand ""''answ'"""
$	goto file_action_ASK
$!
$! .............................................................................
$! and call the correct menu
$!
$do_document:
$	call MENU_STANDARD_RUNOFF
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto file_action_repeat
$!
$do_print:
$	call MENU_DOCUMENT_FILE_ACTION_PRINT
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto file_action_repeat
$!
$do_edit:
$	recovery = FALSE
$   	goto do_EDIT_FILE
$!      
$do_recover:
$	recovery = TRUE
$!
$do_EDIT_FILE:               
$   	call EDIT_FILE  'recovery'
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto file_action_repeat
$!
$do_spell:
$ 	call SPELL_FILE
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto file_action_repeat
$!
$do_show:
$	call UNSET_SCREEN
$	call SHOW_QUEUE
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto file_action_repeat
$!
$do_kill:
$	call UNSET_SCREEN
$	call KILL_QUEUE_ENTRY
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto file_action_repeat
$!
$do_options:
$	DOC$previous_menu = "FILE ACTION"
$	call  MENU_OPTIONS
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto file_action_repeat
$!
$	ENDSUBROUTINE		! MENU_DOCUMENT_FILE_ACTION

$! =============================================================================
$! MENU_DOCUMENT_FILE_ACTION_PRINT
$! choose how to print a single file from a document directory
$! -----------------------------------------------------------------------------
$MENU_DOCUMENT_FILE_ACTION_PRINT:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$print_repeat:
$     	Menu_name  = "DOCUMENT FILE ACTION - PRINT"
$  	Line_count = 7
$	Line1 = "PRINT   - print ''DOC$file' on the lineprinter"
$	Line2 = "LQP     - print ''DOC$file' on the Qume letter quality printer"
$	Line3 = "LN03    - print ''DOC$file' on the LN03 laser printer"
$	Line4 = "TYPE    - type  ''DOC$file' at the terminal"
$	Line5 = "QUEUE   - show what is on the print queues"
$	Line6 = "KILL    - delete an entry from a print queue"
$  	Line7 = "OPTIONS - choose various options for how DOCUMENT works"
$!
$	CtrlZ = "return you to the DOCUMENT FILE ACTION menu"
$	CtrlC = "return you to the TOP-LEVEL menu"
$!
$print_show:
$	call DISPLAY_MENU
$	if .not.$status then exit '$status'
$!
$print_ASK:
$	call ASK  "What do you want to do?"
$!
$	if .not.$status then exit '$status'
$	if DOC$RESULT.eqs."?" then goto print_repeat
$ 	if DOC$RESULT.eqs.""  then goto print_ASK
$!
$	answ := 'DOC$RESULT		! upper-case the answer
$!
$ 	if f$locate( answ, "PRINT"   ).eq.0 then goto do_print
$ 	if f$locate( answ, "LQP"     ).eq.0 then goto do_lqp
$ 	if f$locate( answ, "LN03"    ).eq.0 then goto do_ln03
$ 	if f$locate( answ, "TYPE"    ).eq.0 then goto do_type
$ 	if f$locate( answ, "QUEUE"   ).eq.0 then goto do_show
$ 	if f$locate( answ, "KILL"    ).eq.0 then goto do_kill
$ 	if f$locate( answ, "OPTIONS" ).eq.0 then goto do_options
$!
$	ws "%DOC-I-INVALID, I don't understand ""''answ'"""
$	goto print_ASK
$!
$! .............................................................................
$! and call the correct menu
$!
$do_print:
$	DOC$PRINTER = DOC$Lineprinter
$	goto do_print_file
$!
$do_lqp:
$	DOC$PRINTER = DOC$LQprinter
$	goto do_print_file
$!
$do_ln03:
$	DOC$PRINTER = DOC$LN03printer
$	goto do_print_file
$!
$do_type:
$	DOC$PRINTER = DOC$Terminal
$	goto do_print_file
$!
$do_print_file:
$	call PRINT_FILE
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto print_repeat
$!
$do_show:
$	call UNSET_SCREEN
$	call SHOW_QUEUE
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto print_repeat
$!
$do_kill:
$	call UNSET_SCREEN
$	call KILL_QUEUE_ENTRY
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto print_repeat
$!
$do_options:
$	DOC$previous_menu = "DOCUMENT FILE ACTION - PRINT"
$	call  MENU_OPTIONS
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto print_repeat
$!
$	ENDSUBROUTINE		! MENU_DOCUMENT_FILE_ACTION_PRINT

$! =============================================================================
$! MENU_FILE_ACTION
$! choose what to do to a file
$! -----------------------------------------------------------------------------
$MENU_FILE_ACTION:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$file_action_repeat:
$	Menu_name  = "FILE ACTION"
$	Line_count = 10
$	Line1 = "EDIT    - edit  ''DOC$file'"
$	Line2 = "RECOVER - edit  ''DOC$file' recovering an aborted session"
$	Line3 = "PRINT   - print ''DOC$file' on the lineprinter"
$	Line4 = "LQP     - print ''DOC$file' on the Qume letter quality printer"
$	Line5 = "LN03    - print ''DOC$file' on the LN03 laser printer"
$	Line6 = "TYPE    - type  ''DOC$file' at the terminal"
$	Line7 = "SPELL   - check ''DOC$file' with the spelling checker"
$	Line8 = "QUEUE   - show what is on the print queues"
$	Line9 = "KILL    - delete an entry from a print queue"
$  	Line10= "OPTIONS - choose various options for how DOCUMENT works"
$!
$	CtrlZ = "return you to the ''DOC$previous_menu' menu"
$	CtrlC = "return you to the TOP-LEVEL menu"
$!
$file_action_show:
$	call DISPLAY_MENU
$	if .not.$status then exit '$status'
$!
$file_action_ASK:
$	call ASK  "What do you want to do?"
$!
$	if .not.$status then exit '$status'
$	if DOC$RESULT.eqs."?" then goto file_action_repeat
$ 	if DOC$RESULT.eqs.""  then goto file_action_ASK
$!
$	answ := 'DOC$RESULT		! upper-case the answer
$!
$   	if f$locate( answ, "EDIT"    ).eq.0 then goto do_edit
$ 	if f$locate( answ, "RECOVER" ).eq.0 then goto do_recover
$ 	if f$locate( answ, "PRINT"   ).eq.0 then goto do_print
$ 	if f$locate( answ, "LQP"     ).eq.0 then goto do_lqp
$ 	if f$locate( answ, "LN03"    ).eq.0 then goto do_ln03
$ 	if f$locate( answ, "TYPE"    ).eq.0 then goto do_type
$ 	if f$locate( answ, "SPELL"   ).eq.0 then goto do_spell
$ 	if f$locate( answ, "QUEUE"   ).eq.0 then goto do_show
$ 	if f$locate( answ, "KILL"    ).eq.0 then goto do_kill
$ 	if f$locate( answ, "OPTIONS" ).eq.0 then goto do_options
$!
$	ws "%DOC-I-INVALID, I don't understand ""''answ'"""
$	goto file_action_ASK
$!
$! .............................................................................
$! and call the correct menu
$!
$do_print:
$	DOC$PRINTER = DOC$Lineprinter
$	goto do_print_file
$!
$do_lqp:
$	DOC$PRINTER = DOC$LQprinter
$	goto do_print_file
$!
$do_ln03:
$	DOC$PRINTER = DOC$LN03printer
$	goto do_print_file
$!
$do_type:
$	DOC$PRINTER = DOC$Terminal
$	goto do_print_file
$!
$do_print_file:
$	call PRINT_FILE
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto file_action_repeat
$!
$do_edit:
$	recovery = FALSE
$   	goto do_EDIT_FILE
$!      
$do_recover:
$	recovery = TRUE
$!
$do_EDIT_FILE:               
$   	call EDIT_FILE  'recovery'
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto file_action_repeat
$!
$do_spell:
$ 	call SPELL_FILE
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto file_action_repeat
$!
$do_show:
$	call UNSET_SCREEN
$	call SHOW_QUEUE
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto file_action_repeat
$!
$do_kill:
$	call UNSET_SCREEN
$	call KILL_QUEUE_ENTRY
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto file_action_repeat
$!
$do_options:
$	DOC$previous_menu = "FILE ACTION"
$	call  MENU_OPTIONS
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto file_action_repeat
$!
$	ENDSUBROUTINE		! MENU_FILE_ACTION

$! =============================================================================
$! MENU_DOC
$!!!! start off work in LSL$DOCDISK:[DOC]
$! start off work in LSL$DOC_ROOT:[DOC]
$! -----------------------------------------------------------------------------
$MENU_DOC:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!      
$doc_repeat:
$	wsb
$   	sd LSL$DOC_ROOT:[DOC]
$!
$  	Menu_name = "DOC"
$	CtrlZ = "return you to the TOP-LEVEL menu"
$	CtrlC = "return you to the TOP-LEVEL menu"
$!
$doc_show:
$	call DISPLAY_FILES  "*.DIR"  FALSE
$	if .not.$status then exit '$status'
$!
$doc_ASK:
$	call ASK  "Choose the directory you want:"
$!
$	if .not.$status then exit '$status'
$	if DOC$RESULT.eqs."?" then goto doc_repeat
$ 	if DOC$RESULT.eqs.""  then goto doc_ASK
$!
$	file := 'DOC$RESULT		! upper-case the answer
$!
$	fname = f$parse(file,,,"NAME")
$!
$	if f$search( fname+".DIR" ).nes."" then goto directory_exists
$	   ws "%DOC-E-NODIR, there is no directory called ""''fname'"""
$	   call ASK  "Do you want to create it?"
$	   if .not.$status then exit '$status'
$ 	   if DOC$RESULT.eqs."?" then goto doc_repeat
$ 	   if DOC$RESULT.eqs.""  then goto doc_ASK
$	   if .not.DOC$RESULT    then goto doc_ASK
$	   call CREATE_DIRECTORY 'fname'
$	   if $status.eq.HAD_CTRL then exit '$status'
$	   goto doc_repeat
$!
$directory_exists:
$	DOC$directory = fname
$	DOC$previous_menu = "DOC"
$!
$	call  MENU_DIRECTORY
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto doc_repeat
$!
$	ENDSUBROUTINE		! MENU_DOC

$! =============================================================================
$! MENU_DIRECTORY
$! choose a file or directory from this directory
$! -----------------------------------------------------------------------------
$MENU_DIRECTORY:
$	SUBROUTINE                          
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$	wsb                    
$ 	sd  .'DOC$directory'
$	local_directory = f$trnlnm("HERE")
$!
$directory_repeat:
$!
$! work out if there are any .DIR files, and any .RNO files
$!
$	got_dir_files = f$search( "*.DIR" ).nes.""
$	got_rno_files = f$search( "*.RNO" ).nes.""
$!
$	got_both    = got_dir_files.and.got_rno_files
$	got_neither = .not.(got_dir_files.or.got_rno_files)
$!
$! we can thus work out what our question will be
$!
$	question = "Choose the "
$	if got_dir_files                then question = question + "directory "
$	if got_both                     then question = question + "or "
$	if got_rno_files.or.got_neither then question = question + "file "
$	question = question + "you want:"
$!
$ 	Menu_name = "DIRECTORY"
$	CtrlZ = "return you to the ''DOC$previous_menu' menu"
$	CtrlC = "return you to the TOP-LEVEL menu"
$!
$directory_show:
$	call DISPLAY_FILES  "*.dir,*.com,*.rno"  TRUE
$	if .not.$status then exit '$status'
$!
$directory_ASK:
$	call ASK  "''question'"
$!
$	if .not.$status then exit '$status'
$	if DOC$RESULT.eqs."?" then goto directory_repeat
$ 	if DOC$RESULT.eqs.""  then goto directory_ASK
$!                                  
$	file := 'DOC$RESULT		! upper-case the answer
$!
$	fname = f$parse(file,,,"NAME")
$!
$! the file type will default to .DIR if we have directories, and otherwise
$! it will default to .RNO
$!
$	if      got_dir_files then ftype = f$parse(file,".DIR",,"TYPE")
$	if .not.got_dir_files then ftype = f$parse(file,".RNO",,"TYPE")
$!
$	file = fname+ftype
$!
$	if f$search( file ).nes."" then goto directory_exists
$	   if ftype.eqs.".DIR" then ws -
			"%DOC-E-NODIR, there is no directory called ""''file'"""
$	   if ftype.nes.".DIR" then ws -
			"%DOC-E-NOFILE, there is no file called ""''file'"""
$	   call ASK  "Do you want to create it?"
$	   if .not.$status then exit '$status'
$ 	   if DOC$RESULT.eqs."?" then goto directory_repeat
$ 	   if DOC$RESULT.eqs.""  then goto directory_ASK
$	   if .not.DOC$RESULT    then goto directory_ASK
$	   if ftype.nes.".DIR" then goto dont_create_DIR
$	      call CREATE_DIRECTORY 'fname'
$	      if $status.eq.HAD_CTRL then exit '$status'
$	      goto directory_repeat
$dont_create_DIR:
$	   DOC$previous_menu = "DIRECTORY"
$	   call CREATE_FILE 'file'
$	   if $status.eq.HAD_CTRL then exit '$status'
$	   goto directory_repeat
$!
$! work out what to do now
$! - if it was a .DIR file, then we want to process it as such
$! - if it was a .COM file, then we must work on that file
$! - if it was a .RNO file, then we must work on that file
$!
$directory_exists:
$	if ftype.eqs.".DIR" then goto do_menu_directory
$	if ftype.eqs.".COM" then goto do_menu_document_file
$	if ftype.eqs.".RNO" then goto do_menu_document_file
$	   ws "%DOC-E-UNKTYPE," -
	      " file ""''file'"" is not a directory or a .RNO file"
$	   ws "-DOC-I-IGNORED, it should not be in this directory"
$	   call PRESS_RETURN
$	   if $status.eq.HAD_CTRL then exit '$status'
$	   goto directory_repeat
$!            
$! .............................................................................
$do_menu_directory:
$!
$	DOC$directory     = fname
$	DOC$previous_menu = "previous DIRECTORY"
$!
$	call  MENU_DIRECTORY
$	if $status.eq.HAD_CTRL then exit '$status'
$	wsb
$	sd 'local_directory'
$	goto directory_repeat
$!
$! .............................................................................
$do_menu_document_file:
$!
$ 	DOC$file = file
$	DOC$previous_menu = "DIRECTORY"
$!
$ 	call  MENU_FILE_ACTION
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto directory_repeat
$!
$	ENDSUBROUTINE		! MENU_DIRECTORY

$! =============================================================================
$! MENU_OPTIONS
$! change some facet of DOCUMENT's behaviour
$! -----------------------------------------------------------------------------
$MENU_OPTIONS:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$options_repeat:
$  	Menu_name  = "OPTIONS"
$	Line_count = 7
$	Line1 = "MENUS   - display menus"
$	Line2 = "NOMENUS - don't display menus"
$	Line3 = "SMOOTH  - smooth scroll when TYPEing documents"
$	Line4 = "JUMP    - jump (normal) scroll when TYPEing documents"
$ 	Line5 = "WIDTH   - change screen width"
$	Line6 = "EDITOR  - change the editor used to edit files"
$	Line7 = "DEFAULT - put all options back to the normal values"
$!
$  	CtrlZ = "return you to the ''DOC$previous_menu' menu"
$	CtrlC = "return you to the TOP-LEVEL menu"
$!
$options_show:
$	call DISPLAY_MENU
$	if .not.$status then exit '$status'
$!
$options_ASK:
$	call ASK  "Choose the option you want:"
$!
$	if .not.$status then exit '$status'
$	if DOC$RESULT.eqs."?" then goto options_repeat
$ 	if DOC$RESULT.eqs.""  then goto options_ASK
$!
$	answ := 'DOC$RESULT		! upper-case the answer
$!
$ 	if f$locate( answ, "MENUS"   ).eq.0 then goto do_menus
$ 	if f$locate( answ, "NOMENUS" ).eq.0 then goto do_nomenus
$ 	if f$locate( answ, "SMOOTH"  ).eq.0 then goto do_smooth
$ 	if f$locate( answ, "JUMP"    ).eq.0 then goto do_jump
$ 	if f$locate( answ, "WIDTH"   ).eq.0 then goto do_width 
$ 	if f$locate( answ, "EDITOR"  ).eq.0 then goto do_editor
$ 	if f$locate( answ, "DEFAULT" ).eq.0 then goto do_default
$!
$	ws "%DOC-I-INVALID, I don't understand ""''answ'"""
$	goto options_ASK
$!
$! .............................................................................
$! and call the correct menu
$!
$do_menus:
$	DOC$NO_MENUS == FALSE
$	exit 'SUCCESS'
$!
$do_nomenus:
$	DOC$NO_MENUS == TRUE
$	ws "%DOC-I-NOMENUS, menus will now be suppressed"
$	ws "-DOC-I-QMARK, use the ""?"" command to show a menu"
$	call PRESS_RETURN
$	exit '$status'
$!
$do_smooth:
$	if .not.DOC$is_ansi then goto not_ansi_terminal
$	DOC$SMOOTH == TRUE
$	exit 'SUCCESS'
$!
$do_jump:
$	if .not.DOC$is_ansi then goto not_ansi_terminal
$	DOC$SMOOTH == FALSE
$	exit 'SUCCESS'
$!
$do_width:
$	if .not.DOC$is_ansi then goto not_ansi_terminal
$	call ASK  "What width (normal choices are 80 or 132)?"
$!
$	if .not.$status then exit '$status'
$	if DOC$RESULT.eqs."?" then goto options_repeat
$ 	if DOC$RESULT.eqs.""  then goto options_ASK
$!
$	if f$type(DOC$RESULT).eqs."INTEGER" then goto set_width
$	   ws "%DOC-E-NOTINT, reply must be an integer"
$	   goto options_repeat
$!
$set_width:
$	DOC$WIDTH == DOC$RESULT
$	set terminal/width='DOC$WIDTH'
$	exit '$status'
$!
$do_editor:
$	ws "Current editor command is ""''DOC$EDITOR'"""
$	call ASK  "What editor command do you want?"
$	if .not.$status then exit '$status'
$!
$	if DOC$RESULT.eqs."?" then goto options_repeat
$ 	if DOC$RESULT.eqs.""  then goto options_ASK
$!
$	DOC$EDITOR == f$edit( DOC$RESULT, "COLLAPSE,UPCASE,UNCOMMENT" )
$!
$	ws "The new editor command is thus ""''DOC$EDITOR'"" - caveat emptor"
$	call PRESS_RETURN
$	exit '$status'
$!
$do_default:
$	DOC$NO_MENUS == FALSE
$	DOC$EDITOR   == default_editor
$	if DOC$is_ansi then DOC$SMOOTH == TRUE
$	set terminal/width = 80
$	exit '$status'
$!
$not_ansi_terminal:
$	ws "%DOC-I-NOTAVAIL, that command is not available for this terminal"
$	ws "-DOC-I-CANTDO, as it is not able to do it..."
$	call PRESS_RETURN
$	exit '$status'
$!
$	ENDSUBROUTINE		! MENU_OPTIONS

$! =============================================================================
$! CREATE_DIRECTORY
$! create a new directory
$!
$!	P1	the name of the directory
$! -----------------------------------------------------------------------------
$CREATE_DIRECTORY:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$	create/dir/log  [.'P1']
$!
$	exit 'SUCCESS'
$	ENDSUBROUTINE		! CREATE_DIRECTORY

$! =============================================================================
$! CREATE_FILE
$! create a new file
$!
$!	P1	the file-spec of the new file
$! -----------------------------------------------------------------------------
$CREATE_FILE:
$	SUBROUTINE
$	on error     then exit 'FAILURE'
$	on control_y then exit 'HAD_CTRL'
$!
$! extract the name part for later use
$!
$	fname = f$parse(P1,,,"NAME")
$!
$! if it is not a .RNO file, then we can just create it
$!
$	if f$parse(P1,,,"TYPE").eqs.".RNO" then goto create_file_repeat
$!
$	   ws "Creating file ""''P1'"""
$ 	   create  'P1'				! create an empty file
$	   exit '$status'			! and that's it
$!
$create_file_repeat:
$	Menu_name  = "CREATE FILE ""''fname'"""
$	Line_count = 12
$	Line1  = "EMPTY     - create an empty file"
$	Line2  = "MEMO      - create a memorandum"
$	Line3  = "REPORT    - create a report"
$	Line4  = "VISIT     - create a customer-site visit report"
$	Line5  = "CHAPTER   - create a new chapter"
$	Line6  = "TRAINING  - create a training document"
$	Line7  = "ACCEPT    - create an acceptance schedule"
$	Line8  = "TECHNICAL - create a technical reference document"
$	Line9  = "GUIDE     - create a user guide          (for a PACKAGE)"
$	Line10  = "REFERENCE - create a reference manual    (for a PACKAGE)"
$	Line11 = "SPS       - create a sales specification (for a PACKAGE)"
$	Line12 = "OTHER     - create something else"
$  	Line13 = "OPTIONS   - choose various options for how DOCUMENT works"
$!
$	CtrlZ = "return you to the ''DOC$previous_menu' menu"
$	CtrlC = "return you to the TOP-LEVEL menu"
$!
$create_file_show:
$	call DISPLAY_MENU
$	if .not.$status then exit '$status'
$!
$create_file_ASK:
$	call ASK  "What sort of file do you want to create?"
$!
$	if .not.$status then exit '$status'
$	if DOC$RESULT.eqs."?" then goto create_file_repeat
$ 	if DOC$RESULT.eqs.""  then goto create_file_ASK
$!
$	answ := 'DOC$RESULT		! upper-case the answer
$!
$ 	if f$locate( answ, "EMPTY"     ).eq.0 then goto do_empty
$ 	if f$locate( answ, "MEMO"      ).eq.0 then goto do_memo
$ 	if f$locate( answ, "REPORT"    ).eq.0 then goto do_report
$	if f$locate( answ, "VISIT"     ).eq.0 then goto do_visit
$ 	if f$locate( answ, "CHAPTER"   ).eq.0 then goto do_chapter
$ 	if f$locate( answ, "TRAINING"  ).eq.0 then goto do_training
$ 	if f$locate( answ, "ACCEPT"    ).eq.0 then goto do_accept
$ 	if f$locate( answ, "TECHNICAL" ).eq.0 then goto do_technical
$ 	if f$locate( answ, "GUIDE"     ).eq.0 then goto do_guide
$ 	if f$locate( answ, "REFERENCE" ).eq.0 then goto do_reference
$ 	if f$locate( answ, "SPS"       ).eq.0 then goto do_sps
$ 	if f$locate( answ, "OTHER"     ).eq.0 then goto do_other
$ 	if f$locate( answ, "OPTIONS"   ).eq.0 then goto do_options
$!
$	ws "%DOC-I-INVALID, I don't understand ""''answ'"""
$	goto create_file_ASK
$!
$! .............................................................................
$! and create the required file
$!
$do_empty:
$	ws "Creating empty file ""''fname'.RNO"""
$	create 'fname'.RNO
$	goto end_doing_things
$!
$do_memo:
$	ws "Creating memorandum ""''fname'.RNO"""
$	copy  LSL$DOC_TEMPLATE:TEMPLATE.MEMO  'fname'.RNO
$	goto end_doing_things
$!
$do_report:
$	ws "Creating report ""''fname'.RNO"""
$	copy  LSL$DOC_TEMPLATE:TEMPLATE.REPORT  'fname'.RNO
$	goto end_doing_things
$!
$do_visit:
$	ws "Creating site visit report ""''fname'.RNO"""
$	copy  LSL$DOC_TEMPLATE:TEMPLATE.VISIT  'fname'.RNO
$	goto end_doing_things
$!
$! if the chapter is for a PACKAGE document, then we do not need a
$! .CHAPTER command, etc - so effectively we are doing OTHER
$!
$do_chapter:
$	call ASK "Is it a STANDARD PACKAGE chapter?"
$	if .not.$status then exit '$status'
$	if DOC$RESULT then goto do_other
$	   ws "Creating .CHAPTER file ""''fname'.RNO"""
$	   copy  LSL$DOC_TEMPLATE:TEMPLATE.CHAPTER  'fname'.RNO
$	   goto end_doing_things
$!
$do_training:
$	ws "Creating training document ""''fname'.RNO"""
$	copy  LSL$DOC_TEMPLATE:TEMPLATE.TRAINING  'fname'.RNO
$	goto end_doing_things
$!
$do_accept:
$	ws "Creating accpetance schedule ""''fname'.RNO"""
$	copy  LSL$DOC_TEMPLATE:TEMPLATE.ACCEPT  'fname'.RNO
$	goto end_doing_things
$!
$do_technical:
$	ws "Creating technical reference ""''fname'.RNO"""
$	copy  LSL$DOC_TEMPLATE:TEMPLATE.TECHNICAL  'fname'.RNO
$	goto end_doing_things
$!
$do_guide:
$	ws "Creating: ''fname'.SPEC,"
$	ws "          PREFACE.RNO, CHANGES.RNO, INTRODUCTION.RNO"
$	copy  LSL$DOC_TEMPLATE:PACKAGE.SPEC      'fname'.SPEC
$	copy  LSL$DOC_TEMPLATE:PREFACE.RNO,CHANGES,INTRODUCTION  HERE:
$	goto end_doing_things
$!
$do_reference:
$	ws "Creating: ''fname'.SPEC,"
$	ws "          PREFACE.RNO, CHANGES.RNO, INTRODUCTION.RNO"
$	copy  LSL$DOC_TEMPLATE:PACKAGE.SPEC     'fname'.SPEC
$	copy  LSL$DOC_TEMPLATE:PREFACE.RNO,CHANGES,INTRODUCTION  HERE:
$	goto end_doing_things
$!
$do_sps:
$	ws "Creating: ''fname'.RNO"
$	copy  LSL$DOC_TEMPLATE:SPS.RNO         'fname'.RNO
$	goto end_doing_things
$!
$do_other:
$	ws "Creating standard template file ""''fname'.RNO"""
$	copy  LSL$DOC_TEMPLATE:TEMPLATE.OTHER  'fname'.RNO
$	goto end_doing_things
$!
$end_doing_things:
$	call PRESS_RETURN
$	exit '$status'
$!
$do_options:
$	DOC$previous_menu = "CREATE FILE"
$	call  MENU_OPTIONS
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto create_file_repeat
$!
$	ENDSUBROUTINE		! CREATE_FILE

$! =============================================================================
$! EDIT_FILE
$! edit a file using the current editor
$!
$!	P1	TRUE if we are to edit with recovery
$! -----------------------------------------------------------------------------
$EDIT_FILE:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$	recover = ""
$	if P1 then recover = "/RECOVER"
$!
$ 	define/user  SYS$INPUT  'f$trnlnm("TT")
$	'DOC$EDITOR''recover'  'DOC$file'
$!
$	purge/log/keep=2  'DOC$file'
$!
$	exit 'SUCCESS'
$	ENDSUBROUTINE		! EDIT_FILE

$! =============================================================================
$! PRINT_FILE
$! print a file, using runoff if needs be
$! -----------------------------------------------------------------------------
$PRINT_FILE:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$! what we do depends upon what the file is
$! - if it is not a .RNO file, then we can print it at once
$! - if it is a .RNO file, then we must first run it off
$!
$	outfile = DOC$file		! by default
$!
$ 	if f$parse( DOC$file,,,"TYPE" ).eqs.".RNO" then goto run_it_off
$!
$! so we can print it now - work out what to do
$!
$	if DOC$PRINTER.eqs.DOC$Noprinter   then goto Nowt_to_print
$ 	if DOC$PRINTER.eqs.DOC$Terminal    then goto Type_simple
$	if DOC$PRINTER.eqs.DOC$LQprinter   then goto Qume_simple
$	if DOC$PRINTER.eqs.DOC$Lineprinter then goto Lprint_simple
$ 	if DOC$PRINTER.eqs.DOC$LN03printer then goto LN03_simple
$	goto print_error
$!
$! .............................................................................
$! so we must run the file off before we can print it
$! - note that the command procedure we use wants the file NAME in DOC$file
$! - note that if DOC$PRINTER is DOC$Terminal (ie RUNOFF/OUT=TT:) then we
$!   do not want to print the .MEM file, as we will not have generated one
$!
$run_it_off:
$!
$	DOC$file = f$parse( DOC$file,,,"NAME" )
$ 	DOC$qualifiers = ""
$!
$	if DOC$PRINTER.eqs.DOC$Terminal then call UNSET_SCREEN
$!
$	DOC$original = DOC$file
$	@lsl$doc_command:docrno_sub
$!
$	if $status then goto print_the_mem_file
$	if $status.eq.HAD_CTRL then exit '$status'
$	if DOC$PRINTER.eqs.DOC$Noprinter then goto Nowt_to_print
$	if DOC$PRINTER.eqs.DOC$Terminal  then goto Nowt_to_print
$	   outfile = DOC$RESULT
$	   call ASK "Do you still want to print it?"
$	   if .not.$status then exit '$status'
$	      if DOC$RESULT then goto really_print_the_mem_file
$	      exit '$status'
$!
$! .............................................................................
$print_the_mem_file:
$	outfile = DOC$RESULT
$!
$really_print_the_mem_file:
$	if DOC$PRINTER.eqs.DOC$Noprinter   then goto Nowt_to_print
$	if DOC$PRINTER.eqs.DOC$Terminal    then goto Nowt_to_print
$	if DOC$PRINTER.eqs.DOC$LQprinter   then goto Qume_MEM
$	if DOC$PRINTER.eqs.DOC$Lineprinter then goto Lprint_MEM
$ 	if DOC$PRINTER.eqs.DOC$LN03printer then goto LN03_MEM
$!
$print_error:
$	   ws "%DOC-E-INTERNAL, internal DOCUMENT error"
$	   ws "-DOC-E-BADPRINT, unknown printer option ""''DOC$PRINTER'"""
$	   ws "-DOC-I-REPORT, please report the problem with all details"
$	   call PRESS_RETURN
$	   exit '$status'
$!
$Nowt_to_print:				! there is nothing to print, or
$	call PRESS_RETURN		! the command file already did it
$	exit '$status'
$!
$! .............................................................................
$Type_simple:
$	call UNSET_SCREEN
$	on control_y then continue
$	   ws "<CTRL/C> will abort the typing"
$	   wsb
$	   on control_y then goto end_of_type_simple
$!
$	   type 'outfile'
$!
$end_of_type_simple:
$	   on control_y then continue
$	      wsb
$	      ws "<CTRL/C> will return you to the TOP-LEVEL menu"
$	on control_y then exit 'HAD_CTRL'
$	call PRESS_RETURN
$	exit '$status'
$!
$! .............................................................................
$Qume_simple:
$	LQP  'outfile'
$	exit '$status'
$!
$Qume_MEM:
$	LQP/delete  'outfile'
$	exit '$status'
$!
$! .............................................................................
$Lprint_simple:
$	PRINT  'outfile'
$	exit '$status'
$!
$Lprint_MEM:
$	PRINT/delete  'outfile'
$	exit '$status'
$!
$! .............................................................................
$LN03_simple:
$	LNPRINT 'outfile'
$	exit '$status'
$!
$LN03_MEM:
$	LNPRINT/delete 'outfile'
$	exit '$status'
$!
$	ENDSUBROUTINE		! PRINT_FILE

$! =============================================================================
$! SPELL_FILE
$! check the spelling in a file
$! -----------------------------------------------------------------------------
$SPELL_FILE:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$	if DOC$SPELLED then goto no_need_to_init
$	   spellini Q
$	   DOC$SPELLED == TRUE
$!
$no_need_to_init:
$!
$	define/user	sys$input	sys$command:
$	spell  'DOC$file'
$	call PRESS_RETURN
$!
$	exit 'SUCCESS'
$	ENDSUBROUTINE		! SPELL_FILE

$! =============================================================================
$! SHOW_QUEUE
$! show the line printer queues
$! -----------------------------------------------------------------------------
$SHOW_QUEUE:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$	show queue/device/all
$	call PRESS_RETURN
$	exit '$status'
$!
$	ENDSUBROUTINE		! SHOW_QUEUE

$! =============================================================================
$! KILL_QUEUE_ENTRY
$! delete a print job
$! -----------------------------------------------------------------------------
$KILL_QUEUE_ENTRY:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$! find out which print queue the job is in
$!
$	ws "Print queues used by DOCUMENT are: " + -
	   "FAST_PRINT, LN03_PRINT, QUME_PRINT"
$!
$	call ASK "Which queue is the print job on?"
$	if .not.$status       then exit '$status'
$	if DOC$RESULT.eqs.""  then exit 'FAILURE'
$	if DOC$RESULT.eqs."?" then exit 'FAILURE'
$!
$	print_queue := 'DOC$RESULT
$   	if f$locate( print_queue, "FAST_PRINT" ).eq.0 then goto is_fast
$   	if f$locate( print_queue, "LN03_PRINT" ).eq.0 then goto is_ln03
$   	if f$locate( print_queue, "QUME_PRINT" ).eq.0 then goto is_qume
$	   ws "%DOC-E-PRINTQUEUE," + -
	      " I don't know a print queue called ""''print_queue'"""
$	   exit 'FAILURE'
$!
$! .............................................................................
$is_fast:
$	print_queue = "FAST_PRINT"
$	goto ask_entry
$!
$is_qume:
$	print_queue = "QUME_PRINT"
$	goto ask_entry
$is_ln03:
$	print_queue = "LN03_PRINT"
$	goto ask_entry
$!
$! .............................................................................
$! and show the contents of the queue
$!
$ask_entry:
$ 	show queue/device 'print_queue'
$	if .not.$status then exit '$status'
$!
$! now find out which entry it is
$!
$	call ASK "What is the entry number of the job to be deleted?"
$	if .not.$status       then exit '$status'
$ 	if DOC$RESULT.eqs.""  then exit 'FAILURE'
$	if DOC$RESULT.eqs."?" then exit 'FAILURE'
$!
$	entry_number = DOC$RESULT
$!
$! check that that is correct
$!
$	call ASK "Kill entry number ''entry_number' on queue ''print_queue'?"
$	if .not.$status       then exit '$status'
$	if DOC$RESULT.eqs."?" then exit 'FAILURE'
$ 	if DOC$RESULT.eqs.""  then exit 'SUCCESS'	! treat as NO
$	if .not.DOC$RESULT    then exit 'SUCCESS'	! it was a NO
$!
$	delete/entry='entry_number'  'print_queue'
$	if .not.$status then call PRESS_RETURN
$	exit '$status'
$!
$	ENDSUBROUTINE		! KILL_QUEUE_ENTRY

$! =============================================================================
$! DISPLAY_MENU
$! display the current menu, in standard form
$! -----------------------------------------------------------------------------
$DISPLAY_MENU:
$	SUBROUTINE
$	set noon
$  	on control_y then exit 'HAD_CTRL'
$!
$	DOC$SCREEN == TRUE	! remember we're playing with the screen
$!
$! assemble and output the header line
$!
$	line = ""
$	line[0,'DOC$WIDTH'] := "''Menu_name' menu"
$!
$! ESC [?4l		ensure that we are in JUMP scroll mode
$! ESC [2J		erase screen
$! ESC [7m		display in reverse video
$! ESC [1;1H		move cursor to line 1, column 1
$!
$	if      DOC$is_ansi then ws "[?4l[2J[7m[1;1H",line
$	if .not.DOC$is_ansi then ws line
$!
$! ESC [0m		display in normal mode
$! ESC [3;r		scroll from line 3 to bottom of screen
$! ESC [2;1H		move cursor to line 2, column 1
$!
$	if      DOC$is_ansi then ws "[0m[3;r[2;1H"
$	if .not.DOC$is_ansi then wsb
$!
$! if menus are suppressed, and the user did not just reply to ASK with
$! a question mark, then that is all the text that we want to output
$!
$	if DOC$NO_MENUS.and.DOC$RESULT.nes."?" then exit 'SUCCESS'
$!
$! otherwise loop outputting the lines of menu text
$!
$	count = 1
$!
$next_line:
$	ws "	",Line'count
$	count = count+1
$	if count.le.Line_count then goto next_line
$!
$! that leaves us with some space at the bottom - write out our standard
$! messages about control characters, etc
$!
$	wsb
$	ws "<CTRL/C> will ''CtrlC'"
$	ws "<CTRL/Z> will ''CtrlZ'"
$	ws "      ?  will display the current menu again"
$!
$! work out how many lines that took
$!
$ 	number_of_lines = 2 + Line_count + 5
$	scroll = number_of_lines + 1
$!
$! ESC ['n';r		scroll from line 'n' to bottom of screen
$! ESC ['n';1H		move to line 'n', column 1
$!
$	if      DOC$is_ansi then ws "[''scroll';r[''number_of_lines';1H"
$	if .not.DOC$is_ansi then wsb
$!
$	exit
$	ENDSUBROUTINE		! DISPLAY_MENU

$! =============================================================================
$! DISPLAY_FILES
$! display the files in the current directory
$!
$!	P1	list of files to show
$!		eg "*.DIR,*.RNO" or "*.SPEC,*.HDR,*.HLP,*.RNO"
$!		(note that .RNO should always be last in any list)
$!
$!	P2	TRUE if to show the file type, as well as the name
$!
$! -----------------------------------------------------------------------------
$DISPLAY_FILES:
$	SUBROUTINE
$	set noon
$  	on control_y then exit 'HAD_CTRL'
$!
$	DOC$SCREEN == TRUE	! remember we're playing with the screen
$!
$	list = f$edit( P1, "UPCASE,COLLAPSE" )
$!
$! assemble and output the header line
$!
$	line = ""
$	directory = f$trnlnm("HERE")
$	line[0,'DOC$WIDTH'] := "''Menu_name' menu for directory ''directory'"
$!
$! the window for our directory listing is lines 2 to line 20
$! - define the lower bound
$!
$	window_bottom = 21
$!
$! ESC [?4l		ensure that we are in JUMP scroll mode
$! ESC [2J		erase screen
$! ESC [7m		display in reverse video
$! ESC [1;1H		move cursor to line 1, column 1
$!
$	if      DOC$is_ansi then ws "[?4l[2J[7m[1;1H",line
$	if .not.DOC$is_ansi then ws line
$!
$! ESC [0m			display in normal mode
$! ESC [3;''window_bottom'r	scroll from line 3 to line 21
$! ESC [2;1H		  	move cursor to line 2, column 1
$!
$	if      DOC$is_ansi then ws "[0m[3;''window_bottom'r[2;1H"
$	if .not.DOC$is_ansi then wsb
$!
$! if menus are suppressed, and the user did not just reply to ASK with
$! a question mark, then that is all the text that we want to output
$!
$	if DOC$NO_MENUS.and.DOC$RESULT.nes."?" then exit 'SUCCESS'
$!
$! otherwise loop outputting the lines of directory text
$! - each filename is output in a field which is a multiple of 'chunk'
$!   characters, and each is followed by at least one space
$!
$! (note that the "round it up to a chunk" line:
$!
$!	   size = ((flen+chunk)/chunk) *chunk	! round it up to a chunk
$!
$!  is a compressed form of:
$!
$!	   pad    = 1		! at least one space between file names
$!	   round  = chunk-1	! round the file name length up to a chunk
$!	   chunks = (flen+round+pad)/chunk	! number of chunks needed
$!	   size   = chunks * chunk		! thus number of characters
$!                                
$!  since we know that "pad+round = chunk")
$!
$	if      P2 then chunk = 20	! the line allocation size
$	if .not.P2 then chunk = 15
$!
$	comma  = ","			! the separator for file-specs
$	which  = 0			! count the file-specs we've seached
$	lcount = 0	       		! count the lines we've output
$	fcount = 0	       		! count the files we've output
$	char   = 0			! and the characters in this line
$	line[0,'DOC$WIDTH'] := " "	! start with it empty
$!
$! the file-specs to search on are a comma separated list - search
$! for each one in turn
$!
$	lookfor = f$element(which,comma,list)
$	which   = which +1
$  	on control_y then goto interrupt
$!
$next_file:
$	filespec = f$search(lookfor)		! find the next file
$ 	if filespec.eqs."" then goto no_more_files
$	   file = f$parse(filespec,,,"NAME")	! the file's name
$!                           
$ 	   if P2 then file = file + f$parse(filespec,,,"TYPE")
$!
$	   flen = f$length(file)		! work out its length
$	   size = ((flen+chunk)/chunk) *chunk	! round it up to a chunk
$ 	   if size+char.le.DOC$WIDTH then goto add_file
$!
$	      ws line				! write the full line
$	      lcount = lcount+1			! count it
$	      line[0,'DOC$WIDTH'] := " "	! empty the line
$	      char   = 0			! so no chars in it yet
$!
$add_file: line[char,flen] := 'file		! add the file to the line
$	   char   = char + size			! and count its characters
$	   fcount = fcount + 1			! and count it
$	   goto next_file			! get the next file
$!
$interrupt:
$  	on control_y then exit 'HAD_CTRL'
$	ws " "
$!
$no_more_files:
$	lookfor = f$element(which,comma,list)
$	if lookfor.eqs.comma then goto end_of_directory
$	   which = which+1
$	   if lookfor.nes."*.RNO" .and. lookfor.nes.".RNO" then goto next_file
$	   if fcount.eq.0 then goto next_file
$!
$	      ws line
$	      lcount = lcount+1
$	      line[0,'DOC$WIDTH'] := " "
$	      char   = 0
$	      goto next_file
$!
$end_of_directory:
$	if char.eq.0 then goto no_more_lines
$ 	   ws line				! output the last line
$	   lcount = lcount+1			! and count it
$!
$no_more_lines:
$	if fcount.gt.0 then goto detail_others
$	   ws "%DOC-I-EMPTY, no files found"
$	   lcount = lcount+1
$!
$! that leaves us with some space at the bottom - write out our standard
$! messages about control characters, etc
$!
$detail_others:
$	wsb
$	ws "<CTRL/C> will ''CtrlC'"
$	ws "<CTRL/Z> will ''CtrlZ'"
$	ws "      ?  will display the list of files again"
$!
$! work out how many lines that took
$!
$ 	number_of_lines = 2 + lcount + 5
$!
$	if   number_of_lines.gt.window_bottom -
	then number_of_lines =  window_bottom
$!
$	scroll = number_of_lines + 1
$!
$! ESC ['n';r		scroll from line 'n' to bottom of screen
$! ESC ['n';1H		move to line 'n', column 1
$!
$	if      DOC$is_ansi then ws "[''scroll';r[''number_of_lines';1H"
$	if .not.DOC$is_ansi then wsb
$!
$	exit
$	ENDSUBROUTINE		! DISPLAY_FILES

$! =============================================================================
$! UNSET_SCREEN
$! remove our constraints from the screen
$! -----------------------------------------------------------------------------
$UNSET_SCREEN:
$	SUBROUTINE
$	set noon
$	on control_y then continue
$!
$! ESC [1;r		scroll from line 1 to the bottom of the screen
$! ESC [0m		display in normal mode
$! ESC [24;1H		move cursor to line 24, column 1
$!
$	if DOC$is_ansi then ws "[1;r[0m[24;1H"
$!
$	DOC$SCREEN == FALSE	! note that we've undone this
$!
$	exit
$	ENDSUBROUTINE		! UNSET_SCREEN

$! =============================================================================
$! PRESS_RETURN
$! wait for the user to press RETURN
$! -----------------------------------------------------------------------------
$PRESS_RETURN:
$	SUBROUTINE
$	set noon
$  	on control_y then exit 'HAD_CTRL'
$!
$! ESC [7m		display in reverse video
$! ESC [0m		display in normal mode
$!
$	if      DOC$is_ansi then prompt = "[7mPress <CR> to continue: [0m"
$	if .not.DOC$is_ansi then prompt =      "Press <CR> to continue: "
$!
$	read/end=exit_ok/error=exit_ok -
	    /prompt="''prompt'"  sys$command  answ
$!
$exit_ok:
$	exit 'SUCCESS'
$	ENDSUBROUTINE		! PRESS_RETURN

$! =============================================================================
$! DUMMY_ROUTINE
$! a routine that does nothing
$! -----------------------------------------------------------------------------
$DUMMY_ROUTINE:
$	SUBROUTINE
$	set noon
$  	on control_y then exit 'HAD_CTRL'
$	exit 'SUCCESS'
$	ENDSUBROUTINE		! DUMMY_ROUTINE
