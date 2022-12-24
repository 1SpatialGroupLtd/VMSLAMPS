$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-05-18 16:17:18.000000000 +0100
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
$! Command file for building IIS6DTI
$!
$	on error then goto iis6dtiex
$	on control_y then exit
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$iis6dti_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto iis6dtiex
$	define/group lsl$iis6dti_building "in_progress"
$	open/write comfil iis6dtibat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto iis6dtiex"
$	wc	"$	if ""'","'f$logical(""lsl$iis6dti_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$a0:	define/group lsl$iis6dti_building ""in_progress"""
$	wc	"$	assign lsl$source_root:[dtmconvert.iis2dti.iis6dti] - "
$	wc	"		lsl$cmniis6dti"
$	wc	"$	sd:=$lsl$sys:sd"
$	wc	"$	set noon"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop iis6dti_dbg "With Debug ? "
$	if .not. iis6dti_dbg then goto a04
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
$	   iis6dti="t"
$	   goto a11
$!
$ a05:	   inq/nop iis6dti	"Compile IIS6DTI?	"
$	   write sys$output " "
$!
$ a11:	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkver="iis6dti"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="iis6dtix"
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
$		wc "$ 		adc iis6dti.tmp=iis6dti_cld.cld"
$		wc "$ 		set command/object=iis6dti_cld iis6dti.tmp"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv iis6dti_cld"
$		wc "$ 		if ok then delete iis6dti.tmp;*"
$		wc "$ 		if ok then purge/nolog iis6dti_cld.obj"
$
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. iis6dti then goto lnkonly
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		adc iis6dti''kpcom'=iis6dti"
$	   	wc "$ 		fort''fsw1' iis6dti"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv iis6dti"
$		wc "$ 		purge/nolog iis6dti.obj"
$		wc "$ 		purge/nolog iis6dti.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog iis6dti.lis"
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		link''linkopts'/exe=''linkver' iis6dti,-"
$	   	wc "		iis6dti_cld, -"
$!	   	wc "		iis6dti.promsg_obj, -"
$	   	wc "		lsl$library:dtilib/lib,lsllib/lib"
$!
$ nolnk:
$		wc "$ 		iis6dtiex:"
$		wc "$ 		deass/group lsl$iis6dti_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto iis6dtiex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$iis6dti_building
$	bat iis6dtibat.com
$	goto iis6dtix2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto iis6dtiex
$	deass/group lsl$iis6dti_building
$	@iis6dtibat.com
$	goto iis6dtix2
$!
$ iis6dtiex:
$	deass/group lsl$iis6dti_building
$ iis6dtix2:
$	purge iis6dtibat.com
$	purge iis6dti.map
$	delete adc.ide;*
$!
$	if ver then set verify
$!
