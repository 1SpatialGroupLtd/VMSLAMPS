$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-10 15:39:26.000000000 +0100
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
$! Copyright Laser-Scan Limited, Cambridge, England.
$! Command file for building PROFILE
$! Author  :  D R Catlow
$! Created :  20 April 1988  
$! Modified:  09 May 1992
$!
$	ver=f$verify(0)
$!
$	on error then goto profileex
$	on control_y then goto profileex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$profile_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto profileex
$	define/group lsl$profile_building "in_progress"
$	open/write comfil profilebat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto profileex"
$	wc	"$	if ""'","'f$logical(""lsl$profile_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$a0:	define/group lsl$profile_building ""in_progress"""
$	wc	"$	sd:=$lsl$sys:sd"
$	wc	"$	assign lsl$source_root:[tves.service] lsl$tvessys"
$	wc	"$	set noon"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop profile_dbg "With Debug ? "
$	if .not. profile_dbg then goto a04
$	   fsw1="/debug"
$	   mldbg="/debug"
$	   inquire/nop answer "Without optimisation ? "
$	   if answer then fsw1=fsw1 + "/noopt"
$	   inquire/nop answer "Check bounds and overflow ? "
$	   if answer then fsw1=fsw1 + "/check=(bounds,overflow)"
$	   inquire/nop answer "With listings ? "
$	   if answer then fsw1=fsw1 + "/list"
$	   inquire/nop answer "Keep Fortran sources with comments ? "
$	   if answer then kpcom="/co"
$ a04:
$!
$	   inq/nop everything "Compile all Fortran sources ? "
$	   if .not. everything then goto a05
$	   profile="t"
$	   create_iff_file="t"
$	   get_window_points="t"
$	   in_sector="t"
$	   add_point="t"
$	   generate_profiles="t"
$	   open_dti_file="t"
$	   set_band="t"
$	   ctrlcast="t"
$	   set_map="t"
$	   goto a11
$!
$ a05:     inq/nop profile	     "profile,profile_init                                           ? "
$ 	   inq/nop create_iff_file   "create_iff_file,close_iff,get_iffname,create_corner_points     ? "
$ 	   inq/nop get_window_points "get_window_points                                              ? "
$ 	   inq/nop add_point         "add_point,end_feature,flush_points,new_feature                 ? "
$	   inq/nop generate_profiles "generate_profiles,radial_profiles,single_profile,point_profile ? "
$ 	   inq/nop open_dti_file     "open_dti_file,help,framed_mes,show,set_cmd                     ? "
$ 	   inq/nop set_band          "set_band,set_sector,extend_band,set_position                   ? "
$	   inq/nop ctrlcast          "ctrlcast,hadctrlc,wait,put_output,spawn,open_command_file      ? "
$	   inq/nop set_map           "set_map,readll,showerr                                         ? "  
$	   inq/nop in_sector         "in_sector,get_clutter,sample,point_value                       ? "
$!
$	   write sys$output " "
$a11:	   inquire/nop commands "Compile Command Table ?"
$          inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkver="profile"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="profilex"
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
$ fortonly:		
$	if .not. compile then goto lnkonly
$!
$ 	   if .not. profile then goto a120
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc profile''kpcom'=profile,profile_init"
$	   	wc "$ 		fort''fsw1' profile"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv profile"
$		wc "$ 		purge/nolog profile.obj"
$		if fsw1.eqs."" then -
			wc "$		delete profile.for;*"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog profile.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog profile.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a120:	   if .not. create_iff_file then goto a130
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc create_iff_file''kpcom'=create_iff_file,close_iff,get_iffname,create_corner_points"
$	   	wc "$ 		fort''fsw1' create_iff_file"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv create_iff_file"
$		wc "$ 		purge/nolog create_iff_file.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog create_iff_file.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete create_iff_file.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog create_iff_file.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a130:	   if .not. get_window_points then goto a140
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc get_window_points''kpcom'=get_window_points"
$	   	wc "$ 		fort''fsw1' get_window_points"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv get_window_points"
$		wc "$ 		purge/nolog get_window_points.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog get_window_points.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete get_window_points.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
		      f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog get_window_points.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a140:	   if .not. add_point then goto a150
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc add_point''kpcom'=add_point,end_feature,flush_points,new_feature"
$	   	wc "$ 		fort''fsw1' add_point"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv add_point"
$		wc "$ 		purge/nolog add_point.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog add_point.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete add_point.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog add_point.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a150:	   if .not. generate_profiles then goto a160
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc generate_profiles''kpcom'=generate_profiles,single_profile,radial_profiles,point_profile"
$	   	wc "$ 		fort''fsw1' generate_profiles"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv generate_profiles"
$		wc "$ 		purge/nolog generate_profiles.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog generate_profiles.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete generate_profiles.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog generate_profiles.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a160:	   if .not. open_dti_file then goto a170
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc open_dti_file''kpcom'=open_dti_file,help,framed_mes,show,set_cmd"
$	   	wc "$ 		fort''fsw1' open_dti_file"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv open_dti_file"
$		wc "$ 		purge/nolog open_dti_file.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog open_dti_file.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete open_dti_file.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog open_dti_file.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a170:	   if .not. set_band then goto a180
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc set_band''kpcom'=set_band,set_sector,extend_band,set_position"
$	   	wc "$ 		fort''fsw1' set_band"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv set_band"
$		wc "$ 		purge/nolog set_band.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog set_band.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete set_band.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog set_band.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a180:	   
$!
$ a190:	   if .not. ctrlcast then goto a200
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc ctrlcast''kpcom'=ctrlcast,hadctrlc,wait,put_output,spawn,open_command_file"
$	   	wc "$ 		fort''fsw1' ctrlcast"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv ctrlcast"
$		wc "$ 		purge/nolog ctrlcast.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog ctrlcast.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete ctrlcast.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog ctrlcast.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a200:	   if .not. set_map then goto a210
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc set_map''kpcom'=set_map,readll,showerr"
$	   	wc "$ 		fort''fsw1' set_map"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv set_map"
$		wc "$ 		purge/nolog set_map.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog set_map.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete set_map.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog set_map.lis"
$		wc "$ 		delete adc.ide;*"
$
$ a210:	   if .not. in_sector then goto a220
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc in_sector''kpcom'=in_sector,get_clutter,sample,point_value"
$	   	wc "$ 		fort''fsw1' in_sector"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv in_sector"
$		wc "$ 		purge/nolog in_sector.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog in_sector.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete in_sector.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog in_sector.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a220:	   
$!
$ lnkonly:
$       if .not. commands then goto dolnk
$	        wc "$ macro profile_commands+lsl$library:lslmaclib/lib "
$	        wc "$ purge/nolog profile_commands.obj"
$ dolnk:
$ 	if .not. lnkit then goto nolnk
$		wc "$ run lsl$exe:genver"
$		wc "$ adc version=version"
$		wc "$ fort version"
$		wc "$ pvv version"
$		wc "$ pur version.*"
$!
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$		link''linkopts'/exe=''linkver' profile, -"
$               wc "		profile_commands,create_iff_file,-"
$		wc "		get_window_points,add_point,-"
$	        wc "		generate_profiles,open_dti_file,-"
$               wc "		set_band,in_sector,-"
$               wc "		ctrlcast,set_map,version,-"
$		wc "		lsl$tvessys:tves_service/lib,-"
$		wc "		lsl$library:tablib/lib,-
$	   	wc "		lsl$library:dtilib/lib,-"
$               wc "		lsl$library:iffshr.opt/opt,-
$               wc "		lsl$library:lslshr.opt/opt
$!
$ nolnk:
$		wc "$ 		profileex:"
$		wc "$ 		deass/group lsl$profile_building"
$               wc "$ 		purge/nolog *.map,*.com
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto profileex
$	on control_y then goto profileex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$profile_building
$	bat profilebat.com
$	goto profilex2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto profileex
$	deass/group lsl$profile_building
$	@profilebat.com
$	goto profilex2
$ profileex:
$	deass/group lsl$profile_building
$ profilex2:
$	purge *.for
$	delete adc.ide;*
$	if ver then set verify
$!
