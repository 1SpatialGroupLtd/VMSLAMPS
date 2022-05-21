$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-11-16 11:38:54.000000000 +0000
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
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! 	Command file to build MATRIX utility DTIBLEND
$!
$! 	Copyright Laser-Scan Limited, Cambridge, England.
$!	Created						TJH 26-Apr-1988
$!
$!	Modified to include assign for LSL$MATRIXSYS	ALB 17-Jun-1988
$!	Modified to include frtshr			 JB 15-Nov-1994
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	ver=f$verify(0)
$	on error then goto dtiblendex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$dtiblend_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	on control_y then goto dtiblendex
$	define/group lsl$dtiblend_building "in_progress"
$	open/write comfil dtiblendbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto dtiblendex"
$	wc "$	if ""'","'f$logical(""lsl$dtiblend_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$dtiblend_building ""in_progress"""
$	wc "$	assign here lsl$cmndtiblend"
$	wc "$	assign lsl$source_root:[matrix.service] lsl$matrixsys"
$	wc "$	assign lsl$source_root:[matrix.service] lsl$dtmcreatesys"
$	wc "$	sd:=$lsl$sys:sd"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	dtiblend_dbg=""
$	macbuild=""
$	mes=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop dtiblend_dbg "With Debug ? "
$	if .not. dtiblend_dbg then goto a04
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
$	BLEND_CMD="t"
$	BORDER_CMD="t"
$	CALC_BLEND_SECTORS="t"
$	CHECK_ABUT="t"
$	CLOSE_FILES="t"
$	COMPARE="t"
$	COVERAGE="t"
$	DESCHK="t"
$	DESELECT_CMD="t"
$	DISABLE_CMD="t"
$	DISPLBTMP="t"
$	DTIBLEND="t"
$	DTICHK="t"
$	ENABLE_CMD="t"
$	EUCLID="t"
$	FIX_LUNS="t"
$	GETFRT_CMD="t"
$	GET_CMDS="t"
$	GET_FIXED_Z="t"
$	GO_CMD="t"
$	HELP_CMD="t"
$	HOLD_CMD="t"
$	IFF_CMD="t"
$	IFF_INTERSECTIONS="t"
$	IFF_SETUP="t"
$	IFF_TAB_BUILD="t"
$	INTERP="t"
$	INTERZ="t"
$	INTSEC="t"
$	INWORD="t"
$	LINEQN="t"
$	LIST_CMD="t"
$	LOAD_MEAN_EDGE="t"
$	NULL_CMD="t"
$	OPEN_DTI="t"
$	OPEN_LIST_FILE="t"
$	OPEN_ROVER_FILE="t"
$	OTPLSTRG="t"
$	PACK_TABLE="t"
$	PERFORM_BLEND="t"
$	RDLAY="t"
$	RDSEL="t"
$	RELOFF="t"
$	REPORT_ZONE="t"
$	ROVER_CMD="t"
$	SELECT_CMD="t"
$	SHOW_CMD="t"
$	SWAP="t"
$	THRESHOLD_CMD="t"
$	THRESHOLD_MES="t"
$	macbuild="t"
$	goto a11
$ a05:	   
$	ws " "
$	ws ".............................MACRO32 stuff"
$	   inq/nop macbuild	"Compile command table? "
$	ws " " 
$	ws ".............................FORTRAN sources"
$	inquire/nopunct BLEND_CMD "BLEND_CMD? "
$	inquire/nopunct BORDER_CMD "BORDER_CMD? "
$	inquire/nopunct CALC_BLEND_SECTORS "CALC_BLEND_SECTORS? "
$	inquire/nopunct CHECK_ABUT "CHECK_ABUT? "
$	inquire/nopunct CLOSE_FILES "CLOSE_FILES? "
$	inquire/nopunct COMPARE "COMPARE? "
$	inquire/nopunct COVERAGE "COVERAGE? "
$	inquire/nopunct DESCHK "DESCHK? "
$	inquire/nopunct DESELECT_CMD "DESELECT_CMD? "
$	inquire/nopunct DISABLE_CMD "DISABLE_CMD? "
$	inquire/nopunct DISPLBTMP "DISPLBTMP? "
$	inquire/nopunct DTIBLEND "DTIBLEND? "
$	inquire/nopunct DTICHK "DTICHK? "
$	inquire/nopunct ENABLE_CMD "ENABLE_CMD? "
$	inquire/nopunct EUCLID "EUCLID? "
$	inquire/nopunct FIX_LUNS "FIX_LUNS? "
$	inquire/nopunct GETFRT_CMD "GETFRT_CMD? "
$	inquire/nopunct GET_CMDS "GET_CMDS? "
$	inquire/nopunct GET_FIXED_Z "GET_FIXED_Z? "
$	inquire/nopunct GO_CMD "GO_CMD? "
$	inquire/nopunct HELP_CMD "HELP_CMD? "
$	inquire/nopunct HOLD_CMD "HOLD_CMD? "
$	inquire/nopunct IFF_CMD "IFF_CMD? "
$	inquire/nopunct IFF_INTERSECTIONS "IFF_INTERSECTIONS? "
$	inquire/nopunct IFF_SETUP "IFF_SETUP? "
$	inquire/nopunct IFF_TAB_BUILD "IFF_TAB_BUILD? "
$	inquire/nopunct INTERP "INTERP? "
$	inquire/nopunct INTERZ "INTERZ? "
$	inquire/nopunct INTSEC "INTSEC? "
$	inquire/nopunct INWORD "INWORD? "
$	inquire/nopunct LINEQN "LINEQN? "
$	inquire/nopunct LIST_CMD "LIST_CMD? "
$	inquire/nopunct LOAD_MEAN_EDGE "LOAD_MEAN_EDGE? "
$	inquire/nopunct NULL_CMD "NULL_CMD? "
$	inquire/nopunct OPEN_DTI "OPEN_DTI? "
$	inquire/nopunct OPEN_LIST_FILE "OPEN_LIST_FILE? "
$	inquire/nopunct OPEN_ROVER_FILE "OPEN_ROVER_FILE? "
$	inquire/nopunct OTPLSTRG "OTPLSTRG? "
$	inquire/nopunct PACK_TABLE "PACK_TABLE? "
$	inquire/nopunct PERFORM_BLEND "PERFORM_BLEND? "
$	inquire/nopunct RDLAY "RDLAY? "
$	inquire/nopunct RDSEL "RDSEL? "
$	inquire/nopunct RELOFF "RELOFF? "
$	inquire/nopunct REPORT_ZONE "REPORT_ZONE? "
$	inquire/nopunct ROVER_CMD "ROVER_CMD? "
$	inquire/nopunct SELECT_CMD "SELECT_CMD? "
$	inquire/nopunct SHOW_CMD "SHOW_CMD? "
$	inquire/nopunct SWAP "SWAP? "
$	inquire/nopunct THRESHOLD_CMD "THRESHOLD_CMD? "
$	inquire/nopunct THRESHOLD_MES "THRESHOLD_MES? "
$ a11:
$	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   linkver="dtiblend"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="dtiblendx"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!	   
$	   if .not. compile then goto lnkonly
$!
$ notkb:
$		wc "$ 	set noverify"
$!
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 	set verify"
$ 		if .not. mes then goto cmponly 
$		wc "$	newmsg/dti/number=1644/name=dtiblend/prefix=dtibln__/parameter=for/runoff dtiblend.mes"
$		wc "$ @dtiblend.temp_com"
$!
$ cmponly:		
$	mdeb=""
$	if dtiblend_dbg then mdeb = "/Enable=debug"
$	if .not. macbuild then goto for2
$		wc "$	MACRO''mdeb' dtiblend_cmdtab"
$ for2: if .not. compile then goto lnkonly
$!	
$	if BLEND_CMD then call compiler BLEND_CMD
$	if BORDER_CMD then call compiler BORDER_CMD
$	if CALC_BLEND_SECTORS then call compiler CALC_BLEND_SECTORS
$	if CHECK_ABUT then call compiler CHECK_ABUT
$	if CLOSE_FILES then call compiler CLOSE_FILES
$	if COMPARE then call compiler COMPARE
$	if COVERAGE then call compiler COVERAGE
$	if DESCHK then call compiler DESCHK
$	if DESELECT_CMD then call compiler DESELECT_CMD
$	if DISABLE_CMD then call compiler DISABLE_CMD
$	if DISPLBTMP then call compiler DISPLBTMP
$	if DTIBLEND then call compiler DTIBLEND
$	if DTICHK then call compiler DTICHK
$	if ENABLE_CMD then call compiler ENABLE_CMD
$	if EUCLID then call compiler EUCLID
$	if FIX_LUNS then call compiler FIX_LUNS
$	if GETFRT_CMD then call compiler GETFRT_CMD
$	if GET_CMDS then call compiler GET_CMDS
$	if GET_FIXED_Z then call compiler GET_FIXED_Z
$	if GO_CMD then call compiler GO_CMD
$	if HELP_CMD then call compiler HELP_CMD
$	if HOLD_CMD then call compiler HOLD_CMD
$	if IFF_CMD then call compiler IFF_CMD
$	if IFF_INTERSECTIONS then call compiler IFF_INTERSECTIONS
$	if IFF_SETUP then call compiler IFF_SETUP
$	if IFF_TAB_BUILD then call compiler IFF_TAB_BUILD
$	if INTERP then call compiler INTERP
$	if INTERZ then call compiler INTERZ
$	if INTSEC then call compiler INTSEC
$	if INWORD then call compiler INWORD
$	if LINEQN then call compiler LINEQN
$	if LIST_CMD then call compiler LIST_CMD
$	if LOAD_MEAN_EDGE then call compiler LOAD_MEAN_EDGE
$	if NULL_CMD then call compiler NULL_CMD
$	if OPEN_DTI then call compiler OPEN_DTI
$	if OPEN_LIST_FILE then call compiler OPEN_LIST_FILE
$	if OPEN_ROVER_FILE then call compiler OPEN_ROVER_FILE
$	if OTPLSTRG then call compiler OTPLSTRG
$	if PACK_TABLE then call compiler PACK_TABLE
$	if PERFORM_BLEND then call compiler PERFORM_BLEND
$	if RDLAY then call compiler RDLAY
$	if RDSEL then call compiler RDSEL
$	if RELOFF then call compiler RELOFF
$	if REPORT_ZONE then call compiler REPORT_ZONE
$	if ROVER_CMD then call compiler ROVER_CMD
$	if SELECT_CMD then call compiler SELECT_CMD
$	if SHOW_CMD then call compiler SHOW_CMD
$	if SWAP then call compiler SWAP
$	if THRESHOLD_CMD then call compiler THRESHOLD_CMD
$	if THRESHOLD_MES then call compiler THRESHOLD_MES
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
		wc "$ 	if ok then delete/nolog ''p1'.lis;*"
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
$	wc "$ 	run lsl$exe:genver"
$		call compiler version
$	wc "$ 	purge/nolog version.src"
$	wc "$ set verify"
$	wc "$ 	link''linkopts'/exe=''linkver' dtiblend/opt,lsl$library:iffshr/opt,lslshr/opt,frtshr/opt"
$	wc "$ mapid dtiblend"
$	wc "$ purge dtiblend.*"
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	dtiblendex:"
$		wc "$ 	deass/group lsl$dtiblend_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto dtiblendex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$dtiblend_building
$	bat dtiblendbat.com
$	goto dtiblendx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto dtiblendex
$	deass/group lsl$dtiblend_building
$	@dtiblendbat.com
$	purge dtiblendbat.com
$	goto dtiblendx2
$ dtiblendex:
$	deass/group lsl$dtiblend_building
$ dtiblendx2:
$	if ver then set verify
$!
