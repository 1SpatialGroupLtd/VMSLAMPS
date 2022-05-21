$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-04-29 17:07:44.000000000 +0100
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
$! 	Command file to build MATRIX utility DTI2TEXT
$!
$! 	Copyright Laser-Scan Limited, Cambridge, England.
$!
$!	Created						TJH 12-Jan-1987
$!
$	ver=f$verify(0)
$!
$	on error then goto dti2textex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$dti2text_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	on control_y then goto dti2textex
$	define/group lsl$dti2text_building "in_progress"
$	open/write comfil dti2textbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto dti2textex"
$	wc "$	if ""'","'f$logical(""lsl$dti2text_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$dti2text_building ""in_progress"""
$	wc "$	assign here				lsl$cmndti2text"
$	wc "$	assign lsl$source_root:[matrix.service] lsl$matrixsys"
$	wc "$	assign lsl$source_root:[matrix.service] lsl$dtmcreatesys"
$	wc "$	sd:=$lsl$sys:sd"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	dti2text_dbg=""
$	macbuild=""
$	mes=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop dti2text_dbg "With Debug ? "
$	if .not. dti2text_dbg then goto a04
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
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all sources ? "
$	   if .not. everything then goto a05
$!
$	CHECK_FORMAT	="t"
$	CONVERT_CMD	="t"
$	DISABLE_CMD	="t"
$	ENABLE_CMD	="t"
$	FILEIN_CMD	="t"
$	FILEOUT_CMD	="t"
$	GET_CMDS	="t"
$	HELP_CMD	="t"
$	DTI2TEXT	="t"
$	OPNDTI		="t"
$	READLL		="t"
$	SHOW_CMD	="t"
$	UNITS_CMD	="t"
$	WINDOW_CMD	="t"
$	FORMAT_CMD	="t"
$	NULL_CMD	="t"
$	PARSE_FORMAT	="t"
$	TEXT_OUTPUT	="t"
$	BNULL_SUBST	="t"
$	LNULL_SUBST	="t"
$	RNULL_SUBST	="t"
$	WNULL_SUBST	="t"
$	macbuild	="t"
$	goto a11
$!
$ a05:	   
$	ws " "
$	ws ".............................MACRO32 stuff"
$	inq/nop macbuild	"Compile command table? "
$	ws " "
$	ws ".............................FORTRAN sources"
$	inq/nop check_format 	"check_format? "
$	inq/nop convert_cmd 	"convert_cmd?"
$	inq/nop format_cmd 	"format_cmd? "
$	inq/nop null_cmd 	"null_cmd? "
$	inq/nop parse_format 	"parse_format? "
$	inq/nop text_output 	"text_output? "
$	inq/nop bnull_subst 	"bnull_subst? "
$	inq/nop lnull_subst 	"lnull_subst? "
$	inq/nop rnull_subst 	"rnull_subst? "
$	inq/nop wnull_subst 	"wnull_subst? "
$	inq/nop disable_cmd 	"disable_cmd? "
$	inq/nop dti2text 	"dti2text? "
$	inq/nop duplic 		"duplic? "
$	inq/nop enable_cmd 	"enable_cmd? "
$	inq/nop filein_cmd 	"filein_cmd? "
$	inq/nop fileout_cmd 	"fileout_cmd? "
$	inq/nop get_cmds 	"get_cmds? "
$	inq/nop help_cmd 	"help_cmd? "
$	inq/nop opndti 		"opndti? "
$	inq/nop readll 		"readll? "
$	inq/nop show_cmd 	"show_cmd? "
$	inq/nop units_cmd 	"units_cmd? "
$	inq/nop window_cmd 	"window_cmd? "
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
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!	   
$	   linkver="dti2text"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="dti2textx"
$!
$	   if .not. compile then goto lnkonly
$!
$ notkb:
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$ 		if .not. mes then goto cmponly
$		wc "$ newmsg/dti/number=1642/prefix=d2t__ -"
$		wc "	/parameter=for/runoff dti2text.mes"
$		wc "$ @dti2text.temp_com"
$!
$ cmponly:
$	mdeb=""
$	if dti2text_dbg then mdeb = "/Enable=debug"
$	if .not. macbuild then goto for2
$	wc "$	macro''mdeb' dti2text_cmdtab"
$ for2: if .not. compile then goto lnkonly
$!
$	if check_format 	then call compiler check_format
$	if convert_cmd 		then call compiler convert_cmd
$	if format_cmd 		then call compiler format_cmd
$	if null_cmd 		then call compiler null_cmd
$	if parse_format 	then call compiler parse_format
$	if text_output 		then call compiler text_output
$	if bnull_subst 		then call compiler bnull_subst
$	if lnull_subst 		then call compiler lnull_subst
$	if rnull_subst 		then call compiler rnull_subst
$	if wnull_subst 		then call compiler wnull_subst
$	if disable_cmd 		then call compiler disable_cmd
$	if dti2text 		then call compiler dti2text
$	if enable_cmd 		then call compiler enable_cmd
$	if filein_cmd 		then call compiler filein_cmd
$	if fileout_cmd 		then call compiler fileout_cmd
$	if get_cmds 		then call compiler get_cmds
$	if help_cmd 		then call compiler help_cmd
$	if opndti 		then call compiler opndti
$	if readll 		then call compiler readll
$	if show_cmd 		then call compiler show_cmd
$	if units_cmd 		then call compiler units_cmd
$	if window_cmd 		then call compiler window_cmd
$!
$       goto lnkonly
$!
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
$	wc "$ 	link''linkopts'/exe=''linkver' dti2text/opt, -"
$	wc "		lsl$library:lslshr/opt"
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	dti2textex:"
$		wc "$ 	deass/group lsl$dti2text_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto dti2textex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$dti2text_building
$	bat dti2textbat.com
$	goto dti2textx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto dti2textex
$	deass/group lsl$dti2text_building
$	@dti2textbat.com
$	goto dti2textx2
$ dti2textex:
$	deass/group lsl$dti2text_building
$ dti2textx2:
$	if ver then set verify
$!
