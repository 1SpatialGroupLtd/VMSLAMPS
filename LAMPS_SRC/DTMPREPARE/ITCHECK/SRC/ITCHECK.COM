$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-13 16:22:02.000000000 +0100
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
$! 	Command file to build DTMPREPARE utility ITCHECK
$!
$! 	Copyright Laser-Scan Limited, Cambridge, England.
$!	Created						TJH 09-Jan-1990
$!
$!	mod1267 use DTMPREPARE service for any dtmcreate routines
$!							 JB 13-AUG-1993
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	ver=f$verify(0)
$!
$	on error then goto itcheckex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$itcheck_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto itcheckex
$	define/group lsl$itcheck_building "in_progress"
$	open/write comfil itcheckbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$	define lsl$cmnitcheck	 here
$	define lsl$dtmcreatesys	 lsl$source_root:[dtmprepare.service]
$	define lsl$dtmpreparesys lsl$source_root:[dtmprepare.service]
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto itcheckex"
$	wc "$	if ""'","'f$logical(""lsl$itcheck_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$itcheck_building ""in_progress"""
$	wc "$ define lsl$cmnitcheck here"
$	wc "$ define lsl$dtmcreatesys  lsl$source_root:[dtmprepare.service]"
$	wc "$ define lsl$dtmpreparesys lsl$source_root:[dtmprepare.service]"
$	wc "$	sd:=$lsl$sys:sd"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	everything=""
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	itcheck_dbg=""
$	macbuild=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop itcheck_dbg "With Debug ? "
$	if .not. itcheck_dbg then goto a04
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
$	   checkfiles="t"
$	   bfiles="t"
$	   cfiles="t"
$	   dfiles="t"
$	   efiles="t"
$	   gfiles="t"
$	   hfiles="t"
$	   ifiles="t"
$	   lfiles="t"
$	   ofiles="t"
$	   pfiles="t"
$	   rfiles="t"
$	   sfiles="t"
$	   tfiles="t"
$	   wfiles="t"
$	   zfiles="t"
$!
$!
$	   macbuild="t"
$	   goto a11
$!
$ a05:	   
$	ws " "
$	ws ".............................MACRO32 stuff"
$	   inq/nop macbuild	"Compile command table? "
$	ws " " 
	ws ".............................FORTRAN sources"
$	inq/nop checkfiles "check*.src?  "
$	inq/nop bfiles "b*.src?  "
$	inq/nop cfiles "c*.src?  "
$	inq/nop dfiles "d*.src?  "
$	inq/nop efiles "e*.src?  "
$	inq/nop gfiles "g*.src?  "
$	inq/nop hfiles "h*.src?  "
$	inq/nop ifiles "i*.src?  "
$	inq/nop lfiles "l*.src?  "
$	inq/nop ofiles "o*.src?  "
$	inq/nop pfiles "p*.src?  "
$	inq/nop rfiles "r*.src?  "
$	inq/nop sfiles "s*.src?  "
$	inq/nop tfiles "t*.src?  "
$	inq/nop wfiles "w*.src?  "
$	inq/nop zfiles "z*.src?  "
$!
$ a11:
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkver="itcheck"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="itcheckx"
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!	   
$!
$ notkb:
$		wc "$ 	set noverify"
$!
$	   if .not.everything then goto oldlib
$	        wc "$	library/create  itcheck_fortran_sources"
$	   	wc "$	libr = ""library/insert/log  itcheck_fortran_sources"""
$	   goto do_mess
$ oldlib:
$	   	wc "$	libr = ""library/replace/log  itcheck_fortran_sources"""
$!
$ do_mess:
$!	
$ cmponly:		
$	   if .not. compile then goto lnkonly
$	mdeb=""
$	if itcheck_dbg then mdeb = "/Enable=debug"
$	if .not. macbuild then goto for2
$		wc "$	MACRO''mdeb' ITCHECK_CMDTAB"
$		wc "$	MACRO''mdeb' GROUP_CMDTAB"
$ for2: if .not. compile then goto lnkonly
$	if checkfiles then call compiler CHECK0
$	if checkfiles then call compiler CHECK1
$	if checkfiles then call compiler CHECK2
$	if checkfiles then call compiler CHECK3
$	if checkfiles then call compiler CHECK4
$	if checkfiles then call compiler CHECK5
$	if checkfiles then call compiler CHECK6
$	if bfiles then call compiler BORDER_CHECK
$	if bfiles then call compiler BORDER_CMD
$	if cfiles then call compiler CBINOUT
$	if cfiles then call compiler CHECK_CMD
$	if cfiles then call compiler CHKTAB
$	if cfiles then call compiler CLOSE_CMD
$	if cfiles then call compiler COMPARE
$	if cfiles then call compiler CONTOUR_CMD
$	if cfiles then call compiler CPMINMAX
$	if cfiles then call compiler CROSS
$	if dfiles then call compiler DESELECT_CMD
$	if dfiles then call compiler DISPLBTMP
$	if efiles then call compiler ERRCOP
$	if efiles then call compiler ERRPTS
$	if efiles then call compiler ERRTAB
$	if gfiles then call compiler GET_CMDS
$	if gfiles then call compiler GO_CMD
$	if hfiles then call compiler HELP_CMD
$	if ifiles then call compiler IFF_CMD
$	if ifiles then call compiler INDEX_CMD
$	if ifiles then call compiler INITSEL
$	if ifiles then call compiler INWORD
$	if ifiles then call compiler ITCHECK_SETUP
$	if .not. ifiles then goto lfi
$		wc "$ 	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc itcheck''kpcom'=itcheck"
$	   	wc "$	fort''fsw1' itcheck"
$	      	wc "$ 	ok=$status"	
$		wc "$ 	if ok then pvv itcheck"
$		wc "$ 	purge/nolog itcheck.obj"
$		if fsw1.eqs."" then -
		wc "$ 	delete/nolog itcheck.for;*"
$		if fsw1.nes.""  then -
		wc "$ 	purge/nolog itcheck.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
		wc "$ 	if ok then delete/nolog itcheck.lis;*"
$		wc "$	if .not.ok then emsg=emsg+"" itcheck"""
$		wc "$ 	delete adc.ide;*"
$		wc "$	set noverify"
$ lfi:
$	if lfiles then call compiler LAYER_CMD
$	if lfiles then call compiler LCM_OPEN
$	if lfiles then call compiler LIST_CMD
$	if lfiles then call compiler LITES_CMD
$	if lfiles then call compiler LOOKUP_CMD
$	if ofiles then call compiler OPENFILE
$	if ofiles then call compiler OTPLSTRG
$	if ofiles then call compiler OUTPUT_CMD
$	if ofiles then call compiler OUTPUT_CRT
$	if pfiles then call compiler PAUSE_CMD
$	if pfiles then call compiler PERCENT
$	if pfiles then call compiler PROFILE_CMD
$	if rfiles then call compiler READFSN
$	if rfiles then call compiler READLAY
$	if rfiles then call compiler READRANG
$	if rfiles then call compiler READSEL
$	if sfiles then call compiler SELECT_CMD
$	if sfiles then call compiler SHOW_CMD
$	if sfiles then call compiler SHSELE
$	if sfiles then call compiler SUPPLEMENTARY_CMD
$	if sfiles then call compiler SWAP
$	if tfiles then call compiler TOLERANCE_CMD
$	if wfiles then call compiler WINDOW_CMD
$	if bfiles then call compiler ZLIMITS_CMD
$	   goto lnkonly
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
$		wc "$ 	if ok then libr ''p1'"
$		wc "$ 	delete/nolog ''p1'.obj;*"
$		wc "$	if .not.ok then emsg=emsg+"" ''p1'"""
$		wc "$ 	delete adc.ide;*"
$		wc "$	set noverify"
$	return
$ endsubroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
$	wc "$ 	run lsl$exe:genver"
$	wc "$ 	adc version''kpcom'=version"
$   	wc "$	fort''fsw1' version"
$      	wc "$ 	ok=$status"	
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
$	wc "$ set verify"
$	wc "$ 	link''linkopts'/exe=''linkver' itcheck/opt,lsl$library:iffshr/opt,lslshr/opt"
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	itcheckex:"
$		wc "$ 	deass/group lsl$itcheck_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto itcheckex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$itcheck_building
$	bat itcheckbat.com
$	goto itcheckx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto itcheckex
$	deass/group lsl$itcheck_building
$	@itcheckbat.com
$	goto itcheckx2
$ itcheckex:
$	deass/group lsl$itcheck_building
$ itcheckx2:
$	if ver then set verify
$!
