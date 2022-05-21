$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-10-10 18:06:08.000000000 +0100
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
$	on warning then continue
$!
$! Modified CC Brunt	10-October-1991
$! Better version
$!
$! FLN_CONTROL_ANALYST.COM
$!
$! Command procedure to start the DFAD analyst slave terminal
$! batch jobs 
$! This will involve starting LSL$FLN_LOGIN:FLN_CONTROL.COM
$! on the FADT_BATCH queues
$!
$! If parameter 1 (p1) is H, analysts are halted
$! If S, they are started.
$! Otherwise stop and restart is done.
$!
$! FLN_CONTROL.COM expects the following parameters:
$!	1 Mode
$!	2 Workstation id i.e. LSL$FLN_WORKSTATION = FADT_BATCH
$!	3 i/o route i.e. SYS$COMMAND, TT, SYS$OUTPUT
$!	4 Wait time in integer minutes for failed automatic task request
$!	5 Batch queue for resubmission
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
$	ws "Control of DFAD Flowline Analyst Terminal Jobs"
$	ws ""
$	ws ""
$!
$!--------------------------------------------------------------------
$! Determine, on the basis of p1 whether to halt, start or both, the
$! DFAD analyst jobs
$!
$	want_start = "t"
$	want_halt  = "t"
$!
$	param = f$edit(p1,"upcase") + " "
$	param = f$extract(0,1,param)
$!
$	if param.eqs."H" then want_start = ""
$	if param.eqs."S" then want_halt  = ""
$!
$!--------------------------------------------------------------------
$! Set up the root terminal name
$!
$	terminal = "lsl$dfad_analyst"
$!
$!--------------------------------------------------------------------
$! Set first and last analyst numbers
$!
$	first_sess = 1
$!
$	last_sess = 16
$!
$!--------------------------------------------------------------------
$! Set slave terminal job queue name
$!
$	queue = "fadt_batch"
$	queue_root = "fadt_batch"	! get generic queue too
$!
$!--------------------------------------------------------------------
$! Set root username
$!
$	username = "ANALYST"
$!
$!--------------------------------------------------------------------
$! Determine if want to delete existing analyst jobs
$!
$	if .not.want_halt then goto start_analysts
$!
$!--------------------------------------------------------------------
$! Reset f$getqui context
$!
$	temp = f$getqui("CANCEL_OPERATION")
$!
$!--------------------------------------------------------------------
$! Set up context to next queue matching fadt_batch*
$!
$next_queue:
$	queue_name = f$getqui("DISPLAY_QUEUE","QUEUE_NAME","''queue_root'*")
$	if queue_name.eqs."" then goto end_queue
$!
$!--------------------------------------------------------------------
$! Get the entry number of next job
$!
$next_job:
$	current_job = f$getqui("DISPLAY_JOB","ENTRY_NUMBER",,"ALL_JOBS")
$	if current_job.eq."" then goto next_queue
$!
$!--------------------------------------------------------------------
$! Check that the entry is an ANALYST
$!
$	current_user = f$getqui("DISPLAY_JOB","USERNAME",,"ALL_JOBS,FREEZE_CONTEXT")
$	if current_user.eqs."" then goto next_queue
$	if f$locate(username,current_user).eq.f$length(current_user) then -
			goto next_job
$!
$!--------------------------------------------------------------------
$! Say which job is being done
$!
$	ws "Halting ''current_user' with job number ''current_job'"
$!
$!--------------------------------------------------------------------
$! Stop the job
$!
$	delete/entry='current_job'
$!
$	goto next_job
$!
$!--------------------------------------------------------------------
$! All queues searched
$!
$ end_queue:
$!
$!--------------------------------------------------------------------
$! Initialise current terminal number
$!
$ start_analysts:
$	if .not.want_start then exit
$!
$	num_sess = first_sess
$!
$!--------------------------------------------------------------------
$! Tell the user which one is being started
$!
$	ws " "
$	ws " "
$!
$ start_slave:
$	ws "Starting ANALYST''num_sess'"
$!
$!--------------------------------------------------------------------
$! Now set up the analyst io terminal and job name
$!
$	io = terminal + f$string(num_sess)
$	job =  username + f$string(num_sess)
$	user = username + f$string(num_sess)
$!
$!--------------------------------------------------------------------
$! Submit the session file
$!
$	submit	/noprint/nolog/nokeep/noidentify/restart -
		/username = 'user' -
		/name ='job' -
		/param=(s, 'queue', 'io') -
		/queue='queue' lsl$fln_login:fln_control
$!
$!--------------------------------------------------------------------
$! Increment current session and loop if needed
$!
$next_sess:
$	num_sess = num_sess + 1
$	if num_sess.le.last_sess then goto start_slave
$!
$!--------------------------------------------------------------------
$! Exit from command procedure
$!
$	set noverify
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
