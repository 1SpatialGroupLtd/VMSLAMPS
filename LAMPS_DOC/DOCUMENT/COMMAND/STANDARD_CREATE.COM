$	set noon				! ignore $status settings
$	on control_y then exit 			! <CTRL/Y> is fatal
$!
$! *****************************************************************************
$! STANDARD_CREATE - this command file is used to create a Laser-Scan standard
$!		     package environment
$!
$! Copyright (C) Laser-Scan Laboratories Ltd, Cambridge, England
$! Author TJ Ibbs, 11 May 1987 sqq
$!
$! *****************************************************************************
$!
$	ws  = "write sys$output "
$	wsb = "write sys$output """""
$!
$	wsb
$	ws "	     		    STANDARD_CREATE"
$	wsb
$	ws "    Laser-Scan standard documentation creation procedure" + -
	   " (v1.0, 18-May-1987)"
$	wsb
$!
$! -----------------------------------------------------------------------------
$! define our standard abbreviations
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
$! and a question length
$!
$	a$len = 40
$!
$! we also have some global symbols that we use
$!
$	on control_y then continue
$	   DOC$RESULT  == 0			! procedure return
$	on control_y then goto final_exit
$!
$! .............................................................................
$! check whether we have a package name
$!
$	DOC$package := 'P1
$	if DOC$package.nes."" then goto got_package_name
$!
$ask_for_package:
$	   call ASKRNO 'a$len' "Package to create:"
$	   if .not.$status then goto final_exit
$	   DOC$package := 'DOC$RESULT
$!
$got_package_name:
$!
$	DOC$package = f$edit( DOC$package, "COLLAPSE,UPCASE,UNCOMMENT" )
$!
$	call ASKRNO 'a$len' "Is package ""''DOC$package'"" correct?"
$	if .not.$status    then goto final_exit
$	if .not.DOC$RESULT then goto ask_for_package
$!
$! .............................................................................
$! so check that it does not exist already
$!
$	if   f$search( "LSL$DOC_ROOT:[000000]''DOC$package'.DIR" ).eqs."" -
	then goto new_package
$	   ws "%DOC-E-OLDPACKAGE, package ''DOC$package' already exists"
$	   ws "\LSL$DOC_ROOT:[''DOC$package']\"
$	   goto final_exit
$!
$! .............................................................................
$! so we are ready to call the command file
$!
$new_package:
$	@lsl$doc_command:standard_create_sub
$!
$! .............................................................................
$final_exit:
$	on control_y then continue
$	if "''DOC$RESULT'".eqs."" then goto no_globals defined
$	   delete/symbol/global  DOC$RESULT
$no_globals_defined:
$	exit

$! =========================================================================
$! ASKRNO
$! Called to ask the user a question
$!
$!	P1		the length to pad the question to
$!	P2		the question to ask - pad it with spaces
$!	DOC$RESULT	the answer to the question
$! -------------------------------------------------------------------------
$ASKRNO:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$! make all questions be of a standard length
$!
$	question[0,'P1'] := "''P2'"
$!
$! and ask the question
$!
$ask_again:
$	read/end_of_file=eof/error=ask_error -
	    /prompt="''question'" -
	    sys$command  answ
$!
$! if the result was a question mark, then ask the question again
$!
$	if answ.eqs."?" then goto ask_again
$!
$! otherwise return it
$!
$	DOC$RESULT == answ
$	exit 'SUCCESS'
$!
$! .............................................................................
$eof:	exit 'HAD_EOF'
$!
$ask_error:
$	ws "%RNO-E-ASKERR, error in reading response"
$	exit 'FAILURE'
$!
$	ENDSUBROUTINE		! ASKRNO
