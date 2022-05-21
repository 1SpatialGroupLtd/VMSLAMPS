$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-27 16:32:20.000000000 +0100
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
$!MOD	Uses library shareable images			JMB 30-Nov-1987
$!MOD	Newmessage F(ortran) option added		ATT 14-Jan-1987
$!MOD	Option to link with testing LSLLIB 		TJH 03-Nov-1986
$!MOD	Now doesn't rename general message object	ATT 04-Nov-1986
$!MOD	Now optionally renames general message object
$!	to LSL$GENMSG					TJH 02-Sep-1986
$!MOD	Adapted for ISELECT 				TJH 13-Aug-1986
$!	Created						TJH 29-Jan-1986
$!
$! Command file for building ISELECT
$!
$	ON ERROR THEN GOTO ISELECTEX
$	ON CONTROL_Y THEN EXIT
$!
$	DISK:='F$LOGICAL("SYS$DISK")'
$	IF "''F$LOGICAL("LSL$ISELECT_BUILDING")'" .NES. "IN_PROGRESS" -
	   THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$A0:	ON CONTROL_Y THEN GOTO ISELECTEX
$	DEFINE/GROUP LSL$ISELECT_BUILDING "IN_PROGRESS"
$	OPEN/WRITE COMFIL ISELECTBAT.COM
$	ON CONTROL_Y THEN GOTO FILCLO
$ 	ON ERROR THEN GOTO FILCLO
$	WC="WRITE COMFIL"
$!
$	WC 	"$ 	SET NOVERIFY"
$	WC	"$	ON CONTROL_Y THEN GOTO ISELECTEX"
$	WC	"$	IF ""'","'F$LOGICAL(""LSL$ISELECT_BUILDING"")'"" -"
$	WC	"		 .NES. ""IN_PROGRESS"" THEN GOTO A0"
$	WC	"$	WRITE SYS$OUTPUT ""Someone else is building"""
$	WC	"$	EXIT"
$	WC	"$!"
$	WC	"$A0:	DEFINE/GROUP LSL$ISELECT_BUILDING ""IN_PROGRESS"""
$	WC	"$	ASSIGN LSL$SOURCE_ROOT:[IMP.ISELECT.SRC] LSL$CMNISELECT"
$	WC	"$	SD:=$LSL$SYS:SD"
$	WC	"$	SET NOON"
$!
$	MLDBG=""
$	FSW1=""
$	KPCOM=""
$	INQUIRE/NOP COMPILE "Compile ? "
$	IF .NOT.COMPILE THEN GOTO A04
$	INQUIRE/NOP ISELECT_DBG "With Debug ? "
$	IF .NOT. ISELECT_DBG THEN GOTO A04
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
$	   CHECK="T"
$	   CLOSEF="T"
$	   GETF="T"
$	   ISELECT="T"
$	   MY_REAL="T"
$	   OBEY="T"
$	   RANGE="T"
$	   SELECTF="T"
$	   COPY_FT="T"
$	   GOTO A11
$!
$ A05:	   INQ/NOP CHECK	"Compile CHECK ? 	"
$ 	   INQ/NOP CLOSEF	"Compile CLOSEF? 	"
$ 	   INQ/NOP GETF		"Compile GETF? 		"
$ 	   INQ/NOP ISELECT	"Compile ISELECT? 	"
$ 	   INQ/NOP MY_REAL	"Compile MY_REAL? 	"
$ 	   INQ/NOP OBEY		"Compile OBEY?	 	"
$ 	   INQ/NOP RANGE	"Compile RANGE? 	"
$ 	   INQ/NOP SELECTF	"Compile SELECTF? 	"
$ 	   INQ/NOP COPY_FT	"Compile COPY_FT?	"
$	   WRITE SYS$OUTPUT " "
$ A11:	   INQ/NOP MES "Generate message definitions ? "
$	   INQUIRE/NOP LNKIT "Link ? "
$	   IF .NOT. LNKIT THEN GOTO NOTKB
$!
$	   LINKVER="ISELECT"
$	   INQUIRE/NOP ANSWER "Experimental version ? "
$	   IF ANSWER THEN LINKVER="ISELECTX"
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
$ 		IF .NOT. MES THEN GOTO NOMESSING
$		WC "$		NEWMSG iselect/number = 1206"
$		WC "$		@iselect.temp_com
$ NOMESSING:
$	   IF .NOT. CLD THEN GOTO FORTONLY
$		WC "$ 		ADC ISELECT.TMP=ISELECT_CLD.CLD"
$		WC "$ 		SET COMMAND/OBJECT=ISELECT_CLD ISELECT.TMP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV ISELECT_CLD"
$	      	WC "$ 		OK=$STATUS"	
$!	
$ FORTONLY:		
$	IF .NOT. COMPILE THEN GOTO LNKONLY
$	   IF .NOT. CHECK THEN GOTO A110
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ 		ADC CHECK''KPCOM'=CHECK"
$	   	WC "$ 		FORT''FSW1' CHECK"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV CHECK"
$		WC "$ 		PURGE/NOLOG CHECK.OBJ"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG CHECK.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG CHECK.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG CHECK.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A110:	   IF .NOT. CLOSEF THEN GOTO A120
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC CLOSEF''KPCOM'=CLOSEF"
$	   	WC "$ 		FORT''FSW1' CLOSEF"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV CLOSEF"
$		WC "$ 		PURGE/NOLOG CLOSEF.OBJ"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG CLOSEF.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG CLOSEF.FOR;*"
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
			WC "$ 		DELETE/NOLOG GETF.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG GETF.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A130:	   IF .NOT. ISELECT  THEN GOTO A140
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC ISELECT''KPCOM'=ISELECT"
$	   	WC "$ 		FORT''FSW1' ISELECT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV ISELECT"
$		WC "$ 		PURGE/NOLOG ISELECT.OBJ"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG ISELECT.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG ISELECT.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG ISELECT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A140:	   IF .NOT. MY_REAL  THEN GOTO A150
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC MY_REAL''KPCOM'=MY_REAL"
$	   	WC "$ 		FORT''FSW1' MY_REAL"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV MY_REAL"
$		WC "$ 		PURGE/NOLOG MY_REAL.OBJ"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG MY_REAL.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG MY_REAL.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG MY_REAL.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A150:	   IF .NOT. OBEY THEN GOTO A160
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC OBEY'KPCOM'=OBEY"
$	   	WC "$ 		FORT''FSW1' OBEY"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV OBEY"
$		WC "$ 		PURGE/NOLOG OBEY.OBJ"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG OBEY.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG OBEY.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG OBEY.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A160:	   IF .NOT. RANGE  THEN GOTO A170
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC RANGE''KPCOM'=RANGE"
$	   	WC "$ 		FORT''FSW1' RANGE"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV RANGE"
$		WC "$ 		PURGE/NOLOG RANGE.OBJ"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG RANGE.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG RANGE.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG RANGE.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A170:	   IF .NOT. SELECTF  THEN GOTO A180
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC SELECTF''KPCOM'=SELECTF"
$	   	WC "$ 		FORT''FSW1' SELECTF"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV SELECTF"
$		WC "$ 		PURGE/NOLOG SELECTF.OBJ"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG SELECTF.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG SELECTF.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG SELECTF.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$A180:
$ 	   	IF .NOT. COPY_FT THEN GOTO LNKONLY
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC COPY_FT''KPCOM'=COPY_FT"
$	   	WC "$ 		FORT''FSW1' COPY_FT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV COPY_FT"
$		WC "$ 		PURGE/NOLOG COPY_FT.OBJ"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG COPY_FT.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG COPY_FT.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG COPY_FT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$!
$ LNKONLY:
$ 	IF .NOT. LNKIT THEN GOTO NOLNK
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$	   	WC "$ 		LINK''LINKOPTS'/EXE=''LINKVER' ISELECT, -"
$	   	WC "		ISELECT_CLD, CHECK, CLOSEF, -"
$	   	WC "		GETF, MY_REAL, OBEY, RANGE, -"
$		WC "		SELECTF, COPY_FT, -"
$		WC "		ISELECT.PROMSG_OBJ, -"
$!!!	   	WC "		LSL$LIBRARY:IFFSHR/OPT,LSLSHR/OPT"
$!
$! test LSLLIB for new IFF open stuff
$!
$	   	wc "		lsl$library:iffSHR/OPT, -"
$	   	wc "		''explsl', -"
$	   	wc "		LSL$LIBRARY:LSLLIB/include=DCL_ERRET, -"
$		wc "		SYS$INPUT:/opt"
$	   	wc "		psect_attr=LSL_REPORT,noshr"
$!
$ NOLNK:
$		WC "$ 		ISELECTEX:"
$		WC "$ 		DEASS/GROUP LSL$ISELECT_BUILDING"
$		WC "$ 		SET NOVER"
$!
$ FILCLO:
$	SET NOVERIFY
$	ON ERROR THEN GOTO ISELECTEX
$	CLOSE COMFIL
$	OK=$STATUS
$	IF OK THEN INQ/NOP ANSWER_BAT "Submit for batch ? "
$	IF .NOT. ANSWER_BAT THEN GOTO INT
$	DEASS/GROUP LSL$ISELECT_BUILDING
$	BAT ISELECTBAT.COM
$	GOTO ISELECTX2
$ INT:	
$	IF OK THEN INQ/NOP ANSWER "Interactive ? "
$	IF .NOT.ANSWER THEN GOTO ISELECTEX
$	DEASS/GROUP LSL$ISELECT_BUILDING
$	@ISELECTBAT.COM
$	GOTO ISELECTX2
$ ISELECTEX:
$	DEASS/GROUP LSL$ISELECT_BUILDING
$ ISELECTX2:
$	IF VER THEN SET VERIFY
