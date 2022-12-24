$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-03-02 12:42:18.000000000 +0000
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
$	set noverify
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$! command file: NEWMSG - a command file to build the NEWMSG program
$!
$! Copyright (C) LaserScan Laboratories Ltd, Cambridge, England  1986
$! Author TJ Ibbs, 8 July 1987
$!
$! *************************************************************************
$! initialise our question asking mechanism
$!
$	call initq  "NEWMSG"  "?"
$	if .not.$status then goto exit_neatly	! exit if error
$!
$! set up some symbols
$!
$	inq = "call askq"
$	wsb = "!"
$ 	if .not.askq_repeat then wsb = "write sys$output """""
$	debug = 0
$!
$! prevent the production of listings during batch processing
$!
$	fortran = "fortran/nolist"
$	macro   = "macro/nolist"
$!
$! *************************************************************************
$! and ask our questions
$!                                                                       
$	wsb	! <<<<<<<<<< output a blank line >>>>>>>>>>
$ 	inq  "compile                                                   "
$	comp  = $status
$	if .not.comp then goto ask_link
$!
$	inq  "compile with debug                                        "
$	 debug   = $status
$	wsb	! <<<<<<<<<< output a blank line >>>>>>>>>>
$	if askq_haderror then goto exit_neatly		! check for ^Y,etc
$	inq  "command line definition                                   "
$	cld   = $status
$	inq  "messages                                                  "
$	msg   = $status
$	inq  "commands                                                  "
$	cmd   = $status
$	wsb	! <<<<<<<<<< output a blank line >>>>>>>>>>
$	if askq_haderror then goto exit_neatly		! check for ^Y,etc
$	inq  "main routine    (newmsg)                                  "
$	main  = $status
$	inq  "cmdline         (cmdline)                                 "
$	cmdl  = $status
$	inq  "open/close      (open/close_mesfile)                      "
$	opcl  = $status
$	inq  "read messages 1 (read_messages,get_next_line,readline)    "
$	rdm1  = $status
$	inq  "read messages 2 (start/end_message)                       "
$	rdm2  = $status
$	inq  "read messages 3 (read_explanation/useraction,do_multiple) "
$	rdm3  = $status
$	inq  "read messages 4 (read_replace)                            "
$	rdm4  = $status
$	inq  "write program   (write_program,write_comfile)             "
$	wrpr  = $status
$	inq  "runoff stuff 1  (sort_idents,convert_index,process_rno)   "
$	rno1  = $status
$	inq  "runoff stuff 2  (describe_severity/message,do_mess_line)  "
$	rno2  = $status
$	inq  "runoff stuff 3  (replace_message,get_replace_clause)      "
$	rno3  = $status
$	inq  "misc            (rdchs_nl,copy_string,old_form,cf,swap)   "
$	misc  = $status
$ask_link:
$	wsb	! <<<<<<<<<< output a blank line >>>>>>>>>>
$	if askq_haderror then goto exit_neatly		! check for ^Y,etc
$	inq  "link                                                      "
$	lnk   = $status
$!
$	lbg = ""
$	if .not.lnk then goto no_link_questions
$!
$	inq  "link with debug                                           "
$	lbg   = $status
$!
$no_link_questions:
$	wsb	! <<<<<<<<<< output a blank line >>>>>>>>>>
$	if askq_haderror then goto exit_neatly		! check for ^Y,etc
$!
$! *************************************************************************
$! are we doing it now, or submitting ourselves?
$!
$	call submitq
$	if askq_haderror then goto exit_neatly
$	if .not.$status then goto do_it_now
$	   call exitq				! close the file, etc
$	   submit  newmsg.com			! submit this command file
$	   goto exit_only			! and that's all
$do_it_now:
$!
$! *************************************************************************
$! so obey the commands now - sort out our flags first
$! - note that we link /notraceback if we aren't debugging - this is to
$!   stop an error in the CONVERT routines (which signal the error) from
$!   generating a traceback
$!
$	ldbg= "/notraceback"
$	dbg = ""
$	pd  = "delete"
$	ver = ";*"
$	if lbg   then ldbg= "/debug"
$	if debug then dbg = "/debug/noopt"
$	if debug then pd  = "purge"
$	if debug then ver = ""
$!
$! *************************************************************************
$!
$	set verify
$	if .not.comp then goto do_link
$	if .not.cld  then goto no_cld
$	   adc   newmsg.TMP=newmsg.CLD
$	   set command/object=newmsg_cld  newmsg.TMP
$	   pvv   newmsg_cld
$	   purge newmsg_cld.OBJ
$	   delete ADC.IDE;*
$	   delete newmsg.TMP;*
$no_cld:
$! ............................................................................
$	if .not.msg  then goto no_msg
$!
$! now to bootstrap ourselves
$! (take care when developing NEWMSG!!!)
$!
$	newmsg  newmsg.mes/number=1026/runoff/param=fortran
$	@newmsg.temp_com
$!
$no_msg:
$! ............................................................................
$	if .not.cmd  then goto no_cmd
$	   macro  newmsg.mar/object=newmsg_cmd
$	   purge  newmsg_cmd.obj
$no_cmd:
$! ............................................................................
$	if .not.main then goto nomain                  
$	   adc  newmsg/co = NEWMSG
$	   fortran/extend'dbg' newmsg
$	   pvv   newmsg
$	   purge newmsg.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' newmsg.FOR'ver'
$nomain:
$! ............................................................................
$	if .not.cmdl then goto nocmdl
$	   adc  cmdline/co = CMDLINE
$	   fortran/extend'dbg' cmdline
$	   pvv   cmdline
$	   purge cmdline.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' cmdline.FOR'ver'
$nocmdl:
$! ............................................................................
$	if .not.opcl then goto noopcl
$	   adc  open_close/co = open_mesfile,close_mesfile
$	   fortran/extend'dbg' open_close
$	   pvv   open_close
$	   purge open_close.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' open_close.FOR'ver'
$noopcl:
$! ............................................................................
$	if .not.rdm1 then goto nordm1
$	   adc  read1/co = read_messages,get_next_line,readline
$	   fortran/extend'dbg' read1
$	   pvv   read1
$	   purge read1.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' read1.FOR'ver'
$nordm1:
$! ............................................................................
$	if .not.rdm2 then goto nordm2
$	   adc  read2/co = start_new_message,end_message
$	   fortran/extend'dbg' read2
$	   pvv   read2
$	   purge read2.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' read2.FOR'ver'
$nordm2:
$! ............................................................................
$	if .not.rdm3 then goto nordm3
$	   adc  read3/co = read_explanation,read_useraction,do_multiple
$	   fortran/extend'dbg' read3
$	   pvv   read3
$	   purge read3.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' read3.FOR'ver'
$nordm3:
$! ............................................................................
$	if .not.rdm4 then goto nordm4
$	   adc  read4/co = read_replace
$	   fortran/extend'dbg' read4
$	   pvv   read4
$	   purge read4.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' read4.FOR'ver'
$nordm4:
$! ............................................................................
$	if .not.wrpr then goto nowrpr
$	   adc  write_program/co = write_program,write_comfile
$	   fortran/extend'dbg' write_program
$	   pvv   write_program
$	   purge write_program.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' write_program.FOR'ver'
$nowrpr:
$! ............................................................................
$	if .not.rno1 then goto norno1
$	   adc  runoff1/co = sort_idents,convert_index,process_rno
$	   fortran/extend'dbg' runoff1
$	   pvv   runoff1
$	   purge runoff1.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' runoff1.FOR'ver'
$norno1:
$! ............................................................................
$	if .not.rno2 then goto norno2
$	   adc  runoff2/co = describe_severity,describe_message,do_mess_line
$	   fortran/extend'dbg' runoff2
$	   pvv   runoff2
$	   purge runoff2.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' runoff2.FOR'ver'
$norno2:
$! ............................................................................
$	if .not.rno3 then goto norno3
$	   adc  runoff3/co = replace_message,get_replace_clause
$	   fortran/extend'dbg' runoff3
$	   pvv   runoff3
$	   purge runoff3.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' runoff3.FOR'ver'
$norno3:
$! ............................................................................
$	if .not.misc then goto nomisc
$	   adc  misc/co = rdchs_nl,copy_string,old_form_message,cf,swap
$	   fortran/extend'dbg' misc
$	   pvv   misc
$	   purge misc.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' misc.FOR'ver'
$nomisc:
$! ............................................................................
$do_link:
$	if .not.lnk then goto exit_neatly
$	link/map'ldbg'	newmsg,cmdline,write_program, -
			open_close,read1,read2,read3,read4, -
			runoff1,runoff2,runoff3,misc, -
			newmsg_cld, -
			newmsg_cmd, -
			newmsg.promsg_obj, -
			lsl$library:lsllib/lib
$   	purge newmsg.*
$	t$newmsg == "$''f$trnlnm(""HERE"")'newmsg"
$! ............................................................................
$exit_neatly:	set noverify
$		call exitq
$exit_only:	exit

$! *************************************************************************
$! -------------------------------------------------------------------------
$! INITQ  P1  P2  P3
$!
$! initialise the ASKQ subroutine environment
$! - opens 'P1'.BATCH appropriately
$! - sets the ASKQ environment up
$! - sets a group logical called 'P1'_IS_BUILDING
$! (note that if 'P1'_IS_BUILDING already exits, then it exits with error)
$!
$!	P1	- required, name to be used for the .BATCH command file
$!
$!	P2	- optional, Y => repeat previous answers
$!			    N => get new answers
$!			    ? => ask for Y/N
$!		       absent => as for N
$!
$!	P3	- optional, extra switches to use on INQUIREs, eg "/NOPUNCT"
$! -------------------------------------------------------------------------
$initq:	SUBROUTINE
$!
$! we have not had control-Y, nor have we opened the file
$!
$	askq_haderror    == 0
$	askq_opened_file == 0
$!
$! is there anything extra to add as a switch to our INQUIREs?
$!
$	askq_inqsw :== "''P3'"
$!
$! and what is our name?
$!
$	askq_logical_name == "''P1'_IS_BUILDING"
$!
$! is anyone already trying to use the .BATCH file?
$!
$	if f$trnlnm(askq_logical_name).eqs."" then goto initq_not_building
$	   write sys$output ""
$	   write sys$output "*** Someone else is building ''P1' ***"
$	   write sys$output ""
$	   goto initq_error_exit
$!
$initq_not_building:
$	   define/group  'askq_logical_name'  TRUE
$!
$! determine whether we are writing the .BATCH file, or reading from it
$! - if we are not interactive, then we must read from it
$! - if our argument is present and true, then we must read from it
$! - if our argument is present and "?", then we must ask the user - but
$!   obviously only if we're not in batch mode
$! - otherwise we must write it
$!
$	askq_batch = f$mode().nes."INTERACTIVE"
$!
$	if .not.askq_batch.and.P2.eqs."?" then -
	inquire/nopunct P2 "Use the last set of answers again ? "
$!
$	if P2.eqs.""  then P2 = "N"
$!
$	askq_repeat == askq_batch .or. P2
$!
$! and work out the filename (without a version number)
$!
$	askq_file1 = f$parse("HERE:''P1'.BATCH")
$	askq_file2 = f$parse(askq_file1,,,"VERSION")
$!
$	askq_filename == askq_file1 - askq_file2
$!
$! and open it appropriately
$!
$ 	if askq_repeat then goto initq_setrepeat
$	   open/write askq_file 'askq_filename
$	   askq_opened_file == 1
$	   goto end_initq
$!
$initq_setrepeat:
$	   askq_gotfile = f$search(askq_filename)
$	   if askq_gotfile.eqs."" then goto initq_notgotfile
$	      open/read askq_file 'askq_filename
$	      askq_opened_file == 1
$	      goto end_initq
$!
$initq_notgotfile:
$	   write sys$output ""
$	   write sys$output "*** Cannot find ''askq_filename' ***"
$	   write sys$output ""
$!
$initq_error_exit:
$	   askq_haderror == 1		! fake an error
$	   exit %x10000000		! and exit with an error
$!
$end_initq:
$	exit %x10000001			! exit with success
$	ENDSUBROUTINE			! initq
$!
$! -------------------------------------------------------------------------
$! ASKQ  P1
$!
$! 1) ask the user a question, record the answer in our .BATCH file
$! 2) get the appropriate answer from our .BATCH file
$!
$!	P1	- the prompt string
$!
$! returns $STATUS as true if the answer was YES, and as false if the
$! answer was NO (using normal INQUIRE conventions)
$! -------------------------------------------------------------------------
$askq:	SUBROUTINE
$!
$	if askq_haderror then exit %x10000000	! bluff NO
$	on control_y then goto askq_had_controly
$!
$	if askq_repeat then goto askq_repeat_question
$!
$	   inquire'askq_inqsw'  askq_answ  "''P1'"	! ask the question
$	   write askq_file askq_answ			! write it to the file
$ 	   goto end_askq
$!
$askq_repeat_question:
$	   read/end=askq_repeat_eof askq_file askq_answ	! get answer from file
$	   goto end_askq
$!
$askq_repeat_eof:
$	   askq_answ = "N"		! if eof found, assume NO
$	   goto end_askq
$!
$askq_had_controly:
$	   askq_haderror == 1
$	   exit
$!
$end_askq:
$	if      askq_answ then exit %x10000001		! YES
$	if .not.askq_answ then exit %x10000000		! NO
$	ENDSUBROUTINE	! askq
$!
$! -------------------------------------------------------------------------
$! SUBMITQ
$!
$! If we are repeating the previous answers, then returns $STATUS as false,
$! otherwise asks the user whether to submit for batch. If they answer Yes,
$! then returns $STATUS as true, otherwise as false. The intention is that
$! if the return is false, then the compiling, linking, etc should be done,
$! and if the answer is true, then the calling command file should submit
$! ITSELF to batch...
$! -------------------------------------------------------------------------
$submitq:	SUBROUTINE
$!
$	if .not.askq_repeat then goto askq_ask_submit
$	   askq_notnow = 0				! we want to do it
$	   goto end_submitq
$!
$askq_ask_submit:
$	inquire/nopunct askq_notnow "Submit for batch ? "
$!
$end_submitq:
$	if      askq_notnow then exit %x10000001	! don't do it now
$	if .not.askq_notnow then exit %x10000000	! do it now
$      	ENDSUBROUTINE	! submitq
$!
$! -------------------------------------------------------------------------
$! EXITQ
$!
$! Called to close the .BATCH file (and purge it), and to lose the various
$! symbols that ASKQ uses. This routine should ALWAYS be called to tidy up,
$! and should be called BEFORE the calling command file is submitted, so
$! that there is no conflict of ownership for the .BATCH file, nor on the
$! logical name that stops someone else playing with it
$! -------------------------------------------------------------------------
$exitq:	SUBROUTINE
$	if askq_opened_file then close askq_file
$	if askq_opened_file then purge 'askq_filename
$	deassign/group 'askq_logical_name
$	delete/symbol/global askq_haderror
$	delete/symbol/global askq_opened_file
$	delete/symbol/global askq_filename
$	delete/symbol/global askq_logical_name
$	delete/symbol/global askq_repeat
$	delete/symbol/global askq_inqsw
$	exit
$	ENDSUBROUTINE	! exitq
$!
