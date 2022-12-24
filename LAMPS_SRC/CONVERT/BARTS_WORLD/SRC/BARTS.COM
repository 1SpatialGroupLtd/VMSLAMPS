$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-10-04 18:08:08.000000000 +0100
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
$! Copyright Laser-Scan, Cambridge, England.
$!
$! Command file for building BARTS WORLD NAMES
$!
$	on error then goto bartex
$	on control_y then exit
$	define/nolog cmn lsl$source_root:[convert.barts_world]
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$bart_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto bartex
$	define/group lsl$bart_building "in_progress"
$	open/write comfil bartsbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto bartex"
$	wc	"$	if ""'","'f$logical(""lsl$bart_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$a0:	define/group lsl$bart_building ""in_progress"""
$	wc	"$	set noon"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop bart_dbg "With debug ? "
$	if .not. bart_dbg then goto a04
$	   fsw1="/debug"
$	   mldbg="/debug"
$	   inquire/nop answer "Without optimisation ? "
$	   if answer then fsw1=fsw1 + "/noopt"
$	   inquire/nop answer "Check bounds and overflow ? "
$	   if answer then fsw1=fsw1 + "/check=(bounds,overflow)"
$	   inquire/nop answer "With listings ? "
$	   if answer then fsw1=fsw1 + "/list"
$	   inquire/nop answer "Keep fortran sources with comments ? "
$	   if answer then kpcom="/co"
$ a04:
$	   inq/nop cld "Compile CLD modules ? "
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all fortran sources ? "
$	   if .not. everything then goto a05
$	   barts	 = "t"
$	   obey		 = "t"
$	   set_ascii	 = "t"
$	   process	 = "t"
$!
$	   goto a11
$!
$ a05:	   inq/nop barts	 "Compile BARTS?	"
$	   inq/nop obey		 "Compile OBEY? 	"
$	   inq/nop set_ascii	 "Compile SET_ASCII? 	"
$	   inq/nop process	 "Compile PROCESS?	"
$	   write sys$output " "
$!
$! a11:	   inq/nop mes "Generate message definitions? "
$  a11:	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkver="barts"
$	   inquire/nop answer "Experimental version? "
$	   if answer then linkver="bartsx"
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$	   
$ notkb:
$!
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		set verify"
$!
$!		if .not. mes then goto nomess
$!		wc "$	newmsg/number=1627/prefix=barts__/param=fortran/runoff/hl=2 barts.mes"
$!		wc "$	@barts.temp_com"
$!		wc "$	purge bartsmsg.rno"
$!
$ nomess:	if .not. cld then goto fortonly
$		wc "$ 		adc barts.tmp=barts_cld.cld"
$		wc "$ 		set command/object=barts_cld barts.tmp"
$	      	wc "$ 		ok=$status"	
$!		wc "$ 		if ok then pvv barts_cld"
$!		wc "$ 		if ok then delete adc.ide;*"
$		wc "$ 		if ok then delete barts.tmp;*"
$		wc "$ 		if ok then purge/nolog barts_cld.obj"
$
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. barts then goto a99
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' barts.f"
$		wc "$ 		purge/nolog barts.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog barts.lis"
$!
$ a99:	   if .not. obey then goto a100
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' obey.f"
$		wc "$ 		purge/nolog obey.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog obey.lis"
$!
$ a100:	   if .not. set_ascii then goto a101
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' set_ascii.f"
$		wc "$ 		purge/nolog set_ascii.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog set_ascii.lis"
$!
$ a101:	   if .not. process then goto lnkonly
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' process.f"
$		wc "$ 		purge/nolog process.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog process.lis"
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		link''linkopts'/exe=''linkver' barts, -"
$	   	wc "		barts_cld, -"
$		wc "		obey, -"
$		wc "		set_ascii, -"
$		wc "		process, -"
$!		wc "		barts.promsg_obj, -"
$	   	wc "		lsl$library:lslshr/opt"
$ nolnk:
$		wc "$ 		bartex:"
$		wc "$ 		deass/group lsl$bart_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto bartex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$bart_building
$	bat bartsbat.com
$	goto bartx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto bartex
$	deass/group lsl$bart_building
$	@bartsbat.com
$	goto bartx2
$ bartex:
$	deass/group lsl$bart_building
$ bartx2:
$	if ver then set verify
$	pur bartsbat.com
$	pur *.obj
$!
