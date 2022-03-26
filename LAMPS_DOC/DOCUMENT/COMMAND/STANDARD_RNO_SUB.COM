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
$! Copyright (C) Laser-Scan Ltd, Cambridge, England
$! Author TJ Ibbs, 6 May 1987 sqq
$!
$! ****************************************************************************
$! Modification	 3-Mar-1988	TJ Ibbs
$!	1) change prompts for where the output is
$!	2) when generating the WHOLE file, produce the .RNO file anew each time
$! Modification	 4-Mar-1988	TJ Ibbs
$!	Don't forget the preface, change notices and SPR forms for a whole
$!	document.
$! Modification	8-Mar-1988	TJ Ibbs
$!	Various changes to allow generation of title page, etc
$! Modification	15-Mar-1988	TJ Ibbs
$!	Use .NO NUMBER for the title page(s)
$!	If using a chapter prefix for titles, use the chapter name as the
$!	chapter name after the prefix
$! Modification 12-May-1988	TJ Ibbs
$!	When running off a PART_ file, but wanting contents/index, we must
$!	make sure to generate a whole new runoff file, since runoff/intermediat
$!	needs it
$! Modification 10-March-1989	Paul Hardy
$!	Use the given date for page headers etc in place of date of running off.
$!	Avoid embedded escape sequences as muck up ln03 printer.
$! Modification 09-Jun-1989	Paul Hardy (also 07-Aug-1989)
$!	Change "Laser-Scan Laboratories Ltd" to "Laser-Scan Ltd"
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
$! we need the alphabet for dealing with appendices, and the
$! volume numbers for volums
$!
$	alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
$	volume_numbers = "ZERO,I,II,III,IV,V,VI,VII,VIII,IX,X"
$!
$! define escape sequence
$!
$	esc[0,7]=27
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
$!
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
$!
$! ----------------------------------------------------------------------------
$! if the user has requested the contents or index, we need to generate the
$! header runoff file for the complete document, as contents/index generation
$! involves processing the entire file
$!
$	if do_contents .or. do_index then gosub MAKE_WHOLE_FILE
$!
$! since we are generating a part document, we must change the name of the
$! file to be runoff to reflect that fact
$!
$	DOC$file = "PART_OF_" + DOC$file
$!
$! and we can now open and start the temporary runoff file, using the
$! information obtained above.
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
$	if      do_whole then purge  'DOC$file'.RNO
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
$! - don't assume that we want any of the extra bits of documentation
$!
$	want_changes   = FALSE
$	want_preface   = FALSE
$	want_contents  = FALSE
$	want_index     = FALSE
$	want_SPR_forms = FALSE
$!
$! we don't want section numbers, we will name chapters ourselves, and
$! start each chapter with a flag page (ie with just the chapter name
$! on it), and we will leave the user to decide what the .TITLE is
$!
$	want_section_numbering = FALSE
$	want_auto_name_chapter = TRUE
$	want_flag_pages        = TRUE
$	want_auto_title        = FALSE
$!
$	want_chapter_prefix = FALSE
$	chapter_prefix = ""		! default is no prefix
$!
$	DOC$changes = ""
$!
$!
$!!!	date        = "<<unset date>>"
$	date 	    = f$cvtime("TODAY","ABSOLUTE","DATE")
$	issue       = "<<unset issue>>"
$	author      = "<<unset author>>"
$	short_title = "<<UNSET SHORT TITLE>>"
$	category    = "<<UNSET CATEGORY>>"
$!
$	volume_count     = 1		! no of volumes
$	multiple_volumes = FALSE	! only one volume
$!
$	chapter_count    = 0		! no of chapters
$	appendix_count   = 0		! no of appendices
$	title_line_count = 0		! no of lines of title
$	note_line_count  = 0		! no of lines of notes
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
$	ukey  = f$element( 0, " ", e$line )
$	if ukey.eqs."" then goto next_line	! empty key
$!
$! check that the key is long enough - insist on four characters
$!
$	siz  = f$length(ukey)
$!
$	if siz.ge.4 then goto key_siz_ok
$	   ws "%RNO-W-KEYSIZ, specification command keyword too short"
$	   ws "-RNO-I-SPECLN, you must give at least 4 characters of keyword"
$	   ws "\''line'\"
$	   goto next_line
$!
$key_siz_ok:
$	rest = f$extract( siz, f$length(e$line), e$line )
$	rest = f$edit(rest,"TRIM")		! remove any leading spaces
$!
$! and we can now identify what we are meant to do with this line
$!                               
$	key = f$edit( ukey,"UPCASE" )
$!
$	if f$locate( key,"CHAPTER"             ).eq.0 then goto set_chapter
$	if f$locate( key,"APPENDIX"            ).eq.0 then goto set_appendix
$	if f$locate( key,"CHANGES"             ).eq.0 then goto set_changes
$  	if f$locate( key,"PREFACE"             ).eq.0 then goto set_preface
$	if f$locate( key,"CONTENTS"            ).eq.0 then goto set_contents
$	if f$locate( key,"INDEX"               ).eq.0 then goto set_index
$	if f$locate( key,"SPR_FORMS"           ).eq.0 then goto set_SPR_forms
$!
$	if f$locate( key,"DATE"                ).eq.0 then goto set_date
$	if f$locate( key,"ISSUE"               ).eq.0 then goto set_issue
$	if f$locate( key,"AUTHOR"              ).eq.0 then goto set_author
$	if f$locate( key,"SHORT_TITLE"         ).eq.0 then goto set_short_title
$	if f$locate( key,"CATEGORY"            ).eq.0 then goto set_category
$	if f$locate( key,"TITLE"               ).eq.0 then goto set_title
$	if f$locate( key,"NOTE"                ).eq.0 then goto set_note
$	if f$locate( key,"VOLUMES"             ).eq.0 then goto set_volume
$!
$	if f$locate( key,"SECTION_NUMBERS"     ).eq.0 then goto set_secnums
$	if f$locate( key,"NO_SECTION_NUMBERS"  ).eq.0 then goto set_no_secnums
$	if f$locate( key,"AUTO_NAME_CHAPTER"   ).eq.0 then goto set_autoname
$	if f$locate( key,"NO_AUTO_NAME_CHAPTER").eq.0 then goto set_no_autoname
$	if f$locate( key,"FLAG_PAGES"          ).eq.0 then goto set_flag
$	if f$locate( key,"NO_FLAG_PAGES"       ).eq.0 then goto set_no_flag
$	if f$locate( key,"AUTO_TITLE"          ).eq.0 then goto set_autotitle
$	if f$locate( key,"NO_AUTO_TITLE"       ).eq.0 then goto set_no_autotitle
$	if f$locate( key,"PREFIX_CHAPTER"      ).eq.0 then goto set_prefix
$!
$	ws "%RNO-W-UNKSPEC, unrecognised specification command"
$	ws "\''line'\"
$	goto next_line
$!
$! ............................................................................
$!
$set_chapter:	chapter_count = chapter_count+1
$		chapter'chapter_count = f$element( 0, " ", rest )
$		siz = f$length(chapter'chapter_count)
$!
$		rest1 = f$extract( siz, f$length(rest), rest )
$		rest1 = f$edit( rest1, "TRIM" )
$		if   rest1.eqs."" -
		then chapter_name'chapter_count = chapter'chapter_count
$		if   rest1.nes."" -
		then chapter_name'chapter_count = rest1
$!
$! check that the first chapter is called "INTRODUCTION"
$!
$		if chapter_count.ne.1 then goto next_line
$		   rest1 = f$edit( chapter1, "UPCASE" )
$		   if rest1.eqs."INTRODUCTION" then goto next_line
$		      ws "%RNO-W-NOTINTRO, the first chapter should always" + -
			 " be the INTRODUCTION"
$		      goto next_line
$!
$set_appendix:	appendix_count = appendix_count+1
$		appendix'appendix_count = f$element( 0, " ", rest )
$		siz = f$length(appendix'appendix_count)
$!
$		rest1 = f$extract( siz, f$length(rest), rest )
$		rest1 = f$edit( rest1, "TRIM" )
$		if   rest1.eqs."" -
		then appendix_name'appendix_count = appendix'appendix_count
$		if   rest1.nes."" -
		then appendix_name'appendix_count = rest1
$		goto next_line
$!
$set_date:	date = rest
$		alldate = f$cvtime(date)
$		if alldate.nes."" then goto next_line
$		ws "%RNO-W-BADDATE, date of ''date' is invalid - TODAY used"
$		date = f$cvtime("TODAY","ABSOLUTE","DATE")
$		goto next_line
$!
$set_issue:	issue = rest
$		goto next_line
$!
$set_author:	author = rest
$		goto next_line
$!
$set_short_title: short_title = rest
$		  goto next_line
$!
$set_category:	category = rest
$		goto next_line
$!
$set_title:	title_line_count = title_line_count+1
$		title'title_line_count = rest
$		goto next_line
$!
$! for a note, we don't want to lose significant internal spaces/tabs,
$! so we must go back to the original `line'
$!
$set_note:	note_line_count = note_line_count+1
$		rest = line - ukey
$		note_line'note_line_count = f$edit(rest,"TRIM")
$		goto next_line
$!
$set_volume:	volume_count = rest
$		if f$type(volume_count).eqs."INTEGER" then goto vol_num_is_int
$		   ws "%RNO-W-VOLNUM, VOLUMES must have an integer value"
$		   ws "\''rest'\"
$		   goto next_line
$vol_num_is_int:if volume_count.le.10 then goto vol_num_siz_OK
$		   ws "%RNO-W-VOLSIZ, VOLUMES must be no more than 10"
$		   ws "\''rest'\"
$		   volume_count = 1
$		   goto next_line
$vol_num_siz_OK:multiple_volumes = volume_count.gt.1
$		goto next_line
$!
$set_changes:	want_changes   = TRUE
$		DOC$changes = f$element( 0, " ", rest )
$		DOC$changes = f$edit( DOC$changes, "TRIM" )
$!
$! Make it upwardly compatible. If no filename given for change record, use
$! the normal file CHANGES.RNO
$!
$		if   DOC$changes.eqs."" -
		then DOC$changes = "CHANGES"
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
$set_SPR_forms:	want_SPR_forms = TRUE
$		goto next_line
$!
$set_secnums:	 want_section_numbering = TRUE
$		 goto next_line
$set_no_secnums: want_section_numbering = FALSE
$		 goto next_line
$!
$set_autoname:	 want_auto_name_chapter = TRUE
$		 goto next_line
$set_no_autoname:want_auto_name_chapter = FALSE
$		 goto next_line
$!
$set_flag:	 want_flag_pages = TRUE
$		 goto next_line
$set_no_flag:	 want_flag_pages = FALSE
$		 goto next_line
$!
$set_autotitle:	  want_auto_title = TRUE
$		  goto next_line
$set_no_autotitle:want_auto_title = FALSE
$		  goto next_line
$!
$set_prefix:	chapter_prefix = rest
$		want_chapter_prefix = chapter_prefix.nes.""
$	   	goto next_line
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
$! create a basic header file, with all of the things that we always insert
$!
$	create  'DOC$file'.RNO
.!********************************************************************
.!***                                                              ***
.!***                      W A R N I N G                           ***
.!***                                                              ***
.!*** This file is generated automatically by STANDARD_RNO/DOC     ***
.!*** A new version is generated whenever the document is run off, ***
.!*** so do not edit this file and expect it to stay around.       ***
.!********************************************************************

.! set the standard page size
.LEFT MARGIN 0;.RIGHT MARGIN 80;.PAGE SIZE 60,80

.! ensure that .NO FILL also retains blank lines
.KEEP

.! enable the use of ^*...\* and * as bolding flags
.ENABLE BOLDING;.FLAGS BOLD

.! ensure that .INDEX entries will be transmitted as they were typed
.XLOWER

$	if .not.$status then return 'FAILURE'
$!
$! now open the file to append other things to it
$!
$	on control_y then continue		! disable <CTRL/Y>
$!
$	   open/append  outfile  'DOC$file'.RNO
$	   RNO$outfile_open = TRUE
$!
$	on control_y then goto had_control_y	! reenable <CTRL/Y>
$!
$! and coin an abbreviation for writing to it
$!
$	wo = "write outfile"
$!
$! set up the date info
$!
$	day = f$cvtime(date,,"day")
$	month = f$cvtime(date,,"month")
$	year = f$cvtime(date,,"year")
$	wo ".! we want the date to be added to the top of the page"
$	wo ".SET DATE ''day',''month',''year'"
$	wo ".DATE"
$!
$! if not `want_section_numbering' then we must suppress it in the document
$! - this also carries assumptions about how we will lay the document out
$!
$	if .not.want_section_numbering then goto change_HL_lots
$	   wo ""
$	   wo ".! change the way .HL works"
$	   wo ".!   n1=7  lowest level to have `run-in' format - none"
$	   wo ".STYLE HEADERS 7"
$	   goto finished_with_HL
$!
$change_HL_lots:
$	   wo ""
$	   wo ".! change the way .HL works"
$	   wo ".!   n1=6  lowest  level to have `run-in' format"
$	   wo ".!   n2=2  highest level to have title in uppercase - 1 & 2 will"
$	   wo ".!   n4=0  lowest  level not to have section number at left"
$	   wo ".!   n6=0  number of blank lines before header"
$	   wo ".STYLE HEADERS 6,2,,0,,0"
$!
$finished_with_HL:
$!
$! now sort out the title page
$! - we can cope with more than one title page - if the user said VOLUMES 2
$!   then we will generate two
$! - if we have want_auto_title then we will generate them ourselves, but
$!   otherwise we will include TITLE_PAGE (or TITLE_PAGE1, TITLE_PAGE2, etc)
$!
$	title_page_number = 0
$!
$next_title_page:
$	title_page_number = title_page_number + 1
$!
$	if want_auto_title then goto generate_title_page
$	   if .not.multiple_volumes then title_page_number = ""
$	   wo ""
$	   wo ".no number"
$	   wo ".require ""TITLE_PAGE.RNO''title_page_number'"""
$	   wo ".PAGE"
$	   goto finished_title_page
$!
$generate_title_page:
$	wo ""
$	wo ".NO NUMBER"
$	wo ".FIGURE ",14-title_line_count
$	wo ".CENTRE ;^&Laser-Scan_ Ltd.\&"
$	wo ".FIGURE 2"
$	count = 0
$next_title_line:
$	   count = count + 1
$	   if count.gt.title_line_count then goto finished_with_title
$	      if count.gt.1 then wo ".BLANK"
$	      wo ".CENTRE ;^&" + title'count' + "\&"
$	      goto next_title_line
$finished_with_title:
$	if .not.multiple_volumes then goto not_multiple_volumes
$	   wo ".BLANK"
$	   wo ".CENTRE ;^&Volume_ " + f$element(title_page_number,",", -
						volume_numbers) + "\&"
$not_multiple_volumes:
$	wo ".FIGURE 2"
$	wo ".FLAGS SUBSTITUTE"
$	wo ".CENTRE ;^&Issue_ ''issue'_ -_ $$day-$$month-$$year\&"
$	wo ""
$	wo ".FOOT"
$	wo ".NOFILL"
$!
$! if the user has some straight text notes to insert here, do so
$!
$	if note_line_count.eq.0 then goto no_note_lines
$	   count = 0
$next_note_line:
$	      count = count + 1
$	      if count.gt.note_line_count then goto no_more_note_lines
$	         wo note_line'count
$		 goto next_note_line
$no_more_note_lines:
$	   wo ""
$!
$no_note_lines:
$	wo "Copyright (C) $$year Laser-Scan Ltd"
$	wo "Science Park, Milton Road, Cambridge, England CB4 4FY  tel: (01223) 420414"
$	wo ""
$	wo "Document ""''short_title'"", Category ""''category'"""
$	wo "Document Issue ''issue'	''author' (modified ''date')"
$	wo ".FILL"
$	wo ".NOFLAGS SUBSTITUTE"
$	wo ".END FOOT"
$	wo ""
$	wo ".!* and an initial title to go at the top of each page"
$	wo ".TITLE ''short_title' (''issue')"
$	wo ""
$	wo ".!* also, set a blank subtitle so that dates will come out"
$	wo ".SUBTITLE "
$	wo ".PAGE"
$!
$finished_title_page:
$!
$! if we are doing more than one title page, go back and look again
$!
$	if   multiple_volumes .and. title_page_number.lt.volume_count -
	then goto next_title_page
$!
$! if we are having a contents, then we must place it there now
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
$	   wo  ".REQUIRE	""''DOC$changes'.RNO"""
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
$!	   wo  ".PAGE"
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
$	   is_chapter  = FALSE
$	   is_appendix = TRUE
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
$	   is_chapter  = TRUE
$	   is_appendix = FALSE
$	   goto include_it
$!
$! ............................................................................
$! so we have a chapter or appendix name - we must add it to the runoff file
$!
$include_it:
$	wo = "write outfile"
$!
$! tell the user what we are doing
$!
$	if is_chapter  then ws "Adding chapter  ''choice':  ",chapter'num
$	if is_appendix then ws "Adding appendix ''choice':  ",appendix'num
$!
$! set the chapter or appendix number
$!
$	wo  ""
$	if is_chapter  then wo  ".NUMBER CHAPTER  ",num
$	if is_appendix then wo  ".NUMBER APPENDIX ",num
$!
$! work out if we have a prefix for our chapters - we don't use it for
$! chapter 1 (the introduction)
$!
$	if .not.want_chapter_prefix then goto no_prefix_to_use
$	   modnam = " ''chapter_prefix' "	! for instance, "MODULE"
$	   if num.eq.1 then modnam = ""		! but not "MODULE INTRODUCTION"
$no_prefix_to_use:
$!
$! if we are generating chapter names ourselves, then do so
$! - if we have `want_flag_pages', then the chapter is started on a
$!   separate page from the main text (and that page can then be thrown
$!   away, if necessary)
$! - if we have `want_auto_title' then we must generate a title for this
$!   chapter (note that if we don't have auto-title, then the subtitle for
$!   the INTRODUCTION is suppressed, as by default the title and the subtitle
$!   are both likely to end up as INTRODUCTION, which looks very strange)
$!
$	if .not.want_auto_name_chapter then goto not_auto_name
$!
$!	 if this is a chapter, and we are not using prefixes, then
$!	 use the name the user gave us for this chapter
$!
$	   if   is_chapter.and..not.want_chapter_prefix -
	   then wo  ".CHAPTER  ",chapter_name'num
$!
$!	 if this is a chapter and we ARE using prefixes, then we
$!	 use the prefix followed by the name of the FILE for the
$!	 chapter title - eg MODULE ICHECK
$!
$	   if   is_chapter.and.want_chapter_prefix -
	   then wo  ".CHAPTER  ",modnam,chapter'num
$!
$!	 if this is an appendix, then we just use the name supplied
$!	 by the user
$!
$	   if is_appendix then wo  ".APPENDIX ",appendix_name'num
$!
$	   if .not.want_flag_pages then goto no_flag_page
$	      wo  ".NUMBER PAGE 1"			! start at page 1
$	      wo  ".PAGE"				! on the next page
$no_flag_page:
$!
$	   if .not.want_auto_title then goto not_auto_title
$	      title_prefix = ".TITLE ''short_title' (''issue'): "
$	      if is_chapter  then wo title_prefix + chapter_name'num
$	      if is_appendix then wo title_prefix + appendix_name'num
$	      goto end_auto_title
$!
$not_auto_title:
$	      if num.eq.1 then wo ".NO SUBTITLE"	! suppress subtitles
$							! for the INTRODUCTION
$end_auto_title:
$not_auto_name:
$	if is_chapter  then wo  ".REQUIRE """ + chapter'num  + ".RNO"""
$	if is_appendix then wo  ".REQUIRE """ + appendix'num + ".RNO"""
$	return 'SUCCESS'

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
$	ws "''esc'[1;24r''esc'[24;1H"
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
$! sort out and tell the user what we are doing
$!
$	if do_whole then goto really_make_whole
$!
$	   wsb		! blank line for prettiness
$!
$	   t$what = ""
$	   if do_contents              then t$what = t$what + "contents"
$	   if do_contents.and.do_index then t$what = t$what + " and "
$	   if                 do_index then t$what = t$what + "index"
$	   ws "Generating ''DOC$file' to runoff ''t$what'"
$!
$!	 save the values of our do_xxx variables, since we need to
$!	 set them according to the want_xxx values, below
$!
$	   save_do_contents  = do_contents
$	   save_do_changes   = do_changes
$	   save_do_preface   = do_preface
$	   save_do_index     = do_index
$	   save_do_SPR_forms = do_SPR_forms
$!
$	   goto not_whole_joins
$!
$really_make_whole:
$!
$	   ws "Generating ''DOC$file' to runoff whole document"
$!
$not_whole_joins:
$!
$! ensure that the runoff file will include everything that this document
$! needs (as read from the .SPEC file)
$!
$	do_contents  = want_contents
$	do_changes   = want_changes
$	do_preface   = want_preface
$	do_index     = want_index
$	do_SPR_forms = want_SPR_forms
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
$	wsb
$!
$	if do_whole then return 'SUCCESS'
$!
$! if we are not running the whole file off, but were just doing this for
$! contents/index generation, then we must restore the do_xxx values to
$! what the user actually requested
$!
$	do_contents  = save_do_contents
$	do_changes   = save_do_changes
$	do_preface   = save_do_preface
$	do_index     = save_do_index
$	do_SPR_forms = save_do_SPR_forms
$!
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
$	ws "''esc'[2J''esc'[7m''esc'[1;1H",line	! output the whole lot
$!
$! ESC [0m		display in normal mode
$! ESC [3;r		scroll from line 3 to bottom of screen
$! ESC [2;1H		move cursor to line 2, column 1
$!
$	ws "''esc'[0m''esc'[3;r''esc'[2;1H"
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
$	ws "''esc'[''scroll';r''esc'[''number_of_lines';1H"
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
