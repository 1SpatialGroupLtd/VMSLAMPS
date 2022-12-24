$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-11-30 12:07:52.000000000 +0000
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
$	set noverify
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$! *************************************************************************
$! I2ARC.COM
$!
$! Copyright (C) Laser-Scan Ltd, Cambridge, England  1988
$! Author 					TJ Ibbs,    4-Oct-1988
$! Modified for I2ARC				J Barber   15-May-1989
$! Modified to link in shared libraries         AJ Verrill 19-Mar-1990
$! Mod1435 Use new frtshr			J Barber   29-Nov-1994
$!
$! *************************************************************************
$! and ask our questions
$!
$	debug = 0
$	comp  = 1
$!
$	inquire debug "with debug                          "
$!
$	write sys$output ""
$!
$	inquire  mes "messages                            "
$	inquire  cld "commands                            "
$!
$	write sys$output ""
$!
$	inquire  cmd    "command line   (C)                  "
$	inquire  frt	"c_jacket       (C)                  "
$	inquire  dotab  "dotables       (C)                  "
$	inquire  getatt "getattinfo     (Fortran)            "
$	inquire  getfrt "getfrt         (C)                  "
$	inquire  i2arc  "i2arc          (C)                  "
$	inquire  rdadt  "rdadt          (Fortran)            "
$	inquire  rdfrt	"rdfrt          (Fortran)            "
$	inquire  rdnam  "rdnam          (Fortran)            "
$	inquire  rdpar  "rdpar          (Fortran)            "
$	inquire  rdtab  "rdtab          (Fortran)            "
$	inquire  procac "processac      (C)                  "
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
$	complib = 0
$	dbg  = ""
$	mdbg = ""
$	pd   = "delete"
$	ver  = ";*"
$	sfx  = ""
$	sf2  = ""
$	if debug then dbg  = "/debug/noopt"
$	if debug then mdbg = "/debug"
$	if debug then pd   = "purge"
$	if debug then ver  = ""
$!
$	set verify
$! .........................................................................
$	if .not.mes then goto nomes
$	   newmsg  i2arc.mes  /number=1620/param=(fortran,c)/runoff
$	   @i2arc.temp_com
$!	   newmsg  i2arc.mes  /number=1620/param=fortran/runoff
$!	   @i2arc.temp_com
$	   purge   i2arcmsg.h,.par,.rno
$nomes:
$! .........................................................................
$	if .not.cld  then goto no_cld
$	   adc   i2arc.TMP=i2arc.CLD
$	   set command/object=i2arc_cld  i2arc.TMP
$	   pvv   i2arc_cld
$	   purge i2arc_cld.OBJ
$	   delete/nocon ADC.IDE;*
$	   delete/nocon i2arc.TMP;*
$no_cld:
$! .........................................................................
$	if .not.rdadt then goto no_rdadt
$	   fortran/extend'dbg'	RDADT.F
$	   purge		RDADT.*
$	   macro'mbug''list' 	FLDCMD
$	   append FLDCMD.obj 	RDADT.obj
$	   purge 		RDADT.obj
$	   delete/nocon 	FLDCMD.obj;*
$no_rdadt:
$	if .not.rdtab then goto no_rdtab
$!	   fortran/extend'dbg'	RDADTTAB.F
$!	   purge		RDADTTAB.*
$!	   macro'mbug''list' 	TABCMD
$!	   append TABCMD.obj 	RDADTTAB.obj
$!	   purge 		RDADTTAB.obj
$!	   delete/nocon 	TABCMD.obj;*
$no_rdtab:
$	if .not.rdnam then goto no_rdnam
$	   fortran/extend'dbg'	RDNAM.F
$	   purge		RDNAM.*
$no_rdnam:
$	if .not.rdpar then goto no_rdpar
$	   fortran/extend'dbg'	RDPAR.F
$	   purge		RDPAR.*
$	   macro'mbug''list'	PARCMD
$	   append PARCMD.obj	RDPAR.obj
$	   purge		RDPAR.obj
$	   delete/nocon		PARCMD.obj;*
$no_rdpar:
$	if .not.rdfrt then goto no_rdfrt
$	   fortran/extend'dbg'	RDFRT.F
$	   purge		RDFRT.*
$no_rdfrt:
$	if .not.getatt then goto no_getatt
$	   fortran/extend'dbg'	GETATTINFO.F
$	   purge		GETATTINFO.*
$no_getatt:
$	if i2arc then cc'dbg' i2arc
$	if dotab then cc'dbg' dotables
$	if getfrt then cc'dbg' getfrt
$	if frt then cc'dbg' c_jacket
$	if cmd then cc'dbg' cmdline
$	if procac then cc'dbg' processac
$! .........................................................................
$	if .not.lnk then goto nolink
$	   link/map'mdbg' i2arc, dotables, getfrt, c_jacket, cmdline, -
			rdadt,rdnam,rdpar,rdfrt, - !rdadttab, -
			getattinfo, processac, -
			i2arc_cld, -
			i2arc.promsg_obj, -
			lsl$library:cjacket/lib, -
			lsl$library:frtshr/opt, -
			lsl$library:lslshr/opt, -
			lsl$library:iffshr/opt, -
			sys$input:/opt
sys$library:vaxcrtl/share
$!	   purge i2arc.*
$	   purge *.*obj
$	   purge *.map
$!	   purge *.*exe
$nolink:
$! .........................................................................
$!
$exit_neatly:	set noverify
$!
