$!
$! FLN_SUBMIT.COM
$!
$! Command procedure to start the batch jobs required by
$! the flowline control system going
$! This will involve starting LSL$FLN_LOGIN:FLN_CONTROL.COM
$! on the batch queues required by the manager
$!
$! FLN_CONTROL.COM expects the following parameters:
$!	1 Mode
$!	2 Workstation id i.e. LSL$FLN_WORKSTATION
$!	3 i/o route i.e. SYS$COMMAND, TT, SYS$OUTPUT
$!	4 Wait time in integer minutes for failed automatic task request
$!	5 Batch queue for resubmission
$!	6 Optional qualifiers (e.g. /log) for SUBMIT
$!
$
$!
$!--------------------------------------------------------------------
$! Set up symbols
$!
$	ws = "write sys$output"
$!
$!--------------------------------------------------------------------
$! Say what is happening
$!
$	call clear_screen
$!
$	ws ""
$	ws "Initiation of Flowline Batch and Slave Terminal Jobs"
$	ws ""
$	ws ""
$!
$!--------------------------------------------------------------------
$! Ask which mode to operate in (BATCH/SLAVE)
$!
$ do_start:
$	ws ""
$!
$	inq/nop slave "Slave terminal mode (Y/N) [N] ? "
$!
$	if .not. slave then goto not_slave
$!
$!--------------------------------------------------------------------
$! Find out the root terminal name
$!
$	inq/nop answer "Root terminal name [lsl$dfad_analyst] ? "
$!
$	terminal = answer
$	if answer .eqs. "" then terminal = "lsl$dfad_analyst"
$!
$!--------------------------------------------------------------------
$! Ask the user number of slave terminals
$!
$	inq/nop answer "First analyst number [1] ? "
$!
$	first_sess = f$integer(answer)
$	if first_sess.eq.0 then first_sess = 1
$!
$	inq/nop answer "Last analyst number [16] ? "
$!
$	last_sess = f$integer(answer)
$	if last_sess.eq.0 then last_sess = 16
$!
$!--------------------------------------------------------------------
$! Find out slave job queue name
$!
$	inq/nop answer "Queue name [fadt_batch] ? "
$!
$	queue = answer
$	if answer .eqs. "" then queue = "fadt_batch"
$!
$	if .not. slave then goto start_batch
$!
$!--------------------------------------------------------------------
$! Ask the slave session root job name
$!
$	inq/nop slave_job "Slave session root job name [Analyst] ? "
$!
$	if slave_job .eqs. "" then slave_job = "Analyst"
$!
$!
$!--------------------------------------------------------------------
$! Ask the slave session username
$!
$	inq/nop username "Slave session username [Analyst] ? "
$!
$	if username .eqs. "" then username = "Analyst"
$!
$!--------------------------------------------------------------------
$! Initialise current terminal number
$!
$	num_sess = first_sess
$!
$!--------------------------------------------------------------------
$! Tell the user which one is being started
$!
$	ws " "
$!
$ start_slave:
$	ws "Starting slave session " + f$string(num_sess)
$!
$!--------------------------------------------------------------------
$! Now set up the analyst io terminal and job name
$!
$	io = terminal + f$string(num_sess)
$	job =  slave_job + f$string(num_sess)
$	user = username + f$string(num_sess)
$!
$!--------------------------------------------------------------------
$! Submit the session file
$!
$	submit	/noprint/nolog/nokeep/restart -
		/username = 'user' -
		/name ='job' -
		/param=(s, 'queue', 'io') -
		/queue='queue' lsl$fln_login:fln_control
$!
$!--------------------------------------------------------------------
$! Decrement current session and loop if needed
$!
$	num_sess = num_sess + 1
$	if num_sess.le.last_sess then goto start_slave
$!
$	goto do_more
$!
$!--------------------------------------------------------------------
$! Find out job queue name
$!
$ not_slave:
$!
$	inq/nop answer "Queue name [dted_batch] ? "
$!
$	queue = answer
$	if answer .eqs. "" then queue = "dted_batch"
$!
$!--------------------------------------------------------------------
$! Ask the job name
$!
$	inq/nop job "Job name [fln_control_''queue'] ? "
$!
$	if job .eqs. "" then job = "fln_control_''queue'"
$!
$!
$!--------------------------------------------------------------------
$! Ask the username
$!
$	username = queue - "_"
$	inq/nop username "Username [''username'] ? "
$!
$	if username .eqs. "" then username = queue - "_"
$!
$!--------------------------------------------------------------------
$! Ask if want a log file
$!
$	inq/nop want_log "Produce log file (Y/N) [N] ? "
$!
$	logopt = "/log=lsl$fln_log:''job'.log"
$	if .not. want_log then logopt = "/nolog"
$!
$!--------------------------------------------------------------------
$! Determine if to resubmit to this queue
$!
$	inq/nop resub "Resubmit control procedure (Y/N) [N] ? "
$!
$	resub_queue = """"""
$	if resub then resub_queue = queue
$!
$!--------------------------------------------------------------------
$! Determine wait time
$!
$	inq/nop wt "Task selection failure wait time (integer mins) ? "
$!
$	if f$integer(wt) .eq. 0 then wt = """"""
$!
$!--------------------------------------------------------------------
$! Normal batch submission
$!
$	ws " "
$!
$	submit	/noprint/restart/notify -
	        'logopt' -
		/username = 'username' -
		/name ='job' -
		/param=(b, 'queue', "", 'wt', 'resub_queue', "''logopt'") -
		/queue='queue' lsl$fln_login:fln_control
$!
$!--------------------------------------------------------------------
$! Find if any more
$!
$ do_more:
$!
$	ws " "
$!
$	inq/nop more "Any more (Y/N) [N] ? "
$!
$	if more then goto do_start
$!
$	exit
$!
$!--------------------------------------------------------------------
$! Subroutine to clear screen if operating interactively
$!
$ clear_screen:
$	SUBROUTINE
$!
$! ESC [2J		Clear the screen
$! ESC [1;1H		Move cursor to line 1, column 1
$!
$	if f$mode().eqs."INTERACTIVE" then -
		write sys$output "[2J[1;1H"
$!
$	ENDSUBROUTINE
