$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-03-12 17:45:28.000000000 +0000
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
$ V := 'F$VERIFY( F$LOGI("DEBUG$COM") + F$LOGI("DEBUG$TELL") )
$ TELL_TYPE = "VMS"	!we are VMS
$ TELL_VERSION = 9	!use negative for debugging new version
$ !
$ !=========================================================================
$ !
$ ! Execute DCL command(s) in a remote network job - originally Tim Halvorsen
$ !
$ !	TELL :== @TELL  or, on V4: TELL :== @[wherever]TELL
$ !
$ !	P1 = Node name
$ !	P2-8 = (OPTIONAL) A DCL command to be executed
$ !	[ If you don't supply DCL command, you are prompted for commands.
$ !	  In this mode, you can type tilde (~) to enter local commands for
$ !	  your system without breaking the remote connection.  After typing
$ !	  ~ type ? for help on extra options (Sending text files and logging) ]
$ !
$ ! SCCSID = "@(#)TELL.COM	4.1	DECnet	10/12/88"
$ !
$ ! Modifications
$ !  DEC  8/15/84  Assign SYS$ERROR so we see error messages
$ !	   v 2	   and test for versions (auto update)
$ !		   Add local commands (with tilde ~) including:
$ !			? (help) and
$ !			@textfile, |logfile, local commands
$ !		   (still needs to be able to run interactive programs)
$ !
$ !  DEC  8/27/84  Recover & run if remote tell is old version, 
$ !	   v 3	   and update copy fails
$ !
$ !  DEC  9/6/84   COPY with protection W:RE.
$ !	   V 4	   Turn verify off on remote node.
$ !		   Leave a trail of nodes tell was copied from.
$ !		   Send file TELL$INIT: to remote, if it exists.
$ !		   As an example, TELL$INIT could point to a file containing:
$ !			write sys$output "Remote VMS ",f$getsyi("version")
$ !			dir :== dir/size/date/prot
$ !		   This would tell you the remote VMS version, and redefine 
$ !		   the DIR command to show more information
$ !	NOTE: write sys$output only works on V4 systems.  So, for a TELL$INIT 
$ !	command that works when you talk to V3.x or V4 systems, use:
$ !		write tell_link "Remote VMS ","''f$getsyi(""version"")'"
$ !
$ !  DEC  9/11/84  Fix LOG_FILE_NAME.DAT bug (wrong file name created)
$ !	   V 5	   Fix assign/user sys$input of local commands
$ !
$ !  DEC  9/13/84  Let ~local_cmd execute, but not prompt for more commands
$ !        V 6
$ !
$ !  RSD  10/9/84  Fix interactive command section
$ !	   V 7
$ !
$ !  JAS  5/13/85  Support different system types
$ !
$ !  WJJ  1-Nov-1990	Create LSLTELL
$ !  WJJ  1-Nov-1990	Stop attempted cross-loading of LSLTELL
$ !  WJJ  1-Nov-1990	Execute LSSITEINI in server code
$ !  WJJ 12-Mar-1991	Assume that we are not a server if have parameters
$ !
$ !=========================================================================
$!
$! Some initial stuff
$!
$ v2 = v
$ tell_file := tell.com
$ no_log_sw = ""
$ if f$extract(0,2,f$getsyi("version")) .eqs. "V3" then goto skip_v4_features
$	tell_file = f$environment("procedure")  !VMS V4 feature
$	no_log_sw = "/nolog"			!VMS V4 feature
$!
$skip_v4_features:
$!
$ tell_file_name = f$parse(tell_file,,,"NAME")
$!
$! Network server or Local?
$!
$	if p1.nes."" then goto local
$	if f$mode() .eqs. "NETWORK" then goto network
$!
$!==================================================
$!
$!	Local subroutines
$!
$!==================================================
$!
$local:	if p1 .eqs. "" then read/prompt="Node: " sys$command p1
$	nodespec = p1 - "::"
$	nodename = f$extract(0,f$locate("""",nodespec),nodespec)
$ !	if nodename .eqs. nodespec then nodespec = nodespec + """""" !no proxies
$	local_at = "F"
$	log_file = "F"
$	log_file_name = ""
$	remote_tell_exists = "F"
$	remote_tell_type = "?"
$	temp_zzz = "F"
$	tell_where := sys$login:telltemp.zzz;0
$	tell_init = "F"
$	new_remote = "F"
$	local = " "
$	tell_file = f$logi("TELL$INIT")
$	if tell_file.nes."" then local = " " + f$sea(tell_file)
$	if local .nes. " " then tell_init = "T"
$	on warning then continue
$	on error then goto exit2
$	on control_y then goto exit2
$	close/err=10$	tell_server
$10$:
$	open/read/write tell_server 'nodespec'::"TASK=''TELL_file_name'"/error=open_failure
$	remote_tell_exists = "T"
$	on error then goto exit
$	on control_y then goto exit
$	on warning then goto exit
$sync_start:
$	read tell_server record
$	if f$locate("REMOTE SYSTEM TYPE:",record) .lt. f$len(record) then goto save_server_type
$	if f$locate("REMOTE TELL VERSION:",record) .lt. f$len(record) then goto check_server_ver
$	if record .eqs. "ABOUT_TO_ISSUE_READ" then goto new_remote_server
$	goto sync_start
$
$flush_output:
$	read tell_server record
$	if record .eqs. "ABOUT_TO_ISSUE_READ" then goto send_command
$	if log_file then write to_log record
$!f$extract(0,255,record), f$extract(255,255,record)
$	write sys$output record
$!f$extract(0,255,record), f$extract(255,255,record)
$	goto flush_output
$
$send_command:
$	if p2 .nes. "" then goto single_command
$	if tell_init then goto local_at_file
$	if local_at then       read/error=no_at_file/end=done_at_file tmp_at record
$	if .not. local_at then read sys$command record /promt="''nodename' > " /end=exit
$	test_record	:= 'record
$	if test_record .eqs. "EXIT" then goto exit
$	if f$len(test_record) .gt. 0 .and. -
		f$locate("~", test_record) .eq. 0 then goto local_command_start
$	if log_file then write to_log "$ ",record
$	write tell_server record
$	goto flush_output
$
$local_command_start:
$	if f$len( record ) .le. 1 then goto local_command
$		local = f$extract( 1,999,record )  !typed ahead command
$		multi_local = "F"
$		goto local_1
$local_command:
$	local = ""
$	local_nodename = F$LOGICAL("SYS$NODE") - "_" - "::"
$	read sys$command local /prompt="~''local_nodename' > " /end=local_1
$	multi_local = "T"
$local_1:
$	if f$len( local ) .eq. 0 then write sys$output "[A[K[A"
$	if f$len( local ) .eq. 0 then goto send_command
$	if f$locate("?", local) .eq. 0 then goto local_help
$	if f$locate("@", local) .eq. 0 then goto local_at_file
$	if f$locate("|", local) .eq. 0 then goto record_file
$	assign/user'no_log_sw' 'f$logi("sys$command") sys$input
$	set noon
$	V2 = F$VERIFY( V2 )	!restore verify to what user wants
$ 'local'
$	V2 := 'F$VERIFY( 0 )	!turn verify off for this com file
$	set on
$	if multi_local then goto local_command
$	goto send_command	!it's just one command
$
$local_at_file:
$	open/read/error=no_at_file tmp_at 'f$extract(1,999, local) 
$	local_at = "T"
$	tell_init = "F"
$	goto send_command
$
$done_at_file:
$	local_at = "F"
$	close tmp_at
$	goto send_command
$no_at_file:
$	write sys$output "Can't read file: ''local'"
$	local_at = "F"
$	tell_init = "F"
$	goto send_command
$
$record_file:
$	if local .eqs. "|" then goto done_log_file
$	if log_file then close to_log  !make sure it's closed first
$	log_file_name = f$extract(1,999, local) 
$	open/write/error=no_log_file to_log 'log_file_name
$	log_file = "T"
$	goto send_command
$
$done_log_file:
$	if log_file then close to_log  !only if it's already open
$	log_file = "F"
$	log_file_name = ""
$	goto send_command
$no_log_file:
$	write sys$output "Can't write file: ''local'"
$	log_file = "F"
$	log_file_name = ""
$	goto send_command
$
$local_help:
$	WRITE SYS$OUTPUT ""
$	WRITE SYS$OUTPUT "      Connected to ''nodename', system = ''remote_tell_type', version = ''remote_tell_version'"
$	WRITE SYS$OUTPUT ""
$	WRITE SYS$OUTPUT "      @FILE  sends text file to the remote system
$	WRITE SYS$OUTPUT "      |FILE  records screen output to file
$	WRITE SYS$OUTPUT "      |      turns recording off
$	WRITE SYS$OUTPUT "             anything else is executed locally
$	WRITE SYS$OUTPUT "             (to do @COMfile locally, type a space first)
$	WRITE SYS$OUTPUT "      ^Z     to exit
$	if .not. log_file then WRITE SYS$OUTPUT "      [no log file active]"
$	if log_file then WRITE SYS$OUTPUT "      [logging to file: ''log_file_name']"
$	goto local_command
$
$single_command:
$	command := "''p2' ''p3' ''p4' ''p5' ''p6' ''p7' ''p8'"
$	write tell_server command
$single_flush:
$	read tell_server record
$	if record .eqs. "ABOUT_TO_ISSUE_READ" then goto exit
$	write sys$output record
$	goto single_flush
$
$save_server_type:
$	remote_tell_type = f$extract(20,99,record)
$	goto sync_start
$
$check_server_ver:
$	remote_tell_version = f$extract(21,99,record)
$	if remote_tell_type .eqs. "?" then goto skip_type_check
$	if remote_tell_type .nes. tell_type then goto flush_output
$skip_type_check:
$	if remote_tell_version .eq. tell_version then goto flush_output
$	if remote_tell_version .gt. tell_version then goto need_new_tell
$new_remote_server:
$!!!	close tell_server  !need a new version remotely
$!!!	wait 0:0:1	! Wait for remote FAL process to get ready
$	write sys$output "Remote TELL is old version: ''remote_tell_version'"
$	goto have_new_tell
$
$need_new_tell:
$	write sys$output "Remote TELL is newer version: ''remote_tell_version'"
$	goto flush_output
$
$open_failure:
$! don't do anything fancy now
$	write sys$output "Cannot access remote TELL"
$	goto exit2
$!
$have_new_tell:
$	inquire q "Want to copy this version of TELL.COM to target? "
$	if .not. q then goto flush_output	! try it
$	on warning then goto exit2
$	Write Sys$Output "Replicating TELL version ''Tell_version' to node ''nodename'"
$!
$!	Create tmp file to tell where we came from
$!
$ 	open/write where_is 'tell_where
$ 	temp_zzz = "T"
$ 	node_name = f$logi("sys$node")
$ 	if f$extra(0,1,node_name) .eqs. "_" then -
!		node_name = f$extra(1,999,node_name)
$ 	write where_is "$! Copied from ''node_name' on ''f$time()'"
$ 	close where_is
$ !
$	copy 'tell_file','tell_where' 'nodespec'::'tell_file_name'.COM;0 
$!/prot=w:RE	!highest version
$!
$	copy_stat = $status
$	delete 'tell_where'
$	temp_zzz = "F"
$!
$	if .not. copy_stat then goto Copy_fail_ok !copy failed, but old version is there
$	if remote_tell_exists then close tell_server !copy worked, close old version
$	wait 0:0:1	! Wait for remote FAL process to get ready
$	open/read/write tell_server 'nodespec'::"TASK=''TELL_file_name'"
$	new_remote = "T"
$	on error then goto exit
$	on control_y then goto exit
$	on warning then goto exit
$sync_start:
$	read tell_server record
$	if f$locate("REMOTE TELL VERSION:",record) .eq. f$len(record) then goto sync_start
$	on warning then goto exit
$	goto flush_output
$
$Copy_fail_ok:
$	Write Sys$Output "Can't update Remote TELL, continuing..."
$	on warning then goto exit
$	goto flush_output
$
$exit:
$	set noon
$!!!	write tell_server "LOGOUT/BRIEF"
$	if log_file then close to_log
$	if local_at then close tmp_at
$exit2:
$	if temp_zzz then close where_is/error=e1
$e1:
$	if temp_zzz then delete 'tell_where'
$	close/error=e2 tell_server
$e2:
$	V = F$VERIFY( V )
$	exit
$!
$!===================================================
$!
$!	Network server piece
$!
$!===================================================
$
$network:
$	open/read/write tell_link sys$net
$	set noon
$	tell_verify = 'f$verify(0)'
$	V2 = 0	!initially turns off verify for command echo
$! read site initialisation file
$	if f$search("sys$manager:lssiteini.com").nes."" then -
		@sys$manager:lssiteini
$!
$	define'no_log_sw' sys$error   tell_link:	!need to see errors
$	define'no_log_sw' sys$output  tell_link:
$	write tell_link "REMOTE SYSTEM TYPE: ''tell_type'"
$	write tell_link "REMOTE TELL VERSION: ''tell_version'"
$server_loop:
$	write tell_link "ABOUT_TO_ISSUE_READ"
$	read tell_link tell_string /end_of_file=server_exit /error=server_exit
$	V2 = F$VERIFY( V2 )	!restore verify to what user wants
$ 'tell_string'
$	V2 := 'F$VERIFY( 0 )	!turn verify off for this com file
$	goto server_loop
$server_exit:
$	if tell_verify then set verify
$	close tell_link
$	deassign sys$output
$!
$!=========================================================================
$!
$! Where did this copy of TELL come from?
$!
