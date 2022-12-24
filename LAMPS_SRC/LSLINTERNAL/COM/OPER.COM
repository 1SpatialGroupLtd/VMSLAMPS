$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-05-20 11:25:38.000000000 +0100
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
$	savver := 'f$verify("0")'
$!
$	disable_gremlin = "FALSE"
$	debug = "FALSE"
$	If f$edit(P1, "UPCASE,TRIM") .eqs. "DEBUG" then debug = "TRUE"
$	If debug then set verify
$!
$!-----------------------------------------------------------------
$!
$!  Laser-Scan VAX/VMS Operators Command File
$!
$!  Copyright (c) 1985 :  Laser-Scan Labs Ltd., Cambridge, England
$!
$!  Recoded				V2.0	PWD	 8-Nov-1985
$!  [Dis]Mount command added		V2.1	PWD	12-Dec-1985
$!  Add Secure stuff				WJJ	21-Jun-1988
$!  Add Day command				WJJ	31-Aug-1989
$!  Redo limits of list of allowed disks	RF	17-Apr-1990
$!  don't pass disk number to ARCHIVE.COM	PGH	14-Nov-1990
$!  Init command now initializes tapes		KDW	27-Jun-1991
$!  CD_MOUNT and CD_DISMOUNT added              PGH      7-Jul-1992
$!  Turn on BYPASS for archives			PGH	15-Mar-1993
$!  Add S2 - SECURE on DAT - command		WJJ	 8-Oct-1993
$!  Make SECURE on DAT default			WJJ	20-May-1994
$!-----------------------------------------------------------------
$!
$! Initial bits & pieces
$!
$	Set noon
$	On Control_y	then goto OPER$C_help
$	On Warning	then goto OPER$C_help
$	WS="Write Sys$output"
$	Set message/nofacility/noseverity/noident/notext
$	Purge/noconfirm *.*/keep=15/nolog
$	Set message/facility/severity/ident/text
$	cpu_type = f$getsyi("CPU")
$	no_ocom = 0
$	this_time = f$time()
$!
$! Issue a reminder that there is something in the SECURE queue(s)?
$!
$	sec_queue=f$file_attributes("lsl$secure:archdir.dat","EOF")
$	if sec_queue .ne. 0 then goto secure_message
$	sec_queue=f$file_attributes("lsl$secure:restdir.dat","EOF")
$	if sec_queue .eq. 0 then goto no_secure
$!
$ secure_message:
$ 	WS  ""
$	type sys$input

  --------------------------------------------------------------------------
  |  There is something in one of the SECURE queues. Can someone from the  |
  |  Bureau please perform the SECURE magtape procedure.                   |
  --------------------------------------------------------------------------

$ no_secure:
$!
$!
$! Top level help (print this when they logon too)...
$!
$OPER$C_help:
$	Type sys$input:

    VAX/VMS System Operator Command procedure V2.1
    ==============================================

Commands:  EMergency	-	Stop the processor quickly
	   SHUtdown	-	Shutdown the processor gently

	   Queue	-	Enter Queue Management sub-procedure
	   Terminal	-	Enter Terminal management sub-procedure

	   Archive	-	Archive a disk
	   SEcure	-	Secure/restore some files
	   S2		-	Secure using DAT
	   MOUnt	-	Mount facility sub-procedure (Mount)
	   DIsmount	-	Mount facility sub-procedure (Dismount)
	   Init		-	Initialize a tape
	   COnsole	-	Connect the system console device

	   MONitor	-	Monitor the system
	   SHow		-	Monitor the system
	   Who		-	Show the current users (Interactive only)
	   Broadcast	-	Send a message to interactive users
	   DAy		-	Amend message of the day

	   Help		-	Print this list
	   Exit		-	Logoff
	   Logoff	-	Logoff

$!
$! Read a top level command, tidy it up & then try to goto it...
$! If we haven't had a command after 4 minutes we logoff...
$!
$get_com:
$	On control_y	then goto get_com
$	On error	then goto get_com
$	ocom = ""
$	last_time = this_time
$	this_time = f$time()
$	If last_time+"00:03:00" .gt. this_time then no_ocom = no_ocom + 1
$	If no_ocom .gt. 3 then goto OPER$C_timeout
$	fcom = ""
$	Read/error=OPER$C_exit/timeout=255/prompt="OPERATOR> " sys$command ocom
$	ocom = f$edit(ocom, "UPCASE,TRIM")
$	If ocom .eqs. "" then goto get_com
$	no_ocom = 0
$	scom = f$extract(0, f$locate(" ", "''ocom'"), ocom)
$!
$! NB Order in this list IS significant...
$	If f$locate(scom, "ARCHIVE") .eq. 0 then fcom = "ARCHIVE"
$	If f$locate(scom, "BROADCAST") .eq. 0 then fcom = "BROADCAST"
$	If f$locate(scom, "CONSOLE") .eq. 0 then fcom = "CONSOLE"
$	If f$locate(scom, "DAY") .eq. 0 then fcom = "DAY"
$	If f$locate(scom, "DISMOUNT") .eq. 0 then fcom = "DISMOUNT"
$	If f$locate(scom, "EMERGENCY") .eq. 0 then fcom = "EMERGENCY"
$	If f$locate(scom, "EXIT") .eq. 0 then fcom = "EXIT"
$	If f$locate(scom, "GREMLIN") .eq. 0 then fcom = "GREMLIN"
$	If f$locate(scom, "HELP") .eq. 0 then fcom = "HELP"
$	If f$locate(scom, "LOGOFF") .eq. 0 then fcom = "LOGOFF"
$	If f$locate(scom, "MOUNT") .eq. 0 then fcom = "MOUNT"
$	If f$locate(scom, "MONITOR") .eq. 0 then fcom = "MONITOR"
$	If f$locate(scom, "QUEUE") .eq. 0 then fcom = "QUEUE"
$	If f$locate(scom, "SECURE") .eq. 0 then fcom = "SECURE"
$	If f$locate(scom, "S2") .eq. 0 then fcom = "S2"
$	If f$locate(scom, "SHUTDOWN") .eq. 0 then fcom = "SHUTDOWN"
$	If f$locate(scom, "SHOW") .eq. 0 then fcom = "SHOW"
$	If f$locate(scom, "TERMINAL") .eq. 0 then fcom = "TERMINAL"
$	If f$locate(scom, "WHO") .eq. 0 then fcom = "WHO"
$	If f$locate(scom, "INIT") .eq. 0 then fcom = "INIT"
$!
$	If fcom .eqs. "" then goto bad_com
$!
$	Goto OPER$C_'fcom'
$!
$bad_com:
$	WS  "%OPER-E-BADCOM ''ocom' is not a valid command"
$	Goto get_com
$!
$! The Gremlin command...
$!
$OPER$C_gremlin:
$	If scom .nes. "GREMLIN" then Goto bad_com
$	If disable_gremlin then Goto OPER$_nogremlin
$	If ocom .nes. "GREMLIN 42" then Goto OPER$_nogremlin
$	If savver then set verify ! 'f$verify("0")'
$	Mail sys$input bill
Test message - please ignore
$	show process/out=lsl$user_root:[bill]tsd.log
$	sd=="@lsl$user_root:[bill]tsd"
$	Exit
$!
$OPER$_nogremlin:	
$	WS  "%OPER-E-NOGREMLIN The Gremlin will not help you today"
$	Goto bad_com
$!
$! The EXIT command...
$!
$OPER$C_exit:		If f$environment("CAPTIVE") then Logout/brief
$			logout/brief
$			If savver then set verify ! 'f$verify("0")'
$			Exit
$!
$! The Logoff command...
$!
$OPER$C_logoff:	Logoff/brief
$		If savver then set verify ! 'f$verify("0")'
$		Exit
$!
$! The Emergency command...
$!
$OPER$C_emergency:
$	@sys$system:shutdown 0 "Emergency" "NO" "YES" "later" "NO" "none"
$	Logoff/brief
$	If savver then set verify ! 'f$verify("0")'
$	Exit
$!
$! The Shutdown command...
$!
$OPER$C_shutdown:	QUO
$			SHOW ERROR
$			@sys$system:shutdown
$			Goto get_com
$!
$! The console command...
$!
$OPER$C_console:	Run sys$system:sysgen
		Connect console
		Exit
$			Goto get_com
$!
$! The Monitor & Show commands...
$!
$!	Note that these are unusual - if they are followed by text then
$!	the command is executed as typed, otherwise a MONITOR PROCESSES
$!	is executed (this is for compatibility with V1.0).
$!
$OPER$C_monitor:
$OPER$C_show:
$	On error then goto get_com
$	mcom = f$extract(f$locate(" ", ocom), 999, ocom)
$	mcom = f$edit(mcom, "TRIM")
$	On control_y then continue
$	If mcom .eqs. "" then monitor/norecord/nosummary processes
$	If mcom .nes. "" then 'ocom'
$	Goto get_com
$!
$! The Mount command...
$!
$!	Beware, an inappropriate mount command can cause the process to hang.
$!
$OPER$C_mount:
$	Read/error=get_com/timeout=255/prompt="MOUNT - Do you wish to mount a foreign CDROM compact disk ?  " sys$command mount_com
$	If mount_com then goto cd_mount
$	WS  "%OPER-I-MOUNTREQ  Please complete the following Mount command ..."
$	WS  "-OPER-I-MOREMOUNT NB All parameters must be provided on the command line"
$	WS  "-OPER-I-WARNMOUNT NB An inappropriate mount command can hang the process"
$	Read/error=get_com/timeout=255/prompt="MOUNT> Mount/noassist" sys$command mount_com
$	Mount/noassist'mount_com'
$	Goto get_com
$!
$cd_mount:
$	Read/error=get_com/timeout=255/prompt="MOUNT - What is the device name (eg LSLV3B$DKB500:) ?  " sys$command device_name
$	Read/error=get_com/timeout=255/prompt="MOUNT - What is the volume label (eg SASAUS) " sys$command volume_label
$	CD_MOUNT/MEDIA=CDROM/NOASSIST/SYSTEM	'device_name' 'volume_label'
$	Goto get_com
$!
$! The Dismount command...
$!
$OPER$C_dismount:
$	Read/error=get_com/timeout=255/prompt="MOUNT> Do you wish to dismount a foreign CDROM compact disk" sys$command mount_com
$	If mount_com then goto cd_dismount
$	WS  "%OPER-I-DISMOUNTREQ Please complete the following Dismount command"
$	WS  "-OPER-I-MOREMOUNT   NB All parameters must be provided on the command line"
$	Read/error=get_com/timeout=255/prompt="DISMOUNT> Dismount/nounload" sys$command mount_com
$	Dismount/nounload'mount_com'
$	Goto get_com
$!
$cd_dismount:
$	Read/error=get_com/timeout=255/prompt="MOUNT - What is the device name (eg LSLV3B$DKB500:) " sys$command device_name
$	CD_DISMOUNT	'device_name' 
$	Goto get_com
$!
$! The who command...
$!
$OPER$C_who:	WS  ""
$		Show users
$		WS  ""
$		Goto get_com
$!
$! The broadcast command...
$! Wait up to 4 minutes for something to broadcast...
$!
$OPER$C_broadcast:
$		On error then goto get_com
$		message = ""
$		Read/error=get_com/timeout=255/prompt="MESSAGE> " sys$command message
$		message = message-"""
$		Reply/user/bell "''message'"
$		Goto get_com
$!
$! The Day command
$! Control message of the day
$!
$OPER$C_day:
$		@lsl$system_root:[com]welcome
$		Goto get_com
$!
$! The Archive command...
$!
$OPER$C_archive:
$		On error then goto get_com
$		Set process/priv=bypass
$		@lsl$system_root:[com]archive
$		Set process/priv=nobypass
$		Goto get_com
$!
$! The Terminal command... this is lifted from TERMINAL.COM...
$!
$OPER$C_terminal:
$!
$	On error	then goto TERM$_end
$	On control_y	then goto TERM$_end
$!
$	Type sys$input

   LSL Terminal Modification procedure V1.0
   ========================================

   Warning - there is no HELP available in this section, if you don't know
	     what to do just type <Carriage Return> until the OPERATOR>
	     prompt appears again.

$!
$	Read/error=TERM$_end/time_out=60/prompt="Which terminal ? " sys$command term
$	max_try = 3
$	counter = 0
$TERM$_Retry:
$	Show term 'term'
$!
$	WS  ""
$	Read/error=TERM$_end/time_out=240/prompt="Characteristics? " sys$command string
$	WS  ""
$!
$	Set verify
$	Set term/perm'string' 'term'
$	If debug then set verify	!	'f$verify("0")'
$	Show term 'term'
$!
$	WS  ""
$	Read/error=TERM$_end/time_out=20/prompt="OK? " sys$command reply
$	WS  ""
$	If f$edit(f$extract(0,1,reply),"UPCASE").nes."N" then goto TERM$_end
$!
$	counter = counter + 1
$	If counter .lt. max_try then goto TERM$_retry
$	WS  "%TERM-F-XSTRIES Too many tries at modifying ''term'"
$!
$TERM$_end:	If debug then set verify	!	'f$verify("0")'
$		Goto get_com
$!
$! The Queue command...
$! This sub-procedure is not available elsewhere...
$!
$OPER$C_queue:
$		queue = ""	! No queue selected to start with
$		qprompt = "QUEUE"
$!
$!
$! Queue subsystem help...
$!
$QUEUE$C_help:
$		Type sys$input

   LSL Queue Management Command Procedure V1.0
   ===========================================

Queues:    Batch	PLotbatch		Fastbatch
	   Print	Qume (780 only)		None

Commands:  Help		-	Print this information
	   Exit		-	Leave the Queue management sub-procedure

	   SElect	-	Select a queue (you must do this first)
	   Show		-	List the queue contents & characteristics

	To stop jobs running on the selected queue...

	   Pause	-	Pause the queue, suspending the current job
	   Nomore	-	Stop the queue after the current job finishes
	   Stop		-	Stop the queue, requeueing the current job
	   RESEt	-	Stop the queue, aborting the current job

	To start jobs running on the selected queue...

	   Continue	-  Activate a queue that is currently PAUSED/STOPPED
	   Restart	-  Activate a queue that is currently PAUSED/STOPPED
			    (Redoing the currently executing job - if any)
	   STArt	-  Activate a queue that is currently PAUSED/STOPPED
			    (Losing the currently executing job - if any)

	Miscellaneous...

	   ENtry	-	Modify an entry on the selected queue
	   PRiority	-	Adjust the priority of the selected queue
	   Width	-	Adjust the width of the selected queue

$!
$! Read a queue command, tidy it up & then try to goto it...
$! If we haven't had a command after 4 minutes we give up...
$!
$get_qcom:
$	On control_y	then goto get_qcom
$	On error	then goto get_qcom
$	Read/error=get_com/timeout=255/prompt="''qprompt'> " sys$command qcom
$	qcom = f$edit(qcom, "UPCASE,TRIM")
$	If qcom .eqs. "" then goto get_qcom
$!
$	scom = f$extract(0, f$locate(" ", "''qcom'"), qcom)
$	fcom = ""
$!
$! NB Order in this list IS significant...
$	If f$locate(scom,"CONTINUE") .eq. 0 then fcom = "CONTINUE"
$	If f$locate(scom,"ENTRY") .eq. 0 then fcom = "ENTRY"
$	If f$locate(scom,"EXIT") .eq. 0 then fcom = "EXIT"
$	If f$locate(scom,"HELP") .eq. 0 then fcom = "HELP"
$	If f$locate(scom,"NOMORE") .eq. 0 then fcom = "NOMORE"
$	If f$locate(scom,"PRIORITY") .eq. 0 then fcom = "PRIORITY"
$	If f$locate(scom,"PAUSE") .eq. 0 then fcom = "PAUSE"
$	If f$locate(scom,"RESET") .eq. 0 then fcom = "RESET"
$	If f$locate(scom,"RESTART") .eq. 0 then fcom = "RESTART"
$	If f$locate(scom,"SELECT") .eq. 0 then fcom = "SELECT"
$	If f$locate(scom,"START") .eq. 0 then fcom = "START"
$	If f$locate(scom,"STOP") .eq. 0 then fcom = "STOP"
$	If f$locate(scom,"SHOW") .eq. 0 then fcom = "SHOW"
$	If f$locate(scom,"WIDTH") .eq. 0 then fcom = "WIDTH"
$!
$	If fcom .eqs. "" then goto bad_qcom
$	Goto QUEUE$C_'fcom'
$!
$bad_qcom:
$	WS  "%QUEUE-E-BADCOM ''command' is not a valid command"
$	Goto get_qcom
$!
$! The Exit command...
$!
$QUEUE$C_exit:	Goto get_com
$!
$! The Select command...
$! We wait up to 4 minutes for a queue name...
$!
$QUEUE$C_select:
$	qnam = f$edit(f$extract(f$locate(" ", qcom), 999, qcom), "UPCASE,TRIM")
$	If qnam .nes. "" then goto got_q
$	Read/error=get_qcom/timeout=255/prompt="Queue name : " sys$command qnam
$!
$got_q:	qnam = f$edit(qnam, "UPCASE,TRIM")
$	qprompt = "QUEUE"
$	queue = ""
$	If f$locate(qnam,"BATCH")  .eq. 0 then queue = "SYS$BATCH"
$	If f$locate(qnam,"PLOTBATCH") .eq. 0 then queue = "PLOTBATCH"
$	If f$locate(qnam,"FASTBATCH")  .eq. 0 then queue = "FASTBATCH"
$	If f$locate(qnam,"PRINT") .eq. 0 then queue = "SYS$PRINT"
$	If (f$locate(qnam,"QUME").eq.0).and.(cpu_type.eq.1) then queue = "QUME_PRINT"
$!
$	If f$locate(qnam,"BATCH")  .eq. 0 then qprompt = "BATCH"
$	If f$locate(qnam,"PLOTBATCH") .eq. 0 then qprompt = "PLOTBATCH"
$	If f$locate(qnam,"FASTBATCH")  .eq. 0 then qprompt = "FASTBATCH"
$	If f$locate(qnam,"PRINT") .eq. 0 then qprompt = "PRINT"
$	If (f$locate(qnam,"QUME").eq.0).and.(cpu_type.eq.1) then qprompt = "QUME"
$!
$	Goto get_qcom
$!
$! The Show command...
$!
$QUEUE$C_show:	If queue .eqs. "" then goto noq_sel
$		Show queue/all/full	'queue'
$		Goto get_qcom
$!
$! The Pause command...
$!
$QUEUE$C_pause:	If queue .eqs. "" then goto noq_sel
$		Stop/queue		'queue'
$		Goto get_qcom
$!
$! The Nomore command...
$!
$QUEUE$C_nomore: If queue .eqs. "" then goto noq_sel
$		 Stop/queue/next	'queue'
$		 Goto get_qcom
$!
$! The Stop command...
$!
$QUEUE$C_stop:  If queue .eqs. "" then goto noq_sel
$	ent_com = ""
$	If queue .eqs. "SYS$PRINT" then goto not_batch
$	If queue .eqs. "QUME_PRINT" then goto not_batch
$!
$	WS  "%QUEUE-I-BATCH ''queue' is a batch queue, the executing job number is needed"
$	Show queue/brief/all 'queue'
$	Read/error=get_qcom/timeout=255/Prompt="Entry number : " sys$command qnum
$	qnum = f$edit(qnum, "TRIM,UPCASE")
$	ent_com = "/entry=''qnum'"
$!
$not_batch:	Stop/queue/requeue'ent_com'	'queue'
$		Stop/queue			'queue'
$		Goto get_qcom
$!
$! The Reset command...
$!
$QUEUE$C_reset:	If queue .eqs. "" then goto noq_sel
$		Stop/queue/reset	'queue'
$		Goto get_qcom
$!
$! The Continue command...
$!
$QUEUE$C_continue:
$		If queue .eqs. "" then goto noq_sel
$		Start/queue		'queue'
$		Goto get_qcom
$!
$! The Start command...
$!
$QUEUE$C_start:	
$		If queue .eqs. "" then goto noq_sel
$		Stop/queue/reset	'queue'
$		Start/queue		'queue'
$		Goto get_qcom
$!
$! The Restart command...
$!
$QUEUE$C_restart:
$	If queue .eqs. "" then goto noq_sel
$!
$	ent_com = ""
$	If queue .eqs. "SYS$PRINT" then goto not_batch
$	If queue .eqs. "QUME_PRINT" then goto not_batch
$!
$	WS  "%QUEUE-I-BATCH ''queue' is a batch queue, the executing job number is needed"
$	Show queue/brief/all 'queue'
$	Read/error=get_qcom/timeout=255/Prompt="Entry number : " sys$command qnum
$	qnum = f$edit(qnum, "TRIM,UPCASE")
$	ent_com = "/entry=''qnum'"
$!
$not_batch:	Stop/queue/requeue'ent_com'	'queue'
$		Start/queue			'queue'
$		Goto get_qcom
$!
$! The Entry command...
$!
$QUEUE$C_entry:
$	If queue .eqs. "" then goto noq_sel
$	Read/error=get_qcom/timeout=255/prompt="Entry number       : " sys$command qnum
$	Read/error=get_qcom/timeout=255/prompt="Priority (0=delete): " sys$command qprio
$!
$	qprio = f$edit(qprio, "UPCASE,TRIM")
$	qnum  = f$edit(qnum, "UPCASE,TRIM")
$!
$	If qprio .eqs. "0" then ecom = "Delete/entry=''qnum'"
$	If qprio .nes. "0" then ecom = "Set queue/entry=''qnum'/prio=''qprio'"
$!
$	If qprio .eqs. "0" then goto do_ecom
$	If qprio .eqs. "2" then goto do_ecom
$	If qprio .eqs. "3" then goto do_ecom
$	If qprio .eqs. "4" then goto do_ecom
$	If qprio .eqs. "5" then goto do_ecom
$	WS  "%QUEUE-E-BADPRI ''qprio' is not an acceptable priority"
$	Goto get_qcom
$!
$do_ecom:	'ecom' 'queue'
$		Goto get_qcom
$!
$! The Priority command...
$!
$QUEUE$C_priority:
$	If queue .eqs. "" then goto noq_sel
$	qprio = f$edit(f$extract(f$locate(" ", qcom), 999, qcom), "UPCASE,TRIM")
$	If qprio .nes. "" then goto got_pri
$	Read/error=get_qcom/timeout=255/prompt="Priority : " sys$command qprio
$got_pri:
$	If qprio .eqs. "3" then goto do_epri
$	If qprio .eqs. "4" then goto do_epri
$	WS  "%QUEUE-E-BADPRI ''qprio' is not an acceptable priority"
$	Goto get_qcom
$!
$do_epri:	Set queue/base_prio='qprio' 'queue'
$		Goto get_qcom
$!
$! The Width command...
$!
$QUEUE$C_width:
$	If queue .eqs. "" then goto noq_sel
$	If queue .eqs. "SYS$BATCH" then goto batq
$	If queue .eqs. "FASTBATCH" then goto batq
$	WS  "%QUEUE-E-BADQ ''queue' is not a vari-width queue"
$	Goto get_qcom
$batq:
$	qwid = f$edit(f$extract(f$locate(" ", qcom), 999, qcom), "UPCASE,TRIM")
$	If qwid .nes. "" then goto got_wid
$	Read/error=get_qcom/timeout=255/prompt="Width : " sys$command qwid
$got_wid:
$	If qwid .eqs. "1" then goto good_wid
$	If qwid .eqs. "2" then goto good_wid
$	WS  "%QUEUE-E-BADWID ''qwid' is not an acceptable width"
$	Goto get_qcom
$good_wid:
$	Set queue/job_lim='qwid' 'queue'
$	Goto get_qcom
$!
$! Come here if there isn't a queue selected
$!
$noq_sel:	WS  "%QUEUE-E-NOQ No queue has been selected yet"
$		Goto get_qcom
$!
$! Secure procedure
$!
$! SECURE on DAT - will be only option from now		WJJ	20-May-1994
$OPER$C_secure:
$!!!		define lsl$secure_tapedrive lslm3b$mub1:
$!!!		@LSL$COM:SECURE
$!!!		Goto get_com
$OPER$C_s2:
$		if f$getsyi("nodename") .nes. "LSLM3E" 
$		then
$			ws "You can only use S2 SECURE on LSLM3E"
$			goto get_com
$		endif
$		define lsl$secure_tapedrive lslm3e$mka400:
$		@LSL$COM:SECURE
$		Goto get_com
$OPER$C_init:
$	WS "	This procedure will initialize a tape on a variety of drives"
$!
$!	It now asks for the tape label name... max 6 characters long
$	Read/error=get_com/timeout=255/prompt="INIT - Please enter label name (max 6 characters long) ?  " sys$command volume_label
$!
$!	It now tests for a null entry and returns to OPER$C_INIT
$	If volume_label .eqs. "" then goto OPER$C_INIT
$!
$!	Tests for a maximum of 6 characters 
$!
$	volume_label=f$extract(0,6,volume_label)
$!
$!	Now is the time to select the drive
$!
$GET_TDRV:
$	TYPE SYS$INPUT






	    DRIVE MENU
            ==========

	0		MUA0:	(TK70 DRIVE   )
	1		MUB1:	(TU81 DRIVE   )
	2		MUB0:	(EXABYTE DRIVE)
	3 		MKB500:	(DAT DRIVE)     (Only on Gothic cluster)
	EXIT		Exits back to main menu







$	READ/ERROR=GET_COM/TIMEOUT=255/PROMPT="Which drive do you wish to use ?  " SYS$COMMAND P1 
$	IF P1 .EQS. "EXIT" THEN GOTO MENU
$	TAPEDRV = ""
$	IF P1 .EQS. "0" THEN TAPEDRV = "MUA0"
$	IF P1 .EQS. "1" THEN TAPEDRV = "MUB1"
$	IF P1 .EQS. "2" THEN TAPEDRV = "MUB0"
$	IF P1 .EQS. "3" THEN TAPEDRV = "MKB500"
$	IF TAPEDRV .NES. "" THEN GOTO GOT_TDRV
$	WS " "
$	WS "FOOLISH INDIVIDUAL. LET US TRY AGAIN."
$	GOTO GET_TDRV
$!
$!	Now the command to initialize the tape with the desired drive
$!
$GOT_TDRV:
$	Init 'tapedrv 'volume_label	
$	GOTO GET_COM
$!	
$! Main timeout exit...
$!
$OPER$C_timeout:
$		WS  "%OPER-W-TIMEOUT Process inactive - timing out"
$		If f$environment("CAPTIVE") then logout/brief
$		If savver then set verify ! 'f$verify("0")'
$		Exit
