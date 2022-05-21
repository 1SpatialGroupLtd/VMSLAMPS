$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-09-29 15:45:20.000000000 +0100
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
$!	Created					ST	23-Jul-1990
$!
$!	Command procedure to build MNT2DTI in DTMCONVERT
$!
$!----------------------------------------------------------------------------
$!
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$!	Logical name to point to directory for common blocks, message
$!	and parameter files
$!
$	define/nolog lsl$mnt2dti here
$!
$	ws = "write sys$output"
$	wsb = "write sys$output """"
$	debug = "n"
$!
$	wsb
$	ws "Build of DTMCONVERT/MNT2DTI"
$	wsb
$	inquire/nopunct cld  "Command language definition ? "
$	inquire/nopunct msg  "Messages ? "
$	inquire/nopunct cmp "Compile ? "
$	if .not.cmp then goto asklnk
$	inquire/nopunct debug "with debug ? "
$	if debug.eqs."" then debug = "n"
$	inquire/nopunct main "   Main routine (MNT2DTI) ? "
$	inquire/nopunct tape "   Tape routine (NEXT_MNT) ? "
$	inquire/nopunct cmd  "   Command line (OBEY) ? "
$	inquire/nopunct fil  "   File handling (OPEN_FILES,CLOSE_FILES) ? "
$	inquire/nopunct mnt  "   MNT file (READ_HEADER,READ_DATA) ? "
$	inquire/nopunct dti  "   DTI file (WRITE_DTI) ? "
$	inquire/nopunct blk  "   MNT block data (MNT_OFF) ? "
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
$	   ws "mnt2dti_cld.cld"
$	   set command/object=mnt2dti_cld mnt2dti_cld
$	   purge mnt2dti_cld.obj
$no_cld:
$	if .not.msg then goto no_msg
$	   ws "Building messages..."
$	   ws "mnt2dti.mes"
$	   newmsg  mnt2dti/dti/number=1677/runoff
$	   @mnt2dti.temp_com
$	   purge mnt2dtimsg.*
$no_msg:
$	if .not.cmp then goto do_link
$	ws "Compiling..."
$	if .not.main then goto no_main
$	   ws "mnt2dti.f"
$	   fortran/extend'dbg' mnt2dti.f
$	   purge mnt2dti.*
$no_main:
$	if .not.tape then goto no_tape
$	   ws "next_mnt.f"
$	   fortran/extend'dbg' next_mnt.f
$	   purge next_mnt.*
$no_tape:
$	if .not.cmd then goto no_cmd
$	   ws "obey.f"
$	   fortran/extend'dbg' obey.f
$	   purge obey.*
$no_cmd:
$	if .not.fil then goto no_fil
$	   ws "open_files.f"
$	   fortran/extend'dbg' open_files.f
$	   ws "close_files.f"
$	   fortran/extend'dbg' close_files.f
$	   purge open_files.*
$	   purge close_files.*
$no_fil:
$	if .not.mnt then goto no_mnt
$	   ws "read_header.f"
$	   fortran/extend'dbg' read_header.f
$	   ws "read_data.f"
$	   fortran/extend'dbg' read_data.f
$	   purge read_header.*
$	   purge read_data.*
$no_mnt:
$	if .not.dti then goto no_dti
$	ws "write_dti.f"
$	fortran/extend'dbg' write_dti.f
$	purge write_dti.*
$no_dti:
$	if .not.blk then goto no_blk
$	   ws "mnt_off.f"
$	   fortran/extend'dbg' mnt_off.f
$	   purge mnt_off.*
$no_blk:
$!
$do_link:
$	if .not.lnk then goto exit_neatly
$!
$	ws "Linking..."
$	ws "mnt2dti"
$	link'ldbg'	mnt2dti,next_mnt,obey, -
			open_files,close_files, -
			read_header,read_data, -
			write_dti, -
			mnt_off, -
			mnt2dti_cld, -
 			mnt2dti.promsg_obj, -
			lsl$library:dtilib/lib, -
			lsl$library:lslshr/opt
$	purge mnt2dti.*
$exit_neatly:
$	set noverify
$!
