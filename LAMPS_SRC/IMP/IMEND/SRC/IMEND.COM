$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-27 12:40:00.000000000 +0100
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
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!MOD	Changed build directory for CMS			ST  27-Jul-1993
$!MOD	Uses shareable library images			JMB 30-Nov-1987
$!MOD	Newmessage F(ortran) option added		ATT 14-Jan-1987
$!MOD	And now it doesn't				TJH 19-Nov-1986
$!MOD	Now optionally renames general message object
$!	to LSL$GENMSG					TJH 02-Sep-1986
$!	Created						TJH 12-Sep-1985
$!
$! Command file for building IMEND
$!
$	ON ERROR THEN GOTO IMENDEX
$	ON CONTROL_Y THEN EXIT
$!
$	DISK:='F$LOGICAL("SYS$DISK")'
$	IF "''F$LOGICAL("LSL$IMEND_BUILDING")'" .NES. "IN_PROGRESS" -
	   THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$A0:	ON CONTROL_Y THEN GOTO IMENDEX
$	DEFINE/GROUP LSL$IMEND_BUILDING "IN_PROGRESS"
$	OPEN/WRITE COMFIL IMENDBAT.COM
$	ON CONTROL_Y THEN GOTO FILCLO
$ 	ON ERROR THEN GOTO FILCLO
$	WC="WRITE COMFIL"
$!
$	WC 	"$ 	SET NOVERIFY"
$	WC	"$	ON CONTROL_Y THEN GOTO IMENDEX"
$	WC	"$	IF ""'","'F$LOGICAL(""LSL$IMEND_BUILDING"")'"" -"
$	WC	"		 .NES. ""IN_PROGRESS"" THEN GOTO A0"
$	WC	"$	WRITE SYS$OUTPUT ""Someone else is building"""
$	WC	"$	EXIT"
$	WC	"$!"
$	WC	"$A0:	DEFINE/GROUP LSL$IMEND_BUILDING ""IN_PROGRESS"""
$	WC	"$	SD:=$LSL$SYS:SD"
$	WC	"$	SET NOON"
$!
$	MLDBG=""
$	FSW1=""
$	KPCOM=""
$	INQUIRE/NOP COMPILE "Compile ? "
$	IF .NOT.COMPILE THEN GOTO A05
$	INQUIRE/NOP IMEND_DBG "With Debug ? "
$	IF .NOT. IMEND_DBG THEN GOTO A04
$	   FSW1="/DEBUG"
$	   MLDBG="/DEBUG"
$	   INQUIRE/NOP ANSWER "Without optimisation ? "
$	   IF ANSWER THEN FSW1=FSW1 + "/NOOPT"
$	   INQUIRE/NOP ANSWER "Check bounds and overflow ? "
$	   IF ANSWER THEN FSW1=FSW1 + "/CHECK=(BOUNDS,OVERFLOW)"
$	   INQUIRE/NOP ANSWER "With listings ? "
$	   IF ANSWER THEN FSW1=FSW1 + "/LIST"
$	   INQUIRE/NOP ANSWER "Keep FORtran sources with comments ? "
$	   IF ANSWER THEN KPCOM="/CO"
$ A04:
$	   INQ/NOP CLD "Compile CLD module ? "
$	   INQ/NOP MAIN "Compile IMEND ? "
$ A05:
$	   INQ/NOP MES "Generate message definitions ? "
$	   INQUIRE/NOP LNKIT "Link ? "
$	   IF .NOT. LNKIT THEN GOTO NOTKB
$!
$	   LINKVER="IMEND"
$	   INQUIRE/NOP ANSWER "Experimental version ? "
$	   IF ANSWER THEN LINKVER="IMENDX"
$!
$	   EXPLSL="LSL$LIBRARY:LSLSHR/OPT"
$!
$	   LINKOPTS="/MAP"
$	   INQUIRE/NOP ANSWER "Link with debug ? "
$	   IF ANSWER THEN LINKOPTS=LINKOPTS+"/DEBUG"
$!
$	   INQUIRE/NOP ANSWER "Cross reference map ? "
$	   IF ANSWER THEN LINKOPTS=LINKOPTS+"/CROSS"
$	   
$ NOTKB:
$!
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ 		SET VERIFY"
$		WC "$ 		ASSIGN LSL$SOURCE_ROOT:[IMP.IMEND.SRC] LSL$CMNIMEND"
$ 		IF .NOT. MES THEN GOTO NOMESS
$		wc "$	newmsg/number=1204/name=IMEND/prefix=IMEND__/parameter=for imend.mes"
$		wc "$ @imend.temp_com"
$!	
$ NOMESS:  IF .NOT.COMPILE THEN GOTO LNKONLY
$	   IF .NOT. CLD THEN GOTO FORTONLY
$		WC "$ 		ADC IMEND.TMP=IMEND.CLD"
$		WC "$ 		SET COMMAND/OBJECT=IMEND_CLD IMEND.TMP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV IMEND_CLD"
$		WC "$ 		IF OK THEN DELETE IMEND.TMP;*"
$		WC "$ 		IF OK THEN PURGE/NOLOG IMEND_CLD.OBJ"
$FORTONLY:		
$	   IF .NOT. MAIN THEN GOTO LNKONLY
$		WC "$ 		ADC IMEND''KPCOM'=IMEND"
$	   	WC "$ 		FORT''FSW1' IMEND"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV IMEND"
$		WC "$ 		PURGE/NOLOG IMEND.OBJ
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG IMEND.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG IMEND.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$ LNKONLY:
$ 	IF .NOT. LNKIT THEN GOTO NOLNK
$	   	WC "$ 		LINK''LINKOPTS'/EXE=''LINKVER' IMEND,IMEND_CLD,IMEND.PROMSG_OBJ, -"
$	   	WC "		LSL$LIBRARY:IFFSHR/OPT,''EXPLSL'"
$!
$ NOLNK:
$		WC "$ 		IMENDEX:"
$		WC "$ 		DEASS/GROUP LSL$IMEND_BUILDING"
$		WC "$ 		SET NOVER"
$!
$ FILCLO:
$	SET NOVERIFY
$	ON ERROR THEN GOTO IMENDEX
$	CLOSE COMFIL
$	OK=$STATUS
$	IF OK THEN INQ/NOP ANSWER_BAT "Submit for batch ? "
$	IF .NOT. ANSWER_BAT THEN GOTO INT
$	DEASS/GROUP LSL$IMEND_BUILDING
$	BAT IMENDBAT.COM
$	GOTO IMENDEX2
$ INT:	
$	IF OK THEN INQ/NOP ANSWER "Interactive ? "
$	IF .NOT.ANSWER THEN GOTO IMENDEX
$	DEASS/GROUP LSL$IMEND_BUILDING
$	@IMENDBAT.COM
$	GOTO IMENDEX2
$ IMENDEX:
$	DEASS/GROUP LSL$IMEND_BUILDING
$ IMENDEX2:
$	IF VER THEN SET VERIFY
