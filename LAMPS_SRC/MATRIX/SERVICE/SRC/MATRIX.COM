$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-12 17:54:16.000000000 +0100
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
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! 	Command file to build the MATRIX package service routines
$!
$! 	Copyright Laser-Scan Limited, Cambridge, England.
$!	Created						ALB 26-May-1988
$!
$!	Mod1265	routines from DTMCREATE service copied to matrix service
$!							 JB 11-Aug-1993
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	ver=f$verify(0)
$!
$	on error then goto matrixex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$matrix_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto matrixex
$	define/group lsl$matrix_building "in_progress"
$	open/write comfil matrixbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto matrixex"
$	wc "$	if ""'","'f$logical(""lsl$matrix_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$matrix_building ""in_progress"""
$	wc "$	assign here lsl$matrixsys"
$	wc "$	assign here lsl$dtmcreatesys"
$	wc "$	sd:=$lsl$sys:sd"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	matrix_dbg=""
$	inquire/nop compf "Compile fortran ? "
$	inquire/nop matrix_dbg "With debug ? "
$	if .not. matrix_dbg then goto a04
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
$!
$	if .not. compf then goto a11
$!
$	   inq/nop everything "Compile all sources ? "
$	   if .not. everything then goto a05
$	dtmjpi		="t"
$	hlp_erret	="t"
$	longin		="t"
$	realin		="t"
$	bitmatch	="t"
$	getspec		="t"
$	rdrang		="t"
$	pause		="t"
$	spawn_cmd	="t"
$	wait_cmd	="t"
$!
$	goto a11
$!
$ a05:	   
$	inquire/nopunct DTMJPI "Compile DTMJPI? "
$	inquire/nopunct HLP_ERRET "Compile HLP_ERRET? "
$	inquire/nopunct LONGIN "Compile LONGIN? "
$	inquire/nopunct REALIN "Compile REALIN? "
$	inquire/nopunct BITMATCH "Compile BITMATCH?"
$	inquire/nopunct GETSPEC "Compile GETSPEC? "
$	inquire/nopunct RDRANG "Compile RDRANG? "
$	inquire/nopunct PAUSE "Compile PAUSE? "
$	inquire/nopunct SPAWN_CMD "Compile SPAWN_CMD? "
$	inquire/nopunct WAIT_CMD "Compile WAIT_CMD? "
$!  
$a11:	   inq/nop newlib "Create new matrix library ? "
$	   if .not.newlib then goto oldlib
$	        wc "$	library/create  matrix"
$	   	wc "$	libr = ""library/insert/log  matrix"""
$	   goto do_mess
$ oldlib:
$	   	wc "$	libr = ""library/replace/log  matrix"""
$ do_mess:	wc "$ 	set noverify" 
$! 
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++""" 
$		wc "$ 	set verify" 
$ for: 
$	if .not. compf then goto compile_finished
$!
$	 if dtmjpi    then call compiler dtmjpi
$	 if hlp_erret then call compiler hlp_erret
$	 if longin    then call compiler longin
$	 if realin    then call compiler realin
$	 if bitmatch  then call compiler bitmatch
$	 if getspec   then call compiler getspec
$	 if rdrang    then call compiler rdrang
$	 if pause     then call compiler pause
$	 if spawn_cmd then call compiler spawn_cmd
$	 if wait_cmd  then call compiler wait_cmd
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ compiler: subroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$		wc "$ 	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc ''p1'''kpcom'=''p1'"
$	   	wc "$	fort''fsw1' ''p1'"
$	      	wc "$ 	ok=$status"	
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
$		wc "$ 	matrixex:"
$		wc "$ 	deass/group lsl$matrix_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto matrixex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$matrix_building
$	bat matrixbat.com
$	goto matrixx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto matrixex
$	deass/group lsl$matrix_building
$	@matrixbat.com
$	goto matrixx2
$ matrixex:
$	deass/group lsl$matrix_building
$ matrixx2:
$	if ver then set verify
$!
