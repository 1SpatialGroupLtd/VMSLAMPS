$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-09-29 12:34:00.000000000 +0100
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
$! 	Copyright Laser-Scan Limited, Cambridge, England.
$!
$! 	Command file for building DTI2IIS
$!
$	ver=f$verify(0)
$	on error then goto dti2iisex
$	on control_y then exit
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$dti2iis_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto dti2iisex
$	define/group lsl$dti2iis_building "in_progress"
$	open/write comfil dti2iisbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto dti2iisex"
$	wc	"$	if ""'","'f$logical(""lsl$dti2iis_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$a0:	define/group lsl$dti2iis_building ""in_progress"""
$	wc	"$	assign here lsl$cmndti2iis"
$	wc	"$	sd:=$lsl$sys:sd"
$	wc	"$	set noon"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop dti2iis_dbg "With Debug ? "
$	if .not. dti2iis_dbg then goto a04
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
$	   inq/nop mes "Compile messages ? "
$!
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all FORTRAN sources ? "
$	   if .not. everything then goto a05
$	   dti2iis="t"
$	   goto a11
$!
$ a05:	   inq/nop dti2iis	"Compile DTI2IIS?	"
$	   write sys$output " "
$!
$ a11:	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   linkver="dti2iis"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="dti2iisx"
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
$		if .not. mes then goto nomes
$!
$		newmsg  dti2iis/dti/number=1676/runoff/par=fortran/pref=d2i__
$		@dti2iis.temp_com
$		purge dti2iismsg.*
$!
$!.............................................................................
$nomes:
$	   if .not. cld then goto fortonly
$		wc "$ 		adc dti2iis.tmp=dti2iis_cld.cld"
$		wc "$ 		set command/object=dti2iis_cld dti2iis.tmp"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dti2iis_cld"
$		wc "$ 		if ok then delete dti2iis.tmp;*"
$		wc "$ 		if ok then purge/nolog dti2iis_cld.obj"
$
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. dti2iis then goto lnkonly
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		adc dti2iis''kpcom'=dti2iis"
$	   	wc "$ 		fort''fsw1' dti2iis"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dti2iis"
$		wc "$ 		purge/nolog dti2iis.obj"
$		wc "$ 		purge/nolog dti2iis.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dti2iis.lis"
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		link''linkopts'/exe=''linkver' dti2iis,-"
$	   	wc "		dti2iis_cld, -"
$	   	wc "		dti2iis.promsg_obj, -"
$	   	wc "		lsl$library:dtilib/lib,lslshr/opt"
$!
$ nolnk:
$		wc "$ 		dti2iisex:"
$		wc "$ 		deass/group lsl$dti2iis_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto dti2iisex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$dti2iis_building
$	bat dti2iisbat.com
$	goto dti2iisx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto dti2iisex
$	deass/group lsl$dti2iis_building
$	@dti2iisbat.com
$	goto dti2iisx2
$!
$ dti2iisex:
$	deass/group lsl$dti2iis_building
$ dti2iisx2:
$	purge dti2iisbat.com
$	purge dti2iis.map
$	delete adc.ide;*
$!
$	if ver then set verify
$!
