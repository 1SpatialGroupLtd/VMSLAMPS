$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1999-08-23 14:02:40.000000000 +0100
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
$!
$! Command file to build the DTMCREATE package service routines
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!	Created						TJH 23-Nov-1987
$!
$	ver=f$verify(0)
$!
$	on error then goto dtmcreateex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$dtmcreate_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto dtmcreateex
$	define/group lsl$dtmcreate_building "in_progress"
$	open/write comfil dtmcreatebat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto dtmcreateex"
$	wc "$	if ""'","'f$logical(""lsl$dtmcreate_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$dtmcreate_building ""in_progress"""
$	wc "$	assign lsl$source_root:[dtmcreate.service.src] lsl$dtmcreatesys"
$	wc "$	sd:=$lsl$sys:sd"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$!
$! check for AXP version
$!
$	ARCH_NAME=F$GETSYI("ARCH_NAME")
$	IF ARCH_NAME.EQS."Alpha" 
$	THEN 
$	   TVS="_TV"
$	   AXPS="_AXP"
$	ELSE
$	   TVS=""
$	   AXPS=""
$	ENDIF
$	mldbg=""
$	fsw1=""
$	fswa=""
$	kpcom=""
$	dtmcreate_dbg=""
$	inquire/nop compm "Compile MACRO32 ? "
$	inquire/nop compf "Compile FORTRAN ? "
$	inquire/nop dtmcreate_dbg "With Debug ? "
$	if .not. dtmcreate_dbg then goto a04
$	   fsw1="/debug"
$	   mldbg="/debug"
$	   inquire/nop answer "Without optimisation ? "
$	   if answer then fsw1=fsw1 + "/noopt"
$	   inquire/nop answer "Check bounds and overflow ? "
$	   if answer then fsw1=fsw1 + "/check=(bounds,overflow)"
$	   inquire/nop answer "With listings ? "
$	   if answer then fsw1=fsw1 + "/list"
$	   inquire/nop answer "Keep FORtran sources with comments ? "
$	   if answer then kpcom="/co"
$ a04:
$	IF ARCH_NAME.EQS."Alpha" 
$	THEN 
$	   fswa=fswa + "/EXTEND/TIE/FLOAT=D"
$	ENDIF
$!
$	if .not. compf then goto a11
$!
$	   inq/nop everything "Compile all sources ? "
$	   if .not. everything then goto a05
$	alarms="t"
$	bitmatch="t"
$	conver="t"
$	cvtang="t"
$	dtmjpi="t"
$	endit="t"
$	examine_term="t"
$	getspec="t"
$	grafck="t"
$	hlp_erret="t"
$	io="t"
$	is_alpha_axp="t"
$	longin="t"
$	lookup="t"
$	pause_cmd="t"
$	percent="t"
$	rdran="t"
$	rdrang="t"
$	rdunf="t"
$	readll="t"
$	realin="t"
$	rednod="t"
$	reslog="t"
$	screen="t"
$	spawn_cmd="t"
$	start="t"
$	t4100="t"
$	txtout="t"
$	value="t"
$	vt100="t"
$	wait_cmd="t"
$	window_cmd="t"
$	wrtran="t"
$	wrtunf="t"
$!
$	   goto a11
$!
$ a05:	   
$	inquire/nopunct ALARMS "Compile ALARMS? "
$	inquire/nopunct BITMATCH "Compile BITMATCH? "
$	inquire/nopunct CONVER "Compile CONVER? "
$	inquire/nopunct CVTANG "Compile CVTANG? "
$	inquire/nopunct DTMJPI "Compile DTMJPI? "
$	inquire/nopunct ENDIT "Compile ENDIT? "
$	inquire/nopunct EXAMINE_TERM "Compile EXAMINE_TERM? "
$	inquire/nopunct GETSPEC "Compile GETSPEC? "
$	inquire/nopunct GRAFCK "Compile GRAFCK? "
$	inquire/nopunct HLP_ERRET "Compile HLP_ERRET? "
$	inquire/nopunct IO "Compile IO? "
$	inquire/nopunct IS_ALPHA_AXP "Compile IS_ALPHA_AXP? "
$	inquire/nopunct LONGIN "Compile LONGIN? "
$	inquire/nopunct LOOKUP "Compile LOOKUP? "
$	inquire/nopunct PAUSE_CMD "Compile PAUSE_CMD? "
$	inquire/nopunct PERCENT "Compile PERCENT? "
$	inquire/nopunct RDRAN "Compile RDRAN? "
$	inquire/nopunct RDRANG "Compile RDRANG? "
$	inquire/nopunct RDUNF "Compile RDUNF? "
$	inquire/nopunct READLL "Compile READLL? "
$	inquire/nopunct REALIN "Compile REALIN? "
$	inquire/nopunct REDNOD "Compile REDNOD? "
$	inquire/nopunct RESLOG "Compile RESLOG? "
$	inquire/nopunct SCREEN "Compile SCREEN? "
$	inquire/nopunct SPAWN_CMD "Compile SPAWN_CMD? "
$	inquire/nopunct START "Compile START? "
$	inquire/nopunct T4100 "Compile T4100? "
$	inquire/nopunct TXTOUT "Compile TXTOUT? "
$	inquire/nopunct VALUE "Compile VALUE? "
$	inquire/nopunct VT100 "Compile VT100? "
$	inquire/nopunct WAIT_CMD "Compile WAIT_CMD? "
$	inquire/nopunct WINDOW_CMD "Compile WINDOW_CMD? "
$	inquire/nopunct WRTRAN "Compile WRTRAN? "
$	inquire/nopunct WRTUNF "Compile WRTUNF? "
$!  
$a11:	   inq/nop newlib "Create new dtmcreate library ? "
$	   if .not.newlib then goto oldlib
$	        wc "$	library/create  dtmcreate''AXPS'"
$	   	wc "$	libr = ""library/insert/log  dtmcreate''AXPS'"""
$	   goto do_mess
$ oldlib:
$	   	wc "$	libr = ""library/replace/log  dtmcreate''AXPS'"""
$ do_mess:	wc "$ 	set noverify" 
$! 
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++""" 
$		wc "$ 	set verify" 
$ cmponly:		
$	if .not. compm then goto for
$	mdeb=""
$	if dtmcreate_dbg then mdeb = "/Enable=debug"
$		wc "$	MACRO''mdeb' PANIO"
$		wc "$	if $status then libr panio.obj"
$		wc "$	MACRO''mdeb' VSTTEM"
$		wc "$	if $status then libr vsttem.obj"
$ for: 
$	if .not. compf then goto compile_finished
$	 if alarms then call compiler alarms
$	 if bitmatch then call compiler bitmatch
$	 if conver then call compiler conver
$	 if cvtang then call compiler cvtang
$	 if dtmjpi then call compiler dtmjpi
$	 if endit then call compiler endit
$	 if examine_term then call compiler examine_term
$	 if getspec then call compiler getspec
$	 if grafck then call compiler grafck
$	 if hlp_erret then call compiler hlp_erret
$	 if io then call compiler io
$	 if is_alpha_axp then call compiler is_alpha_axp
$	 if longin then call compiler longin
$	 if lookup then call compiler lookup
$	 if pause_cmd then call compiler pause_cmd
$	 if percent then call compiler percent
$	 if rdran then call compiler rdran
$	 if rdranG then call compiler rdrang
$	 if rdunf then call compiler rdunf
$	 if readll then call compiler readll
$	 if realin then call compiler realin
$	 if rednod then call compiler rednod
$	 if reslog then call compiler reslog
$	 if screen then call compiler screen
$	 if spawn_cmd then call compiler spawn_cmd
$	 if start then call compiler start
$	 if txtout then call compiler txtout
$	 if value then call compiler value
$	 if wait_cmd then call compiler wait_cmd
$	 if window_cmd then call compiler window_cmd
$	 if wrtran then call compiler wrtran
$	 if wrtunf then call compiler wrtunf
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ compiler: subroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$		wc "$ 	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc ''p1'''kpcom'=''p1'"
$	   	wc "$	fort''fsw1' ''fswa' ''p1'"
$	      	wc "$ 	ok=$severity.eq.1 .or. $severity.eq.0"	
$		wc "$ 	if ok then pvv ''p1'"
$		wc "$ 	purge/nolog ''p1'.obj"
$		if fsw1.eqs."" then -
		wc "$ 	delete/nolog ''p1'.for;*"
$		if fsw1.nes.""  then -
		wc "$ 	purge/nolog ''p1'.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
		wc "$ 	if ok then delete/nolog ''p1'.lis;*"
$		wc "$	if .not.ok then emsg=emsg+"" ''p1'"""
$		wc "$ 	delete adc.ide;*"
$		wc "$	if ok then libr ''p1'"
$		wc "$ 	delete ''p1'.obj;*"
$		wc "$	set noverify"
$	return
$ endsubroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ compile_finished:
$	wc "$	set noverify"
$	wc "$	if emsg.eqs."""" then goto noerr"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	write sys$output ""Compilation errors in:"""
$	wc "$	write sys$output emsg"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	noerr:"
$!
$ nolnk:
$		wc "$ 	dtmcreateex:"
$		wc "$ 	deass/group lsl$dtmcreate_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto dtmcreateex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$dtmcreate_building
$	bat dtmcreatebat.com
$	goto dtmcreatex2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto dtmcreateex
$	deass/group lsl$dtmcreate_building
$	@dtmcreatebat.com
$	goto dtmcreatex2
$ dtmcreateex:
$	deass/group lsl$dtmcreate_building
$ dtmcreatex2:
$	if ver then set verify
