$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-10-11 11:46:34.000000000 +0100
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
$	ver_status=f$verify(0)
$!
$! package "FLOWLINE" acceptance test command procedure.
$!
$! Author 					MWSR	28-May-1988
$! Based on DTMCREATE acceptance procedure by   TJH
$! Rehashed to use SITE_ROOT directories	JMC	19-Mar-1991
$! Use new FLOWLINEINI, p1=root for database	CCB	10-Oct-1991
$!
$! Set things up
$!
$	set noon
$	ws="write sys$output"
$	esc[0,7]=27
$	bel[0,7]=7
$	ff[0,15]=%x0c			! form feed
$	clear_screen:= write sys$output FF,FF
$	b_on = esc+"[0m"+esc+"[1m" 	! bold on
$	b_of = esc+"[0m"		! bold off
$ 	bell =bel+bel			! ding ding
$	top  ="#3"			! big letters (top)
$	bot  ="#4"			! big letters (bottom)
$ 	i_on = ""			! inverse video on
$	vt100_ok=1			! assume VT100
$!
$! If we have a non VT100 terminal then switch off bolding etc...
$!
$	if f$getdvi("TT:","TT_ANSICRT") then goto lets_go
$	b_on = ""	 	! bold on
$	b_of = ""		! bold off
$ 	bell = ""		! no ding ding
$ 	i_on = ""		! inverse video on
$	top  =""		! no big letters (top)
$	bot  =""		! no big letters (bottom)
$	vt100_ok=0		! not VT100
$	clear_screen:= write sys$output " "
$!
$!***************************************************************************
$!
$lets_go:
$!
$ ws "''b_on'"
$ ws "============================================================"
$ ws "============    Laser-Scan Laboratories Ltd.    ============"
$ ws "============         LAMPS package FLOWLINE     ============"
$ ws "============  Acceptance test command procedure ============"
$ ws "============================================================"
$	date_time=f$time()
$ ws "============  Starting ''date_time'  ============"
$ ws "============================================================"
$ ws " "
$ ws "''b_of'"
$ ws " "
$	gosub go_on
$ clear_screen
$!
$!***************************************************************************
$!
$! Defining the package symbols and setting up logical names.
$!
$	ws " "
$	ws "''b_on'"
$	ws "FLOWLINE package acceptance tests"
$	ws "''b_of'"
$	ws " "
$	ws "... Creating acceptance directories on LSL$SITE_ROOT:"
$	ws "... please ignore any warning messages"
$	create/dir/log lsl$site_root:[flowline.accept]
$	create/dir/log lsl$site_root:[flowline.accept.database]
$	create/dir/log lsl$site_root:[flowline.accept.log]
$	create/dir/log lsl$site_root:[flowline.accept.login]
$	create/dir/log lsl$site_root:[flowline.accept.jacket]
$	create/dir/log lsl$site_root:[flowline.accept.job]
$	create/dir/log lsl$site_root:[flowline.accept.project]
$	create/dir/log lsl$site_root:[flowline.accept.site]
$	create/dir/log lsl$site_root:[flowline.accept.work]
$	ws " "
$	ws "... Initialising the package and checking environment"
$	set noon
$	@lsl$com:flowlineini public accept accept
$!
$! Copy database to acceptance test directory on lsl$site_root.
$! Make sure no flowline databases are already there. If there are then
$! delete them.
$! If a root has not been given for the database, then use public
$	if p1.eqs."" then p1="public"
$
$	ws "... Copying the acceptance test database to LSL$SITE_ROOT:[FLOWLINE.ACCEPT.DATABASE]"
$	if f$search("lsl$site_root:[flowline.accept.database]flowline.rdb") .nes. ""
$	then
$		delete/noconfirm lsl$site_root:[flowline.accept.database]flowline.rdb;*
$	endif
$	copy lsl$'p1'_root:[flowline.accept]flowline.rdb -
	     lsl$site_root:[flowline.accept.database]flowline.rdb
$!
$	if f$search("lsl$site_root:[flowline.accept.database]flowline.snp") .nes. ""
$	then
$		delete/noconfirm lsl$site_root:[flowline.accept.database]flowline.snp;*
$	endif
$	copy lsl$'p1'_root:[flowline.accept]flowline.snp -
	     lsl$site_root:[flowline.accept.database]flowline.snp
$!
$	DBASE="LSL$FLN_DATABASE:FLOWLINE.RDB"
$       ACCEPT_FLN = "LSL$COM:ACCEPT_FLOWLINE.COM"
$       PROCESS_1  = "LSL$COM:PROCESS_1.COM"
$       PROCESS_2  = "LSL$COM:PROCESS_2.COM"
$       PROCESS_3  = "LSL$COM:PROCESS_3.COM"
$       PROCESS_4  = "LSL$COM:PROCESS_4.COM"
$!
$!
$!============================================================================
$! Check the flowline database exists
$!
$	if f$search(dbase) .nes. "" then goto in_db_ok
$	ws " ''bell'"
$	ws "Flowline database could not be found, tests abandoned."
$	ws "Input file was ''dbase'"
$	ws " "
$	goto tidy_exit
$!
$ in_db_ok:
$! Check that flowline command file is there
$	if f$search(accept_fln) .nes. "" then goto in_fln_ok
$	ws " ''bell'"
$	ws "Flowline command file could not be found, tests abandoned."
$	ws "Input file was ''accept_fln'"
$	ws " "
$	goto tidy_exit
$!
$ in_fln_ok:
$! check all PROCESS command files are there
$	if f$search(PROCESS_1) .nes. "" then goto el_1_ok
$	ws " ''bell'"
$	ws "PROCESS file could not be found, tests abandoned."
$	ws "Input file was ''PROCESS_1'"
$	ws " "
$	goto tidy_exit
$!
$ el_1_ok:

$	if f$search(PROCESS_2) .nes. "" then goto el_2_ok
$	ws " ''bell'"
$	ws "PROCESS file could not be found, tests abandoned."
$	ws "Input file was ''PROCESS_2'"
$	ws " "
$	goto tidy_exit
$!
$ el_2_ok:
$	if f$search(PROCESS_3) .nes. "" then goto el_3_ok
$	ws " ''bell'"
$	ws "PROCESS file could not be found, tests abandoned."
$	ws "Input file was ''PROCESS_3'"
$	ws " "
$	goto tidy_exit
$!
$ el_3_ok:
$	if f$search(PROCESS_4) .nes. "" then goto el_4_ok
$	ws " ''bell'"
$	ws "PROCESS file could not be found, tests abandoned."
$	ws "Input file was ''PROCESS_4'"
$	ws " "
$	goto tidy_exit
$!
$ el_4_ok:
$!
$! Work out the workstation name
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
$	term = f$getsyi("NODENAME") + "$" + term
$!
$	assign 'term' lsl$fln_workstation
$!
$!
$! now authorise this user on this workstation to use the database
$	ws "... Authorising the user on the system."
$	work = f$trnlnm("lsl$fln_workstation")
$	oper = f$getjpi("","USERNAME")
$!
$! write rdo file for authorisation
$	open/write cmdfil sys$scratch:accept_authorise.com
$		wc:="write cmdfil"
$	        wc "$ set message /nofacility/noid/noseverity/notext"
$     		wc "$ MCR RDO"
$       	wc "data file lsl$fln_database:flowline"
$		wc "start_transaction read_write"
$       	wc "store o in operator using"
$      		wc  "  o.operator_id  = ""''oper'""
$       	wc "end_store"
$      		wc " store w in workstation using" 
$       	wc " w.workstation_id  =  ""''work'""
$       	wc "end_store"
$       	wc "commit"
$       	wc " exit"
$	        wc "$ set message /facility/id/severity/text"
$		wc "$ exit"
$	close cmdfil
$	ON ERROR THEN CONTUNUE
$	@sys$scratch:accept_authorise.com;
$	delete/noconfirm sys$scratch:accept_authorise.com;*
$	SET NOON	
$	set noverify
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Execute lampscontrol
$!
$ LC:
$	define/user/nolog sys$input sys$command
$ 	SET VERIFY
$	LAMPSCONTROL 	/COMMAND_FILE = LSL$FLN_JACKET:JACKET.COM/NOLOGOFF
$!
$!
$! Clear the screen
$!
$	 set noverify
$	 clear_screen
$!
$! Now execute the returned command procedure
$!
$	@LSL$FLN_JACKET:JACKET
$	set noverify
$!
$! If user has selected 'Exit from LAMPSCONTROL', then all done
$!
$	if FLN_JACKET_TYPE .eqs. "NULL" .or. -
	   FLN_JACKET_TYPE .eqs. "ERROR" then goto finished
$!
$! Now reset the action on errors, control y's etc
$!
$!	on control_y then continue
$!
$! Now loop for next operation with LAMPSCONTROL
$!
$   GOTO LC
$!
$! Check if user has really finished
$!
$ finished:
$	inq/nop resp "Is the acceptance test now complete? "
$	if .not. resp then goto LC
$	clear_screen
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ ws "''b_on'"
$ ws "============================================================"
$ ws "============    Laser-Scan Laboratories Ltd.    ============"
$ ws "============        LAMPS package  FLOWLINE     ============"
$ ws "============  Acceptance test command procedure ============"
$ ws "============================================================"
$ date_time=f$time()
$ ws "============  Completed ''date_time' ============"
$ ws "============================================================"
$ ws " "
$ ws "''b_of'"
$ ws " "
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	set noon
$	set noverify
$	ws "... Tidying up, please ignore any warning messages"
$!
$! delete the temporary acceptance test database on lsl$site_root
$!
$ if f$search("lsl$site_root:[flowline.accept.database]flowline.rdb") .nes. ""
$ then
$	delete/noconf lsl$site_root:[flowline.accept.database]flowline.rdb;*
$ endif
$!
$ if f$search("lsl$site_root:[flowline.accept.database]flowline.snp") .nes. ""
$ then
$	delete/noconf lsl$site_root:[flowline.accept.database]flowline.snp;*
$ endif
$	delete/noconfirm lsl$fln_jacket:jacket.com;*
$	delete/noconfirm lsl$fln_log:fln.log;*
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$tidy_exit:
$	set control=y
$	if ver_status then set verify
$	exit
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!	SUBROUTINES
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Subroutine chk_status
$!
$ chk_status:
$	ws " "
$	ws "Return $STATUS was ''f$message(dcl_status)'"
$	return
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Subroutine go_on
$!
$ go_on:
$ 	ws " "
$	inquire/nopunc continue - 
	"Press ''b_on'<RETURN> ''b_of'to continue "
$ 	ws " "
$	return
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
