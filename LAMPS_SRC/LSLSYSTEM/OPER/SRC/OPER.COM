$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-02-27 14:56:00.000000000 +0000
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
$!-----------------------------------------------------------------
$!
$!  Example VAX/VMS Operators Command File
$!
$!  Created by Laser-Scan Ltd, Cambridge, England,
$!
$!  Original				V1.0	AJW	12-Dec-1981
$!  Recoded				V2.0	PWD	 8-Nov-1985
$!  Rehashed				V3.0	PGH	12-Feb-1990
$!  More tidies				V3.1	PGH	27-Feb-1990
$!
$! Note:
$!  This file is provided as an example of a command procedure to
$!  automate some of the daily/weekly system admin tasks for VMS.
$!  It is not intended to be suitable "as is" for every site, and
$!  may well require changing to suit local requirements.
$!
$!-----------------------------------------------------------------
$!
$! Initial bits & pieces
$!
$	Set noon
$	debug = "FALSE"
$	ws = "write sys$output"
$	If f$edit(P1, "UPCASE,TRIM") .eqs. "DEBUG" then debug = "TRUE"
$	If debug then set verify
$!
$	ws " "
$	ws "LSL VAX/VMS System Operator Command procedure V3.1",-
		" at ",f$time()
$	ws " "
$!
$	if .not.f$priv("SYSPRV,OPER")
$	then 
$	   ws "%OPER-F-NOPRIV, at least SYSPRV and OPER privileges needed for sensible results"
$	   goto OPER$C_exit
$	endif
$!
$	On Control_y	then goto OPER$C_help
$	On Warning	then goto OPER$C_help
$	if f$search("*.tmp;-3").nes."" 
$	then
$	   Set message/nofacility/noseverity/noident/notext
$	   Purge/noconfirm *.tmp/keep=3/nolog
$	   Set message/facility/severity/ident/text
$	endif
$	cpu_type = f$getsyi("CPU")
$	no_ocom = 0
$	this_time = f$time()
$	ws "For a list of commands and help information, type HELP or ?"
$	ws " "
$	goto get_com
$!
$! Top level help 
$!
$OPER$C_help:
$	Type sys$input:

Commands:  EMergency	-	Stop the processor quickly
	   SHUtdown	-	Shutdown the processor gently
	   Console	-	Connect the system console device

	   Queue	-	Enter Queue Management sub-procedure
	   Terminal	-	Enter Terminal management sub-procedure

	   Archive	-	Archive a disk
	   MOUnt	-	Mount facility sub-procedure (Mount)
	   Dismount	-	Mount facility sub-procedure (Dismount)

	   Monitor	-	Monitor the system
	   SHOw		-	Show the system
	   Who		-	Show the current users (Interactive only)
	   Broadcast	-	Send a message to interactive users
	   Day		-	Amend message of the day

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
$	If ocom .eqs. "?" then goto OPER$C_help
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
$	If f$locate(scom, "HELP") .eq. 0 then fcom = "HELP"
$	If f$locate(scom, "LOGOFF") .eq. 0 then fcom = "LOGOFF"
$	If f$locate(scom, "MOUNT") .eq. 0 then fcom = "MOUNT"
$	If f$locate(scom, "MONITOR") .eq. 0 then fcom = "MONITOR"
$	If f$locate(scom, "QUEUE") .eq. 0 then fcom = "QUEUE"
$	If f$locate(scom, "SHUTDOWN") .eq. 0 then fcom = "SHUTDOWN"
$	If f$locate(scom, "SHOW") .eq. 0 then fcom = "SHOW"
$	If f$locate(scom, "TERMINAL") .eq. 0 then fcom = "TERMINAL"
$	If f$locate(scom, "WHO") .eq. 0 then fcom = "WHO"
$!
$	If fcom .eqs. "" then goto bad_com
$!
$	Goto OPER$C_'fcom'
$!
$bad_com:
$	ws "%OPER-E-BADCOM ''ocom' is not a valid command"
$	Goto get_com
$!
$! The EXIT command...
$!
$OPER$C_logoff:
$OPER$C_exit:
$	If f$environment("CAPTIVE") then Logout/brief
$	If savver then set verify ! 'f$verify("0")'
$	Exit
$!
$! The Emergency command...
$!
$OPER$C_emergency:
$	@sys$system:shutdown 0 "Emergency" "NO" "YES" "later" "NO" "none"
$	goto get_com		! should never happen
$!
$! The Shutdown command...
$!
$OPER$C_shutdown:
$	SHOW USERS/NODE
$	SHOW ERROR
$	@sys$system:shutdown
$	goto get_com		! should never happen
$!
$! The console command...
$!
$OPER$C_console:
$	if .not.f$priv("CMKRNL")
$	then 
$	   ws "%OPER-F-NOPRIV, CMKRNL privilege needed for SYSGEN operations"
$	   goto get_com
$	endif
$	Run sys$system:sysgen
		Connect console
		Exit
$	ws "Console Connected"
$	Goto get_com
$!
$! The Monitor & Show commands...
$!
$!	Note that these are unusual - if they are followed by text then
$!	the command is executed as typed, otherwise a MON SYS or SH SYS
$!	is executed (this is for compatibility with V1.0).
$!
$OPER$C_monitor:
$OPER$C_show:
$	On error then goto get_com
$	mcom = f$extract(f$locate(" ", ocom), 999, ocom)
$	mcom = f$edit(mcom, "TRIM")
$	On control_y then continue
$	if mcom.eqs."" then mcom="SYSTEM"
$	'fcom' 'mcom'
$	Goto get_com
$!
$! The Mount command...
$!
$!	Beware, an inappropriate mount command can cause the process to hang.
$!
$OPER$C_mount:
$	ws "%OPER-I-MOUNTREQ  Please complete the following Mount command ..."
$	ws "-OPER-I-MOREMOUNT NB All parameters must be provided on the command line"
$	ws "-OPER-I-WARNMOUNT NB An inappropriate mount command can hang the process"
$	Read/error=get_com/timeout=255/prompt="MOUNT> Mount/noassist" sys$command mount_com
$	Mount/noassist'mount_com'
$	Goto get_com
$!
$! The Dismount command...
$!
$OPER$C_dismount:
$	ws "%OPER-I-DISMOUNTREQ Please complete the following Dismount command"
$	ws "-OPER-I-MOREMOUNT   NB All parameters must be provided on the command line"
$	Read/error=get_com/timeout=255/prompt="DISMOUNT> Dismount/nounload" sys$command mount_com
$	Dismount/nounload'mount_com'
$	Goto get_com
$!
$! The who command...
$!
$OPER$C_who:
$	ws ""
$	Show users/node
$	ws ""
$	Goto get_com
$!
$! The broadcast command...
$! Wait up to 4 minutes for something to broadcast...
$!
$OPER$C_broadcast:
$	On error then goto get_com
$	message = ""
$	Read/error=get_com/timeout=255/prompt="MESSAGE> " sys$command message
$	message = message-"""
$	Reply/all/bell "''message'"
$	Goto get_com
$!
$! The Day command
$! Control message of the day (sometimes called WELCOME.TXT)
$!
$OPER$C_day:
$	edit sys$manager:message.day
$	Goto get_com
$!
$! The Archive command - use separate archive procedure
$!
$OPER$C_archive:
$	@ARCHIVE.COM
$	Goto get_com
$!
$! The Terminal command... this is lifted from TERMINAL.COM...
$!
$OPER$C_terminal:
$!
$	On error	then goto TERM$_end
$	On control_y	then goto TERM$_end
$!
$	ws " "
$	ws "LSL Terminal Modification procedure - type ? for help"
$	ws " "
$	if .not.f$priv("PHY_IO")
$	then 
$	   ws "%OPER-F-NOPRIV, PHY_IO privilege needed for terminal operations"
$	   goto get_com
$	endif
$!
$	Read/error=TERM$_end/time_out=60/prompt="Which terminal ? " sys$command term
$	if term.eqs."?"
$	then
$	   ws " "
$	   ws "Terminal names are of the form TTcn: or TXcn:, as follows:"
$	   ws " "
$	   show dev t
$	   goto OPER$C_terminal
$	endif
$	max_try = 3
$	counter = 0
$TERM$_Retry:
$	ws " "
$	Show term 'term'
$!
$	ws ""
$	Read/error=TERM$_end/time_out=240/prompt="Characteristics? " sys$command string
$	ws ""
$	if string.eqs."?"
$	then
$	   ws " "
$	   ws "Specify required charactistics in the form of /option/option as in:"
$	   ws "/TYPEAHEAD/NOECHO/SPEED=9600"
$	   goto TERM$_Retry
$	endif
$!
$	Set verify
$	Set term/perm'string' 'term'
$	If debug then set verify	!	'f$verify("0")'
$	Show term 'term'
$	ws ""
$!
$TERM$_end:	If debug then set verify	!	'f$verify("0")'
$		Goto get_com
$!
$! The Queue command...
$! This sub-procedure is not available elsewhere...
$!
$OPER$C_queue:
$	queue = ""	! No queue selected to start with
$	qprompt = "QUEUE"
$	qcom = ""
$	qname = ""
$	ws " "
$	ws "LSL queue management - type ? for help"
$	goto get_qcom
$!
$! Queue subsystem help...
$!
$QUEUE$C_help:
$		Type sys$input

Commands:  Help		-	Print this information
	   Exit		-	Leave the Queue management sub-procedure

	   SElect	-	Select a queue (you must do this first)
	   Show		-	List the queue contents & characteristics

	To stop jobs running on the selected queue...

	   Pause	-	Pause the queue, suspending the current job
	   STOp		-	Stop the queue after the current job finishes
	   Abort	-	Abort the current job - if any
	   REQueue	-  	Requeue the currently executing job - if any
	   RESEt	-	Stop the queue, aborting the current job

	To start jobs running on the selected queue...

	   Continue	-  Activate a queue that is currently PAUSED/STOPPED
	   STArt	-  Activate a queue that is currently PAUSED/STOPPED

	Miscellaneous...

	   ENtry	-	Modify an entry on the selected queue
	   PRiority	-	Adjust the priority of the selected queue
	   Width	-	Adjust the width of the selected queue

$!
$	if queue.eqs."" then goto QUEUE$C_list
$	goto get_qcom
$!
$! Read a queue command, tidy it up & then try to goto it...
$! If we haven't had a command after 4 minutes we give up...
$!
$get_qcom:
$	On control_y	then goto get_qcom
$	On error	then goto get_qcom
$	if queue.eqs."" then goto QUEUE$C_select
$	ws " "
$	Read/error=get_com/timeout=255/prompt="''qprompt'> " sys$command qcom
$	qcom = f$edit(qcom, "UPCASE,TRIM")
$	If qcom .eqs. "" then goto get_qcom
$	If qcom .eqs. "?" then goto QUEUE$C_help
$!
$	scom = f$extract(0, f$locate(" ", "''qcom'"), qcom)
$	fcom = ""
$!
$! NB Order in this list IS significant...
$	If f$locate(scom,"ABORT") .eq. 0 then fcom = "ABORT"
$	If f$locate(scom,"CONTINUE") .eq. 0 then fcom = "CONTINUE"
$	If f$locate(scom,"ENTRY") .eq. 0 then fcom = "ENTRY"
$	If f$locate(scom,"EXIT") .eq. 0 then fcom = "EXIT"
$	If f$locate(scom,"HELP") .eq. 0 then fcom = "HELP"
$	If f$locate(scom,"PRIORITY") .eq. 0 then fcom = "PRIORITY"
$	If f$locate(scom,"PAUSE") .eq. 0 then fcom = "PAUSE"
$	If f$locate(scom,"REQUEUE") .eq. 0 then fcom = "REQUEUE"
$	If f$locate(scom,"RESET") .eq. 0 then fcom = "RESET"
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
$	ws "%QUEUE-E-BADCOM ''command' is not a valid command"
$	Goto get_qcom
$!
$! The Exit command...
$!
$QUEUE$C_exit:	Goto get_com
$!
$! The List command...
$!
$QUEUE$C_list:
$	temp = f$getqui("") 
$	qtype="Symbiont"
$qscan:
$	ws " "
$	ws "''qtype' Queues available:"
$	ws " "
$qloop: 
$	qname = f$getqui("display_queue","queue_name","*",qtype)
$	if qname .nes. "" 
$	then 
$	   ws qname
$	   goto qloop
$	endif
$	if qtype .nes. "Batch" 
$	then
$	   qtype="Batch"
$	   goto qscan
$	endif
$	ws " "
$	Goto get_qcom
$!
$! The Select command...
$! We wait up to 4 minutes for a queue name...
$!
$QUEUE$C_select:
$	qname = f$edit(f$extract(f$locate(" ", qcom), 999, qcom), "UPCASE,TRIM")
$	If qname .nes. "" then goto got_q
$	ws " "
$	Read/error=get_com/timeout=255/prompt="Queue name [? for list] ? " sys$command qname
$got_q:	
$	If qname .eqs. "?" then goto QUEUE$C_help
$	qname = f$edit(qname, "UPCASE,TRIM")
$	qprompt = "QUEUE"
$	queue = f$getqui("display_queue","queue_name",qname)
$	if queue.eqs."" 
$	then 
$	   ws "%OPER-W-NOQUEUE - no such queue as ",qname
$	   goto QUEUE$C_select
$	endif
$	qprompt = queue
$!
$! fall through to SHOW
$!
$! The Show command...
$!
$QUEUE$C_show:
$	If queue .eqs. "" then goto noq_sel
$	ws " "
$	Show queue/all/full	'queue'
$	Goto get_qcom
$!
$! The Pause command...
$!
$QUEUE$C_pause:
$	If queue .eqs. "" then goto noq_sel
$	Stop/queue	'queue'
$	ws "Queue ",queue," paused"
$	Goto get_qcom
$!
$! The STOP command...
$!
$QUEUE$C_stop:
$	If queue .eqs. "" then goto noq_sel
$	Stop/queue/next	'queue'
$	ws "Queue ",queue," stopped after next job"
$	Goto get_qcom
$!
$! The Abort command...
$!
$QUEUE$C_abort:
$	If queue .eqs. "" then goto noq_sel
$	entryno = f$getqui("display_entry","entry_number",queue,"executing_jobs")
$	isbatch = f$getqui("display_queue","queue_batch",queue)
$	if entryno.eqs."" 
$	then
$	   ws "Queue ",queue," has nothing to abort"
$	   goto get_qcom
$	endif
$	if isbatch
$	then
$	   abocom = "/entry=''entryno'"
$	else
$	   abocom = "/abort"
$	endif
$	Stop/queue'abocom'	'queue'
$	ws "Queue ",queue," entry ''entryno' aborted
$	Goto get_qcom
$!
$! The Requeue command...
$!
$QUEUE$C_requeue:
$	If queue .eqs. "" then goto noq_sel
$	entryno = f$getqui("display_entry","entry_number",queue,"executing_jobs")
$	isbatch = f$getqui("display_queue","queue_batch",queue)
$	if entryno.eqs."" 
$	then
$	   ws "Queue ",queue," has nothing to requeue"
$	   goto get_qcom
$	endif
$	if isbatch
$	then
$	   reqcom = "/requeue/entry=''entryno'"
$	else
$	   reqcom = "/requeue"
$	endif
$	Stop/queue'reqcom'	'queue'
$	ws "Queue ",queue," entry ''entryno' requeued"
$	Goto get_qcom
$!
$! The Reset command...
$!
$QUEUE$C_reset:	
$	If queue .eqs. "" then goto noq_sel
$	Stop/queue/reset	'queue'
$	ws "Queue ",queue," reset"
$	Goto get_qcom
$!
$! The Continue command...
$! The Start command...
$!
$QUEUE$C_continue:
$QUEUE$C_start:	
$	If queue .eqs. "" then goto noq_sel
$	Start/queue		'queue'
$	ws "Queue ",queue," continued"
$	Goto get_qcom
$!
$! The Entry command...
$!
$QUEUE$C_entry:
$	If queue .eqs. "" then goto noq_sel
$	Read/error=get_qcom/timeout=255/prompt="Entry number       : " sys$command qnum
$	qnum  = f$edit(qnum, "UPCASE,TRIM")
$	if qnum.eqs."?" then goto QUEUE$C_show
$!
$	Read/error=get_qcom/timeout=255/prompt="Priority (0=delete): " sys$command qprio
$	qprio = f$edit(qprio, "UPCASE,TRIM")
$!
$	If qprio .eqs. "0" then ecom = "Delete/entry=''qnum'"
$	If qprio .nes. "0" then ecom = "Set queue/entry=''qnum'/prio=''qprio'"
$!
$	qprio_type=f$type(qprio)
$	If qprio_type .eqs. "INTEGER" then goto do_ecom
$	ws "%QUEUE-E-BADPRI ''qprio' is not an acceptable priority"
$	Goto get_qcom
$!
$do_ecom:
$	'ecom' 'queue'
$	Goto get_qcom
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
$	ws "%QUEUE-E-BADPRI ''qprio' is not an acceptable priority"
$	Goto get_qcom
$!
$do_epri:
$	Set queue/base_prio='qprio' 'queue'
$	Goto get_qcom
$!
$! The Width command...
$!
$QUEUE$C_width:
$	If queue .eqs. "" then goto noq_sel
$	isbatch = f$getqui("display_queue","queue_batch",queue)
$	If isbatch then goto batq
$	ws "%QUEUE-E-BADQ ''queue' is not a vari-width queue"
$	Goto get_qcom
$batq:
$	qwid = f$edit(f$extract(f$locate(" ", qcom), 999, qcom), "UPCASE,TRIM")
$	If qwid .nes. "" then goto got_wid
$	Read/error=get_qcom/timeout=255/prompt="Width : " sys$command qwid
$got_wid:
$	If qwid .eqs. "1" then goto good_wid
$	If qwid .eqs. "2" then goto good_wid
$	ws "%QUEUE-E-BADWID ''qwid' is not an acceptable width"
$	Goto get_qcom
$good_wid:
$	Set queue/job_lim='qwid' 'queue'
$	Goto get_qcom
$!
$! Come here if there isn't a queue selected
$!
$noq_sel:
$	ws "%QUEUE-E-NOQ No queue has been selected yet"
$	Goto get_qcom
$!
$! Main timeout exit...
$!
$OPER$C_timeout:
$	ws "%OPER-W-TIMEOUT Process inactive - timing out"
$	goto OPER$C_exit
