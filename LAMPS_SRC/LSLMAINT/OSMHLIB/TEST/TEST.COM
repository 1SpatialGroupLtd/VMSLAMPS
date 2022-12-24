$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-10-21 13:58:24.000000000 +0100
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
$!!!!!	set noverify            
$	on control_y then goto exit_neatly
$	on error     then goto exit_neatly
$!
$! command file: OSMH - a command file to compile the OSMH routines
$!
$! Copyright (C) LaserScan Laboratories Ltd, Cambridge, England
$!
$! Author S Townrow, 28 August 1990
$!
$! *************************************************************************
$!
$!	Logical name to point to directory for common blocks, message
$!	and parameter files
$!
$	assign  'f$logical("HERE")  start_directory
$!
$	ws  = "write sys$output "
$	wsb = "write sys$output """""
$!
$	inquire COMP   "Compile                            "
$	if COMP.eqs."" then P1 = "N"
$  	inquire CDEBUG  "With debug                         "
$	if CDEBUG.eqs."" then P1 = "N"
$!
$	wsb
$	inquire MAIN   "TEST                               "
$!
$	wsb
$	inquire DO_LINK   "Link                               "
$	if DO_LINK .eqs."" then P1 = "N"
$ 	inquire LDEBUG  "With debug                         "
$	if LDEBUG.eqs."" then P1 = "N"
$!
$	ldbg = ""
$	dbg = ""
$	pd  = "delete/noconfirm"
$	ver = ";*"
$	if CDEBUG then dbg = "/debug/noopt"
$	if LDEBUG then ldbg = "/debug"
$	if CDEBUG then pd  = "purge"
$	if CDEBUG then ver = ""
$!
$!!!	set noverify
$	if .not.COMP then goto doLINK
$	ws "Compiling..."
$!
$	if .not.MAIN then goto noMAIN
$	   ws 			"TEST"
$	   adc			TEST/co = TEST!, -
$!				[-.osmh_new]osmh_new_ini
$!				[-.osmh_new]osmh_new_inqtable
$!				[-.osmh_new]osmh_new_getfld, -
$!				[-.osmh_new]osmh_new_putint, -
$!				[-.osmh_new]osmh_new_putstr
$	   fort/extend'dbg'	TEST
$	   pvv			TEST
$	   purge		TEST.obj
$	   delete/noconfirm	adc.ide;*
$	   'pd'			TEST.for'ver'
$noMAIN:
$doLINK:
$	if .not.DO_LINK then goto noLINK
$	ws "Linking..."
$	ws "TEST"
$	link'ldbg'		TEST, -
		lsl$source_root:[lslmaint.osmhlib]osmhlib/lib,-
				lsl$library:lsllib/lib
$!
$!				lsl$library:osmhlib/include=osmhlib/lib
$! This went wrong unless linked against library rather than shared image???
$! WAS->			lsl$library:lslshr/opt
$	purge test.*
$noLINK:
$!
$!
$exit_neatly:
$!!!	set noverify
