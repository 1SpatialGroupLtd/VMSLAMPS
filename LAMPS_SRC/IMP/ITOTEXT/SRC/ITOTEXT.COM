$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-11-21 17:58:02.000000000 +0000
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
$!	  Created				 	TJH 05-Nov-1986
$!
$!MOD     New routine CB stuff and shareable libraries MWSR    Nov-1987
$!MOD	  Changed the build directory for CMS		 ST 27-Jul-1993
$!MOD1387 Add I2TABS to format absolute numbers		 JB 01-Aug-1994
$!MOD1432 Use new frtshr				 JB 21-Nov-1994
$!
$! Command file for building ITOTEXT
$!
$	on error then goto itotextex
$	on control_y then exit
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$itotext_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$ a0:	on control_y then goto itotextex
$	define/group lsl$itotext_building "in_progress"
$	open/write comfil itotextbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$	set noverify"
$	wc	"$	on control_y then goto itotextex"
$	wc	"$	if ""'","'f$logical(""lsl$itotext_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$ a0:	define/group lsl$itotext_building ""in_progress"""
$	wc	"$	assign lsl$source_root:[imp.itotext.src] lsl$cmnitotext"
$	wc	"$	sd:=$lsl$sys:sd"
$	wc	"$	set noon"
$	wc	"$	emsg="""""
$!
$	fortdeb=""
$	macdeb=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile? "
$	if .not.compile then goto a04
$	inquire/nop itotext_dbg "With Debug? "
$	if .not. itotext_dbg then goto a04
$	   fsw1="/debug"
$	   fortdeb="/debug"
$	   macdbg="/enable=dbg"
$	   inquire/nop answer "Without optimisation? "
$	   if answer then fsw1=fsw1 + "/noopt"
$	   inquire/nop answer "Check bounds and overflow? "
$	   if answer then fsw1=fsw1 + "/check=(bounds,overflow)"
$	   inquire/nop answer "With listings ? "
$	   if answer then fsw1=fsw1 + "/list"
$	   inquire/nop answer "Keep FORtran sources with comments? "
$	   if answer then kpcom="/co"
$ a04:
$	   inq/nop cld "Compile CLD modules? "
$	   if .not.compile then goto a11
$!
$	   inq/nop macbld  "Compile Macro sources? "
$!
$	   inq/nop everything "Compile all FORTRAN sources? "
$	   if .not. everything then goto a05
$!
$	   appang = "t"
$	   appdat = "t"
$	   appflt = "t"
$	   bintod = "t"
$	   cvtang = "t"
$	   expflt = "t"
$	   i2tabs = "t"
$	   i2tasc = "t"
$	   i2tcom = "t"
$	   i2tent = "t"
$	   i2tcb  = "t"
$	   i2tli8 = "t"
$	   i2tlin = "t"
$	   i2tmht = "t"
$	   itotext = "t"
$	   wrtang = "t"
$	   wrtdat = "t"
$!
$	   macbld = "t"
$	   goto a11
$!
$ a05:
$	   INQ/NOP ITOTEXT "Compile ITOTEXT? "
$	   INQ/NOP APPANG "Compile APPANG? "
$	   INQ/NOP APPDAT "Compile APPDAT? "
$	   INQ/NOP APPFLT "Compile APPFLT? "
$	   INQ/NOP BINTOD "Compile BINTOD? "
$	   INQ/NOP CVTANG "Compile CVTANG? "
$	   INQ/NOP EXPFLT "Compile EXPFLT? "
$	   INQ/NOP I2TABS "Compile I2TABS? "
$	   INQ/NOP I2TASC "Compile I2TASC? "
$	   INQ/NOP I2TCOM "Compile I2TCOM? "
$	   INQ/NOP I2TENT "Compile I2TENT? "
$	   INQ/NOP I2TCB  "Compile I2TCB? "
$	   INQ/NOP I2TLI8 "Compile I2TLI8? "
$	   INQ/NOP I2TLIN "Compile I2TLIN? "
$	   INQ/NOP I2TMHT "Compile I2TMHT? "
$	   INQ/NOP WRTANG "Compile WRTANG? "
$	   INQ/NOP WRTDAT "Compile WRTDAT? "
$!
$ a11:	   inq/nop mes "Generate message definitions? "
$
$	   inquire/nop lnkit "Link? "
$	   if .not. lnkit then goto notkb
$
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   inquire/nop answer "Cross reference map? "
$	   if answer then linkopts=linkopts+"/cross"
$!
$	   linkver="itotext
$	   inquire/nop answer "Experimental version? 
$	   if answer then linkver="itotextx"
$!
$ notkb:
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$ 		if .not.mes then goto nomes
$		wc "$	newmsg/number=1216/name=itotext/prefix=itotext__/par=for/runoff/hl=2 itotext.mes"
$		wc "$ @itotext.temp_com"
$!
$ nomes:   if .not. cld then goto fortonly
$		wc "$ 	adc itotext.tmp=itotext.cld"
$		wc "$ 	set command/object=itotext_cld itotext.tmp"
$	      	wc "$ 	ok=$status"	
$		wc "$ 	if ok then pvv itotext_cld"
$		wc "$ 	if ok then delete itotext.tmp;*"
$		wc "$ 	if ok then purge/nolog itotext_cld.obj"
$	
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. macbld then goto fort_cmds
$		wc "$	macro'macdbg'/object=i2tcmd i2tcmd"
$		wc "$	ok=$status"
$		wc "$	pur/nolog i2tcmd.obj"
$		wc "$	if .not.ok then emsg=emsg+"" macro-i2tcmd"""
$!
$ fort_cmds:
$	   if itotext then call compiler itotext 
$	   if appang then call compiler appang 
$	   if appdat then call compiler appdat 
$	   if appflt then call compiler appflt 
$	   if bintod then call compiler bintod 
$	   if cvtang then call compiler cvtang 
$	   if expflt then call compiler expflt 
$	   if i2tabs then call compiler i2tabs
$	   if i2tasc then call compiler i2tasc 
$	   if i2tcom then call compiler i2tcom 
$	   if i2tcb  then call compiler i2tcb
$	   if i2tent then call compiler i2tent 
$	   if i2tli8 then call compiler i2tli8 
$	   if i2tlin then call compiler i2tlin 
$	   if i2tmht then call compiler i2tmht 
$	   if wrtang then call compiler wrtang 
$	   if wrtdat then call compiler wrtdat 
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ compiler: subroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$!
$	wc "$	set noverify"
$	wc "$	if emsg.eqs."""" then goto noerr
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	write sys$output "" Compilation errors in:"""
$	wc "$	write sys$output emsg"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	noerr: set verify"
$	wc "$	link''linkopts'/exe=''linkver' -"
$	wc "	itotext,itotext_cld, -"
$	wc "	i2tcmd,appang,appdat,appflt,bintod,cvtang,-"
$	wc "	expflt,i2tabs,i2tasc,i2tcom,i2tent,i2tli8,-"
$	wc "	i2tlin,i2tmht,wrtang,wrtdat,i2tcb,-"
$	wc "	itotext.promsg_obj,-"
$	wc "    lsl$library:frtshr/opt,-"
$	wc "    lsl$library:iffshr/opt,-"
$	wc "    lsl$library:lslshr/opt"
$!
$ nolnk:
$	wc "$	itotextex:"
$	wc "$ 	deass/group lsl$itotext_building"
$	wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto itotextex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch? "
$	if .not. answer_bat then goto int
$	deass/group lsl$itotext_building
$	bat itotextbat.com
$	goto itotextx2
$!
$ int:	
$	if ok then inq/nop answer "Interactive? "
$	if .not.answer then goto itotextex
$	deass/group lsl$itotext_building
$	@itotextbat.com
$	goto itotextx2
$!
$ itotextex:
$	deass/group lsl$itotext_building
$!
$ itotextx2:
$	if ver then set verify
$!
