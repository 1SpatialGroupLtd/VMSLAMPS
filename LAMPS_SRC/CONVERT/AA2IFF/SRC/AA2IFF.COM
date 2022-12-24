$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-04-17 15:07:54.000000000 +0100
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
$! Copyright Laser-Scan Limited, Cambridge, England.
$!
$! Command file for building AA2IFF
$!
$	on error then goto aa2iex
$	on control_y then exit
$	define/nolog cmn lsl$source_root:[convert.aa2iff]
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$aa2i_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto aa2iex
$	define/group lsl$aa2i_building "in_progress"
$	open/write comfil aa2iffbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto aa2iex"
$	wc	"$	if ""'","'f$logical(""lsl$aa2i_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$a0:	define/group lsl$aa2i_building ""in_progress"""
$	wc	"$	set noon"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop aa2i_dbg "With debug ? "
$	if .not. aa2i_dbg then goto a04
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
$	   aa2iff	 = "t"
$	   obey		 = "t"
$	   rdpar	 = "t"
$	   process	 = "t"
$	   iff_start	 = "t"
$	   start_feature = "t"
$	   coord	 = "t"
$	   flush	 = "t"
$!
$	   goto a11
$!
$ a05:	   inq/nop aa2iff	 "Compile AA2IFF?	"
$	   inq/nop obey		 "Compile OBEY? 	"
$	   inq/nop rdpar	 "Compile RDPAR?	"
$	   inq/nop process	 "Compile PROCESS?	"
$	   inq/nop iff_start	 "Compile IFF_START? 	"
$	   inq/nop start_feature "Compile START_FEATURE?"
$	   inq/nop coord	 "Compile COORD? 	"
$	   inq/nop flush	 "Compile FLUSH? 	"
$	   write sys$output " "
$ a11:	   inq/nop mes "Generate message definitions? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkver="aa2iff"
$	   inquire/nop answer "Experimental version? "
$	   if answer then linkver="aa2iffx"
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
$ 		if .not. mes then goto nomess
$		wc "$	newmsg/number=1627/prefix=aa2i__/param=fortran/runoff/hl=2 aa2iff.mes"
$		wc "$	@aa2iff.temp_com"
$		wc "$	purge aa2iffmsg.rno"
$!
$ nomess:	if .not. cld then goto fortonly
$		wc "$ 		adc aa2iff.tmp=aa2iff_cld.cld"
$		wc "$ 		set command/object=aa2iff_cld aa2iff.tmp"
$	      	wc "$ 		ok=$status"	
$!		wc "$ 		if ok then pvv aa2iff_cld"
$!		wc "$ 		if ok then delete adc.ide;*"
$		wc "$ 		if ok then delete aa2iff.tmp;*"
$		wc "$ 		if ok then purge/nolog aa2iff_cld.obj"
$
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. aa2iff then goto a100
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' aa2iff.f"
$		wc "$ 		purge/nolog aa2iff.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog aa2iff.lis"
$!
$ a100:	   if .not. obey then goto a101
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' obey.f"
$		wc "$ 		purge/nolog obey.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog obey.lis"
$!
$ a101:	   if .not. rdpar then goto a102
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' rdpar.f"
$		wc "$ 		purge/nolog rdpar.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog rdpar.lis"
$!
$ a102:	   if .not. process then goto a105
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' process.f"
$		wc "$ 		purge/nolog process.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog process.lis"
$!
$ a105:	   if .not. iff_start then goto a110
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' iff_start.f"
$		wc "$ 		purge/nolog iff_start.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog iff_start.lis"
$!
$ a110:	   if .not. start_feature then goto a120
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' start_feature.f"
$		wc "$ 		purge/nolog start_feature.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog start_feature.lis"
$!
$ a120:	   if .not. coord then goto a125
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' coord.f"
$		wc "$ 		purge/nolog coord.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog coord.lis"
$!
$ a125:	   if .not. flush then goto lnkonly
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' flush.f"
$		wc "$ 		purge/nolog flush.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog flush.lis"
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		link''linkopts'/exe=''linkver' aa2iff, -"
$	   	wc "		aa2iff_cld, -"
$		wc "		obey, -"
$		wc "		rdpar, -"
$		wc "		process, -"
$		wc "		iff_start, -"
$		wc "		start_feature, -"
$		wc "		coord, -"
$		wc "		flush, -"
$		wc "		aa2iff.promsg_obj, -"
$		wc "		lsl$library:lslfrtlib/lib,-"
$	   	wc "		lsl$library:iffshr/opt,lslshr/opt"
$ nolnk:
$		wc "$ 		aa2iex:"
$		wc "$ 		deass/group lsl$aa2i_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto aa2iex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$aa2i_building
$	bat aa2iffbat.com
$	goto aa2ix2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto aa2iex
$	deass/group lsl$aa2i_building
$	@aa2iffbat.com
$	goto aa2ix2
$ aa2iex:
$	deass/group lsl$aa2i_building
$ aa2ix2:
$	if ver then set verify
$	pur aa2iffbat.com
$	pur *.obj
$!
