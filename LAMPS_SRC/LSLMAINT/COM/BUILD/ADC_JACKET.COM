$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1995-01-27 18:23:06.000000000 +0000
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
$	ver=f$verify(0)
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! ADC_JACKET.COM			Author:	Steve Townrow	25-Jan-1995
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Command file necessary because the command line of the old ADC
$! (written in BCPL) is different to the new ADC (re-written as ADCC)
$!
$! In order for existing LAMPS utilites to use ADC with out having to
$! alter the format of the ADC command line, this DCL procedure will alter
$! the command line and call ADCC in the correct way. When compiling on the
$! VAX, the original ADC program will be used.
$!
$! The format of the old ADC is :
$!
$!	ADC RDPAR/CO = RDPAR,RDLAYER,RDENTITY,RDTEXT
$!
$! which must be turned into:
$!
$!	ADCC/COMMENT=ALL RDPAR,RDLAYER,RDENTITY,RDTEXT  RDPAR
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Check the system architecture for OpenVMS Alpha AXP
$!
$	ARCH_NAME=F$GETSYI("ARCH_NAME")
$!
$! Append all the parameters together in case the arguments were
$! separated by spaces
$!
$	CLINE = P1+P2+P3+P4+P5+P6+P7+P8
$	IF F$LENGTH(CLINE).EQ.0
$	THEN
$	   IF VER THEN WRITE SYS$OUTPUT "No arguments given to ADC"
$	   GOTO the_end
$	ENDIF
$!
$! First, lets find the '=' and split up the line
$!
$	POS = F$LOCATE("=",CLINE)
$	IF POS.EQ.F$LENGTH(CLINE)
$	THEN
$	   IF VER THEN WRITE SYS$OUTPUT "No equals (=) on ADC command line"
$	   GOTO the_end
$	ENDIF
$	LEFTSTR = F$EXTRACT(0,POS,CLINE)
$	RGHTSTR = F$EXTRACT(POS+1,F$LENGTH(CLINE),CLINE)
$!
$! Now work on the left string to get the output filename
$!
$	POS = F$LOCATE("/",LEFTSTR)
$	OUTFILE = F$EXTRACT(0,POS,LEFTSTR)
$!
$! Now look for any qualifiers
$!
$	QUALLINE = F$EXTRACT(POS+1,F$LENGTH(LEFTSTR),LEFTSTR)
$!
$! Put slash ('/') on end to find last qualifier
$!
$	QUALLINE = QUALLINE + "/"
$	OUTQ = ""
$!
$again:
$	POS = F$LOCATE("/",QUALLINE)
$	IF POS.LT.F$LENGTH(QUALLINE)
$	THEN
$	   QUAL = F$EXTRACT(0,POS,QUALLINE)
$	   IF F$EXTRACT(0,2,QUAL).EQS."SP" THEN OUTQ = OUTQ + "/PRINT"
$	   IF F$EXTRACT(0,2,QUAL).EQS."AP" THEN OUTQ = OUTQ + "/APPEND"
$	   IF F$EXTRACT(0,2,QUAL).EQS."TH" THEN OUTQ = OUTQ + "/THREAD"
$	   IF F$EXTRACT(0,2,QUAL).EQS."LN" THEN OUTQ = OUTQ + "/LN"
$	   IF F$EXTRACT(0,2,QUAL).EQS."CO" THEN OUTQ = OUTQ + "/COMMENT=ALL"
$	   IF F$EXTRACT(0,2,QUAL).EQS."LI" THEN OUTQ = OUTQ + "/COMMENT=OUTER"
$	   IF F$EXTRACT(0,2,QUAL).EQS."DE" THEN OUTQ = OUTQ + "/DEBUG"
$	   IF F$EXTRACT(0,2,QUAL).EQS."CD" THEN OUTQ = OUTQ + "/CD"
$	   IF F$EXTRACT(0,2,QUAL).EQS."LL" THEN OUTQ = OUTQ + "/"+QUAL
$	   IF F$EXTRACT(0,2,QUAL).EQS."IN" THEN OUTQ = OUTQ + "/IN"
$	   IF F$EXTRACT(0,2,QUAL).EQS."TR" THEN OUTQ = OUTQ + "/TR"
$	   QUALLINE = F$EXTRACT(POS+1,F$LENGTH(QUALLINE),QUALLINE)
$	   GOTO again
$	ENDIF
$!
$! Run appropriate version of ADC
$!
$	IF ARCH_NAME.EQS."VAX"
$	THEN
$	   ADCPROG == "$LSL$EXE:ADC.EXE"
$	   IF VER THEN WRITE SYS$OUTPUT "$ ADC "+CLINE
$	ENDIF
$!
$	IF ARCH_NAME.EQS."Alpha"
$	THEN
$	   ADCPROG == "$LSL$EXE:ADCC_TV.EXE"
$	   CLINE = OUTQ+" "+RGHTSTR+" "+OUTFILE
$	   IF VER THEN WRITE SYS$OUTPUT "$ ADCC "+CLINE
$	ENDIF
$!
$! Execute it.
$!
$	ADCPROG 'CLINE
$!
$the_end:
$	IF VER THEN SET VERIFY
