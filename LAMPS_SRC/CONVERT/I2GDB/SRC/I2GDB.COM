$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-11-29 17:52:38.000000000 +0000
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
$! I2GDB.COM
$!
$! Copyright (C) Laser-Scan Ltd, Cambridge, England  1988
$! Author 					TJ Ibbs,  4-Oct-1988
$! Modified for I2GDB				J Barber 15-Sep-1989
$!
$! Mod 1435 Use new frtshr			JB	 29-Nov-1994
$!
$! *************************************************************************
$! and ask our questions
$!
$	debug = 0
$	comp  = 1
$!
$	inquire debug "with debug                          "
$	inquire v51   "with version 5-1 libraries          "
$!
$	write sys$output ""
$!
$	inquire  mes "messages                            "
$	inquire  cld "commands                            "
$!
$	write sys$output ""
$!
$	inquire  i2gdb  	"i2gdb                               "
$	inquire  frt_ret	"frt_retrieve                        "
$	inquire  acd_ret	"acd_retrieve                        "
$	inquire  find_codes 	"finc_codes                          "
$	inquire  getcb	 	"getcb                               "
$	inquire  cmd    	"command line                        "
$	inquire  params 	"params                              "
$	inquire  read_params 	"read params                         "
$	inquire  poly 		"poly                                "
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
$!	pd   = "delete"
$	ver  = ";*"
$	sfx  = ""
$	sf2  = ""
$	if debug then dbg  = "/debug/noopt"
$	if debug then mdbg = "/debug"
$!	if debug then pd   = "purge"
$	if debug then ver  = ""
$!
$	set verify
$! .........................................................................
$	if .not.mes then goto nomes
$	   newmsg  i2gdb.mes  /number=1624/param=c/runoff
$	   @i2gdb.temp_com
$	   purge   i2gdbmsg.h,.rno
$nomes:
$! .........................................................................
$	if .not.cld  then goto no_cld
$	   adc   i2gdb.TMP=i2gdb.CLD
$	   set command/object=i2gdb_cld  i2gdb.TMP
$	   pvv   i2gdb_cld
$	   purge i2gdb_cld.OBJ
$	   delete ADC.IDE;*
$	   delete i2gdb.TMP;*
$no_cld:
$! .........................................................................
$	if i2gdb then cc'dbg' i2gdb
$	if .not.frt_ret then goto no_frt
$		adc frt_retrieve/co=frt_retrieve
$		fort/extend'dbg' frt_retrieve
$		pvv frt_retrieve
$		purge *.for
$	delete adc.ide;*
$! .........................................................................
$no_frt:
$! .........................................................................
$	if .not.acd_ret then got no_acd
$		adc acd_retrieve/co=acd_retrieve
$		fort/extend'dbg' acd_retrieve
$		pvv  acd_retrieve
$		purge *.for
$	delete adc.ide;*
$! .........................................................................
$no_acd:
$	if .not.find_codes then goto no_find_codes
$		adc find_codes/co=find_codes
$		fort/extend'dbg' find_codes
$		pvv find_codes
$		purge *.for
$	delete adc.ide;*
$no_find_codes:
$! .........................................................................
$	if .not.getcb then goto no_getcb
$		adc getcb/co=getcb
$		fort/extend'dbg' getcb
$		pvv getcb
$		purge *.for
$!
$no_getcb:
$! .........................................................................
$ 	if cmd then cc'dbg' cmdline
$	if params then cc'dbg' params
$	if read_params then cc'dbg' read_params
$	if poly then cc'dbg' poly
$! .........................................................................
$	if .not.lnk then goto nolink
$	if v51 then @sys$library:use_vaxcrtl_v51
$	   link/map'mdbg' i2gdb, frt_retrieve, acd_retrieve, -
			find_codes, getcb, cmdline, -
			params, read_params, poly, -
			i2gdb_cld, -
			i2gdb.promsg_obj, -
			lsl$library:frtshr/opt, -
			lsl$library:cjacket/lib, -
			lsl$library:lslshr/opt, -
			lsl$library:iffshr/opt, -
			sys$input:/opt
sys$library:vaxcrtl/share
$!
$nolink:
$! .........................................................................
$!
$exit_neatly:	set noverify
$!	   purge i2gdb.*
$	   purge *.*obj
$	   purge *.map
$	   purge *.*exe
$!
