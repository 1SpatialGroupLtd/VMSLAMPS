$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-01-14 18:37:18.000000000 +0000
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
$! Command file for building BC2IFF
$!
$	ON ERROR THEN GOTO BC2IEX
$	ON CONTROL_Y THEN EXIT
$!
$	DISK:='F$LOGICAL("SYS$DISK")'
$	IF "''F$LOGICAL("LSL$BC2I_BUILDING")'" .NES. "IN_PROGRESS" -
	   THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$A0:	ON CONTROL_Y THEN GOTO BC2IEX
$	DEFINE/GROUP LSL$BC2I_BUILDING "IN_PROGRESS"
$	OPEN/WRITE COMFIL BC2IFFBAT.COM
$	ON CONTROL_Y THEN GOTO FILCLO
$ 	ON ERROR THEN GOTO FILCLO
$	WC="WRITE COMFIL"
$!
$	WC 	"$ 	SET NOVERIFY"
$	WC	"$	ON CONTROL_Y THEN GOTO BC2IEX"
$	WC	"$	IF ""'","'F$LOGICAL(""LSL$BC2I_BUILDING"")'"" -"
$	WC	"		 .NES. ""IN_PROGRESS"" THEN GOTO A0"
$	WC	"$	WRITE SYS$OUTPUT ""Someone else is building"""
$	WC	"$	EXIT"
$	WC	"$!"
$	WC	"$A0:	DEFINE/GROUP LSL$BC2I_BUILDING ""IN_PROGRESS"""
$	WC	"$	SET NOON"
$!
$	MLDBG=""
$	FSW1=""
$	KPCOM=""
$	INQUIRE/NOP COMPILE "Compile ? "
$	IF .NOT.COMPILE THEN GOTO A04
$	INQUIRE/NOP BC2I_DBG "With Debug ? "
$	IF .NOT. BC2I_DBG THEN GOTO A04
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
$	   BC2IFF	= "T"
$	   UPDATE_RANGE = "T"
$	   BC2CONV	= "T"
$	   GOTO A11
$!
$ A05:	   INQ/NOP BC2IFF	"Compile BC2IFF?	"
$	   INQ/NOP UPDATE_RANGE	"Compile UPDATE_RANGE? 	"
$	   INQ/NOP BC2CONV	"Compile BC2CONV? 	"
$	   WRITE SYS$OUTPUT " "
$ A11:	   INQ/NOP MES "Generate message definitions ? "
$	   INQUIRE/NOP LNKIT "Link ? "
$	   IF .NOT. LNKIT THEN GOTO NOTKB
$!
$	   LINKVER="BC2IFF"
$	   INQUIRE/NOP ANSWER "Experimental version ? "
$	   IF ANSWER THEN LINKVER="BC2IFFX"
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
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$ 		IF .NOT. MES THEN GOTO NOMESS
$		WC "$	NEWMSG/NUMBER=1613/PREFIX=BC2I__/PARAMETER=FORTRAN/RUNOFF/HL=2 BC2IFF.MES"
$		WC "$	PURGE BC2IFFMSG.RNO"
$		WC "$	@BC2IFF.TEMP_COM"
$!
$ NOMESS:	IF .NOT. CLD THEN GOTO FORTONLY
$		WC "$ 		ADC BC2IFF.TMP=BC2IFF_CLD.CLD"
$		WC "$ 		SET COMMAND/OBJECT=BC2IFF_CLD BC2IFF.TMP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV BC2IFF_CLD"
$		WC "$ 		IF OK THEN DELETE BC2IFF.TMP;*"
$		WC "$ 		IF OK THEN PURGE/NOLOG BC2IFF_CLD.OBJ"
$	
$ FORTONLY:		
$	IF .NOT. COMPILE THEN GOTO LNKONLY
$	   IF .NOT. BC2IFF THEN GOTO A100
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ 		ADC BC2IFF''KPCOM'=BC2IFF"
$	   	WC "$ 		FORT''FSW1' BC2IFF"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV BC2IFF"
$		WC "$ 		PURGE/NOLOG BC2IFF.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG BC2IFF.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG BC2IFF.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A100:	   IF .NOT. UPDATE_RANGE THEN GOTO A110
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ 		ADC UPDATE_RANGE''KPCOM'=UPDATE_RANGE"
$	   	WC "$ 		FORT''FSW1' UPDATE_RANGE"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV UPDATE_RANGE"
$		WC "$ 		PURGE/NOLOG UPDATE_RANGE.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG UPDATE_RANGE.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG UPDATE_RANGE.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A110:	   IF .NOT. BC2CONV THEN GOTO A120
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC BC2CONV''KPCOM'=BC2CONV"
$	   	WC "$ 		FORT''FSW1' BC2CONV"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV BC2CONV"
$		WC "$ 		PURGE/NOLOG BC2CONV.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG BC2CONV.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG BC2CONV.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A120:
$ LNKONLY:
$ 	IF .NOT. LNKIT THEN GOTO NOLNK
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$	   	WC "$ 		LINK''LINKOPTS'/EXE=''LINKVER' BC2IFF,-"
$	   	WC "		BC2IFF_CLD,BC2CONV,UPDATE_RANGE,-"
$		WC "		BC2IFF.PROMSG_OBJ,-"
$	   	WC "		LSL$LIBRARY:IFFSHR/OPT,LSLSHR/OPT"
$!
$ NOLNK:
$		WC "$ 		BC2IEX:"
$		WC "$ 		DEASS/GROUP LSL$BC2I_BUILDING"
$		WC "$ 		SET NOVER"
$!
$ FILCLO:
$	SET NOVERIFY
$	ON ERROR THEN GOTO BC2IEX
$	CLOSE COMFIL
$	OK=$STATUS
$	IF OK THEN INQ/NOP ANSWER_BAT "Submit for batch ? "
$	IF .NOT. ANSWER_BAT THEN GOTO INT
$	DEASS/GROUP LSL$BC2I_BUILDING
$	BAT BC2IFFBAT.COM
$	GOTO BC2IX2
$ INT:	
$	IF OK THEN INQ/NOP ANSWER "Interactive ? "
$	IF .NOT.ANSWER THEN GOTO BC2IEX
$	DEASS/GROUP LSL$BC2I_BUILDING
$	@BC2IFFBAT.COM
$	GOTO BC2IX2
$ BC2IEX:
$	DEASS/GROUP LSL$BC2I_BUILDING
$ BC2IX2:
$	IF VER THEN SET VERIFY
$	PUR BC2IFFBAT.COM
$	PUR *.FOR
$	PUR *.OBJ
$!
