$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-16 15:34:46.000000000 +0100
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
$! command file: DTI2BIN - a command file to build the DTI2BIN program
$!
$! Copyright (C) Laser-Scan Ltd, Cambridge, England  1985
$!
$! Author S Gupta	(ripped from ntf2dti.com)	SG	27-Aug-1991
$! Rehashed for DTI2BIN					PGH	13-May-1992
$!
$! *************************************************************************
$!
$	set noverify
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$	wsb = "write sys$output """""
$	ws = "write sys$output "
$!
$!.............................................................................
$!
$	inquire compile_sources "compile ?                                "
$	if compile_sources
$	then
$	  inquire debug "compile with debug                       "
$	  if debug.eqs."" then debug = "n"
$	  wsb
$	  ws "             ----------------------------------------------------"
$	  wsb
$	  inquire cld  "Command line definition                   "
$	  inquire msg  "Messages                                  "
$	  wsb
$	  ws "             ----------------------------------------------------"
$	  wsb
$	  inquire main "DTI2BIN                                           "
$	  inquire cmd  "commands: CMDLIN                                  "
$	  inquire dti  "dti     : OPEN_DTI  CLOSE_DTI  PROCESS_DTI        "
$	  inquire log  "log     : OPEN_LOG, CLOSE_LOG, GET_INFILE         "
$	  inquire oput "output  : OPEN_BIN, PROCESS_BIN, CLOSE_BIN        "
$	  wsb
$	  ws "             ----------------------------------------------------"
$	  wsb
$!
$	endif
$!
$	inquire lnk "Link                          "
$	if lnk
$	then
$	  sca = "n"
$	  inquire lbg "Link with debug                "
$	  if .not.lbg then inquire sca "Link with source code analyser "
$	endif
$!
$!.............................................................................
$!
$	wsb
$	ws "             ----------------------------------------------------"
$	wsb
$!
$	if .not.compile_sources then goto do_link
$!
$!.............................................................................
$!
$	set noverify
$	dbg = ""
$	if debug then dbg = "/debug/noopt/list"
$	pd = "delete"
$	ver =";"
$	if debug then pd  = "purge"
$	if debug then ver = ""
$!
$	if cld
$	then
$	   adc   dti2bin_cld.tmp=dti2bin_cld.cld
$	   set verify
$	   set command/object=DTI2BIN_cld  DTI2BIN_cld.TMP
$	   pvv   dti2bin_cld
$	   set noverify
$	   purge dti2bin_cld.obj
$	   delete adc.ide;*
$	   delete dti2bin_cld.tmp;*
$	   wsb
$	   adc   inlist_cld.tmp=inlist_cld.cld
$	   set verify
$	   set command/object=inlist_cld  inlist_cld.tmp
$	   pvv   inlist_cld
$	   set noverify
$	   purge inlist_cld.obj
$	   delete adc.ide;*
$	   delete inlist_cld.tmp;*
$	endif
$!
$	if msg
$	then
$	   set verify
$	   newmsg  dti2bin/number=1673/runoff
$	   @dti2bin.temp_com
$	   set noverify
$	   purge dti2binmsg.*
$	endif
$!
$!.............................................................................
$!
$compile:SUBROUTINE
$	on error     then exit 4
$	on control_y then exit 4
$	wsb
$	set verify
$	adc   'p1'/co ='p2'
$	fortran/extend'dbg' 'p1'
$	pvv   'p1'
$	purge 'p1'.obj
$	delete adc.ide;*
$	'pd' 'p1'.for'ver'  
$	set noverify
$	wsb
$ENDSUBROUTINE
$!
$!.............................................................................
$!
$	set noverify
$!
$	if main then call compile  "dti2bin" -
					" dti2bin"
$	if cmd  then call compile  "command" -
					" cmdlin"
$	if dti  then call compile  "dti_files" -
					" open_dti, close_dti, process_dti"
$	if log  then call compile  "do_log" -
					" open_log, close_log, get_infile"
$	if oput  then call compile  "output" -
					" open_bin, process_bin, close_bin"
$!.............................................................................
$!
$do_link:
$	if lnk
$	then
$	  ldbg="/map"
$	  pd  = "delete"
$	  ver = ";*"
$	  if lbg   then ldbg= ldbg+"/debug"
$	  if sca then ldbg = ldbg+"/debug=sys$library:pca$obj.obj"
$	  set verify
$!
$	  link'ldbg'	dti2bin, command, dti_files,-
			do_log, output,-
			dti2bin_cld, inlist_cld,-
			dti2bin.promsg_obj,-
			lsl$library:dtilib/lib,-
			lsl$library:lslshr/opt
$	  set noverify
$	  purge dti2bin.*
$	endif
$!
$!.............................................................................
$exit_neatly:
$	set verify
$!
