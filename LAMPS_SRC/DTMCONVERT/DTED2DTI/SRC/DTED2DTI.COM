$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-09-29 12:44:26.000000000 +0100
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
$! 	Command file to build DTMCONVERT utility DTED2DTI
$!
$! 	Copyright (C) Laser-Scan Limited, Cambridge, England.
$!
$!	Created						TJH 12-Jan-1987
$!	Amended	for DTED2DTI				FJB 24-Feb-1988
$!
$	ver=f$verify(0)
$!
$	on error then goto dted2dtiex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$dted2dti_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto dted2dtiex
$	define/group lsl$dted2dti_building "in_progress"
$	open/write comfil dted2dtibat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto dted2dtiex"
$	wc "$	if ""'","'f$logical(""lsl$dted2dti_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$dted2dti_building ""in_progress"""
$	wc "$	assign here lsl$cmndted2dti"
$	wc "$	assign lsl$source_root:[dtmconvert.service] lsl$dtmconvertsys"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	dted2dti_dbg=""
$	macbuild=""
$	mes=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop dted2dti_dbg "With Debug ? "
$	if .not. dted2dti_dbg then goto a04
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
$	DEVICE_CMD="t"
$	DEVMNT_OK="t"
$	DISABLE_CMD="t"
$	DTED2DTI="t"
$	EASNOR_CMD="t"
$	ENABLE_CMD="t"
$	FILEOUT_CMD="t"
$	GET_CMDS="t"
$	HELP_CMD="t"
$	LATLONG_CMD="t"
$	MANUSCRIPT_CMD="t"
$	PROCESS_TAPE="t"
$	RDGRID="t"
$	READLL="t"
$	REWIND_CMD="t"
$	SHOW_CMD="t"
$	SWPCPY="t"
$	MACBUILD="t"
$	goto a11
$ a05:	   
$	ws " "
$	ws ".............................MACRO32 stuff"
$	   inq/nop macbuild	"Compile command table? "
$	ws " " 
$	ws ".............................FORTRAN sources"
$	inq/nop DEVICE_CMD "DEVICE_CMD? "
$	inq/nop DEVMNT_OK "DEVMNT_OK? "
$	inq/nop DISABLE_CMD "DISABLE_CMD? "
$	inq/nop DTED2DTI "DTED2DTI? "
$	inq/nop EASNOR_CMD "EASNOR_CMD? "
$	inq/nop ENABLE_CMD "ENABLE_CMD? "
$	inq/nop FILEOUT_CMD "FILEOUT_CMD? "
$	inq/nop GET_CMDS "GET_CMDS? "
$	inq/nop HELP_CMD "HELP_CMD? "
$	inq/nop LATLONG_CMD "LATLONG_CMD? "
$	inq/nop MANUSCRIPT_CMD "MANUSCRIPT_CMD? "
$	inq/nop PROCESS_TAPE "PROCESS_TAPE? "
$	inq/nop RDGRID "RDGRID? "
$	inq/nop READLL "READLL? "
$	inq/nop REWIND_CMD "REWIND_CMD? "
$	inq/nop SHOW_CMD "SHOW_CMD? "
$	inq/nop SWPCPY "SWPCPY? "
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
$	   linkver="dted2dti"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="dted2dtix"
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
$ 		if .not.mes then goto cmponly
$		wc "$	newmsg/dti/number=1672/name=dted2dti/prefix=dted2dt__/parameter=for/runoff dted2dti.mes"
$		wc "$ @dted2dti.temp_com"
$!	
$ cmponly:		
$	mdeb=""
$	if dted2dti_dbg then mdeb = "/Enable=debug"
$	if .not. macbuild then goto for2
$		wc "$	MACRO''mdeb' dted2dti_cmdtab"
$ for2: if .not. compile then goto lnkonly
$	
$!
$	if DEVICE_CMD then call compiler DEVICE_CMD
$	if DEVMNT_OK then call compiler DEVMNT_OK
$	if DISABLE_CMD then call compiler DISABLE_CMD
$	if DTED2DTI then call compiler DTED2DTI
$	if EASNOR_CMD then call compiler EASNOR_CMD
$	if ENABLE_CMD then call compiler ENABLE_CMD
$	if FILEOUT_CMD then call compiler FILEOUT_CMD
$	if GET_CMDS then call compiler GET_CMDS
$	if HELP_CMD then call compiler HELP_CMD
$	if LATLONG_CMD then call compiler LATLONG_CMD
$	if MANUSCRIPT_CMD then call compiler MANUSCRIPT_CMD
$	if PROCESS_TAPE then call compiler PROCESS_TAPE
$	if RDGRID then call compiler RDGRID
$	if READLL then call compiler READLL
$	if REWIND_CMD then call compiler REWIND_CMD
$	if SHOW_CMD then call compiler SHOW_CMD
$	if SWPCPY then call compiler SWPCPY
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
$	wc "$ link''linkopts'/exe=''linkver' - "
$       wc "  dted2dti,device_cmd,devmnt_ok,disable_cmd,dted2dti_cmdtab, - "
$       wc "  easnor_cmd,enable_cmd,fileout_cmd,get_cmds, - "
$       wc "  help_cmd,latlong_cmd,manuscript_cmd,process_tape, - "
$       wc "  rdgrid,readll,rewind_cmd, - "
$       wc "  show_cmd,swpcpy, - "
$       wc "  version,- "
$       wc "  dted2dti.promsg_obj, - "
$       wc "  lsl$dtmconvertsys:dtmconvert/lib, - "
$       wc "  lsl$library:pmeclock.obj, - "
$	wc "  lsl$library:dtilib/lib, - "
$       wc "  lsl$library:lsldlmslib/lib, - "
$       wc "  lsl$library:lslshr/opt "
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	dted2dtiex:"
$		wc "$ 	deass/group lsl$dted2dti_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto dted2dtiex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$dted2dti_building
$	bat dted2dtibat.com
$	goto dted2dtix2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto dted2dtiex
$	deass/group lsl$dted2dti_building
$	@dted2dtibat.com
$	goto dted2dtix2
$ dted2dtiex:
$	deass/group lsl$dted2dti_building
$ dted2dtix2:
$	if ver then set verify
                                         
