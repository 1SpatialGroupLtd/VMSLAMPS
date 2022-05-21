$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-02-12 16:16:08.000000000 +0000
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
$! Command file to build utility UILGEN
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$	ver=f$verify(0)
$!
$	on error then goto uilgenex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$uilgen_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto uilgenex
$	define/group lsl$uilgen_building "in_progress"
$	open/write comfil uilgenbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto uilgenex"
$	wc "$	if ""'","'f$logical(""lsl$uilgen_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$uilgen_building ""in_progress"""
$	wc "$	assign lsl$source_root:[lites2.motif.uilgen] lsl$cmnuilgen"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	uilgen_dbg=""
$	macbuild=""
$	cld=""
$	mes=""
$	inquire/nop compile "Compile FORTRAN ? "
$	inq/nop cld "Compile CLD module ? "
$	inq/nop mes "Generate message definitions ? "
$	inq/nop mac "Macro command table? "
$	if .not.compile then goto a11
$	inquire/nop uilgen_dbg "Compile with Debug ? "
$	if uilgen_dbg 
$	then
$	   fsw1="/debug/noopt"
$	   mldbg="/debug"
$	   inquire/nop answer "Check bounds and overflow ? "
$	   if answer then fsw1=fsw1 + "/check=(bounds,overflow)"
$	endif
$!
$	if .not.compile then goto a11
$!
$	inq/nop everything "Compile all sources ? "
$	if everything
$	then
$	   cld_init="t"
$	   uilgen="t"
$	   init_uil="t"
$	   process_icon="t"
$	   process_file="t"
$	   write_callback="t"
$	   write_uil="t"
$!
$	else
$!
$	   ws " "
$ 	   inq/nop cld_init	"Compile CLD_INIT ? "
$ 	   inq/nop uilgen	"Compile UILGEN ? "
$ 	   inq/nop init_uil	"Compile INIT_UIL ? "
$ 	   inq/nop process_icon	"Compile PROCESS_ICON ? "
$ 	   inq/nop process_file	"Compile PROCESS_FILE ? "
$ 	   inq/nop write_callback "Compile WRITE_CALLBACK ? "
$ 	   inq/nop write_uil	"Compile WRITE_UIL ? "
$	endif
$ a11:
$!
$	inquire/nop lnk "Link ? "
$	if lnk
$	then
$	   inquire/nop ldb "Link with debug ? "
$	   lqual = ""
$	   if ldb then lqual="/deb"
$	endif
$!
$	if cld
$	then
$		wc "$ 		adc uilgen.tmp=uilgen_cld.cld"
$		wc "$ 		set command/object=uilgen_cld uilgen.TMP"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv uilgen_cld"
$	      	wc "$ 		ok=$status"	
$		wc "$! "
$	endif
$!
$ 	if mes
$	then
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 	set verify"
$		wc "$	newmsg/number=1174/name=uilgen/prefix=uilgen__/parameter=for/runoff uilgen.mes"
$		wc "$ @uilgen.temp_com"
$		wc "$ 	set noverify"
$	endif
$!
$ 	if mac
$	then
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 	set verify"
$		wc "$	macro uilgencmd"
$		wc "$	purge/nolog uilgencmd.obj"
$		wc "$ 	set noverify"
$	endif

$!	
$ cmponly: if .not. compile then goto lnkonly
$	if cld_init then call compiler cld_init
$	if uilgen then call compiler uilgen
$	if init_uil then call compiler init_uil
$	if process_icon then call compiler process_icon
$	if process_file then call compiler process_file
$	if write_callback then call compiler write_callback
$	if write_uil then call compiler write_uil
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ compiler: subroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$		wc "$ 	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc ''p1'=''p1'"
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
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ lnkonly:
$!
$	if lnk
$	then
$		wc "$	set verify"
$		wc "$	link/exe=UILGENMOTIF ''lqual' uilgen, -
$		wc "	uilgencmd, -"
$		wc "	cld_init, -"
$		wc "	init_uil, -"
$		wc "	process_file, -"
$		wc "	process_icon, -
$		wc "	write_callback, -"
$		wc "	write_uil, -"
$		wc "	uilgen_cld, -"
$		wc "	uilgen.promsg_obj, -"
$		wc "	lsl$library:lslshr/opt"
$		wc "$	purge/nolog uilgenmotif.*"
$		wc "$	set noverify"
$	endif
$!
$	wc "$	if emsg.eqs."""" then goto noerr"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	write sys$output ""Compilation errors in:"""
$	wc "$	write sys$output emsg"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	noerr:"
$	wc "$   uilgenex:"
$	wc "$ 	deass/group lsl$uilgen_building"
$	wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto uilgenex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$uilgen_building
$	bat uilgenbat.com
$	goto uilgenx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto uilgenex
$	deass/group lsl$uilgen_building
$	@uilgenbat.com
$	goto uilgenx2
$ uilgenex:
$	deass/group lsl$uilgen_building
$ uilgenx2:
$	if ver then set verify
