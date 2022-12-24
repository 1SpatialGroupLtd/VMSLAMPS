$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-09-27 12:17:12.000000000 +0100
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
$! Command file for building DTIFROMTEXT
$!
$	on error then goto dtiex
$	on control_y then exit
$	define/nolog cmn here
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$dti_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto dtiex
$	define/group lsl$dti_building "in_progress"
$	open/write comfil dtifromtextbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto dtiex"
$	wc	"$	if ""'","'f$logical(""lsl$dti_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$a0:	define/group lsl$dti_building ""in_progress"""
$	wc	"$	set noon"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop dti_dbg "With debug ? "
$	if .not. dti_dbg then goto a04
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
$	   dtifromtext	  = "t"
$	   obey		  = "t"
$	   convert	  = "t"
$	   convert_mobile = "t"
$	   convertr	  = "t"
$!
$	   goto a11
$!
$ a05:	   inq/nop dtifromtext	  "Compile DTIFROMTEXT ?	"
$	   inq/nop obey		  "Compile OBEY ? 		"
$	   inq/nop convert	  "Compile CONVERT ?		"
$	   inq/nop convertr	  "Compile CONVERTR ?		"
$	   inq/nop convert_mobile "Compile CONVERT_MOBILE ? 	"
$!
$	   write sys$output " "
$ a11:	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   linkver="dtifromtext"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="dtifromtextx"
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
$		wc "$	newmsg/dti/number=1645/prefix=dtift__/par=fortran/runoff dtifromtext.mes"
$		wc "$	@dtifromtext.temp_com"
$		wc "$	purge dtifromtextmsg.rno"
$!
$ nomess:	if .not. cld then goto fortonly
$		wc "$ 		adc dtifromtext.tmp=dtifromtext_cld.cld"
$		wc "$ 		set command/object=dtifromtext_cld dtifromtext.tmp"
$	      	wc "$ 		ok=$status"	
$!		wc "$ 		if ok then pvv dtifromtext_cld"
$!		wc "$ 		if ok then delete adc.ide;*"
$		wc "$ 		if ok then delete dtifromtext.tmp;*"
$		wc "$ 		if ok then purge/nolog dtifromtext_cld.obj"
$
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. dtifromtext then goto a100
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' dtifromtext.f"
$		wc "$ 		purge/nolog dtifromtext.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dtifromtext.lis"
$!
$ a100:	   if .not. obey then goto a102
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' obey.f"
$		wc "$ 		purge/nolog obey.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog obey.lis"
$!
$ a102:	   if .not. convert then goto a103
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' convert.f"
$		wc "$ 		purge/nolog convert.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog convert.lis"
$!
$ a103:	   if .not. convert_mobile then goto a104
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' convert_mobile.f"
$		wc "$ 		purge/nolog convert_mobile.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog convert_mobile.lis"
$!
$ a104:	   if .not. convertr then goto lnkonly
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	   	wc "$ 		fort''fsw1' convertr.f"
$		wc "$ 		purge/nolog convertr.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog convertr.lis"
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		link''linkopts'/exe=''linkver' dtifromtext, -"
$	   	wc "		dtifromtext_cld, -"
$		wc "		obey, -"
$		wc "		convert, -"
$		wc "		convertr, -"
$		wc "		convert_mobile, -"
$		wc "		dtifromtext.promsg_obj, -"
$		wc "		lsl$library:dtilib/lib,-"
$	   	wc "		lsl$library:iffshr/opt,lslshr/opt"
$ nolnk:
$		wc "$ 		dtiex:"
$		wc "$ 		deass/group lsl$dti_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto dtiex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$dti_building
$	bat dtifromtextbat.com
$	goto dtix2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto dtiex
$	deass/group lsl$dti_building
$	@dtifromtextbat.com
$	goto dtix2
$ dtiex:
$	deass/group lsl$dti_building
$ dtix2:
$	if ver then set verify
$	pur dtifromtextbat.com
$	pur *.obj
$!
