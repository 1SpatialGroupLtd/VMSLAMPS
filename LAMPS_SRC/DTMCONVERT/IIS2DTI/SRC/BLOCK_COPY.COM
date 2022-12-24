$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-06-04 11:52:16.000000000 +0100
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
$! Command file for building BLOCK_COPY
$!
$	on error then goto bcex
$	on control_y then exit
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$bc_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto bcex
$	define/group lsl$bc_building "in_progress"
$	open/write comfil bcbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto bcex"
$	wc	"$	if ""'","'f$logical(""lsl$bc_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$a0:	define/group lsl$bc_building ""in_progress"""
$	wc	"$	sd:=$lsl$sys:sd"
$	wc	"$	set noon"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop bc_dbg "With Debug ? "
$	if .not. bc_dbg then goto a04
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
$	   inq/nop cld "Compile CLD modules ? "
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all FORTRAN sources ? "
$	   if .not. everything then goto a05
$	   block_copy="t"
$	   goto a11
$!
$ a05:	   inq/nop block_copy	"Compile BLOCK_COPY?	"
$	   write sys$output " "
$!
$ a11:	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkver="block_copy"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="block_copyx"
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
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
$	   if .not. cld then goto fortonly
$		wc "$ 		adc block_copy.tmp=block_copy_cld.cld"
$		wc "$ 		set command/object=block_copy_cld block_copy.tmp"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv block_copy_cld"
$		wc "$ 		if ok then delete block_copy.tmp;*"
$		wc "$ 		if ok then purge/nolog block_copy_cld.obj"
$
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. block_copy then goto lnkonly
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		adc block_copy ''kpcom'=block_copy"
$	   	wc "$ 		fort''fsw1' block_copy"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv block_copy"
$		wc "$ 		purge/nolog block_copy.obj"
$		wc "$ 		purge/nolog block_copy.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog block_copy.lis"
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		link''linkopts'/exe=''linkver' block_copy,-"
$	   	wc "		block_copy_cld, -"
$!	   	wc "		iis6dti.promsg_obj, -"
$	   	wc "		lsl$library:lslshr/opt"
$!
$ nolnk:
$		wc "$ 		bcex:"
$		wc "$ 		deass/group lsl$bc_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto bcex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$bc_building
$	bat bcbat.com
$	goto bcx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto bcex
$	deass/group lsl$bc_building
$	@bcbat.com
$	goto bcx2
$!
$ bcex:
$	deass/group lsl$bc_building
$ bcx2:
$	purge bcbat.com
$	purge block_copy.map
$	delete adc.ide;*
$!
$	if ver then set verify
$!
