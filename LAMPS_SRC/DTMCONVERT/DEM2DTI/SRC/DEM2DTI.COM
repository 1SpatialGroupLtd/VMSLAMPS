$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-09-29 14:11:50.000000000 +0100
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
$!	Copyright  Laser-Scan Ltd., Cambridge, England.
$!
$!	Created		APB	03-Oct-1989
$!
$!	Command procedure to build DEM2DTI in DTMCONVERT
$!
$!---------------------------------------------------------------------------
$!
$	set noverify
$!
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$!	logical name to point to directory for common blocks, message
$!	and parameter files
$!
$	define/nolog lsl$dem2dti here
$!
$	ws = "write sys$output"
$	wsb = "write sys$output """"
$	debug = "n"
$!
$	wsb
$	ws "Build of DTMCONVERT/DEM2DTI"
$	wsb
$	inquire/nopunct cld  "Command language definition ? "
$	inquire/nopunct msg  "Messages ? "
$	inquire/nopunct cmp "Compile ? "
$	if .not.cmp then goto asklnk
$	inquire/nopunct debug "with debug ? "
$	if debug.eqs."" then debug = "n"
$	inquire/nopunct main "   Main routine (DEM2DTI) ? "
$	inquire/nopunct cmd  "   Command line (OBEY) ? "
$	inquire/nopunct fil  "   File handling (OPEN_FILES,CLOSE_FILES) ? "
$	inquire/nopunct dem  "   DEM file (DEM_SCAN,READ_RECA,READ_RECB) ? "
$	inquire/nopunct dti  "   DTI file (WRITE_DTI) ? "
$	inquire/nopunct blk  "   DEM block data (DEM_OFF) ? "
$asklnk:
$	inquire/nopunct lnk  "Link ? "
$	inquire/nopunct lbg  "with debug ? "
$	wsb
$!
$	ldbg="/map"
$	dbg = ""
$	pd  = "purge"
$	ver = ";*"
$	if lbg   then ldbg= "/debug"
$	if debug then dbg = "/debug/noopt"
$	if debug then pd  = "purge"
$	if debug then ver = ""
$!
$	if .not.cld then goto no_cld
$	   ws "Building command language definition..."
$	   ws "DEM2DTI_CLD.CLD"
$	   set command/object=DEM2DTI_CLD DEM2DTI_CLD
$	   purge DEM2DTI_CLD.OBJ
$no_cld:
$	if .not.msg then goto no_msg
$	   ws "Building messages..."
$	   ws "DEM2DTI.MES"
$	   newmsg  DEM2DTI /dti/number=1677/runoff
$	   @DEM2DTI.TEMP_COM
$	   purge DEM2DTIMSG.*
$no_msg:
$	if .not.cmp then goto do_link
$	ws "Compiling..."
$	if .not.main then goto no_main
$	   ws "DEM2DTI.F"
$	   fortran/extend'dbg' DEM2DTI.F
$	   purge DEM2DTI.*
$no_main:
$	if .not.cmd then goto no_cmd
$	   ws "OBEY.F"
$	   fortran/extend'dbg' OBEY.F
$	   purge OBEY.*
$no_cmd:
$	if .not.fil then goto no_fil
$	   ws "OPEN_FILES.F"
$	   fortran/extend'dbg' OPEN_FILES.F
$	   ws "CLOSE_FILES.F"
$	   fortran/extend'dbg' CLOSE_FILES.F
$	   purge OPEN_FILES.*
$	   purge CLOSE_FILES.*
$no_fil:
$	if .not.dem then goto no_dem
$	   ws "DEM_SCAN.F"
$	   fortran/extend'dbg' DEM_SCAN.F
$	   ws "READ_RECA.F"
$	   fortran/extend'dbg' READ_RECA.F
$	   ws "READ_RECB.F"
$	   fortran/extend'dbg' READ_RECB.F
$	   purge DEM_SCAN.*
$	   purge READ_RECA.*
$	   purge READ_RECB.*
$no_dem:
$	if .not.dti then goto no_dti
$	ws "WRITE_DTI.F"
$	fortran/extend'dbg' WRITE_DTI.F
$	purge WRITE_DTI.*
$no_dti:
$	if .not.blk then goto no_blk
$	   ws "DEM_OFF.F"
$	   fortran/extend'dbg' DEM_OFF.F
$	   purge DEM_OFF.*
$no_blk:
$!
$do_link:
$	if .not.lnk then goto exit_neatly
$!
$	ws "Linking..."
$	ws "DEM2DTI"
$	link'ldbg'	DEM2DTI,OBEY, -
			OPEN_FILES,CLOSE_FILES, -
			DEM_SCAN,READ_RECA,READ_RECB, -
			WRITE_DTI, -
			DEM_OFF, -
			DEM2DTI_CLD, -
 			DEM2DTI.PROMSG_OBJ, -
			lsl$library:dtilib/lib, -
			lsl$library:lslshr/opt
$	purge DEM2DTI.*
$exit_neatly:
$	set noverify
$!
