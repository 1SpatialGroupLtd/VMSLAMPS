$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-04-06 13:41:54.000000000 +0100
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
$!	Created					 	DRC 14-MAR-88
$!
$! Command file for building DFAD2I
$!
$	ON ERROR THEN GOTO DFAD2IEX
$	ON CONTROL_Y THEN EXIT
$!
$	DISK:='F$LOGICAL("SYS$DISK")'
$	IF "''F$LOGICAL("LSL$DFAD2I_BUILDING")'" .NES. "IN_PROGRESS" -
	   THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$!
$ A0:	ON CONTROL_Y THEN GOTO DFAD2IEX
$	DEFINE/GROUP LSL$DFAD2I_BUILDING "IN_PROGRESS"
$	OPEN/WRITE COMFIL DFAD2IBAT.COM
$	ON CONTROL_Y THEN GOTO FILCLO
$ 	ON ERROR THEN GOTO FILCLO
$	WC="WRITE COMFIL"
$!
$	WC 	"$ 	SET NOVERIFY"
$	WC	"$	ON CONTROL_Y THEN GOTO DFAD2IEX"
$	WC	"$	IF ""'","'F$LOGICAL(""LSL$DFAD2I_BUILDING"")'"" -"
$	WC	"		 .NES. ""IN_PROGRESS"" THEN GOTO A0"
$	WC	"$	WRITE SYS$OUTPUT ""Someone else is building"""
$	WC	"$	EXIT"
$	WC	"$!"
$	WC	"$ A0:	DEFINE/GROUP LSL$DFAD2I_BUILDING ""IN_PROGRESS"""
$	WC	"$      ASSIGN DUA0:[MCE.DTM] DTMPAR
$	WC	"$	SD:=$LSL$SYS:SD"
$	WC	"$	SET NOON"
$!
$	MLDBG=""
$	FSW1=""
$	KPCOM=""
$	INQUIRE/NOP COMPILE "Compile ? "
$	IF .NOT.COMPILE THEN GOTO A04
$	INQUIRE/NOP DFAD2I_DBG "With Debug ? "
$	IF .NOT. DFAD2I_DBG THEN GOTO A04
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
$	   GETCOMLIN="T"
$	   DFAD2I="T"
$	   RDMAG="T"
$	   HEADER="T"
$	   FEATUR="T"
$	   RDCH3="T"
$	   OUTIF1="T"
$	   OUTIF2="T"
$	   INFO="T"
$	   RDLALO="T"
$	   GOTO A11
$!
$ A05:
$	   INQ/NOP DFAD2I "Compile DFAD2I? "
$	   INQ/NOP GETCOMLIN "Compile GETCOMLIN? "
$	   INQ/NOP RDMAG "Compile RDMAG,RD2MKS? "
$	   INQ/NOP HEADER "Compile HEADER? "
$	   INQ/NOP FEATUR "Compile FEATUR,FTRHD1,FTRHD2,POINT? "
$	   INQ/NOP RDCH3 "Compile RDDSI,RDACC,RDPOLY,SPACE? "
$	   INQ/NOP OUTIF1 "Compile STRTIF,ENDIFF,EOPTR? "
$	   INQ/NOP OUTIF2 "Compile OUTFTR,OUTHDR,OUTAC? "
$	   INQ/NOP INFO "Compile PRFHDR,PRMHDR? "
$	   INQ/NOP RDLALO "Compile RDLALO? "
$!
$	   GOTO A11
$!
$ A11:	   INQ/NOP MES "Generate message definitions? "
$!
$	   INQUIRE/NOP LNKIT "Link? "
$	   IF .NOT. LNKIT THEN GOTO NOTKB
$!
$	   LINKVER="DFAD2I"
$	   INQUIRE/NOP ANSWER "Experimental version ? "
$	   IF ANSWER THEN LINKVER="DFAD2IX"
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
$		WC "$	NEWMSG DFAD2I.MES/NUM=1693/NAME=DFAD2I/PRE=DFAD2I__/PAR=FOR/RUNOFF"
$		WC "$	@DFAD2I.TEMP_COM"
$ NOMESSING:
$	   IF .NOT. CLD THEN GOTO FORTONLY
$		WC "$ 		ADC DFAD2I.TMP=DFAD2I.CLD"
$		WC "$ 		SET COMMAND/OBJECT=DFAD2I_CLD DFAD2I.TMP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV DFAD2I_CLD"
$		WC "$ 		IF OK THEN DELETE DFAD2I.TMP;*"
$		WC "$ 		IF OK THEN PURGE/NOLOG DFAD2I_CLD.OBJ"
$	
$ FORTONLY:		
$	IF .NOT. COMPILE THEN GOTO LNKONLY
$	   IF .NOT. DFAD2I THEN GOTO A110
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ 		ADC DFAD2I''KPCOM'=DFAD2I"
$	   	WC "$ 		FORT''FSW1' DFAD2I"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV DFAD2I"
$		WC "$ 		PURGE/NOLOG DFAD2I.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG DFAD2I.FOR;*"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG DFAD2I.FOR"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A110:	   IF .NOT. GETCOMLIN THEN GOTO A115
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC GETCOMLIN''KPCOM'=GETCOMLIN"
$	   	WC "$ 		FORT''FSW1' GETCOMLIN"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV GETCOMLIN"
$		WC "$ 		PURGE/NOLOG GETCOMLIN.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG GETCOMLIN.FOR;*"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG GETCOMLIN.FOR"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A115:	   IF .NOT. RDMAG THEN GOTO A120
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC RDMAG''KPCOM'=RDMAG,RD2MKS"
$	   	WC "$ 		FORT''FSW1' RDMAG"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV RDMAG"
$		WC "$ 		PURGE/NOLOG RDMAG.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG RDMAG.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG RDMAG.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG RDMAG.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A120:	   IF .NOT. HEADER THEN GOTO A130
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC HEADER''KPCOM'=HEADER"
$	   	WC "$ 		FORT''FSW1' HEADER"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV HEADER"
$		WC "$ 		PURGE/NOLOG HEADER.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG HEADER.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG HEADER.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG HEADER.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A130:	   IF .NOT. FEATUR THEN GOTO A140
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC FEATUR''KPCOM'=FEATUR,FTRHD1,FTRHD2,POINT"
$	   	WC "$ 		FORT''FSW1' FEATUR"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV FEATUR"
$		WC "$ 		PURGE/NOLOG FEATUR.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG FEATUR.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG FEATUR.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG FEATUR.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A140:	   IF .NOT. RDCH3 THEN GOTO A150
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC RDCH3''KPCOM'=RDDSI,RDACC,RDPOLY,SPACE"
$	   	WC "$ 		FORT''FSW1' RDCH3"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV RDCH3"
$		WC "$ 		PURGE/NOLOG RDCH3.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG RDCH3.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG RDCH3.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG RDCH3.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A150:	   IF .NOT. OUTIF1 THEN GOTO A160
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC OUTIF1''KPCOM'=STRTIF,ENDIFF,EOPTR"
$	   	WC "$ 		FORT''FSW1' OUTIF1"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV OUTIF1"
$		WC "$ 		PURGE/NOLOG OUTIF1.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG OUTIF1.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG OUTIF1.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG OUTIF1.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A160:	   IF .NOT. OUTIF2 THEN GOTO A170
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC OUTIF2''KPCOM'=OUTFTR,OUTHDR,OUTAC"
$	   	WC "$ 		FORT''FSW1' OUTIF2"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV OUTIF2"
$		WC "$ 		PURGE/NOLOG OUTIF2.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG OUTIF2.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG OUTIF2.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG OUTIF2.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A170:	   IF .NOT. INFO THEN GOTO A175
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC INFO''KPCOM'=PRFHDR,PRMHDR"
$	   	WC "$ 		FORT''FSW1' INFO"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV INFO"
$		WC "$ 		PURGE/NOLOG INFO.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG INFO.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG INFO.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG INFO.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A175:	   IF .NOT. RDLALO THEN GOTO A180
$ 		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		WC "$ SET VERIFY"
$		WC "$ 		ADC RDLALO''KPCOM'=RDLALO"
$	   	WC "$ 		FORT''FSW1' RDLALO"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV RDLALO"
$		WC "$ 		PURGE/NOLOG RDLALO.OBJ"
$		IF FSW1.NES.""  THEN -
			WC "$ 		PURGE/NOLOG RDLALO.FOR"
$		IF FSW1.EQS."" THEN -
			WC "$ 		DELETE/NOLOG RDLALO.FOR;*"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG RDLALO.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$!
$ A180:	   
$!
$ LNKONLY:
$ 	IF .NOT. LNKIT THEN GOTO NOLNK
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$	   	WC "$	LINK''LINKOPTS'/EXE=''LINKVER' -"
$		WC "	DFAD2I,DFAD2I_CLD,-"
$		WC "	GETCOMLIN,RDMAG,HEADER,FEATUR,-"
$		WC "	RDCH3,OUTIF1,OUTIF2,INFO,RDLALO,-"
$	        WC "    DFAD2I.PROMSG_OBJ,-"
$ 		WC "    LSL$LIBRARY:LSLDLMSLIB/LIB,-"
$		WC "    LSL$LIBRARY:IFFSHR.OPT/OPT,-"
$		WC "    LSL$LIBRARY:LSLSHR.OPT/OPT"
$!
$ NOLNK:
$		WC "$ 		DFAD2IEX:"
$		WC "$ 		DEASS/GROUP LSL$DFAD2I_BUILDING"
$		WC "$ 		SET NOVER"
$!
$ FILCLO:
$	SET NOVERIFY
$	ON ERROR THEN GOTO DFAD2IEX
$	CLOSE COMFIL
$	OK=$STATUS
$	IF OK THEN INQ/NOP ANSWER_BAT "Submit for batch ? "
$	IF .NOT. ANSWER_BAT THEN GOTO INT
$	DEASS/GROUP LSL$DFAD2I_BUILDING
$	BAT DFAD2IBAT.COM
$	GOTO DFAD2IX2
$ INT:	
$	IF OK THEN INQ/NOP ANSWER "Interactive ? "
$	IF .NOT.ANSWER THEN GOTO DFAD2IEX
$	DEASS/GROUP LSL$DFAD2I_BUILDING
$	@DFAD2IBAT.COM
$	GOTO DFAD2IX2
$ DFAD2IEX:
$	DEASS/GROUP LSL$DFAD2I_BUILDING
$ DFAD2IX2:
$	IF VER THEN SET VERIFY

