$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-06-16 11:13:10.000000000 +0100
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
$	ON CONTROL_Y THEN GOTO ISORTEX
$	IF "''F$LOGICAL("LSL$ISORT_BUILDING")'" -
		 .NES. "IN_PROGRESS" THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$!
$A0:	DEFINE/GROUP LSL$ISORT_BUILDING "IN_PROGRESS"
$	ASSIGN LSL$SOURCE_ROOT:[IMP.ISORT] LSL$CMNISORT
$	SD:=$LSL$SYS:SD
$	SET NOON
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		SET VERIFY
$ 		ADC ISORT.TMP=ISORT_CLD.CLD
$ 		SET COMMAND/OBJECT=ISORT_CLD ISORT.TMP
$ 		OK=$STATUS
$ 		IF OK THEN PVV ISORT_CLD
$ 		DELETE ISORT.TMP;*
$		PURGE/NOLOG ISORT_CLD.OBJ
$ 		OK=$STATUS
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC CLOSEF=CLOSEF
$ 		FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW) CLOSEF
$ 		OK=$STATUS
$ 		IF OK THEN PVV CLOSEF
$ 		PURGE/NOLOG CLOSEF.OBJ
$ 		PURGE/NOLOG CLOSEF.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC GETF=GETF
$ 		FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW) GETF
$ 		OK=$STATUS
$ 		IF OK THEN PVV GETF
$ 		PURGE/NOLOG GETF.OBJ
$ 		PURGE/NOLOG GETF.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC ISORT=ISORT
$ 		FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW) ISORT
$ 		OK=$STATUS
$ 		IF OK THEN PVV ISORT
$ 		PURGE/NOLOG ISORT.OBJ
$ 		PURGE/NOLOG ISORT.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC OBEY'KPCOM'=OBEY
$ 		FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW) OBEY
$ 		OK=$STATUS
$ 		IF OK THEN PVV OBEY
$ 		PURGE/NOLOG OBEY.OBJ
$ 		PURGE/NOLOG OBEY.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC SORTF=SORTF
$ 		FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW) SORTF
$ 		OK=$STATUS
$ 		IF OK THEN PVV SORTF
$ 		PURGE/NOLOG SORTF.OBJ
$ 		PURGE/NOLOG SORTF.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC SRTINFO=SRTINFO
$ 		FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW) SRTINFO
$ 		OK=$STATUS
$ 		IF OK THEN PVV SRTINFO
$ 		PURGE/NOLOG SRTINFO.OBJ
$ 		PURGE/NOLOG SRTINFO.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		LINK/MAP/DEBUG/EXE=ISORT ISORT, -
		ISORT_CLD, CLOSEF, -
		GETF, OBEY, SORTF, SRTINFO, -
		ISORT.PROMSG_OBJ, -
		lsl$library:iffshr/opt,lslshr/opt
$ 		ISORTEX:
$ 		DEASS/GROUP LSL$ISORT_BUILDING
$ 		SET NOVER
