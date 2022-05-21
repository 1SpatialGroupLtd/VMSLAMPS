$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-11-30 12:32:30.000000000 +0000
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
$! Command file to build CONVERT utility I2CEDD
$!
$! Copyright Laser-Scan Limited, Cambridge, England.
$!
$!	Created						TJH 12-Jan-1987
$!
$!	Mod 1435 Use new frtshr				 JB 30-Nov-1994
$!
$	ver=f$verify(0)
$!
$	on error then goto i2ceddex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$i2cedd_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto i2ceddex
$	define/group lsl$i2cedd_building "in_progress"
$	open/write comfil i2ceddbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto i2ceddex"
$	wc "$	if ""'","'f$logical(""lsl$i2cedd_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$i2cedd_building ""in_progress"""
$	wc "$	assign here lsl$i2cedd"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	i2cedd_dbg=""
$	cldgen=""
$	mes=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop i2cedd_dbg "With Debug ? "
$	if .not. i2cedd_dbg then goto a04
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
$!
$	i2cedd = "t"
$	i2cedd_init = "t"
$	getcomlin = "t"
$	open_files = "t"
$	close_files = "t"
$	read_iff_header = "t"
$	start_layer0_dsi = "t"
$	output_iff_header_dsi = "t"
$	finish_layer0_dsi = "t"
$	process_acc_area = "t"
$	process_reg_point = "t"
$	process_enclosing_feature = "t"
$	process_feature_attr = "t"
$	find_z_range = "t"
$	process_feature_coord = "t"
$	read_coord_entry = "t"
$	start_seg_subrecord = "t"
$	write_coord_to_seg = "t"
$	find_total_points = "t"
$	process_date_ac = "t"
$	process_dmsh = "t"
$       convert_to_dmsh = "t"
$	output_txt_record = "t"
$	cvtdate = "t"
$	append_to_block = "t"
$	insert_in_block = "t"
$	start_output_block = "t"
$	finish_block = "t"
$	write_block = "t"
$!
$	goto a11
$ a05:	   
$	ws " " 
$	ws ".............................FORTRAN sources"
$	inq/nop i2cedd "i2cedd ? "
$	inq/nop i2cedd_init "i2cedd_init ? "
$	inq/nop getcomlin "getcomlin ? "
$	inq/nop open_files "open_files ? "
$	inq/nop close_files "close_files ? "
$	inq/nop read_iff_header "read_iff_header ? "
$	inq/nop start_layer0_dsi "start_layer0_dsi ? "
$	inq/nop output_iff_header_dsi "output_iff_header_dsi ? "
$	inq/nop finish_layer0_dsi "finish_layer0_dsi ? "
$	inq/nop process_acc_area "process_acc_area ? "
$	inq/nop process_reg_point "process_reg_point ? "
$	inq/nop process_enclosing_feature "process_enclosing_feature ? "
$	inq/nop process_feature_attr "process_feature_attr ? "
$	inq/nop find_z_range "find_z_range ? "
$	inq/nop process_date_ac "process_date_ac ? "
$	inq/nop process_dmsh "process_dmsh ? "
$	inq/nop process_feature_coord "process_feature_coord ? "
$	inq/nop read_coord_entry "read_coord_entry  ? "
$	inq/nop start_seg_subrecord "start_seg_subrecord ? "
$	inq/nop write_coord_to_seg "write_coord_to_seg ? "
$	inq/nop find_total_points "find_total_points ? "
$	inq/nop convert_to_dmsh "convert_to_dmsh ? "
$	inq/nop output_txt_record "output_txt_record ? "
$	inq/nop cvtdate "cvtdate ? "
$	inq/nop append_to_block "append_to_block ? "
$	inq/nop insert_in_block "insert_in_block ? "
$	inq/nop start_output_block "start_output_block ? "
$	inq/nop finish_block "finish_block ? "
$	inq/nop write_block "write_block ? "
$!
$ a11:
$	   inq/nop cldgen	"Generate command definitions ? "
$!
$	   inq/nop mes "Generate message definitions ? "
$!
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkver="i2cedd"
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
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 	set verify"
$ 		if .not.mes then goto cmponly
$		wc "$	newmsg/number=1611/prefix=i2cedd__ -"
$		wc "	/parameter=for/runoff i2cedd.mes"
$		wc "$ @i2cedd.temp_com"
$!	
$ cmponly:		
$	if .not. cldgen then goto for2
$		wc "$	adc i2cedd.tmp = i2cedd_cld.cld"
$		wc "$	set command/object =i2cedd_cld i2cedd.tmp"
$		wc "$	pvv i2cedd_cld"
$		wc "$	delete i2cedd.tmp;*"
$		wc "$	delete adc.ide;*"
$		wc "$	purge i2cedd_cld.obj"
$		wc "$	set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$ for2: if .not. compile then goto lnkonly
$!	
$	if i2cedd then call compiler i2cedd
$	if i2cedd_init then call compiler i2cedd_init
$	if getcomlin then call compiler getcomlin
$	if open_files then call compiler open_files
$	if close_files then call compiler close_files
$	if read_iff_header then call compiler read_iff_header
$	if start_layer0_dsi then call compiler start_layer0_dsi
$	if output_iff_header_dsi then -
				call compiler output_iff_header_dsi
$	if finish_layer0_dsi then call compiler finish_layer0_dsi
$	if process_acc_area then call compiler process_acc_area
$	if process_reg_point then call compiler process_reg_point
$	if process_enclosing_feature then -
				call compiler process_enclosing_feature
$	if process_feature_attr then call compiler process_feature_attr
$	if find_z_range then call compiler find_z_range
$	if process_feature_coord then -
				call compiler process_feature_coord
$	if read_coord_entry then call compiler read_coord_entry 
$	if start_seg_subrecord then call compiler start_seg_subrecord
$	if write_coord_to_seg then call compiler write_coord_to_seg
$	if find_total_points then call compiler find_total_points
$	if process_date_ac then call compiler process_date_ac
$	if process_dmsh then call compiler process_dmsh
$	if convert_to_dmsh then call compiler convert_to_dmsh
$	if output_txt_record then call compiler output_txt_record
$	if cvtdate then call compiler cvtdate
$	if append_to_block then call compiler append_to_block
$	if insert_in_block then call compiler insert_in_block
$	if start_output_block then call compiler start_output_block
$	if finish_block then call compiler finish_block
$	if write_block then call compiler write_block
$!
$	   goto lnkonly
$!----------------------------------------------------------------------
$ compiler: subroutine 
$!----------------------------------------------------------------------
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
		wc "$ 	if ok then purge/nolog ''p1'.lis"
$		wc "$	if .not.ok then emsg=emsg+"" ''p1'"""
$		wc "$ 	delete adc.ide;*"
$		wc "$	set noverify"
$	return
$ endsubroutine
$!----------------------------------------------------------------------
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
$	wc "$ 	link''linkopts'/exe=''linkver' i2cedd/opt, -"
$	wc "		i2cedd.promsg_obj, -"
$	WC "		lsl$library:frtshr/opt,-
$	WC "		lsl$library:lslshr/opt, lsl$library:iffshr/opt"
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	i2ceddex:"
$		wc "$ 	deass/group lsl$i2cedd_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto i2ceddex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$i2cedd_building
$	submit/notify/noprint/keep/restart i2ceddbat.com
$	goto i2ceddx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto i2ceddex
$	deass/group lsl$i2cedd_building
$	@i2ceddbat.com
$	goto i2ceddx2
$!
$ i2ceddex:
$	deass/group lsl$i2cedd_building
$!
$ i2ceddx2:
$	if ver then set verify
$!
