$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-05-13 16:48:32.000000000 +0100
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
$	VER=F$VERIFY(0)
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!MOD	GOTOs eradicate					
$!MOD   Now linked against IFFSHR not IFFLIB	TJH	19-Oct-1989
$!MOD	COPY_STRING added			TJH	19-Jun-1987
$!MOD	Ripped off for ISTSEL			GST	27-Jan-1987
$!	Created					TJH	21-Aug-1986
$!
$! Command file for building ISTSEL
$!
$	set nover
$!
$	on error then goto ISTSELEX
$	on control_Y then goto ISTSELEX
$!
$	open/write comfil ISTSELBAT.COM
$	on control_Y then goto FILCLO
$	on error then goto FILCLO
$	wc= "write comfil"
$	ws= "write sys$output"
$!
$	wc "$	set nover"
$	wc "$	on control_Y then goto ISTSELEX"
$	wc "$	ws = ""write sys$output"""
$	wc "$!"
$	wc "$	set noon"
$!
$	MLDBG= ""
$	FSW1= ""
$	KPCOM= ""
$!
$	inq/nop COMPILE "Compile ? "
$	if COMPILE
$	then
$	  inq/nop ISTSEL_DBG "  With Debug ? "
$	  if ISTSEL_DBG
$	  then
$	     MLDBG= "/DEBUG"
$	     FSW1= "/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW)/LIST/CO"
$	  endif
$	endif
$!
$	if COMPILE
$	then
$	  inq/nop EVERYTHING "  Compile all FORTRAN sources ? "
$	  if EVERYTHING
$	  then 
$	    ISTSEL	= "T"
$	    COPY_STRING	= "T"
$	    CMDLIN	= "T"
$	    POL_DEF	= "T"
$	    SEGSEL	= "T"
$	    ACSORT	= "T"
$	    STRSUB	= "T"
$	  else
$	    inq/nop ACSORT	"    ACSORT?  "
$	    inq/nop CMDLIN	"    CMDLIN?  "
$	    inq/nop COPY_STRING	"    COPY_STRING? "
$	    inq/nop ISTSEL	"    ISTSEL? "
$	    inq/nop POL_DEF	"    POL_DEF?  "
$	    inq/nop STRSUB	"    STRSUB? "
$	    inq/nop SEGSEL	"    SEGSEL?  "
$	  endif
$!
$	  ws ""
$	  ws "Generating instructions for compiler................"
$	  if ISTSEL then call compiler "ISTSEL"
$	  if CMDLIN then call compiler "cmdlin"
$	  if COPY_STRING then call compiler "COPY_STRING"
$	  if POL_DEF then call compiler "POL_DEF"
$	  if SEGSEL then call compiler "SEGSEL"
$	  IF STRSUB then call compiler "STRSUB"
$	  if ACSORT then call compiler "ACSORT"
$!
$	  ws ""
$	  inq/nop CLD "  Compile CLD modules ? "
$	  if CLD
$	  then
$	    wc "$	ws """""
$	    wc "$	ws ""------------COMMAND LINE  MODULES............"""
$	    wc "$	ADC ISTSEL.TMP=ISTSEL.CLD"
$	    wc "$	set COMMAND/OBJECT=ISTSEL_CLD ISTSEL.TMP"
$	    wc "$	OK=$STATUS"	
$	    wc "$	if OK"
$	    wc "$	then"
$	    wc "$	  PVV ISTSEL_CLD"
$	    wc "$	  DELETE ISTSEL.TMP;*"
$	    wc "$	  PURGE/NOLOG ISTSEL_CLD.OBJ"
$	    wc "$	endif"
$	  endif
$!
$	  ws ""
$	  inq/nop MES "  Generate message definitions ? "
$	  if MES 
$	  then 
$	    wc "$	ws """""
$	    wc "$	ws ""------------------MESSAGE DEFINITIONS...."""
$	    wc "$ NEWMSG/NUMBER=1241/PREF=ISTSEL__/PARAM=FORTRAN ISTSEL.MES"
$	    wc "$ @ISTSEL.TEMP_COM"
$	  endif
$	endif
$!
$	ws ""
$	ws ""
$	inq/nop LNKIT "Link ? "
$	if LNKIT
$	then
$!
$	   LINKVER= "ISTSEL"
$	   LINKOPTS= "/MAP"
$!
$	   inq/nop ans "  with debug ? "
$	   if ans
$	   then
$	     LINKOPTS=LINKOPTS+"/cross/DEBUG"
$	   else
$	     inq/nop ans "  with profiler ? "
$	     if ans then LINKOPTS=LINKOPTS+"cross/DEBUG=sys$library:pca$obj.obj"
$	   endif
$	endif
$!	   
$!-----------------------------------------------------------------------------
$!
$	wc "$	set nover"
$	wc "$	set VERifY"
$	
$!	   
$!-----------------------------------------------------------------------------
$!
$	if LNKIT
$	then
$	  wc "$	set nover"
$	  wc "$	ws """""
$	  wc "$	ws ""------------------------LINKING................"""
$	  wc "$	set VERifY"
$	  wc "$	LINK''LINKOPTS'/EXE=''LINKVER' HERE:ISTSEL,-"
$	  wc "		ISTSEL_CLD,STRSUB, -"
$	  wc "		SEGSEL,ACSORT,CMDLIN,-"
$	  wc "		COPY_STRING,POL_DEF, -"
$	  wc "		ISTSEL.PROMSG_OBJ, -"
$	  wc "		LSL$LIBRARY:ifFSHR/OPT,-"
$	  wc "		LSL$LIBRARY:LSLSHR/OPT"
$	endif
$!
$	wc "$	ISTSELEX:"
$	wc "$	set NOVER"
$!
$FILCLO:
$	set nover
$	on error then goto ISTSELEX
$	CLOSE comfil
$	OK=$STATUS
$!
$	ws ""
$	ws ""
$	if OK
$	then
$	  inq/nop ans_bat "Submit for batch ? "
$	  if ans_bat
$	  then
$	    BAT ISTSELBAT.COM
$	  else
$	    inq/nop ans "Interactive ? "
$	    if ans
$	    then
$		@ISTSELBAT.COM
$	    else
$		ws " ******** YOU DIDNT ASK ME TO DO ANYTHING !!!!!! *********"
$	    endif
$	  endif
$	endif
$!
$ISTSELEX:
$	if VER then set VERifY
$	exit
$!
$!------------------------------------------------------------------------------
$!
$compiler: subroutine
$	wc "$	set nover"
$	wc "$	ws """""
$	wc "$	ws ""------------------------COMPILING ''p1'......"""
$	wc "$	ADC ''p1'''KPCOM'=''p1'"
$	wc "$	set ver"
$	wc "$	FORT''FSW1' HERE:''p1'"
$	wc "$	OK=$STATUS"	
$	wc "$	set nover"
$	wc "$	if OK then PVV HERE:''p1'"
$	wc "$	PURGE/NOLOG ''p1'.OBJ"
$!
$	if FSW1.EQS.""
$	then
$	  wc "$	PURGE/NOLOG ''p1'.FOR"
$	endif
$!
$	tmplen = f$LENGTH(FSW1)
$	if (F$LOCATE("LIST",FSW1).NE.tmplen).AND.tmplen.NE.0"
$	then
$	  wc "$	PURGE/NOLOG ''p1'.LIS"
$	endif
$!
$	wc "$	DELETE ADC.IDE;*"
$	wc "$	ws """""
$endsubroutine
