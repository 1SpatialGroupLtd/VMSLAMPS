$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-01-03 14:36:24.000000000 +0000
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
$! command file to build the TABLE_MONITOR test image for the library
$! routines
$!
$	set noverify
$!
$! set up where we keep our common files
$!
$	assign	lsl$source_root:[table.shared]  cmn
$!
$	on control then goto end
$	on error then goto end
$!
$! assume we don't want debug
$	dbug   = ""
$	lbug   = ""
$	retfor = ""
$!
$	ws = "write sys$output"
$!
$! now find out what we wish to do...
$!
$	inquire CMP  "compile                 "
$	inquire DBG  "debug                   "
$	if .not.CMP then goto asklnk
$	if .not.DBG then goto nod
$	   dbug = "/debug/noop"
$	   lbug = "/debug"
$	   inquire retfor "retain fortran sources  "
$nod:	ws " "
$	inquire CMDS  "command tables         "
$	inquire TEST  "TEST                   "
$	ws " "
$!
$asklnk:inquire LNK  "link                    "
$	inquire TST  "use testing library     "
$	if      TST then lib_to_use := "lsl$disk:[tves.table.lib]tablib"
$	if .not.TST then lib_to_use := "lsl$library:tablib"
$!
$start:	set verify
$	if .not.CMP then goto dolnk
$	if .not.CMDS then goto nocmds
$	   macro'lbug' testcmd
$nocmds:if .not.TEST then goto notest
$	   adc test/co = test
$	   fort'dbug' test
$	   pvv test
$	   delete adc.ide;*
$	   if .not.RETFOR then delete test.for;*
$notest:
$dolnk:	if .not.LNK then goto end
$	   link/map'lbug'  test,testcmd,-
			   'lib_to_use'/lib,-
			   lsl$library:cmdlib/lib,-
			   lsl$library:violib/lib
$ end:	purge/log
$	set noverify
$!
$	ws " "
$	ws "Don't forget to rename TEST.EXE into [-.EXE]"
$	ws " "
$!
