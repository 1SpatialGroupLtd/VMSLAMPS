$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-12-21 15:07:56.000000000 +0000
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
$! Command file to build srp2dti
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!	Created						IDJ 13-Sep-88
$!
$	ver=f$verify(0)
$	set noverify
$!
$	on error then goto srp2dtiex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$srp2dti_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto srp2dtiex
$	define/group lsl$srp2dti_building "in_progress"
$	open/write comfil srp2dtibat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto srp2dtiex"
$	wc "$	if ""'","'f$logical(""lsl$srp2dti_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$srp2dti_building ""in_progress"""
$	wc "$	assign lsl$source_root:[imageprocess.srp2dti] lsl$cmnsrp2dti"
$	wc "$	assign lsl$source_root:[tves.service] lsl$tvessys"
$	wc "$	assign lsl$source_root:[dtmcreate.service] lsl$dtmcreatesys"
$	wc "$	sd:=$lsl$sys:sd"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	srp2dti_dbg=""
$	macbuild=""
$	mes=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop srp2dti_dbg "With Debug ? "
$	if .not. srp2dti_dbg then goto a04
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
$	   inq/nop cld "Compile CLD module ? "
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all sources ? "
$	   if .not. everything then goto a05
$	SRP2DTI	= "t"
$	OPNDTI	= "t"
$	LSL_TAPE_SETUP = "t"
$	LSL_TAPE_CLOSEDOWN = "t"
$	LSL_TAPE_CLOSE = "t"
$	ADCS_HELLMCE  = "t"
$	HELLMCE_HEADER  = "t"
$	ADCS_MTALLOC  = "t"
$	ADCS_MTDEALLOC  = "t"
$	RDPHYSICAL  = "t"
$	MTTEST 	 = "t"
$	FLINIT  = "t"
$	FLIRDB  = "t"
$	FLIRWD  = "t"
$	FLCLOS  = "t"
$	MXINIT  = "t"
$	MXIRDB  = "t"
$	MXIRWD  = "t"
$	FRAMED_MES = "t"
$	PERCENT = "t"
$!
$	macbuild="t"
$	goto a11
$ a05:	   
$	ws " "
$	ws ".............................MACRO32 stuff"
$	   inq/nop macbuild	"Compile MACRO sources ? "
$	ws " " 
$	ws ".............................FORTRAN sources"
$!
$	inq/nop SRP2DTI "SRP2DTI ?"
$	inq/nop OPNDTI "OPNDTI ?"
$	inq/nop LSL_TAPE_SETUP "LSL_TAPE_SETUP? "
$	inq/nop LSL_TAPE_CLOSEDOWN "LSL_TAPE_CLOSEDOWN? "
$	inq/nop LSL_TAPE_CLOSE "LSL_TAPE_CLOSE? "
$	inq/nop ADCS_HELLMCE "ADCS_HELLMCE? "
$	inq/nop HELLMCE_HEADER "HELLMCE_HEADER? "

$	inq/nop ADCS_MTALLOC "ADCS_MTALLOC? "
$	inq/nop ADCS_MTDEALLOC "ADCS_MTDEALLOC? "
$	inq/nop RDPHYSICAL "RDPHYSICAL? "
$	inq/nop	MTTEST "MTTEST? "	
$	inq/nop FLINIT "FLINIT? "
$	inq/nop FLIRDB "FLIRDB? "
$	inq/nop FLIRWD "FLIRWD? "
$	inq/nop FLCLOS "FLCLOS? "
$	inq/nop MXINIT "MXINIT? "
$	inq/nop MXIRDB "MXIRDB? "
$	inq/nop MXIRWD "MXIRWD? "
$	inq/nop FRAMED_MES "FRAMED_MES? "
$	inq/nop PERCENT "PERCENT? "
$!
$!
$ a11:
	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkver="srp2dti"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="srp2dtix"
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!	   
$	   if .not. compile then goto lnkonly
$!
$ notkb:
$		wc "$ 	set noverify"
$		wc "$   write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 	set verify"
$ 		if .not.mes then goto nomess
$!
$!		wc  "$	newmsg := "$lsl$exe:newmsg.exe" "
$		wc  "$	newmsg srp2dti.mes/number=1025/parameters=(f)/runoff"
$		wc  "$	@srp2dti.temp_com"
$		wc  "$	pur srp2dtimsg.rno"
$!
$ nomess:
$		if .not. cld then goto fortonly
$		wc "$ 		adc srp2dti.tmp=srp2dti_cld.cld"
$		wc "$ 		set command/object=srp2dti_cld srp2dti.tmp"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv srp2dti_cld"
$		wc "$		purge srp2dti_cld.obj"
$		wc "$		delete/noconf srp2dti.tmp;*"
$		wc "$		delete/noconf adc.ide;*"
$	      	wc "$ 		ok=$status"	
$		wc "$! "
$!
$ fortonly:		
$	mdeb=""
$	if srp2dti_dbg then mdeb = "/Enable=debug"
$	if .not. macbuild then goto for2
$		wc "$	mac''mdeb' UNRUN"
		wc "$	mac''mdeb' REVB"
		wc "$	mac''mdeb' UNRUN_COLOUR"
$!
$ for2: if .not. compile then goto lnkonly
$!
$	if  SRP2DTI then call compiler SRP2DTI
$	if  OPNDTI then call compiler OPNDTI
$	if  LSL_TAPE_SETUP then call compiler LSL_TAPE_SETUP
$	if  LSL_TAPE_CLOSEDOWN then call compiler LSL_TAPE_CLOSEDOWN
$	if LSL_TAPE_CLOSE then call compiler LSL_TAPE_CLOSE
$	if  ADCS_HELLMCE then call compiler ADCS_HELLMCE
$	if  HELLMCE_HEADER then call compiler HELLMCE_HEADER 
$	if  ADCS_MTALLOC then call compiler ADCS_MTALLOC 
$	if  ADCS_MTDEALLOC then call compiler ADCS_MTDEALLOC 
$	if  RDPHYSICAL then call compiler RDPHYSICAL 
$	if  MTTEST then call compiler MTTEST
$	if  FLINIT then call compiler FLINIT 
$	if  FLIRDB then call compiler FLIRDB 
$	if  FLIRWD then call compiler FLIRWD 
$	if  FLCLOS then call compiler FLCLOS 
$	if  MXINIT then call compiler MXINIT 
$	if  MXIRDB then call compiler MXIRDB 
$	if  MXIRWD then call compiler MXIRWD 
$	if  FRAMED_MES then call compiler FRAMED_MES
$	if  PERCENT then call compiler PERCENT
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
$	wc "$ 	adc version''kpcom'=version"
$   	wc "$	fort''fsw1' version"
$      	wc "$ 	ok=$status"	
$	wc "$ 	if ok then pvv version"
$	wc "$ 	purge/nolog version.obj"
$	if fsw1.eqs."" then -
		wc "$ 	delete/nolog version.for;*"
$	if fsw1.nes.""  then -
		wc "$ 	purge/nolog version.for"
$	if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
	wc "$ 	if ok then delete/nolog version.lis;*"
$	wc "$	if .not.ok then emsg=emsg+"" version"""
$	wc "$ 	delete adc.ide;*"
$	wc "$ 	purge/nolog version.src"
$	wc "$ set verify"
$	wc "$ 	link''linkopts'/exe=''linkver' srp2dti/opt,lsl$library:lslshr/opt"
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	srp2dtiex:"
$		wc "$ 	deass/group lsl$srp2dti_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto srp2dtiex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$srp2dti_building
$	inq/nop answer_fast "fastbatch ? "
$	if .not. answer_fast then goto slobat
$	submit/queue=fastbatch srp2dtibat.com
$	goto srp2dtiex2
$ slobat: 
$	bat srp2dtibat.com
$	goto srp2dtiex2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto srp2dtiex
$	deass/group lsl$srp2dti_building
$	@srp2dtibat.com
$	goto srp2dtiex2
$ srp2dtiex:
$	deass/group lsl$srp2dti_building
$ srp2dtiex2:
$	purge srp2dtibat.com
$	purge *.*obj
$	if ver then set verify
$!
