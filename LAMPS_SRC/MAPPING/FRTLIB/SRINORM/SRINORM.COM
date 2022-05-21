$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-05-07 14:42:10.000000000 +0100
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
$	VER=F$verify(0)
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!	Created						TJH 26-Jan-1987
$!
$! Command file for building srinorm
$!
$	on error then goto srinormEX
$	on control_Y then exit
$	ws = "write sys$output"
$!
$	if "''F$LOGICAL("LSL$srinorm_BUILDING")'" .EQS. "IN_PROGRESS" 
$	then
$	  ws "Someone else is building"
$	  inq/nop carry "  Carry on regardless? "
$	  if .not.carry then exit
$	endif
$!
$A0:	on control_Y then goto srinormEX
$	DEFINE/GROUP LSL$srinorm_BUILDING "IN_PROGRESS"
$	OPEN/write COMFIL srinormBAT.COM
$	on control_Y then goto FILCLO
$	on error then goto FILCLO
$	wc="write COMFIL"
$	wc "$	ws = ""write sys$output"""
$!
$	wc "$	SET noverify"
$	wc "$	on control_Y then goto srinormEX"
$	wc "$	if ""'","'F$LOGICAL(""LSL$srinorm_BUILDING"")'"" -"
$	wc "		 .nes. ""IN_PROGRESS"" then goto A0"
$	wc "$	ws ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$A0:	DEFINE/GROUP LSL$srinorm_BUILDING ""IN_PROGRESS"""
$	wc "$	ASSIGN LSL$SOURCE_ROOT:[MAPPING.FRTLIB.srinorm] LSL$CMNsrinorm"
$	wc "$	SET NOon"
$!
$	MLDBG=""
$	fsw1=""
$	KPCOM=""
$!
$	ws ""
$	inquire/NOP COMPILE "Compile ? "
$	if COMPILE
$	then
$	  inquire/NOP srinorm_DBG "  With Debug ? "
$	  if srinorm_DBG
$	  then
$	     fsw1="/debug"
$	     mldbg="/debug"
$	     fsw1=fsw1 + "/noopt/check=(bounds,overflow)/list/co"
$	  endif
$	endif
$!
$	ws ""
$	inq/nop CLD "Compile CLD module ? "
$	ws ""
$	inq/nop MES "Generate message definitions ? "
$!
$	ws ""
$	inq/nop LNKIT "link ? "
$	if LNKIT
$	then
$	   linkver	="srinorm"
$	   linkopts	="/MAP"
$	   inq/nop ANSWER "  link with debug ? "
$	   if ANSWER then linkopts=linkopts+"/DEBUG"
$	   linkopts	=linkopts+"/CROSS"
$	endif
$!
$	wc "$	SET verify"
$		if MES
$	then
$	  wc "$	NEWMSG srinorm/number=1186"
$	  wc "$	@srinorm.TEMP_COM"
$	endif
$!
$	if CLD
$	then
$	  wc "$	ADC srinorm.TMP=srinorm.CLD"
$	  wc "$	SET COMMAND/OBJECT=srinorm_cld srinorm.TMP"
$	  wc "$	OK=$STATUS"	
$	  wc "$	if OK then PVV srinorm_cld"
$	  wc "$	DELETE srinorm.TMP;*"	
$	  wc "$	PURGE/NOLOG srinorm_cld.OBJ"
$	  wc "$	OK=$STATUS"	
$	endif
$!
$	if COMPILE
$	then
$	  wc "$	SET noverify"
$	  wc "$	ws ""-----------------COMPILE--------"""
$	  wc "$	SET verify"
$	  wc "$	ADC srinorm''KPCOM'=srinorm"
$	  wc "$	FORT''fsw1' srinorm"
$	  wc "$	OK=$STATUS"	
$	  wc "$	if OK then PVV srinorm"
$	  wc "$	PURGE/NOLOG srinorm.OBJ"
$	  if fsw1.EQS.""
$	  then
$	    wc "$	DELETE srinorm.FOR;*"
$	  else
$	    wc "$	PURGE/NOLOG srinorm.FOR"
$	  endif
$!
$	  tmp_len = f$length(fsw1)
$	  if (F$LOCATE("LIST",fsw1).ne.tmp_len) .AND. tmp_len.NE.0
$	  then
$	    wc "$	PURGE/NOLOG srinorm.LIS"
$	  endif
$!
$	  wc "$	DELETE ADC.IDE;*"
$	endif
$!
$		if LNKIT
$	then
$	  wc "$	SET noverify"
$	  wc "$	ws ""---------------LINK........."""
$	  wc "$	SET verify"
$	  wc "$	link''linkopts'/exe=''linkver' srinorm,-"
$	  wc " srinorm_cld,srinorm.PROMSG_OBJ, -"
$	  wc " LSL$LIBRARY:IFFSHR/OPT,LSLSHR/OPT"
$	endif
$!
$	wc "$	srinormEX:"
$	wc "$	DEASS/GROUP LSL$srinorm_BUILDING"
$	wc "$	SET NOVER"
$!
$	FILCLO:
$	SET noverify
$	on error then goto srinormEX
$	CLOSE COMFIL
$	OK=$STATUS
$!
$	DEASS/GROUP LSL$srinorm_BUILDING
$
$	ws ""
$	if OK then inq/nop ANSWER_BAT "Submit for batch ? "
$	if ANSWER_BAT
$	then
$	  BAT srinormBAT.COM
$	else
$	  if OK then inq/nop ANSWER "  Interactive ? "
$	  if ANSWER
$	  then
$		@srinormBAT.COM
$	  else
$	        ws "Hmmmmmmm.......... next time give me something to do"
	  endif
$	endif
$!
$	srinormEX:
$	if VER then SET verify
