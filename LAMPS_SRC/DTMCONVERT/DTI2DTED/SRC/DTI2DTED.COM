$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-09-29 11:18:28.000000000 +0100
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
$! 	Command file to build DTMCONVERT utility DTI2DTED
$!
$! 	Copyright Laser-Scan Limited, Cambridge, England.
$!
$!	Created						TJH 12-Jan-1987
$!	Amended	for DTED2DTI				FJB 24-Feb-1988
$!	Amended for DTI2DTED				FJB 20-Apr-1988
$!	mod 1269 use dtmconvert service library		 JB 16-Aug-1993

$!
$	ver=f$verify(0)
$!
$	on error then goto dti2dtedex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$dti2dted_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	on control_y then goto dti2dtedex
$	define/group lsl$dti2dted_building "in_progress"
$	open/write comfil dti2dtedbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto dti2dtedex"
$	wc "$	if ""'","'f$logical(""lsl$dti2dted_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$dti2dted_building ""in_progress"""
$	wc "$	assign here lsl$cmndti2dted"
$	wc "$	assign lsl$source_root:[dtmconvert.service] lsl$dtmconvertsys"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	dti2dted_dbg=""
$	macbuild=""
$	mes=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop dti2dted_dbg "With Debug ? "
$	if .not. dti2dted_dbg then goto a04
$!
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
$	MACBUILD="t"
$	APPEND_CMD="t"
$	CPYSWP="t"
$	DEVICE_CMD="t"
$	DEVMNT_OUT_OK="t"
$	DISABLE_CMD="t"
$	DTI2DTED="t"
$	ENABLE_CMD="t"
$	FILEIN_CMD="t"
$	GET_CMDS="t"
$	HELP_CMD="t"
$	PROCESS_FILE="t"
$	SHOW_CMD="t"
$!
$	goto a11
$ a05:
$	ws " "
$	ws ".............................MACRO32 stuff"
$!
$	   inq/nop MACBUILD	"Compile command table? "
$!
$	ws " " 
$	ws ".............................FORTRAN sources"
$!
$	inq/nop APPEND_CMD "APPEND_CMD? "
$	inq/nop CPYSWP "CPYSWP? "
$	inq/nop DEVICE_CMD "DEVICE_CMD? "
$	inq/nop DEVMNT_OUT_OK "DEVMNT_OUT_OK? "
$	inq/nop DISABLE_CMD "DISABLE_CMD? "
$	inq/nop DTI2DTED "DTI2DTED? "
$	inq/nop ENABLE_CMD "ENABLE_CMD? "
$	inq/nop FILEIN_CMD "FILEIN_CMD? "
$	inq/nop GET_CMDS "GET_CMDS? "
$	inq/nop HELP_CMD "HELP_CMD? "
$	inq/nop PROCESS_FILE "PROCESS_FILE? "
$	inq/nop SHOW_CMD "SHOW_CMD? "
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
$	   linkver="dti2dted"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="dti2dtedx"
$!
$	   if .not. compile then goto lnkonly
$!
$ notkb:
$		wc "$ 	set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 	set verify"
$!
$	   if .not. mes then goto cmponly
$!
$		wc "$ newmsg/dti/number=1671/name=dti2dted/prefix=dti2dte__/parameter=for/runoff dti2dted.mes"
$		wc "$ @dti2dted.temp_com" 
$!
$ cmponly:
$	   if .not. macbuild then goto for2
$!
$	mdeb=""
$	if dti2dted_dbg then mdeb = "/enable=debug"
$!
$		wc "$ 	set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 	set verify"
$		wc "$ MACRO''mdeb' dti2dted_cmdtab"
$!
$ for2: if .not. compile then goto lnkonly
$!
$	if APPEND_CMD then call compiler APPEND_CMD
$	if CPYSWP then call compiler CPYSWP
$	if DEVICE_CMD then call compiler DEVICE_CMD
$	if DEVMNT_OUT_OK then call compiler DEVMNT_OUT_OK
$	if DISABLE_CMD then call compiler DISABLE_CMD
$	if DTI2DTED then call compiler DTI2DTED
$	if ENABLE_CMD then call compiler ENABLE_CMD
$	if FILEIN_CMD then call compiler FILEIN_CMD
$	if GET_CMDS then call compiler GET_CMDS
$	if HELP_CMD then call compiler HELP_CMD
$	if PROCESS_FILE then call compiler PROCESS_FILE
$	if SHOW_CMD then call compiler SHOW_CMD
$!
$	goto lnkonly
$!----------------------------------------------------------------------
$ compiler: subroutine 
$!----------------------------------------------------------------------
$		wc "$	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$	adc ''p1'''kpcom'=''p1'"
$	   	wc "$	fort''fsw1' ''p1'"
$	      	wc "$	ok=$status"	
$		wc "$	if ok then pvv ''p1'"
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
$	wc "$ link''linkopts'/exe=''linkver' - "
$       wc "  dti2dted,append_cmd,cpyswp,device_cmd,devmnt_out_ok, - "
$       wc "  disable_cmd,dti2dted_cmdtab,enable_cmd,filein_cmd, - "
$       wc "  get_cmds,help_cmd,process_file, - "
$       wc "  show_cmd, - "
$       wc "  version,- "
$       wc "  dti2dted.promsg_obj, - "
$       wc "  lsl$dtmconvertsys:dtmconvert/lib, - "
$       wc "  lsl$library:dtilib/lib, - "
$       wc "  lsl$library:lslshr/opt "
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	dti2dtedex:"
$		wc "$ 	deass/group lsl$dti2dted_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto dti2dtedex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$dti2dted_building
$	bat dti2dtedbat.com
$	goto dti2dtedx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto dti2dtedex
$	deass/group lsl$dti2dted_building
$	@dti2dtedbat.com
$	goto dti2dtedx2
$ dti2dtedex:
$	deass/group lsl$dti2dted_building
$ dti2dtedx2:
$	if ver then set verify
$!
