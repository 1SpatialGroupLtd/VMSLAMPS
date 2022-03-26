$	set noverify
$	set noon				! ignore $status settings
$	on control_y then goto only_exit	! <CTRL/Y> is fatal
$!
$! ****************************************************************************
$! LSLIMI_MENU - a command file to manage the translation of data from OSTF or
$!		 NTF into INFORMAP, and back again
$!
$! Copyright (C) Laser-Scan Laboratories Ltd, Cambridge, England
$! Author TJ Ibbs, 16 October 1987 sqq
$!
$! Uses some of the same technology as the Laser-Scan DOCUMENT command files
$!
$! ****************************************************************************
$! Modifications
$! ............................................................................
$! 28-Oct-1987	Tony J Ibbs (Laser-Scan Labs)
$! Menu now released for use
$! ............................................................................
$! 06-Oct-1988	R J Hulme (Laser-Scan Labs)
$! Use /OS and /SCALE=1 with IMAP2I for OSTF output
$! Use /QUIET with I2IMAP
$! ............................................................................
$! 24-Oct-1988	R J Hulme (Laser-Scan Labs)
$! rename from IMAP_MENU.COM, amend comments, reference LSLIMI_LSLINI.COM
$! ............................................................................
$!
$! ****************************************************************************
$! introduce ourselves
$! - define a couple of essential abbreviations first
$!
$	ws  = "write sys$output "
$	wsb = "write sys$output """""
$!
$! - and we are
$!
$	wsb
$	ws "               Laser-Scan Informap/NTF/OSTF translation menu"
$	ws "                       (version 0.9, 24 October 1988)"
$	ws "                         [edited at LSL Cambridge]"
$	wsb
$!
$! ****************************************************************************
$! define various standard abbreviations that we need
$!
$	TRUE     = 1
$	FALSE	 = 0
$!
$! perform the LSL initialisation sequence
$!
$	@STI_ROOT:[LSL.COM]LSLIMI_LSLINI
$!
$! we want our own version of LSL$IF - but we don't want ot lose anyone
$! else's. Thus remember the old value, and define a new value
$!
$	old_if = f$trnlnm("LSL$IF")
$	define/nolog  LSL$IF  STI_ROOT:[LSL.TEMP]
$!
$! return values (for $status) from subroutines, etc
$! (note that HAD_EOF and HAD_CTRL are also 'failures')
$!
$	SUCCESS	 = %x10000001		! routine succeeded
$	FAILURE	 = %x1000000A		! routine failed
$	HAD_EOF  = %x10000002		! user replied <CTRL/Z> to a question
$	HAD_CTRL = %x10000004		! user interrupted with a <CTRL/Y>
$!
$! ????????????????????????????????????????????????????????????????????????????
$! INITIALISATION OF DEFAULTS
$!
$! This area may be edited to set appropriate defaults for the site using
$! the LSLIMI_MENU system
$! ............................................................................
$!
$! default values used in managing our input/output
$!
$	IMENU$d_drive           = "$2$MUA0:"	! tape drive name
$	IMENU$d_file		= "INFORMAP"	! file name
$	IMENU$d_is_tape         = "TRUE"	! drive is a tape drive
$	IMENU$d_density         = "1600"	! density to write at
$	IMENU$d_schema          = "BM2FULL"	! schema name
$!
$! the parameter file has the schema as its default name, but we will specify
$! an INITIAL value here, in case it is not the same
$!
$ 	IMENU$i_params		= "BM2"		! and in this case it isn't
$!
$! OSTF specific values
$!
$	IMENU$d_ostf_charset    = "ASCII"	! OSTF character set
$	IMENU$d_ostf_block      = "1800"	! OSTF blocksize
$	IMENU$d_ostf_points     = "FALSE"	! OSTF text in points?
$	IMENU$d_ostf_version    = "3"		! OSTF version
$	IMENU$d_ostf_contractor = "0"		! OSTF contractor number
$!
$	IMENU$t_ostf_points  = "point sizes"	! if 'points' is TRUE
$	IMENU$f_ostf_points  = "mm/10"		! if 'points' is FALSE
$!
$! NTF specific values
$!
$	IMENU$d_ntf_donor	= "British Gas"	! NTF donor - ourselves
$	IMENU$d_ntf_level	= "1"		! NTF output level
$	IMENU$d_ntf_serial	= "0"		! NTF volume serial number
$!
$	IMENU$d_ntf_xylen	= "10"		! size of planimetric coords
$	IMENU$d_ntf_xymult	= "0.001"	! scaling factor for them
$	IMENU$d_ntf_zmult	= "1.0"		! and for height values
$	IMENU$d_ntf_zdatum	= "0"		! and their origin
$	IMENU$d_ntf_copyright	= ""		! copyright as "yyyymmdd"
$!						! (default is 'unused' state)
$! ............................................................................
$! End of the INITIALISATION section
$!
$! ????????????????????????????????????????????????????????????????????????????
$! ****************************************************************************
$! disable <CTRL/Y> (and thus <CTRL/C>) for the next bit
$!
$	on control_y then continue		! <CTRL/Y> is ignored
$!
$! do the things that MUST be completed before the user can be allowed to use
$! <CTRL/Y> to escape
$!
$! - define the global symbols that we shall need for general management
$!
$	IMENU$RESULT   == 0		! to return a result from subroutines
$	IMENU$SCREEN   == FALSE		! we haven't yet played with the screen
$	IMENU$NO_MENUS == FALSE		! we want to display menus
$	IMENU$WIDTH    == 80		! and the default screen width
$!
$! - and those we shall need for managing our input/output
$!   (note that these are sensible things to set in the initialisation file)
$!
$	IMENU$v_drive           == IMENU$d_drive	! tape drive name
$	IMENU$v_file		== IMENU$d_file		! file name
$	IMENU$v_is_tape		== IMENU$d_is_tape	! use the tape drive
$	IMENU$v_density         == IMENU$d_density	! density to write at
$	IMENU$v_drawing_count	== 0			! no drawings at all yet
$	IMENU$v_schema          == IMENU$d_schema	! schema name
$ 	IMENU$v_params          == IMENU$i_params	! parameter file
$!
$	IMENU$v_ostf_select	== ""			! all sheets selected
$	IMENU$v_ostf_charset    == IMENU$d_ostf_charset	! OSTF character set
$	IMENU$v_ostf_block      == IMENU$d_ostf_block	! OSTF blocksize
$	IMENU$v_ostf_points     == IMENU$d_ostf_points	! OSTF text in points?
$	IMENU$v_ostf_version    == IMENU$d_ostf_version	! OSTF version
$	IMENU$v_ostf_contractor == IMENU$d_ostf_contractor
$!
$	IMENU$v_ntf_recipient	== ""			! to whom the data goes
$	IMENU$v_ntf_donor	== IMENU$d_ntf_donor	! and who we are
$	IMENU$v_ntf_level	== IMENU$d_ntf_level	! the level to write at
$	IMENU$v_ntf_serial	== IMENU$d_ntf_serial	! the volume serial
$	IMENU$v_ntf_xylen	== IMENU$d_ntf_xylen	! XY coord size
$	IMENU$v_ntf_xymult	== IMENU$d_ntf_xymult	! XY coord factor
$	IMENU$v_ntf_zmult	== IMENU$d_ntf_zmult	!  Z coord factor
$	IMENU$v_ntf_zdatum	== IMENU$d_ntf_zdatum	!  Z coord origin
$	IMENU$v_ntf_copyright	== IMENU$d_ntf_copyright! overriding copyright
$!
$! the other things that we want to define are all non-critical, so
$! can safely be interrupted by <CTRL/Y>. However, we must now go
$! to an earlier label to tidy up after the things we have just done.          
$!
$  	on control_y then goto final_exit	! <CTRL/Y> is fatal
$!
$! ****************************************************************************
$! work out whether we have the display capabilities that we need
$! - if we don't, warn the user, but carry on anyway.
$!
$	display_usable = f$getdvi( f$trnlnm("TT"), "TT_ANSICRT" )
$	if display_usable then goto display_is_usable
$	   ws "%IMENU-W-DISPLAY, display is not an ANSI terminal"
$	   ws "-IMENU-I-NOMENUS, menu display will not work properly"
$	   call PRESS_RETURN
$	   if .not.$status then goto final_exit
$!
$display_is_usable:
$!
$! look to see if there is an initialisation file to obey
$!
$	call CHECK_INIFILE
$	if .not.$status then goto final_exit
$!
$! ****************************************************************************
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
$	ws "%IMENU-E-INTERNAL, internal error"
$	ws "-IMENU-E-TOPMENU, unknown return from TOPLEVEL menu ($status=" +-
					$status + ")"
$	ws "-IMENU-I-REPORT, please report the problem to Laser-Scan"
$	call PRESS_RETURN
$	if .not.$status then goto final_exit
$	goto do_MENU_TOPLEVEL
$!
$! ****************************************************************************
$! come here to exit from the command procedure
$!
$final_exit:
$!
$! don't allow them to stop us now
$!
$	on control_y then continue
$!
$    	if IMENU$SCREEN then call UNSET_SCREEN
$!
$! delete the global symbols we used for general management
$!
$	delete/symbol/global  IMENU$RESULT
$	delete/symbol/global  IMENU$SCREEN
$	delete/symbol/global  IMENU$NO_MENUS
$	delete/symbol/global  IMENU$WIDTH
$!
$! and the ones we use for controllling input/output
$!
$	delete/symbol/global  IMENU$v_drive
$	delete/symbol/global  IMENU$v_file
$	delete/symbol/global  IMENU$v_is_tape
$	delete/symbol/global  IMENU$v_density
$	delete/symbol/global  IMENU$v_schema
$	delete/symbol/global  IMENU$v_params
$	delete/symbol/global  IMENU$v_drawing_count
$!
$	delete/symbol/global  IMENU$v_ostf_select
$	delete/symbol/global  IMENU$v_ostf_charset
$	delete/symbol/global  IMENU$v_ostf_block
$	delete/symbol/global  IMENU$v_ostf_points
$	delete/symbol/global  IMENU$v_ostf_version
$	delete/symbol/global  IMENU$v_ostf_contractor
$!
$	delete/symbol/global  IMENU$v_ntf_recipient
$	delete/symbol/global  IMENU$v_ntf_donor
$	delete/symbol/global  IMENU$v_ntf_level
$	delete/symbol/global  IMENU$v_ntf_serial
$	delete/symbol/global  IMENU$v_ntf_xylen
$	delete/symbol/global  IMENU$v_ntf_xymult
$	delete/symbol/global  IMENU$v_ntf_zmult
$	delete/symbol/global  IMENU$v_ntf_zdatum
$	delete/symbol/global  IMENU$v_ntf_copyright
$!
$! delete the symbols used for drawings - note that we don't know how many
$! there are, so keep going until we find one that has not been used
$!
$	count = 0
$next_drawing:
$	count = count +1
$	define/user sys$error  nl:		! suppress any error messages
$	define/user sys$output nl:		! or other output
$	delete/symbol/global IMENU$v_drawing'count
$	if $status then goto next_drawing
$!
$! if there was a previous value of LSL$IF, then go back to it
$!
$	if old_if.eqs."" then goto no_old_if
$	   define/nolog lsl$if 'old_if'
$	   ws "%IMENU-I-OLDIF, LSL$IF now points to where it used to"
$no_old_if:
$!
$! ............................................................................
$! and finally exit the command procedure
$!
$only_exit:	exit
$! ****************************************************************************

$! ============================================================================
$! ASK
$! Called to ASK the user a question
$!
$!	P1		the question to ask
$!	IMENU$RESULT	the answer to the question
$! ----------------------------------------------------------------------------
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
$	read/end_of_file=had_eof/error=had_error -
	    /prompt="''question'" -
    	    sys$command  answ
$!
$! and return it...
$!
$	IMENU$RESULT == answ
$	exit 'SUCCESS'
$!
$! ............................................................................
$had_eof:
$	IMENU$RESULT == ""
$	exit 'HAD_EOF'
$!
$had_error:
$	IMENU$RESULT == ""
$	ws "%IMENU-E-ASKERR, error in reading response"
$	exit 'FAILURE'

$! ============================================================================
$! ASKNO
$! Called to ASK the user a question, with a YES or NO answer
$! - an answer of <CR> will be treated as if it were NO
$!
$!	P1		the question to ask
$! 	P2		if present, an answer already supplied
$!
$! ----------------------------------------------------------------------------
$ASKNO:                                  
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$	IMENU$RESULT == ""
$!
$  	if P2.eqs."" then goto ask_again
$  	   answ = f$edit(P2,"TRIM,UPCASE")
$	   goto check_answ
$!
$ask_again:
$	call ASK "''P1' [NO]"
$	if .not.$status then exit '$status'
$!
$	answ = f$edit(IMENU$RESULT,"TRIM,UPCASE,UNCOMMENT")
$!
$check_answ:
$	if answ.eqs."" then goto it_was_NO	! treat RETURN as NO
$!
$	if f$locate(answ,"NO" ).eq.0 then goto it_was_NO
$	if f$locate(answ,"YES").eq.0 then goto it_was_YES
$!
$	ws "%IMENU-E-BADREPLY, please answer YES or NO"
$	goto ask_again
$!
$it_was_NO:
$	IMENU$RESULT == "NO"
$	exit 'SUCCESS'
$!
$it_was_YES:
$	IMENU$RESULT == "YES"
$	exit 'SUCCESS'
$!
$	ENDSUBROUTINE		! ASKNO

$! ============================================================================
$! ASK_DRAWINGS
$! Called to ASK the user for a series of drawings
$! - an answer of <CR> or <CTRL/Z> will terminate the list
$!
$! Arguments:
$!		P1	if supplied, this should be a single drawing
$!			name, in which case we don't ask for more
$!
$! ----------------------------------------------------------------------------
$ASK_DRAWINGS:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$	had_P1 = FALSE
$	if IMENU$v_drawing_count.eq.0 then fn = "First"
$	if IMENU$v_drawing_count.ne.0 then fn = " Next"
$!
$ 	if P1.eqs."" then goto ask_again
$	   had_P1 = TRUE
$ 	   answ = f$edit(P1,"TRIM,UPCASE")
$	   goto check_answ
$!             
$ask_again:
$	call ASK "''fn' drawing to output:"
$	if $status.eq.HAD_EOF then goto no_more_drawings
$	if .not.$status then exit '$status'
$!
$	answ = f$edit(IMENU$RESULT,"TRIM,UPCASE,UNCOMMENT")
$!
$check_answ:
$	if answ.eqs."" then goto no_more_drawings
$	if f$length(answ).le.9 then goto drawing_OK
$	   ws "%IMENU-E-BADDRAWG, drawing name cannot be longer than 9 characters"
$	   goto ask_again
$!
$drawing_OK:
$	call ADD_DRAWING "''answ'"
$ 	if had_P1 then goto no_more_drawings	! only wanted one
$!
$	fn = " Next"
$	goto ask_again
$!
$no_more_drawings:
$	exit 'SUCCESS'
$!
$	ENDSUBROUTINE		! ASK_DRAWINGS

$! ============================================================================
$! ASK_NAME
$! Called to ASK the user for a file name, drawing name, etc
$!
$! Arguments:
$!		P1		the question to ask
$!		P2		the maximum length the answer may be
$!		P3		if present, an answer already supplied
$!
$! ----------------------------------------------------------------------------
$ASK_NAME:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$	IMENU$RESULT == ""
$!
$	if P3.eqs."" then goto ask_again
$	   answ = f$edit(P3,"TRIM,UPCASE")
$	   goto check_answ
$!
$ask_again:
$	call ASK "''P1'"
$	if .not.$status then exit '$status'
$!
$	answ = f$edit(IMENU$RESULT,"TRIM,UPCASE,UNCOMMENT")
$!
$check_answ:
$	if answ.eqs."" then exit 'SUCCESS'
$!
$  	if f$length(answ).le.P2 then goto name_OK
$	   ws "%IMENU-E-BADNAME, name cannot be longer than ''P2' characters"
$	   goto ask_again
$!
$name_OK:
$	IMENU$RESULT == "''answ'"
$	exit 'SUCCESS'
$!
$	ENDSUBROUTINE		! ASK_NAME

$! ============================================================================
$! ASK_INTEGER
$! Called to ASK the user for an integer value
$!
$! Arguments:
$!		P1		the question to ask
$!		P2		the minimum value allowed
$!		P3		the maximum value allowed
$!		P4		if present, an answer already supplied
$!
$! ----------------------------------------------------------------------------
$ASK_INTEGER:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$	IMENU$RESULT == ""
$!
$	if P4.eqs."" then goto ask_again
$	   answ = f$edit(P4,"TRIM,UPCASE")
$	   goto check_answ
$!
$ask_again:
$	call ASK "''P1'"
$  	if .not.$status then exit '$status'
$!
$	answ = f$edit(IMENU$RESULT,"TRIM,UPCASE,UNCOMMENT")
$!
$check_answ:
$	if answ.eqs."" then exit 'SUCCESS'
$!
$	if f$type(answ).eqs."INTEGER" then goto answ_is_integer
$	   ws "%IMENU-E-BADINT, answer must be an integer"
$	   goto ask_again
$!
$answ_is_integer:
$	if answ.ge.P2 .and. answ.le.P3 then goto answ_OK
$	   ws "%IMENU-E-RANGE, answer must be between ''P2' and ''P3'"
$	   goto ask_again
$!
$answ_OK:
$    	IMENU$RESULT == "''answ'"
$	exit 'SUCCESS'
$!
$	ENDSUBROUTINE	       	! ASK_INTEGER

$! ============================================================================
$! ADD_DRAWING
$! Called to add a drawing to the list for output
$!
$! Arguments:
$!		P1	the drawing name to add
$!
$! ----------------------------------------------------------------------------
$ADD_DRAWING:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$	IMENU$v_drawing_count == IMENU$v_drawing_count +1
$	IMENU$v_drawing'IMENU$v_drawing_count == "''P1'"
$!
$	ws "Drawing ''IMENU$v_drawing_count' is " + -
				IMENU$v_drawing'IMENU$v_drawing_count
$!
$	exit 'SUCCESS'
$!
$	ENDSUBROUTINE		! ADD_DRAWING

$!
$! ============================================================================
$! MENU_TOPLEVEL
$! choose what to do, in a general sense
$! ----------------------------------------------------------------------------
$MENU_TOPLEVEL:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$repeat_tmenu:
$	Menu_name  = "TOP-LEVEL"
$	Line_count = 3
$ 	Line1 = "OSTF  -  OSTF data transfer"
$  	Line2 = "NTF   -  NTF data transfer"
$	Line3 = "MENU  -  set menu options"
$!
$	CtrlC = "redisplay the TOP-LEVEL menu"
$	CtrlZ = "exit the menu system"
$!
$	call DISPLAY_MENU
$	if .not.$status then exit '$status'
$!
$ask_option:           
$	call ASK  "Choose the option you want:"
$!
$	if .not.$status then exit '$status'
$	if IMENU$RESULT.eqs."?" then goto repeat_tmenu
$ 	if IMENU$RESULT.eqs.""  then goto ask_option
$!
$	answ := 'IMENU$RESULT		! upper-case the answer
$!
$	if f$length(answ).ge.2 then goto key_length_OK
$	   ws "%IMENU-E-KEYWORD, please type at least 2 characters"
$	   goto ask_option
$key_length_OK:
$!
$ 	if f$locate( answ, "OSTF" ).eq.0 then goto do_ostf
$ 	if f$locate( answ, "NTF"  ).eq.0 then goto do_ntf
$ 	if f$locate( answ, "MENU" ).eq.0 then goto do_menu_options
$!
$	ws "%IMENU-I-INVALID, I don't understand ""''answ'"""
$	goto ask_option
$!
$! ............................................................................
$! and call the correct menu
$!
$do_ostf:
$	call menu_ostf "''Menu_name'"
$	goto repeat_tmenu
$!
$do_ntf:
$	call menu_ntf "''Menu_name'"
$	goto repeat_tmenu
$!
$do_menu_options:
$	call menu_options "''Menu_name'"
$	goto repeat_tmenu
$!
$	ENDSUBROUTINE		! MENU_TOPLEVEL

$! ============================================================================
$! MENU_OSTF
$! To input/output OSTF data
$!
$! Arguments:
$!		P1	the previous menu's name
$!
$! ----------------------------------------------------------------------------
$MENU_OSTF:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$repeat_menu:
$	Menu_name  = "OSTF main"
$	Line_count = 2
$ 	Line1 = "IN   - read OSTF data into Informap"
$  	Line2 = "OUT  - write Informap data to OSTF"
$!
$	CtrlZ = "return you to the ''P1' menu"
$	CtrlC = "return you to the TOP-LEVEL menu"
$!
$	call DISPLAY_MENU
$	if .not.$status then exit '$status'
$!
$ask_option:           
$	call ASK  "Choose the option you want:"
$!
$	if .not.$status then exit '$status'
$	if IMENU$RESULT.eqs."?" then goto repeat_menu
$ 	if IMENU$RESULT.eqs.""  then goto ask_option
$!
$	answ := 'IMENU$RESULT		! upper-case the answer
$!
$	if f$length(answ).ge.2 then goto key_length_OK
$	   ws "%IMENU-E-KEYWORD, please type at least 2 characters"
$	   goto ask_option
$key_length_OK:
$!
$ 	if f$locate( answ, "IN"  ).eq.0 then goto do_in
$ 	if f$locate( answ, "OUT" ).eq.0 then goto do_out
$!
$	ws "%IMENU-I-INVALID, I don't understand ""''answ'"""
$	goto ask_option
$!
$! ............................................................................
$! and call the correct menu
$!
$do_in:
$	call menu_ostf_process "''Menu_name'"  "INPUT"
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto repeat_menu
$!
$do_out:
$	call menu_ostf_process "''Menu_name'"  "OUTPUT"
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto repeat_menu
$!
$	ENDSUBROUTINE		! MENU_OSTF

$! ============================================================================
$! MENU_OSTF_PROCESS
$! To set various values for OSTF input/output
$!
$! Arguments:
$!		P1	name of the parent menu
$!		P2	INPUT or OUTPUT (ie to tape, from Informap)
$!
$! ----------------------------------------------------------------------------
$MENU_OSTF_PROCESS:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$! when we enter the OUTPUT menu, we want to start off with no drawings
$! selected yet. This is irrelevant for the INPUT menu, but I can't be
$! bothered not to reset it then too.
$!
$	IMENU$v_drawing_count == 0		! no drawings yet
$!
$repeat_menu:
$	num = 0
$!
$	Menu_name = "OSTF input/output - ''P2'"
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	field1[0,35] := "WHAT    - Tape drive or file"
$	if .not.IMENU$v_is_tape then field2[0,13] := "File"
$	if      IMENU$v_is_tape then field2[0,13] := "Tape drive"
$	if .not.IMENU$d_is_tape then field3[0,23] := "(default File)"
$	if      IMENU$d_is_tape then field3[0,23] := "(default Tape drive)"
$	num = num+1
$	Line'num' = field1 + field2 + field3
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	if .not.IMENU$v_is_tape then goto not_using_drive
$	   field1[0,35] := "NAME    - Use tape drive"
$	   field2[0,13] := "''IMENU$v_drive'"
$	   field3[0,23] := "(default ''IMENU$d_drive')"
$	   goto sorted_out_drive
$not_using_drive:
$	   field1[0,35] := "NAME    - Use file"
$	   field2[0,13] := "''IMENU$v_file'"
$	   field3[0,23] := "(default ''IMENU$d_file')"
$sorted_out_drive:
$	num = num+1
$	Line'num' = field1 + field2 + field3
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	if      P2.nes."OUTPUT" then goto not_using_density
$	if .not.IMENU$v_is_tape then goto not_using_density
$	   field1[0,35] := "DENSITY - Write at density"
$	   field2[0,13] := "''IMENU$v_density'"
$	   field3[0,23] := "(default ''IMENU$d_density')"
$	   num = num+1
$	   Line'num' = field1 + field2 + field3
$not_using_density:
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	num = num+1
$	Line'num' = " "
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	if P2.nes."OUTPUT" then goto not_using_version
$	   field1[0,35] := "VERSION - OSTF version"
$	   field2[0,13] := "''IMENU$v_ostf_version'"
$	   field3[0,23] := "(default ''IMENU$d_ostf_version')"
$	   num = num+1
$	   Line'num' = field1 + field2 + field3
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	   field1[0,35] := "CID     - OS contractor ID"
$	   field2[0,13] := "''IMENU$v_ostf_contractor'"
$	   field3[0,23] := "(default ''IMENU$d_ostf_contractor')"
$	   num = num+1
$	   Line'num' = field1 + field2 + field3
$not_using_version:
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	field1[0,35] := "CHAR    - Character set"
$	field2[0,13] := "''IMENU$v_ostf_charset'"
$	field3[0,23] := "(default ''IMENU$d_ostf_charset')"
$	num = num+1
$	Line'num' = field1 + field2 + field3
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	if .not.IMENU$v_is_tape then goto not_using_blocksize
$	   field1[0,35] := "BLOCK   - Block size"
$	   field2[0,13] := "''IMENU$v_ostf_block'"
$	   field3[0,23] := "(default ''IMENU$d_ostf_block')"
$	   num = num+1
$	   Line'num' = field1 + field2 + field3
$not_using_blocksize:
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	if P2.nes."INPUT" then goto not_using_pointsize
$	   field1[0,35] := "TEXT    - Text sizes are"
$	   if IMENU$v_ostf_points -
	      then field2[0,13] := "''IMENU$t_ostf_points'"
$	   if .not.IMENU$v_ostf_points -
	      then field2[0,13] := "''IMENU$f_ostf_points'"
$	   if IMENU$d_ostf_points -
	      then field3[0,23] := "(default ''IMENU$t_ostf_points')"
$	   if .not.IMENU$d_ostf_points -
	      then field3[0,23] := "(default ''IMENU$f_ostf_points')"
$	   num = num+1                             
$	   Line'num' = field1 + field2 + field3
$not_using_pointsize:
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	num = num+1
$	Line'num' = " "
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	if P2.nes."OUTPUT" then goto not_using_drawing
$	   field1[0,35] := "DRAWING - Specify drawings"
$	   if IMENU$v_drawing_count.ne.0 then -
		field2[0,13] := "''IMENU$v_drawing_count' selected"
$	   if IMENU$v_drawing_count.eq.0 then field2[0,13] := "none selected"
$	   field3[0,23] := " "
$	   num = num+1
$	   Line'num' = field1 + field2 + field3
$not_using_drawing:
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	if P2.nes."INPUT" then goto not_using_select
$	   field1[0,35] := "SELECT  - Select sheets"
$	   if IMENU$v_ostf_select.eqs."" -
	      then field2[0,13] := "All sheets"
$	   if IMENU$v_ostf_select.nes."" -
	      then field2[0,13] := "''IMENU$v_ostf_select'"
$	   field3[0,23] := "(default All sheets)"
$	   num = num+1
$	   Line'num' = field1 + field2 + field3
$not_using_select:
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	field1[0,35] := "SCHEMA  - Schema name"
$	field2[0,13] := "''IMENU$v_schema'"
$	field3[0,23] := "(default ''IMENU$d_schema')"
$	num = num+1
$	Line'num' = field1 + field2 + field3
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	field1[0,35] := "PARAMS  - Translation parameters"
$	field2[0,13] := "''IMENU$v_params'"
$	field3[0,23] := "(default ''IMENU$v_schema')"
$	num = num+1
$	Line'num' = field1 + field2 + field3
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	num = num+1
$	Line'num' = " "
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	num = num+1
$	if      IMENU$v_is_tape then tofrom = "tape"
$	if .not.IMENU$v_is_tape then tofrom = "file"
$	if P2.eqs."OUTPUT" -
 	   then Line'num' = "OUTPUT  - output the drawings to ''tofrom'"
$	if P2.eqs."INPUT" -                
	   then Line'num' = "INPUT   - read the data from the ''tofrom'"
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	num = num+1
$	if P2.eqs."OUTPUT" -
	   then Line'num' = "SHOW    - the drawings to be output"
$	if P2.eqs."INPUT" -                
	   then Line'num' = "SHOW    - the OSTF index from the input"
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	Line_count = num
$!
$	CtrlZ = "return you to the ''P1' menu"
$	CtrlC = "return you to the TOP-LEVEL menu"
$!
$	call DISPLAY_MENU
$	if .not.$status then exit '$status'
$!
$ask_option:           
$	call ASK  "Choose the option you want:"
$!
$	if .not.$status then exit '$status'
$	if IMENU$RESULT.eqs."?" then goto repeat_menu
$ 	if IMENU$RESULT.eqs.""  then goto ask_option
$!
$! tidy up the reply
$!
$	answ = f$edit(IMENU$RESULT,"COMPRESS,TRIM,UNCOMMENT,UPCASE")
$!
$! extract the keyword from it - assume that it's ended by a space
$!
$	key = f$element(0," ",answ)
$	if key.eqs."" then goto ask_option
$	if f$length(key).ge.2 then goto key_length_OK
$	   ws "%IMENU-E-KEYWORD, please type at least 2 characters"
$	   goto ask_option
$key_length_OK:
$!
$! and also get the rest of the line (if any)
$!
$	rest = f$extract(f$length(key),f$length(answ),answ)
$!
$ 	if f$locate( key, "WHAT"    ).eq.0 then goto do_what
$ 	if f$locate( key, "NAME"    ).eq.0 then goto do_name
$ 	if f$locate( key, "DENSITY" ).eq.0 then goto do_density
$ 	if f$locate( key, "VERSION" ).eq.0 then goto do_version
$ 	if f$locate( key, "CID"     ).eq.0 then goto do_contractor
$ 	if f$locate( key, "CHAR"    ).eq.0 then goto do_charset
$ 	if f$locate( key, "BLOCK"   ).eq.0 then goto do_block
$ 	if f$locate( key, "TEXT"    ).eq.0 then goto do_points
$ 	if f$locate( key, "DRAWING" ).eq.0 then goto do_drawing
$ 	if f$locate( key, "SELECT"  ).eq.0 then goto do_select
$ 	if f$locate( key, "SCHEMA"  ).eq.0 then goto do_schema
$ 	if f$locate( key, "PARAMS"  ).eq.0 then goto do_params
$ 	if f$locate( key, "OUTPUT"  ).eq.0 then goto do_output
$ 	if f$locate( key, "INPUT"   ).eq.0 then goto do_input
$ 	if f$locate( key, "SHOW"    ).eq.0 then goto do_show
$!
$invalid_option:
$	ws "%IMENU-I-INVALID, I don't understand ""''key'"""
$	goto ask_option
$!
$! ............................................................................
$! and get the relevant value
$!
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_what:
$	if P2.eqs."OUTPUT" then qq = "output to"
$	if P2.eqs. "INPUT" then qq = "input from"
$!
$	call ASKNO "Is ''qq' file?"  "''rest'"
$ 	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.eqs."YES" then IMENU$v_is_tape == "FALSE"
$	if IMENU$RESULT.eqs."NO"  then IMENU$v_is_tape == "TRUE"
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_name:
$	if IMENU$v_is_tape then goto do_drive
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	call ASK_NAME "File to use:"  9  "''rest'"
$ 	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.eqs."" then IMENU$v_file == IMENU$d_file
$	if IMENU$RESULT.nes."" then IMENU$v_file == IMENU$RESULT
$	goto repeat_menu
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$do_drive:
$    	call ASK_NAME "Tape drive to use:"  37  "''rest'"
$ 	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.eqs."" then drive = IMENU$d_drive
$	if IMENU$RESULT.nes."" then drive = IMENU$RESULT
$!
$	if f$getdvi(drive,"EXISTS") then goto existing_device
$ 	   ws "%IMENU-E-NOSUCH, there is no device called ''drive' on the system"
$	   rest = ""
$	   goto do_drive
$existing_device:
$!
$	IMENU$v_drive == drive
$	if f$locate(":",IMENU$v_drive).eq.f$length(IMENU$v_drive) -
	   then IMENU$v_drive == IMENU$v_drive+":"
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_density:
$	if  P2.nes."OUTPUT"     then goto invalid_option
$ 	if .not.IMENU$v_is_tape then goto invalid_option
$!
$	call ASK_INTEGER "Density to write output tapes at:" 800 1600 "''rest'"
$	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.nes."" then goto got_density
$ 	   IMENU$v_density == IMENU$d_density
$	   goto repeat_menu
$!
$got_density:
$	if IMENU$RESULT.nes."1600" .and. -
	   IMENU$RESULT.nes."800" then goto bad_density
$	IMENU$v_density == IMENU$RESULT
$ 	goto repeat_menu
$!
$bad_density:
$  	ws "%IMENU-E-BADENSITY, tape density must be 800 or 1600"
$	rest = ""
$	goto do_density
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_version:
$	if P2.nes."OUTPUT" then goto invalid_option
$!
$	call ASK_INTEGER "Version of OSTF data (0-3):"  0  3  "''rest'"
$	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.eqs."" then IMENU$v_ostf_version == IMENU$d_ostf_version
$	if IMENU$RESULT.nes."" then IMENU$v_ostf_version == IMENU$RESULT
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_contractor:
$	if P2.nes."OUTPUT" then goto invalid_option
$!
$	call ASK_INTEGER "OS contractor ID:"  0  9999  "''rest'"
$	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.eqs."" then -
		IMENU$v_ostf_contractor == IMENU$d_ostf_contractor
$	if IMENU$RESULT.nes."" then IMENU$v_ostf_contractor == IMENU$RESULT
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_charset:
$	if rest.nes."" then goto got_charset1
$	   call ASK "ASCII or EBCDIC:"
$	   if .not.$status then exit '$status'
$	   rest = IMENU$RESULT
$got_charset1:
$	if rest.nes."" then goto got_charset2
$	   IMENU$v_ostf_charset == IMENU$d_ostf_charset
$	   goto repeat_menu
$got_charset2:
$	rest = f$edit(rest,"UPCASE,TRIM")
$ 	if f$locate( rest, "ASCII"  ).eq.0 then goto set_ASCII
$ 	if f$locate( rest, "EBCDIC" ).eq.0 then goto set_EBCDIC
$	   ws "%IMENU-E-BADCHAR, character set must be ASCII or EBCDIC"
$	   rest = ""
$	   goto do_charset
$set_ASCII:
$	IMENU$v_ostf_charset == "ASCII"
$	goto repeat_menu
$set_EBCDIC:
$	IMENU$v_ostf_charset == "EBCDIC"
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_block:
$	if P2.nes."OUTPUT"      then goto invalid_option
$	if .not.IMENU$v_is_tape then goto invalid_option
$!
$	call ASK_INTEGER "The blocksize of data on the tape is:" -
			 16 20000 "''rest'"
$	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.eqs."" then IMENU$v_ostf_block == IMENU$d_ostf_block
$	if IMENU$RESULT.nes."" then IMENU$v_ostf_block == IMENU$RESULT
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_points:
$	if P2.nes."INPUT" then goto invalid_option
$!
$	call ASKNO "Are text sizes in points?" "''rest'"
$	if .not.$status then exit '$status'
$!
$ 	if IMENU$RESULT.eqs."NO"  then IMENU$v_ostf_points == "FALSE"
$ 	if IMENU$RESULT.eqs."YES" then IMENU$v_ostf_points == "TRUE"
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_drawing:
$	if p2.nes."OUTPUT" then goto invalid_option
$!
$	call ASK_DRAWINGS "''rest'"
$ 	if .not.$status then exit '$status'
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_select:
$	if P2.nes."INPUT" then goto invalid_option
$!
$	if rest.nes."" then goto got_select1
$	   call ASK "Select which sheets are to be read:"
$	   if .not.$status then exit '$status'
$	   rest = f$edit(IMENU$RESULT,"TRIM,UNCOMMENT")
$got_select1:
$	IMENU$v_ostf_select == rest
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_schema:
$	call ASK_NAME "Schema name:"  9  "''rest'"
$	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.eqs."" then IMENU$v_schema == IMENU$d_schema
$	if IMENU$RESULT.nes."" then IMENU$v_schema == IMENU$RESULT
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_params:
$	call ASK_NAME "Translation parameter file:"  37  "''rest'"
$	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.eqs."" then parfil = IMENU$d_schema
$	if IMENU$RESULT.nes."" then parfil = IMENU$RESULT
$!
$	if P2.eqs."INPUT"  then ext="I2IMAP_PAR"
$	if P2.eqs."OUTPUT" then ext="IMAP2I_PAR"
$	if   f$search("LSL$LOOKUP:''parfil'.''ext'").eqs."" -
	then goto bad_params
$	   IMENU$v_params == parfil
$	   goto repeat_menu
$!
$bad_params:
$	ws "%IMENU-E-BADPARAMS, parameter file ""''parfil'.''ext'"" does not exist"
$	rest = ""
$	goto do_params
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$! Actually perform the output
$!
$do_output:
$!
$! first, check that the OUTPUT command would have been on the menu
$! - if not, don't let them select it!
$!
$	if P2.nes."OUTPUT" then goto invalid_option
$!
$! next, check that they have specified at least one drawing to output
$!
$	if IMENU$v_drawing_count.ne.0 then goto can_output
$	   ws "%IMENU-E-NODRAWG, you must specify which drawing(s) to output"
$	   goto ask_option
$can_output:
$!
$! perform the actual output operation
$!
$	call ostf_output
$	goto repeat_menu
$!
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$! Read the data from the tape
$!
$do_input:
$!
$! first, check that the INPUT command would have been on the menu
$! - if not, don't let them select it!
$!
$	if P2.nes."INPUT" then goto invalid_option
$!
$! perform the actual input operation
$!
$	call ostf_input
$	goto repeat_menu
$!
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$! Show - either the drawings that are to be output,
$!	      or the index from the start of the OSTF input data
$!
$do_show:
$!
$	if P2.eqs."INPUT"  then call DISPLAY_OSTF_INDEX  "''Menu_name'"
$	if P2.eqs."OUTPUT" then call DISPLAY_DRAWINGS    "''Menu_name'"
$!
$	goto repeat_menu
$!
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$!
$	ENDSUBROUTINE		! MENU_OSTF_PROCESS

$! ============================================================================
$! OSTF_INPUT
$! To perform input from OSTF on tape to the Informap system
$!
$! NOTE that WARNING returns from the LSL programs are treated as SUCCESSes
$! ----------------------------------------------------------------------------
$OSTF_INPUT:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$	had_control_y = FALSE
$	got_directory = FALSE
$	tape_attached = FALSE
$!
$	Menu_name = "OSTF input"
$	CtrlC     = "terminate the input operation"
$!
$	call DISPLAY_HEADER
$	if .not.$status then exit '$status'
$!
$! so we are ready to start
$! - note that we wil only check whether they have used control-C when
$!   it is convenient for ourselves
$!
$	on control_y then had_control_y = TRUE
$!
$! ensure that we will be able to use the transfer IFF directory
$!
$	call lock_directory  "from OSTF to Informap"
$	if .not.$status then goto exit_neatly
$	got_directory = TRUE
$!
$! if we are using a tape drive, attempt to get it for ourselves
$! if we are using a file, then check that it exists
$!
$	if IMENU$v_is_tape then goto get_drive
$!
$	   OSTF_input = "LSL$DATA:''IMENU$v_file'.OSTF"
$	   if f$search(OSTF_input).nes."" then goto got_our_input
$	      ws "%IMENU-E-NOFILE, input file ''IMENU$v_file' does not exist"
$	      goto exit_neatly
$!
$get_drive:
$	   call attach_tape  "OSTF"
$	   if .not.$status then goto exit_neatly
$	   tape_attached = TRUE
$	   OSTF_input = IMENU$v_drive
$!
$got_our_input:
$!
$! and let the system handle control-C for us again
$!
$	on control_y     then goto exit_neatly
$	if had_control_y then goto exit_neatly
$!
$! at last, we can actually try running a program!
$!
$	wsb
$	ws "[1mReading the OSTF data from ''OSTF_input'[0m"
$	wsb
$!
$	if .not.IMENU$v_ostf_points then points = "NOPOINT_SIZE"
$	if      IMENU$v_ostf_points then points =   "POINT_SIZE"
$!
$	select = ""
$	if IMENU$v_ostf_select.nes."" -
	   then select = "/SELECT=(''IMENU$v_ostf_select')"
$!
$	ostf2i  'OSTF_input'  'select'                -
			      /'IMENU$v_ostf_charset' -
			      /'points'               -
			      /blocksize='f$integer(IMENU$v_ostf_block)'
$!
$	if  $status               then goto ostf2i_ok
$	if ($status.and.%x7).eq.0 then goto ostf2i_ok	! treat W as S
$!
$	   ws "%IMENU-E-OSTF2I, error in reading from OSTF"
$	   if f$search("LSL$IF:*.IFF",1).eqs."" then goto exit_neatly
$	      wsb
$	      ws "Some files have been read"
$	      call ASKNO "Do you want to try transferring them to Informap?"
$	      if IMENU$RESULT.eqs."NO"  then goto exit_neatly
$!
$! so we have finished with the magnetic tape
$! - note that we treat the release of the tape as an indivisible operation
$!
$ostf2i_ok:
$	if .not.tape_attached then goto no_need_to_detach
$	   on control_y then had_control_y = TRUE
$	   call detach_tape
$	   tape_attached = FALSE
$	   on control_y     then goto exit_neatly
$	   if had_control_y then goto exit_neatly
$no_need_to_detach:
$!
$! and we are now ready to output the files we have read
$! to the Informap system
$!
$	wsb
$	ws "[1mWriting data from the intermediate directory to Informap[0m"
$	wsb
$!
$next_file:
$	file = f$search("LSL$IF:*.IFF",2)
$	if file.eqs."" then goto no_more_files
$	   name = f$parse(file,,,"NAME")
$!
$	   i2imap  'file'  /schema='IMENU$v_schema' -
		   /parameter='f$trnlnm("LSL$LOOKUP")''IMENU$v_params' -
		   /quiet
$!
$	   if  $status               then goto i2imap_ok
$	   if ($status.and.%x7).eq.0 then goto i2imap_ok
$!
$	      ws "%IMENU-E-I2IMAP, error writing file ''name' to Informap"
$	      ws "-IMENU-I-CARRYON, trying to carry on"
$i2imap_ok:
$	   goto next_file
$!
$no_more_files:
$	wsb
$	ws "[1mEnd of transfer[0m"
$	wsb
$!
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$! come here to tidy up before leaving. Note that we will continue even if
$! they type control-C (we don't want to get into a loop!)
$!
$exit_neatly:
$	on control_y then continue
$	if .not.got_directory then goto no_need_to_delete
$	   if f$search("LSL$IF:*.IFF",3).nes."" then delete LSL$IF:*.IFF;*
$	   call unlock_directory
$no_need_to_delete:
$	if tape_attached then call detach_tape
$!
$	call PRESS_RETURN
$	exit '$status'
$!
$	ENDSUBROUTINE		! OSTF_INPUT

$! ============================================================================
$! OSTF_OUTPUT
$! To perform output from the Informap system to OSTF on tape
$!
$! NOTE that WARNING returns from the LSL programs are treated as SUCCESSes
$! ----------------------------------------------------------------------------
$OSTF_OUTPUT:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$	had_control_y = FALSE
$	got_directory = FALSE
$	tape_attached = FALSE
$	got_inlist    = FALSE
$!
$	Menu_name = "OSTF output"
$	CtrlC     = "terminate the output operation"
$!
$	call DISPLAY_HEADER
$	if .not.$status then exit '$status'
$!
$! so we are ready to start
$! - note that we wil only check whether they have used control-C when
$!   it is convenient for ourselves
$!
$	on control_y then had_control_y = TRUE
$!
$! ensure that we will be able to use the transfer IFF directory
$!
$	call lock_directory  "from Informap to OSTF"
$	if .not.$status then goto exit_neatly
$	got_directory = TRUE
$!
$! if we are using a tape drive, then attempt to get it for ourselves
$!
$	if IMENU$v_is_tape then goto get_the_tape
$	   OSTF_output = "LSL$DATA:''IMENU$v_file'.OSTF"
$	   goto got_our_output
$get_the_tape:
$	   call attach_tape  "OSTF"
$	   if .not.$status then goto exit_neatly
$	   tape_attached = TRUE
$	   OSTF_output = IMENU$v_drive
$got_our_output:
$!
$! and let the system handle control-C for us again
$!
$	on control_y     then goto exit_neatly
$	if had_control_y then goto exit_neatly
$!
$! at last, we can actually try running a program!
$! - read a drawing from the Informap system into an IFF file
$!
$	wsb
$	ws "[1mWriting data from Informap to the intermediate directory[0m"
$	wsb
$!
$! we use the local symbol count to maintain a note of which drawing we
$! are dealing with. NOTE that it is incremented in such a way that it
$! is set to the number of drawings for transfer when we have finished
$! reading from Informap
$!
$ 	count = 0
$!
$! we must also open a file in which to list the drawings as we read them
$! - this will be used as the /INPUT_FILE file for I2OSTF
$!
$	on control_y then had_control_y = TRUE
$	   create  lsl$if:inlist.opt
$	   open/write/read  IMENU$INLIST  lsl$if:inlist.opt
$	   got_inlist = TRUE
$	on control_y     then goto exit_neatly
$	if had_control_y then goto exit_neatly
$!
$next_drawing:
$!
$	   if count.eq.IMENU$v_drawing_count then goto no_more_drawings
$	   count = count +1
$!
$ 	   drawing = IMENU$v_drawing'count	! it's this drawing
$!
$	   write IMENU$INLIST "''drawing'"	! add it to the input list
$!
$	   imap2i  'drawing' -
		   /schema='IMENU$v_schema' -
		   /parameter='f$trnlnm("LSL$LOOKUP")''IMENU$v_params' -
		   /os/scale=1
$!
$	   if  $status               then goto next_drawing
$	   if ($status.and.%x7).eq.0 then goto next_drawing
$!
$! cope with the difficult case of the transfer failing
$!
$	   ws "%IMENU-E-IMAP2I, error reading drawing ''drawing' from Informap"
$	   if f$search("LSL$IF:*.IFF",1).eqs."" then goto exit_neatly
$	      wsb
$	      ws "Some drawings have been read"
$	      call ASKNO "Do you want to try transferring them to OSTF?"
$	      if IMENU$RESULT.eqs."NO" then goto exit_neatly
$!
$no_more_drawings:
$!
$	close IMENU$INLIST		! close the input list file
$!
$! and write the files to tape in OSTF form
$!
$	wsb
$	ws "[1mWriting OSTF data to ''OSTF_output'[0m"
$	wsb
$!
$	i2ostf/input_list=lsl$if:inlist.opt  'OSTF_output'                 -
			/contractor  ='f$integer(IMENU$v_ostf_contractor)' -
			/ostf_version='f$integer(IMENU$v_ostf_version)'    -
			/density     ='f$integer(IMENU$v_density)'         -
	       		/blocksize   ='f$integer(IMENU$v_ostf_block)'      -
			/'IMENU$v_ostf_charset'
$!
$	if  $status               then goto ostf2i_ok
$	if ($status.and.%x7).eq.0 then goto ostf2i_ok
$!
$	   ws "%IMENU-E-I2OSTF, error in writing to OSTF"
$	   goto exit_neatly
$ostf2i_ok:
$!
$	wsb
$	ws "[1mEnd of transfer[0m"
$	wsb
$!
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$! come here to tidy up before leaving. Note that we will continue even if
$! they type control-C (we don't want to get into a loop!)
$!
$exit_neatly:
$ 	on control_y then continue
$!
$ 	if f$trnlnm("IMENU$INLIST").nes."" then close IMENU$INLIST
$	if got_inlist then delete lsl$if:inlist.opt;*
$!
$	if .not.got_directory then goto no_need_to_delete
$	   if f$search("LSL$IF:*.IFF",3).nes."" then delete LSL$IF:*.IFF;*
$	   call unlock_directory
$no_need_to_delete:
$	if tape_attached then call detach_tape
$!
$	call PRESS_RETURN
$	exit '$status'
$!
$	ENDSUBROUTINE		! OSTF_OUTPUT

$! ============================================================================
$! DISPLAY_DRAWINGS
$! display the drawings currently selected for output
$!
$! Arguments:
$!		P1		the previous menu name
$!
$! ----------------------------------------------------------------------------
$DISPLAY_DRAWINGS:
$	SUBROUTINE
$	set noon
$  	on control_y then exit 'HAD_CTRL'
$!
$! check that there ARE some drawings specified!
$!
$	if IMENU$v_drawing_count.gt.0 then goto got_some_drawings
$	   ws "There are no drawings selected for output"
$	   exit 'SUCCESS'
$got_some_drawings:
$!
$! Otherwise, output a banner heading for our listing
$!
$	Menu_name = "Drawings selected for output"
$	CtrlC     = "return you to the ''P1' menu"
$!
$	call DISPLAY_HEADER
$	if .not.$status then exit '$status'
$!
$! - each name is output in a field which is a multiple of 'chunk'
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
$	chunk = 15
$!
$	count = 0
$	char  = 0			! and the characters in this line
$	line[0,'IMENU$WIDTH'] := " "	! start with it empty
$!
$next_name:
$	   count = count +1
$	   if count.gt.IMENU$v_drawing_count then goto no_more_names
$!
$	   name = IMENU$v_drawing'count
$!
$	   flen = f$length(name)		! work out its length
$	   size = ((flen+chunk)/chunk) *chunk	! round it up to a chunk
$! 
$ 	   if size+char.le.IMENU$WIDTH then goto add_name
$!
$	      ws line				! write the full line
$	      line[0,'IMENU$WIDTH'] := " "	! empty the line
$	      char   = 0			! so no chars in it yet
$!
$add_name: line[char,flen] := 'name		! add the file to the line
$	   char   = char + size			! and count its characters
$	   goto next_name			! get the next name
$!
$no_more_names:
$	      ws line
$!
$no_more_lines:
$!
$	ws " "
$	call PRESS_RETURN
$	if .not.$status then exit '$status'
$!
$	exit 'SUCCESS'
$	ENDSUBROUTINE		! DISPLAY_DRAWINGS

$! ============================================================================
$! DISPLAY_OSTF_INDEX
$! display the index from the start of the current OSTF data file/tape
$!
$! Arguments:
$!		P1		the previous menu name
$!
$! ----------------------------------------------------------------------------
$DISPLAY_OSTF_INDEX:
$	SUBROUTINE
$	set noon
$  	on control_y then exit 'HAD_CTRL'
$!
$! Output a banner heading for our listing
$!
$   	Menu_name = "OSTF index"
$	CtrlC     = "return you to the ''P1' menu"
$!
$	call DISPLAY_HEADER
$	if .not.$status then exit '$status'
$!
$	if IMENU$v_is_tape then goto mount_the_tape
$!
$	   ostfindex  LSL$DATA:'IMENU$v_file'.OSTF
$	   goto finished
$!
$mount_the_tape:
$!
$	   call ATTACH_TAPE "OSTF"
$	   if .not.$status then exit '$status'
$!
$	   ostfindex  'IMENU$v_drive'
$!
$	   call DETACH_TAPE
$!
$finished:
$	call PRESS_RETURN
$	if .not.$status then exit '$status'
$!
$	exit 'SUCCESS'
$	ENDSUBROUTINE		! DISPLAY_OSTF_INDEX

$! ============================================================================
$! ATTACH_TAPE
$! To allocate and mount the magnetic tape, also reserving the i/o directory
$! for our use
$!
$! Arguments:
$!		P1	OSTF or NTF - what we want the tape for
$!
$! ----------------------------------------------------------------------------
$ATTACH_TAPE:
$	SUBROUTINE
$	set noon
$	on control_y then continue	! for the moment
$!
$	tape_allocated = FALSE
$	tape_mounted   = FALSE
$	had_control_y  = FALSE
$!
$! make the next operation indivisible
$!
$	if had_control_y then had_control_y = TRUE	! user can't interrupt
$!
$! try to allocate the tape drive
$!
$	allocate  'IMENU$v_drive'
$	if $status then goto allocate_ok
$	   ws "%IMENU-E-NOTAPE, tape drive ''IMENU$v_drive' not available"
$	   show device/full 'IMENU$v_drive'
$	   call PRESS_RETURN
$	   goto exit_with_error
$allocate_ok:
$	tape_allocated = TRUE
$!
$! so we have the tape drive
$! - from now on, we can allow the system to trap control-C for us
$!
$	on control_y     then goto exit_with_error
$	if had_control_y then goto exit_with_error	! our last check
$!
$! - ask them to get the tape ready for us to mount
$!
$	ws "[7mInsert the magnetic tape in ''IMENU$v_drive'[0m"
$	call PRESS_RETURN
$	if $status.eq.HAD_CTRL then goto exit_with_error
$!
$! - and mount it
$!   if we are mounting for OSTF, specify the block and record sizes
$!   if we are mounting for NTF, just mount the tape
$!
$	if P1.eqs."NTF" then goto mount_NTF
$	   mount  'IMENU$v_drive'  /foreign -
				   /blocksize='f$integer(IMENU$v_ostf_block)' -
				   /recordsize=8
$	   goto check_mount
$mount_NTF:
$	   mount  'IMENU$v_drive'  /foreign
$check_mount:
$	if $status then goto mount_ok
$	   ws "%IMENU-E-MOUNT, unable to mount tape on ''IMENU$v_drive'"
$	   call PRESS_RETURN
$	   goto exit_with_error
$mount_ok:
$!
$! and that's all we have to do
$!
$	exit 'SUCCESS'
$!
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$! come here to tidy up before leaving after an error. Note that we will
$! continue even if they type control-C (we don't want to get into a loop!)
$!
$exit_with_error:
$	on control_y then continue
$	if tape_mounted   then dismount   'IMENU$v_drive'
$	if tape_allocated then deallocate 'IMENU$v_drive'
$	exit 'FAILURE'
$!
$	ENDSUBROUTINE		! ATTACH_TAPE

$! ============================================================================
$! DETACH_TAPE
$! To free the tape drive after we have finished with it
$! ----------------------------------------------------------------------------
$DETACH_TAPE:
$	SUBROUTINE
$	set noon
$	on control_y then continue	! can't split this up
$!
$	dismount   'IMENU$v_drive
$	deallocate 'IMENU$v_drive'
$!
$	exit '$status'
$!
$	ENDSUBROUTINE		! DETACH_TAPE

$! ============================================================================
$! LOCK_DIRECTORY
$! To lock the LSL$IF directory for our own use
$!
$! Arguments:
$!		P1	the reason we are getting the directory
$!
$! ----------------------------------------------------------------------------
$LOCK_DIRECTORY:
$	SUBROUTINE
$	set noon
$	on control_y then continue	! can't split this operation
$!
$	got_directory = FALSE
$!
$! check whether someone else has grabbed the directory where we want to put
$! our IFF files. We do this by trying to create the "locking file", with a
$! specific version number. Note that we suppress any output from CREATE
$!
$	define/user sys$error  nl:
$	define/user sys$output nl:
$	create LSL$IF:DIRECTORY_IN_USE.ALREADY;1
$	if $status then goto directory_ok
$	   ws "%IMENU-E-DIRINUSE, the temporary data directory is already in use"
$	   type LSL$IF:DIRECTORY_IN_USE.ALREADY;1
$	   call PRESS_RETURN
$	   goto exit_with_error
$directory_ok:
$	got_directory = TRUE
$!
$! note who we are in the locking file
$!
$	open  IMENU$LOCKFILE  LSL$IF:DIRECTORY_IN_USE.ALREADY;1 /write/read
$	write IMENU$LOCKFILE  "Translation ''P1' in progress"
$	write IMENU$LOCKFILE  "(translating process is ''f$process()')"
$	close IMENU$LOCKFILE
$!
$! and that's all we have to do
$!
$	exit 'SUCCESS'
$!
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$! come here to tidy up before leaving after an error. Note that we will
$! continue even if they type control-C (we don't want to get into a loop!)
$!
$exit_with_error:
$	if got_directory then call unlock_directory
$	exit 'FAILURE'
$!
$	ENDSUBROUTINE		! LOCK_DIRECTORY

$! ============================================================================
$! UNLOCK_DIRECTORY
$! To free the directory after we have finished with it
$! ----------------------------------------------------------------------------
$UNLOCK_DIRECTORY:
$	SUBROUTINE
$	set noon
$	on control_y then continue	! can't split this up
$!
$! if the file wasn't closed properly, then we must close it
$!
$	if f$trnlnm("IMENU$LOCKFILE") .nes."" then close IMENU$LOCKFILE
$!
$! and we must then delete it, so that we have no more claim on the
$! IFF directory
$!
$	delete LSL$IF:DIRECTORY_IN_USE.ALREADY;*
$!
$	exit 'SUCCESS'
$!
$	ENDSUBROUTINE		! UNLOCK_DIRECTORY

$! ============================================================================
$! MENU_NTF
$! To input/output NTF data
$!
$! Arguments:
$!		P1		the previous menu's name
$!
$! ----------------------------------------------------------------------------
$MENU_NTF:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$repeat_menu:
$	Menu_name  = "NTF main"
$	Line_count = 2
$ 	Line1 = "IN   - read NTF data into Informap"
$  	Line2 = "OUT  - write Informap data to NTF"
$!
$	CtrlZ = "return you to the ''P1' menu"
$	CtrlC = "return you to the TOP-LEVEL menu"
$!
$	call DISPLAY_MENU
$	if .not.$status then exit '$status'
$!
$ask_option:
$	call ASK  "Choose the option you want:"
$!
$	if .not.$status then exit '$status'
$	if IMENU$RESULT.eqs."?" then goto repeat_menu
$ 	if IMENU$RESULT.eqs.""  then goto ask_option
$!
$	answ := 'IMENU$RESULT		! upper-case the answer
$!
$	if f$length(answ).ge.2 then goto key_length_OK
$	   ws "%IMENU-E-KEYWORD, please type at least 2 characters"
$	   goto ask_option
$key_length_OK:
$!
$ 	if f$locate( answ, "IN"  ).eq.0 then goto do_in
$ 	if f$locate( answ, "OUT" ).eq.0 then goto do_out
$!
$	ws "%IMENU-I-INVALID, I don't understand ""''answ'"""
$	goto ask_option
$!
$! ............................................................................
$! and call the correct menu
$!
$do_in:
$	call menu_ntf_process  "''Menu_name'"  "INPUT"
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto repeat_menu
$!
$do_out:
$	call menu_ntf_process  "''Menu_name'"  "OUTPUT"
$	if $status.eq.HAD_CTRL then exit '$status'
$	goto repeat_menu
$!
$	ENDSUBROUTINE		! MENU_NTF

$! ============================================================================
$! MENU_NTF_PROCESS
$! To set various values for NTF input/output
$!
$! Arguments:
$!		P1	the previous menu's name
$!		P2	INPUT or OUTPUT (ie from tape, or to Informap)
$!
$! ----------------------------------------------------------------------------
$MENU_NTF_PROCESS:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$! when we enter the OUTPUT menu, we want to start off with no drawings
$! selected yet. This is irrelevant for the INPUT menu, but I can't be
$! bothered not to reset it then too.
$!
$	IMENU$v_drawing_count == 0		! no drawings yet
$!
$repeat_menu:
$	num = 0
$!
$	Menu_name = "NTF input/output - ''P2'"
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	field1[0,35] := "WHAT    - Tape drive or file"
$	if .not.IMENU$v_is_tape then field2[0,13] := "File"
$	if      IMENU$v_is_tape then field2[0,13] := "Tape drive"
$	if .not.IMENU$d_is_tape then field3[0,23] := "(default File)"
$	if      IMENU$d_is_tape then field3[0,23] := "(default Tape drive)"
$	num = num+1
$	Line'num' = field1 + field2 + field3
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	if .not.IMENU$v_is_tape then goto not_using_drive
$	   field1[0,35] := "NAME    - Use tape drive"
$	   field2[0,13] := "''IMENU$v_drive'"
$	   field3[0,23] := "(default ''IMENU$d_drive')"
$	   goto sorted_out_drive
$not_using_drive:
$	   field1[0,35] := "NAME    - Use file"
$	   field2[0,13] := "''IMENU$v_file'"
$	   field3[0,23] := "(default ''IMENU$d_file')"
$sorted_out_drive:
$	num = num+1
$	Line'num' = field1 + field2 + field3
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	if      P2.nes."OUTPUT" then goto not_using_density
$	if .not.IMENU$v_is_tape then goto not_using_density
$	   field1[0,35] := "DENSITY - Write at density"
$	   field2[0,13] := "''IMENU$v_density'"
$	   field3[0,23] := "(default ''IMENU$d_density')"
$	   num = num+1
$	   Line'num' = field1 + field2 + field3
$not_using_density:
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	if P2.nes."OUTPUT" then goto no_extra_blank_needed
$	   num = num+1
$	   Line'num' = " "
$no_extra_blank_needed:
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	if P2.nes."OUTPUT" then goto not_using_recipient
$	   field1[0,35] := "RECIP   - Recipient of data"
$!
$ 	   second[ 0,1]  := """"
$	   second[21,1]  := """"
$	   second[ 1,20] := "''IMENU$v_ntf_recipient'"
$!
$ 	   if IMENU$v_ntf_recipient.eqs."" then second[0,22] := "none defined"
$!
$	   num = num+1
$	   Line'num' = field1 + second
$not_using_recipient:
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$! NOTE that there is not room to show both a 20 character DONOR and its
$! default, so we don't try
$!
$	if P2.nes."OUTPUT" then goto not_using_donor
$	   field1[0,35] := "DONOR   - Sender of data"
$!
$ 	   second[ 0,1]  := """"
$	   second[21,1]  := """"
$	   second[ 1,20] := "''IMENU$v_ntf_donor'"
$!
$	   num = num+1
$	   Line'num' = field1 + second
$not_using_donor:
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	if P2.nes."OUTPUT" then goto not_using_level
$	   field1[0,35] := "LEVEL   - NTF level"
$	   field2[0,13] := "''IMENU$v_ntf_level'"
$	   field3[0,23] := "(default ''IMENU$d_ntf_level')"
$	   num = num+1
$	   Line'num' = field1 + field2 + field3
$not_using_level:
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	if P2.nes."OUTPUT" then goto not_using_serial
$	   field1[0,35] := "SERIAL  - Volume serial number"
$	   field2[0,13] := "''IMENU$v_ntf_serial'"
$	   field3[0,23] := "(default ''IMENU$d_ntf_serial')"
$	   num = num+1
$	   Line'num' = field1 + field2 + field3
$not_using_serial:
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	if P2.nes."OUTPUT" then goto not_using_etc
$	   num = num+1
$	   Line'num' = "ETC     - Other output details"
$not_using_etc:
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	num = num+1
$	Line'num' = " "
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	if P2.nes."OUTPUT" then goto not_using_drawing
$	   field1[0,35] := "DRAWING - Specify drawings"
$	   if IMENU$v_drawing_count.ne.0 then -
		field2[0,13] := "''IMENU$v_drawing_count' selected"
$	   if IMENU$v_drawing_count.eq.0 then field2[0,13] := "none selected"
$	   field3[0,23] := " "
$	   num = num+1
$	   Line'num' = field1 + field2 + field3
$not_using_drawing:
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	field1[0,35] := "SCHEMA  - Schema name"
$	field2[0,13] := "''IMENU$v_schema'"
$	field3[0,23] := "(default ''IMENU$d_schema')"
$	num = num+1
$	Line'num' = field1 + field2 + field3
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	field1[0,35] := "PARAMS  - Translation parameters"
$	field2[0,13] := "''IMENU$v_params'"
$	field3[0,23] := "(default ''IMENU$v_schema')"
$	num = num+1
$	Line'num' = field1 + field2 + field3
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	num = num+1
$	Line'num' = " "
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	num = num+1
$	if      IMENU$v_is_tape then tofrom = "tape"
$	if .not.IMENU$v_is_tape then tofrom = "file"
$	if P2.eqs."OUTPUT" -
 	   then Line'num' = "OUTPUT  - output the drawings to ''tofrom'"
$	if P2.eqs."INPUT" -                
	   then Line'num' = "INPUT   - read the data from the ''tofrom'"
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	if P2.nes."OUTPUT" then goto not_using_show
$	   num = num+1
$	   Line'num' = "SHOW    - the drawings to be output"
$not_using_show:
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	Line_count = num
$!
$	CtrlZ = "return you to the ''P1' menu"
$	CtrlC = "return you to the TOP-LEVEL menu"
$!
$	call DISPLAY_MENU
$	if .not.$status then exit '$status'
$!
$ask_option:           
$	call ASK  "Choose the option you want:"
$!
$	if .not.$status then exit '$status'
$	if IMENU$RESULT.eqs."?" then goto repeat_menu
$ 	if IMENU$RESULT.eqs.""  then goto ask_option
$!
$! tidy up the reply
$!
$	answ = f$edit(IMENU$RESULT,"COMPRESS,TRIM,UNCOMMENT,UPCASE")
$!
$! extract the keyword from it - assume that it's ended by a space
$!
$	key = f$element(0," ",answ)
$	if key.eqs."" then goto ask_option
$	if f$length(key).ge.2 then goto key_length_OK
$	   ws "%IMENU-E-KEYWORD, please type at least 2 characters"
$	   goto ask_option
$key_length_OK:
$!
$! and also get the rest of the line (if any)
$!
$	rest = f$extract(f$length(key),f$length(answ),answ)
$!
$ 	if f$locate( key, "WHAT"    ).eq.0 then goto do_what
$ 	if f$locate( key, "NAME"    ).eq.0 then goto do_name
$ 	if f$locate( key, "DENSITY" ).eq.0 then goto do_density
$ 	if f$locate( key, "RECIP"   ).eq.0 then goto do_recipient
$ 	if f$locate( key, "DONOR"   ).eq.0 then goto do_donor
$ 	if f$locate( key, "LEVEL"   ).eq.0 then goto do_level
$ 	if f$locate( key, "SERIAL"  ).eq.0 then goto do_serial
$ 	if f$locate( key, "ETC"     ).eq.0 then goto do_etc
$ 	if f$locate( key, "DRAWING" ).eq.0 then goto do_drawing
$ 	if f$locate( key, "SCHEMA"  ).eq.0 then goto do_schema
$ 	if f$locate( key, "PARAMS"  ).eq.0 then goto do_params
$ 	if f$locate( key, "OUTPUT"  ).eq.0 then goto do_output
$ 	if f$locate( key, "INPUT"   ).eq.0 then goto do_input
$ 	if f$locate( key, "SHOW"    ).eq.0 then goto do_show
$!
$invalid_option:
$	ws "%IMENU-I-INVALID, I don't understand ""''key'"""
$	goto ask_option
$!
$! ............................................................................
$! and get the relevant value
$!
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_what:
$	if P2.eqs."OUTPUT" then qq = "output to"
$	if P2.eqs. "INPUT" then qq = "input from"
$!
$	call ASKNO "Is ''qq' file?"  "''rest'"
$ 	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.eqs."YES" then IMENU$v_is_tape == "FALSE"
$	if IMENU$RESULT.eqs."NO"  then IMENU$v_is_tape == "TRUE"
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_name:
$	if IMENU$v_is_tape then goto do_drive
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	call ASK_NAME "File to use:"  9  "''rest'"
$ 	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.eqs."" then IMENU$v_file == IMENU$d_file
$	if IMENU$RESULT.nes."" then IMENU$v_file == IMENU$RESULT
$	goto repeat_menu
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$do_drive:
$    	call ASK_NAME "Tape drive to use:"  37  "''rest'"
$ 	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.eqs."" then drive = IMENU$d_drive
$	if IMENU$RESULT.nes."" then drive = IMENU$RESULT
$!
$	if f$getdvi(drive,"EXISTS") then goto existing_device
$ 	   ws "%IMENU-E-NOSUCH, there is no device called ''drive' on the system"
$	   rest = ""
$	   goto do_drive
$existing_device:
$!
$	IMENU$v_drive == drive
$	if f$locate(":",IMENU$v_drive).eq.f$length(IMENU$v_drive) -
	   then IMENU$v_drive == IMENU$v_drive+":"
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_density:
$	if  P2.nes."OUTPUT"     then goto invalid_option
$ 	if .not.IMENU$v_is_tape then goto invalid_option
$!
$	call ASK_INTEGER "Density to write output tapes at:" 800 1600 "''rest'"
$	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.nes."" then goto got_density
$ 	   IMENU$v_density == IMENU$d_density
$	   goto repeat_menu
$!
$got_density:
$	if IMENU$RESULT.nes."1600" .and. -
	   IMENU$RESULT.nes."800" then goto bad_density
$	IMENU$v_density == IMENU$RESULT
$ 	goto repeat_menu
$!
$bad_density:
$  	ws "%IMENU-E-BADENSITY, tape density must be 800 or 1600"
$	rest = ""
$	goto do_density
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_recipient:
$	if P2.nes."OUTPUT" then goto invalid_option
$!
$	if rest.eqs."" then goto ask_recip
$	   rest = f$edit(rest,"TRIM")
$	   goto got_recip
$!
$ask_recip:
$	call ASK "Recipient of data:"
$	if .not.$status then exit '$status'
$	rest = f$edit(IMENU$RESULT,"TRIM")
$	if rest.nes."" then goto got_recip
$	   ws "%IMENU-E-RECIP, recipient must be specified before OUTPUT"
$	   goto do_recipient
$!
$got_recip:
$	if f$length(rest).gt.20 then goto bad_recip
$  	IMENU$v_ntf_recipient == rest
$	goto repeat_menu
$!
$bad_recip:
$	ws "%IMENU-E-RECIPLEN, recipient name cannot be more than 20 characters"
$	rest = ""
$	goto do_recipient
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_donor:
$	if P2.nes."OUTPUT" then goto invalid_option
$!
$	if rest.eqs."" then goto ask_donor
$	   rest = f$edit(rest,"TRIM")
$	   goto got_donor
$!
$ask_donor:
$	call ASK "Donor of data:"
$	if .not.$status then exit '$status'
$	rest = f$edit(IMENU$RESULT,"TRIM")
$	if rest.nes."" then goto got_donor
$	   IMENU$v_ntf_donor == IMENU$d_ntf_donor
$	   goto repeat_menu
$!
$got_donor:
$	if f$length(rest).gt.20 then goto bad_donor
$  	IMENU$v_ntf_donor == rest
$	goto repeat_menu
$!
$bad_donor:
$	ws "%IMENU-E-DONORLEN, donor name cannot be more than 20 characters"
$	rest = ""
$	goto do_donor
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_level:
$	if P2.nes."OUTPUT" then goto invalid_option
$!
$	call ASK_INTEGER "Level of NTF (1 or 2):"  1  2  "''rest'"
$	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.eqs."" then IMENU$v_ntf_level == IMENU$d_ntf_level
$	if IMENU$RESULT.nes."" then IMENU$v_ntf_level == IMENU$RESULT
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_serial:
$	if P2.nes."OUTPUT" then goto invalid_option
$!
$	call ASK_INTEGER "Volume serial number:"  0  2000  "''rest'"
$	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.eqs."" then IMENU$v_ntf_serial == IMENU$d_ntf_serial
$	if IMENU$RESULT.nes."" then IMENU$v_ntf_serial == IMENU$RESULT
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_etc:
$	if P2.nes."OUTPUT" then goto invalid_option
$!
$   	call MENU_NTF_ETC  "''Menu_name'"
$!
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_drawing:
$	if P2.nes."OUTPUT" then goto invalid_option
$!
$	call ASK_DRAWINGS "''rest'"
$ 	if .not.$status then exit '$status'
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_schema:
$	call ASK_NAME "Schema name:"  9  "''rest'"
$	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.eqs."" then IMENU$v_schema == IMENU$d_schema
$	if IMENU$RESULT.nes."" then IMENU$v_schema == IMENU$RESULT
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_params:                              
$	call ASK_NAME "Translation parameter file:"  37  "''rest'"
$	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.eqs."" then parfil = IMENU$d_schema
$	if IMENU$RESULT.nes."" then parfil = IMENU$RESULT
$!
$	if P2.eqs."INPUT"  then ext="I2IMAP_PAR"
$	if P2.eqs."OUTPUT" then ext="IMAP2I_PAR"
$	if   f$search("LSL$LOOKUP:''parfil'.''ext'").eqs."" -
	then goto bad_params
$	   IMENU$v_params == parfil
$	   goto repeat_menu
$!
$bad_params:
$	ws "%IMENU-E-BADPARAMS, parameter file ""''parfil'.''ext'"" does not exist"
$	rest = ""
$	goto do_params
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$! Actually perform the output
$!
$do_output:
$!
$! first, check that the OUTPUT command would have been on the menu
$! - if not, don't let them select it!
$!
$	if P2.nes."OUTPUT" then goto invalid_option
$!
$! next, they must have specified the recipient
$!
$	if IMENU$v_ntf_recipient.nes."" then goto got_recip_for_output
$	   ws "%IMENU-E-RECIP, recipient must be specified before OUTPUT"
$	   goto ask_option
$got_recip_for_output:
$!
$! next, check that they have specified at least one drawing to output
$!
$	if IMENU$v_drawing_count.ne.0 then goto can_output
$	   ws "%IMENU-E-NODRAWG, you must specify which drawing(s) to output"
$	   goto ask_option
$can_output:
$!
$! perform the actual output operation
$!
$	call ntf_output
$	goto repeat_menu
$!
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$! Read the data from the tape
$!
$do_input:
$!
$! first, check that the INPUT command would have been on the menu
$! - if not, don't let them select it!
$!
$	if P2.nes."INPUT" then goto invalid_option
$!
$! perform the actual input operation
$!
$	call ntf_input
$	goto repeat_menu
$!
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$! Show - the drawings that are to be output
$!
$do_show:
$!
$	if P2.eqs."INPUT"  then goto invalid_option
$	if P2.eqs."OUTPUT" then call DISPLAY_DRAWINGS    "''Menu_name'"
$!
$	goto repeat_menu
$!
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$!
$	ENDSUBROUTINE		! MENU_NTF_PROCESS

$! ============================================================================
$! MENU_NTF_ETC
$! To set various values for NTF output
$!
$! Arguments:
$!		P1	the previous menu's name
$!
$! ----------------------------------------------------------------------------
$MENU_NTF_ETC:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$repeat_menu:
$	num = 0
$!
$	Menu_name = "NTF output - ETC"
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	field1[0,35] := "LENGTH  - XY coord length"
$	field2[0,13] := "''IMENU$v_ntf_xylen'"
$	field3[0,23] := "(default ''IMENU$d_ntf_xylen')"
$	num = num+1
$	Line'num' = field1 + field2 + field3
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	field1[0,35] := "MULT    - XY scale factor"
$	field2[0,13] := "''IMENU$v_ntf_xymult'"
$	field3[0,23] := "(default ''IMENU$d_ntf_xymult')"
$	num = num+1
$	Line'num' = field1 + field2 + field3
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	field1[0,35] := "ZMULT   - Z  scale factor"
$	field2[0,13] := "''IMENU$v_ntf_zmult'"
$	field3[0,23] := "(default ''IMENU$d_ntf_zmult')"
$	num = num+1
$	Line'num' = field1 + field2 + field3
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	field1[0,35] := "ZDATUM  - Z  origin"
$	field2[0,13] := "''IMENU$v_ntf_zdatum'"
$	field3[0,23] := "(default ''IMENU$d_ntf_zdatum')"
$	num = num+1
$	Line'num' = field1 + field2 + field3
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	field1[0,35] := "COPYRT  - Overriding copyright"
$	if IMENU$v_ntf_copyright.eqs."" then field2[0,13] := "unset"
$	if IMENU$v_ntf_copyright.nes."" then -
		field2[0,13] := "''IMENU$v_ntf_copyright"
$	if IMENU$d_ntf_copyright.eqs."" then field3[0,23] := "(default unset)"
$	if IMENU$d_ntf_copyright.nes."" then -
		field3[0,23] := "(default ''IMENU$d_ntf_copyright')"
$	num = num+1
$	Line'num' = field1 + field2 + field3
$!
$! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
$	Line_count = num
$!
$	CtrlZ = "return you to the ''P1' menu"
$	CtrlC = "return you to the TOP-LEVEL menu"
$!
$	call DISPLAY_MENU
$	if .not.$status then exit '$status'
$!
$ask_option:           
$	call ASK  "Choose the option you want:"
$!
$	if .not.$status then exit '$status'
$	if IMENU$RESULT.eqs."?" then goto repeat_menu
$ 	if IMENU$RESULT.eqs.""  then goto ask_option
$!
$! tidy up the reply
$!
$	answ = f$edit(IMENU$RESULT,"COMPRESS,TRIM,UNCOMMENT,UPCASE")
$!
$! extract the keyword from it - assume that it's ended by a space
$!
$	key = f$element(0," ",answ)
$	if key.eqs."" then goto ask_option
$	if f$length(key).ge.2 then goto key_length_OK
$	   ws "%IMENU-E-KEYWORD, please type at least 2 characters"
$	   goto ask_option
$key_length_OK:
$!
$! and also get the rest of the line (if any)
$!
$	rest = f$extract(f$length(key),f$length(answ),answ)
$!
$ 	if f$locate( key, "LENGTH"  ).eq.0 then goto do_xylen
$ 	if f$locate( key, "MULT"    ).eq.0 then goto do_xymult
$ 	if f$locate( key, "ZMULT"   ).eq.0 then goto do_zmult
$ 	if f$locate( key, "ZDATUM"  ).eq.0 then goto do_zdatum
$ 	if f$locate( key, "COPYRT"  ).eq.0 then goto do_copyright
$!
$invalid_option:
$	ws "%IMENU-I-INVALID, I don't understand ""''key'"""
$	goto ask_option
$!
$! ............................................................................
$! and get the relevant value
$!
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_xylen:
$!
$	call ASK_INTEGER "Length of X,Y coords:" 5 12 "''rest'"
$	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.eqs."" then IMENU$v_ntf_xylen == IMENU$d_ntf_xylen
$	if IMENU$RESULT.nes."" then IMENU$v_ntf_xylen == IMENU$RESULT
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_xymult:
$!
$	call ASK "Multiplication factor for X,Y coords:"  "''rest'"
$	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.eqs."" then IMENU$v_ntf_xymult == IMENU$d_ntf_xymult
$	if IMENU$RESULT.nes."" then IMENU$v_ntf_xymult == IMENU$RESULT
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_zmult:
$!
$	call ASK "Multiplication factor for Z values:"  "''rest'"
$	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.eqs."" then IMENU$v_ntf_zmult == IMENU$d_ntf_zmult
$	if IMENU$RESULT.nes."" then IMENU$v_ntf_zmult == IMENU$RESULT
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_zdatum:
$!
$	call ASK "Origin (datum) for Z values:"  "''rest'"
$	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.eqs."" then IMENU$v_ntf_zdatum == IMENU$d_ntf_zdatum
$	if IMENU$RESULT.nes."" then IMENU$v_ntf_zdatum == IMENU$RESULT
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$do_copyright:
$!
$	call ASK "Copyright date for all drawings (as yyyymmdd):"  "''rest'"
$	if .not.$status then exit '$status'
$!
$	if IMENU$RESULT.nes."" then IMENU$v_ntf_copyright == IMENU$RESULT
$	if IMENU$RESULT.eqs."" -
		then IMENU$v_ntf_copyright == IMENU$d_ntf_copyright
$	goto repeat_menu
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$!
$	ENDSUBROUTINE		! MENU_NTF_ETC

$! ============================================================================
$! NTF_INPUT
$! To perform input from NTF on tape to the Informap system
$!
$! NOTE that WARNING returns from the LSL programs are treated as SUCCESSes
$! ----------------------------------------------------------------------------
$NTF_INPUT:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$	had_control_y = FALSE
$	got_directory = FALSE
$	tape_attached = FALSE
$!
$ 	Menu_name = "NTF input"
$	CtrlC     = "terminate the input operation"
$!
$	call DISPLAY_HEADER
$	if .not.$status then exit '$status'
$!
$! so we are ready to start
$! - note that we wil only check whether they have used control-C when
$!   it is convenient for ourselves
$!
$	on control_y then had_control_y = TRUE
$!
$! ensure that we will be able to use the transfer IFF directory
$!
$	call lock_directory  "from NTF to Informap"
$	if .not.$status then goto exit_neatly
$	got_directory = TRUE
$!
$! if we are using a tape drive, attempt to get it for ourselves
$! if we are using a file, then check that it exists
$!
$	if IMENU$v_is_tape then goto get_drive
$!
$	   NTF_input = "LSL$DATA:''IMENU$v_file'.NTF"
$	   if f$search(NTF_input).nes."" then goto got_our_input
$	      ws "%IMENU-E-NOFILE, input file ''IMENU$v_file' does not exist"
$	      goto exit_neatly
$!
$get_drive:
$	   call attach_tape  "NTF"
$	   if .not.$status then goto exit_neatly
$	   tape_attached = TRUE
$	   NTF_input = IMENU$v_drive
$!
$got_our_input:
$!
$! and let the system handle control-C for us again
$!
$	on control_y     then goto exit_neatly
$	if had_control_y then goto exit_neatly
$!
$! at last, we can actually try running a program!
$!
$	wsb
$	ws "[1mReading the NTF data from ''NTF_input'[0m"
$	wsb
$!
$	ntf2i  'NTF_input' /log/output=SYS$OUTPUT:
$!
$	if  $status               then goto ntf2i_ok
$	if ($status.and.%x7).eq.0 then goto ntf2i_ok	! treat W as S
$!
$	   ws "%IMENU-E-NTF2I, error in reading from NTF"
$	   if f$search("LSL$IF:*.IFF",1).eqs."" then goto exit_neatly
$	      wsb
$	      ws "Some files have been read"
$	      call ASKNO "Do you want to try transferring them to Informap?"
$	      if IMENU$RESULT.eqs."NO"  then goto exit_neatly
$!
$! so we have finished with the magnetic tape
$! - note that we treat the release of the tape as an indivisible operation
$!
$ntf2i_ok:
$	if .not.tape_attached then goto no_need_to_detach
$	   on control_y then had_control_y = TRUE
$	   call detach_tape
$	   tape_attached = FALSE
$	   on control_y     then goto exit_neatly
$	   if had_control_y then goto exit_neatly
$no_need_to_detach:
$!
$! and we are now ready to output the files we have read
$! to the Informap system
$!
$	wsb
$	ws "[1mWriting data from the intermediate directory to Informap[0m"
$	wsb
$!
$next_file:
$	file = f$search("LSL$IF:*.IFF",2)
$	if file.eqs."" then goto no_more_files
$	   name = f$parse(file,,,"NAME")
$!
$	   i2imap  'file'  /schema='IMENU$v_schema' -
		   /parameter='f$trnlnm("LSL$LOOKUP")''IMENU$v_params' -
		   /quiet
$!
$	   if  $status               then goto i2imap_ok
$	   if ($status.and.%x7).eq.0 then goto i2imap_ok
$!
$	      ws "%IMENU-E-I2IMAP, error writing file ''name' to Informap"
$	      ws "-IMENU-I-CARRYON, trying to carry on"
$i2imap_ok:
$	   goto next_file
$!
$no_more_files:
$	wsb
$	ws "[1mEnd of transfer[0m"
$	wsb
$!
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$! come here to tidy up before leaving. Note that we will continue even if
$! they type control-C (we don't want to get into a loop!)
$!
$exit_neatly:
$	on control_y then continue
$	if .not.got_directory then goto no_need_to_delete
$	   if f$search("LSL$IF:*.IFF",3).nes."" then delete LSL$IF:*.IFF;*
$	   call unlock_directory
$no_need_to_delete:
$	if tape_attached then call detach_tape
$!
$	call PRESS_RETURN
$	exit '$status'
$	ENDSUBROUTINE		! NTF_INPUT

$! ============================================================================
$! NTF_OUTPUT
$! To perform output from the Informap system to NTF on tape
$!
$! NOTE that WARNING returns from the LSL programs are treated as SUCCESSes
$! ----------------------------------------------------------------------------
$NTF_OUTPUT:                
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$	had_control_y = FALSE
$	got_directory = FALSE
$	tape_attached = FALSE
$	got_inlist    = FALSE
$!
$ 	Menu_name = "NTF output"
$	CtrlC     = "terminate the output operation"
$!
$	call DISPLAY_HEADER
$	if .not.$status then exit '$status'
$!
$! so we are ready to start
$! - note that we wil only check whether they have used control-C when
$!   it is convenient for ourselves
$!
$	on control_y then had_control_y = TRUE
$!
$! ensure that we will be able to use the transfer IFF directory
$!
$	call lock_directory  "from Informap to NTF"
$	if .not.$status then goto exit_neatly
$	got_directory = TRUE
$!
$! if we are using a tape drive, then attempt to get it for ourselves
$!
$	if IMENU$v_is_tape then goto get_the_tape
$	   NTF_output = "''f$trnlnm(""LSL$DATA"")'''IMENU$v_file'.NTF"
$  	   goto got_our_output
$get_the_tape:
$	   call attach_tape  "NTF"
$	   if .not.$status then goto exit_neatly
$	   tape_attached = TRUE
$	   NTF_output = IMENU$v_drive
$got_our_output:
$!
$! and let the system handle control-C for us again
$!
$	on control_y     then goto exit_neatly
$	if had_control_y then goto exit_neatly
$!
$! at last, we can actually try running a program!
$! - read a drawing from the Informap system into an IFF file
$!
$	wsb
$	ws "[1mWriting data from Informap to the intermediate directory[0m"
$	wsb
$!
$! we use the local symbol count to maintain a note of which drawing we
$! are dealing with. NOTE that it is incremented in such a way that it
$! is set to the number of drawings for transfer when we have finished
$! reading from Informap
$!
$ 	count = 0
$!
$! we must also open a file in which to list the drawings as we read them
$! - this will be used as the /INPUT_FILE file for I2NTF
$!
$	on control_y then had_control_y = TRUE
$	   create  lsl$if:inlist.i2ntf_lis
$	   open/write/read  IMENU$INLIST  lsl$if:inlist.i2ntf_lis
$	   got_inlist = TRUE
$	on control_y     then goto exit_neatly
$	if had_control_y then goto exit_neatly
$!
$next_drawing:
$!
$	   if count.eq.IMENU$v_drawing_count then goto no_more_drawings
$	   count = count +1
$!
$ 	   drawing = IMENU$v_drawing'count	! it's this drawing
$!
$	   write IMENU$INLIST "''drawing'"	! add it to the input list
$!
$	   imap2i  'drawing' -
		   /schema='IMENU$v_schema' -
		   /parameter='f$trnlnm("LSL$LOOKUP")''IMENU$v_params'
$!
$	   if  $status               then goto next_drawing
$	   if ($status.and.%x7).eq.0 then goto next_drawing
$!
$! cope with the difficult case of the transfer failing
$!
$	   ws "%IMENU-E-IMAP2I, error reading drawing ''drawing' from Informap"
$	   if f$search("LSL$IF:*.IFF",1).eqs."" then goto exit_neatly
$	      wsb
$	      ws "Some drawings have been read"
$	      call ASKNO "Do you want to try transferring them to NTF?"
$	      if IMENU$RESULT.eqs."NO" then goto exit_neatly
$!
$no_more_drawings:
$!
$	close IMENU$INLIST		! close the input list file
$!
$! and write the files to tape in NTF form
$!
$	wsb
$	ws "[1mWriting NTF data to ''NTF_output'[0m"
$	wsb
$!
$! work out whether we are specifying the overriding copyright
$!
$	copyright = ""
$	if IMENU$v_ntf_copyright.nes."" -
	   then copyright = "/copyright=''IMENU$v_ntf_copyright'"
$!
$	i2ntf/input_list=lsl$if:inlist.i2ntf_lis -
	'NTF_output'                             -
	/recipient="''IMENU$v_ntf_recipient'"    -
	/donor  ="''IMENU$v_ntf_donor'"          -
	/level  ='f$integer(IMENU$v_ntf_level)'  -
	/serial ='f$integer(IMENU$v_ntf_serial)' -
	/xy_len ='IMENU$v_ntf_xylen'             -
	/xy_mult='IMENU$v_ntf_xymult'            -
	/z_mult ='IMENU$v_ntf_zmult'             -
	/z_datum='IMENU$v_ntf_zdatum'            -
	/density='f$integer(IMENU$v_density)'    -
	'copyright'/log/output=SYS$OUTPUT:
$!
$	if  $status               then goto i2ntf_ok
$	if ($status.and.%x7).eq.0 then goto i2ntf_ok
$!
$	   ws "%IMENU-E-I2NTF, error in writing to NTF"
$	   goto exit_neatly
$i2ntf_ok:
$!
$	wsb
$	ws "[1mEnd of transfer[0m"
$	wsb
$!
$! _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
$! come here to tidy up before leaving. Note that we will continue even if
$! they type control-C (we don't want to get into a loop!)
$!
$exit_neatly:
$ 	on control_y then continue
$!
$ 	if f$trnlnm("IMENU$INLIST").nes."" then close IMENU$INLIST
$	if got_inlist then delete lsl$if:inlist.i2ntf_lis;*
$!
$	if .not.got_directory then goto no_need_to_delete
$	   if f$search("LSL$IF:*.IFF",3).nes."" then delete LSL$IF:*.IFF;*
$	   call unlock_directory
$no_need_to_delete:
$	if tape_attached then call detach_tape
$!
$	call PRESS_RETURN
$	exit '$status'
$	ENDSUBROUTINE		! NTF_OUTPUT

$! ============================================================================
$! MENU_OPTIONS
$! To change some facet of LSLIMI_MENU's behaviour
$!
$! Arguments:
$!		P1		the previous menu's name
$!
$! ----------------------------------------------------------------------------
$MENU_OPTIONS:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$repeat_menu:
$  	Menu_name  = "OPTIONS"
$	Line_count = 4
$ 	Line1 = "WIDTH   - change screen width"
$	Line2 = "MENUS   - display menus"
$	Line3 = "NOMENUS - don't display menus"
$	Line4 = "DEFAULT - put all options back to the normal values"
$!
$  	CtrlZ = "return you to the ''P1' menu"
$	CtrlC = "return you to the TOP-LEVEL menu"
$!
$	call DISPLAY_MENU
$	if .not.$status then exit '$status'
$!
$ask_option:
$	call ASK  "Choose the option you want:"
$!
$	if .not.$status then exit '$status'
$	if IMENU$RESULT.eqs."?" then goto repeat_menu
$ 	if IMENU$RESULT.eqs.""  then goto ask_option
$!
$	answ := 'IMENU$RESULT		! upper-case the answer
$!
$ 	if f$locate( answ, "WIDTH"   ).eq.0 then goto do_width 
$ 	if f$locate( answ, "MENUS"   ).eq.0 then goto do_menus
$ 	if f$locate( answ, "NOMENUS" ).eq.0 then goto do_nomenus
$ 	if f$locate( answ, "DEFAULT" ).eq.0 then goto do_default
$!
$	ws "%IMENU-I-INVALID, I don't understand ""''answ'"""
$	goto ask_option
$!
$! ............................................................................
$! and perform the required action
$!
$!
$do_width:
$	call ASK  "What width (normal choices are 80 or 132)?"
$!
$	if .not.$status then exit '$status'
$	if IMENU$RESULT.eqs."?" then goto repeat_menu
$ 	if IMENU$RESULT.eqs.""  then goto ask_options
$	if f$type(IMENU$RESULT).eqs."INTEGER" then goto set_width
$	   ws "%IMENU-E-NOTINT, reply must be an integer"
$	   goto repeat_menu
$set_width:
$	IMENU$WIDTH == IMENU$RESULT
$	set terminal/width='IMENU$WIDTH'
$	exit '$status'
$!
$do_menus:
$	IMENU$NO_MENUS == FALSE
$	exit 'SUCCESS'
$!
$do_nomenus:
$	IMENU$NO_MENUS == TRUE
$	ws "%IMENU-I-NOMENUS, menus will now be suppressed"
$	ws "-IMENU-I-QMARK, use the ""?"" command to show a menu"
$	call PRESS_RETURN
$	exit '$status'
$!
$do_default:
$	IMENU$NO_MENUS == FALSE
$	IMENU$WIDTH    == 80
$	set terminal/width='IMENU$WIDTH'
$	exit '$status'
$!
$	ENDSUBROUTINE		! MENU_OPTIONS

$! ============================================================================
$! DISPLAY_MENU
$! display the current menu, in standard form
$! ----------------------------------------------------------------------------
$DISPLAY_MENU:
$	SUBROUTINE
$	set noon
$  	on control_y then exit 'HAD_CTRL'
$!
$	IMENU$SCREEN == TRUE	! remember we're playing with the screen
$!
$! assemble and output the header line
$!
$	line = ""
$	line[0,'IMENU$WIDTH'] := "''Menu_name' menu"
$!
$! ESC [?4l		ensure that we are in JUMP scroll mode
$! ESC [2J		erase screen
$! ESC [7m		display in reverse video
$! ESC [1;1H		move cursor to line 1, column 1
$!
$	ws "[?4l[2J[7m[1;1H",line	! output the whole lot
$!
$! ESC [0m		display in normal mode
$! ESC [3;r		scroll from line 3 to bottom of screen
$! ESC [2;1H		move cursor to line 2, column 1
$!
$	ws "[0m[3;r[2;1H"
$!
$! if menus are suppressed, and the user did not just reply to ASK with
$! a question mark, then that is all the text that we want to output
$!
$	if IMENU$NO_MENUS.and.IMENU$RESULT.nes."?" then exit 'SUCCESS'
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
$ 	ws "<CTRL/Z> will ''CtrlZ'"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! take out the "?" message                                                   !
$!                                                                            !
$!!!!	ws "      ?  will display the current menu again"                     !
$!!!! 	number_of_lines = 2 + Line_count + 4 + 1                              !
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! work out how many lines that took
$!
$ 	number_of_lines = 2 + Line_count + 3 + 1
$	scroll = number_of_lines + 1
$!
$! ESC ['n';r		scroll from line 'n' to bottom of screen
$! ESC ['n';1H		move to line 'n', column 1
$!
$	ws "[''scroll';r[''number_of_lines';1H"
$!
$	exit
$	ENDSUBROUTINE		! DISPLAY_MENU

$! ============================================================================
$! DISPLAY_HEADER
$! display a banner for the current operation, in a form similar to that
$! used by DISPLAY_MENU
$! ----------------------------------------------------------------------------
$DISPLAY_HEADER:
$	SUBROUTINE
$	set noon
$  	on control_y then exit 'HAD_CTRL'
$!
$	IMENU$SCREEN == TRUE	! remember we're playing with the screen
$!
$! assemble and output the header line
$!
$	line = ""
$	line[0,'IMENU$WIDTH'] := "''Menu_name'"
$!
$! ESC [?4l		ensure that we are in JUMP scroll mode
$! ESC [2J		erase screen
$! ESC [7m		display in reverse video
$! ESC [1;1H		move cursor to line 1, column 1
$!
$	ws "[?4l[2J[7m[1;1H",line	! output the whole lot
$!
$! ESC [0m		display in normal mode
$! ESC [3;r		scroll from line 3 to bottom of screen
$! ESC [2;1H		move cursor to line 2, column 1
$!
$	ws "[0m[3;r[2;1H"
$!
$! if menus are suppressed, and the user did not just reply to ASK with
$! a question mark, then that is all the text that we want to output
$!
$	if IMENU$NO_MENUS.and.IMENU$RESULT.nes."?" then exit 'SUCCESS'
$!
$! we just outout a message about what will happen if they use control-C
$!
$	ws "<CTRL/C> will ''CtrlC'"
$!
$! work out how many lines that took
$!
$ 	number_of_lines = 2 + 1 + 1
$	scroll = number_of_lines + 1
$!
$! ESC ['n';r		scroll from line 'n' to bottom of screen
$! ESC ['n';1H		move to line 'n', column 1
$!
$	ws "[''scroll';r[''number_of_lines';1H"
$!
$	exit
$	ENDSUBROUTINE		! DISPLAY_HEADER

$! ============================================================================
$! DISPLAY_FILES
$! display the files in the current directory
$!
$!	P1	list of files to show
$!		eg "*.DIR,*.RNO" or "*.SPEC,*.HDR,*.RNO"
$!		(note that .RNO should always be last in any list)
$!
$!	P2	TRUE if to show the file type, as well as the name
$!
$! ----------------------------------------------------------------------------
$DISPLAY_FILES:
$	SUBROUTINE
$	set noon
$  	on control_y then exit 'HAD_CTRL'
$!
$	IMENU$SCREEN == TRUE	! remember we're playing with the screen
$!
$	list = f$edit( P1, "UPCASE,COLLAPSE" )
$!
$! assemble and output the header line
$!
$	line = ""
$	directory = f$trnlnm("HERE")
$	line[0,'IMENU$WIDTH'] := "''Menu_name' menu for directory ''directory'"
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
$	ws "[?4l[2J[7m[1;1H",line	! output the whole lot
$!
$! ESC [0m			display in normal mode
$! ESC [3;''window_bottom'r	scroll from line 3 to line 21
$! ESC [2;1H		  	move cursor to line 2, column 1
$!
$	ws "[0m[3;''window_bottom'r[2;1H"
$!
$! if menus are suppressed, and the user did not just reply to ASK with
$! a question mark, then that is all the text that we want to output
$!
$	if IMENU$NO_MENUS.and.IMENU$RESULT.nes."?" then exit 'SUCCESS'
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
$	line[0,'IMENU$WIDTH'] := " "	! start with it empty
$!
$! the file-specs to search on are a comma separated list - search
$! for each one in turn
$!
$	lookfor = f$element(which,comma,list)
$	which   = which +1
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
$ 	   if size+char.le.IMENU$WIDTH then goto add_file
$!
$	      ws line				! write the full line
$	      lcount = lcount+1			! count it
$	      line[0,'IMENU$WIDTH'] := " "	! empty the line
$	      char   = 0			! so no chars in it yet
$!
$add_file: line[char,flen] := 'file		! add the file to the line
$	   char   = char + size			! and count its characters
$	   fcount = fcount + 1			! and count it
$	   goto next_file			! get the next file
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
$	      line[0,'IMENU$WIDTH'] := " "
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
$	   ws "%IMENU-I-EMPTY, no files found"
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
$	ws "[''scroll';r[''number_of_lines';1H"
$!
$	exit
$	ENDSUBROUTINE		! DISPLAY_FILES

$! ============================================================================
$! UNSET_SCREEN
$! remove our constraints from the screen
$! ----------------------------------------------------------------------------
$UNSET_SCREEN:
$	SUBROUTINE
$	set noon
$	on control_y then continue
$!
$! ESC [1;r		scroll from line 1 to the bottom of the screen
$! ESC [0m		display in normal mode
$! ESC [24;1H		move cursor to line 24, column 1
$!
$	ws "[1;r[0m[24;1H"
$!
$	IMENU$SCREEN == FALSE	! note that we've undone this
$!
$	exit
$	ENDSUBROUTINE		! UNSET_SCREEN

$! ============================================================================
$! PRESS_RETURN
$! wait for the user to press RETURN
$! ----------------------------------------------------------------------------
$PRESS_RETURN:
$	SUBROUTINE
$	set noon
$  	on control_y then exit 'HAD_CTRL'
$!
$! ESC [7m		display in reverse video
$! ESC [0m		display in normal mode
$!
$	read/end=exit_ok/error=exit_ok -
	    /prompt="[7mPress <RETURN> to continue: [0m"  sys$command  answ
$!
$exit_ok:
$	exit 'SUCCESS'
$	ENDSUBROUTINE		! PRESS_RETURN

$! ============================================================================
$! CHECK_INIFILE
$! look for an initialisation file
$! ----------------------------------------------------------------------------
$CHECK_INIFILE:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$! check whether the user has defined an initialisation file to be obeyed
$! - look for the logical name LSL$IMENU_INITIALISE
$!
$	inifile = f$trnlnm("LSL$IMENU_INITIALISE")
$	if inifile.eqs."" then goto no_init_file
$!
$! and check that it does indeed point to a file that exists
$!
$	if f$search(inifile).eqs."" then goto no_init_file
$!
$! so we can obey the file - tell the user, and then do it
$!
$	ws "%IMENU-I-INIFILE, obeying LSL$IMENU_INITIALISE file "
$	ws "-IMENU-I-ININAME, obeying ""''inifile'"""
$!
$! the file can sensibly be used to set any of the following global symbols
$! - symbols that control the menus (menu options)
$!
$!	IMENU$NO_MENUS		== TRUE		(default is FALSE)
$!	IMENU$WIDTH		== 132		(default is 80)
$!
$!	and all of the IMENU$v_xxx global symbols
$!
$!
$	@'inifile'
$	if .not.$status then exit 'FAILURE'
$!
$! if the user has altered IMENU$WIDTH, then note that change
$!
$	if IMENU$WIDTH .ne. 80 then set terminal/width='IMENU$WIDTH'
$!
$no_init_file:
$	exit 'SUCCESS'
$	ENDSUBROUTINE
