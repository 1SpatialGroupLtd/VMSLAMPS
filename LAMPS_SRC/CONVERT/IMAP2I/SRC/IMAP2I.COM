$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1995-02-21 18:01:50.000000000 +0000
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
$! Command file to compile IMAP2I program
$!
$! Mod 1462 Allow compiling on AXP		ST 14-Feb-1995
$!
$	set noverify
$	on control then goto end
$       on error  then goto end
$!
$	define  cmn  'f$logical("HERE")
$!  
$! Define some symbols
$!
$	ws    := "write sys$output "
$	wsb   := "write sys$output """""
$	dbg   :=
$	debug :=
$	mbug  :=
$	cmp   :=
$	lst   :=
$	list  :=
$	cmt   :=
$	rno   :=
$	runoff:=
$	tidy  := "delete"
$	ver   := ";*"
$	link_dir := 'f$logical("HERE")
$!
$	wsb
$askcmp:inquire CMP "Compile                 "
$	if .not. CMP then goto askcop
$	inquire DBG "   with debug           "
$	if .not. DBG then goto askall
$	   debug = "/debug/noopt/check=all"
$	   mbug  = "/debug"
$	   cmt   = "/co"
$	   tidy  = "purge"
$	   ver   = ""
$!
$	inquire LST "   and listings         "
$	if LST then list = "/list"
$!
$askall:wsb
$	inquire MAIN     "Main program                  "
$	inquire CMD      "Get commands                  "
$	inquire PAR      "Read parameters               "
$	inquire FAC      "Get facets                    "
$	inquire RET      "INFORMAP Retrieval            "
$	inquire IFF      "Output to IFF file            "
$!
$	wsb
$	inquire CLD      "Command Line Decoding         "
$	inquire MES      "Message Definitions           "
$!
$	if .not. MES then goto askcop
$	   inquire RNO   "Runoff file                   "
$	   if RNO then runoff = "/runoff/hl=2"
$! 
$askcop:wsb
$!
$	if .not. CMP then goto noCMP
$	wsb
$	set verify
$!
$! Check the architecture
$!
$	  if F$GETSYI("ARCH_NAME").eqs."Alpha"
$	  then
$	     axp = "/tie/extend/separate/float=d_float"
$	     maxp =  "/migrate/notie/unalign"
$	     cmt = cmt + "/ll:80"
$	  else
$	     axp = ""
$	     maxp = ""
$	  endif
$!
$	if .not. MES then goto noMES
$	newmsg  IMAP2I/number=1610'runoff'
$	@IMAP2I.temp_com
$	if RNO then purge IMAP2IMSG.rno
$!
$noMES :if .not. CLD then goto noCLD
$       adc CLD.tmp'cmt' = IMAP2I.CLD
$	set command/object = IMAP2I_CLD CLD.tmp
$	pvv IMAP2I_CLD
$	purge IMAP2I_CLD.obj
$	delete adc.ide;*,CLD.tmp;*
$!
$noCLD:	if .not. MAIN then goto noMAIN
$	adc IMAP2I'cmt' = IMAP2I,REPORT
$	fort'debug''axp''list' IMAP2I
$	pvv IMAP2I
$	purge IMAP2I.obj
$	delete adc.ide;*
$	'tidy' IMAP2I.for'ver'
$!
$noMAIN:if .not. CMD then goto noCMD
$	adc GET_COMMAND'cmt' = GET_COMMAND,UPCASE,STRTOBUF
$	fort 'debug''axp''list' GET_COMMAND
$	pvv GET_COMMAND
$	purge GET_COMMAND.obj
$	delete adc.ide;*
$	'tidy' GET_COMMAND.for'ver'
$!
$noCMD:	if .not. PAR then goto noPAR
$	adc RDPAR'cmt' = RDPAR,RDDDT,RDADT
$	adc RDPAR'cmt'/ap = READ_NAM,UP_NAM,READ_DTR,ADD_DTR
$	fort 'debug''axp''list' RDPAR
$	pvv RDPAR
$	macro'mbug''maxp''list' PARCMD
$	macro'mbug''maxp''list' FLDCMD
$	append PARCMD.obj,FLDCMD.obj RDPAR.obj
$	purge RDPAR.obj
$	delete adc.ide;*,PARCMD.obj;*,FLDCMD.obj;*
$	'tidy' RDPAR.for'ver'
$!
$noPAR:	if .not. FAC then goto noFAC
$	adc GET_LIST'cmt' = GET_LIST,RDFDT,FDT_LINE,RECFAX,BASFAC
$	fort 'debug''axp''list' GET_LIST
$	pvv GET_LIST
$	purge GET_LIST.obj
$	delete adc.ide;*
$	'tidy' GET_LIST.for'ver'
$!
$noFAC: if .not. RET then goto noRET
$	adc CONDAT'cmt'    = CONDAT,STARET,ENDRET,RETLIN,RETSYM,RETTXT,RETATT
$	adc CONDAT'cmt'/ap = CHKTXT,ATTR_IND,AC_IND,GETLIN,GETSYM,GETTEX,GETATT
$	adc CONDAT'cmt'/ap = NXTGRA,IMAP_SYSMSG,RETATTANNO
$	fort 'debug''axp''list' CONDAT
$	pvv CONDAT
$	purge CONDAT.obj
$	delete adc.ide;*
$	'tidy' CONDAT.for'ver'
$!
$noRET: if .not. IFF then goto noIFF
$	adc WRITE_IFF'cmt'    = CLOSE_IFF,GET_LIMITS,INI_FEATURE,NEW_FEATURE
$	adc WRITE_IFF'cmt'/ap = WRITE_START,WRITE_END,WRITE_FEATURE
$	adc WRITE_IFF'cmt'/ap = START_FEATURE,FLUSH,COORD
$	fort 'debug''axp''list' WRITE_IFF
$	pvv WRITE_IFF
$	purge WRITE_IFF.obj
$	delete adc.ide;*
$	'tidy' WRITE_IFF.for'ver'
$!
$noIFF:	set noverify
$noCMP:	
$	wsb
$end:
