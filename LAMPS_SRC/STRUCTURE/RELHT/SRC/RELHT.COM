$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-03-18 18:10:58.000000000 +0000
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
$! Command file to build RELHT program
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
$	cmt   :=
$!
$	wsb
$	inquire DBG "Compile/Link with debug "
$	if .not. DBG then goto askcmp
$	   debug = "/debug/noopt/check=all"
$	   lbug  = "/debug"
$	   cmt   = "/co"
$!
$askcmp:inquire CMP "Compile                 "
$	if .not. CMP then goto asklnk
$!
$	inquire LST "Listings                "
$	if LST then list = "/list"
$!
$	wsb
$	inquire MAIN     "Main program                  "
$	inquire CMD      "Get commands                  "
$	inquire TAB      "Read priorities               "
$	inquire PROC     "Process IFF file              "
$	inquire JUNC     "Junction handling             "
$	inquire TXT      "Output text file handling     "
$	inquire IFF      "IFF file handling             "
$	wsb
$	inquire CLD      "Command Line Decoding         "
$	inquire MES      "Message Definitions           "
$! 
$asklnk:wsb
$	inquire LNK      "Link                          "
$!
$!**	wsb
$!**	inquire DELE     "Delete .OBJ's, .MAP, .LIS's   "
$!
$	if .not. CMP then goto nocmp
$	wsb
$	set verify
$!
$	if .not. MES then goto noMES
$	   newmsg/number=1802/param=for/prefix=relht__/runoff relht.mes
$	   @RELHT.temp_com
$	   purge relhtmsg.rno
$!
$noMES :if .not. CLD then goto noCLD
$       adc CLD.tmp'cmt' = RELHT.CLD
$	set command/object = RELHT_CLD CLD.tmp
$	pvv RELHT_CLD
$	delete adc.ide;*,CLD.tmp;*
$!
$noCLD:	if .not. MAIN then goto noMAIN
$	adc RELHT'cmt' = RELHT,INIT,SIGCHS
$	fort'debug''list' RELHT
$	pvv RELHT
$	delete adc.ide;*
$	if .not. DBG then delete RELHT.for;*
$!
$noMAIN:if .not. CMD then goto noCMD
$	adc GET_COMMAND'cmt' = GET_COMMAND
$	fort 'debug''list' GET_COMMAND
$	pvv GET_COMMAND
$	delete adc.ide;*
$	if .not. dbg then delete GET_COMMAND.for;*
$!
$noCMD:	if .not. TAB then goto noTAB
$	adc READ_PRIO'cmt' = READ_PRIO,FC_RANGE,ADD_RANGE
$	fort 'debug''list' READ_PRIO
$	pvv READ_PRIO
$	delete adc.ide;*
$	if .not. dbg then delete READ_PRIO.for;*
$!
$noTAB:	if .not. PROC then goto noPROC
$	adc PROCESS'cmt' = PROCESS,COPY_INPUT,SET_HEIGHTS
$	fort 'debug''list' PROCESS
$	pvv PROCESS
$	delete adc.ide;*
$	if .not. dbg then delete PROCESS.for;*
$!
$noPROC:if .not. JUNC then goto noJUNC
$	adc NEXT_JUNCTION'cmt' = NEXT_JUNCTION,BINARY_CHOP,NEW_PRIO,UPDATE_HEIGHTS
$	fort 'debug''list' NEXT_JUNCTION
$	pvv NEXT_JUNCTION
$	delete adc.ide;*
$	if .not. dbg then delete NEXT_JUNCTION.for;*
$!
$noJUNC:if .not. TXT then goto noTXT
$	adc OPEN_LCM'cmt' = OPEN_LCM,OPEN_LIS,WRITE_LCM,WRITE_LIS,CLOSE_LCM,CLOSE_LIS
$	fort 'debug''list' OPEN_LCM
$	pvv OPEN_LCM
$	delete adc.ide;*
$	if .not. dbg then delete OPEN_LCM.for;*
$!
$noTXT:	if .not. IFF then goto noIFF
$	adc OPEN_IFF'cmt' = OPEN_IFF,CLOSE_IFF
$	fort 'debug''list' OPEN_IFF
$	pvv OPEN_IFF
$	delete adc.ide;*
$	if .not. dbg then delete OPEN_IFF.for;*
$!
$noIFF:	set noverify
$nocmp:	if .not. LNK then goto endit
$!
$	set verify
$	link'lbug'/map	RELHT,RELHT_CLD,-
			GET_COMMAND,READ_PRIO,PROCESS,NEXT_JUNCTION,-
			   OPEN_LCM,OPEN_IFF,-
			RELHT.PROMSG_OBJ,-
			LSL$LIBRARY:LSLLIB/LIB,IFFLIB/LIB
$	set noverify
$!
$! clear the source directory of unwanted files
$!
$endit:	
$!**	if .not. DELE then goto noDEL
$!**	delete  *.obj;*
$!**	delete  *.map;*
$!**	delete  *.lis;*
$!
$! tidy the source directory
$!
$noDEL:	purge	*.*
$	wsb
$!
$! set up some things to run it
$!
$end:	RELHT:==$here:RELHT
$	Define	LSL$RELHT_PRIO		here:RELHT.PRIO
