$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-11-11 19:23:52.000000000 +0000
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
$!
$! MAKE.COM - command file generator for building complex programs.
$!
$! Original by SCM					1979
$!MOD	additions by PGH, AJW and DM.			1980 to 1988
$!MOD	allow link switches				PGH	15-Jul-1991
$!MOD	Remove call to CHARGE, as withdrawn		PGH	11-Nov-1991
$!
$! MAKE allows creation of command files to compile modules and link programs.
$!
$	SET NOON
$	ON CONTROL_Y THEN EXIT 1554	!   with error status
$!
$	GOTO MAK_'P1'
$	WRITE SYS$OUTPUT "Unknown MAKE parameter: ",P1
$	EXIT
$!
$! Consider and possibly recreate a module
$!
$MAK_C: MAK$TR="TR:/TR,"
$	IF P2.EQS."M".OR.P2.EQS."AM" THEN MAK$TR="TR:+"
$	GOTO MAK_MLIST
$MAK_U: MAK$TR=""
$MAK_MLIST: MAK$MLIS=MAK$LIS
$	IF MAK$LIS .EQS. "/NOLIST" THEN GOTO MAK_WHICH
$	IF P2.EQS."M".OR.P2.EQS."AM" THEN MAK$MLIS=MAK$LIS+"="+P3
$MAK_WHICH: MAK$PVV=0
$	IF P2 .EQS. "F"  THEN GOTO MAK_F
$	IF P2 .EQS. "AF" THEN GOTO MAK_AF
$	IF P2 .EQS. "AP" THEN GOTO MAK_AP
$	IF P2 .EQS. "APF" THEN GOTO MAK_APF
$	IF P2 .EQS. "C" THEN GOTO MAK_CC
$	IF P2 .EQS. "CP" THEN GOTO MAK_CP
$	IF P2 .EQS. "M" THEN GOTO MAK_M
$	IF P2 .EQS. "MP" THEN GOTO MAK_MP
$	IF P2 .EQS. "AM" THEN GOTO MAK_AM	! alias for MP
$	IF P2 .EQS. "A" THEN GOTO MAK_A
$	IF P2 .EQS. "L" THEN GOTO MAK_LINK
$	WO "Unknown type: ",P2
$	EXIT
$!
$MAK_AF: WC "$	ADC ",P3,"/CD:CMN:",MAK$ADCC,"=",MAK$TR,"SRC:",P4
$MAK_FP: MAK$PVV=1
$MAK_F: WC "$	FORTRAN",MAK$NOI4,MAK$DEB,MAK$LIS,MAK$FSW," ",P3
$	IF P2.NES."F".AND..NOT.MAK$FKP THEN WC "$	DELETE ",P3,".FOR;*"
$	IF P2.NES."F".AND.     MAK$FKP THEN WC "$	PURGE ",P3,".FOR"
$	IF .NOT. MAK$PVV THEN GOTO MAK_F1
$	WC "$	PVV ",P3
$	WC "$	DELETE ADC.IDE;*"
$MAK_F1: WC "$	PURGE ",P3,".OBJ"
$	IF MAK$LIS.EQS."/LIST" THEN WC "$	PURGE ",P3,".LIS"
$	EXIT
$!
$MAK_APF: WC "$	ADC ",P3,"/AP/CD:CMN:",MAK$ADCC,"=",MAK$TR,"SRC:",P4
$	GOTO MAK_FP
$!
$MAK_CC: WC "$	CC",MAK$DEB,MAK$LIS,MAK$CSW,"/OBJECT=",P3," C:",P4
$MAK_C1: WC "$	PURGE ",P3,".OBJ"
$	IF MAK$LIS.EQS."/LIST" THEN WC "$	PURGE ",P3,".LIS"
$	EXIT
$!
$MAK_CP: WC "$	CC",MAK$DEB,MAK$LIS,MAK$CSW,"/OBJECT=",P3,".TEMP_OBJ C:",P4
$	WC "$	APPEND ",P3,".TEMP_OBJ ",P3,".OBJ"
$	WC "$	DELETE ",P3,".TEMP_OBJ;*"
$	GOTO MAK_C1
$!
$MAK_M:	WC "$	MACRO",MAK$MLIS,MAK$MDEB,"/OBJECT=",P3," ",MAK$TR," -"
$	IF F$LOCATE(":",P4).LT.F$LOCATE("+",P4) THEN GOTO MAK_M1
$	WC "		MAR:",P4
$	GOTO MAK_M2
$MAK_M1:WC "		",P4
$MAK_M2:WC "$	PURGE ",P3,".OBJ"
$	IF MAK$LIS .EQS. "/LIST" THEN WC "$	PURGE ",P3,".LIS"
$	EXIT
$!
$MAK_MP:
$MAK_AM: WC "$	MACRO",MAK$MLIS,MAK$MDEB,"/OBJECT=",P3,".TEMP_OBJ ",MAK$TR," - "
$	IF F$LOCATE(":",P4).LT.F$LOCATE("+",P4) THEN GOTO MAK_M3
$	WC "		MAR:",P4
$	GOTO MAK_M4
$MAK_M3:WC "		",P4
$MAK_M4:WC "$	APPEND ",P3,".TEMP_OBJ ",P3,".OBJ"
$	WC "$	DELETE ",P3,".TEMP_OBJ;*"
$	EXIT
$MAK_A:	WC "$	ADC ",P3,"/CD:CMN:",MAK$ADCC,"=",MAK$TR,"SRC:",P4
$	EXIT
$!
$MAK_AP: WC "$	ADC ",P3,"/AP/CD:CMN:",MAK$ADCC,"=",MAK$TR,"SRC:",P4
$	EXIT
$!
$! ask questions
$!
$MAK_INQ:
$MAK_ASK: MAK$AUTO=MAK$ALL
$	IF MAK$ALL THEN GOTO MAK_YES
$	IF M1.EQS."" THEN GOTO MAK_IS
$	MAK$AUTO=1
$	N=1
$MAK_NEXT:
$	IF M'N' .EQS.P2 THEN GOTO MAK_YES
$	N=N+1
$	IF N .LE. 7 THEN GOTO MAK_NEXT
$MAK_NO: YES==0
$	NO==1
$	GOTO MAK_YESNO
$MAK_IS: INQUIRE/NOP YES "''P3' ? "
$	IF .NOT. YES THEN GOTO MAK_NO
$MAK_YES: IF MAK$AUTO THEN WRITE SYS$OUTPUT "MAKing ",P3
$	PL="+"
$	TTT=" "
$	IF F$LENGTH(P3) THEN TTT:=""	! if even then make it odd
$	N = 20-'F$LENGTH(P3)'/2
$	IF N.GT.1 THEN PL=F$EXTRACT(0,N,"++++++++++++++++++++++++++++++")
$	WC "$!  ",PL,"  ",P3,TTT,"  ",PL
$	YES==1
$	NO==0
$MAK_YESNO:IF P1.EQS."INQ" THEN 'P2' == YES
$	EXIT
$!
$! Initialise
$! 
$MAK_I: 
$! First set up the MAKE directory from the current environment
$	Command_file=f$ENVIRONMENT("PROCEDURE")
$	C_node=F$PARSE(Command_file,,,"NODE")
$	C_device=F$PARSE(Command_file,,,"DEVICE")
$	C_directory=F$PARSE(Command_file,,,"DIRECTORY")
$	C_dir=C_node+C_device+C_directory
$	ASS 'C_dir LSL$MAK
$	OPTION=="@LSL$MAK:MAKE OPT"
$	MAKU  =="@LSL$MAK:MAKE U"
$	MAKC  =="@LSL$MAK:MAKE C"
$	MAKALL=="@LSL$MAK:MAKE ALL"
$	MAKCLO=="@LSL$MAK:MAKE CLO"
$	MAKEND=="@LSL$MAK:MAKE END"
$	TRUTH =="@LSL$MAK:MAKE TRUTH"
$	BUILD =="@LSL$MAK:MAKE BUILD"
$	MAKASK=="@LSL$MAK:MAKE ASK"
$	MAKINQ=="@LSL$MAK:MAKE INQ"
$	MAKFIL=="@LSL$MAK:MAKE FILE"
$	MAKSET=="@LSL$MAK:MAKE SET"
$	MAKLIS=="@LSL$MAK:MAKE LIS"
$	MAKDEBUG=="@LSL$MAK:MAKE DEB"
$	MAKI4=="@LSL$MAK:MAKE I4"
$	MAKCSW=="@LSL$MAK:MAKE CSW"
$	MAKFSW=="@LSL$MAK:MAKE FSW"
$	MAKFKP=="@LSL$MAK:MAKE FKP"
$	MAKADCSW=="@LSL$MAK:MAKE ADCSW"
$	MAKLNKSW=="@LSL$MAK:MAKE LNKSW"
$	MAKNOI4=="@LSL$MAK:MAKE NOI4"
$	MAKLIB=="@LSL$MAK:MAKE LIB"
$	WO=="WRITE SYS$OUTPUT"
$	WT=="WRITE TRUTH"
$	WC=="WRITE DATA"
$	MAK$FILOPN==0
$	MAK$TROPEN==0
$	MAK$ALL==0
$	MAK$LIS=="/NOLIST"
$	MAK$DEB==""
$	MAK$MDEB==""
$	MAK$NOI4=="/NOI4"
$	MAK$CSW==""
$	MAK$FSW==""
$	MAK$LNKSW==""
$	MAK$FKP==0
$	MAK$ADCC==""
$	MAK$PVVN==1
$	M1==P2
$	M2==P3
$	M3==P4
$	M4==P5
$	M5==P6
$	M6==P7
$	M7==P8
$	IF "''TRFILE'".NES."" THEN ASSIGN 'TRFILE' TR		!TRU
$	EXIT
$!
$! Close files
$!
$MAK_CLO: IF MAK$TROPEN THEN CLOSE TRUTH
$	CLOSE DATA
$	GOTO MAK_EX
$!
$! Batch, run interactively or stop
$!
$MAK_END: INQUIRE/NOP BATCHIT "Submit for batch ? "
$	IF .NOT. BATCHIT THEN GOTO MAK_INT
$!	WC "$	SEND ''F$PROCESS()' BATCH JOB ENDED"
$	IF MAK$TROPEN THEN CLOSE TRUTH
$	CLOSE DATA
$	BAT 'MAK$FIL	! use LSL batch command to get charging and cost
$	SHOW QUEUE/ALL SYS$BATCH
$	GOTO MAK_EX
$MAK_INT: IF MAK$TROPEN THEN CLOSE TRUTH
$	CLOSE DATA
$	INQUIRE/NOP INTER "Interactive ? "
$	IF .NOT. INTER THEN GOTO MAK_EX
$	MAK$V = 'F$VERIFY()'
$	ON CONTROL THEN GOTO MAK_RESET
$	SET VERIFY
$	@'MAK$FIL'
$MAK_RESET: MAK$V = 'F$VERIFY(MAK$V) 
$MAK_EX: TRFILE==""			! define those that
$	NO==0				! just might not have been
$	YES==0				! previously defined
$	DSG="DELETE/SYMBOL/GLOBAL"
$	DSG OPTION
$	DSG MAKU
$	DSG MAKC
$	DSG MAKALL
$	DSG MAKCLO
$	DSG MAKEND
$	DSG TRUTH
$	DSG BUILD
$	DSG MAKASK
$	DSG MAKINQ
$	DSG MAKFIL
$	DSG MAKSET
$	DSG MAKLIS
$	DSG MAKDEBUG
$	DSG MAKI4
$	DSG MAKCSW
$	DSG MAKFSW
$	DSG MAKLNKSW
$	DSG MAKFKP
$	DSG MAKADCSW
$	DSG MAKNOI4
$	DSG MAKLIB
$	DSG WO
$	DSG WT	
$	DSG WC
$	DSG MAK$FILOPN
$	DSG MAK$TROPEN
$	DSG MAK$ALL
$	DSG MAK$LIS
$	DSG MAK$DEB
$	DSG MAK$MDEB
$	DSG MAK$NOI4
$	DSG MAK$CSW
$	DSG MAK$FSW
$	DSG MAK$LNKSW
$	DSG MAK$FKP
$	DSG MAK$ADCC
$	DSG MAK$PVVN
$	DSG M1
$	DSG M2
$	DSG M3
$	DSG M4
$	DSG M5
$	DSG M6
$	DSG M7
$	DSG TRFILE
$	DSG MAK$FIL
$	DSG NO
$	DSG YES
$	IF "''F$TRNLNM("TR")'" .NES. "" THEN DEASSIGN TR !TRU
$	DEASSIGN LSL$MAK				 ! this directory
$	EXIT
$!
$! Open data file and mark open
$MAK_FILE: FIL$TYP:=.COM
$	MAK$FIL:=='P2'
$	IF 'F$LOC(":",P2)' .EQ. 'F$LEN(P2)' THEN -
		MAK$FIL:=='F$LOG("EXE")''MAK$FIL'
$	IF 'F$LOC(".",P2)' .EQ. 'F$LEN(P2)' THEN -
		MAK$FIL:=='MAK$FIL''FIL$TYP'
$	OPEN/WRITE DATA 'MAK$FIL
$	MAK$FILOPN == 1
$!!!!	WC "$	CHARGE ",SYS$ACCOUNT
$	IF "''TRFILE'".NES."" THEN WC "$	ASSIGN ",TRFILE," TR"
$	EXIT
$! Open truth file and remember its name
$!
$MAK_TRUTH: FIL$TYP=".MAR"
$	TRFILE==P2
$	IF F$LOC(".",P2).EQ.F$LEN(P2) THEN TRFILE==TRFILE+FIL$TYP
$	IF F$LOC(":",P2).EQ.F$LEN(P2) THEN TRFILE=="MAR:"+TRFILE
$	OPEN/WRITE TRUTH 'TRFILE'
$	MAK$TROPEN == 1
$	EXIT
$!
$! Ask question and write answer to truth file
$!
$MAK_OPT: INQUIRE/NOP 'P2' "''P3' ? "
$	IF      'P2' THEN WT "'P2' = 1	; ''P3'"
$	IF	'P2' THEN 'P2' == 1
$	IF .NOT. 'P2' THEN WT "''P2' = 0	; ''P3'"
$	IF .NOT. 'P2' THEN 'P2' == 0
$	EXIT
$!
$! Set globals (as currently set) in the data file
$!
$MAK_SET: IF 'P2' THEN WC "$	''P2' == 1"
$	IF .NOT. 'P2' THEN WC "$	''P2' == 0"
$	EXIT
$!
$MAK_LINK: IF F$LOCATE(":",P4).EQ.F$LENGTH(P4) THEN -
	WC "$	ADC ",P3,".OPT=",MAK$TR,"EXE:",P4,".LNK"
$	IF F$LOCATE(":",P4).NE.F$LENGTH(P4) THEN -
	WC "$	ADC ",P3,".OPT=",MAK$TR,P4,".LNK"
$	WC "$	PURGE ",P3,".OPT"
$	EXIT
$!
$MAK_BUILD: WC "$!  ++++++++++++++++++++  Linking  ++++++++++++++++++++"
$	LNKSW:=/MAP'MAK$LNKSW'
$	INQUIRE/NOP CRF "Cross Reference Map ? "
$	IF CRF THEN LNKSW:='LNKSW'/CROSS_REF
$	INQUIRE/NOP DBSW "Link with Debug ? "
$	IF DBSW THEN LNKSW:=/DEBUG'LNKSW'
$	WC "$	LINK''LNKSW'/EXE=EXE:''P2'  ''P3'/OPTIONS"
$	WC "$	PURGE EXE:''P2'.EXE"
$	WC "$	PURGE ''P3'.MAP"
$	EXIT
$!
$MAK_ALL: IF P2 .EQS. "" THEN P2:=1
$	MAK$ALL == 'P2
$	EXIT
$!
$MAK_LIS: MAK$LIS:=="/NOLIST"
$	IF P2 .EQS. "" .OR. P2 .EQS. "1" THEN MAK$LIS:=="/LIST"
$	EXIT
$!
$MAK_LIB:
$	WC "$	LIBR/REPLACE ''P2'  ''P3'"
$	WC "$	DELETE ''P3'.OBJ;*"
$	EXIT
$!
$MAK_DEB: MAK$DEB:==
$	MAK$MDEB:==
$	IF P2 .NES. "" .AND. P2 .NES. "1" THEN EXIT
$	MAK$DEB:=="/DEBUG"
$	MAK$MDEB:=="/ENA=DBG"
$	EXIT
$!
$MAK_I4: MAK$NOI4:==
$	EXIT
$!
$MAK_NOI4: MAK$NOI4:=="/NOI4"
$	EXIT
$!
$MAK_CSW: MAK$CSW:=='P2'
$	EXIT
$!
$MAK_FSW: MAK$FSW:=='P2'
$	EXIT
$!
$MAK_LNKSW: MAK$LNKSW:=='P2'
$	EXIT
$!
$MAK_FKP: MAK$FKP==1
$	MAK$ADCC:=="/CO"
$	EXIT
$!
$MAK_ADCSW: MAK$ADCC:=='P2'
$	EXIT
