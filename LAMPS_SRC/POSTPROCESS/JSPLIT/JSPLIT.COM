$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1986-05-01 16:39:58.000000000 +0100
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
$! Command file to build JSPLIT
$!
$	set noverify
$	on control then goto end
$       on error  then goto end
$!  
$! Define some symbols
$!
$	ws    := "write sys$output "
$	wsb   := "write sys$output """""
$	dbg   :=
$	debug :=
$ 	lbug  :=
$	cmp   :=
$	lst   :=
$	list  :=
$!
$	wsb
$	inquire DBG "Compile/Link with debug "
$	   if DBG then debug = "/debug/noopt/check=all"
$	   if DBG then lbug  = "/debug"
$	inquire CMP "Compile                 "
$	if .not. CMP then goto asklnk
$!
$	inquire LST "Listings                "
$	if LST then list = "/list"
$!
$	wsb
$	inquire ALL	 "Process all routines		"
$!
$	if .not. ALL then goto askrout
$	JSPLIT = "Y"
$	SPLIT  = "Y"
$	JSPFIL = "Y"
$	CLD    = "Y"
$	goto asklnk
$!
$askrout:inquire JSPLIT   "Main program (JSPLIT)         "
$	inquire SPLIT    "Split subroutine		"
$	inquire JSPFIL   "File handling subroutine      "
$	inquire CLD      "Command line decoder		"
$! 
$asklnk:wsb
$	inquire LNK      "Link                          "
$!
$	wsb
$	inquire DELE     "delete .OBJ's, .MAP, .LIS's   "
$!
$	if .not. CMP then goto lnkit
$	wsb
$	set verify
$!
$	if .not. JSPLIT then goto noJSPLIT
$	adc JSPLIT = JSPLIT
$	fort'debug''list' JSPLIT
$	pvv JSPLIT
$	delete/nocon adc.ide;*
$	if .not. DBG then delete/nocon JSPLIT.for;*
$!
$noJSPLIT:if .not. SPLIT then goto noSPLIT
$	adc SPLIT = SPLIT
$	fort 'debug''list' SPLIT
$	pvv SPLIT
$	delete/nocon adc.ide;*
$	if .not. dbg then delete/nocon SPLIT.for;*
$!
$noSPLIT:if .not. JSPFIL then goto noJSPFIL
$	adc JSPFIL = JSPFIL 
$	fort 'debug''list' JSPFIL
$	pvv JSPFIL
$	delete/nocon adc.ide;*
$	if .not. dbg then delete/nocon JSPFIL.for;*
$!
$noJSPFIL:if .not. CLD then goto lnkit
$	adc JSPLIT_CLD.tmp = JSPLIT_CLD.cld
$	set command/object=JSPLIT_CLD JSPLIT_CLD.tmp
$	OK=$STATUS
$	if OK then pvv JSPLIT_CLD
$	if OK then delete/nocon jsplit_cld.tmp;*
$	delete/nocon adc.ide;*
$lnkit:	if .not. LNK then goto endit
$!
$	inquire map "map required"
$	if .not.map then goto nomap
$	map = "/map"
$nomap:
$	set verify
$	link'lbug''map'	JSPLIT,SPLIT,JSPFIL,JSPLIT_CLD,-
			LSL$LIBRARY:LSLLIB/LIB,IFFLIB/LIB
$	set noverify
$!
$! clear the source directory of unwanted files
$!
$endit:	
$	if .not. DELE then goto noDEL
$	delete/nocon  *.obj;*
$	delete/nocon  *.lis;*
$!
$	if .not. map then goto nmap
$	mapid jsplit
$	delete/nocon  *.map;*
$nmap:
$!
$!
$! tidy the source directory
$!
$noDEL:	purge	*.*
$	wsb
$!
$! set up some things to run it
$!
$end:	JSPLITK:==$here:JSPLIT  	!symbol for command interpreter
