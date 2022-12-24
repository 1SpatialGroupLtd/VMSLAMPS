$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-05-14 10:59:06.000000000 +0100
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
$	set noverify
!	
!
!	Copyright               Laser-Scan Ltd., Cambridge, England.
!
!	Created					ST	22-Apr-1991
!
! Description:
!
!	Command procedure to build jiffy i2GEN
!
!-------------------------------------------------------------------------------
$!
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$	ws = "write sys$output"
$	wsb = "write sys$output """"
$	debug = "N"
$!
$	wsb
$	ws "Building ARC2I"
$	wsb
$	inquire/nopunct cmp    "Compile ?                     "
$	if .not.cmp then goto asklnk
$	inquire/nopunct debug  "with debug ?                  "
$	if debug.eqs."" then debug = "N"
$	wsb
$	inquire/nopunct cld    "Command language definition ? "
$	wsb
$	inquire/nopunct main   "I2GEN ?                       "
$	inquire/nopunct cmd    "CMDLIN ?                      "
$	inquire/nopunct get    "GET_FILES ?                   "
$	inquire/nopunct rdpar  "RD_PAR ?                      "
$	inquire/nopunct proc   "PROCESS ?                     "
$	wsb
$asklnk:
$	inquire/nopunct lnk    "Link ?                        "
$	inquire/nopunct lbg    "with debug ?                  "
$	wsb
$!
$	ldbg="/map"
$	dbg = ""
$	mbug = ""
$	pd  = "delete/nocon"
$	ver = ";*"
$	if lbg   then ldbg= "/debug"
$	if debug then dbg = "/debug/noopt/check"
$	if debug then mbug = "/debug"
$	if debug then pd  = "purge"
$	if debug then ver = ""
$!
$!
$	set verify
$	if .not.cmp then goto do_link
$!
$	if .not.cld then goto no_cld
$	   set command/object =	I2GEN_CLD  I2GEN
$	   purge		I2GEN_CLD.OBJ
$no_cld:
$	if .not.main then goto no_main
$	   fortran/extend'dbg'	I2GEN.F
$	   purge		I2GEN.*
$no_main:
$	if .not.cmd then goto no_cmd
$	   fortran/extend'dbg'	CMDLIN.F
$	   purge		CMDLIN.*
$no_cmd:
$	if .not.get then goto no_get
$	   fortran/extend'dbg'	GET_FILES.F
$	   purge		GET_FILES.*
$no_get:
$	if .not.rdpar then goto no_rdpar
$	   fortran/extend'dbg'	RD_PAR.F
$	   purge		RD_PAR.*
$!	   macro'mbug''list'	PARCMD
$!	   append PARCMD.obj	RD_PAR.obj
$!	   purge		RD_PAR.obj
$!	   delete/nocon		PARCMD.obj;*
$no_rdpar:
$	if .not.proc then goto do_link
$	   fortran/extend'dbg'	PROCESS.F
$	   purge		PROCESS.*
$do_link:
$	if .not.lnk then goto exit_neatly
$!
$	ws "Linking..."
$	ws "I2GEN"
$	link'ldbg'	I2GEN,-
			I2GEN_CLD,-
			CMDLIN,GET_FILES,RD_PAR,PROCESS,-
			lsl$library:iffshr/opt,-
			lsl$library:lslshr/opt
$	purge I2GEN.*
$exit_neatly:
$	set noverify
