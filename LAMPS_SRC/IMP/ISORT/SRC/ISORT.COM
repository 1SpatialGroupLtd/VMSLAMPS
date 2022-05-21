$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-27 16:38:06.000000000 +0100
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
$!MOD	Changed the build directory for CMS		ST  27-Jul-1993
$!MOD	Uses shareable library images.			JMB 30-Nov-1987
$!MOD   Modified to use NEWMSG utility                  DRC 06-Aug-1987
$!MOD	Routine USER_EQUAL removed 			DRC 06_Aug-1987
$!MOD   Routine USER_EQUAL added                        DRC 05-Aug-1987
$!MOD   Newmessage F(ortran) option added		ATT 14-Jan-1987
$!MOD   Oh no it doesn't. (Test LSLLIB added)		ATT  7-Nov-1986
$!MOD	Now optionally renames general message object
$!	to LSL$GENMSG					TJH 02-Sep-1986
$!MOD	Adapted for ISORT				TJH 17-Aug-1986
$!	Created						TJH 29-Jan-1986
$!
$! Command file for building ISORT
$!
$	ON ERROR THEN GOTO ISORTEX
$	ON CONTROL_Y THEN EXIT
$!
$	DISK:='F$LOGICAL("SYS$DISK")'
$	IF "''F$LOGICAL("LSL$ISORT_BUILDING")'" .NES. "IN_PROGRESS" -
	   THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$A0:	ON CONTROL_Y THEN GOTO ISORTEX
$	DEFINE/GROUP LSL$ISORT_BUILDING "IN_PROGRESS"
$	OPEN/WRITE COMFIL ISORTBAT.COM
$	ON CONTROL_Y THEN GOTO FILCLO
$ 	ON ERROR THEN GOTO FILCLO
$	WC="WRITE COMFIL"
$!
$	WC 	"$ 	SET NOVERIFY"
$	WC	"$	ON CONTROL_Y THEN GOTO ISORTEX"
$	WC	"$	IF ""'","'F$LOGICAL(""LSL$ISORT_BUILDING"")'"" -"
$	WC	"		 .NES. ""IN_PROGRESS"" THEN GOTO A0"
$	WC	"$	WRITE SYS$OUTPUT ""Someone else is building"""
$	WC	"$	EXIT"
$	WC	"$!"
$	WC	"$A0:	DEFINE/GROUP LSL$ISORT_BUILDING ""IN_PROGRESS"""
$	WC	"$	ASSIGN LSL$SOURCE_ROOT:[IMP.ISORT.SRC] LSL$CMNISORT"
$	WC	"$	SD:=$LSL$SYS:SD"
$	WC	"$	SET NOON"
$!
$	MLDBG=""
$	FSW1=""
$	KPCOM=""
$	INQUIRE/NOP COMPILE "Compile ? "
$	IF .NOT.COMPILE THEN GOTO A04
$	INQUIRE/NOP ISORT_DBG "With Debug ? "
$	IF .NOT. ISORT_DBG THEN GOTO A04
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
$	   IF .NOT.COMPILE THEN GOTO A11
$!
$	   INQ/NOP EVERYTHING "Compile all FORTRAN sources ? "
$	   IF .NOT. EVERYTHING THEN GOTO A05
$	   CLOSEF="T"
$	   GETF="T"
$	   ISORT="T"
$	   OBEY="T"
$	   SORTF="T"
$	   SRTINFO="T"
$!	   USER_EQUAL="T"
$	   GOTO A11
$!
$ A05: 	   INQ/NOP CLOSEF	"Compile CLOSEF? 	"
$ 	   INQ/NOP GETF		"Compile GETF? 		"
$ 	   INQ/NOP ISORT	"Compile ISORT? 	"
$ 	   INQ/NOP OBEY		"Compile OBEY?	 	"
$ 	   INQ/NOP SORTF	"Compile SORTF? 	"
$ 	   INQ/NOP SRTINFO	"Compile SRTINFO?	"
$!	   INQ/NOP USER_EQUAL   "Compile USER_EQUAL?    "
$	   WRITE SYS$OUTPUT " "
$ A11:	   INQ/NOP MES "Generate message definitions ? "
$	   INQUIRE/NOP LNKIT "Link ? "
$	   IF .NOT. LNKIT THEN GOTO NOTKB
$!
$	   LINKVER="ISORT"
$	   INQUIRE/NOP ANSWER "Experimental version ? "
$	   IF ANSWER THEN LINKVER="ISORTX"
$!
$	   LINKOPTS="/MAP"
$	   INQUIRE/NOP ANSWER "Link with debug ? "
$	   IF ANSWER THEN LINKOPTS=LINKOPTS+"/DEBUG"
$!
$	   INQUIRE/NOP ANSWER "Cross reference map ? "
$	   IF ANSWER THEN LINKOPTS=LINKOPTS+"/CROSS"
$!	   
$ NOTKB:
$!
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ 		SET VERIFY"
$ 		IF .NOT. MES THEN GOTO NOMESSING
$  	        WC "$ NEWMSG/NUMBER=1029 ISORT.MES"
$  		WC "$ @ISORT.TEMP_COM "
$ NOMESSING:
$	   IF .NOT. CLD THEN GOTO FORTONLY
$		WC "$ 		ADC ISORT.TMP=ISORT_CLD.CLD"
$		WC "$ 		SET COMMAND/OBJECT=ISORT_CLD ISORT.TMP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV ISORT_CLD"
$	      	WC "$ 		DELETE ISORT.TMP;*"	
$		WC "$		PURGE/NOLOG ISORT_CLD.OBJ"
$	      	WC "$ 		OK=$STATUS"	
$!	
$ FORTONLY:		
$	IF .NOT. COMPILE THEN GOTO LNKONLY
$!
$ 	   IF .NOT. CLOSEF THEN GOTO A120
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC CLOSEF''KPCOM'=CLOSEF"
$	   	WC "$ 		FORT''FSW1' CLOSEF"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV CLOSEF"
$		WC "$ 		PURGE/NOLOG CLOSEF.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE CLOSEF.FOR;*"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG CLOSEF.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG CLOSEF.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A120:	   IF .NOT. GETF THEN GOTO A130
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC GETF''KPCOM'=GETF"
$	   	WC "$ 		FORT''FSW1' GETF"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV GETF"
$		WC "$ 		PURGE/NOLOG GETF.OBJ"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG GETF.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE GETF.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG GETF.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A130:	   IF .NOT. ISORT  THEN GOTO A140
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC ISORT''KPCOM'=ISORT"
$	   	WC "$ 		FORT''FSW1' ISORT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV ISORT"
$		WC "$ 		PURGE/NOLOG ISORT.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE ISORT.FOR;*"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG ISORT.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG ISORT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A140:	   IF .NOT. OBEY THEN GOTO A160
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC OBEY'KPCOM'=OBEY"
$	   	WC "$ 		FORT''FSW1' OBEY"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV OBEY"
$		WC "$ 		PURGE/NOLOG OBEY.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE OBEY.FOR;*"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG OBEY.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG OBEY.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$!
$ A160:	   IF .NOT. SORTF  THEN GOTO A170
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC SORTF''KPCOM'=SORTF"
$	   	WC "$ 		FORT''FSW1' SORTF"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV SORTF"
$		WC "$ 		PURGE/NOLOG SORTF.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE SORTF.FOR;*"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG SORTF.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG SORTF.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$ A170:	   IF .NOT. SRTINFO  THEN GOTO LNKONLY
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC SRTINFO''KPCOM'=SRTINFO"
$	   	WC "$ 		FORT''FSW1' SRTINFO"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV SRTINFO"
$		WC "$ 		PURGE/NOLOG SRTINFO.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE SRTINFO.FOR;*"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG SRTINFO.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG SRTINFO.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$! A180:	   IF .NOT. USER_EQUAL  THEN GOTO LNKONLY
$!		WC "$ SET NOVERIFY"
$!		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$!		WC "$ SET VERIFY"
$!		WC "$ 		ADC USER_EQUAL''KPCOM'=USER_EQUAL"
$!	   	WC "$ 		FORT''FSW1' USER_EQUAL"
$!	      	WC "$ 		OK=$STATUS"	
$!		WC "$ 		IF OK THEN PVV USER_EQUAL"
$!		WC "$ 		PURGE/NOLOG USER_EQUAL.OBJ"
$!		IF FSW1.EQS."" THEN -
$!		WC "$ 		DELETE USER_EQUAL.FOR;*"
$!		IF FSW1.NES."" THEN -
$!			WC "$ 		PURGE/NOLOG USER_EQUAL.FOR"
$!		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
$!			F$LENGTH(FSW1).NE.0 THEN -
$!				WC "$ 		PURGE/NOLOG USER_EQUAL.LIS"
$!		WC "$ 		DELETE ADC.IDE;*"
$!
$ LNKONLY:
$ 	IF .NOT. LNKIT THEN GOTO NOLNK
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$	   	WC "$ 		LINK''LINKOPTS'/EXE=''LINKVER' ISORT, -"
$	   	WC "		ISORT_CLD, CLOSEF, -"
$	   	WC "		GETF, OBEY, SORTF, SRTINFO, -"
$		WC "		ISORT.PROMSG_OBJ, -"
$!
$	   	wc "		lsl$library:iffshr/opt,lslshr/opt"
$!
$ NOLNK:
$		WC "$ 		ISORTEX:"
$		WC "$ 		DEASS/GROUP LSL$ISORT_BUILDING"
$		WC "$ 		SET NOVER"
$!
$ FILCLO:
$	SET NOVERIFY
$	ON ERROR THEN GOTO ISORTEX
$	CLOSE COMFIL
$	OK=$STATUS
$	IF OK THEN INQ/NOP ANSWER_BAT "Submit for batch ? "
$	IF .NOT. ANSWER_BAT THEN GOTO INT
$	DEASS/GROUP LSL$ISORT_BUILDING
$	BAT ISORTBAT.COM
$	GOTO ISORTX2
$ INT:	
$	IF OK THEN INQ/NOP ANSWER "Interactive ? "
$	IF .NOT.ANSWER THEN GOTO ISORTEX
$	DEASS/GROUP LSL$ISORT_BUILDING
$	@ISORTBAT.COM
$	GOTO ISORTX2
$ ISORTEX:
$	DEASS/GROUP LSL$ISORT_BUILDING
$ ISORTX2:
$	IF VER THEN SET VERIFY
