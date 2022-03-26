$	set noon				! ignore $status settings
$	on control_y then exit 'HAD_CTRL'	! <CTRL/Y> is fatal
$!
$! ****************************************************************************
$! STANDARD_RNO_SUB - this command file is called (via @) to handle the
$!		      production of  Laser-Scan standard documentation.
$!
$! It is currently called by either
$!
$!		LSL$DOC_COMMAND:STANDARD_RNO
$!	or by	LSL$DOC_COMMAND:DOCUMENT
$!
$! Copyright (C) Laser-Scan Laboratories Ltd, Cambridge, England
$! Author TJ Ibbs, 6 May 1987 sqq
$!
$! ****************************************************************************
$! Modification	 3-Mar-1988	TJ Ibbs
$!	1) change prompts for where the output is
$!	2) when generating the WHOLE file, produce the .RNO file anew each time
$! ****************************************************************************
$! define various symbols that are private to this command file
$!
$	RNO$defined_lock    = FALSE
$	RNO$spec_file_open  = FALSE
$	RNO$outfile_open    = FALSE
$!
$! define our question lengths
$!
$	a$len = 40
$ 	c$len = 30
$!
$! we need the alphabet for dealing with appendices
$!
$	alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
$!
$! ----------------------------------------------------------------------------
$! check that no-one else is assembling the document
$!
$	gosub LOCK
$!
$! read the specification file for this document
$!
$	gosub READ_SPEC_FILE
$	if .not.$status then goto status_exit
$!
$! ----------------------------------------------------------------------------
$! define various variables
$!
$	to_Qume        = FALSE
$	to_LN03        = FALSE
$ 	to_terminal    = FALSE
$	to_lineprinter = FALSE
$!
$ 	do_whole     = FALSE
$ 	do_subset    = FALSE
$ 	do_contents  = FALSE
$ 	do_changes   = FALSE
$ 	do_preface   = FALSE
$ 	do_index     = FALSE
$ 	do_SPR_forms = FALSE
$!
$	DOC$file     = DOC$original		! name of file to runoff
$!
$! ............................................................................
$! we must now find out what the user wants us to do
$!
$	call ASKRNO 'a$len' "Run the whole document off?"
$	if $status.eq.HAD_CTRL then goto had_control_y
$	if .not.$status then goto status_exit
$	do_whole = DOC$RESULT
$!
$	if do_whole then goto not_a_subset
$	   call ASKRNO 'a$len' "Subset of pages from one chapter?"
$	   if $status.eq.HAD_CTRL then goto had_control_y
$	   if .not.$status then goto status_exit
$	   do_subset = DOC$RESULT
$not_a_subset:
$! ............................................................................
$!
$find_out_printer:
$!
$	call ASKRNO 'a$len' "For output on the LN03 laser printer?"
$	if $status.eq.HAD_CTRL then goto had_control_y
$	if .not.$status then goto status_exit
$	to_LN03 = DOC$RESULT
$!
$	if .not.to_LN03 then goto not_to_LN03
$	   DOC$PRINTER == DOC$LN03printer
$	   DOC$qualifiers  = "/DEVICE=LN03"
$	   goto output_device_known
$!
$not_to_LN03:
$	call ASKRNO 'a$len' "For output on the Qume?"
$	if $status.eq.HAD_CTRL then goto had_control_y
$	if .not.$status then goto status_exit
$	to_Qume = DOC$RESULT
$!
$	if .not.to_Qume then goto not_to_Qume
$	   DOC$PRINTER == DOC$LQprinter
$	   DOC$qualifiers  = "/BACKSPACE/BOLD=3"
$	   goto output_device_known
$!
$not_to_Qume:
$	call ASKRNO 'a$len' "For output on the lineprinter?"
$	if $status.eq.HAD_CTRL then goto had_control_y
$	if .not.$status then goto status_exit
$	to_lineprinter = DOC$RESULT
$!
$ 	if .not.to_lineprinter then goto not_to_lineprinter
$	   DOC$PRINTER == DOC$Lineprinter
$	   DOC$qualifiers  = ""
$	   goto output_device_known
$!
$not_to_lineprinter:
$	call ASKRNO 'a$len' "Type it at the terminal?"
$	if $status.eq.HAD_CTRL then goto had_control_y
$	if .not.$status then goto status_exit
$	to_terminal = DOC$RESULT
$!
$ 	if .not.to_terminal then goto not_to_terminal
$	   DOC$PRINTER == DOC$Noprinter	! as we'll already have
$	   DOC$qualifiers  = "/OUTPUT=TT:"! output it to the terminal
$	   goto output_device_known
$!
$not_to_terminal:
$	ws "%DOC-E-NOOUTPUT, there are no more output devices"
$	ws "-DOC-I-TRYAGAIN, please try again"
$	goto find_out_printer
$!                             
$output_device_known:
$!
$	wsb		! blank line for prettiness
$!
$! if we are outputting the whole document, then we must generate a new
$! runoff file, and then go to run it off
$!
$	if .not.do_whole then goto not_doing_whole
$	   gosub MAKE_WHOLE_FILE
$	   goto run_file_off
$not_doing_whole:
$! ............................................................................
$! otherwise, we are generating a part document - so change the name of
$! the file to be runoff to reflect that fact
$!
$	DOC$file = "PART_OF_" + DOC$file
$! ............................................................................
$!
$ 	if .not.want_contents then goto no_contents_wanted
$	   call ASKRNO 'a$len' "Produce a new contents?"
$	   if $status.eq.HAD_CTRL then goto had_control_y
$	   if .not.$status then goto status_exit
$	   do_contents = DOC$RESULT
$no_contents_wanted:
$!            
$ 	if .not.want_changes  then goto no_changes_wanted
$	   call ASKRNO 'a$len' "Produce a new change record?"
$	   if $status.eq.HAD_CTRL then goto had_control_y
$	   if .not.$status then goto status_exit
$	   do_changes = DOC$RESULT
$no_changes_wanted:
$!
$ 	if .not.want_preface  then goto no_preface_wanted
$	   call ASKRNO 'a$len' "Produce a new preface?"
$	   if $status.eq.HAD_CTRL then goto had_control_y
$	   if .not.$status then goto status_exit
$	   do_preface = DOC$RESULT
$no_preface_wanted:
$!
$ 	if .not.want_index    then goto no_index_wanted
$	   call ASKRNO 'a$len' "Produce a new index?"
$	   if $status.eq.HAD_CTRL then goto had_control_y
$	   if .not.$status then goto status_exit
$	   do_index = DOC$RESULT
$no_index_wanted:
$!
$ 	if .not.want_SPR_forms then goto no_SPRs_wanted
$	   call ASKRNO 'a$len' "Produce new SPR forms?"
$	   if $status.eq.HAD_CTRL then goto had_control_y
$	   if .not.$status then goto status_exit
$	   do_SPR_forms = DOC$RESULT
$no_SPRs_wanted:
$! ----------------------------------------------------------------------------
$! so we can now open and start the temporary runoff file, using the information
$! obtained above
$!
$	gosub START_RUNOFF_FILE
$	if .not.$status then goto status_exit
$!
$! ----------------------------------------------------------------------------
$! we must now find out which chapters/appendices of the document the user wants
$! - show the available choices
$!
$	call DISPLAY_CHAPTERS
$	if $status.eq.HAD_CTRL then goto had_control_y
$!
$! and find out which chapters the user wants
$! - note that if we are doing a subset of pages, then we can only process
$!   one chapter at a time
$!
$	fn       = "First"
$	if do_subset then fn = "Which"
$!
$next_chapter:
$	   call ASKRNO 'c$len' "''fn' chapter to include:"
$	   if $status.eq.HAD_CTRL then goto had_control_y
$	   if .not.$status then goto status_exit
$	   choice = DOC$RESULT
$!
$	   if choice.eqs."" then goto no_more_chapters
$!
$	   gosub INSERT_CHAPTER
$	   if .not.$status then goto next_chapter	! ask again
$!
$	   if do_subset then goto no_more_chapters
$!
$	   fn       = " Next"
$	   goto next_chapter
$!
$! ----------------------------------------------------------------------------
$! we have finished finding the pages wanted by the user, so tidy things up
$!
$no_more_chapters:
$	gosub END_DISPLAY
$ 	gosub END_RUNOFF_FILE
$	if .not.$status then goto status_exit
$!
$! ............................................................................
$! if the user wanted a subset of pages from one chapter, determine the subset
$!
$ 	if .not.do_subset then goto do_whole_chapter
$	   gosub SPECIFY_SUBSET
$	   if .not.$status then goto status_exit
$!
$	   if DOC$RESULT.nes."" then -
	      DOC$qualifiers = DOC$qualifiers + "/PAGES=(" + DOC$RESULT + ")"
$!
$do_whole_chapter:
$! ****************************************************************************
$! so we can now do the actual running off of the file
$!
$run_file_off:
$	@lsl$doc_command:runoff_file
$	if .not.$status then goto status_exit
$	if .not.do_whole then delete 'DOC$file'.RNO;*
$	goto status_exit
$!
$! ----------------------------------------------------------------------------
$! we trapped a <CTRL/Y> at the main level
$!
$had_control_y:
$	final_status = HAD_CTRL
$	goto final_exit
$!
$! ----------------------------------------------------------------------------
$! we are exiting with a value in $status to be preserved
$!
$status_exit:
$	final_status = $status
$!
$! ----------------------------------------------------------------------------
$! we are exiting with a value in final_status to be preserved
$!
$final_exit:
$	on control_y	      then continue		! ignore <CTRL/Y>
$	if DOC$SCREEN         then gosub END_DISPLAY
$	if RNO$outfile_open   then close outfile
$	if RNO$spec_file_open then close spec
$!
$	gosub UNLOCK
$!
$exit_only:
$	exit 'final_status'
       
$! =========================================================================
$! LOCK
$! claim the running off of this document to ourselves
$! ------------------------------------------------------------------------
$LOCK:
$!
$! create the logical name that we want to set
$!
$	log_name = "RUNNING_OFF_" + DOC$original
$!
$! is it already defined? - look in the group tables
$!
$	user = f$trnlnm( log_name, "LNM$GROUP" )
$!
$! if it is, then someone else is using the document, and we must
$! abort this procedure. Note that we set 'final_status' ourselves
$! before branching to exit
$!
$	if user.eqs."" then goto no_one_else
$	   ws "%RNO-E-ALREADY, ''user' is already running ''DOC$original' off"
$	   final_status = 'FAILURE'
$	   goto exit_only
$!
$no_one_else:
$	on control_y then continue		! disable <CTRL/Y>
$!
$	RNO$defined_lock = TRUE
$	define/group  'log_name'  "''f$process()'"
$!
$	on control_y then goto had_control_y
$	return 'SUCCESS'

$! =========================================================================
$! UNLOCK
$! release our lock on the document
$! -------------------------------------------------------------------------
$UNLOCK:
$!
$! if the name has not been set by us at an earlier stage, then exit
$!
$	if .not.RNO$defined_lock then return 'SUCCESS'
$!
$! work out the logical name that we want to unset
$!
$	log_name = "RUNNING_OFF_" + DOC$original
$!
$	on control_y then continue	! force this to execute
$!
$	deassign/group  'log_name'
$	RNO$defined_lock = FALSE
$!
$	on control_y then goto had_control_y
$	return 'SUCCESS'

$! =========================================================================
$! READ_SPEC_FILE
$! read the specification file for this document
$! -------------------------------------------------------------------------
$READ_SPEC_FILE:
$!
$! first, we must ensure that the specification file exists
$!
$	spec_file = f$search( "''DOC$original'.SPEC" )
$	if spec_file.nes."" then goto got_spec_file
$	   ws "%RNO-E-NOSPECFIL, " + -
	      "cannot find specification file ""''DOC$original'.SPEC"""
$	   return 'FAILURE'
$!
$got_spec_file:
$!
$! having found our file, set up the default states
$!
$	want_section_numbering = FALSE
$	want_changes   = FALSE
$	want_preface   = FALSE
$	want_contents  = FALSE
$	want_index     = FALSE
$	want_spr_forms = FALSE
$	want_user_name = FALSE
$	chapter_prefix = ""
$	chapter_count  = 0
$	appendix_count = 0
$!
$! now, open it and read each line in turn
$!
$ 	on control_y then continue		! disable <CTRL/Y>
$!
$	open/read/error=open_error  spec  'spec_file'
$  	RNO$spec_file_open = TRUE
$!
$	on control_y then goto had_control_y	! reenable <CTRL/Y>
$!
$	wsb
$	ws "%RNO-I-SPECFIL, reading specification file ""''DOC$original'.SPEC"""
$	wsb
$!
$! zero counters - how many chapters there are, etc
$!
$	chapter_count  = 0
$	appendix_count = 0
$!
$next_line:
$	read/end_of_file=eof/error=read_error  spec  line
$!
$! decode the contents of the line
$!
$	if line.eqs." " then goto next_line
$	if f$extract(0,1,line).eqs."!" then goto next_line
$!
$	size  = f$length(line)
$!
$! the line is either of the form KEYWORD or KEYWORD VALUES, where VALUES
$! is preceded by space(s) or tab(s). Thus we first compress all multiple
$! spaces and tabs into single spaces, remove trailing & leading spaces,
$! and remove any comments
$!
$  	e$line = f$edit( line, "COMPRESS,TRIM,UNCOMMENT" )
$!
$! the KEYWORD will now be delimited by the first space, or by the end
$! of the line
$!
$	key  = f$element( 0, " ", e$line )
$	if key.eqs."" then goto next_line	! empty key
$!
$	key  = f$edit( key, "UPCASE" )
$!
$	siz  = f$length(key)
$	rest = f$extract( siz, f$length(e$line), e$line )
$!
$! and we can now identify what we are meant to do with this line
$!                               
$	if f$locate( key,"SECTION_NUMBERS"     ).eq.0 then goto set_secnums
$	if f$locate( key,"CHANGES"             ).eq.0 then goto set_changes
$  	if f$locate( key,"PREFACE"             ).eq.0 then goto set_preface
$	if f$locate( key,"CONTENTS"            ).eq.0 then goto set_contents
$	if f$locate( key,"INDEX"               ).eq.0 then goto set_index
$	if f$locate( key,"SPR_FORMS"           ).eq.0 then goto set_spr_forms
$	if f$locate( key,"WANT_SPR_FORMS"      ).eq.0 then goto set_spr_forms
$	if f$locate( key,"NO_AUTO_NAME_CHAPTER").eq.0 then goto set_no_auto
$	if f$locate( key,"PREFIX_CHAPTER"      ).eq.0 then goto set_prefix
$	if f$locate( key,"CHAPTER"             ).eq.0 then goto set_chapter
$	if f$locate( key,"APPENDIX"            ).eq.0 then goto set_appendix
$!
$	ws "%RNO-W-UNKSPEC, unrecognised specification record"
$	ws "\''line'\"
$	goto next_line
$!
$! ............................................................................
$set_secnums:	want_section_numbering = TRUE
$		goto next_line
$!
$set_changes:	want_changes   = TRUE
$		goto next_line
$!
$set_preface:	want_preface   = TRUE
$		goto next_line
$!
$set_contents:	want_contents  = TRUE
$		goto next_line
$!
$set_index:	want_index     = TRUE
$		goto next_line
$!
$set_spr_forms:	want_SPR_forms = TRUE
$		goto next_line
$!
$set_no_auto:	want_user_name = TRUE
$		goto next_line
$!
$set_prefix:	chapter_prefix = rest
$	   	goto next_line
$!
$set_chapter:	chapter_count  = chapter_count+1
$		chapter'chapter_count = rest
$!
$! check that the first chapter is called "INTRODUCTION"
$!
$		if chapter_count.ne.1 then goto next_line
$		   rest = f$edit( rest, "TRIM,UPCASE" )
$		   if rest.eqs."INTRODUCTION" then goto next_line
$		      ws "%RNO-W-NOTINTRO, the first chapter should always" + -
			 " be the INTRODUCTION"
$		      goto next_line
$!
$set_appendix:	appendix_count = appendix_count+1
$		appendix'appendix_count = rest
$		goto next_line
$!
$! ............................................................................
$! errors and conditions
$!
$open_error:
$	ws "%RNO-E-SPECOPEN, error opening specification file ""''spec_file'"""
$	return 'FAILURE'
$!
$eof:	close  spec
$	RNO$spec_file_open = FALSE
$	return 'SUCCESS'
$!
$read_error:
$	ws "%RNO-E-SPECREAD, error reading specification file ""''spec_file'"""
$	return 'FAILURE'

$! =========================================================================
$! START_RUNOFF_FILE
$! create a file to runoff, and put some initial things into it
$! -------------------------------------------------------------------------
$START_RUNOFF_FILE:
$! 
$! create and open the temporary runoff file
$! - first check that we have a header file
$!
$	if f$search("''DOC$original'.HDR").nes."" then goto got_hdr_file
$	   ws "%RNO-E-NOHDR," + -
	      " cannot find ''DOC$original'.HDR to copy to ''DOC$file'.RNO"
$	   ws "-RNO-I-HEADR, define a header (.HDR) file and try again"
$	   return 'FAILURE'
$!
$got_hdr_file:
$ 	copy  'DOC$original'.HDR  'DOC$file'.RNO
$	if .not.$status then return 'FAILURE'
$!
$	on control_y then continue		! disable <CTRL/Y>
$!
$	open/append  outfile  'DOC$file'.RNO
$	RNO$outfile_open = TRUE
$!
$	on control_y then goto had_control_y	! reenable <CTRL/Y>
$!
$! and an abbreviation for writing
$!
$	wo = "write outfile"
$!
$! output a standard warning message for anyone looking at this file with an
$! editor
$!
$	wo ".!********************************************************************"
$	wo ".!***                                                              ***
$	wo ".!***                      W A R N I N G                           ***
$	wo ".!***                                                              ***
$	wo ".!*** This file is generated automatically by STANDARD_RNO/DOC     ***"
$	wo ".!*** A new version is generated whenever the document is run off, ***"
$	wo ".!*** so do not edit this file and expect it to stay around.       ***"
$	wo ".!********************************************************************"
$!      
$! and if we are having a contents, then we must place it there now
$!
$ 	if .not.do_contents then goto dont_include_contents
$!
$	   wo  ""
$	   wo  ".SAVE"
$	   wo  ".NO NUMBER"
$	   wo  ".SUBTITLE Contents"
$	   wo  ".REQUIRE	""''DOC$original'.RNT"""
$  	   wo  ".RESTORE"
$	   wo  ".PAGE"
$!
$dont_include_contents:
$!
$! and similarly with the changes record and preface
$!
$  	if .not.do_changes then goto dont_include_changes
$!
$	   wo  ""
$	   wo  ".!* change our page numbering practices"
$	   wo  ".!* use lower-case Roman numbers, and start at 1"
$	   wo  ".DISPLAY NUMBER RL"
$	   wo  ".NUMBER PAGE 1"
$	   wo  ".SUBTITLE Changes"
$	   wo  ".REQUIRE	""CHANGES.RNO"""
$	   wo  ".SEND TOC .BLANK"
$	   wo  ".!* restore normal numbering practices - use decimal numbers"
$	   wo  ".DISPLAY NUMBER D"
$	   wo  ".PAGE"
$!
$dont_include_changes:
$!
$ 	if .not.do_preface then goto dont_include_preface
$	   wo  ""
$	   wo  ".!* start again at page 1"
$	   wo  ".NUMBER PAGE 1"
$	   wo  ".SUBTITLE Preface"
$	   wo  ".REQUIRE ""PREFACE.RNO"""
$	   wo  ".PAGE"
$!
$dont_include_preface:
$!
$	return 'SUCCESS'

$! =========================================================================
$! INSERT_CHAPTER
$! work out which chapter is wanted, and amend the runoff file suitably
$! -------------------------------------------------------------------------
$INSERT_CHAPTER:
$!
$! determine whether we want a chapter or an appendix according to whether
$! we have an integer choice or not
$!
$	if f$type(choice).eqs."INTEGER" then goto choose_chapter
$!
$	   choice := 'choice			! upper-case it
$	   num = f$locate(choice,alphabet)
$	   if num.ne.f$length(alphabet) then goto is_an_appendix
$	      ws "%RNO-E-VALUE," + -
		 " value ""''choice'"" is not integer or alphabetic"
$	      ws "-RNO-I-CHAPVAL, specify an integer to choose a chapter"
$	      ws "-RNO-I-APPXVAL, specify an alphabetic to choose an appendix"
$	      return 'FAILURE'
$!
$is_an_appendix:
$	   num = num+1		! start at 1, not at 0
$	   if num.le.appendix_count then goto good_appendix
$	      ws "%RNO-E-NOSUCH, appendix ""''choice'"" does not exist"
$	      return 'FAILURE'
$!
$good_appendix:
$	   name = appendix'num
$	   is_chapter = FALSE
$	   goto include_it
$!
$choose_chapter:
$!
$	   num = choice
$	   if num.le.chapter_count .and. num.gt.0 then goto good_chapter
$	      ws "%RNO-E-NOSUCH, chapter ""''choice'"" does not exist"
$	      return 'FAILURE'
$!
$good_chapter:
$	   name = chapter'num
$	   is_chapter = TRUE
$	   goto include_it
$!
$! ............................................................................
$! so we have a chapter or appendix name - we must add it to the runoff file
$!
$include_it:
$	wo = "write outfile"
$!
$! - decide whether it is a chapter or an appendix
$!
$	if .not.is_chapter then goto do_an_appendix
$!
$	   ws "Adding chapter  ''choice':  ",chapter'num
$!                 
$! if this is chapter 1, then we are outputting the introduction,
$! but for all other chapters we want to put the prefix on
$!
$! if want_user_name is specified, then we will not create a separate chapter
$! header page, but will assume that the .RNO file contains a .CHAPTER command
$!
$	   modnam = " ''chapter_prefix' "	! for instance, "MODULE"
$	   if num.eq.1 then modnam = ""		! but not MODULE INTRODUCTION !
$!
$	   wo  ""
$	   wo  ".NUMBER CHAPTER  ",num			! number the chapter
$	   if want_user_name then goto not_auto_name
$	      wo  ".CHAPTER ",modnam,chapter'num	! name the chapter
$	      wo  ".NUMBER PAGE 1"			! start at page 1
$	      wo  ".PAGE"				! on the next page
$	      if num.eq.1 then wo ".NO SUBTITLE"	! suppress subtitles
$							! for the INTRODUCTION
$not_auto_name:
$	   wo  ".REQUIRE """,chapter'num,".RNO"""	! and include the file
$	   return 'SUCCESS'
$!
$do_an_appendix:
$!
$	   ws "Adding appendix ''choice':  ",appendix'num
$!
$	   wo  ""
$	   wo  ".NUMBER APPENDIX ",P1			! letter the appendix
$	   wo  ".REQUIRE """,appendix'num,".RNO"""	! and include the file
$	   return 'SUCCESS'

$! =========================================================================
$! SPECIFY_SUBSET
$! determine which pages from the chapter are required
$! -------------------------------------------------------------------------
$SPECIFY_SUBSET:
$!
$	wsb
$	ws "			Specify the pages required"
$	wsb
$	ws "Use the standard RUNOFF syntax - for instance" + -
	   " 15-9:15-9 or 15-18:15-27"
$	wsb
$!
$	call ASKRNO 'c$len' "Which pages do you want?"
$	if $status.eq.HAD_CTRL then goto had_control_y
$	return '$status'

$! =========================================================================
$! END_DISPLAY
$! return the terminal to normal after DISPLAY_CHAPTERS
$! -------------------------------------------------------------------------
$END_DISPLAY:
$!
$! ensure that we scroll in the whole of the screen, but move the cursor
$! to the bottom line
$!
$	on control_y then continue		! disable <CTRL/Y>
$!                        
$	ws "[1;24r[24;1H"
$	DOC$SCREEN == FALSE
$!
$	on control_y then goto had_control_y	! reenable <CTRL/Y>
$!
$	return 'SUCCESS'

$! =========================================================================
$! END_RUNOFF_FILE
$! terminate the runoff file
$! -------------------------------------------------------------------------
$END_RUNOFF_FILE:
$!
$  	if .not.do_index then goto dont_include_index
$!
$	   wo = "write outfile"
$!
$	   wo  ""
$	   wo  ".PAGE"
$	   wo  ".TITLE Index"
$	   wo  ".NO SUBTITLE"
$ 	   wo  ".REQUIRE	""''DOC$original'.RNX"""
$!
$dont_include_index:
$!
$	if .not.do_SPR_forms then goto dont_include_SPR_forms
$!
$! work out the title for this SPR form
$! - take the name of the document, and replace underlines by spaces
$!
$	   title = "SPR form for"
$!
$	   elem = 0
$loop:	   next = f$element( elem, "_", DOC$original )
$	   if next.eqs."_" then goto got_title
$	      title = title + " " + next
$	      elem  = elem +1
$	      goto loop
$!
$got_title:
$	   wo  ""
$	   wo  ".NO NUMBER"			! suppress page numbers
$	   wo  ".PAGE"
$	   wo  ".TITLE ''title'"
$	   wo  ".NO SUBTITLE"
$ 	   wo  ".REQUIRE	""SPR_FORM.RNO"""
$	   wo  ".PAGE"
$ 	   wo  ".REQUIRE	""SPR_FORM.RNO"""
$	   wo  ".PAGE"
$ 	   wo  ".REQUIRE	""SPR_FORM.RNO"""
$!
$dont_include_SPR_forms:
$!
$	on control_y then continue
$!
$	close outfile
$	RNO$outfile_open = FALSE
$!
$	on control_y then goto had_control_y
$!
$	return 'SUCCESS'

$! =========================================================================
$! MAKE_WHOLE_FILE
$! generate a runoff file to produce the whole document
$! -------------------------------------------------------------------------
$MAKE_WHOLE_FILE:
$!
$! tell the user what we are doing
$!
$	ws "Generating ''DOC$file' to runoff whole document"
$!
$! note that if there are contents and index, then we want them
$!
$	do_contents = want_contents
$	do_index    = want_index
$!
$! start off the file
$!
$	gosub START_RUNOFF_FILE
$	if .not.$status then return 'FAILURE'
$!
$! and we must now add each chapter to the file
$!
$	choice = 0
$!
$next_chapter_for_whole:
$!
$	choice = choice +1
$	if choice.gt.chapter_count then goto end_chapters_for_whole
$!
$	   gosub INSERT_CHAPTER
$	   if .not.$status then return 'FAILURE'
$	   goto next_chapter_for_whole
$!
$end_chapters_for_whole:
$!
$! and we must now deal with any appendices
$!
$	whole_idx = 0
$!
$next_appendix_for_whole:
$!
$	whole_idx = whole_idx +1
$	if whole_idx.gt.appendix_count then goto end_appendices_for_whole
$!
$	   choice = f$extract(whole_idx-1,1,alphabet)
$!
$	   gosub INSERT_CHAPTER
$	   if .not.$status then return 'FAILURE'
$	   goto next_appendix_for_whole
$!
$end_appendices_for_whole:
$!
$! end the file
$!
$	gosub END_RUNOFF_FILE
$	if .not.$status then return 'FAILURE'
$!
$! otherwise, we are finished
$!
$	wsb
$	return 'SUCCESS'

$! =========================================================================
$! DISPLAY_CHAPTERS
$! show the user the chapters that are available
$! -------------------------------------------------------------------------
$DISPLAY_CHAPTERS:
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
$	line[0,'DOC$WIDTH']        := "STANDARD RUNOFF CHAPTER menu"
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
$! now for the actual contents of the menu
$!
$	tab    = "	"		! define a tab as separator
$	nlines = 0			! no lines of menu output yet
$!
$	do_chapter = TRUE		! start with the chapters
$	max_num    = chapter_count	! how many there are
$	num        = 0			! none output on this line
$!
$	alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
$!
$! start the first line of output
$!
$	line[0,80] := " "
$	char = 0
$!
$! get the next chapter/appendix description
$!
$next_name:
$	   num = num+1
$	   if num.gt.max_num then goto change_topic
$!
$	   if .not.do_chapter then goto is_an_appendix
$	      numch = "''num'"
$	      if f$len(numch).lt.2 then numch = " " + numch
$	      name = "''numch'   "+chapter'num
$	      goto add_it_on
$!
$is_an_appendix:
$	      numch = " " + f$extract(num-1,1,alphabet)
$	      name  = "''numch'   "+appendix'num
$!
$add_it_on:
$!
$! work out the length of the name, and thus how much space we need to
$! write it out - always leave at least one space after the name,
$! so add one to 'length' before using it
$!
$	   length = f$len(name)
$	   twenties = (length+1+19) /20
$	   total_length = 20*twenties
$	   if char+total_length.le.80 then goto output_name
$	      ws line
$	      nlines = nlines+1
$	      line[0,80] := " "
$	      char = 0
$!
$output_name:
$	      line[char,length] := "''name'"
$	      char = char+total_length
$	      goto next_name
$!
$! ............................................................................
$! work out if we should now be doing appendices, or if we have finished
$!
$change_topic:
$	   if .not.do_chapter then goto no_next_name	! finished
$	      do_chapter = FALSE			! appendices now
$	      max_num    = appendix_count		! how many of them
$	      num        = 0		   		! none output yet
$	      goto next_name
$!
$! ............................................................................
$! we have no more names - output the last line as it is
$!
$no_next_name:
$	if char.le.0 then goto no_more_lines
$	   ws line
$	   nlines = nlines + 1
$!
$no_more_lines:
$!
$! now define what happens if the control keys are used
$!
$	wsb
$	ws "<CTRL/Z> will ''CtrlZ'"
$	ws "<CTRL/C> will ''CtrlC'"
$	ws "      ?  will repeat the current question"
$	ws "    <CR> will end chapter selection and run the document off"
$!
$! and we will scroll in the section of the screen below the menu
$!
$ 	number_of_lines = 2 + nlines + 6
$	scroll = number_of_lines + 1
$!
$! ESC ['n';r		scroll from line 'n' to bottom of screen
$! ESC ['n';1H		move to line 'n', column 1
$!
$	ws "[''scroll';r[''number_of_lines';1H"
$!
$	exit 'SUCCESS'
$	ENDSUBROUTINE		! DISPLAY_CHAPTERS

$! =========================================================================
$! ASKRNO
$! Called to ask the user a question
$!
$! 	P1		the length to pad the question to
$!			(or 0 if the question should just be asked)
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
$	question = ""
$	if p1.ne.0 then question[0,'P1'] := "''P2'"
$	if p1.eq.0 then question[0,f$len(P2)+1] := "''P2'"
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
$! ............................................................................
$eof:	exit 'HAD_EOF'
$!
$ask_error:
$	ws "%RNO-E-ASKERR, error in reading response"
$	exit 'FAILURE'
$!
$	ENDSUBROUTINE		! ASKRNO
