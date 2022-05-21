$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-12-19 15:57:00.000000000 +0000
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
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$!	Command file for creating and submiting a batch command file
$!	for building DTIFILTER
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	ver = f$verify(0)
$	ws = "write sys$output"
$	wc = "write comfil"
$	on error then goto abort2
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! DO NOT BUILD IF SOMEONE ELSE IS ALREADY BUILDING
$	disk = f$logical("sys$disk")
$	my_name = f$getjpi("","USERNAME")
$	buildingname = "lsl$dtifilter_building"
$	buildingwarning = "''f$logical(buildingname)'"
$	on control_y then goto abort2
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! OPEN FILE TO RECEIVE BUILDING COMMANDS
$	comfile = "dtifilterbat.com"
$	if f$search(comfile).nes."" then delete/nolog 'comfile';*
$	open/write comfil dtifilterbat.com
$	on control_y then goto abort1
$ 	on error then goto xx260
$!
$! CHECK FOR BUILD ALREADY IN PROGRESS FROM WITHIN THE BUILD COMMAND FILE
$	wc "$ 	set noverify"
$	wc "$	ws = ""write sys$output"""
$	wc "$	on control_y then goto abort1"
$	wc "$	buildingname = ""lsl$dtifilter_building"""
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
$	wc "$	assign lsl$source_root:[imageprocess.dtifilter] lsl$cmndtifilter"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$	set verify"
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! INITIALISE
$	lnkopts=""
$	macopts=""
$	comopts="/list"
$	adcopts=""
$	TRUE = "1"
$	FALSE = "0"
$!
$! COMPILE ANY SOURCES?
$	everything = FALSE
$	inq/nop anything "Compile any sources ? "
$	if .not.anything then goto xx140
$!
$! COMPILE WITH DEBUG?
$	inq/nop yes "Compile with debug ? "
$	if yes then comopts=comopts + "/debug/noopt/check=(b,o)"
$	if yes then adcopts="/co"
$!
$! COMPILE ALL SOURCES?
$	inq/nop everything "Compile all sources ? "
$!
$xx140:
$! COMPILE .MAR?
$	inq/nop mar "CMDLIB commands ? "
$! COMPILE .CLD?
$!	inq/nop cld "DCL commands ? "
$! COMPILE .MES?
$	inq/nop mes "message definitions ? "
$!
$! LINK?
$	inq/nop lnkit "Link ? "
$	if .not. lnkit then goto compile
$!
$! LINK WITH DEBUG?
$	lnkopts="/map/full"
$	inq/nop yes "Link with debug ? "
$	if yes then lnkopts=lnkopts + "/debug"
$!
$compile:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Build message files
$	if.not.mes then goto nomes
$	wc "$	set noverify"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$	set verify"
$	wc "$	newmsg dtifilter.mes/number=1269/prefix=dtifil__/parameter=fortran/runoff"
$	wc "$	@dtifilter.temp_com"
$	wc "$	purge dtifiltermsg.rno"
$	wc "$	set noverify"
$	wc "$!"
$nomes:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$	if .not. anything then goto nocomp
$!
$	call compiler clofil		'everything'
$	call compiler convolve		'everything'
$	call compiler convolve_byte	'everything'
$	call compiler convolve_long	'everything'
$	call compiler convolve_real	'everything'
$	call compiler convolve_word	'everything'
$	call compiler ctrlcast		'everything'
$	call compiler dfilcom		'everything'
$	call compiler dtifilter		'everything'
$	call compiler dyncom		'everything'
$	call compiler filter		'everything'
$	call compiler filter_byte	'everything'
$	call compiler filter_long	'everything'
$	call compiler filter_real	'everything'
$	call compiler filter_word	'everything'
$	call compiler hadctrlc		'everything'
$	call compiler help		'everything'
$	call compiler initial		'everything'
$	call compiler kernel		'everything'
$	call compiler kersize		'everything'
$	call compiler long_lkp		'everything'
$	call compiler median_byte	'everything'
$	call compiler median_long	'everything'
$	call compiler median_real	'everything'
$	call compiler median_word	'everything'
$	call compiler mode_byte		'everything'
$	call compiler mode_long		'everything'
$	call compiler mode_real		'everything'
$	call compiler mode_word		'everything'
$	call compiler newdti		'everything'
$	call compiler opnfil		'everything'
$	call compiler opnlkp		'everything'
$	call compiler read_lookup	'everything'
$	call compiler real_lkp		'everything'
$	call compiler scrnker		'everything'
$	call compiler setker		'everything'
$	call compiler setthresh		'everything'
$	call compiler sharpen_byte	'everything'
$	call compiler sharpen_long	'everything'
$	call compiler sharpen_real	'everything'
$	call compiler sharpen_word	'everything'
$	call compiler show		'everything'
$	call compiler termin		'everything'
$	call compiler tidyup		'everything'
$	call compiler window		'everything'
$	call compiler wrtlkp		'everything'
$!
$	on control_c then goto abort1
$nocomp:
$	goto nocld
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Compile CLD module
$	if.not.cld then goto nocld
$	wc "$	set noverify"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$ set verify"
$	wc "$	adc dtifilter.tmp = dtifilter.cld"
$	wc "$	set command/object = dtifilter_cld dtifilter.tmp"
$	wc "$ 	ok=$status"	
$	wc "$	if ok then pvv dtifilter_cld"
$	wc "$	delete dtifilter.tmp;*"
$	wc "$	delete adc.ide;*"
$	wc "$	if .not.ok then emsg=emsg + "" dtifilter_cld"""
$	wc "$	set noverify"
$	wc "$! "
$!
$nocld:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Compile .MAR
$	if .not. mar then goto nomar
$	wc "$	set noverify"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$	set verify"
$	wc "$	macro''macopts'/object=dtifilter_mar dfilcmd"
$	wc "$ 	ok=$status"
$	wc "$	purge/nolog dtifilter_mar.obj"
$	wc "$	if .not.ok then emsg=emsg + "" dtifilter_mar"""
$	wc "$	set noverify"
$	wc "$! "
$nomar:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! LIST SUBROUTINES IN WHICH COMPILATION ERRORS OCCURED
$	wc "$	set noverify"
$	wc "$	if emsg.eqs."""" then goto noerr"
$	wc "$	ws ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	ws ""Compilation errors in:"""
$	wc "$	ws emsg"
$	wc "$	ws ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	goto xx250"
$	wc "$	noerr:"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! LINK
$ 	if .not. lnkit then goto xx250
$!
$	wc "$ ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$ set verify"
$!
$	wc "$ 	link''lnkopts'/map=dtifilter/exe=dtifilter -"
$	wc "	dtifilter/opt,lsl$library:lslshr/opt"
$!
$	wc "$   purge/nolog *.exe,*.map"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! TERMINATE COMFILE
$!
$xx250:	wc "$xx250:"
$	wc "$abort1:"
$	wc "$ 	deass/group ''buildingname'"
$	wc "$ 	set noverify"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! CLOSE COMFIL AND SUBMIT JOB
$xx260:
$	on control_c then goto abort2
$	close comfil
$	ok=$status
$!
$! Do not submit job if dtifilter is already building
$	if "''buildingwarning'" .eqs. "" then goto xx10
$	ws "Can't submit job now because dtifilter is already building"
$	goto normal_exit
$!
$xx10:	if ok then inq/nop yes "Submit for batch ? "
$	if .not. yes then goto xx270
$	bat dtifilterbat.com
$	goto normal_exit
$!
$xx270:	if ok then inq/nop yes "Submit for FAST batch ? "
$	if .not. yes then goto xx280
$	fbat dtifilterbat.com
$	goto normal_exit
$!
$xx280:	if ok then inq/nop yes "Interactive ? "
$	if .not. yes then goto abort2
$	@dtifilterbat.com
$!	ws "[1m[5mDTIFILTERBAT job completed[m"
$	ws "DTIFILTERBAT job completed"
$	goto normal_exit
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! TERMINATE BUILD SESSION
$!
$abort1:close comfil
$abort2:ws "Bye!"
$normal_exit:
$	purge/nolog dtifilterbat.com
$	if ver then set verify
$	exit
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! SUBROUTINE TO ADC/FORTRAN/PVV/PURGE FILE p1
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
$	if comopts.nes.""  then	wc "$ 	if ok then delete/nolog ''p1'.lis;*"
$	wc "$	if .not.ok then emsg=emsg + "" ''p1'"""
$	wc "$ 	delete adc.ide;*"
$ret:	return
$	endsubroutine
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
