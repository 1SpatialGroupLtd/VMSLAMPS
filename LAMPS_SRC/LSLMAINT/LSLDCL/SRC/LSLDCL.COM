$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1985-11-22 11:30:40.000000000 +0000
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
$!	Created					 TJH	12-Sep-1985
$!
$! Command file for building LSLDCL
$!
$	ON ERROR THEN GOTO DCLEX
$	ON CONTROL_Y THEN EXIT
$!
$	DISK:='F$LOGICAL("SYS$DISK")'
$	IF "''F$LOGICAL("LSL$DCL_BUILDING")'" .NES. "IN_PROGRESS" -
	   THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$A0:	ON CONTROL_Y THEN GOTO DCLEX
$	DEFINE/GROUP LSL$DCL_BUILDING "IN_PROGRESS"
$	OPEN/WRITE COMFIL LSLDCLBAT.COM
$	ON CONTROL_Y THEN GOTO FILCLO
$ 	ON ERROR THEN GOTO FILCLO
$	WC="WRITE COMFIL"
$!
$	WC	"$	ON CONTROL_Y THEN GOTO DCLEX"
$	WC	"$	IF ""'","'F$LOGICAL(""LSL$DCL_BUILDING"")'"" -"
$	WC	"		 .NES. ""IN_PROGRESS"" THEN GOTO A0"
$	WC	"$	WRITE SYS$OUTPUT ""Someone else is building"""
$	WC	"$	EXIT"
$	WC	"$!"
$	WC	"$A0:	DEFINE/GROUP LSL$DCL_BUILDING ""IN_PROGRESS"""
$	WC	"$	ASSIGN ''DISK'[TONY.LIB.COMMON] LSL$CMNLSL"
$	WC	"$	SD:=$LSL$SYS:SD"
$	WC	"$	SET NOON"
$	WC 	"$ 	SET NOVERIFY"
$	WC	"$	ERROR=""
$!
$	MLDBG=""
$	FSW1=""
$	KPCOM=""
$	INQUIRE/NOP DCL_DBG "With Debug ? "
$	IF .NOT. DCL_DBG THEN GOTO A05
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
$A05:
$	INQ/NOP ALL "Everything ? "
$!
$	  FILE1="F.DCL_CML,DCL_CML		"
$	  FILE2="F.DCL_COMMA,DCL_COMMA		"
$	  FILE3="F.DCL_DBL,DCL_DBL		"
$	  FILE4="F.DCL_FILE,DCL_FILE		"
$         FILE5="F.DCL_ERRET,DCL_ERRET		"
$         FILE6="F.DCL_INT,DCL_INT		"
$	  FILE7="F.DCL_QUAL,DCL_QUAL		"
$	  FILE8="F.DCL_REAL,DCL_REAL		"
$	  FILE9="F.DCL_STARTUP,DCL_STARTUP	"
$	  FILE10="F.DCL_STR,DCL_STR		"
$	  TIMES=10
$	  COUNT=0
$ NXTASK:
$	  COUNT=COUNT+1
$	  OUT=F$EXTRACT(2,F$LOCATE(",",FILE'COUNT')-2,FILE'COUNT')
$	  FILES=F$EXTRACT(F$LOCATE(",",FILE'COUNT')+1,100,FILE'COUNT')
$	  IF ALL THEN YES="Y"
$	  IF .NOT.ALL THEN INQUIRE YES "''OUT' (''FILES')"
$	  IF .NOT.YES THEN FILE'COUNT'=""
$	  IF COUNT.LT.TIMES THEN GOTO NXTASK
$ NOB:
$	  COUNT=0
$ NXTC:
$	  COUNT=COUNT+1
$	    CMP=F$EXTRACT(0,1,FILE'COUNT')
$	    OUT=F$EXTRACT(2,F$LOCATE(",",FILE'COUNT')-2,FILE'COUNT')
$	    FILES=F$EXTRACT(F$LOCATE(",",FILE'COUNT')+1,100,FILE'COUNT')
$	    IF CMP.EQS."M" THEN GOTO MAC
$	    IF ALL THEN WRITE SYS$OUTPUT "Writing commands for ''OUT'"
$	    IF CMP.NES."F" THEN GOTO SKIPC
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		OUTSW=OUT+KPCOM
$		WC "$ SET VERIFY"
$		WC "$ ADC ''OUTSW' = ''FILES'"
$		WC "$ FORT''FSW1' ''OUT'"
$	      	WC "$ OK=$STATUS"	
$	        WC "$ IF .NOT. OK THEN ERROR=ERROR+"" ''OUT'"""
$		WC "$ IF OK THEN PVV ''OUT'"
$		WC "$ PURGE/NOLOG ''OUT'.OBJ
$		IF FSW1.EQS."" THEN -
			WC "$ PURGE/NOLOG ''OUT'.FOR"
$		IF (F$LOCATE("LIST",FSW1).NE.F$LENGTH(FSW1)).AND. -
			F$LENGTH(FSW1).NE.0 THEN -
				WC "$ PURGE/NOLOG ''OUT'.LIS"
$		WC "$ DELETE ADC.IDE;*"
$		WC "$ SET NOVER"
$	      GOTO SKIPC
$ MAC:
$		WC "$ MACRO''MLDBG'/OBJECT=''OUT' ''FILES'"
$		WC "$ OK=$STATUS"			
$	        WC "$ IF .NOT.OK THEN ERROR=ERROR+"" ""+OUT"
$		WC "$ PURGE/NOLOG ''OUT'.OBJ
$ SKIPC:
$!
$	  IF COUNT.LT.TIMES THEN GOTO NXTC
$!
$ 		WC "$ IF ERROR.NES."""" THEN WRITE SYS$OUTPUT ""Errors in""+ERROR"
$!
$!
$	WC	"$ DCLEX:"
$	WC	"$	DEASS/GROUP LSL$DCL_BUILDING"
$!
$ FILCLO:
$	SET NOVERIFY
$	ON ERROR THEN GOTO DCLEX
$	CLOSE COMFIL
$	OK=$STATUS
$	IF OK THEN INQ/NOP ANSWER_BAT "Submit for batch ? "
$	IF .NOT. ANSWER_BAT THEN GOTO INT
$	DEASS/GROUP LSL$DCL_BUILDING
$	BAT LSLDCLBAT.COM
$	GOTO DCLEX2
$ INT:	
$	IF OK THEN INQ/NOP ANSWER "Interactive ? "
$	IF .NOT.ANSWER THEN GOTO DCLEX
$	DEASS/GROUP LSL$DCL_BUILDING
$	@LSLDCLBAT.COM
$	GOTO DCLEX2
$ DCLEX:
$	DEASS/GROUP LSL$DCL_BUILDING
$ DCLEX2:
$	IF VER THEN SET VERIFY
