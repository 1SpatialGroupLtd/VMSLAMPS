$	set noon				! ignore $status settings
$	on control_y then continue		! ignore <CTRL/Y>
$!
$! *****************************************************************************
$! RUNOFF_FILE - this command file is called (via @) to run a file off
$!
$! It is currently called by either
$!
$!		LSL$DOC_COMMAND:DOCRNO_SUB
$!	or by	LSL$DOC_COMMAND:STANDARD_RNO_SUB
$!
$! Copyright (C) Laser-Scan Laboratories Ltd, Cambridge, England
$! Author TJ Ibbs, 15 May 1987 sqq
$!
$!mod	Purge index and contents files			PGH	24-Apr-1990
$!
$! *****************************************************************************
$! the following are assumed already defined:
$!
$!		DOC$original		the name of the whole file
$!		DOC$file		the name of the file to runoff
$!		do_contents		true if we should
$!		do_index   		also true if we should
$!		want_section_numbering	true if we do
$!		DOC$qualifiers		the switches for RUNOFF
$!
$!		DOC$PRINTER	the printer it is destined for
$! 		DOC$RESULT	used to return the .MEM filespec
$!		DOC$SMOOTH	TRUE if to type with smooth scroll
$!
$!		CtrlC		if this is not "" then we have a
$!				message about what will happen when
$!				<CTRL/Y> is typed
$!
$!		HAD_CTRL	<CTRL/Y> status code
$!		SUCCESS		success  status code
$!		FAILURE		failure  status code
$!
$! Note that DOC$file is the name of the file we want to runoff. This will
$! typically either be the same as DOC$original, or it will be "PART_OF_" +
$! DOC$original. When producing a contents or index, we must always refer
$! to the whole document name, not the (possibly) partial name.
$!
$! *****************************************************************************
$! if we are logged in as DOC, then we should reduce our priority
$!
$	doc_user = f$getjpi("","USERNAME").eqs."DOC         "
$	if doc_user then set process/priority=4
$!
$! if we are being called from a procedure that handles <CTRL/Y>, then
$! change the action to be a local abort
$!
$	if CtrlC.eqs."" then goto CtrlC_is_OK
$	   ws "<CTRL/C> will abort the runoff"
$CtrlC_is_OK:
$	on control_y then goto had_control_y
$!
$! .............................................................................
$! if we don't want a contents or an index, then we can skip the next bit
$!
$	if .not.do_contents .and. .not.do_index then goto runoff_whole_thing
$!
$! otherwise, we must check
$! .............................................................................
$! do we want a contents? If we do, then we must ensure that we have a .RNT
$! file, so that the .REQUIRE in our file will be satisfied
$!
$	if .not.do_contents then goto dont_create_contents
$	   if   f$search("''DOC$original'.RNT").nes."" -
	   then goto dont_create_contents
$!
$! there is no contents file, so we must create a dummy one
$!
$	      create 'DOC$original'.RNT
CONTENTS file has not yet been produced by RUNOFF
$!
$dont_create_contents:
$! .............................................................................
$! do we want an index? If we do, then we must ensure that we have a .RNX
$! file, so that the .REQUIRE in our file will be satisfied
$!
$	if .not.do_index then goto dont_create_index
$	   if f$search("''DOC$original'.RNX").nes."" then goto dont_create_index
$!                       
$! there is no index file, so we must create a dummy one
$!             
$	      create 'DOC$original'.RNX
INDEX file has not yet been produced by RUNOFF
$!
$dont_create_index:
$! -----------------------------------------------------------------------------
$! so we can now produce the contents and/or index
$!
$	line = "Producing "
$	if do_contents              then line = line + "contents "
$	if do_contents.and.do_index then line = line + "and "
$	if do_index                 then line = line + "index "
$	ws line,"for ''DOC$file'"
$!
$! .............................................................................
$! produce the BRN intermediate file
$!
$	file_type = "intermediate"
$	runoff 'DOC$original' /intermediate/nooutput
$	if $status then goto done_intermediate
$!
$! .............................................................................
$runoff_error:
$	   ws "%DOC-E-RNOERR, error producing ''file_type' file"
$	   ws "%DOC-I-RNOALL, trying to runoff whole thing to show the error"
$	   goto runoff_whole_thing
$!
$done_intermediate:
$! .............................................................................
$! prepare the contents file
$!
$	if .not.do_contents then goto dont_do_contents
$	   file_type = "contents"
$	   sw = "/nosection_numbers"
$	   if want_section_numbering then sw = "/section_numbers"
$	   runoff 'DOC$original' /contents/indent'sw'
$	   if .not.$status then goto runoff_error
$dont_do_contents:
$! .............................................................................
$! and the index file
$!
$	if .not.do_index then goto dont_do_index
$	   file_type = "index"
$	   runoff 'DOC$original' /index
$	   if .not.$status then goto runoff_error
$dont_do_index:
$! -----------------------------------------------------------------------------
$! so we can now run off the file
$!
$runoff_whole_thing:
$!
$	ws "Running ''DOC$file' off now"
$!
$	if DOC$SMOOTH then ws "[?4h"		! set smooth scrolling
$!
$	runoff 'DOC$file' /log'DOC$qualifiers'
$	if .not.$status then goto status_exit
$!
$	if DOC$SMOOTH then ws "[?4l"		! set jump scrolling
$!
$	if do_contents.or.do_index then delete 'DOC$original'.BRN;*
$	if f$search("''DOC$original'.RNX;-1").nes."" then -
	   PURGE 'DOC$original'.RNX
$	if f$search("''DOC$original'.RNT;-1").nes."" then -
	   PURGE 'DOC$original'.RNT
$!
$	DOC$RESULT == "''DOC$file'.MEM"
$!
$! if we were outputting for the LN03 printer, then we produce a .LNI file
$! instead of a .MEM file. If this is indeed the case, we must then edit
$! the beginning of the .LNI file, to stop it from resetting the printer
$! back to American paper sizes...
$! ... unless this is a part runoff under VMS v5.2 onwards, in which case
$! it doesn't put a header !!
$!
$	if DOC$PRINTER.nes.DOC$LN03printer then goto not_an_LN03
$	DOC$RESULT == "''DOC$file'.LNI"
$	if f$locate("/PAGE",DOC$qualifiers).lt.f$len(DOC$qualifiers) -
		then goto not_an_LN03
$	   ws "%DOC-I-LN03TIDY, tidying the LN03 file ''DOC$file'"
$	   define/user sys$output nl:			! throw away any output
$	   edit="edit"				! ensure correct editor
$	   edit/edt 'DOC$RESULT' /command=lsl$doc_command:ln03.edt
$!
$not_an_LN03:
$	if f$search(DOC$RESULT).nes."" then purge 'DOC$RESULT'
$!
$	final_status = 'SUCCESS'
$	goto final_exit
$!
$! -----------------------------------------------------------------------------
$! we trapped a <CTRL/Y> - treat it as a failure
$!
$had_control_y:
$	final_status = 'FAILURE'
$	goto final_exit
$!
$! -----------------------------------------------------------------------------
$! we are exiting with a value in $status to be preserved
$!
$status_exit:
$	final_status = $status
$	if DOC$SMOOTH then ws "[?4l"		! set jump scrolling
$!
$! -----------------------------------------------------------------------------
$! and exit tidily
$!
$final_exit:
$	on control_y  then continue
$	if DOC$SMOOTH then ws "[?4l"		! set jump scrolling
$!
$	if CtrlC.eqs."" then goto CtrlC_is_back
$	   ws "<CTRL/C> will ''CtrlC'"
$CtrlC_is_back:
$!
$	if doc_user then set process/priority=5
$	exit 'final_status'
