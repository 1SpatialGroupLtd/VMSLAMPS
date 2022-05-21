$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-27 13:45:26.000000000 +0100
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
$!
$!MOD	Changed build directoy for CMS			ST  27-Jul-1993
$!MOD	Link with shareable IFFLIB and LSLLIB
$!      and implement CB handling			TJH 03-Dec-1987
$!MOD	Newmessage GENMSG option removed		TJH 27-Mar-1987
$!MOD	Newmessage F(ortran) option added		ATT 14-Jan-1987
$!MOD	Option to link with test LSLLIB 		TJH 03-Nov-1986
$!MOD	And now it doesn't!				TJH 30-Oct-1986
$!MOD	Now optionally renames general message object
$!	to LSL$GENMSG					TJH 02-Sep-1986
$!	Created						TJH 29-Jan-1986
$!
$! Command file for building IMERGE
$!
$	ON ERROR THEN GOTO IMERGEEX
$	ON CONTROL_Y THEN EXIT
$!
$	DISK:='F$LOGICAL("SYS$DISK")'
$	IF "''F$LOGICAL("LSL$IMERGE_BUILDING")'" .NES. "IN_PROGRESS" -
	   THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$A0:	ON CONTROL_Y THEN GOTO IMERGEEX
$	DEFINE/GROUP LSL$IMERGE_BUILDING "IN_PROGRESS"
$	OPEN/WRITE COMFIL IMERGEBAT.COM
$	ON CONTROL_Y THEN GOTO FILCLO
$ 	ON ERROR THEN GOTO FILCLO
$	WC="WRITE COMFIL"
$!
$	WC 	"$ 	SET NOVERIFY"
$	WC	"$	ON CONTROL_Y THEN GOTO IMERGEEX"
$	WC	"$	IF ""'","'F$LOGICAL(""LSL$IMERGE_BUILDING"")'"" -"
$	WC	"		 .NES. ""IN_PROGRESS"" THEN GOTO A0"
$	WC	"$	WRITE SYS$OUTPUT ""Someone else is building"""
$	WC	"$	EXIT"
$	WC	"$!"
$	WC	"$A0:	DEFINE/GROUP LSL$IMERGE_BUILDING ""IN_PROGRESS"""
$	WC	"$	ASSIGN LSL$SOURCE_ROOT:[IMP.IMERGE.SRC] LSL$CMNIMERGE"
$	WC	"$	SD:=$LSL$SYS:SD"
$	WC	"$	SET NOON"
$!
$	RENMES=""
$	MLDBG=""
$	FSW1=""
$	KPCOM=""
$	INQUIRE/NOP COMPILE "Compile ? "
$	IF .NOT.COMPILE THEN GOTO A04
$	INQUIRE/NOP IMERGE_DBG "With Debug ? "
$	IF .NOT. IMERGE_DBG THEN GOTO A04
$	   FSW1="/DEBUG"
$	   MLDBG="/DEBUG"
$	   INQUIRE/NOP ANSWER "Without optimisation ? "
$	   IF ANSWER THEN FSW1=FSW1 + "/NOOPT"
$	   INQUIRE/NOP ANSWER "Check bounds and overflow ? "
$	   IF ANSWER THEN FSW1=FSW1 + "/CHECK=(BOUNDS,OVERFLOW)"
$	   INQUIRE/NOP ANSWER "With listings ? "
$	   IF ANSWER THEN FSW1=FSW1 + "/LIST"
$	   IF (F$LOCATE("/LIST",FSW1).EQ.F$LENGTH(FSW1)) THEN  -
					FSW1=FSW1 + "/NOLIST"
$	   INQUIRE/NOP ANSWER "Keep FORtran sources with comments ? "
$	   IF ANSWER THEN KPCOM="/CO"
$ A04:
$	   INQ/NOP CLD "Compile CLD modules ? "
$	   IF .NOT.COMPILE THEN GOTO A11
$!
$	   INQ/NOP EVERYTHING "Compile all FORTRAN sources ? "
$	   IF .NOT. EVERYTHING THEN GOTO A05
$	   ADDOV_REST="T"
$	   ADDOV_SEL="T"
$	   CMDLIN ="T"
$	   CML_ERRET="T"
$	   COMMA="T"
$	   DESCHK="T"
$	   DUPFIL="T"
$	   IFFLYR="T"
$	   IFFMER="T"
$	   IFF_START="T"
$	   IMERGE="T"
$	   INICP="T"
$	   MERCPX="T"
$	   NXT_SEL_OV="T"
$	   NXT_REST_OV="T"
$	   PARSE2 ="T"
$	   PRINCP="T"
$	   RELOFF="T"
$	   RESTMER="T"
$	   SELMER="T"
$	   SKPOVR="T"
$	   WRTCMD="T"
$	   XFER_QUAL="T"
$	   GOTO A11
$!
$ A05:	   INQ/NOP ADDOV_REST	"Compile ADDOV_REST ? 	"
$	   INQ/NOP ADDOV_SEL	"Compile ADDOV_SEL ? 	"
$	   INQ/NOP CMDLIN	"Compile CMDLIN ? 	"
$	   INQ/NOP CML_ERRET	"Compile CML_ERRET ? 	"
$	   INQ/NOP COMMA	"Compile COMMA ? 	"
$	   INQ/NOP DESCHK	"Compile DESCHK ? 	"
$	   INQ/NOP DUPFIL	"Compile DUPFIL ? 	"
$	   INQ/NOP IFFLYR	"Compile IFFLYR ? 	"
$	   INQ/NOP IFFMER	"Compile IFFMER ? 	"
$	   INQ/NOP IFF_START	"Compile IFF_START ? 	"
$	   INQ/NOP IMERGE	"Compile IMERGE ? 	"
$	   INQ/NOP INICP	"Compile INICP ? 	"
$	   INQ/NOP MERCPX	"Compile MERCPX ? 	"
$	   INQ/NOP NXT_SEL_OV	"Compile NXT_SEL_OV ? 	"
$	   INQ/NOP NXT_REST_OV	"Compile NXT_REST_OV ? 	"
$	   INQ/NOP PARSE2 	"Compile PARSE2 ? 	"
$	   INQ/NOP PRINCP	"Compile PRINCP ? 	"
$	   INQ/NOP RELOFF	"Compile RELOFF ? 	"
$	   INQ/NOP RESTMER	"Compile RESTMER ? 	"
$	   INQ/NOP SELMER	"Compile SELMER ? 	"
$	   INQ/NOP SKPOVR	"Compile SKPOVR ? 	"
$	   INQ/NOP WRTCMD	"Compile WRTCMD ? 	"
$	   INQ/NOP XFER_QUAL	"Compile XFER_QUAL ? 	"
$	   WRITE SYS$OUTPUT " "
$ A11:	   INQ/NOP MES "Generate message definitions ? "
$! 	   IF MES THEN INQ/NOP RENMES "Rename general message object to package message directory ? "
$	   INQUIRE/NOP LNKIT "Link ? "
$	   IF .NOT. LNKIT THEN GOTO NOTKB
$!
$	   LINKVER="IMERGE"
$	   INQUIRE/NOP ANSWER "Experimental version ? "
$	   IF ANSWER THEN LINKVER="IMERGEX"
$!
$	   INQUIRE/NOP ANSWER "Experimental LSLLIB ? "
$	   EXPLSL = "LSL$LIBRARY:LSLSHR/OPT"
$	   IF ANSWER THEN EXPLSL="LSL$DISK:[LIB.LSLLIB.TEST]LSLLIB/LIB"
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
$ 		IF .NOT.MES THEN GOTO NOMESS
$		WC "$	NEWMSG/NUMBER=1201/PREFIX=IMERGE__/PARAMETER=FORTRAN IMERGE.MES"
$		WC "$	@IMERGE.TEMP_COM"
$ NOMESS:   IF .NOT. CLD THEN GOTO FORTONLY
$		WC "$ 		ADC IMERGE.TMP=IMERGE.CLD"
$		WC "$ 		SET COMMAND/OBJECT=IMERGE_CLD IMERGE.TMP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV IMERGE_CLD"
$		WC "$ 		IF OK THEN DELETE IMERGE.TMP;*"
$		WC "$ 		IF OK THEN PURGE/NOLOG IMERGE_CLD.OBJ"
$		WC "$ 		ADC IMERGE.TMP2=IMERGEPAR.CLD"
$		WC "$ 		SET COMMAND/OBJECT=IMERGEPAR_CLD IMERGE.TMP2"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV IMERGEPAR_CLD"
$		WC "$ 		IF OK THEN DELETE IMERGE.TMP2;*"
$		WC "$ 		IF OK THEN PURGE/NOLOG IMERGEPAR_CLD.OBJ"
$	
$ FORTONLY:		
$	IF .NOT. COMPILE THEN GOTO LNKONLY
$	   IF .NOT. ADDOV_REST  THEN GOTO A110
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ 		ADC ADDOV_REST''KPCOM'=ADDOV_REST"
$	   	WC "$ 		FORT''FSW1' ADDOV_REST"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV ADDOV_REST"
$		WC "$ 		PURGE/NOLOG ADDOV_REST.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG ADDOV_REST.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG ADDOV_REST.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A110:	   IF .NOT. ADDOV_SEL  THEN GOTO A120
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ 		ADC ADDOV_SEL''KPCOM'=ADDOV_SEL"
$	   	WC "$ 		FORT''FSW1' ADDOV_SEL"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV ADDOV_SEL"
$		WC "$ 		PURGE/NOLOG ADDOV_SEL.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG ADDOV_SEL.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG ADDOV_SEL.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A120:	   IF .NOT. CMDLIN  THEN GOTO A130
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC CMDLIN''KPCOM'=CMDLIN"
$	   	WC "$ 		FORT''FSW1' CMDLIN"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV CMDLIN"
$		WC "$ 		PURGE/NOLOG CMDLIN.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG CMDLIN.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG CMDLIN.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A130:	   IF .NOT. DESCHK  THEN GOTO A140
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC DESCHK''KPCOM'=DESCHK"
$	   	WC "$ 		FORT''FSW1' DESCHK"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV DESCHK"
$		WC "$ 		PURGE/NOLOG DESCHK.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG DESCHK.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG DESCHK.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A140:	   IF .NOT. CML_ERRET  THEN GOTO A160
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC CML_ERRET''KPCOM'=CML_ERRET"
$	   	WC "$ 		FORT''FSW1' CML_ERRET"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV CML_ERRET"
$		WC "$ 		PURGE/NOLOG CML_ERRET.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG CML_ERRET.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG CML_ERRET.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A160:	   IF .NOT. COMMA  THEN GOTO A170
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC COMMA''KPCOM'=COMMA"
$	   	WC "$ 		FORT''FSW1' COMMA"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV COMMA"
$		WC "$ 		PURGE/NOLOG COMMA.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG COMMA.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG COMMA.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A170:	   IF .NOT. DUPFIL  THEN GOTO A180
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC DUPFIL''KPCOM'=DUPFIL"
$	   	WC "$ 		FORT''FSW1' DUPFIL"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV DUPFIL"
$		WC "$ 		PURGE/NOLOG DUPFIL.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG DUPFIL.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG DUPFIL.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A180:	   IF .NOT. IFFLYR  THEN GOTO A190
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC IFFLYR''KPCOM'=IFFLYR"
$	   	WC "$ 		FORT''FSW1' IFFLYR"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV IFFLYR"
$		WC "$ 		PURGE/NOLOG IFFLYR.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG IFFLYR.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG IFFLYR.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A190:	   IF .NOT. IFFMER  THEN GOTO A200
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC IFFMER''KPCOM'=IFFMER"
$	   	WC "$ 		FORT''FSW1' IFFMER"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV IFFMER"
$		WC "$ 		PURGE/NOLOG IFFMER.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG IFFMER.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG IFFMER.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$!
$ A200:	   IF .NOT. IFF_START THEN  GOTO A220
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC IFF_START''KPCOM'=IFF_START"
$	   	WC "$ 		FORT''FSW1' IFF_START"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV IFF_START"
$		WC "$ 		PURGE/NOLOG IFF_START.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG IFF_START.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG IFF_START.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A220:	   IF .NOT. IMERGE  THEN GOTO A230
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC IMERGE''KPCOM'=IMERGE"
$	   	WC "$ 		FORT''FSW1' IMERGE"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV IMERGE"
$		WC "$ 		PURGE/NOLOG IMERGE.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG IMERGE.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG IMERGE.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A230:	   IF .NOT. INICP  THEN GOTO A240
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC INICP''KPCOM'=INICP"
$	   	WC "$ 		FORT''FSW1' INICP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV INICP"
$		WC "$ 		PURGE/NOLOG INICP.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG INICP.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG INICP.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A240:	   IF .NOT. MERCPX  THEN GOTO A250
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC MERCPX''KPCOM'=MERCPX"
$	   	WC "$ 		FORT''FSW1' MERCPX"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV MERCPX"
$		WC "$ 		PURGE/NOLOG MERCPX.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG MERCPX.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG MERCPX.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A250:	   IF .NOT. NXT_REST_OV THEN GOTO A260
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC NXT_REST_OV''KPCOM'=NXT_REST_OV"
$	   	WC "$ 		FORT''FSW1' NXT_REST_OV"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV NXT_REST_OV"
$		WC "$ 		PURGE/NOLOG NXT_REST_OV.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG NXT_REST_OV.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG NXT_REST_OV.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A260:	   IF .NOT. NXT_SEL_OV THEN GOTO A270
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC NXT_SEL_OV''KPCOM'=NXT_SEL_OV"
$	   	WC "$ 		FORT''FSW1' NXT_SEL_OV"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV NXT_SEL_OV"
$		WC "$ 		PURGE/NOLOG NXT_SEL_OV.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG NXT_SEL_OV.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG NXT_SEL_OV.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A270:	   IF .NOT. PARSE2 THEN GOTO A280
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC PARSE2''KPCOM'=PARSE2"
$	   	WC "$ 		FORT''FSW1' PARSE2"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV PARSE2"
$		WC "$ 		PURGE/NOLOG PARSE2.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG PARSE2.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG PARSE2.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A280:	   IF .NOT. PRINCP  THEN GOTO A290
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC PRINCP''KPCOM'=PRINCP"
$	   	WC "$ 		FORT''FSW1' PRINCP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV PRINCP"
$		WC "$ 		PURGE/NOLOG PRINCP.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG PRINCP.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG PRINCP.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A290:	   IF .NOT. RELOFF  THEN GOTO A300
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC RELOFF''KPCOM'=RELOFF"
$	   	WC "$ 		FORT''FSW1' RELOFF"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV RELOFF"
$		WC "$ 		PURGE/NOLOG RELOFF.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG RELOFF.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG RELOFF.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A300:	   IF .NOT. RESTMER  THEN GOTO A310
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC RESTMER''KPCOM'=RESTMER"
$	   	WC "$ 		FORT''FSW1' RESTMER"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV RESTMER"
$		WC "$ 		PURGE/NOLOG RESTMER.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG RESTMER.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG RESTMER.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A310:	   IF .NOT. SELMER  THEN GOTO A320
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC SELMER''KPCOM'=SELMER"
$	   	WC "$ 		FORT''FSW1' SELMER"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV SELMER"
$		WC "$ 		PURGE/NOLOG SELMER.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG SELMER.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG SELMER.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A320:	   IF .NOT. SKPOVR  THEN GOTO A330
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC SKPOVR''KPCOM'=SKPOVR"
$	   	WC "$ 		FORT''FSW1' SKPOVR"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV SKPOVR"
$		WC "$ 		PURGE/NOLOG SKPOVR.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG SKPOVR.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG SKPOVR.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A330:	   IF .NOT. WRTCMD  THEN GOTO A340
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC WRTCMD''KPCOM'=WRTCMD"
$	   	WC "$ 		FORT''FSW1' WRTCMD"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV WRTCMD"
$		WC "$ 		PURGE/NOLOG WRTCMD.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG WRTCMD.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG WRTCMD.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A340:	   IF .NOT. XFER_QUAL  THEN GOTO LNKONLY
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC XFER_QUAL''KPCOM'=XFER_QUAL"
$	   	WC "$ 		FORT''FSW1' XFER_QUAL"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV XFER_QUAL"
$		WC "$ 		PURGE/NOLOG XFER_QUAL.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG XFER_QUAL.FOR"
$		IF (F$LOCATE("/LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG XFER_QUAL.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$!
$ LNKONLY:
$ 	IF .NOT. LNKIT THEN GOTO NOLNK
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$		ADC LNK = LSL$CMNIFF:MD2DAT
$		WC "$		FORT/DEBUG/NOOPT LNK"
$		WC "$		PVV LNK"
$		WC "$		DELETE	ADC.IDE;*"
$		WC "$		DELETE  LNK.FOR;*"
$	   	WC "$ 		LINK''LINKOPTS'/EXE=''LINKVER' IMERGE,IMERGE_CLD, -"
$	   	WC "		IMERGEPAR_CLD,CMDLIN,PARSE2, -"
$	   	WC "		CML_ERRET,COMMA,ADDOV_REST,ADDOV_SEL, -"
$		WC "		IFF_START,DUPFIL,IFFLYR,INICP, LNK, -"
$		WC "		MERCPX,SKPOVR,XFER_QUAL,IFFMER,NXT_REST_OV, -"
$		WC "		NXT_SEL_OV,PRINCP,WRTCMD,RELOFF,DESCHK, -"
$		WC "		RESTMER,SELMER, -"
$		WC "		IMERGE.PROMSG_OBJ, -"
$	   	WC "		LSL$LIBRARY:IFFSHR/OPT,-"
$		WC "		''EXPLSL'"
$!
$ NOLNK:
$		WC "$ 		IMERGEEX:"
$		WC "$ 		DEASS/GROUP LSL$IMERGE_BUILDING"
$		WC "$ 		SET NOVER"
$!
$ FILCLO:
$	SET NOVERIFY
$	ON ERROR THEN GOTO IMERGEEX
$	CLOSE COMFIL
$	OK=$STATUS
$	IF OK THEN INQ/NOP ANSWER_BAT "Submit for batch ? "
$	IF .NOT. ANSWER_BAT THEN GOTO INT
$	DEASS/GROUP LSL$IMERGE_BUILDING
$	BAT IMERGEBAT.COM
$	GOTO IMERGEX2
$ INT:	
$	IF OK THEN INQ/NOP ANSWER "Interactive ? "
$	IF .NOT.ANSWER THEN GOTO IMERGEEX
$	DEASS/GROUP LSL$IMERGE_BUILDING
$	@IMERGEBAT.COM
$	GOTO IMERGEX2
$ IMERGEEX:
$	DEASS/GROUP LSL$IMERGE_BUILDING
$ IMERGEX2:
$	IF VER THEN SET VERIFY
