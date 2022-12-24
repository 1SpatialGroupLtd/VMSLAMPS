$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-11-29 15:51:10.000000000 +0000
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
$!	Copyright (C) Laser-Scan Ltd., Cambridge, England.
$!
$!	Created						RJH 16-Sep-1994
$!
$!	Mod 1435 new frtshr rebuild			 JB 29-Nov-1994
$!
$!	CONVERT I2MAPDATA Utility - Command file to build the program
$!
$	on error then goto i2mapdataex
$	on control_y then exit
$	define/nolog cmn lsl$source_root:[convert.i2mapdata.src]
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$i2mapdata_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$ a0:	on control_y then goto i2mapdataex
$	define/group lsl$i2mapdata_building "in_progress"
$	open/write comfil i2mapdatabat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$		wc "$!	'f$verify(0)"
$		wc "$	on control_y then goto i2mapdataex"
$		wc "$	on error then goto i2mapdataex"
$		wc "$	if ""'","'f$logical(""lsl$i2mapdata_building"")'"" -"
$		wc "		 .nes. ""in_progress"" then goto a0"
$		wc "$	write sys$output ""Someone else is building"""
$		wc "$	exit"
$		wc "$!"
$		wc "$a0:	define/group lsl$i2mapdata_building ""in_progress"""
$!!!		wc "$	set noon"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop i2mapdata_dbg "With debug ? "
$	if .not. i2mapdata_dbg then goto a04
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
$!
$ a04:	   inq/nop cld "Compile CLD modules ? "
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all fortran sources ? "
$	   if .not. everything then goto a05
$	   i2mapdata		= "t"
$	   control_init		= "t"
$	   obey			= "t"
$	   obey_qual		= "t"
$	   obey_erret		= "t"
$	   rdfrt		= "t"
$	   rdpar		= "t"
$	   rdlin		= "t"
$	   get_strpar		= "t"
$	   check_md_code	= "t"
$	   check_ac_code	= "t"
$	   check_fc		= "t"
$	   check_flag		= "t"
$	   check_coord		= "t"
$	   keep_coord		= "t"
$	   find_fc		= "t"
$	   set_ac_details	= "t"
$	   get_ac_code		= "t"
$	   get_ac_name		= "t"
$	   open_iff		= "t"
$	   open_md		= "t"
$	   close_iff		= "t"
$	   close_md		= "t"
$	   process		= "t"
$	   start_feature	= "t"
$	   read_points		= "t"
$	   write_points		= "t"
$	   rotation_to_point	= "t"
$	   write_md_head	= "t"
$	   write_md_seg		= "t"
$	   write_md_code	= "t"
$	   write_md_coord	= "t"
$!
$	   goto a11
$!
$ a05:	   inq/nop i2mapdata		"Compile I2MAPDATA ? "
$	   inq/nop control_init		"Compile CONTROL_INIT ? "
$	   inq/nop obey			"Compile OBEY ? "
$	   inq/nop obey_qual		"Compile OBEY_QUAL ? "
$	   inq/nop obey_erret		"Compile OBEY_ERRET ? "
$	   inq/nop rdfrt		"Compile RDFRT ? "
$	   inq/nop rdpar		"Compile RDPAR ? "
$	   inq/nop rdlin		"Compile RDLIN ? "
$	   inq/nop get_strpar		"Compile GET_STRPAR ? "
$	   inq/nop check_md_code	"Compile CHECK_MD_CODE ? "
$	   inq/nop check_ac_code	"Compile CHECK_AC_CODE ? "
$	   inq/nop check_fc		"Compile CHECK_FC ? "
$	   inq/nop check_flag		"Compile CHECK_FLAG ? "
$	   inq/nop check_coord		"Compile CHECK_COORD ? "
$	   inq/nop keep_coord		"Compile KEEP_COORD ? "
$	   inq/nop find_fc		"Compile FIND_FC ? "
$	   inq/nop set_ac_details	"Compile SET_AC_DETAILS ? "
$	   inq/nop get_ac_code		"Compile GET_AC_CODE ? "
$	   inq/nop get_ac_name		"Compile GET_AC_NAME ? "
$	   inq/nop open_iff		"Compile OPEN_IFF ? "
$	   inq/nop open_md		"Compile OPEN_MD ? "
$	   inq/nop close_iff		"Compile CLOSE_IFF ? "
$	   inq/nop close_md		"Compile CLOSE_MD ? "
$	   inq/nop process		"Compile PROCESS ? "
$	   inq/nop start_feature	"Compile START_FEATURE ? "
$	   inq/nop read_points		"Compile READ_POINTS ? "
$	   inq/nop write_points		"Compile WRITE_POINTS ? "
$	   inq/nop rotation_to_point	"Compile ROTATION_TO_POINT ? "
$	   inq/nop write_md_head	"Compile WRITE_MD_HEAD ? "
$	   inq/nop write_md_seg		"Compile WRITE_MD_SEG ? "
$	   inq/nop write_md_code	"Compile WRITE_MD_CODE ? "
$	   inq/nop write_md_coord	"Compile WRITE_MD_COORD ? "
$	   write sys$output " "
$!
$ a11:	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   linkver="i2mapdata"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="i2mapdatax"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!
$ notkb:   if .not. mes then goto nomess
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$	newmsg/number=1501/prefix=I2MD__/runoff/hl=2 i2mapdata"
$		wc "$	@i2mapdata.temp_com"
$		wc "$	purge i2mapdatamsg.rno"
$!
$ nomess:  if .not. cld then goto fortonly
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc i2mapdata.tmp=i2mapdata_cld.cld"
$		wc "$ 	set command/object=i2mapdata_cld i2mapdata.tmp"
$		wc "$ 	pvv i2mapdata_cld"
$		wc "$ 	purge/nolog i2mapdata_cld.obj"
$		wc "$ 	delete adc.ide;*,i2mapdata.tmp;*"
$!
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. i2mapdata then goto a1010
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' i2mapdata.f"
$		wc "$ 	purge/nolog i2mapdata.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog i2mapdata.lis"
$!
$ a1010:   if .not. control_init then goto a1100
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' control_init.f"
$		wc "$ 	purge/nolog control_init.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog control_init.lis"
$!
$ a1100:   if .not. obey then goto a1110
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' obey.f"
$		wc "$ 	purge/nolog obey.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog obey.lis"
$!
$ a1110:   if .not. obey_qual then goto a1120
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' obey_qual.f"
$		wc "$ 	purge/nolog obey_qual.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog obey_qual.lis"
$!
$ a1120:   if .not. obey_erret then goto a1200
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' obey_erret.f"
$		wc "$ 	purge/nolog obey_erret.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog obey_erret.lis"
$!
$ a1200:   if .not. rdfrt then goto a1300
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' rdfrt.f"
$		wc "$ 	purge/nolog rdfrt.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog rdfrt.lis"
$!
$ a1300:   if .not. rdpar then goto a1310
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' rdpar.f"
$		wc "$ 	purge/nolog rdpar.obj"
$		wc "$ 	macro''mldbg' parcmd"
$		wc "$ 	append parcmd.obj rdpar.obj"
$		wc "$ 	delete	parcmd.obj;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog rdpar.lis"
$!
$ a1310:   if .not. rdlin then goto a1320
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' rdlin.f"
$		wc "$ 	purge/nolog rdlin.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog rdlin.lis"
$!
$ a1320:   if .not. get_strpar then goto a1330
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' get_strpar.f"
$		wc "$ 	purge/nolog get_strpar.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog get_strpar.lis"
$!
$ a1330:   if .not. check_md_code then goto a1340
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' check_md_code.f"
$		wc "$ 	purge/nolog check_md_code.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog check_md_code.lis"
$!
$ a1340:   if .not. check_ac_code then goto a1350
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' check_ac_code.f"
$		wc "$ 	purge/nolog check_ac_code.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog check_ac_code.lis"
$!
$ a1350:   if .not. check_fc then goto a1351
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' check_fc.f"
$		wc "$ 	purge/nolog check_fc.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog check_fc.lis"
$!
$ a1351:   if .not. check_flag then goto a1352
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' check_flag.f"
$		wc "$ 	purge/nolog check_flag.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog check_flag.lis"
$!
$ a1352:   if .not. check_coord then goto a1353
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' check_coord.f"
$		wc "$ 	purge/nolog check_coord.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog check_coord.lis"
$!
$ a1353:   if .not. keep_coord then goto a1360
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' keep_coord.f"
$		wc "$ 	purge/nolog keep_coord.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog keep_coord.lis"
$!
$ a1360:   if .not. find_fc then goto a1370
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' find_fc.f"
$		wc "$ 	purge/nolog find_fc.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog find_fc.lis"
$!
$ a1370:   if .not. set_ac_details then goto a1380
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' set_ac_details.f"
$		wc "$ 	purge/nolog set_ac_details.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog set_ac_details.lis"
$!
$ a1380:   if .not. get_ac_code then goto a1390
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' get_ac_code.f"
$		wc "$ 	purge/nolog get_ac_code.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog get_ac_code.lis"
$!
$ a1390:   if .not. get_ac_name then goto a1400
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' get_ac_name.f"
$		wc "$ 	purge/nolog get_ac_name.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog get_ac_name.lis"
$!
$ a1400:   if .not. open_iff then goto a1410
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' open_iff.f"
$		wc "$ 	purge/nolog open_iff.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog open_iff.lis"
$!
$ a1410:   if .not. open_md then goto a1420
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' open_md.f"
$		wc "$ 	purge/nolog open_md.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog open_md.lis"
$!
$ a1420:   if .not. close_iff then goto a1430
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' close_iff.f"
$		wc "$ 	purge/nolog close_iff.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog close_iff.lis"
$!
$ a1430:   if .not. close_md then goto a1500
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' close_md.f"
$		wc "$ 	purge/nolog close_md.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog close_md.lis"
$!
$ a1500:   if .not. process then goto a1501
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' process.f"
$		wc "$ 	purge/nolog process.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog process.lis"
$ a1501:   if .not. start_feature then goto a1502
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' start_feature.f"
$		wc "$ 	purge/nolog start_feature.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog start_feature.lis"
$ a1502:   if .not. read_points then goto a1503
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' read_points.f"
$		wc "$ 	purge/nolog read_points.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog read_points.lis"
$!
$ a1503:   if .not. write_points then goto a1504
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' write_points.f"
$		wc "$ 	purge/nolog write_points.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog write_points.lis"
$!
$ a1504:   if .not. rotation_to_point then goto a1510
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' rotation_to_point.f"
$		wc "$ 	purge/nolog rotation_to_point.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog rotation_to_point.lis"
$!
$ a1510:   if .not. write_md_head then goto a1520
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' write_md_head.f"
$		wc "$ 	purge/nolog write_md_head.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog write_md_head.lis"
$!
$ a1520:   if .not. write_md_seg then goto a1530
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' write_md_seg.f"
$		wc "$ 	purge/nolog write_md_seg.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog write_md_seg.lis"
$!
$ a1530:   if .not. write_md_code then goto a1540
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' write_md_code.f"
$		wc "$ 	purge/nolog write_md_code.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog write_md_code.lis"
$!
$ a1540:   if .not. write_md_coord then goto a1600
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	fort''fsw1' write_md_coord.f"
$		wc "$ 	purge/nolog write_md_coord.obj"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog write_md_coord.lis"
$!
$ a1600:
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$!	'f$verify(0)"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$ 	link''linkopts'/exe=''linkver' i2mapdata, -"
$	   	wc "		i2mapdata_cld, -"
$		wc "		control_init, -"
$		wc "		obey, -"
$		wc "		obey_qual, -"
$		wc "		obey_erret, -"
$		wc "		rdfrt, -"
$		wc "		rdpar, -"
$		wc "		rdlin, -"
$		wc "		get_strpar, -"
$		wc "		check_md_code, -"
$		wc "		check_ac_code, -"
$		wc "		check_fc, -"
$		wc "		check_flag, -"
$		wc "		check_coord, -"
$		wc "		keep_coord, -"
$		wc "		find_fc, -"
$		wc "		set_ac_details, -"
$		wc "		get_ac_code, -"
$		wc "		get_ac_name, -"
$		wc "		open_iff, -"
$		wc "		open_md, -"
$		wc "		close_iff, -"
$		wc "		close_md, -"
$		wc "		process, -"
$		wc "		start_feature, -"
$		wc "		read_points, -"
$		wc "		write_points, -"
$		wc "		rotation_to_point, -"
$		wc "		write_md_head, -"
$		wc "		write_md_seg, -"
$		wc "		write_md_code, -"
$		wc "		write_md_coord, -"
$		wc "		i2mapdata.promsg_obj, -"
$		wc "		lsl$library:frtshr/opt,-"
$	   	wc "		lsl$library:iffshr/opt,lslshr/opt"
$!
$ nolnk:
$		wc "$!"
$		wc "$ i2mapdataex:				! 'f$verify(0)"
$		wc "$	deass/group lsl$i2mapdata_building"
$		wc "$	exit"
$!
$ filclo:
$!!!	set noverify
$	on error then goto i2mapdataex
$	on control_y then goto i2mapdataex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$i2mapdata_building
$	bat i2mapdatabat.com
$	goto i2mapdatax2
$!
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto i2mapdataex
$	deass/group lsl$i2mapdata_building
$	@i2mapdatabat.com
$	goto i2mapdatax2
$!
$ i2mapdataex:
$	deass/group lsl$i2mapdata_building
$!
$ i2mapdatax2:
$	if ver then set verify
$	pur i2mapdatabat.com
$	pur *.obj
$	exit
$!
