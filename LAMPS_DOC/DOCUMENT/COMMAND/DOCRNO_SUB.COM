$	set noon				! ignore $status settings
$	on control_y then exit 'HAD_CTRL'	! <CTRL/Y> is fatal
$!
$! *****************************************************************************
$! DOCRNO_SUB - this command file is called (via @) to runoff a file,
$!		including producing contents and index if required
$!
$! It is currently called by either
$!
$!		LSL$DOC_COMMAND:DOCRNO
$!	or by	LSL$DOC_COMMAND:DOCUMENT
$!
$! Copyright (C) Laser-Scan Laboratories Ltd, Cambridge, England
$! Author TJ Ibbs, 15 May 1987 sqq
$!
$! *****************************************************************************
$! define various symbols that are private to this command file
$!        
$	do_contents = FALSE	! unset these just in case we
$	do_index    = FALSE	! go to end_it before they're set
$!
$! -----------------------------------------------------------------------------
$! work out exactly how we are running this off
$!
$ 	if DOC$PRINTER.nes.DOC$LQprinter then goto not_LQprinter
$	   DOC$qualifiers = DOC$qualifiers + "/BACKSPACE/BOLD=3"
$	   goto printer_recognised
$!
$not_LQprinter:
$ 	if DOC$PRINTER.nes.DOC$LN03printer then goto not_LN03printer
$	   DOC$qualifiers = DOC$qualifiers + "/DEVICE=LN03"
$	   goto printer_recognised
$!
$not_LN03printer:
$	if DOC$PRINTER.nes.DOC$Lineprinter then goto not_Lineprinter
$	   goto printer_recognised
$!
$not_Lineprinter:
$	if DOC$PRINTER.nes.DOC$Terminal then goto not_Terminal
$	   DOC$qualifiers = DOC$qualifiers + "/OUTPUT=TT:"
$	   goto printer_recognised
$!
$not_Terminal:
$	if DOC$PRINTER.nes.DOC$Noprinter then goto not_Noprinter
$	   DOC$qualifiers = DOC$qualifiers + "/NOOUTPUT"
$	   goto printer_recognised
$!
$not_Noprinter:
$	ws "%DOC-E-BADPRINT, don't recognise printer option ""''DOC$PRINTER'"""
$	exit 'FAILURE'
$!
$printer_recognised:
$! .............................................................................
$! if the user wants a subset of pages, determine the subset
$!
$	call DOCASK "Do you want to select particular pages?"
$	if .not.$status then exit '$status'
$	if .not.DOC$RESULT then goto do_whole_thing
$	   wsb
$	   ws "			Specify the pages required"
$	   wsb
$	   ws "Use the standard RUNOFF syntax - for instance" + -
	      " 15-9:15-9 or 15-18:15-27"
$	   wsb
$!
$	   call DOCASK "Which pages do you want?"
$	   if .not.$status then exit '$status'
$!
$	   if DOC$RESULT.nes."" then -
	      DOC$qualifiers = DOC$qualifiers + "/PAGES=(" + DOC$RESULT + ")"
$!
$do_whole_thing:
$!
$! -----------------------------------------------------------------------------
$! check whether the user has required a contents - search for
$!
$!	.REQuire  "filename.RNT"
$!
$! - note that we point our output streams to NL: so that the
$! "No strings found" error message will be hidden
$!
$	assign/user nl: sys$output
$	assign/user nl: sys$error
$!
$	search 'DOC$file'.RNO/nooutput/nohead/nolog/match=and  ".REQ",".RNT"
$	do_contents = $status.eq.1	! 1 => success, found the strings
$!
$! now perform a similar function for the index - we look for
$!
$!	.REQUIRE  "filename.RNX"
$!
$	assign/user nl: sys$output
$	assign/user nl: sys$error
$!
$	search 'DOC$file'.RNO/nooutput/nolog/nohead/match=and  ".REQ",".RNX"
$	do_index = $status.eq.1		! 1 => success, found the strings
$!
$! -----------------------------------------------------------------------------
$! if we have one of these, then we must run off the file to generate
$! a contents / index
$!
$	if .not.do_contents .and. .not.do_index then goto do_runoff
$!
$! are we going to want running page numbers?
$! if there are .CHAPTER statements, then we don't, but otherwise we do
$!
$	assign/user nl: sys$output
$	assign/user nl: sys$error
$!
$	search 'DOC$file'.RNO/nohead/nooutput/nolog  ".CH"
$	runpag = $status.ne.1		! 1 => 'success' - found ".CH"
$!
$	numbering = ""
$	if runpag then numbering = "/page_numbers=running"
$!
$! check now whether we actually have an old contents/index to be included
$! - in the current version of DSR, it must have an old one for the .REQUIRE
$!   so if there isn't one, we create a dummy file
$!
$	contents = ""
$	index    = ""
$	if .not.do_contents then goto dont_check_contents
$	   contents = "/contents"
$	   if f$search(DOC$file+".RNT").nes."" then goto dont_check_contents
$	      on control_y then continue
$	         open/write cdum 'DOC$file'.RNT
$	         write cdum "Dummy CONTENTS file"
$	         close cdum
$	      on control_y then exit 'HAD_CTRL'
$dont_check_contents:
$!
$	if .not.do_index then goto dont_check_index
$	   index = "/index"
$	   if f$search(DOC$file+".RNX").nes."" then goto dont_check_index
$	      on control_y then continue
$	         open/write idum 'DOC$file'.RNX
$	         write idum "Dummy INDEX file"
$	         close idum
$	      on control_y then exit 'HAD_CTRL'
$dont_check_index:
$! -----------------------------------------------------------------------------
$! and now do the actual running off
$!
$do_runoff:
$	want_section_numbering = TRUE
$!
$	@lsl$doc_command:runoff_file
$	exit '$status'

$! =========================================================================
$! DOCASK
$! Called to ask the user a question
$!
$!	P1		the question to ask
$!    	DOC$RESULT	the answer to the question
$! -------------------------------------------------------------------------
$DOCASK:
$	SUBROUTINE
$	set noon
$	on control_y then exit 'HAD_CTRL'
$!
$! make all questions be of a standard length
$!
$	question = P1 + " "
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
$	ws "%DOC-E-ASKERR, error in reading response"
$	exit 'FAILURE'
$!
$      	ENDSUBROUTINE		! DOCASK
