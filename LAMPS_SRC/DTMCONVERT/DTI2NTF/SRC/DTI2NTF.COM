$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-09-29 13:11:08.000000000 +0100
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
$! command file: dti2ntf - a command file to build the dti2ntf program
$!
$! Copyright (C) Laser-Scan Ltd, Cambridge, England  1985
$!
$! Author S Gupta	27-August-1991
$!
$! ripped from ntf2dti.com
$!
$! added subroutine COMPILE which does the compilation process provided it is 
$! given the target file and the consituent files. This cuts the size of this
$! file to managable proportions		SG  16-August-1991
$!
$! *************************************************************************
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
$	  inquire main "DTI2NTF                                           "
$	  inquire cmd  "commands: CMDLIN                                  "
$	  inquire wrt  "write   : WRITE_NTF_HEADER, WRITE_VOLTERM         "
$	  inquire col  "column  : READ_DTI_COL, WRITE_NTF_COL             "
$	  inquire dti  "dti     : OPEN_DTI  CLOSE_DTI  PROCESS_DTI        "
$	  inquire grid "grid    : WRITE_GRIDHREC                          "	
$	  inquire head "header  : READ_DTI_HEADER, SECTION_HEADER         "
$	  inquire log  "log     : OPEN_LOG, CLOSE_LOG, GET_INFILE         "
$	  inquire misc "misc    : WRITE/GET_STRING, END_TAPE              "
$	  inquire ntf  "ntf     : OPEN_NTF, CLOSE_NTF, CREATE_NTF         "
$	  inquire sec  "section : SET_GRIDVAL, PROCESS_SECTION            "
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
$	  inquire lbg "Link with debug               "
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
$	   adc   dti2ntf_cld.tmp=dti2ntf_cld.cld
$	   set verify
$	   set command/object=dti2ntf_cld  dti2ntf_cld.tmp
$	   pvv   dti2ntf_cld
$	   set noverify
$	   purge dti2ntf_cld.obj
$	   delete ADC.IDE;*
$	   delete dti2ntf_cld.tmp;*
$	   wsb
$	   adc   inlist_cld.TMP=inlist_cld.cld
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
$	   newmsg  dti2ntf/dti/number=1673/runoff
$	   @dti2ntf.temp_com
$	   set noverify
$	   purge dti2ntfmsg.*
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
$	if main then call compile  "dti2ntf" -
					" dti2ntf"
$	if col  then call compile  "column" -
					" read_dti_col, write_ntf_col"
$	if cmd  then call compile  "command" -
					" cmdlin"
$	if dti  then call compile  "dti_files" -
					" open_dti, close_dti, process_dti"
$	if grid then call compile  "grid" -
					" write_gridhrec"	
$	if head then call compile  "head" -
					" read_dti_header, section_header"
$	if log  then call compile  "do_log" -
					" open_log, close_log, get_infile"
$	if misc then call compile  "misc" -
					" write_string, get_string, end_tape"
$	if ntf  then call compile  "do_ntf" -
					" open_ntf, close_ntf, create_ntf"
$	if sec  then call compile  "do_section" -
					" set_gridval, process_section"
$	if wrt  then call compile  "write_ntf" -
					" write_ntf_header, write_volterm"
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
$	  link'ldbg'	dti2ntf, command, do_ntf, write_ntf, dti_files,-
			head, do_section, misc, do_log, column, grid,-
			dti2ntf_cld, inlist_cld,-
			dti2ntf.promsg_obj,-
			lsl$library:dtilib/lib,-
			lsl$library:lslshr/opt
$	  set noverify
$!	  purge dti2ntf.*
$	endif
$!
$!.............................................................................
$!
$exit_neatly:
$	set verify
$!
