$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-11-30 11:37:50.000000000 +0000
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
$!	Created					 TJH 21-Aug-1986
$!	Change message facility number		 RJH 29-Jul-1987
$!	Use IFFSHR and LSLSHR, use NEWMSG	 CCB  2-Aug-1989
$!	Used for I2DLG				 FJB 10-Aug-1989
$!	Mod 1435 for new frtshr			  JB 30-Nov-1994
$!
$! Command file for building I2DLG
$!
$	on error then goto i2dlgex
$	on control_y then exit
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$i2dlg_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto i2dlgex
$	define/group lsl$i2dlg_building "in_progress"
$	open/write comfil i2dlgbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto i2dlgex"
$	wc	"$	if ""'","'f$logical(""lsl$i2dlg_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$a0:	define/group lsl$i2dlg_building ""in_progress"""
$	wc	"$	assign lsl$source_root:[convert.i2dlg.src] lsl$cmni2dlg"
$	wc	"$	set noon"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop i2dlg_dbg "With Debug ? "
$	if .not. i2dlg_dbg then goto a04
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
$	   i2dlg="t"
$	   get_command="t"
$	   open_files="t"
$	   open_iff="t"
$	   open_frt="t"
$	   open_dlg="t"
$	   iff_scan="t"
$	   jnctct="t"
$	   jnctex="t"
$	   cf="t"
$	   swap="t"
$	   iff_header="t"
$	   iff_nodes="t"
$	   iff_areas="t"
$	   iff_lines="t"
$	   outrec="t"
$	   degree="t"
$	   close_files="t"
$	   goto a11
$!
$ a05:     inq/nop i2dlg	"cOMPILE i2dlg ? 	"
$	   inq/nop get_command	"cOMPILE get_command? 	"
$	   inq/nop open_files	"cOMPILE open_files?    "
$	   inq/nop open_iff	"cOMPILE open_iff?      "
$	   inq/nop open_frt	"cOMPILE open_frt?      "
$	   inq/nop open_dlg	"cOMPILE open_dlg?	"
$	   inq/nop iff_header	"cOMPILE iff_header? 	"
$	   inq/nop iff_scan	"cOMPILE iff_scan? 	"
$	   inq/nop jnctct	"cOMPILE jnctct? 	"
$	   inq/nop jnctex	"cOMPILE jnctex? 	"
$	   inq/nop cf		"cOMPILE cf?	 	"
$	   inq/nop swap		"cOMPILE swap?	 	"
$	   inq/nop iff_nodes	"cOMPILE iff_nodes? 	"
$	   inq/nop iff_areas	"cOMPILE iff_areas? 	"
$	   inq/nop iff_lines	"cOMPILE iff_lines? 	"
$	   inq/nop outrec	"cOMPILE outrec?	"
$	   inq/nop degree	"cOMPILE degree?	"
$	   inq/nop close_files	"cOMPILE close_files?	"
$	   write sys$output " "
$ a11:	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   linkver="i2dlg"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="i2dlgx"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$	   
$ notkb:
$!
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		set verify"
$ 	 if .not.mes then goto nomes
$		wc "$newmsg i2dlg/number=1621/runoff/hl=2"
$		wc "$ @i2dlg.temp_com"
$ nomes: if .not. cld then goto fortonly
$		wc "$ 		adc i2dlg.tmp=i2dlg_cld.cld"
$		wc "$ 		set command/object=i2dlg_cld i2dlg.tmp"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv i2dlg_cld"
$		wc "$ 		if ok then delete i2dlg.tmp;*"
$		wc "$ 		if ok then purge/nolog i2dlg_cld.obj"
$	
$ fortonly:		
$	if .not. compile then goto lnkonly
$!
$ a100:	   if .not. get_command then goto a110
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' get_command.f"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if .not. ok then goto i2dlgex"
$		wc "$ 		purge/nolog get_command.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog get_command.lis"
$!
$ a110:	   if .not. open_files then goto a120
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' open_files.f"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if .not. ok then goto i2dlgex"
$		wc "$ 		purge/nolog open_files.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog open_files.lis"
$!
$ a120:	   if .not. open_iff then goto a125
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' open_iff.f"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if .not. ok then goto i2dlgex"
$		wc "$ 		purge/nolog open_iff.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog open_iff.lis"
$!
$!
$ a125:	   if .not. open_frt then goto a130
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' open_frt.f"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if .not. ok then goto i2dlgex"
$		wc "$ 		purge/nolog open_frt.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog open_frt.lis"
$!
$ a130:	   if .not. i2dlg  then goto a140
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' i2dlg.f"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if .not. ok then goto i2dlgex"
$		wc "$ 		purge/nolog i2dlg.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog i2dlg.lis"
$!
$ a140:	   if .not. iff_header  then goto a150
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' iff_header.f"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if .not. ok then goto i2dlgex"
$		wc "$ 		purge/nolog iff_header.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog iff_header.lis"
$!
$ a150:	if .not. open_dlg  then goto a180
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' open_dlg.f"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if .not. ok then goto i2dlgex"
$		wc "$ 		purge/nolog open_dlg.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog open_dlg.lis"
$!
$ a180:	   if .not. outrec  then goto a185
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' outrec.f"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if .not. ok then goto i2dlgex"
$		wc "$ 		purge/nolog outrec.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog outrec.lis"
$!
$ a185:	   if .not. degree  then goto a190
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' degree.f"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if .not. ok then goto i2dlgex"
$		wc "$ 		purge/nolog degree.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog degree.lis"
$!
$ a190:	   if .not. iff_scan  then goto a195
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' iff_scan.f"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if .not. ok then goto i2dlgex"
$		wc "$ 		purge/nolog iff_scan.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog iff_scan.lis"
$!
$ a195:	   if .not. jnctct  then goto a196
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' jnctct.f"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if .not. ok then goto i2dlgex"
$		wc "$ 		purge/nolog jnctct.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog jnctct.lis"
$!
$ a196:	   if .not. jnctex  then goto a197
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' jnctex.f"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if .not. ok then goto i2dlgex"
$		wc "$ 		purge/nolog jnctex.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog jnctex.lis"
$!
$ a197:	   if .not. cf  then goto a198
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' cf.f"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if .not. ok then goto i2dlgex"
$		wc "$ 		purge/nolog cf.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog cf.lis"
$!
$ a198:	   if .not. swap  then goto a200
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' swap.f"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if .not. ok then goto i2dlgex"
$		wc "$ 		purge/nolog swap.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog swap.lis"
$!
$ a200:	   if .not. iff_nodes  then goto a210
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' iff_nodes.f"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if .not. ok then goto i2dlgex"
$		wc "$ 		purge/nolog iff_nodes.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog iff_nodes.lis"
$!
$ a210:	   if .not. iff_areas  then goto a220
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' iff_areas.f"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if .not. ok then goto i2dlgex"
$		wc "$ 		purge/nolog iff_areas.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog iff_areas.lis"
$!
$ a220:	   if .not. iff_lines  then goto a230
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' iff_lines.f"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if .not. ok then goto i2dlgex"
$		wc "$ 		purge/nolog iff_lines.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog iff_lines.lis"
$!
$ a230:	   if .not. close_files then goto lnkonly
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		fort''fsw1' close_files.f"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if .not. ok then goto i2dlgex"
$		wc "$ 		purge/nolog close_files.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog close_files.lis"
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		link''linkopts'/exe=''linkver' i2dlg, -"
$	   	wc "		i2dlg_cld,get_command, -"
$		wc "		open_files,open_iff,open_frt,open_dlg, -"
$	   	wc "		iff_header,iff_scan,jnctct,jnctex, -"
$	   	wc "		cf, swap, -"
$		wc "		iff_nodes,iff_areas,iff_lines, -"
$		wc "		outrec,degree,close_files, -"
$		wc "		i2dlg.promsg_obj, -"
$		wc "		lsl$library:frtshr/opt, -"
$	   	wc "		lsl$library:iffshr/opt,lslshr/opt"
$!
$ nolnk:
$		wc "$ 		i2dlgex:"
$		wc "$ 		deass/group lsl$i2dlg_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto i2dlgex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$i2dlg_building
$	bat i2dlgbat.com
$	goto i2dlgx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto i2dlgex
$	deass/group lsl$i2dlg_building
$	@i2dlgbat.com
$	goto i2dlgx2
$!
$ i2dlgex:
$	deass/group lsl$i2dlg_building
$!
$ i2dlgx2:
$	if ver then set verify
$!
