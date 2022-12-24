$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1999-08-12 13:13:42.000000000 +0100
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
$! Command file to build DTMCREATE utility TRIDER
$!
$! Copyright Laser-Scan Limited, Cambridge, England.
$!
$!MOD	No longer uses LITES2 specific graphics libraries.
$!	Now uses LSLSHR					TJH 03-Jan-1989
$!	Created						TJH 23-Nov-1987
$!
$	ver=f$verify(0)
$!
$	on error then goto triderex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$trider_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto triderex
$	define/group lsl$trider_building "in_progress"
$	open/write comfil triderbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto triderex"
$	wc "$	if ""'","'f$logical(""lsl$trider_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$trider_building ""in_progress"""
$	wc "$	assign lsl$source_root:[dtmcreate.trider.src] lsl$cmntrider"
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
$	trider_dbg=""
$	macbuild=""
$	mes=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop trider_dbg "With Debug ? "
$	if .not. trider_dbg then goto a04
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
$	boxint="t"
$	cramer="t"
$	deriv="t"
$	disable_cmd="t"
$	dot="t"
$	enable_cmd="t"
$	filein_cmd="t"
$	filclo="t"
$	frame="t"
$	framed_mes="t"
$	getfil="t"
$	getnay="t"
$	help_cmd="t"
$	imaginary_cmd="t"
$	interp="t"
$	limits_cmd="t"
$	neighb="t"
$	picsqu="t"
$	putnay="t"
$	readin="t"
$	setup="t"
$	show_cmd="t"
$	solve="t"
$	trackn="t"
$	trend="t"
$	trider="t"
$	macbuild="t"
$	goto a11
$ a05:	   
$	ws " "
$	ws ".............................MACRO32 stuff"
$	   inq/nop macbuild	"Compile command table? "
$	ws " " 
$	ws ".............................FORTRAN sources"
$	inq/nop BOXINT "Compile BOXINT? "
$	inq/nop CRAMER "Compile CRAMER? "
$	inq/nop DERIV "Compile DERIV? "
$	inq/nop DISABLE_CMD "Compile DISABLE_CMD? "
$	inq/nop DOT "Compile DOT? "
$	inq/nop ENABLE_CMD "Compile ENABLE_CMD? "
$	inq/nop FILEIN_CMD "Compile FILEIN_CMD? "
$	inq/nop filclo "Compile FILCLO? "
$	inq/nop FRAME "Compile FRAME? "
$	inq/nop FRAMED_MES "Compile FRAMED_MES? "
$	inq/nop GETFIL "Compile GETFIL? "
$	inq/nop GETNAY "Compile GETNAY? "
$	inq/nop HELP_CMD "Compile HELP_CMD? "
$	inq/nop IMAGINARY_CMD "Compile IMAGINARY_CMD? "
$	inq/nop INTERP "Compile INTERP? "
$	inq/nop LIMITS_CMD "Compile LIMITS_CMD? "
$	inq/nop NEIGHB "Compile NEIGHB? "
$	inq/nop PICSQU "Compile PICSQU? "
$	inq/nop PUTNAY "Compile PUTNAY? "
$	inq/nop READIN "Compile READIN? "
$	inq/nop SETUP "Compile SETUP? "
$	inq/nop SHOW_CMD "Compile SHOW_CMD? "
$	inq/nop SOLVE "Compile SOLVE? "
$	inq/nop TRACKN "Compile TRACKN? "
$	inq/nop TREND "Compile TREND? "
$	inq/nop TRIDER "Compile TRIDER? "
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
$	   linkver = "trider"
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
$	        wc "$	library/create  trider_fortran_sources"
$	   	wc "$	libr = ""library/insert/log  trider_fortran_sources"""
$	   goto do_mess
$ oldlib:
$	   	wc "$	libr = ""library/replace/log  trider_fortran_sources"""
$!
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ do_mess:	wc "$ 	set verify"
$ 		if .not.mes then goto cmponly
$		wc "$	newmsg/number=1637/name=TRIDER/prefix=TRIDER__/parameter=for/runoff trider.mes"
$		wc "$ @trider.temp_com"
$!	
$ cmponly:		
$	mdeb=""
$	if trider_dbg then mdeb = "/Enable=debug"
$	if .not. macbuild then goto for2
$		wc "$	MACRO''mdeb' trider_cmdtab"
$ for2: if .not. compile then goto lnkonly
$	
$!
$	if BOXINT then call compiler BOXINT
$	if CRAMER then call compiler CRAMER
$	if DERIV then call compiler DERIV
$	if DISABLE_CMD then call compiler DISABLE_CMD
$	if DOT then call compiler DOT
$	if ENABLE_CMD then call compiler ENABLE_CMD
$	if FILEIN_CMD then call compiler FILEIN_CMD
$	if FILCLO then call compiler FILCLO
$	if FRAME then call compiler FRAME
$	if FRAMED_MES then call compiler FRAMED_MES
$	if GETFIL then call compiler GETFIL
$	if GETNAY then call compiler GETNAY
$	if HELP_CMD then call compiler HELP_CMD
$	if IMAGINARY_CMD then call compiler IMAGINARY_CMD
$	if INTERP then call compiler INTERP
$	if LIMITS_CMD then call compiler LIMITS_CMD
$	if NEIGHB then call compiler NEIGHB
$	if PICSQU then call compiler PICSQU
$	if PUTNAY then call compiler PUTNAY
$	if READIN then call compiler READIN
$	if SETUP then call compiler SETUP
$	if SHOW_CMD then call compiler SHOW_CMD
$	if SOLVE then call compiler SOLVE
$	if TRACKN then call compiler TRACKN
$	if TREND then call compiler TREND
$	if .not. TRIDER then goto lnkonly
$		wc "$ 	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc TRIDER''kpcom'=TRIDER"
$	   	wc "$	fort''fsw1' ''fswa' TRIDER"
$	      	wc "$ 	ok=$severity.eq.1 .or. $severity.eq.0"
$		wc "$ 	if ok then pvv TRIDER"
$		wc "$ 	purge/nolog TRIDER.obj"
$		if fsw1.eqs."" then -
		wc "$ 	delete/nolog TRIDER.for;*"
$		if fsw1.nes.""  then -
		wc "$ 	purge/nolog TRIDER.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
		wc "$ 	if ok then delete/nolog TRIDER.lis;*"
$		wc "$	if .not.ok then emsg=emsg+"" TRIDER"""
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
$	wc "$ 	link''linkopts'/exe=''linkver' trider''axps'/opt,-"
$	wc "		lsl$library:lslshr''tvs'/opt"
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	triderex:"
$		wc "$ 	deass/group lsl$trider_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto triderex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$trider_building
$	bat triderbat.com
$	goto triderx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto triderex
$	deass/group lsl$trider_building
$	@triderbat.com
$	goto triderx2
$!
$ triderex:
$	deass/group lsl$trider_building
$!
$ triderx2:
$	if ver then set verify
$!
