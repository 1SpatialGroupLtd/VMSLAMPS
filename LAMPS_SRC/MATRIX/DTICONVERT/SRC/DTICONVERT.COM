$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1996-01-12 11:22:10.000000000 +0000
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
$! 	command file to compile and link DTICONVERT
$! 	DTI format conversion program.
$!
$!	MOD1517 Add LSL$LIBRARY:LSLDLMSLIB for ADDANG routine	JB 10-Jan-1996
$!
$	set noverify
$!
$	def 	lsl$matrixsys	lsl$source_root:[matrix.service]
$!
$	dbg := ""
$	deb := ""
$!
$	inquire ans "Compile/link with debug? "
$!
$	if ans then dbg := /debug
$	if ans then deb := /debug/noopt/check=(b,o)/lis
$!
$	inquire main "main"
$       inquire copy "copy_bit,copy_byte,copy_word,copy_long,copy_real"
$	inquire mar "mar"
$	inquire lnk "link"
$!
$	testtab = 0
$	tablib = "lsl$library:tablib"
$!
$	set verify
$!
$ 	if .not. main then goto nomain
$	adc dticonvert = dticonvert
$	fort 'deb' dticonvert
$	pvv dticonvert
$	delete adc.ide;*
$	pur dticonvert.*
$!
$ nomain: if .not. copy then goto nocopy
$       adc copy = copy_bit,copy_byte,copy_word,copy_long,copy_real
$       fort 'deb' copy
$       pvv copy
$       delete adc.ide;*
$       pur copy.*
$!
$ nocopy: if .not. mar then goto link
$	macro dticmd + lsl$library:lslmaclib/lib
$	pur dticmd.obj
$!
$ link: if .not.lnk then goto nolnk
$	run lsl$exe:genver
$	adc version=version
$	fort version
$	pvv version
$       delete adc.ide;*
$	purge version.*
$!
$	link'dbg'/map	dticonvert,copy,dticmd,version,-
			lsl$matrixsys:matrix/lib,-
			lsl$library:dtilib/lib,-
			lsl$library:lsldlmslib/lib,-
			lsl$library:lslshr/opt
$	pur *.map
$	if deb .nes. "" then pur *.lis
$!
$nolnk:	set noverify
$!
