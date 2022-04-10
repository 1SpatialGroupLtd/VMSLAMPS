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
$!  Version for LKB (without [Dis]Mount		RWR	 2-Sep-1986
$!  [Dis]Mount command added		V2.1	PWD	12-Dec-1985
$!  Recoded				V2.0	PWD	 8-Nov-1985
$!
$!-----------------------------------------------------------------
$!
$! Initial bits & pieces
$!
$	Set noon
$	On Control_y	then goto OPER$C_help
$	On Warning	then goto OPER$C_help
$	Set message/nofacility/noseverity/noident/notext
$	Purge/noconfirm *.*/keep=15/nolog
$	Set message/facility/severity/ident/text
$	cpu_type = f$getsyi("CPU")
$	no_ocom = 0
$	this_time = f$time()
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

	   Monitor	-	Monitor the system
	   Show		-	Monitor the system
	   Who		-	Show the current users (Interactive only)
	   Broadcast	-	Send a message to interactive users

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
$!	If f$locate(scom, "CONSOLE") .eq. 0 then fcom = "CONSOLE"
$!	If f$locate(scom, "DISMOUNT") .eq. 0 then fcom = "DISMOUNT"
$	If f$locate(scom, "EMERGENCY") .eq. 0 then fcom = "EMERGENCY"
$	If f$locate(scom, "EXIT") .eq. 0 then fcom = "EXIT"
$	If f$locate(scom, "GREMLIN") .eq. 0 then fcom = "GREMLIN"
$	If f$locate(scom, "HELP") .eq. 0 then fcom = "HELP"
$	If f$locate(scom, "LOGOFF") .eq. 0 then fcom = "LOGOFF"
$!	If f$locate(scom, "MOUNT") .eq. 0 then fcom = "MOUNT"
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
$	Write sys$output "%OPER-E-BADCOM ''ocom' is not a valid command"
$	Goto get_com
$!
$! The Gremlin command...
$!
$OPER$C_gremlin:
$	If ocom .nes. "GREMLIN" then Goto bad_com
$	If disable_gremlin then Goto OPER$_nogremlin
$	If savver then set verify ! 'f$verify("0")'
$	Exit
$!
$OPER$_nogremlin:	
$	Write sys$output "%OPER-E-NOGREMLIN The Gremlin has been liquidated"
$	Goto bad_com
$!
$! The EXIT command...
$!
$OPER$C_exit:		If f$environment("CAPTIVE") then Logout/brief
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
$! The who command...
$!
$OPER$C_who:	Write sys$output ""
$		Show users
$		Write sys$output ""
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
$! The Archive command...
$! Wait up to 4 minutes for a disk name...
$!
$OPER$C_archive:
$	On error then goto get_com
$	disk = "0"
$	Read/error=get_com/timeout=255/prompt="Archive which disk (0,1,2,3 or 4) ? " sys$command disk
$	disk = f$edit(disk, "TRIM")
$	If disk .eqs. "0" then goto got_disk
$	If disk .eqs. "1" then goto got_disk
$	If disk .eqs. "2" then goto got_disk
$	If disk .eqs. "3" then goto got_disk
$	If disk .eqs. "4" then goto got_disk
$	If disk .eqs. "7" then goto got_disk
$!
$	Write sys$output "%OPER-E-BADDISK ''disk' is not a valid disk number"
$	Goto get_com
$!
$got_disk:	@sys$sysdevice:[oper]archive 'disk'
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
$	Write sys$output ""
$	Read/error=TERM$_end/time_out=240/prompt="Characteristics? " sys$command string
$	Write sys$output ""
$!
$	Set verify
$	Set term/perm'string' 'term'
$	If debug then set verify	!	'f$verify("0")'
$	Show term 'term'
$!
$	Write sys$output ""
$	Read/error=TERM$_end/time_out=20/prompt="OK? " sys$command reply
$	Write sys$output ""
$	If f$edit(f$extract(0,1,reply),"UPCASE").nes."N" then goto TERM$_end
$!
$	counter = counter + 1
$	If counter .lt. max_try then goto TERM$_retry
$	Write sys$output "%TERM-F-XSTRIES Too many tries at modifying ''term'"
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
$	Write sys$output "%QUEUE-E-BADCOM ''command' is not a valid command"
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
$	Write sys$output "%QUEUE-I-BATCH ''queue' is a batch queue, the executing job number is needed"
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
$	Write sys$output "%QUEUE-I-BATCH ''queue' is a batch queue, the executing job number is needed"
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
$	Write sys$output "%QUEUE-E-BADPRI ''qprio' is not an acceptable priority"
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
$	Write sys$output "%QUEUE-E-BADPRI ''qprio' is not an acceptable priority"
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
$	Write sys$output "%QUEUE-E-BADQ ''queue' is not a vari-width queue"
$	Goto get_qcom
$batq:
$	qwid = f$edit(f$extract(f$locate(" ", qcom), 999, qcom), "UPCASE,TRIM")
$	If qwid .nes. "" then goto got_wid
$	Read/error=get_qcom/timeout=255/prompt="Width : " sys$command qwid
$got_wid:
$	If qwid .eqs. "1" then goto good_wid
$	If qwid .eqs. "2" then goto good_wid
$	Write sys$output "%QUEUE-E-BADWID ''qwid' is not an acceptable width"
$	Goto get_qcom
$good_wid:
$	Set queue/job_lim='qwid' 'queue'
$	Goto get_qcom
$!
$! Come here if there isn't a queue selected
$!
$noq_sel:	Write sys$output "%QUEUE-E-NOQ No queue has been selected yet"
$		Goto get_qcom
$!
$! Main timeout exit...
$!
$OPER$C_timeout:
$		Write sys$output "%OPER-W-TIMEOUT Process inactive - timing out"
$		If f$environment("CAPTIVE") then logout/brief
$		If savver then set verify ! 'f$verify("0")'
$		Exit
