$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-04-06 15:00:58.000000000 +0100
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
$!MOD	Directory logicals changed for CMS		ST  26-Jul-1993
$!MOD   SIGCHS now taken from LSLLIB, not local copy	TJH 16-Jan-1989
$!MOD   New shareable IFFLIB,LSLLIB, SIGCHS in LSLLIB 	MWSR 16-Nov-1987
$!MOD	Newmessage general message option removed	TJH 16-Jun-1987
$!MOD	Newmessage F(ortran) option added		ATT 14-Jan-1987
$!MOD	Option to link with test version of LSLLIB	TJH 03-Nov-1986
$!MOD	Adapted for IINFO				LAJ 26-Jun-1986
$!	Created					 	TJH 29-Jan-1986
$!
$! Command file for building IINFO
$!
$	ON ERROR THEN GOTO IINFOEX
$	ON CONTROL_Y THEN EXIT
$!
$	DISK:='F$LOGICAL("SYS$DISK")'
$ 	GOTO A0
$	IF "''F$LOGICAL("LSL$IINFO_BUILDING")'" .NES. "IN_PROGRESS" -
	   THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$A0:	ON CONTROL_Y THEN GOTO IINFOEX
$	DEFINE/GROUP LSL$IINFO_BUILDING "IN_PROGRESS"
$	ASSIGN HERE: LSL$CMNIINFO
$!
$! check for AXP version
$!
$	ARCH_NAME=F$GETSYI("ARCH_NAME")
$	IF ARCH_NAME.EQS."Alpha" 
$	THEN 
$	   TVS="_TV"
$	   AXPS="_AXP"
$	   ADC="@here:adc"
$	   PVV="@nl:"
$	   FSW1="/EXTEND/TIE/FLOAT=D"
$	   LINKOPTS="/NONATIVE_ONLY"
$	ELSE
$	   TVS=""
$	   AXPS=""
$	   FSW1="/EXTEND"
$	   LINKOPTS=""
$	ENDIF
$!
$	OPEN/WRITE COMFIL IINFOBAT.COM
$	ON CONTROL_Y THEN GOTO FILCLO
$ 	ON ERROR THEN GOTO FILCLO
$	WC="WRITE COMFIL"
$!
$	WC 	"$ 	SET NOVERIFY"
$	WC	"$	ON CONTROL_Y THEN GOTO IINFOEX"
$	WC	"$	IF ""'","'F$LOGICAL(""LSL$IINFO_BUILDING"")'"" -"
$	WC	"		 .NES. ""IN_PROGRESS"" THEN GOTO A0"
$	WC	"$	WRITE SYS$OUTPUT ""Someone else is building"""
$	WC	"$	EXIT"
$	WC	"$!"
$	WC	"$A0:	DEFINE/GROUP LSL$IINFO_BUILDING ""IN_PROGRESS"""
$	WC	"$	ASSIGN LSL$SOURCE_ROOT:[IMP.IINFO.AXP] LSL$CMNIINFO"
$	WC	"$	SD:=$LSL$SYS:SD"
$	WC	"$	SET NOON"
$!
$	MLDBG=""
$	KPCOM=""
$	INQUIRE/NOP COMPILE "Compile ? "
$	IF .NOT.COMPILE THEN GOTO A04
$	INQUIRE/NOP IINFO_DBG "With Debug ? "
$	IF .NOT. IINFO_DBG THEN GOTO A04
$	   FSW1=FSW1+"/DEBUG"
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
$	   FDAT="T"
$	   MOVE="T"
$	   SEARCH="T"
$	   TOTAL="T"
$	   OUT_MD1="T"
$	   OUT_MD2="T"
$	   SCAN_LAYER="T"
$	   SCAN_OUT="T"
$	   INFO_OUT="T"
$	   IINFO="T"
$	   GOTO A11
$!
$ A05:
$	   INQ/NOP FDAT		"Compile FDAT ? 	"
$	   INQ/NOP MOVE		"Compile MOVE ? 	"
$	   INQ/NOP SEARCH	"Compile SEARCH ? 	"
$	   INQ/NOP TOTAL	"Compile TOTAL ? 	"
$	   INQ/NOP OUT_MD1	"Compile OUT_MD1 ? 	"
$	   INQ/NOP OUT_MD2	"Compile OUT_MD2 ? 	"
$	   INQ/NOP SCAN_LAYER	"Compile SCAN_LAYER ? 	"
$	   INQ/NOP SCAN_OUT	"Compile SCAN_OUT ? 	"
$	   INQ/NOP INFO_OUT	"Compile INFO_OUT? 	"
$	   INQ/NOP IINFO	"Compile IINFO ? 	"
$	   WRITE SYS$OUTPUT " "
$ A11:	   INQ/NOP DOMAC "Assemble macro ? "
$ 	   INQ/NOP MES "Generate message definitions ? "
$	   INQUIRE/NOP LNKIT "Link ? "
$	   IF .NOT. LNKIT THEN GOTO NOTKB
$!
$	   LINKVER="IINFO"+AXPS
$	   INQUIRE/NOP ANSWER "Experimental version ? "
$	   IF ANSWER THEN LINKVER="IINFOX"+AXPS
$!
$	   EXPLSL="LSL$LIBRARY:LSLSHR''TVS'/OPT"
$!
$	   LINKOPTS=LINKOPTS+"/MAP/FULL"
$	   INQUIRE/NOP ANSWER "Link with debug ? "
$	   IF ANSWER THEN LINKOPTS=LINKOPTS+"/DEBUG"
$!
$	   INQUIRE/NOP ANSWER "Cross reference map ? "
$	   IF ANSWER THEN LINKOPTS=LINKOPTS+"/CROSS"
$	   
$ NOTKB:
$!
$		WC "$ 		SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ 		SET VERIFY"
$		IF DOMAC THEN -
		WC "$		MACRO IFFMAC
$		WC "$ 		SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ 		SET VERIFY"
$ 		IF .NOT. MES THEN GOTO NOMESSING
$	   	WC "$ NEWMSG IINFO/NUMBER=1208"
$		WC "$ @IINFO.TEMP_COM"
$ NOMESSING:
$	   IF .NOT. CLD THEN GOTO FORTONLY
$		WC "$ 		ADC IINFO.TMP=IINFO.CLD"
$		WC "$ 		SET COMMAND/OBJECT=IINFO_CLD IINFO.TMP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV IINFO_CLD"
$		WC "$ 		IF OK THEN DELETE IINFO.TMP;*"
$		WC "$ 		IF OK THEN PURGE/NOLOG IINFO_CLD.OBJ"
$	
$ FORTONLY:		
$	IF .NOT. COMPILE THEN GOTO LNKONLY
$!
$ A110:	   IF .NOT. FDAT THEN GOTO A120
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC FDAT''KPCOM'=FDAT"
$	   	WC "$ 		FORT''FSW1' FDAT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV FDAT"
$		WC "$ 		PURGE/NOLOG FDAT.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG FDAT.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG FDAT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A120:	   IF .NOT. MOVE  THEN GOTO A130
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC MOVE''KPCOM'=MOVE"
$	   	WC "$ 		FORT''FSW1' MOVE"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV MOVE"
$		WC "$ 		PURGE/NOLOG MOVE.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG MOVE.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG MOVE.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A130:	   IF .NOT. SEARCH  THEN GOTO A150
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC SEARCH''KPCOM'=SEARCH"
$	   	WC "$ 		FORT''FSW1' SEARCH"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV SEARCH"
$		WC "$ 		PURGE/NOLOG SEARCH.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG SEARCH.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG SEARCH.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A150:	   IF .NOT. TOTAL  THEN GOTO A170
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC TOTAL''KPCOM'=TOTAL"
$	   	WC "$ 		FORT''FSW1' TOTAL"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV TOTAL"
$		WC "$ 		PURGE/NOLOG TOTAL.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG TOTAL.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG TOTAL.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A170:	   IF .NOT. OUT_MD1  THEN GOTO A180
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC OUT_MD1''KPCOM'=OUT_MD1"
$	   	WC "$ 		FORT''FSW1' OUT_MD1"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV OUT_MD1"
$		WC "$ 		PURGE/NOLOG OUT_MD1.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG OUT_MD1.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG OUT_MD1.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A180:	   IF .NOT. OUT_MD2  THEN GOTO A190
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC OUT_MD2''KPCOM'=OUT_MD2"
$	   	WC "$ 		FORT''FSW1' OUT_MD2"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV OUT_MD2"
$		WC "$ 		PURGE/NOLOG OUT_MD2.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG OUT_MD2.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG OUT_MD2.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A190:	   IF .NOT. SCAN_LAYER THEN GOTO A200
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC SCAN_LAYER''KPCOM'=SCAN_LAYER"
$	   	WC "$ 		FORT''FSW1' SCAN_LAYER"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV SCAN_LAYER"
$		WC "$ 		PURGE/NOLOG SCAN_LAYER.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG SCAN_LAYER.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG SCAN_LAYER.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A200:	   IF .NOT. IINFO  THEN GOTO A210
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC IINFO''KPCOM'=IINFO"
$	   	WC "$ 		FORT''FSW1' IINFO"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV IINFO"
$		WC "$ 		PURGE/NOLOG IINFO.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG IINFO.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG IINFO.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A210:	   IF .NOT. SCAN_OUT  THEN GOTO A220
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC SCAN_OUT''KPCOM'=SCAN_OUT"
$	   	WC "$ 		FORT''FSW1' SCAN_OUT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV SCAN_OUT"
$		WC "$ 		PURGE/NOLOG SCAN_OUT.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG SCAN_OUT.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG SCAN_OUT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A220:	   IF .NOT. INFO_OUT  THEN GOTO LNKONLY
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC INFO_OUT''KPCOM'=INFO_OUT"
$	   	WC "$ 		FORT''FSW1' INFO_OUT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV INFO_OUT"
$		WC "$ 		PURGE/NOLOG INFO_OUT.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG INFO_OUT.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG INFO_OUT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$!
$ LNKONLY:
$ 	IF .NOT. LNKIT THEN GOTO NOLNK
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$		ADC LNK=MD2DAT
$		WC "$		FORT/DEBUG/NOOPT LNK"
$		WC "$		PVV LNK"
$		WC "$		DELETE	ADC.IDE;*"
$		WC "$		DELETE  LNK.FOR;*"
$		WC "$		PURGE LNK.OBJ"
$!
$! don't move these DEFINE/USERs away from LINK
$		WC "$		DEFINE/USER LSL$IFFSHR_TV LSL$LIBRARY:IFFSHR_DUMMY_AXP"
$		WC "$		DEFINE/USER LSL$LSLSHR_TV LSL$LIBRARY:LSLSHR_DUMMY_AXP"
$	   	WC "$ 		LINK''LINKOPTS'/EXE=''LINKVER' IINFO, -"
$	   	WC "		IINFO_CLD,FDAT, -"
$	   	WC "		TOTAL,SCAN_LAYER, -"
$		WC "		OUT_MD1,SCAN_OUT,INFO_OUT, -"
$		WC "		OUT_MD2,SEARCH,MOVE, -"
$		WC "		IFFMAC, LNK, -"
$		WC "		IINFO.PROMSG_OBJ, -"
$	   	WC "		LSL$LIBRARY:IFFSHR''TVS'/OPT,''EXPLSL'"
$!
$ NOLNK:
$		WC "$ 		IINFOEX:"
$		WC "$ 		DEASS/GROUP LSL$IINFO_BUILDING"
$		WC "$ 		SET NOVER"
$!
$ FILCLO:
$	SET NOVERIFY
$	ON ERROR THEN GOTO IINFOEX
$	CLOSE COMFIL
$	OK=$STATUS
$	IF OK THEN INQ/NOP ANSWER_BAT "Submit for batch ? "
$	IF .NOT. ANSWER_BAT THEN GOTO INT
$	DEASS/GROUP LSL$IINFO_BUILDING
$	BAT IINFOBAT.COM
$	GOTO IINFOX2
$ INT:	
$	IF OK THEN INQ/NOP ANSWER "Interactive ? "
$	IF .NOT.ANSWER THEN GOTO IINFOEX
$	DEASS/GROUP LSL$IINFO_BUILDING
$	@IINFOBAT.COM
$	PURGE IINFOBAT.COM
$	GOTO IINFOX2
$ IINFOEX:
$	DEASS/GROUP LSL$IINFO_BUILDING
$ IINFOX2:
$	PURGE IINFO.MAP
$	IF VER THEN SET VERIFY
