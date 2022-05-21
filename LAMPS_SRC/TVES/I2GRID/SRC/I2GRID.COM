$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-11-16 16:28:38.000000000 +0000
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
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$!	Command file for creating and submitting a batch command file
$!	for building I2GRID
$!
$!	mod1427 for new frtshr
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	ver = f$verify(0)
$	ws = "write sys$output"
$	wc = "write comfil"
$	on error then goto abort2
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! do not build if someone else is already building
$	disk = f$logical("sys$disk")
$	my_name = f$getjpi("","USERNAME")
$	buildingname = "lsl$i2grid_building"
$	buildingwarning = "''f$logical(buildingname)'"
$	on control_y then goto abort2
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! open file to receive building commands
$	comfile = "i2gridbat.com"
$	if f$search(comfile).nes."" then delete/nolog 'comfile';*
$	open/write comfil i2gridbat.com
$	on control_y then goto abort1
$ 	on error then goto xx260
$!
$! check for build already in progress from within the build command file
$	wc "$ 	set noverify"
$	wc "$	ws = ""write sys$output"""
$	wc "$	on control_y then goto abort1"
$	wc "$	buildingname = ""lsl$i2grid_building"""
$	wc "$	buildingwarning = ""'","'f$logical(buildingname)'""
$	wc "$	if ""'","'buildingwarning'"" .eqs. """" then goto xx20"
$	wc "$	ws ""'","'buildingwarning'"""
$	wc "$	exit"
$	wc "$!"
$	wc "$xx20:"
$	wc "$	define/group ''buildingname' ""in_progress"""
$	wc "$	sd:=$lsl$sys:sd"
$	wc "$	set noon"
$	wc "$	emsg="""""
$	wc "$	assign here lsl$cmni2grid"
$	wc "$	assign lsl$source_root:[tves.service] lsl$tvessys"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$	set verify"
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! initialise
$	lnkopts=""
$	macopts=""
$	comopts=""
$	adcopts=""
$	TRUE  = "1"
$	FALSE = "0"
$!
$! compile any sources?
$	everything = FALSE
$	inq/nop anything "Compile any sources ? "
$	if .not.anything then goto xx140
$!
$! compile with listings?
$	inq/nop lis "With listings ? "
$	if lis then comopts=comopts + "/list"
$!
$! compile with debug?
$	inq/nop yes "Compile with debug ? "
$	if yes then comopts=comopts + "/debug/noopt/check=(b,o)"
$	if yes then adcopts="/co"
$!
$! compile all sources?
$	inq/nop everything "Compile all sources ? "
$!
$! compile .mar?
$xx140:
$	inq/nop mar "Compile mar ? "
$!
$! LINK?
$	inq/nop lnkit "Link ? "
$	if .not. lnkit then goto compile
$!
$! link with debug?
$	lnkopts="/map/full"
$	inq/nop yes "Link with debug ? "
$	if yes then lnkopts=lnkopts + "/debug"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$compile:
$	if .not anything then goto nocomp
$!
$	if everything then goto compile_a
$	inq yes	"Compile group ""a"""
$	if .not. yes then goto no_a
$!
$compile_a:
$	on control_c then goto no_a
$	call compiler AREA_CMD		'everything'
$	call compiler ATTRIBUTE_CMD     'everything'
$no_a:
$no_b:
$	if everything then goto compile_c
$	inq yes	"Compile group ""c"""
$	if .not. yes then goto no_c
$!
$compile_c:
$	on control_c then goto no_c
$	call compiler CLOSE_DTI		'everything'
$	call compiler CONVERT		'everything'
$	call compiler CREATE_DTI_FILE   'everything'
$no_c:
$	if everything then goto compile_d
$	inq yes	"Compile group ""d"""
$	if .not. yes then goto no_d
$compile_d:
$	on control_c then goto no_d
$	call compiler DECODE_DFAD	'everything'
$	call compiler DISPLBTMP		'everything'
$no_d:
$	if everything then goto compile_e
$	inq yes	"Compile group ""e"""
$	if .not. yes then goto no_e
$compile_e:
$	on control_c then goto no_e
$	call compiler ENABLE_CMD	'everything'
$	call compiler ENCODE_IFF	'everything'
$	call compiler ENCODE_IFF_SUB	'everything'
$	call compiler ENCODE_VALUE	'everything'
$no_e:
$	if everything then goto compile_g
$	inq yes	"Compile group ""g"""
$	if .not. yes then goto no_g
$compile_g:
$	on control_c then goto no_h
$	call compiler GET_DTINAME	'everything'
$no_g:
$	if everything then goto compile_h
$	inq yes	"Compile group ""h"""
$	if .not. yes then goto no_h
$compile_h:
$	on control_c then goto no_h
$!!!	call compiler hadctrlc		'everything'
$	call compiler HELP		'everything'
$no_h:
$	if everything then goto compile_i
$	inq yes	"Compile group ""i"""
$	if .not. yes then goto no_i
$compile_i:
$	on control_c then goto no_i
$	call compiler I2GRID		'everything'
$	call compiler IFF_TO_DTI	'everything'
$	call compiler INTSCT		'everything'
$	call compiler INWORD		'everything'
$no_i:
$	if everything then goto compile_o
$	inq yes	"Compile group ""o"""
$	if .not. yes then goto no_o
$compile_o:
$	on control_c then goto no_o
$	call compiler OFFSEG		'everything'
$	call compiler OFFSET		'everything'
$	call compiler OPEN_DTI_FILE	'everything'
$	call compiler OPEN_IFF		'everything'
$	call compiler OTPLSTRG		'everything'
$no_o:
$	if everything then goto compile_p
$	inq yes	"Compile group ""p"""
$	if .not. yes then goto no_p
$compile_p:
$	on control_c then goto no_p
$	call compiler PLOT_AREA		'everything'
$	call compiler PLOT_LINE		'everything'
$	call compiler PLOT_POINT	'everything'
$	call compiler PRESET_CMD	'everything'
$	call compiler PRIORITY_CMD	'everything'
$no_p:
$	if everything then goto compile_r
$	inq yes	"Compile group ""r"""
$	if .not. yes then goto no_r
$compile_r:
$	on control_c then goto no_r
$	call compiler RDFSN		'everything'
$	call compiler RDLAY		'everything'
$	call compiler RDRANG		'everything'
$	call compiler RDSEL		'everything'
$	call compiler REAL_RIPPLESORT	'everything'
$no_r:
$	if everything then goto compile_s
$	inq yes	"Compile group ""s"""
$	if .not. yes then goto no_s
$compile_s:
$	on control_c then goto no_s
$	call compiler SELECT_CMD	'everything'
$	call compiler SET_IFF_WINDOW    'everything'
$	call compiler SETUP_TRANSFORMATION 'everything'
$	call compiler SHOW_AREA		'everything'
$	call compiler SHOW_CMD		'everything'
$	call compiler SHOW_IFF		'everything'
$	call compiler SHOW_PRESET	'everything'
$	call compiler SHSELE		'everything'
$no_s:
$	if everything then goto compile_t
$	inq yes	"Compile group ""t"""
$	if .not. yes then goto no_t
$compile_t:
$	on control_c then goto no_t
$	call compiler TEST_VALUE        'everything'
$	call compiler TRANSFORM_ST	'everything'
$	call compiler TRANSFORM_ZS	'everything'
$no_t:
$	if everything then goto compile_w
$	inq yes	"Compile group ""w"""
$	if .not. yes then goto no_w
$compile_w:
$	on control_c then goto no_w
$	call compiler WIDEN_LINE	'everything'
$	call compiler WIDEN_POINT	'everything'
$	call compiler UPDATE_HEADER     'everything'
$no_w:
$	on control_c then goto abort1
$nocomp:
$	if .not. mar then goto nomar
$	wc "$	set noverify"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$	set verify"
$	wc "$	macro''macopts'/object=i2grid_mar i2grid + lsl$library:lslmaclib/lib"
$	wc "$ 	ok=$status"	
$	wc "$	purge/nolog i2grid_mar.obj"
$	wc "$	if .not.ok then emsg=emsg + "" i2grid_mar"""
$	wc "$! "
$	wc "$	set noverify"
$	wc "$! "
$nomar:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! list subroutines in which compilation errors occured
$	wc "$	set noverify"
$	wc "$	if emsg.eqs."""" then goto noerr"
$	wc "$	ws ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	ws ""Compilation control_cs in:"""
$	wc "$	ws emsg"
$	wc "$	ws ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	goto xx250"
$	wc "$	noerr:"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! link
$ 	if .not. lnkit then goto xx250
$	run lsl$exe:genver
$	adc version=version
$	fort version
$	pvv version
$	purge/log version.*
$!
$!
$	wc "$ ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$ set verify"
$!
$	wc "$ 	link''lnkopts'/map=i2grid/exe=i2grid -"
$	wc "	close_dti,convert,displbtmp,encode_iff, -"
$	wc "	encode_iff_sub,help,i2grid,iff_to_dti,intsct,inword, -"
$	wc "	offseg,offset,open_dti_file,open_iff,otplstrg,plot_area, -"
$	wc "	plot_line,plot_point,preset_cmd,rdfsn,rdlay,rdrang,rdsel, -"
$	wc "	real_ripplesort,area_cmd,shsele,transform_st, -"
$	wc "	show_iff,set_iff_window,show_cmd,show_area,show_preset, -"
$	wc "	transform_zs,widen_point,widen_line,get_dtiname,test_value, -"
$	wc "	attribute_cmd,decode_dfad,enable_cmd,priority_cmd, -"
$	wc "	encode_value,select_cmd,create_dti_file, -"
$	wc "	update_header,setup_transformation,i2grid_mar, -"
$	wc "	version,lsl$tvessys:tves_service/lib, -"
$	wc "	lsl$library:dtilib/lib,- "
$	wc "	lsl$library:frtshr/opt,-"
$	wc "	lsl$library:iffshr.opt/opt,- "
$	wc "	lsl$library:lslshr.opt/opt "
$!
$	wc "$   purge/nolog *.map"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! terminate comfile
$!
$xx250:	wc "$xx250:"
$	wc "$abort1:"
$	wc "$ 	deass/group ''buildingname'"
$	wc "$ 	set noverify"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! close comfil and submit job
$xx260:
$	on control_c then goto abort2
$	close comfil
$	ok=$status
$!
$! Do not submit job if i2grid is already building
$	if "''buildingwarning'" .eqs. "" then goto xx10
$	ws "Can't submit job now because i2grid is already building"
$	goto normal_exit
$!
$xx10:	if ok then inq/nop yes "Submit for batch ? "
$	if .not. yes then goto xx270
$	bat i2gridbat
$	goto normal_exit
$!
$xx270:	if ok then inq/nop yes "Submit for FAST batch ? "
$	if .not. yes then goto xx280
$	fbat i2gridbat
$	goto normal_exit
$!
$xx280:	if ok then inq/nop yes "Interactive ? "
$	if .not. yes then goto abort2
$	@i2gridbat
$!	ws "[1m[5mi2gridBAT job completed[m"
$	ws "i2gridBAT job complete"
$	goto normal_exit
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! terminate build session
$!
$abort1:close comfil
$abort2:ws "Bye!"
$normal_exit:
$	purge/nolog i2gridbat.com
$	if ver then set verify
$	exit
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! subroutine to adc/fortran/pvv/purge file P1
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$compiler:
$	subroutine
$	if p2 then goto no_ask
$	inq/nop yes "Compile ''p1' ? "
$	if .not. yes then goto ret
$no_ask:wc "$ 	set noverify"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$	set verify"
$	wc "$ 	adc ''p1'''adcopts'= ''p1'"
$	wc "$	fort''comopts' ''p1'"
$	wc "$ 	ok=$status"	
$	wc "$ 	if ok then pvv ''p1'"
$	wc "$ 	purge/nolog ''p1'.obj"
$	if comopts.eqs."" then	wc "$ 	delete/nolog ''p1'.for;*"
$	if comopts.nes.""  then	wc "$ 	purge/nolog ''p1'.for"
$	if (f$locate("nolist",comopts).ge.f$length(comopts)) -
		then		wc "$ 	if ok.and.lis then purge ''p1'.lis"
$	wc "$	if .not.ok then emsg=emsg + "" ''p1'"""
$	wc "$ 	delete adc.ide;*"
$ret:	return
$	endsubroutine
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
