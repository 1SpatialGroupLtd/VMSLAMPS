$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-04-10 17:13:56.000000000 +0100
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
$!	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
$!
$!	Created						RJH 09-Oct-1986
$!MOD	Newmessage F(ortran) option added		ATT 14-Jan-1987
$!MOD	BRIDGE and ERR$ROUT routines added, together with
$!	conditional compilation for debug		TJH 23-Aug-1989
$!
$!	IMP IFILTER Program - Command file for building it
$!
$	ON ERROR THEN GOTO IFILTEREX
$	ON CONTROL_Y THEN EXIT
$!
$	DISK:='F$LOGICAL("SYS$DISK")'
$	IF "''F$LOGICAL("LSL$IFILTER_BUILDING")'" .NES. "IN_PROGRESS" -
	   THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building IFILTER"
$	EXIT
$A0:	ON CONTROL_Y THEN GOTO IFILTEREX
$	DEFINE/GROUP LSL$IFILTER_BUILDING "IN_PROGRESS"
$	OPEN/WRITE COMFIL IFILTERBAT.COM
$	ON CONTROL_Y THEN GOTO FILCLO
$ 	ON ERROR THEN GOTO FILCLO
$	WC="WRITE COMFIL"
$!
$	WC 	"$ 	SET NOVERIFY"
$	WC	"$	ON CONTROL_Y THEN GOTO IFILTEREX"
$	WC	"$	IF ""'","'F$LOGICAL(""LSL$IFILTER_BUILDING"")'"" -"
$	WC	"		 .NES. ""IN_PROGRESS"" THEN GOTO A0"
$	WC	"$	WRITE SYS$OUTPUT ""Someone else is building IFILTER"""
$	WC	"$	EXIT"
$	WC	"$!"
$	WC	"$A0:	DEFINE/GROUP LSL$IFILTER_BUILDING ""IN_PROGRESS"""
$	WC	"$	INTER =F$MODE() .EQS. ""INTERACTIVE"""
$	WC	"$	ASSIGN HERE: LSL$CMNIFILT"
$	WC	"$	SD:=$LSL$SYS:SD"
$	WC	"$	SET NOON"
$!
$	RENMES=""
$	MLDBG=""
$	FSW1=""
$	KPCOM=""
$	INQUIRE/NOP COMPILE "Compile ? "
$	IF .NOT.COMPILE THEN GOTO A04
$	INQUIRE/NOP IFILT_DBG "With Debug ? "
$	IF .NOT. IFILT_DBG THEN GOTO A04
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
$	   IFILT="T"
$	   OBEY="T"
$	   IFF="T"
$	   INT="T"
$	   FIL="T"
$	   EXCEPT="T"
$	   GOTO A11
$!
$ A05:	   INQ/NOP IFILT	"Main program ?		"
$	   INQ/NOP OBEY		"Get command ?		"
$	   INQ/NOP IFF		"Process IFF file ?	"
$	   INQ/NOP INT		"Interpolation ?	"
$	   INQ/NOP FIL		"Filtering ?		"
$	   INQ/NOP EXCEPT	"Exception handler ?	"
$	   WRITE SYS$OUTPUT " "
$ A11:	   INQ/NOP MES "Generate message definitions ? "
$	   INQUIRE/NOP LNKIT "Link ? "
$	   IF .NOT. LNKIT THEN GOTO NOTKB
$!
$	   LINKVER="IFILTER"
$	   INQUIRE/NOP ANSWER "Experimental version ? "
$	   IF ANSWER THEN LINKVER="IFILTERX"
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
$ 	IF .NOT. MES THEN GOTO NOMES
$  	        WC "$ NEWMSG/NUMBER=1202 IFILT.MES"
$  		WC "$ @IFILT.TEMP_COM "
$
$NOMES:	IF .NOT. CLD THEN GOTO FORTONLY
$		WC "$ 		ADC IFILTER.TMP=IFILTER.CLD"
$		WC "$ 		SET COMMAND/OBJECT=IFILTER_CLD IFILTER.TMP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV IFILTER_CLD"
$		WC "$ 		IF OK THEN DELETE IFILTER.TMP;*"
$		WC "$ 		IF OK THEN PURGE/NOLOG IFILTER_CLD.OBJ"
$	
$ FORTONLY:		
$	IF .NOT. COMPILE THEN GOTO LNKONLY
$	   IF .NOT. IFILT THEN GOTO A110
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC IFILTER''KPCOM'=IFILTER"
$	   	WC "$ 		FORT''FSW1' IFILTER"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV IFILTER"
$		WC "$ 		PURGE/NOLOG IFILTER.OBJ"
$		IF FSW1.EQS."" THEN GOTO A102
$ 		WC "$ 		PURGE/NOLOG IFILTER.FOR"
$		GOTO A104
$ A102:		WC "$ 		DELETE/NOLOG IFILTER.FOR;*"
$ A104:		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN GOTO A106
$ 		WC "$ 		IF .NOT. INTER THEN DELETE/NOLOG IFILTER.LIS;*"
$		GOTO A108
$ A106:		WC "$ 		PURGE/NOLOG IFILTER.LIS"
$ A108:		WC "$ 		DELETE ADC.IDE;*"
$!
$ A110:	   IF .NOT. OBEY THEN GOTO A120
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC GET_COMMAND''KPCOM'=GET_COMMAND"
$	   	WC "$ 		FORT''FSW1' GET_COMMAND"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV GET_COMMAND"
$		WC "$ 		PURGE/NOLOG GET_COMMAND.OBJ"
$		IF FSW1.EQS."" THEN GOTO A112
$ 		WC "$ 		PURGE/NOLOG GET_COMMAND.FOR"
$		GOTO A114
$ A112:		WC "$ 		DELETE/NOLOG GET_COMMAND.FOR;*"
$ A114:		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN GOTO A116
$ 		WC "$ 		IF .NOT. INTER THEN DELETE/NOLOG GET_COMMAND.LIS;*"
$		GOTO A118
$ A116:		WC "$ 		PURGE/NOLOG GET_COMMAND.LIS"
$ A118:		WC "$ 		DELETE ADC.IDE;*"
$!
$ A120:	   IF .NOT. IFF THEN GOTO A130
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC PROCESS''KPCOM'=PROCESS,PROCESS_LINE"
$		WC "$ 		ADC PROCESS''KPCOM'/AP=TRANSFER_PTS,FLUSH_LINE"
$		WC "$ 		ADC PROCESS''KPCOM'/AP=ST_OUT,SET_UP"
$		WC "$ 		ADC PROCESS''KPCOM'/AP=OPEN_IFF,CLOSE_IFF"
$		WC "$ 		ADC PROCESS''KPCOM'/AP=ADDNOD"
$	   	WC "$ 		FORT''FSW1' PROCESS"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV PROCESS"
$		WC "$ 		PURGE/NOLOG PROCESS.OBJ"
$		IF FSW1.EQS."" THEN GOTO A122
$ 		WC "$ 		PURGE/NOLOG PROCESS.FOR"
$		GOTO A124
$ A122:		WC "$ 		DELETE/NOLOG PROCESS.FOR;*"
$ A124:		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN GOTO A126
$ 		WC "$ 		IF .NOT. INTER THEN DELETE/NOLOG PROCESS.LIS;*"
$		GOTO A128
$ A126:		WC "$ 		PURGE/NOLOG PROCESS.LIS"
$ A128:		WC "$ 		DELETE ADC.IDE;*"
$!
$ A130:	   IF .NOT. INT THEN GOTO A140
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC SMOOTH_LINE''KPCOM'=SMOOTH_LINE,ADDPTS"
$	   	WC "$ 		FORT''FSW1' SMOOTH_LINE"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV SMOOTH_LINE"
$		WC "$ 		PURGE/NOLOG SMOOTH_LINE.OBJ"
$		IF FSW1.EQS."" THEN GOTO A132
$ 		WC "$ 		PURGE/NOLOG SMOOTH_LINE.FOR"
$		GOTO A134
$ A132:		WC "$ 		DELETE/NOLOG SMOOTH_LINE.FOR;*"
$ A134:		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN GOTO A136
$ 		WC "$ 		IF .NOT. INTER THEN DELETE/NOLOG SMOOTH_LINE.LIS;*"
$		GOTO A138
$ A136:		WC "$ 		PURGE/NOLOG SMOOTH_LINE.LIS"
$ A138:		WC "$ 		DELETE ADC.IDE;*"
$!
$ A140:	   IF .NOT. FIL THEN GOTO A150
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC FILTER_LINE''KPCOM'=FILTER_LINE"
$	   	WC "$ 		FORT''FSW1' FILTER_LINE"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV FILTER_LINE"
$		WC "$ 		PURGE/NOLOG FILTER_LINE.OBJ"
$		IF FSW1.EQS."" THEN GOTO A142
$ 		WC "$ 		PURGE/NOLOG FILTER_LINE.FOR"
$		GOTO A144
$ A142:		WC "$ 		DELETE/NOLOG FILTER_LINE.FOR;*"
$ A144:		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN GOTO A146
$ 		WC "$ 		IF .NOT. INTER THEN DELETE/NOLOG FILTER_LINE.LIS;*"
$		GOTO A148
$ A146:		WC "$ 		PURGE/NOLOG FILTER_LINE.LIS"
$ A148:		WC "$ 		DELETE ADC.IDE;*"
$!
$ A150:	   IF .NOT. EXCEPT THEN GOTO LNKONLY
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		IF IFILT_DBG
$		THEN
$		   WC "$		ADC EXCEPT''KPCOM'=IFILTER_DEBUG.TRU/TR,BRIDGE.SRC,ERR$ROUT.SRC"
$		ELSE
$		   WC "$		ADC EXCEPT''KPCOM'=IFILTER_NODEBUG.TRU/TR,BRIDGE.SRC,ERR$ROUT.SRC"
$		ENDIF
$   		WC "$ 		FORT''FSW1' EXCEPT"
$      		WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV EXCEPT"
$		WC "$ 		PURGE/NOLOG EXCEPT.OBJ"
$		IF FSW1.EQS."" THEN GOTO A152
$ 		WC "$ 		PURGE/NOLOG EXCEPT.FOR"
$		GOTO A154
$ A152:		WC "$ 		DELETE/NOLOG EXCEPT.FOR;*"
$ A154:		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN GOTO A156
$ 		WC "$ 		IF .NOT. INTER THEN DELETE/NOLOG EXCEPT.LIS;*"
$		GOTO A158
$ A156:		WC "$ 		PURGE/NOLOG EXCEPT.LIS"
$ A158:		WC "$ 		DELETE ADC.IDE;*"
$!
$ LNKONLY:
$ 	IF .NOT. LNKIT THEN GOTO NOLNK
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$	   	WC "$ 		LINK''LINKOPTS'/EXE=''LINKVER'  -"
$	   	WC "		IFILTER,IFILTER_CLD,FILTER_LINE, -"
$	   	WC "		GET_COMMAND,EXCEPT,PROCESS, -"
$		WC "		SMOOTH_LINE,IFILT.PROMSG_OBJ, -"
$		WC "LSL$source_root:[lslmaint.coordlib.test]COORDLIB/LIB, -"
$		WC "    	LSL$LIBRARY:LSLFRTLIB/LIB,-"
$		WC "    	LSL$LIBRARY:IFFSHR/OPT,-"
$		WC "    	LSL$LIBRARY:LSLSHR/OPT"
$	   	WC "$ 		PURGE/NOLOG IFILTER*.EXE"
$	   	WC "$ 		PURGE/NOLOG IFILTER*.MAP"
$!
$ NOLNK:
$		WC "$ 		IFILTEREX:"
$		WC "$ 		DEASS/GROUP LSL$IFILTER_BUILDING"
$		WC "$ 		SET NOVER"
$!
$ FILCLO:
$	SET NOVERIFY
$	ON ERROR THEN GOTO IFILTEREX
$	ON CONTROL_Y THEN GOTO IFILTEREX
$	CLOSE COMFIL
$	PURGE/NOLOG/KEEP=3 IFILTERBAT.COM
$	OK=$STATUS
$	IF OK THEN INQ/NOP ANSWER_BAT "Submit for batch ? "
$	IF .NOT. ANSWER_BAT THEN GOTO INT
$	DEASS/GROUP LSL$IFILTER_BUILDING
$	BAT IFILTERBAT.COM
$	GOTO IFILTERX2
$ INT:	
$	IF OK THEN INQ/NOP ANSWER "Interactive ? "
$	IF .NOT.ANSWER THEN GOTO IFILTEREX
$	DEASS/GROUP LSL$IFILTER_BUILDING
$	@IFILTERBAT.COM
$	GOTO IFILTERX2
$ IFILTEREX:
$	DEASS/GROUP LSL$IFILTER_BUILDING
$ IFILTERX2:
$	IF VER THEN SET VERIFY
