$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-09-28 19:24:32.000000000 +0100
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
$! Command file to build TVES utility DTICHECK
$!
$! Copyright Laser-Scan Limited, Cambridge, England.
$!
$!	Created						DJG 09-Feb-1988
$!
$	ver=f$verify(0)
$!
$	on error then goto dticheckex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$dticheck_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	on control_y then goto dticheckex
$	define/group lsl$dticheck_building "in_progress"
$	open/write comfil dticheckbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto dticheckex"
$	wc "$	if ""'","'f$logical(""lsl$dticheck_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$dticheck_building ""in_progress"""
$	wc "$	assign here lsl$cmndticheck"
$	wc "$	assign lsl$source_root:[tves.service] lsl$tvessys"
$	wc "$	assign lsl$source_root:[tves.service] lsl$dtmcreatesys"
$	wc "$	sd:=$lsl$sys:sd"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	dticheck_dbg=""
$	macbuild=""
$	mes=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop dticheck_dbg "With Debug ? "
$	if .not. dticheck_dbg then goto a04
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
$	CAL_ABS_POS="t"
$	CHECK_SLOPE="t"
$	CHECK_MINUS="t"
$	CHECK_NULL="t"
$	CHECK_ZERO="t"
$	CLOSE_FILES="t"
$	DISABLE_CMD="t"
$	dticheck="t"
$	ENABLE_CMD="t"
$	FILEIN_CMD="t"
$	FIVE_PERCENT="t"
$	GET_CMDS="t"
$	GETCOL="t"
$	GO_CMD="t"
$	HELP_CMD="t"
$	IFF_CMD="t"
$	LITES2_CMD="t"
$	LITES_MESS="t"
$	NULL_CMD="t"
$	OPNDTI="t"
$	PLOTUNITS_CMD="t"
$	PREP_RCM_INFO="t"
$	RCM_OPEN="t"
$	READLL="t"
$	ROVER_CMD="t"
$	ROVER_MESS="t"
$	SET_CMD="t"
$	SETUP_IFF="t"
$	SHOW_CMD="t"
$	SLOPE_CMD="t"
$	START_RCM="t"
$	UNITS_CMD="t"
$	WINDOW_CMD="t"
$	WRITE_MESS="t"
$	macbuild="t"
$	goto a11
$ a05:	   
$	ws " "
$	ws ".............................MACRO32 stuff"
$	   inq/nop macbuild	"Compile command table? "
$	ws " " 
$	ws ".............................FORTRAN sources"
$	inq/nop CAL_ABS_POS "CAL_ABS_POS? "
$	inq/nop CHECK_SLOPE "CHECK_SLOPE? "
$	inq/nop CHECK_MINUS "CHECK_MINUS? "
$	inq/nop CHECK_NULL "CHECK_NULL? "
$	inq/nop CHECK_ZERO "CHECK_ZERO? "
$	inq/nop CLOSE_FILES "CLOSE_FILES? "
$	inq/nop DISABLE_CMD "DISABLE_CMD? "
$	inq/nop dticheck "dticheck? "
$	inq/nop ENABLE_CMD "ENABLE_CMD? "
$	inq/nop FILEIN_CMD "FILEIN_CMD? "
$	inq/nop FIVE_PERCENT "FIVE_PERCENT? "
$	inq/nop GET_CMDS "GET_CMDS? "
$	inq/nop GETCOL "GETCOL? "
$	inq/nop GO_CMD "GO_CMD? "
$	inq/nop HELP_CMD "HELP_CMD? "
$	inq/nop IFF_CMD "IFF_CMD? "
$	inq/nop LITES2_CMD "LITES2_CMD? "
$	inq/nop LITES_MESS "LITES_MESS? "
$	inq/nop NULL_CMD "NULL_CMD? "
$	inq/nop OPNDTI "OPNDTI?"
$	inq/nop PLOTUNITS_CMD "PLOTUNITS_CMD? "
$	inq/nop PREP_RCM_INFO "PREP_RCM_INFO?"
$	inq/nop RCM_OPEN "RCM_OPEN?"
$	inq/nop READLL "READLL?"
$	inq/nop ROVER_CMD "ROVER_CMD?"
$	inq/nop ROVER_MESS "ROVER_MESS?"
$	inq/nop SET_CMD "SET_CMD? "
$	inq/nop SETUP_IFF "SETUP_IFF? "
$	inq/nop SHOW_CMD "SHOW_CMD? "
$	inq/nop SLOPE_CMD "SLOPE_CMD? "
$	inq/nop START_RCM "START_RCM? "
$	inq/nop UNITS_CMD "UNITS_CMD? "
$	inq/nop WINDOW_CMD "WINDOW_CMD? "
$	inq/nop WRITE_MESS "WRITE_MESS?"
$!
$ a11:
$	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   linkver="dticheck"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="dticheckx"
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
$		wc "$	newmsg/dti/number=1654/name=dtichk/prefix=dtichk__/parameter=for/runoff dticheck.mes"
$		wc "$ @dticheck.temp_com"
$!	
$ cmponly:		
$	mdeb=""
$	if dticheck_dbg then mdeb = "/Enable=debug"
$	if .not. macbuild then goto for2
$		wc "$	MACRO''mdeb' dticheck_cmdtab"
$ for2: if .not. compile then goto lnkonly
$!
$	if CAL_ABS_POS then call compiler CAL_ABS_POS
$	if CHECK_SLOPE then call compiler CHECK_SLOPE
$	if CHECK_MINUS then call compiler CHECK_MINUS
$	if CHECK_NULL then call compiler CHECK_NULL
$	if CHECK_ZERO then call compiler CHECK_ZERO
$	if CLOSE_FILES then call compiler CLOSE_FILES
$	if DISABLE_CMD then call compiler DISABLE_CMD
$	if dticheck then call compiler dticheck
$	if ENABLE_CMD then call compiler ENABLE_CMD
$	if FILEIN_CMD then call compiler FILEIN_CMD
$	if FIVE_PERCENT then call compiler FIVE_PERCENT
$	if GET_CMDS then call compiler GET_CMDS
$	if GETCOL then call compiler GETCOL
$	if GO_CMD then call compiler GO_CMD
$	if HELP_CMD then call compiler HELP_CMD
$	if IFF_CMD then call compiler IFF_CMD
$	if LITES2_CMD then call compiler LITES2_CMD
$	if LITES_MESS then call compiler LITES_MESS
$	if NULL_CMD then call compiler NULL_CMD
$	if OPNDTI then call compiler OPNDTI
$	if PLOTUNITS_CMD then call compiler PLOTUNITS_CMD
$	if PREP_RCM_INFO then call compiler PREP_RCM_INFO
$	if RCM_OPEN then call compiler RCM_OPEN
$	if READLL then call compiler READLL
$	if ROVER_CMD then call compiler ROVER_CMD
$	if ROVER_MESS then call compiler ROVER_MESS
$	if SET_CMD then call compiler SET_CMD
$	if SETUP_IFF then call compiler SETUP_IFF
$	if SHOW_CMD then call compiler SHOW_CMD
$	if SLOPE_CMD then call compiler SLOPE_CMD
$	if START_RCM then call compiler START_RCM
$	if UNITS_CMD then call compiler UNITS_CMD
$	if WINDOW_CMD then call compiler WINDOW_CMD
$	if WRITE_MESS then call compiler WRITE_MESS
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
$	wc "$ 	link''linkopts'/exe=''linkver' dticheck/opt,lsl$library:iffshr/opt,lslshr/opt"
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	dticheckex:"
$		wc "$ 	deass/group lsl$dticheck_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto dticheckex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$dticheck_building
$	bat dticheckbat.com
$	goto dticheckx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto dticheckex
$	deass/group lsl$dticheck_building
$	@dticheckbat.com
$	goto dticheckx2
$!
$ dticheckex:
$	deass/group lsl$dticheck_building
$!
$ dticheckx2:
$	if ver then set verify
$!
