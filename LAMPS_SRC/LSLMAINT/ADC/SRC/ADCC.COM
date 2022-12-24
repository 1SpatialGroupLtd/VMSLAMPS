$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1999-08-17 13:17:18.000000000 +0100
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
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$! *************************************************************************
$! ADCC.COM
$!
$! Copyright © Laser-Scan Ltd, Cambridge, England  1993
$! Author JM Cadogan, 4 October 1993
$! *************************************************************************
$!
$! Some definitions to make old stuff work
$	define LSL$CMNLSD  LSL$CMNLSL				! for cjacket.h
$	if f$trnlnm("LSL$CJACKET").eqs."" then -
	   define LSL$CJACKET LSL$OLD_SOURCE_ROOT:[LSD.CJACKET]	! for cjacket.olb
$!
$! and ask our questions
$!
$	debug = 0
$	comp  = 1
$!
$	inquire debug "with debug                          "
$	if debug then inquire lst "with listings                          "
$!
$	write sys$output ""
$!
$	inquire  mes "messages                            "
$	inquire  cld "commands - CLD                      "
$	inquire  mar "commands - LOOKUP file              "
$!
$	write sys$output ""
$!
$	inquire  main "adcc                                 "
$	inquire  cmd "command line                        "
$	inquire  cpy "copystream                          "
$	inquire  tru "read_truth                          "
$	inquire  sou "write_source                        "
$	inquire  pri "readlogexp                         "
$!
$	write sys$output ""
$!
$	inquire  lnk "link                                "
$!
$	write sys$output ""
$!
$! *************************************************************************
$! so obey the commands now - sort out our flags first
$!
$	dbg  = ""
$	mdbg = ""
$	pd   = "delete"
$	ver  = ";*"
$	if debug then dbg  = "/debug/noopt"
$	if lst then dbg  = "/debug/noopt/list"
$	if debug then mdbg = "/debug"
$	if debug then pd   = "purge"
$	if debug then ver  = ""
$!
$	set verify
$! .........................................................................
$	if .not.mes then goto nomes
$	   newmsg  adcc.mes  /number=1942/param=c/runoff
$	   @adcc.temp_com
$	   purge   adccmsg.h,.rno
$nomes:
$! .........................................................................
$	if .not.cld  then goto no_cld
$	   set command/object=adcc_cld  adcc_cld
$	   purge adcc_cld.OBJ
$no_cld:
$! .........................................................................
$	if .not.mar then goto nomar
$      	   macro'mdbg' adcccmds
$nomar:
$! .........................................................................
$	if main then cc'dbg' adcc
$	if cmd then cc'dbg' cmdline
$	if cpy then cc'dbg' copystream
$	if tru then cc'dbg' read_truth
$	if sou then cc'dbg' write_source
$	if pri then cc'dbg' readlogexp
$! .........................................................................
$	if .not.lnk then goto nolink
$	   link/map'mdbg' adcc,cmdline,adcccmds,copystream,-
			adcc_cld,read_truth,write_source, -
			readlogexp,adcc.promsg_obj, -
			lsl$cjacket:cjacket/lib, -
			lsl$library:lslshr/opt, -
			sys$input:/opt
sys$library:vaxcrtl/share
$	   purge adcc.*
$	   purge *.*obj
$nolink:
$! .........................................................................
$!
$exit_neatly:	set noverify
