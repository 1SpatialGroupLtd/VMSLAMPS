$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-03-04 12:24:12.000000000 +0000
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
$ 	SET NOVERIFY
$	ON CONTROL_Y THEN GOTO IREPORTEX
$	IF "''F$LOGICAL("LSL$IREPORT_BUILDING")'" -
		 .NES. "IN_PROGRESS" THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$!
$ A0:	DEFINE/GROUP LSL$IREPORT_BUILDING "IN_PROGRESS"
$	ASSIGN LSL$DISK:[IFF.IMP.IREPORT] LSL$CMNIREPORT
$	SD:=$LSL$SYS:SD
$	SET NOON
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		SET VERIFY
$ 	NEWMSG IREPORT /NUMBER=1215/PREFIX=IREPORT__
$	@IREPORT.TEMP_COM
$ 		ADC IREPORT.TMP=IREPORT.CLD
$ 		SET COMMAND/OBJECT=IREPORT_CLD IREPORT.TMP
$ 		OK=$STATUS
$ 		IF OK THEN PVV IREPORT_CLD
$ 		IF OK THEN DELETE IREPORT.TMP;*
$ 		IF OK THEN PURGE/NOLOG IREPORT_CLD.OBJ
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		ADC AC_REPORT=AC_REPORT
$ 		FORT AC_REPORT
$ 		OK=$STATUS
$ 		IF OK THEN PVV AC_REPORT
$ 		PURGE/NOLOG AC_REPORT.OBJ
$ 		DELETE/NOLOG AC_REPORT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC CB_REPORT=CB_REPORT
$ 		FORT CB_REPORT
$ 		OK=$STATUS
$ 		IF OK THEN PVV CB_REPORT
$ 		PURGE/NOLOG CB_REPORT.OBJ
$ 		DELETE/NOLOG CB_REPORT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC CC_REPORT=CC_REPORT
$ 		FORT CC_REPORT
$ 		OK=$STATUS
$ 		IF OK THEN PVV CC_REPORT
$ 		PURGE/NOLOG CC_REPORT.OBJ
$ 		DELETE/NOLOG CC_REPORT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC CP_REPORT=CP_REPORT
$ 		FORT CP_REPORT
$ 		OK=$STATUS
$ 		IF OK THEN PVV CP_REPORT
$ 		PURGE/NOLOG CP_REPORT.OBJ
$ 		DELETE/NOLOG CP_REPORT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC EF_REPORT=EF_REPORT
$ 		FORT EF_REPORT
$ 		OK=$STATUS
$ 		IF OK THEN PVV EF_REPORT
$ 		PURGE/NOLOG EF_REPORT.OBJ
$ 		DELETE/NOLOG EF_REPORT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC EO_REPORT=EO_REPORT
$ 		FORT EO_REPORT
$ 		OK=$STATUS
$ 		IF OK THEN PVV EO_REPORT
$ 		PURGE/NOLOG EO_REPORT.OBJ
$ 		DELETE/NOLOG EO_REPORT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC FC_REPORT=FC_REPORT
$ 		FORT FC_REPORT
$ 		OK=$STATUS
$ 		IF OK THEN PVV FC_REPORT
$ 		PURGE/NOLOG FC_REPORT.OBJ
$ 		DELETE/NOLOG FC_REPORT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC GET_COM_LIN=GET_COM_LIN
$ 		FORT GET_COM_LIN
$ 		OK=$STATUS
$ 		IF OK THEN PVV GET_COM_LIN
$ 		PURGE/NOLOG GET_COM_LIN.OBJ
$ 		DELETE/NOLOG GET_COM_LIN.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC EJ_REPORT=EJ_REPORT
$ 		FORT EJ_REPORT
$ 		OK=$STATUS
$ 		IF OK THEN PVV EJ_REPORT
$ 		PURGE/NOLOG EJ_REPORT.OBJ
$ 		DELETE/NOLOG EJ_REPORT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC IREPORT=IREPORT
$ 		FORT IREPORT
$ 		OK=$STATUS
$ 		IF OK THEN PVV IREPORT
$ 		PURGE/NOLOG IREPORT.OBJ
$ 		DELETE/NOLOG IREPORT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC LITES2M=LITES2M
$ 		FORT LITES2M
$ 		OK=$STATUS
$ 		IF OK THEN PVV LITES2M
$ 		PURGE/NOLOG LITES2M.OBJ
$ 		DELETE/NOLOG LITES2M.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC NF_REPORT=NF_REPORT
$ 		FORT NF_REPORT
$ 		OK=$STATUS
$ 		IF OK THEN PVV NF_REPORT
$ 		PURGE/NOLOG NF_REPORT.OBJ
$ 		DELETE/NOLOG NF_REPORT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC NS_REPORT=NS_REPORT
$ 		FORT NS_REPORT
$ 		OK=$STATUS
$ 		IF OK THEN PVV NS_REPORT
$ 		PURGE/NOLOG NS_REPORT.OBJ
$ 		DELETE/NOLOG NS_REPORT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC NO_REPORT=NO_REPORT
$ 		FORT NO_REPORT
$ 		OK=$STATUS
$ 		IF OK THEN PVV NO_REPORT
$ 		PURGE/NOLOG NO_REPORT.OBJ
$ 		DELETE/NOLOG NO_REPORT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC FILEINI=FILEINI
$ 		FORT FILEINI
$ 		OK=$STATUS
$ 		IF OK THEN PVV FILEINI
$ 		PURGE/NOLOG FILEINI.OBJ
$ 		DELETE/NOLOG FILEINI.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC WRTCMD=WRTCMD
$ 		FORT WRTCMD
$ 		OK=$STATUS
$ 		IF OK THEN PVV WRTCMD
$ 		PURGE/NOLOG WRTCMD.OBJ
$ 		DELETE/NOLOG WRTCMD.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC RO_REPORT=RO_REPORT
$ 		FORT RO_REPORT
$ 		OK=$STATUS
$ 		IF OK THEN PVV RO_REPORT
$ 		PURGE/NOLOG RO_REPORT.OBJ
$ 		DELETE/NOLOG RO_REPORT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC ST_REPORT=ST_REPORT
$ 		FORT ST_REPORT
$ 		OK=$STATUS	
$ 		IF OK THEN PVV ST_REPORT
$ 		PURGE/NOLOG ST_REPORT.OBJ
$ 		DELETE/NOLOG ST_REPORT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		ADC TC_REPORT=TC_REPORT
$ 		FORT TC_REPORT
$ 		OK=$STATUS
$ 		IF OK THEN PVV TC_REPORT
$ 		PURGE/NOLOG TC_REPORT.OBJ
$ 		DELETE/NOLOG TC_REPORT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC TH_REPORT=TH_REPORT
$ 		FORT TH_REPORT
$ 		OK=$STATUS
$ 		IF OK THEN PVV TH_REPORT
$ 		PURGE/NOLOG TH_REPORT.OBJ
$ 		DELETE/NOLOG TH_REPORT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC TS_REPORT=TS_REPORT
$ 		FORT TS_REPORT
$ 		OK=$STATUS
$ 		IF OK THEN PVV TS_REPORT
$ 		PURGE/NOLOG TS_REPORT.OBJ
$ 		DELETE/NOLOG TS_REPORT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC TX_REPORT=TX_REPORT
$ 		FORT TX_REPORT
$ 		OK=$STATUS
$ 		IF OK THEN PVV TX_REPORT
$ 		PURGE/NOLOG TX_REPORT.OBJ
$ 		DELETE/NOLOG TX_REPORT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC ZS_REPORT=ZS_REPORT
$ 		FORT ZS_REPORT
$ 		OK=$STATUS
$ 		IF OK THEN PVV ZS_REPORT
$ 		PURGE/NOLOG ZS_REPORT.OBJ
$ 		DELETE/NOLOG ZS_REPORT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$	LINK/MAP/CROSS/EXE=IREPORT -
	IREPORT,IREPORT_CLD, -
	AC_REPORT,CC_REPORT,CP_REPORT,EF_REPORT,-
	EO_REPORT,FC_REPORT,GET_COM_LIN,EJ_REPORT,LITES2M,-
	NF_REPORT,NS_REPORT,NO_REPORT,FILEINI,-
	WRTCMD,RO_REPORT,ST_REPORT,CB_REPORT,-
	TC_REPORT,TH_REPORT,TS_REPORT,TX_REPORT,-
	ZS_REPORT, IREPORT.PROMSG_OBJ,-
    LSL$LIBRARY:IFFSHR.OPT/OPT,-
    LSL$LIBRARY:LSLSHR.OPT/OPT,-
	LSL$LIBRARY:LSLFRTLIB/LIB
$ 		IREPORTEX:
$ 		DEASS/GROUP LSL$IREPORT_BUILDING
$ 		SET NOVER
