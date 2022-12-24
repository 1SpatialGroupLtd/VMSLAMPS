$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-01-29 16:33:26.000000000 +0000
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
$ if f$mode().eqs."BATCH" then set noverify
$!
$! FLN_CONTROL.COM
$!
$! Copyright Laser-Scan Laboratories Ltd, Cambridge, England
$! Author: J.M. Billing			25 April 1988
$!
$! Many changes since, version by 	CC Brunt 10 October 1991
$! Don't use SET MESSAGE (as slow)	JMC/PGH	 29-Jan-1993
$!
$!
$! Parameters:
$!	1 Mode
$!	2 LSL$FLN_WORKSTATION
$!	3 SYS$COMMAND, TT, SYS$OUTPUT
$!	4 Wait time (integer minutes) for WAIT command procedure
$!	5 Batch queue name for resubmission instead of iteration
$!	6 Optional qualifiers (e.g. /log) for SUBMIT
$!
$! Flowline control command procedure, exact action is determined
$! by parameter 1:
$!
$!	CONTROL		Performs top level control operations
$!	MANAGE		Performs manage operations
$!	REPORT		Performs report operations
$!	OPERATE		Performs ordinary operator request
$!	BATCH		Performs batch auto request
$!	SLAVE		Performs interaction at slave terminal
$!			when current process is actually running
$!			in batch or detached.
$!
$! This command procedure determines which LAMPSCONTROL qualifiers to
$! use on the basis of the parameter.
$!
$! Then it calls LAMPSCONTROL with the qualifiers to perform the 
$! required operation
$!
$! When LAMPSCONTROL terminates, the command procedure executes the 
$! jacket command procedure file constructed by LAMPSCONTROL.
$!
$! This procedure will check that it is operating interactively and
$! may modify its operation if it is not
$!
$! It will also determine the user/operator name and the workstation id
$! and will name its process accordingly.
$!
$! The jacket command procedure file spec and the log file spec
$! which are specified in the LAMPSCONTROL command line are based
$! on the process name
$!
$! Thus, by ensuring that the workstation id is related to the
$! cluster node as well as the workstation type, the file specs
$! will be unique on the cluster
$!
$!
$!
$!--------------------------------------------------------------------
$! If third parameter was specified, then use it to assign to
$! default terminal output logical name
$!
$	if (p3 .nes. "") then ass 'p3' sys$output
$!
$!--------------------------------------------------------------------
$! Set up write to sys$output symbol
$!
$	ws := write sys$output
$!
$!--------------------------------------------------------------------
$! Check if interactive
$!
$	FLN_INT == "T"
$	if (f$mode() .nes. "INTERACTIVE") then FLN_INT == ""
$!
$!--------------------------------------------------------------------
$! Clear the screen
$! Subroutine to clear screen does nothing if FLN_INT is not true
$!
$	call clear_screen
$!
$!--------------------------------------------------------------------
$! Brief title to stop the users getting impatient
$!
$	ws "Flowline control starting ..."
$!
$!--------------------------------------------------------------------
$! Work out the workstation and assign it to LSL$FLN_WORKSTATION
$! For most modes this is <node>$<window/terminal type>XXX
$! If p2 is defined, this is used
$!
$	if (p2 .nes. "") then p2 = f$edit(p2, "UPCASE")
$	if (p2 .nes. "") then ass 'p2' lsl$fln_workstation
$!
$! If workstation already defined, use that
$!
$	if (f$trnlnm("lsl$fln_workstation") .nes. "") then -
				goto do_set_input
$!
$! Otherwise, work out the workstation name
$!
$	term = "BATCH"
$	if f$mode().eqs."INTERACTIVE" then term=f$logical("sys$command")
$	if f$locate("WT",term) .ne. f$length(term) then term = "WTXXX"
$	if f$locate("LT",term) .ne. f$length(term) then term = "LTXXX"
$	if f$locate("RT",term) .ne. f$length(term) then term = "RTXXX"
$	if ((term.nes."BATCH").and. -
	    (term.nes."WTXXX").and. -
	    (term.nes."LTXXX").and. -
	    (term.nes."RTXXX")) then term = "__ODD"
$!
$! the following line is used to group nodes for authorisation purposes
$! eg EDITA, EDITB, etc all classed as EDIT
$	term = f$extract(0,4,f$getsyi("SCSNODE")) + "$" + term
$! if you want all nodes treated separately, then use the next line instead
$!!!!!	term = f$edit(f$getsyi("SCSNODE"),"TRIM") + "$" + term
$!
$	assign 'term' lsl$fln_workstation
$!
$!--------------------------------------------------------------------
$! If third parameter was specified, then use it to assign to
$! default terminal interactive input logical name
$!
$ do_set_input:
$!
$	if (p3 .nes. "") then ass 'p3' sys$command
$	if (p3 .nes. "") then -
		open/read/error=do_determine_mode -
		sys$command sys$command
$!
$!--------------------------------------------------------------------
$! Determine the mode of operation
$!
$! Test for null
$!
$ do_determine_mode:
$!
$	if (p1 .eqs. "") .and. (FLN_INT) then -
			inq/nop p1 "Mode (C/M/R/O/A/B) ? "
$!
$! Default is OPERATE if interactive, BATCH if not
$!
$	if p1 .eqs. "" then p1 = "OPERATE"
$!
$! Make parameter upper case
$!
$	p1 = f$edit(p1, "UPCASE")
$!
$! Test for operator
$!
$ try_operate:
$	if f$extract(0,1,p1) .nes. "O" then goto try_slave
$	FLN_MODE == "OPERATE"
$	if .not. FLN_INT then FLN_MODE == "BATCH"
$	goto do_title
$!
$! Test for slave terminal option
$!
$ try_slave:
$	if f$extract(0,1,p1) .nes. "S" then goto try_control
$	FLN_MODE == "SLAVE"
$	FLN_INT == "t"
$	goto do_title
$!
$! Test for control option
$!
$ try_control:
$	if f$extract(0,1,p1) .nes. "C" then goto try_manage
$	FLN_MODE == "CONTROL"
$	if .not. FLN_INT then FLN_MODE == "BATCH"
$	goto do_title
$!
$! Test for manage option
$!
$ try_manage:
$	if f$extract(0,1,p1) .nes. "M" then goto try_report
$	FLN_MODE == "MANAGE"
$	if .not. FLN_INT then FLN_MODE == "BATCH"
$	goto do_title
$!
$! Test for report option
$!
$ try_report:
$	if f$extract(0,1,p1) .nes. "R" then goto try_batch
$	FLN_MODE == "REPORT"
$	if .not. FLN_INT then FLN_MODE == "BATCH"
$	goto do_title
$!
$! Test for batch option
$!
$ try_batch:
$	if f$extract(0,1,p1) .nes. "B" then goto try_default_mode
$	FLN_INT == ""
$	FLN_MODE == "BATCH"
$	goto do_title
$!
$! Default mode of operation
$!
$ try_default_mode:
$	p1 = "OPERATE"
$	goto try_operate
$!
$!--------------------------------------------------------------------
$! Clear the screen
$! Subroutine to clear screen does nothing if FLN_INT is not true
$!
$ do_title:
$	call clear_screen
$!
$!--------------------------------------------------------------------
$! Indicate that system has started
$!
$	ws " "
$	ws " "
$	ws "Flowline control system initiated"
$	ws " "
$!
$!--------------------------------------------------------------------
$! Determine the qualifiers to use
$!
$! Test if interactive, and set /[NO]MENU accordingly
$!
$	lsc_menuopt = "/nomenu"
$	if FLN_INT then lsc_menuopt = "/menu"
$!
$! Determine the remaining command qualifiers on basis of operation mode
$!
$	if FLN_MODE .eqs. "OPERATE" then lsc_opt = "/request"
$	if FLN_MODE .eqs. "MANAGE"  then lsc_opt = "/manage"
$	if FLN_MODE .eqs. "REPORT"  then lsc_opt = "/report"
$	if FLN_MODE .eqs. "CONTROL" then lsc_opt = "/nologoff"
$	if FLN_MODE .eqs. "BATCH"   then lsc_opt = "/request"
$	if FLN_MODE .eqs. "SLAVE"   then lsc_opt = "/request"
$!
$! Arrange that certain users will not be logged off
$! If doing this, then change the "/nologoff" above to a null string
$!
$!!!	name = f$getjpi("","USERNAME")
$!!!	if name.eqs."SYSTEM" then lsc_opt = lsc_opt+"/nologoff"
$!
$!--------------------------------------------------------------------
$! Determine if workstation logical name is defined, and give
$! it a default if it is not
$!
$	if f$trnlnm("LSL$FLN_WORKSTATION") .eqs. "" then -
		ass Unknown lsl$fln_workstation
$!
$! Determine workstation id symbol
$!
$	FLN_WORKSTATION == f$trnlnm("LSL$FLN_WORKSTATION")
$!
$!--------------------------------------------------------------------
$! Determine user name
$!
$	FLN_OPERATOR == f$getjpi("","USERNAME")
$!
$!--------------------------------------------------------------------
$! Determine unique process name from operator and a serial number
$!
$! Set up an initial process number
$!
$	FLN_PROCESS_NUMBER == 0
$!
$! Now set up the process name (username + process number)
$! Will be '<username><user session instance number>'
$!
$ name_clash:
$	on error then goto name_clash
$!
$	FLN_PROCESS_NUMBER == FLN_PROCESS_NUMBER + 1
$	FLN_PROCESS == -
	   f$element(0," ",FLN_OPERATOR) + f$string(FLN_PROCESS_NUMBER)
$!
$! Now attempt to set process name, turning off messages beforehand,
$!
$	define/user sys$error nl:
$	set process/name = 'FLN_PROCESS'
$!
$!--------------------------------------------------------------------
$! Now have process name, so can get on with rest of initialisation
$!
$! Set up the action on errors, control_y etc
$!
$	on warning then continue
$!	set nocontrol_y
$!	on control_y then continue
$!
$!--------------------------------------------------------------------
$! Give details of what is happening
$!
$	ws "      Operator    " + FLN_OPERATOR
$	ws "      Workstation " + FLN_WORKSTATION
$	ws "      Process     " + FLN_PROCESS
$	ws "      Mode        " + FLN_MODE
$	ws " "
$!
$	if FLN_INT then ws "Interactive system set up commencing"
$	if .not.FLN_INT then ws "Non-interactive system set up commencing"
$!
$	ws " "
$	ws " "
$!
$!--------------------------------------------------------------------
$! Set up jacket command procedure and log file specs using 
$! process name and workstation id, so that files are unique 
$! clusterwide.
$!
$! Will be 'LSL$FLN_JACKET:<process-name>_<workstation>_JACKET.COM'
$! and     'LSL$FLN_LOG:<process-name>_<workstation>_LOG.LOG'
$!
$	FLN_JACKET_COMPROC == -
	   "LSL$FLN_JACKET:" + -
	   f$getjpi("","PRCNAM") + "_" + -
	   FLN_WORKSTATION + -
	   "_JACKET.COM"
$
$	FLN_LAMPSCONTROL_LOG_FILE == -
	   "LSL$FLN_LOG:" + -
	   f$getjpi("","PRCNAM") + "_" + -
	   FLN_WORKSTATION + -
	   "_LOG.LOG"
$!
$!--------------------------------------------------------------------
$! Symbol initialisation (only needed if FLOWLINEINI is done system
$! wide, so it cannot initialise symbols)
$!
$!!!	LAMPSCONTROL :== $LSL$EXE:LAMPSCONTROL
$!
$!--------------------------------------------------------------------
$! Set up the wait time required before looking for another task
$! if none found by LAMPSCONTROL in automatic task selection.
$! Determined by parameter 4 (symbol p4).
$! Will default to 1 minute if not specified by p4.
$! Delta-time format with no days figure 'hh:mm:ss.cc'
$!
$	if (p4 .eqs. "") then p4 = "1"
$	FLN_WAIT_TIME :== 00:0'f$integer(p4)':00.00
$!
$!--------------------------------------------------------------------
$! Logical names
$!
$!
$!--------------------------------------------------------------------
$! If in slave terminal mode, tell the user to press return to restart
$! to prevent having lots of idle sessions in LAMPSCONTROL
$	if FLN_MODE .eqs. "SLAVE" then goto SLAVE_INIT
$!
$!--------------------------------------------------------------------
$! Now do the main part with LAMPSCONTROL
$!
$!
$! Set up the error handler for the LAMPSCONTROL section
$!
$ flowline:
$!	set nocontrol_y
$!	on control_y then continue
$	on warning then continue
$	on error then goto control_error
$!
$! Setting terminal to no type ahead to avoid
$! someone accidentally going through lots of menus
$!
$!	set terminal/notype_ahead
$!	if FLN_MODE .eqs. "OPERATE" then set terminal/noecho
$!	if FLN_MODE .eqs. "SLAVE" then set terminal/noecho
$!
$! Set input for lampscontrol to terminal if interactive or slave
$!
$	if FLN_INT then define/user sys$input sys$command
$!
$! Execute Lampscontrol
$!
$	LAMPSCONTROL -
			'lsc_menuopt' -
			'lsc_opt' -
			/COMMAND_FILE = 'FLN_JACKET_COMPROC' -
			/LOG = 'FLN_LAMPSCONTROL_LOG_FILE' -
			/WAIT_TIME = 'FLN_WAIT_TIME'
$!
$! Restore type ahead + echo
$!
$!	set terminal/type_ahead
$!	if FLN_MODE .eqs. "OPERATE" then set terminal/echo
$!	if FLN_MODE .eqs. "SLAVE" then set terminal/echo
$!
$! Clear the screen
$!
$	call clear_screen
$!
$!
$	@'FLN_JACKET_COMPROC'
$!
$!
$! Now reset the action on errors, control y's etc
$!
$!	set nocontrol_y
$!	on control_y then continue
$	on warning then continue
$	on error then goto control_error
$!
$! Now loop for next operation with LAMPSCONTROL
$!
$ repeat_flowline:
$!
$! If have just had a null command procedure in control mode,
$! then exit (this null procedure is written instead of a logoff 
$! command procedure, because /NOLOGOFF is specified in the command
$! line)
$!
$	if (FLN_MODE .eqs. "CONTROL") .and. -
	   (FLN_JACKET_TYPE .eqs. "NULL") then exit
$!
$! If not in batch mode, then always loop
$!
$	if FLN_MODE .nes. "BATCH" then goto flowline
$!
$! If in batch mode, then if a queue parameter was specified,
$! should re-submit this command file to it,
$!
$	if p5 .eqs. "" then goto flowline
$!
$	subopt = p6
$	p1 = """" + p1 + """"
$	p2 = """" + p2 + """"
$	p3 = """" + p3 + """"
$	p4 = """" + p4 + """"
$	p5 = """" + p5 + """"
$	p6 = """" + p6 + """"
$	ws p1,", ",p2,", ",p3,", ",p4,", ",p5,", ",p6
$	comfil = f$environment("PROCEDURE")
$	comfil = f$extract(0,f$locate(";",comfil),comfil)
$!
$	on error then exit
$	submit/noprint/restart -
	        'subopt' -
		/param=('p1','p2','p3','p4','p5','p6') -
		/queue='p5' -
		'comfil'
$	exit
$!
$!--------------------------------------------------------------------
$! Error handler for control section
$!
$ control_error:
$!
$! Restore type ahead + echo
$!
$!	set terminal/type_ahead
$!	if FLN_MODE .eqs. "OPERATE" then set terminal/noecho
$!	if FLN_MODE .eqs. "SLAVE" then set terminal/echo
$!
$! Clear screen
$!
$	call clear_screen
$!
$	ws "Flowline Control Error Procedure"
$	ws " "
$	ws " "
$	ws "There a problem in the flowline control system"
$	ws "Please consult a manager"
$	ws " "
$!
$! If in slave terminal mode, tell the user to press return to restart
$! Also come here if slave on initial entry, to prevent having lots of
$! sessions sitting in LAMPSCONTROL
$!
$ slave_init:
$	log_out = ""
$!
$	if FLN_MODE.eqs."SLAVE" then -
		read/error=no_error -
		/prompt="Press RETURN to restart system " -
		sys$command cr
$!
$	IF FLN_MODE.eqs."SLAVE" then goto no_error
$!
$! If in normal interactive mode ask if user wants to log off
$!
$	if FLN_INT then read/error=no_error -
		/prompt="Do you wish to logoff (Y/N) " -
		sys$command log_out
$!
$ no_error:
$!
$	if .not. log_out then goto flowline
$!
$! Otherwise log off
$!
$	if p3 .nes. "" then close/nolog/error=do_logoff sys$command
$!
$ do_logoff:
$	LOGOFF
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
$	if FLN_INT then write sys$output "[2J[1;1H"
$!
$	ENDSUBROUTINE
$!
