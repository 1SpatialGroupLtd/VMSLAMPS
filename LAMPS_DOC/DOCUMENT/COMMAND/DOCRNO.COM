$	set noon				! ignore $status settings
$	on control_y then exit 			! <CTRL/Y> is fatal
$!
$! *****************************************************************************
$! DOCRNO - this command file is to run a file off,
$!	    including producing contents and index if required
$!
$! Arguments are:
$!
$!	P1	file to runoff
$!	P2	the printer it will go to - a single letter chosen
$!		from
$!			P  = Line Printer
$!			Q  = Qume
$!			L  = LN03
$!			T  = Terminal
$!
$!	P3	any other qualifiers required
$!
$! Copyright (C) Laser-Scan Laboratories Ltd, Cambridge, England
$! Author TJ Ibbs, 18 May 1987
$!
$! *****************************************************************************
$!
$	ws  = "write sys$output "
$	wsb = "write sys$output """""
$!
$	wsb
$	ws "			    DOCRNO"
$	wsb
$	ws "    Laser-Scan simple runoff procedure (v1.2, 18-March-1988)"
$	wsb
$!
$! check whether they are asking for help
$!
$	if P1.nes."?" then goto no_help_required
$	   gosub help_user
$	   exit
$!
$no_help_required:
$! .............................................................................
$! define various abbreviations
$!
$	TRUE  = 1
$	FALSE = 0
$!
$! return values (for $status) from subroutines, etc
$! (note that HAD_EOF and HAD_CTRL are also 'failures')
$!
$	SUCCESS	 = %x10000001		! routine succeeded
$	FAILURE	 = %x10000000		! routine failed
$	HAD_EOF  = %x10000002		! user replied <CTRL/Z> to a question
$	HAD_CTRL = %x10000004		! user interrupted with a <CTRL/Y>
$!
$! we don't have a CtrlC message (as would have been defined in DOCUMENT
$! or STANDARD_RNO)
$!
$	CtrlC = ""
$!
$! and printers that we support
$!
$	DOC$LQprinter   = "LETTER QUALITY PRINTER"
$	DOC$Lineprinter = "LINE PRINTER"
$	DOC$Terminal    = "TERMINAL"
$	DOC$Noprinter   = "NOTHING TO PRINT"
$	DOC$LN03printer = "LN03 PRINTER"
$!
$! and a question length
$!
$	a$len = 45
$!
$! defined our qualifiers
$!
$	DOC$qualifiers = P3
$!
$! we also have some global symbols that we use
$!
$	on control_y then continue
$	   DOC$RESULT  == 0
$	   DOC$PRINTER == DOC$Noprinter
$	   DOC$SMOOTH  == TRUE
$	on control_y then goto final_exit
$!
$! .............................................................................
$! so let us find out what the user wants to do
$! - what file is wanted?
$!
$	if P1.eqs."" then goto ask_for_file
$	   DOC$file := 'P1
$	   goto got_filespec
$!
$ask_for_file:
$	call ASKRNO 'a$len' "Runoff what file?"
$	if .not.$status then goto final_exit
$	if DOC$RESULT.eqs."" then goto final_exit
$!
$	DOC$file := 'DOC$RESULT
$!
$! now check that they have not specified an extension (other than an
$! optional .RNO)
$!
$got_filespec:
$ 	ftype = f$parse(DOC$file,,,"TYPE")
$	fvers = f$parse(DOC$file,,,"VERSION")
$	if ftype.eqs."." .and. fvers.eqs.";" then goto file_is_OK
$	   line = "%DOC-E-FILE, file type or version was specified ("""
$	   if ftype.nes."." then line = line + ftype
$	   if fvers.nes.";" then line = line + fvers
$	   ws line + """)"
$	   ws "-DOC-I-ONLY," + -
	      " do not specify the file type (must be .RNO) or the version"
$	   goto final_exit
$!
$file_is_OK:
$	if f$search(DOC$file+".RNO").nes."" then goto file_exists
$	   ws "%DOC-I-NOFILE, file ""''DOC$file'.RNO"" does not exist"
$	   goto final_exit
$!
$file_exists:
$!
$! in order for lower routines (RUNOFF_FILE) to work, we must also define
$! DOC$original
$!
$	DOC$original = DOC$file
$!
$! .............................................................................
$! work out where it is to be runoff for
$!
$	P2 := 'P2		! upper case it
$!
$	if P2.eqs."P" then goto do_lineprinter
$	if P2.eqs."Q" then goto do_LQprinter
$	if P2.eqs."L" then goto do_LN03printer
$	if P2.eqs."T" then goto do_Terminal
$	if P2.nes.""  then ws "%DOC-W-LETTER, unknown destination letter" + -
  			      " ""''P2'"" - should be L,Q,P or T"
$!
$find_out_printer:
$!
$	call ASKRNO 'a$len' "For output on the LN03 laser printer?"
$	if .not.$status then goto final_exit
$	if .not.DOC$RESULT then goto not_to_LN03
$do_LN03printer:
$      	   DOC$PRINTER == DOC$LN03printer
$	   goto output_device_known
$!
$not_to_LN03:
$	call ASKRNO 'a$len' "For output on the Qume?"
$	if .not.$status then goto final_exit
$	if .not.DOC$RESULT then goto not_to_Qume
$do_LQprinter:
$	   DOC$PRINTER == DOC$LQprinter
$	   goto output_device_known
$!
$not_to_Qume:
$	call ASKRNO 'a$len' "For output on the lineprinter?"
$	if .not.$status then goto final_exit
$ 	if .not.DOC$RESULT then goto not_to_lineprinter
$do_Lineprinter:
$	   DOC$PRINTER == DOC$Lineprinter
$	   goto output_device_known
$!
$not_to_lineprinter:
$	call ASKRNO 'a$len' "Type the file at the terminal?"
$	if .not.$status then goto final_exit
$ 	if .not.DOC$RESULT then goto not_to_terminal
$do_Terminal:
$	    DOC$PRINTER == DOC$Terminal	! as we'll already have
$	    goto output_device_known
$!
$not_to_terminal:
$	ws "%DOC-E-NOOUTPUT, there are no more output devices"
$	ws "-DOC-I-TRYAGAIN, please try again"
$	goto find_out_printer
$!                             
$output_device_known:
$! .............................................................................
$! so we can now call our sub-procedure to do the actual work
$!
$	@lsl$doc_command:docrno_sub
$!
$! .............................................................................
$final_exit:
$	on control_y then continue
$	if "''DOC$RESULT'".eqs."" then goto no_globals_defined
$	   delete/symbol/global  DOC$RESULT
$	   delete/symbol/global  DOC$PRINTER
$	   delete/symbol/global  DOC$SMOOTH
$no_globals_defined:
$	exit

$! =========================================================================
$! HELP_USER
$! write out some help information for the user
$! -------------------------------------------------------------------------
$help_user:
$	set noon
$  	on control_y then goto final_exit
$!
$  	type sys$input:
This command file is designed for use in running off Laser-Scan documentation.
For running off standard documentation, use STANDARD_RNO instead - DOCRNO is
only intended for running off simple files.

The parameters it takes are:

	P1		the file to be runoff (note that no extension
			is allowed), or ? to get this information

	P2		where you will be printing the file after you
			have run it off - one of the letters

				P	for the lineprinter
				Q	for the Qume (letter quality printer)
				L	for the Agfa LED printer
				T	runoff to the Terminal

	P3		any other runoff qualifiers - eg "/NOSECTION_NUMBERS"

Note that this command procedure will not print the .MEM file that it produces.
If P2 option T is used, then no .MEM file is produced. If P1 and P2 are not
specified, then you will be asked appropriate questions instead.
$!
$	return

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
