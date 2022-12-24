$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1999-08-12 13:45:42.000000000 +0100
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
$	ver=f$verify(0)
$!
$! Command file to build DTMCREATE utility TRIGRID
$!
$! Copyright Laser-Scan Limited, Cambridge, England.
$!
$!MOD	Changed logical pointing to build dir for CMS	ST  29-Jul-1993
$!MOD	No longer uses LITES2 specific graphics libraries.
$!	Now uses LSLSHR					TJH 03-Jan-1989
$!	Created						TJH 07-Apr-1988
$!
$!
$	on error then goto trigridex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$trigrid_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto trigridex
$	define/group lsl$trigrid_building "in_progress"
$	open/write comfil trigridbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto trigridex"
$	wc "$	if ""'","'f$logical(""lsl$trigrid_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$trigrid_building ""in_progress"""
$	wc "$	assign lsl$source_root:[dtmcreate.trigrid.src] lsl$cmntrigrid"
$	wc "$	assign lsl$source_root:[dtmcreate.service.src] lsl$dtmcreatesys"
$	wc "$	sd:=$lsl$sys:sd"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$! check for AXP version
$!
$	arch_name=f$getsyi("ARCH_NAME")
$	if arch_name.eqs."Alpha" 
$	then 
$	   tvs="_tv"
$	   axps="_axp"
$	   fswa="/extend/tie/float=d"
$	else
$	   tvs=""
$	   axps=""
$	   fswa=""
$	endif
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	trigrid_dbg=""
$	macbuild=""
$	mes=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop trigrid_dbg "With Debug ? "
$	if .not. trigrid_dbg then goto a04
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
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all sources ? "
$	   if .not. everything then goto a05
$	data_type_cmd="t"
$	deter="t"
$	disable_cmd="t"
$	dot="t"
$	dtmgrd="t"
$	enable_cmd="t"
$	evalz="t"
$	facet="t"
$	filclo="t"
$	filein_cmd="t"
$	fileout_cmd="t"
$	finpos="t"
$	framed_mes="t"
$	getnay="t"
$	getsid="t"
$	get_cmds="t"
$	gtlink="t"
$	header_type_cmd="t"
$	help_cmd="t"
$	initialise="t"
$	limits_cmd="t"
$	linkck="t"
$	opndti="t"
$	putnay="t"
$	putsid="t"
$	readin="t"
$	remnod="t"
$	setcof="t"
$	setup="t"
$	show_cmd="t"
$	show_window="t"
$	sidelength_cmd="t"
$	siderr="t"
$	sidfil="t"
$	size_cmd="t"
$	triangle_limits_cmd="t"
$	trigrid="t"
$	trival="t"
$	units_cmd="t"
$	window_cmd="t"
$	write_post="t"
$	macbuild="t"
$	goto a11
$ a05:	   
$	ws " "
$	ws ".............................MACRO32 stuff"
$	   inq/nop macbuild	"Compile command table? "
$	ws " " 
$	ws ".............................FORTRAN sources"
$	inquire/nopunct data_type_cmd "Compile data_type_cmd ? "
$	inquire/nopunct deter "Compile deter ? "
$	inquire/nopunct disable_cmd "Compile disable_cmd ? "
$	inquire/nopunct dot "Compile dot ? "
$	inquire/nopunct dtmgrd "Compile dtmgrd ? "
$	inquire/nopunct enable_cmd "Compile enable_cmd ? "
$	inquire/nopunct evalz "Compile evalz ? "
$	inquire/nopunct facet "Compile facet ? "
$	inquire/nopunct filclo "Compile filclo ? "
$	inquire/nopunct filein_cmd "Compile filein_cmd ? "
$	inquire/nopunct fileout_cmd "Compile fileout_cmd ? "
$	inquire/nopunct finpos "Compile finpos ? "
$	inquire/nopunct framed_mes "Compile framed_mes ? "
$	inquire/nopunct getnay "Compile getnay ? "
$	inquire/nopunct getsid "Compile getsid ? "
$	inquire/nopunct get_cmds "Compile get_cmds ? "
$	inquire/nopunct gtlink "Compile gtlink ? "
$	inquire/nopunct header_type_cmd "Compile header_type_cmd ? "
$	inquire/nopunct help_cmd "Compile help_cmd ? "
$	inquire/nopunct initialise "Compile initialise ? "
$	inquire/nopunct limits_cmd "Compile limits_cmd ? "
$	inquire/nopunct linkck "Compile linkck ? "
$	inquire/nopunct opndti "Compile opndti ? "
$	inquire/nopunct putnay "Compile putnay ? "
$	inquire/nopunct putsid "Compile putsid ? "
$	inquire/nopunct readin "Compile readin ? "
$	inquire/nopunct remnod "Compile remnod ? "
$	inquire/nopunct setcof "Compile setcof ? "
$	inquire/nopunct setup "Compile setup ? "
$	inquire/nopunct show_cmd "Compile show_cmd ? "
$	inquire/nopunct show_window "Compile show_window ? "
$	inquire/nopunct sidelength_cmd "Compile sidelength_cmd ? "
$	inquire/nopunct siderr "Compile siderr ? "
$	inquire/nopunct sidfil "Compile sidfil ? "
$	inquire/nopunct size_cmd "Compile size_cmd ? "
$	inquire/nopunct triangle_limits_cmd "Compile triangle_limits_cmd ? "
$	inquire/nopunct trigrid "Compile trigrid ? "
$	inquire/nopunct trival "Compile trival ? "
$	inquire/nopunct units_cmd "Compile units_cmd ? "
$	inquire/nopunct window_cmd "Compile window_cmd ? "
$	inquire/nopunct write_post "Compile write_post ? "
$!
$ a11:
$	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map/full"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   if arch_name.eqs."Alpha" 
$	   then 
$	      linkopts=linkopts + "/nonative_only"
$	   endif
$!
$	   linkver = "trigrid"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver=linkver+"x"
$	   linkver = linkver + axps
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!	   
$	   if .not. compile then goto lnkonly
$!
$ notkb:
$		wc "$ 	set noverify"
$!
$	   if .not.everything then goto oldlib
$	        wc "$	library/create  trigrid_fortran_sources"
$	   	wc "$	libr = ""library/insert/log  trigrid_fortran_sources"""
$	   goto do_mess
$ oldlib:
$	   	wc "$	libr = ""library/replace/log  trigrid_fortran_sources"""
$!
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ do_mess:	wc "$ 	set verify"
$ 		if .not.mes then goto cmponly
$		wc "$	newmsg/dti/number=1638/name=trigrid/prefix=trigrid__/parameter=for/runoff trigrid.mes"
$		wc "$ @trigrid.temp_com"
$!
$ cmponly:
$	mdeb=""
$	if trigrid_dbg then mdeb = "/Enable=debug"
$	if .not. macbuild then goto for2
$		wc "$	MACRO''mdeb' trigrid_cmdtab"
$ for2: if .not. compile then goto lnkonly
$	
$!
$	if data_type_cmd then call compiler data_type_cmd
$	if deter then call compiler deter
$	if disable_cmd then call compiler disable_cmd
$	if dot then call compiler dot
$	if dtmgrd then call compiler dtmgrd
$	if enable_cmd then call compiler enable_cmd
$	if evalz then call compiler evalz
$	if facet then call compiler facet
$	if filclo then call compiler filclo
$	if filein_cmd then call compiler filein_cmd
$	if fileout_cmd then call compiler fileout_cmd
$	if finpos then call compiler finpos
$	if framed_mes then call compiler framed_mes
$	if getnay then call compiler getnay
$	if getsid then call compiler getsid
$	if get_cmds then call compiler get_cmds
$	if gtlink then call compiler gtlink
$	if header_type_cmd then call compiler header_type_cmd
$	if help_cmd then call compiler help_cmd
$	if initialise then call compiler initialise
$	if limits_cmd then call compiler limits_cmd
$	if linkck then call compiler linkck
$	if opndti then call compiler opndti
$	if putnay then call compiler putnay
$	if putsid then call compiler putsid
$	if readin then call compiler readin
$	if remnod then call compiler remnod
$	if setcof then call compiler setcof
$	if setup then call compiler setup
$	if show_cmd then call compiler show_cmd
$	if show_window then call compiler show_window
$	if sidelength_cmd then call compiler sidelength_cmd
$	if siderr then call compiler siderr
$	if sidfil then call compiler sidfil
$	if size_cmd then call compiler size_cmd
$	if triangle_limits_cmd then call compiler triangle_limits_cmd
$	if trival then call compiler trival
$	if units_cmd then call compiler units_cmd
$	if window_cmd then call compiler window_cmd
$	if write_post then call compiler write_post
$	if .not. trigrid then goto lnkonly
$		wc "$ 	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc trigrid''kpcom'=trigrid"
$	   	wc "$	fort''fsw1' ''fswa' trigrid"
$	      	wc "$ 	ok=$severity.eq.1 .or. $severity.eq.0"	
$		wc "$ 	if ok then pvv trigrid"
$		wc "$ 	purge/nolog trigrid.obj"
$		if fsw1.eqs."" then -
		wc "$ 	delete/nolog trigrid.for;*"
$		if fsw1.nes.""  then -
		wc "$ 	purge/nolog trigrid.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
		wc "$ 	if ok then delete/nolog trigrid.lis;*"
$		wc "$	if .not.ok then emsg=emsg+"" trigrid"""
$		wc "$ 	delete adc.ide;*"
$		wc "$	set noverify"
$!	
$	   goto lnkonly
$!
$!---------------------------------------------------------------------- 
$ compiler: subroutine 
$!----------------------------------------------------------------------
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
$		wc "$ 	if ok then libr ''p1'"
$		wc "$ 	delete/nolog ''p1'.obj;*"
$		wc "$	if .not.ok then emsg=emsg+"" ''p1'"""
$		wc "$ 	delete adc.ide;*"
$		wc "$	set noverify"
$	return
$ endsubroutine
$!----------------------------------------------------------------------
$ lnkonly:
$	wc "$	set noverify"
$	wc "$	if emsg.eqs."""" then goto noerr"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	write sys$output ""Compilation errors in:"""
$	wc "$	write sys$output emsg"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	goto nolnk"
$	wc "$	noerr:"
$ 	if .not. lnkit then goto nolnk
$	wc "$ set noverify"
$	wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$ set verify"
$	wc "$ 	run lsl$exe:genver"+tvs
$	wc "$ 	adc version''kpcom'=version"
$   	wc "$	fort''fsw1' ''fswa' version"
$	wc "$ 	ok=$severity.eq.1 .or. $severity.eq.0"	
$	wc "$ 	if ok then pvv version"
$	wc "$ 	purge/nolog version.obj"
$	if fsw1.eqs."" then -
		wc "$ 	delete/nolog version.for;*"
$	if fsw1.nes.""  then -
		wc "$ 	purge/nolog version.for"
$	if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
	wc "$ 	if ok then delete/nolog version.lis;*"
$	wc "$	if .not.ok then emsg=emsg+"" version"""
$	wc "$ 	delete adc.ide;*"
$	wc "$ 	purge/nolog version.src"
$	wc "$   set verify"
$	wc "$   define/user lsl$dtm_gksshr lsl$exe:dtm_gksnullshr''tvs'"
$	wc "$	define/user lsl$lslshr_tv lsl$library:lslshr_dummy_axp"
$	wc "$	define/user lsl$dtishr_tv lsl$library:dtishr_dummy_axp"
$	wc "$ 	link''linkopts'/exe=''linkver' trigrid''axps'/opt,-"
$	wc "		lsl$library:lslshr''tvs'/opt,-"
$	wc "		lsl$library:dtishr''tvs'/opt"
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	trigridex:"
$		wc "$ 	deass/group lsl$trigrid_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto trigridex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$trigrid_building
$	bat trigridbat.com
$	goto trigridx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto trigridex
$	deass/group lsl$trigrid_building
$	@trigridbat.com
$	goto trigridx2
$!
$ trigridex:
$	deass/group lsl$trigrid_building
$!
$ trigridx2:
$	if ver then set verify
$!
