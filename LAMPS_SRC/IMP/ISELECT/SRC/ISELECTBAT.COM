$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-05-08 12:25:24.000000000 +0100
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
$	ON CONTROL_Y THEN GOTO ISELECTEX
$	IF "''F$LOGICAL("LSL$ISELECT_BUILDING")'" -
		 .NES. "IN_PROGRESS" THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$!
$A0:	DEFINE/GROUP LSL$ISELECT_BUILDING "IN_PROGRESS"
$	ASSIGN LSL$SOURCE_ROOT:[IMP.ISELECT] LSL$CMNISELECT
$	SD:=$LSL$SYS:SD
$	SET NOON
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		SET VERIFY
$		NEWMSG iselect/number = 1206
$		@iselect.temp_com
$ 		ADC ISELECT.TMP=ISELECT_CLD.CLD
$ 		SET COMMAND/OBJECT=ISELECT_CLD ISELECT.TMP
$ 		OK=$STATUS
$ 		IF OK THEN PVV ISELECT_CLD
$ 		OK=$STATUS
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		ADC CHECK=CHECK
$ 		FORT CHECK
$ 		OK=$STATUS
$ 		IF OK THEN PVV CHECK
$ 		PURGE/NOLOG CHECK.OBJ
$ 		DELETE/NOLOG CHECK.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC CLOSEF=CLOSEF
$ 		FORT CLOSEF
$ 		OK=$STATUS
$ 		IF OK THEN PVV CLOSEF
$ 		PURGE/NOLOG CLOSEF.OBJ
$ 		DELETE/NOLOG CLOSEF.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC GETF=GETF
$ 		FORT GETF
$ 		OK=$STATUS
$ 		IF OK THEN PVV GETF
$ 		PURGE/NOLOG GETF.OBJ
$ 		DELETE/NOLOG GETF.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC ISELECT=ISELECT
$ 		FORT ISELECT
$ 		OK=$STATUS
$ 		IF OK THEN PVV ISELECT
$ 		PURGE/NOLOG ISELECT.OBJ
$ 		DELETE/NOLOG ISELECT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC MY_REAL=MY_REAL
$ 		FORT MY_REAL
$ 		OK=$STATUS
$ 		IF OK THEN PVV MY_REAL
$ 		PURGE/NOLOG MY_REAL.OBJ
$ 		DELETE/NOLOG MY_REAL.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC OBEY'KPCOM'=OBEY
$ 		FORT OBEY
$ 		OK=$STATUS
$ 		IF OK THEN PVV OBEY
$ 		PURGE/NOLOG OBEY.OBJ
$ 		DELETE/NOLOG OBEY.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC RANGE=RANGE
$ 		FORT RANGE
$ 		OK=$STATUS
$ 		IF OK THEN PVV RANGE
$ 		PURGE/NOLOG RANGE.OBJ
$ 		DELETE/NOLOG RANGE.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC SELECTF=SELECTF
$ 		FORT SELECTF
$ 		OK=$STATUS
$ 		IF OK THEN PVV SELECTF
$ 		PURGE/NOLOG SELECTF.OBJ
$ 		DELETE/NOLOG SELECTF.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC COPY_FT=COPY_FT
$ 		FORT COPY_FT
$ 		OK=$STATUS
$ 		IF OK THEN PVV COPY_FT
$ 		PURGE/NOLOG COPY_FT.OBJ
$ 		DELETE/NOLOG COPY_FT.FOR;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		LINK/MAP/EXE=ISELECT ISELECT, -
		ISELECT_CLD, CHECK, CLOSEF, -
		GETF, MY_REAL, OBEY, RANGE, -
		SELECTF, COPY_FT, -
		ISELECT.PROMSG_OBJ, -
		lsl$library:iffSHR/OPT, -
		LSL$LIBRARY:LSLSHR/OPT, -
		LSL$LIBRARY:LSLLIB/include=DCL_ERRET, -
		SYS$INPUT:/opt
		psect_attr=LSL_REPORT,noshr
$ 		ISELECTEX:
$ 		DEASS/GROUP LSL$ISELECT_BUILDING
$ 		SET NOVER
