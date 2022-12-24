$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-06-01 16:59:54.000000000 +0100
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
$!MOD	Replace NEWMESSAGE with NEWMSG			AJV 01-Jun-1990
$!MOD	Newmessage F(ortran) option added		ATT 14-Jan-1987
$!MOD	Option to link with testing LSLLIB 		TJH 03-Nov-1986
$!	Created					 	TJH 30-Sep-1986
$!
$! Command file for building IREPORT
$!
$	ON ERROR THEN GOTO IREPORTEX
$	ON CONTROL_Y THEN EXIT
$!
$	DISK:='F$LOGICAL("SYS$DISK")'
$	IF "''F$LOGICAL("LSL$IREPORT_BUILDING")'" .NES. "IN_PROGRESS" -
	   THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$!
$ A0:	ON CONTROL_Y THEN GOTO IREPORTEX
$	DEFINE/GROUP LSL$IREPORT_BUILDING "IN_PROGRESS"
$	OPEN/WRITE COMFIL IREPORTBAT.COM
$	ON CONTROL_Y THEN GOTO FILCLO
$ 	ON ERROR THEN GOTO FILCLO
$	WC="WRITE COMFIL"
$!
$	WC 	"$ 	SET NOVERIFY"
$	WC	"$	ON CONTROL_Y THEN GOTO IREPORTEX"
$	WC	"$	IF ""'","'F$LOGICAL(""LSL$IREPORT_BUILDING"")'"" -"
$	WC	"		 .NES. ""IN_PROGRESS"" THEN GOTO A0"
$	WC	"$	WRITE SYS$OUTPUT ""Someone else is building"""
$	WC	"$	EXIT"
$	WC	"$!"
$	WC	"$ A0:	DEFINE/GROUP LSL$IREPORT_BUILDING ""IN_PROGRESS"""
$	WC	"$	ASSIGN LSL$DISK:[IFF.IMP.IREPORT] LSL$CMNIREPORT"
$	WC	"$	SD:=$LSL$SYS:SD"
$	WC	"$	SET NOON"
$!
$	MLDBG=""
$	FSW1=""
$	KPCOM=""
$	INQUIRE/NOP COMPILE "Compile ? "
$	IF .NOT.COMPILE THEN GOTO A04
$	INQUIRE/NOP IREPORT_DBG "With Debug ? "
$	IF .NOT. IREPORT_DBG THEN GOTO A04
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
$	   INQ/NOP CLD "Compile CLD modules ? "
$	   IF .NOT.COMPILE THEN GOTO A11
$!
$	   INQ/NOP EVERYTHING "Compile all FORTRAN sources ? "
$	   IF .NOT. EVERYTHING THEN GOTO A05
$!
$	   GET_COM_LIN="T"
$	   FILEINI="T"
$	   WRTCMD="T"
$	   LITES2M="T"
$	   NO_REPORT="T"
$	   EO_REPORT="T"
$	   CC_REPORT="T"
$	   CP_REPORT="T"
$	   EJ_REPORT="T"
$	   NS_REPORT="T"
$	   AC_REPORT="T"
$	   CB_REPORT="T"
$	   IREPORT="T"
$	   FC_REPORT="T"
$	   EF_REPORT="T"
$	   NF_REPORT="T"
$	   ST_REPORT="T"
$	   ZS_REPORT="T"
$	   RO_REPORT="T"
$	   TC_REPORT="T"
$	   TH_REPORT="T"
$	   TS_REPORT="T"
$	   TX_REPORT="T"
$	   GOTO A11
$!
$ A05:
$	   INQ/NOP AC_REPORT "Compile AC_REPORT? "
$	   INQ/NOP CB_REPORT "Compile CB_REPORT? "
$	   INQ/NOP CC_REPORT "Compile CC_REPORT? "
$	   INQ/NOP CP_REPORT "Compile CP_REPORT? "
$	   INQ/NOP EF_REPORT "Compile EF_REPORT? "
$	   INQ/NOP EO_REPORT "Compile EO_REPORT? "
$	   INQ/NOP FC_REPORT "Compile FC_REPORT? "
$	   INQ/NOP GET_COM_LIN "Compile GET_COM_LIN? "
$	   INQ/NOP EJ_REPORT "Compile EJ_REPORT? "
$	   INQ/NOP IREPORT  "Compile IREPORT? "
$	   INQ/NOP LITES2M "Compile LITES2M? "
$	   INQ/NOP NF_REPORT "Compile NF_REPORT? "
$	   INQ/NOP NS_REPORT "Compile NS_REPORT? "
$	   INQ/NOP NO_REPORT "Compile NO_REPORT? "
$	   INQ/NOP FILEINI "Compile FILEINI? "
$	   INQ/NOP RO_REPORT "Compile RO_REPORT? "
$	   INQ/NOP ST_REPORT "Compile ST_REPORT? "
$	   INQ/NOP TC_REPORT "Compile TC_REPORT? "
$	   INQ/NOP TH_REPORT "Compile TH_REPORT? "
$	   INQ/NOP TS_REPORT "Compile TS_REPORT? "
$	   INQ/NOP TX_REPORT "Compile TX_REPORT? "
$	   INQ/NOP WRTCMD "Compile WRTCMD? "
$	   INQ/NOP ZS_REPORT "Compile ZS_REPORT? "
$!
$	   GOTO A11
$!
$ A11:	   INQ/NOP MES "Generate message definitions? "
$!
$	   INQUIRE/NOP LNKIT "Link? "
$	   IF .NOT. LNKIT THEN GOTO NOTKB
$!
$	   LINKVER="IREPORT"
$	   INQUIRE/NOP ANSWER "Experimental version ? "
$	   IF ANSWER THEN LINKVER="IREPORTX"
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
$! New message generation AJV 1-JUN-1990
$		WC "$ 	NEWMSG IREPORT /NUMBER=1215/PREFIX=IREPORT__"
$		WC "$	@IREPORT.TEMP_COM"
$! Old message generation
$! 		WC "$	NEWMESSAGE IREPORT.MES IREPORT 1215 IREPORT__ N F"
$ NOMESSING:
$	   IF .NOT. CLD THEN GOTO FORTONLY
$		WC "$ 		ADC IREPORT.TMP=IREPORT.CLD"
$		WC "$ 		SET COMMAND/OBJECT=IREPORT_CLD IREPORT.TMP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV IREPORT_CLD"
$		WC "$ 		IF OK THEN DELETE IREPORT.TMP;*"
$		WC "$ 		IF OK THEN PURGE/NOLOG IREPORT_CLD.OBJ"
$	
$ FORTONLY:		
$	IF .NOT. COMPILE THEN GOTO LNKONLY
$	   IF .NOT. AC_REPORT THEN GOTO A110
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ 		ADC AC_REPORT''KPCOM'=AC_REPORT"
$	   	WC "$ 		FORT''FSW1' AC_REPORT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV AC_REPORT"
$		WC "$ 		PURGE/NOLOG AC_REPORT.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG AC_REPORT.FOR;*"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG AC_REPORT.FOR"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A110:	   IF .NOT. CB_REPORT THEN GOTO A115
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC CB_REPORT''KPCOM'=CB_REPORT"
$	   	WC "$ 		FORT''FSW1' CB_REPORT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV CB_REPORT"
$		WC "$ 		PURGE/NOLOG CB_REPORT.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG CB_REPORT.FOR;*"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG CB_REPORT.FOR"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A115:	   IF .NOT. CC_REPORT THEN GOTO A120
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC CC_REPORT''KPCOM'=CC_REPORT"
$	   	WC "$ 		FORT''FSW1' CC_REPORT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV CC_REPORT"
$		WC "$ 		PURGE/NOLOG CC_REPORT.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG CC_REPORT.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG CC_REPORT.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG CC_REPORT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A120:	   IF .NOT. CP_REPORT THEN GOTO A130
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC CP_REPORT''KPCOM'=CP_REPORT"
$	   	WC "$ 		FORT''FSW1' CP_REPORT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV CP_REPORT"
$		WC "$ 		PURGE/NOLOG CP_REPORT.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG CP_REPORT.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG CP_REPORT.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG CP_REPORT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A130:	   IF .NOT. EF_REPORT THEN GOTO A140
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC EF_REPORT''KPCOM'=EF_REPORT"
$	   	WC "$ 		FORT''FSW1' EF_REPORT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV EF_REPORT"
$		WC "$ 		PURGE/NOLOG EF_REPORT.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG EF_REPORT.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG EF_REPORT.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG EF_REPORT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A140:	   IF .NOT. EO_REPORT THEN GOTO A150
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC EO_REPORT''KPCOM'=EO_REPORT"
$	   	WC "$ 		FORT''FSW1' EO_REPORT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV EO_REPORT"
$		WC "$ 		PURGE/NOLOG EO_REPORT.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG EO_REPORT.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG EO_REPORT.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG EO_REPORT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A150:	   IF .NOT. FC_REPORT THEN GOTO A160
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC FC_REPORT''KPCOM'=FC_REPORT"
$	   	WC "$ 		FORT''FSW1' FC_REPORT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV FC_REPORT"
$		WC "$ 		PURGE/NOLOG FC_REPORT.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG FC_REPORT.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG FC_REPORT.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG FC_REPORT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A160:	   IF .NOT. GET_COM_LIN THEN GOTO A170
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC GET_COM_LIN''KPCOM'=GET_COM_LIN"
$	   	WC "$ 		FORT''FSW1' GET_COM_LIN"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV GET_COM_LIN"
$		WC "$ 		PURGE/NOLOG GET_COM_LIN.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG GET_COM_LIN.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG GET_COM_LIN.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG GET_COM_LIN.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A170:	   IF .NOT. EJ_REPORT THEN GOTO A175
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC EJ_REPORT''KPCOM'=EJ_REPORT"
$	   	WC "$ 		FORT''FSW1' EJ_REPORT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV EJ_REPORT"
$		WC "$ 		PURGE/NOLOG EJ_REPORT.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG EJ_REPORT.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG EJ_REPORT.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG EJ_REPORT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A175:	   IF .NOT. IREPORT THEN GOTO A180
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC IREPORT''KPCOM'=IREPORT"
$	   	WC "$ 		FORT''FSW1' IREPORT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV IREPORT"
$		WC "$ 		PURGE/NOLOG IREPORT.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG IREPORT.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG IREPORT.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG IREPORT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A180:	   IF .NOT. LITES2M THEN GOTO A190
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC LITES2M''KPCOM'=LITES2M"
$	   	WC "$ 		FORT''FSW1' LITES2M"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV LITES2M"
$		WC "$ 		PURGE/NOLOG LITES2M.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG LITES2M.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG LITES2M.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG LITES2M.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A190:	   IF .NOT. NF_REPORT THEN GOTO A200
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC NF_REPORT''KPCOM'=NF_REPORT"
$	   	WC "$ 		FORT''FSW1' NF_REPORT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV NF_REPORT"
$		WC "$ 		PURGE/NOLOG NF_REPORT.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG NF_REPORT.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG NF_REPORT.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG NF_REPORT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A200:	   IF .NOT. NS_REPORT THEN GOTO A210
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC NS_REPORT''KPCOM'=NS_REPORT"
$	   	WC "$ 		FORT''FSW1' NS_REPORT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV NS_REPORT"
$		WC "$ 		PURGE/NOLOG NS_REPORT.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG NS_REPORT.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG NS_REPORT.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG NS_REPORT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A210:	   IF .NOT. NO_REPORT THEN GOTO A220
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC NO_REPORT''KPCOM'=NO_REPORT"
$	   	WC "$ 		FORT''FSW1' NO_REPORT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV NO_REPORT"
$		WC "$ 		PURGE/NOLOG NO_REPORT.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG NO_REPORT.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG NO_REPORT.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG NO_REPORT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A220:	   IF .NOT. FILEINI THEN GOTO A230
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC FILEINI''KPCOM'=FILEINI"
$	   	WC "$ 		FORT''FSW1' FILEINI"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV FILEINI"
$		WC "$ 		PURGE/NOLOG FILEINI.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG FILEINI.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG FILEINI.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG FILEINI.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A230:	   IF .NOT. WRTCMD THEN GOTO A240
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC WRTCMD''KPCOM'=WRTCMD"
$	   	WC "$ 		FORT''FSW1' WRTCMD"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV WRTCMD"
$		WC "$ 		PURGE/NOLOG WRTCMD.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG WRTCMD.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG WRTCMD.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG WRTCMD.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A240:	   IF .NOT. RO_REPORT THEN GOTO A250
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC RO_REPORT''KPCOM'=RO_REPORT"
$	   	WC "$ 		FORT''FSW1' RO_REPORT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV RO_REPORT"
$		WC "$ 		PURGE/NOLOG RO_REPORT.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG RO_REPORT.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG RO_REPORT.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG RO_REPORT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A250:	   IF .NOT. ST_REPORT THEN GOTO A260
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC ST_REPORT''KPCOM'=ST_REPORT"
$	   	WC "$ 		FORT''FSW1' ST_REPORT"
$	      	WC "$ 		OK=$STATUS	
$		WC "$ 		IF OK THEN PVV ST_REPORT"
$		WC "$ 		PURGE/NOLOG ST_REPORT.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG ST_REPORT.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG ST_REPORT.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG ST_REPORT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A260:	   IF .NOT. TC_REPORT THEN GOTO A270
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ 		ADC TC_REPORT''KPCOM'=TC_REPORT"
$	   	WC "$ 		FORT''FSW1' TC_REPORT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV TC_REPORT"
$		WC "$ 		PURGE/NOLOG TC_REPORT.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG TC_REPORT.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG TC_REPORT.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG TC_REPORT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A270:	   IF .NOT. TH_REPORT THEN GOTO A280
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC TH_REPORT''KPCOM'=TH_REPORT"
$	   	WC "$ 		FORT''FSW1' TH_REPORT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV TH_REPORT"
$		WC "$ 		PURGE/NOLOG TH_REPORT.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG TH_REPORT.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG TH_REPORT.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG TH_REPORT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A280:	   IF .NOT.  TS_REPORT THEN GOTO A290
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC TS_REPORT''KPCOM'=TS_REPORT"
$	   	WC "$ 		FORT''FSW1' TS_REPORT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV TS_REPORT"
$		WC "$ 		PURGE/NOLOG TS_REPORT.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG TS_REPORT.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG TS_REPORT.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG TS_REPORT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A290:	   IF .NOT. TX_REPORT THEN GOTO A300
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC TX_REPORT''KPCOM'=TX_REPORT"
$	   	WC "$ 		FORT''FSW1' TX_REPORT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV TX_REPORT"
$		WC "$ 		PURGE/NOLOG TX_REPORT.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG TX_REPORT.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG TX_REPORT.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG TX_REPORT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A300:	   IF .NOT. ZS_REPORT THEN GOTO LNKONLY
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC ZS_REPORT''KPCOM'=ZS_REPORT"
$	   	WC "$ 		FORT''FSW1' ZS_REPORT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV ZS_REPORT"
$		WC "$ 		PURGE/NOLOG ZS_REPORT.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG ZS_REPORT.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG ZS_REPORT.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG ZS_REPORT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ LNKONLY:
$ 	IF .NOT. LNKIT THEN GOTO NOLNK
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$	   	WC "$	LINK''LINKOPTS'/EXE=''LINKVER' -"
$		WC "	IREPORT,IREPORT_CLD, -"
$		WC "	AC_REPORT,CC_REPORT,CP_REPORT,EF_REPORT,-"
$		WC "	EO_REPORT,FC_REPORT,GET_COM_LIN,EJ_REPORT,LITES2M,-"
$		WC "	NF_REPORT,NS_REPORT,NO_REPORT,FILEINI,-"
$		WC "	WRTCMD,RO_REPORT,ST_REPORT,CB_REPORT,-"
$		WC "	TC_REPORT,TH_REPORT,TS_REPORT,TX_REPORT,-"
$		WC "	ZS_REPORT, IREPORT.PROMSG_OBJ,-"
$		WC "    LSL$LIBRARY:IFFlib.Olb/lib,-"
$		WC "    LSL$SOURCE_ROOT:[LSLMAINT.LSLLIB.TEST]LSLLIB/OPT,-"
$		WC "	LSL$LIBRARY:LSLFRTLIB/LIB"
$!
$ NOLNK:
$		WC "$ 		IREPORTEX:"
$		WC "$ 		DEASS/GROUP LSL$IREPORT_BUILDING"
$		WC "$ 		SET NOVER"
$!
$ FILCLO:
$	SET NOVERIFY
$	ON ERROR THEN GOTO IREPORTEX
$	CLOSE COMFIL
$	OK=$STATUS
$	IF OK THEN INQ/NOP ANSWER_BAT "Submit for batch ? "
$	IF .NOT. ANSWER_BAT THEN GOTO INT
$	DEASS/GROUP LSL$IREPORT_BUILDING
$	BAT IREPORTBAT.COM
$	GOTO IREPORTX2
$ INT:	
$	IF OK THEN INQ/NOP ANSWER "Interactive ? "
$	IF .NOT.ANSWER THEN GOTO IREPORTEX
$	DEASS/GROUP LSL$IREPORT_BUILDING
$	@IREPORTBAT.COM
$	GOTO IREPORTX2
$ IREPORTEX:
$	DEASS/GROUP LSL$IREPORT_BUILDING
$ IREPORTX2:
$	IF VER THEN SET VERIFY
