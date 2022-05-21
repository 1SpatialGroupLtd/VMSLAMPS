$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-27 12:51:26.000000000 +0100
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
$!MOD	Build directory changed for CMS			ST  27-Jul-1993
$!MOD	Adapted for ICUT 				TJH 13-may-1991
$!	Created						TJH 29-Jan-1986
$!
$! Command file for building ICUT
$!
$	ON ERROR THEN GOTO ICUTEX
$	ON CONTROL_Y THEN EXIT
$!
$	DISK:='F$LOGICAL("SYS$DISK")'
$	IF "''F$LOGICAL("LSL$ICUT_BUILDING")'" .NES. "IN_PROGRESS" -
	   THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$A0:	ON CONTROL_Y THEN GOTO ICUTEX
$	DEFINE/GROUP LSL$ICUT_BUILDING "IN_PROGRESS"
$	OPEN/WRITE COMFIL ICUTBAT.COM
$	ON CONTROL_Y THEN GOTO FILCLO
$ 	ON ERROR THEN GOTO FILCLO
$	WC="WRITE COMFIL"
$!
$	WC 	"$ 	SET NOVERIFY"
$	WC	"$	ON CONTROL_Y THEN GOTO ICUTEX"
$	WC	"$	IF ""'","'F$LOGICAL(""LSL$ICUT_BUILDING"")'"" -"
$	WC	"		 .NES. ""IN_PROGRESS"" THEN GOTO A0"
$	WC	"$	WRITE SYS$OUTPUT ""Someone else is building"""
$	WC	"$	EXIT"
$	WC	"$!"
$	WC	"$A0:	DEFINE/GROUP LSL$ICUT_BUILDING ""IN_PROGRESS"""
$	WC	"$	ASSIGN LSL$SOURCE_ROOT:[IMP.ICUT.SRC] LSL$CMNICUT"
$	WC	"$	SD:=$LSL$SYS:SD"
$	WC	"$	SET NOON"
$!
$	MLDBG=""
$	FSW1=""
$	KPCOM=""
$	INQUIRE/NOP COMPILE "Compile ? "
$	IF .NOT.COMPILE THEN GOTO A04
$	INQUIRE/NOP ICUT_DBG "With Debug ? "
$	IF .NOT. ICUT_DBG THEN GOTO A04
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
$	   OBEY="T"
$	   ICUT="T"
$	   GETF="T"
$	   GETP="T"
$	   CLOSEF="T"
$	   CHECK ="T" 
$	   CUTF ="T" 
$	   PROCESS ="T" 
$	   WRITE_NF ="T" 
$	   WRITE_cb ="T" 
$	   CHECKIFF= "T"
$	   GOTO A11
$!
$ A05:	   INQ/NOP OBEY		"Compile OBEY?	 	"
$ 	   INQ/NOP CHECK	"Compile CHECK?	 	"
$ 	   INQ/NOP GETF		"Compile GETF?	 	"
$ 	   INQ/NOP GETP		"Compile GETPAIRS?	"
$ 	   INQ/NOP CLOSEF	"Compile CLOSEF? 	"
$ 	   INQ/NOP CUTF		"Compile CUTF? 		"
$ 	   INQ/NOP CHECKIFF	"Compile CHECKIFF? 	"
$ 	   INQ/NOP PROCESS	"Compile PROCESS? 	"
$ 	   INQ/NOP WRITE_NF	"Compile WRITE_NF? 	"
$ 	   INQ/NOP WRITE_cb	"Compile WRITE_cb? 	"
$ 	   INQ/NOP ICUT		"Compile ICUT?	 	"
$	   WRITE SYS$OUTPUT " "
$ A11:	   INQ/NOP MES "Generate message definitions ? "
$	   INQUIRE/NOP LNKIT "Link ? "
$	   IF .NOT. LNKIT THEN GOTO NOTKB
$!
$	   LINKVER="ICUT"
$	   INQUIRE/NOP ANSWER "Experimental version ? "
$	   IF ANSWER THEN LINKVER="ICUTX"
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
$		WC "$		NEWMSG ICUT/number = 1221"
$		WC "$		@ICUT.temp_com
$ NOMESSING:
$	   IF .NOT. CLD THEN GOTO FORTONLY
$		WC "$ 		ADC ICUT.TMP=ICUT_CLD.CLD"
$		WC "$ 		SET COMMAND/OBJECT=ICUT_CLD ICUT.TMP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV ICUT_CLD"
$	      	WC "$ 		OK=$STATUS"	
$!	
$ FORTONLY:		
$	IF .NOT. COMPILE THEN GOTO LNKONLY

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
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$ A160:	   IF .NOT.CHECK THEN GOTO A170
$		WC "$ 		ADC CHECK'KPCOM'=CHECK"
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
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$ A170:		IF .NOT.GETF THEN GOTO A180
$		WC "$ 		ADC GETF'KPCOM'=GETF"
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
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$ A180:		IF .NOT.GETP THEN GOTO A190
$		WC "$ 		ADC GETPAIRS'KPCOM'=GETPAIRS"
$	   	WC "$ 		FORT''FSW1' GETPAIRS"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV GETPAIRS"
$		WC "$ 		PURGE/NOLOG GETPAIRS.OBJ"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG GETPAIRS.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG GETPAIRS.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG GETPAIRS.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$ A190:		IF .NOT.CLOSEF THEN GOTO A200
$		WC "$ 		ADC CLOSEF'KPCOM'=CLOSEF"
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
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$ A200:		IF .NOT.CUTF THEN GOTO A210
$		WC "$ 		ADC CUTF'KPCOM'=CUTF"
$	   	WC "$ 		FORT''FSW1' CUTF"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV CUTF"
$		WC "$ 		PURGE/NOLOG CUTF.OBJ"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG CUTF.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG CUTF.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG CUTF.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$!
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$ A210:		IF .NOT.CHECKIFF THEN GOTO A230
$		WC "$ 		ADC CHECKIFF'KPCOM'=CHECKIFF"
$	   	WC "$ 		FORT''FSW1' CHECKIFF"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV CHECKIFF"
$		WC "$ 		PURGE/NOLOG CHECKIFF.OBJ"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG CHECKIFF.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG CHECKIFF.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG CHECKIFF.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$ A230:		IF .NOT.PROCESS THEN GOTO A240
$		WC "$ 		ADC PROCESS'KPCOM'=PROCESS"
$	   	WC "$ 		FORT''FSW1' PROCESS"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV PROCESS"
$		WC "$ 		PURGE/NOLOG PROCESS.OBJ"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG PROCESS.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG PROCESS.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG PROCESS.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$ A240:		IF .NOT.WRITE_NF THEN GOTO A250
$		WC "$ 		ADC WRITE_NF'KPCOM'=WRITE_NF"
$	   	WC "$ 		FORT''FSW1' WRITE_NF"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV WRITE_NF"
$		WC "$ 		PURGE/NOLOG WRITE_NF.OBJ"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG WRITE_NF.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG WRITE_NF.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG WRITE_NF.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$ A250:		IF .NOT.WRITE_cb THEN GOTO A900
$		WC "$ 		ADC WRITE_cb'KPCOM'=WRITE_cb"
$	   	WC "$ 		FORT''FSW1' WRITE_cb"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV WRITE_cb"
$		WC "$ 		PURGE/NOLOG WRITE_cb.OBJ"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG WRITE_cb.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG WRITE_cb.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG WRITE_cb.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$ A900:	   IF .NOT. ICUT THEN GOTO LNKONLY
$		WC "$ 		ADC ICUT'KPCOM'=ICUT"
$	   	WC "$ 		FORT''FSW1' ICUT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV ICUT"
$		WC "$ 		PURGE/NOLOG ICUT.OBJ"
$		IF FSW1.NES."" THEN -
			WC "$ 		PURGE/NOLOG ICUT.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG ICUT.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG ICUT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$ LNKONLY:
$ 	IF .NOT. LNKIT THEN GOTO NOLNK
$	   	WC "$ 		LINK''LINKOPTS'/EXE=''LINKVER' ICUT, -"
$	   	WC "		ICUT_CLD, OBEY, CHECK, GETF ,GETPAIRS, -"
$		WC "		CLOSEF, CUTF, CHECKIFF, PROCESS,-"
$		WC "		WRITE_NF, WRITE_cb, -"
$		WC "		ICUT.PROMSG_OBJ, -"
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
$		WC "$ 		ICUTEX:"
$		WC "$ 		DEASS/GROUP LSL$ICUT_BUILDING"
$		WC "$ 		SET NOVER"
$!
$ FILCLO:
$	SET NOVERIFY
$	ON ERROR THEN GOTO ICUTEX
$	CLOSE COMFIL
$	OK=$STATUS
$	IF OK THEN INQ/NOP ANSWER_BAT "Submit for batch ? "
$	IF .NOT. ANSWER_BAT THEN GOTO INT
$	DEASS/GROUP LSL$ICUT_BUILDING
$	BAT ICUTBAT.COM
$	GOTO ICUTX2
$ INT:	
$	IF OK THEN INQ/NOP ANSWER "Interactive ? "
$	IF .NOT.ANSWER THEN GOTO ICUTEX
$	DEASS/GROUP LSL$ICUT_BUILDING
$	@ICUTBAT.COM
$	GOTO ICUTX2
$ ICUTEX:
$	DEASS/GROUP LSL$ICUT_BUILDING
$ ICUTX2:
$	IF VER THEN SET VERIFY
