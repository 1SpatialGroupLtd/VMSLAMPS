$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-27 15:44:08.000000000 +0100
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
$!MOD	Changed the build directory for CMS		ST  27-Jul-1993
$!MOD	Uses shareable library images			JMB 30-Nov-1987
$!MOD	Newmessage F(ortran) option added		ATT 14-Jan-1987
$!MOD	CPCLOSE added					TJH 24-Nov-1986
$!MOD	Option to link with testing LSLLIB 		TJH 03-Nov-1986
$!	Created					 	TJH 30-Sep-1986
$!
$! Command file for building ISTART
$!
$	ON ERROR THEN GOTO ISTARTEX
$	ON CONTROL_Y THEN EXIT
$!
$	DISK:='F$LOGICAL("SYS$DISK")'
$	IF "''F$LOGICAL("LSL$ISTART_BUILDING")'" .NES. "IN_PROGRESS" -
	   THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$A0:	ON CONTROL_Y THEN GOTO ISTARTEX
$	DEFINE/GROUP LSL$ISTART_BUILDING "IN_PROGRESS"
$	OPEN/WRITE COMFIL ISTARTBAT.COM
$	ON CONTROL_Y THEN GOTO FILCLO
$ 	ON ERROR THEN GOTO FILCLO
$	WC="WRITE COMFIL"
$!
$	WC 	"$ 	SET NOVERIFY"
$	WC	"$	ON CONTROL_Y THEN GOTO ISTARTEX"
$	WC	"$	IF ""'","'F$LOGICAL(""LSL$ISTART_BUILDING"")'"" -"
$	WC	"		 .NES. ""IN_PROGRESS"" THEN GOTO A0"
$	WC	"$	WRITE SYS$OUTPUT ""Someone else is building"""
$	WC	"$	EXIT"
$	WC	"$!"
$	WC	"$A0:	DEFINE/GROUP LSL$ISTART_BUILDING ""IN_PROGRESS"""
$	WC	"$	ASSIGN LSL$SOURCE_ROOT:[IMP.ISTART.SRC] LSL$CMNISTART"
$	WC	"$	SD:=$LSL$SYS:SD"
$	WC	"$	SET NOON"
$!
$	RENMES=""
$	MLDBG=""
$	FSW1=""
$	KPCOM=""
$	INQUIRE/NOP COMPILE "Compile ? "
$	IF .NOT.COMPILE THEN GOTO A04
$	INQUIRE/NOP ISTART_DBG "With Debug ? "
$	IF .NOT. ISTART_DBG THEN GOTO A04
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
$	   ABANDON_HLP="T"
$	   BUTTONS_HLP="T"
$	   CENTRE="T"
$	   CMDLIN="T"
$	   CP_CHECK="T"
$	   CPCLOSE="T"
$	   CP_HLP="T"
$	   CP_PRINT="T"
$	   EXTENT_HLP="T"
$	   GEN_INTRO="T"
$	   GET_CPS="T"
$	   GET_EXTENT="T"
$	   GET_GRIDSTEP="T"
$	   GET_MHBGI="T"
$	   GET_ORIGIN="T"
$	   GET_SCALE="T"
$	   IFFFIN="T"
$	   IFF_HEADER="T"
$	   GRIDSTEP_HLP="T"
$	   ISTART="T"
$	   ISTART_BLANK="T"
$	   LENGTH="T"
$	   MUART_CPS="T"
$	   OPEN_IFF="T"
$	   ORIGIN_HLP="T"
$	   OSGRID="T"
$	   PRESS_HLP="T"
$	   REGISTER="T"
$	   RESCALE="T"
$	   ROTATE="T"
$	   SCALE_HLP="T"
$	   TABMON_CPS="T"
$	   TAB_INTRO="T"
$	   TOOFAR="T"
$	   TT_INPUT="T"
$	   TT_CPS="T"
$!
$! TABLE_MONITOR and direct table read stuff (should be in a library)
$	   DIGTRN="T"
$	   GETABL="T"
$	   GTDGXY="T"
$	   GTYPAC="T"
$	   STRDTB="T"
$	   TABINIT="T"
$	   TRNBUT="T"
$	   EFWM="T"
$	   GOTO A11
$!
$ A05:
$	   INQ/NOP CENTRE	"Compile CENTRE ?	"
$	   INQ/NOP CMDLIN	"Compile CMDLIN ?	"
$	   INQ/NOP CP_CHECK	"Compile CP_CHECK ?	"
$	   INQ/NOP CPCLOSE	"Compile CPCLOSE ?	"
$	   INQ/NOP CP_PRINT	"Compile CP_PRINT ?	"
$	   INQ/NOP GEN_INTRO	"Compile GEN_INTRO ?	"
$	   INQ/NOP GET_CPS	"Compile GET_CPS ?	"
$	   INQ/NOP GET_EXTENT	"Compile GET_EXTENT ?	"
$	   INQ/NOP GET_GRIDSTEP	"Compile GET_GRIDSTEP?	"
$	   INQ/NOP GET_MHBGI	"Compile GET_MHBGI ?	"
$	   INQ/NOP GET_ORIGIN	"Compile GET_ORIGIN ?	"
$	   INQ/NOP GET_SCALE	"Compile GET_SCALE ?	"
$	   INQ/NOP IFFFIN	"Compile IFFFIN ?	"
$	   INQ/NOP IFF_HEADER	"Compile IFF_HEADER ?	"
$	   INQ/NOP ISTART	"Compile ISTART ?	"
$	   INQ/NOP ISTART_BLANK	"Compile ISTART_BLANK ?	"
$	   INQ/NOP LENGTH	"Compile LENGTH ?	"
$	   INQ/NOP MUART_CPS	"Compile MUART_CPS ?	"
$	   INQ/NOP OPEN_IFF	"Compile OPEN_IFF ?	"
$	   INQ/NOP OSGRID	"Compile OSGRID ?	"
$	   INQ/NOP REGISTER	"Compile REGISTER ?	"
$	   INQ/NOP RESCALE	"Compile RESCALE ?	"
$	   INQ/NOP ROTATE	"Compile ROTATE ?	"
$	   INQ/NOP TABMON_CPS	"Compile TABMON_CPS ? 	"
$	   INQ/NOP TAB_INTRO	"Compile TAB_INTRO? 	"
$	   INQ/NOP TOOFAR	"Compile TOOFAR ?	"
$	   INQ/NOP TT_CPS	"Compile TT_CPS ?	"
$	   INQ/NOP TT_INPUT	"Compile TT_INPUT ?	"
$!
$!
$ 	   WRITE SYS$OUTPUT " "
$	   INQ/NOP CMPTAB "Compile TABLE MONITOR/direct table read stuff ? "
$	   IF .NOT.CMPTAB THEN GOTO A4
$ 	   WRITE SYS$OUTPUT " "
$ 	   WRITE SYS$OUTPUT "OK. The inquisition will continue!"
$ 	   WRITE SYS$OUTPUT " "
$!
$	   INQ/NOP DIGTRN "Compile DIGTRN ? 	"
$	   INQ/NOP GETABL "Compile GETABL ? 	"
$	   INQ/NOP GTDGXY "Compile GTDGXY ?	"
$	   INQ/NOP GTYPAC "Compile GTYPAC ?	"
$	   INQ/NOP STRDTB "Compile STRDTB ?	"
$	   INQ/NOP TABINIT "Compile TABINIT ?	"
$	   INQ/NOP TRNBUT "Compile TRNBUT ?	"
$	   WRITE SYS$OUTPUT " "
$	   WRITE SYS$OUTPUT "Macro table stuff"
$	   INQ/NOP EFWM "Compile EFWM?		"
$	   GOTO A5
$!
$ A4:	   DIGTRN="F"
$	   GETABL="F"
$	   GTDGXY="F"
$	   GTYPAC="F"
$	   STRDTB="F"
$	   TABINIT="F"
$	   TRNBUT="F"
$	   EFWM  ="F"
$!
$ A5: 	   WRITE SYS$OUTPUT " "
$ 	   INQ/NOP CMPHLP "Compile ISTART/LEARNER help stuff ? "
$	   IF .NOT.CMPHLP THEN GOTO A10
$ 	   WRITE SYS$OUTPUT " "
$ 	   WRITE SYS$OUTPUT "Someone must really hate you today!"
$ 	   WRITE SYS$OUTPUT " "
$!
$	   INQ/NOP ABANDON_HLP	"Compile ABANDON_HLP ? 	"
$	   INQ/NOP BUTTONS_HLP	"Compile BUTTONS_HLP ?	"
$	   INQ/NOP CP_HLP	"Compile CP_HLP ?	"
$	   INQ/NOP EXTENT_HLP	"Compile EXTENT_HLP?	"
$	   INQ/NOP GRIDSTEP_HLP	"Compile GRIDSTEP_HLP?	"
$	   INQ/NOP ORIGIN_HLP	"Compile ORIGIN_HLP ?	"
$	   INQ/NOP PRESS_HLP	"Compile PRESS_HLP ?	"
$	   INQ/NOP SCALE_HLP	"Compile SCALE_HLP ?	"
$!
$	   GOTO A11
$!
$ A10:	   WRITE SYS$OUTPUT " "
$	   ABANDON_HLP="F"
$	   BUTTONS_HLP="F"
$	   CP_HLP="F"
$	   EXTENT_HLP="F"
$	   GRIDSTEP_HLP="F"
$	   ORIGIN_HLP="F"
$	   PRESS_HLP="F"
$	   SCALE_HLP="F"
$!
$ A11:	   INQ/NOP MES "Generate message definitions ? "
$!
$	   INQUIRE/NOP LNKIT "Link ? "
$	   IF .NOT. LNKIT THEN GOTO NOTKB
$!
$	   LINKVER="ISTART"
$	   INQUIRE/NOP ANSWER "Experimental version ? "
$	   IF ANSWER THEN LINKVER="ISTARTX"
$!
$	   EXPLSL="LSL$LIBRARY:LSLSHR/OPT"
$!
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
$ 		IF .NOT. MES THEN GOTO NO_MESSING_ABOUT
$		wc "$	newmsg/number=1208/name=ISTART/prefix=ISTART__/parameter=for ISTART.mes"
$		wc "$ @ISTART.temp_com"
$ NO_MESSING_ABOUT:
$	   IF .NOT. CLD THEN GOTO FORTONLY
$		WC "$ 		ADC ISTART.TMP=ISTART.CLD"
$		WC "$ 		SET COMMAND/OBJECT=ISTART_CLD ISTART.TMP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV ISTART_CLD"
$		WC "$ 		IF OK THEN DELETE ISTART.TMP;*"
$		WC "$ 		IF OK THEN PURGE/NOLOG ISTART_CLD.OBJ"
$	
$ FORTONLY:		
$	IF .NOT. COMPILE THEN GOTO LNKONLY
$	   IF .NOT. ABANDON_HLP THEN GOTO A110
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ 		ADC ABANDON_HLP''KPCOM'=ABANDON_HLP"
$	   	WC "$ 		FORT''FSW1' ABANDON_HLP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV ABANDON_HLP"
$		WC "$ 		PURGE/NOLOG ABANDON_HLP.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG ABANDON_HLP.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG ABANDON_HLP.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A110:	   IF .NOT. BUTTONS_HLP THEN GOTO A120
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC BUTTONS_HLP''KPCOM'=BUTTONS_HLP"
$	   	WC "$ 		FORT''FSW1' BUTTONS_HLP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV BUTTONS_HLP"
$		WC "$ 		PURGE/NOLOG BUTTONS_HLP.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG BUTTONS_HLP.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG BUTTONS_HLP.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A120:	   IF .NOT. CP_CHECK  THEN GOTO A122
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC CP_CHECK''KPCOM'=CP_CHECK"
$	   	WC "$ 		FORT''FSW1' CP_CHECK"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV CP_CHECK"
$		WC "$ 		PURGE/NOLOG CP_CHECK.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG CP_CHECK.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG CP_CHECK.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A122:	   IF .NOT. CPCLOSE  THEN GOTO A123
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC CPCLOSE''KPCOM'=CPCLOSE"
$	   	WC "$ 		FORT''FSW1' CPCLOSE"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV CPCLOSE"
$		WC "$ 		PURGE/NOLOG CPCLOSE.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG CPCLOSE.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG CPCLOSE.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A123:	   IF .NOT. CP_HLP  THEN GOTO A124
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC CP_HLP''KPCOM'=CP_HLP"
$	   	WC "$ 		FORT''FSW1' CP_HLP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV CP_HLP"
$		WC "$ 		PURGE/NOLOG CP_HLP.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG CP_HLP.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG CP_HLP.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A124:	   IF .NOT. CP_PRINT  THEN GOTO A125
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC CP_PRINT''KPCOM'=CP_PRINT"
$	   	WC "$ 		FORT''FSW1' CP_PRINT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV CP_PRINT"
$		WC "$ 		PURGE/NOLOG CP_PRINT.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG CP_PRINT.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG CP_PRINT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A125:	   IF .NOT. CENTRE  THEN GOTO A130
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC CENTRE''KPCOM'=CENTRE"
$	   	WC "$ 		FORT''FSW1' CENTRE"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV CENTRE"
$		WC "$ 		PURGE/NOLOG CENTRE.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG CENTRE.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG CENTRE.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A130:	   IF .NOT. CMDLIN  THEN GOTO A135
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC CMDLIN''KPCOM'=CMDLIN,CMD_ERRET"
$	   	WC "$ 		FORT''FSW1' CMDLIN"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV CMDLIN"
$		WC "$ 		PURGE/NOLOG CMDLIN.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG CMDLIN.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG CMDLIN.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A135:	   IF .NOT. EXTENT_HLP THEN GOTO A137
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC EXTENT_HLP''KPCOM'=EXTENT_HLP"
$	   	WC "$ 		FORT''FSW1' EXTENT_HLP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV EXTENT_HLP"
$		WC "$ 		PURGE/NOLOG EXTENT_HLP.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG EXTENT_HLP.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG EXTENT_HLP.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A137:	   IF .NOT. GEN_INTRO  THEN GOTO A140
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC GEN_INTRO''KPCOM'=GEN_INTRO"
$	   	WC "$ 		FORT''FSW1' GEN_INTRO"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV GEN_INTRO"
$		WC "$ 		PURGE/NOLOG GEN_INTRO.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG GEN_INTRO.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG GEN_INTRO.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A140:	   IF .NOT. GET_CPS  THEN GOTO A142
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC GET_CPS''KPCOM'=GET_CPS"
$	   	WC "$ 		FORT''FSW1' GET_CPS"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV GET_CPS"
$		WC "$ 		PURGE/NOLOG GET_CPS.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG GET_CPS.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG GET_CPS.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$!
$ A142:	   IF .NOT. GET_EXTENT  THEN GOTO A145
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC GET_EXTENT''KPCOM'=GET_EXTENT"
$	   	WC "$ 		FORT''FSW1' GET_EXTENT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV GET_EXTENT"
$		WC "$ 		PURGE/NOLOG GET_EXTENT.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG GET_EXTENT.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG GET_EXTENT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$!
$ A145:	   IF .NOT. GET_GRIDSTEP THEN GOTO A150
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC GET_GRIDSTEP''KPCOM'=GET_GRIDSTEP"
$	   	WC "$ 		FORT''FSW1' GET_GRIDSTEP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV GET_GRIDSTEP"
$		WC "$ 		PURGE/NOLOG GET_GRIDSTEP.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG GET_GRIDSTEP.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG GET_GRIDSTEP.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$!
$ A150:	   IF .NOT. GET_MHBGI THEN GOTO A160
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC GET_MHBGI ''KPCOM'=GET_MHBGI"
$	   	WC "$ 		FORT''FSW1' GET_MHBGI"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV GET_MHBGI"
$		WC "$ 		PURGE/NOLOG GET_MHBGI.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG GET_MHBGI.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG GET_MHBGI.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A160:	   IF .NOT. GET_ORIGIN  THEN GOTO A170
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC GET_ORIGIN''KPCOM'=GET_ORIGIN"
$	   	WC "$ 		FORT''FSW1' GET_ORIGIN"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV GET_ORIGIN"
$		WC "$ 		PURGE/NOLOG GET_ORIGIN.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG GET_ORIGIN.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG GET_ORIGIN.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A170:	   IF .NOT. GET_SCALE  THEN GOTO A180
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC GET_SCALE''KPCOM'=GET_SCALE"
$	   	WC "$ 		FORT''FSW1' GET_SCALE"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV GET_SCALE"
$		WC "$ 		PURGE/NOLOG GET_SCALE.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG GET_SCALE.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG GET_SCALE.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A180:	   IF .NOT. IFFFIN  THEN GOTO A190
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC IFFFIN''KPCOM'=IFFFIN"
$	   	WC "$ 		FORT''FSW1' IFFFIN"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV IFFFIN"
$		WC "$ 		PURGE/NOLOG IFFFIN.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG IFFFIN.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG IFFFIN.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A190:	   IF .NOT. GRIDSTEP_HLP THEN GOTO A195
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC GRIDSTEP_HLP''KPCOM'=GRIDSTEP_HLP"
$	   	WC "$ 		FORT''FSW1' GRIDSTEP_HLP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV GRIDSTEP_HLP"
$		WC "$ 		PURGE/NOLOG GRIDSTEP_HLP.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG GRIDSTEP_HLP.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG GRIDSTEP_HLP.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A195:	   IF .NOT. IFF_HEADER THEN GOTO A200
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC IFF_HEADER''KPCOM'=IFF_HEADER"
$	   	WC "$ 		FORT''FSW1' IFF_HEADER"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV IFF_HEADER"
$		WC "$ 		PURGE/NOLOG IFF_HEADER.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG IFF_HEADER.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG IFF_HEADER.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A200:	   IF .NOT. ISTART  THEN GOTO A205
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC ISTART''KPCOM'=ISTART"
$	   	WC "$ 		FORT''FSW1' ISTART"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV ISTART"
$		WC "$ 		PURGE/NOLOG ISTART.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG ISTART.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG ISTART.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A205:	   IF .NOT. ISTART_BLANK  THEN GOTO A210
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC ISTART_BLANK''KPCOM'=ISTART_BLANK"
$	   	WC "$ 		FORT''FSW1' ISTART_BLANK"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV ISTART_BLANK"
$		WC "$ 		PURGE/NOLOG ISTART_BLANK.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG ISTART_BLANK.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG ISTART_BLANK.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A210:	   IF .NOT. MUART_CPS  THEN GOTO A220
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC MUART_CPS''KPCOM'=MUART_CPS"
$	   	WC "$ 		FORT''FSW1' MUART_CPS"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV MUART_CPS"
$		WC "$ 		PURGE/NOLOG MUART_CPS.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG MUART_CPS.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG MUART_CPS.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A220:	   IF .NOT. ORIGIN_HLP  THEN GOTO A225
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC ORIGIN_HLP''KPCOM'=ORIGIN_HLP"
$	   	WC "$ 		FORT''FSW1' ORIGIN_HLP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV ORIGIN_HLP"
$		WC "$ 		PURGE/NOLOG ORIGIN_HLP.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG ORIGIN_HLP.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG ORIGIN_HLP.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$ A225:	   IF .NOT. OPEN_IFF  THEN GOTO A230
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC OPEN_IFF''KPCOM'=OPEN_IFF"
$	   	WC "$ 		FORT''FSW1' OPEN_IFF"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV OPEN_IFF"
$		WC "$ 		PURGE/NOLOG OPEN_IFF.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG OPEN_IFF.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG OPEN_IFF.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$ A230:	   IF .NOT. OSGRID THEN GOTO A244
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC OSGRID''KPCOM'=OSGRID"
$	   	WC "$ 		FORT''FSW1' OSGRID"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV OSGRID"
$		WC "$ 		PURGE/NOLOG OSGRID.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG OSGRID.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG OSGRID.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A244:	   IF .NOT. PRESS_HLP  THEN GOTO A250
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC PRESS_HLP''KPCOM'=PRESS_HLP"
$	   	WC "$ 		FORT''FSW1' PRESS_HLP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV PRESS_HLP"
$		WC "$ 		PURGE/NOLOG PRESS_HLP.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG PRESS_HLP.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG PRESS_HLP.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A245:	   IF .NOT. SCALE_HLP THEN GOTO A250
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC SCALE_HLP''KPCOM'=SCALE_HLP"
$	   	WC "$ 		FORT''FSW1' SCALE_HLP"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV SCALE_HLP"
$		WC "$ 		PURGE/NOLOG SCALE_HLP.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG SCALE_HLP.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG SCALE_HLP.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A250:	   IF .NOT. REGISTER  THEN GOTO A260
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC REGISTER''KPCOM'=REGISTER"
$	   	WC "$ 		FORT''FSW1' REGISTER"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV REGISTER"
$		WC "$ 		PURGE/NOLOG REGISTER.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG REGISTER.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG REGISTER.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$ A260:	   IF .NOT. RESCALE THEN GOTO A270
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC RESCALE''KPCOM'=RESCALE"
$	   	WC "$ 		FORT''FSW1' RESCALE"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV RESCALE"
$		WC "$ 		PURGE/NOLOG RESCALE.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG RESCALE.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG RESCALE.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A270:	   IF .NOT. ROTATE  THEN GOTO A280
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC ROTATE''KPCOM'=ROTATE"
$	   	WC "$ 		FORT''FSW1' ROTATE"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV ROTATE"
$		WC "$ 		PURGE/NOLOG ROTATE.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG ROTATE.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG ROTATE.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A280:	   IF .NOT. TABMON_CPS THEN GOTO A290
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC TABMON_CPS''KPCOM'=TABMON_CPS"
$	   	WC "$ 		FORT''FSW1' TABMON_CPS"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV TABMON_CPS"
$		WC "$ 		PURGE/NOLOG TABMON_CPS.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG TABMON_CPS.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG TABMON_CPS.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$ A290:	   IF .NOT. TAB_INTRO THEN GOTO A300
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC TAB_INTRO ''KPCOM'=TAB_INTRO"
$	   	WC "$ 		FORT''FSW1' TAB_INTRO"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV TAB_INTRO "
$		WC "$ 		PURGE/NOLOG TAB_INTRO.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG TAB_INTRO.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG TAB_INTRO.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$ A300:	   IF .NOT. TOOFAR  THEN GOTO A310
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC TOOFAR''KPCOM'=TOOFAR"
$	   	WC "$ 		FORT''FSW1' TOOFAR"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV TOOFAR"
$		WC "$ 		PURGE/NOLOG TOOFAR.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG TOOFAR.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG TOOFAR.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A310:	   IF .NOT. TT_CPS  THEN GOTO A330
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC TT_CPS''KPCOM'=TT_CPS"
$	   	WC "$ 		FORT''FSW1' TT_CPS"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV TT_CPS"
$		WC "$ 		PURGE/NOLOG TT_CPS.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG TT_CPS.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG TT_CPS.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A330:	   IF .NOT. TT_INPUT  THEN GOTO A340
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC TT_INPUT''KPCOM'=TT_INPUT"
$	   	WC "$ 		FORT''FSW1' TT_INPUT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV TT_INPUT"
$		WC "$ 		PURGE/NOLOG TT_INPUT.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG TT_INPUT.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG TT_INPUT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$		WC "$ WRITE SYS$OUTPUT "" """
$		WC "$ WRITE SYS$OUTPUT "" T A B L E  M O N I T O R  &  D I R E C T   T A B L E    R E A D   S T U F F"""
$		WC "$ WRITE SYS$OUTPUT "" """
$! 
$ A340:	   IF .NOT. DIGTRN THEN GOTO A350
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC DIGTRN''KPCOM'=DIGTRN"
$	   	WC "$ 		FORT''FSW1' DIGTRN"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV DIGTRN"
$		WC "$ 		PURGE/NOLOG DIGTRN.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG DIGTRN.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG DIGTRN.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A350:	   IF .NOT. GETABL THEN GOTO A360
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC GETABL''KPCOM'=GETABL"
$	   	WC "$ 		FORT''FSW1' GETABL"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV GETABL"
$		WC "$ 		PURGE/NOLOG GETABL.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG GETABL.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG GETABL.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A360:	   IF .NOT. GTDGXY THEN GOTO A370
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC GTDGXY''KPCOM'=GTDGXY"
$	   	WC "$ 		FORT''FSW1' GTDGXY"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV GTDGXY"
$		WC "$ 		PURGE/NOLOG GTDGXY.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG GTDGXY.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG GTDGXY.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A370:	   IF .NOT. GTYPAC THEN GOTO A380
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC GTYPAC''KPCOM'=GTYPAC"
$	   	WC "$ 		FORT''FSW1' GTYPAC"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV GTYPAC"
$		WC "$ 		PURGE/NOLOG GTYPAC.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG GTYPAC.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG GTYPAC.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A380:	   IF .NOT. LENGTH THEN GOTO A390
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC LENGTH''KPCOM'=LENGTH"
$	   	WC "$ 		FORT''FSW1' LENGTH"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV LENGTH"
$		WC "$ 		PURGE/NOLOG LENGTH.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG LENGTH.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG LENGTH.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A390:	   IF .NOT. STRDTB THEN GOTO A400
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC STRDTB''KPCOM'=STRDTB"
$	   	WC "$ 		FORT''FSW1' STRDTB"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV STRDTB"
$		WC "$ 		PURGE/NOLOG STRDTB.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG STRDTB.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG STRDTB.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A400:	   IF .NOT. TABINIT THEN GOTO A410
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC TABINIT''KPCOM'=TABINIT"
$	   	WC "$ 		FORT''FSW1' TABINIT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV TABINIT"
$		WC "$ 		PURGE/NOLOG TABINIT.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG TABINIT.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG TABINIT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A410:	   IF .NOT. TRNBUT THEN GOTO A420
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC TRNBUT''KPCOM'=TRNBUT"
$	   	WC "$ 		FORT''FSW1' TRNBUT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV TRNBUT"
$		WC "$ 		PURGE/NOLOG TRNBUT.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG TRNBUT.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG TRNBUT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A420:	   IF .NOT. TRNBUT THEN GOTO A440
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$		WC "$ 		ADC TRNBUT''KPCOM'=TRNBUT"
$	   	WC "$ 		FORT''FSW1' TRNBUT"
$	      	WC "$ 		OK=$STATUS"	
$		WC "$ 		IF OK THEN PVV TRNBUT"
$		WC "$ 		PURGE/NOLOG TRNBUT.OBJ"
$		IF FSW1.EQS."" THEN -
			WC "$ 		PURGE/NOLOG TRNBUT.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ 		PURGE/NOLOG TRNBUT.LIS"
$		WC "$ 		DELETE ADC.IDE;*"
$!
$ A440:	   IF .NOT. EFWM THEN GOTO LNKONLY
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$	   	WC "$ 		MACRO''MLDBG' EFWM"
$		WC "$ 		PURGE/NOLOG EFWM.OBJ"
$!
$ LNKONLY:
$ 	IF .NOT. LNKIT THEN GOTO NOLNK
$		WC "$ SET NOVERIFY"
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ SET VERIFY"
$	   	WC "$	LINK''LINKOPTS'/EXE=''LINKVER' -"
$		WC "	ISTART,ISTART_CLD, -"
$		WC "	ABANDON_HLP, BUTTONS_HLP, CENTRE, CMDLIN, -"
$		WC "	CP_CHECK, CPCLOSE, CP_HLP, CP_PRINT,-"
$		WC "	DIGTRN, EFWM, EXTENT_HLP, -"
$		WC "	GEN_INTRO, GET_CPS, GET_EXTENT, - "
$		WC "	GETABL, GTDGXY, GTYPAC, -"
$		WC "	GET_GRIDSTEP, GET_MHBGI, GET_ORIGIN, -"
$		WC "	GET_SCALE, IFFFIN, IFF_HEADER, ISTART_BLANK, -"
$		WC "	GRIDSTEP_HLP, LENGTH, MUART_CPS, OPEN_IFF,-"
$		WC "	ORIGIN_HLP, OSGRID, PRESS_HLP, REGISTER, -"
$		WC "	RESCALE, ROTATE, SCALE_HLP, STRDTB,TABMON_CPS,-"
$		WC "	TABINIT, TRNBUT, -"
$		WC "	TAB_INTRO, TOOFAR, TT_CPS, -"
$		WC "	TT_INPUT, ISTART.PROMSG_OBJ, -"
$	   	WC "	LSL$LIBRARY:OSMHLIB/LIB, -"
$	   	WC "	LSL$LIBRARY:TABLIB/LIB,TRANLIB/LIB,-"
$		WC "	WOSPLIB/LIB, -"
$	   	WC "	LSL$LIBRARY:IFFSHR/OPT,''EXPLSL'"
$!
$ NOLNK:
$		WC "$ 		ISTARTEX:"
$		WC "$ 		DEASS/GROUP LSL$ISTART_BUILDING"
$		WC "$ 		SET NOVER"
$!
$ FILCLO:
$	SET NOVERIFY
$	ON ERROR THEN GOTO ISTARTEX
$	CLOSE COMFIL
$	OK=$STATUS
$	IF OK THEN INQ/NOP ANSWER_BAT "Submit for batch ? "
$	IF .NOT. ANSWER_BAT THEN GOTO INT
$	DEASS/GROUP LSL$ISTART_BUILDING
$	BAT ISTARTBAT.COM
$	GOTO ISTARTX2
$ INT:	
$	IF OK THEN INQ/NOP ANSWER "Interactive ? "
$	IF .NOT.ANSWER THEN GOTO ISTARTEX
$	DEASS/GROUP LSL$ISTART_BUILDING
$	@ISTARTBAT.COM
$	GOTO ISTARTX2
$ ISTARTEX:
$	DEASS/GROUP LSL$ISTART_BUILDING
$ ISTARTX2:
$	IF VER THEN SET VERIFY
