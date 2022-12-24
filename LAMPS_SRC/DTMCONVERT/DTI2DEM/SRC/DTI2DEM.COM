$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-09-29 14:28:28.000000000 +0100
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
!
!	Copyright (C) Laser-Scan Ltd., Cambridge, England.
!
!	Created					APB	17-Oct-1989
!
!	Command procedure to build DTI2DEM in DTMCONVERT
!
!-------------------------------------------------------------------------------
$!
$	set noverify
!	
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$!	logical name to point to directory for common blocks, message
$!	and parameter files
$!
$	define/nolog lsl$dti2dem here
$!
$	ws = "write sys$output"
$	wsb = "write sys$output """"
$	debug = "n"
$!
$!
$	wsb
$	ws "Build of DTMCONVERT/DTI2DEM"
$	wsb
$	inquire/nopunct cld  "Command language definition ? "
$	inquire/nopunct msg  "Messages ? "
$	inquire/nopunct cmp "Compile ? "
$	if .not.cmp then goto asklnk
$	inquire/nopunct debug "with debug ? "
$	if debug.eqs."" then debug = "n"
$	inquire/nopunct main "   Main routine (DTI2DEM) ? "
$	inquire/nopunct cmd  "   Command line (OBEY) ? "
$	inquire/nopunct fil  "   File handling (OPENOUT,CLSFIL) ? "
$	inquire/nopunct dem  "   DEM file (GETHDR,OUTDEM,OUTREC,OUTRECA) ? "
$	inquire/nopunct dti  "   DTI file (GETORG,GETSW,DTISCAN) ? "
$	inquire/nopunct blk  "   Block data (BLKDAT) ? "
$	inquire/nopunct mis  "   Miscellaneous (READLL,YBOUND) ? "
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
$	   ws "dti2dem_cld.cld"
$	   set command/object=dti2dem_cld dti2dem_cld
$	   purge dti2dem_cld.obj
$no_cld:
$	if .not.msg then goto no_msg
$	   ws "Building messages..."
$	   ws "dti2dem.mes"
$	   newmsg  dti2dem /dti/number=1678/runoff
$	   @dti2dem.temp_com
$	   purge dti2demmsg.*
$no_msg:
$	if .not.cmp then goto do_link
$	ws "Compiling..."
$	if .not.main then goto no_main
$	   ws "dti2dem.f"
$	   fortran/extend'dbg' dti2dem.f
$	   purge dti2dem.*
$no_main:
$	if .not.cmd then goto no_cmd
$	   ws "obey.f"
$	   fortran/extend'dbg' obey.f
$	   purge obey.*
$no_cmd:
$	if .not.fil then goto no_fil
$	   ws "openout.f"
$	   fortran/extend'dbg' openout.f
$	   purge openout.*
$	   ws "clsfil.f"
$	   fortran/extend'dbg' clsfil.f
$	   purge clsfil.*
$no_fil:
$	if .not.dem then goto no_dem
$	   ws "gethdr.f"
$	   fortran/extend'dbg' gethdr.f
$	   purge gethdr.*
$	   ws "outdem.f"
$	   fortran/extend'dbg' outdem.f
$	   purge outdem.*
$	   ws "outrec.f"
$	   fortran/extend'dbg' outrec.f
$	   purge outrec.*
$	   ws "outreca.f"
$	   fortran/extend'dbg' outreca.f
$	   purge outreca.*
$no_dem:
$	if .not.dti then goto no_dti
$	   ws "getorg.f"
$	   fortran/extend'dbg' getorg.f
$	   purge getorg.*
$	   ws "getsw.f"
$	   fortran/extend'dbg' getsw.f
$	   purge getsw.*
$	   ws "dtiscan.f"
$	   fortran/extend'dbg' dtiscan.f
$	   purge dtiscan.*
$no_dti:
$	if .not.blk then goto no_blk
$	   ws "blkdat.f"
$	   fortran/extend'dbg' blkdat.f
$	   purge blkdat.*
$no_blk:
$	if .not.mis then goto do_link
$	   ws "readll.f"
$	   fortran/extend'dbg' readll.f
$	   purge readll.*
$	   ws "ybound.f"
$	   fortran/extend'dbg' ybound.f
$	   purge ybound.*
$!
$do_link:
$	if .not.lnk then goto exit_neatly
$!
$	ws "Linking..."
$	ws "dti2dem"
$	link'ldbg'	dti2dem,obey, -
			openout,clsfil, -
	                gethdr,outdem,outrec,outreca, -
			getorg,getsw,dtiscan, -
			blkdat, -
	     		readll,ybound, -
			dti2dem_cld, -
 			dti2dem.promsg_obj, -
	                lsl$library:gctplib/lib, -
			lsl$library:dtilib/lib, -
			lsl$library:lslshr/opt
$	purge dti2dem.*
$exit_neatly:
$	set noverify
$!
