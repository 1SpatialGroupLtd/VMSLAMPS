$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-06-03 15:22:14.000000000 +0100
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
$	ON CONTROL_Y THEN GOTO I2MOSSEX
$	IF "''F$LOGICAL("LSL$I2MOSS_BUILDING")'" -
		 .NES. "IN_PROGRESS" THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$!
$A0:	DEFINE/GROUP LSL$I2MOSS_BUILDING "IN_PROGRESS"
$	ASSIGN LSL$SOURCE_ROOT:[CONVERT.I2MOSS] LSL$CMNI2MOSS
$	SET NOON
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		SET VERIFY
$newmsg i2moss/number=1606
$@i2moss.temp_com
$ 		ADC I2MOSS.TMP=I2MOSS.CLD
$ 		SET COMMAND/OBJECT=I2MOSS_CLD I2MOSS.TMP
$ 		OK=$STATUS
$ 		IF OK THEN PVV I2MOSS_CLD
$ 		IF OK THEN DELETE I2MOSS.TMP;*
$ 		IF OK THEN PURGE/NOLOG I2MOSS_CLD.OBJ
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		ADC CLSFIL/CO=CLSFIL
$ 		FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW)/LIST CLSFIL
$ 		OK=$STATUS
$ 		IF OK THEN PVV CLSFIL
$ 		PURGE/NOLOG CLSFIL.OBJ
$ 		PURGE/NOLOG CLSFIL.LIS
$ 		DELETE ADC.IDE;*
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		ADC CMDLIN/CO=CMDLIN
$ 		FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW)/LIST CMDLIN
$ 		OK=$STATUS
$ 		IF OK THEN PVV CMDLIN
$ 		PURGE/NOLOG CMDLIN.OBJ
$ 		PURGE/NOLOG CMDLIN.LIS
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC GETF/CO=GETF
$ 		FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW)/LIST GETF
$ 		OK=$STATUS
$ 		IF OK THEN PVV GETF
$ 		PURGE/NOLOG GETF.OBJ
$ 		PURGE/NOLOG GETF.LIS
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC GET_CROSS/CO=GET_CROSS
$ 		FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW)/LIST GET_CROSS
$ 		OK=$STATUS
$ 		IF OK THEN PVV GET_CROSS
$ 		PURGE/NOLOG GET_CROSS.OBJ
$ 		PURGE/NOLOG GET_CROSS.LIS
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC I2MOSS/CO=I2MOSS
$ 		FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW)/LIST I2MOSS
$ 		OK=$STATUS
$ 		IF OK THEN PVV I2MOSS
$ 		PURGE/NOLOG I2MOSS.OBJ
$ 		PURGE/NOLOG I2MOSS.LIS
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC IFFBDY/CO=IFFBDY
$ 		FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW)/LIST IFFBDY
$ 		OK=$STATUS
$ 		IF OK THEN PVV IFFBDY
$ 		PURGE/NOLOG IFFBDY.OBJ
$ 		PURGE/NOLOG IFFBDY.LIS
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC MOSCOD/CO=MOSCOD
$ 		FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW)/LIST MOSCOD
$ 		OK=$STATUS
$ 		IF OK THEN PVV MOSCOD
$ 		PURGE/NOLOG MOSCOD.OBJ
$ 		PURGE/NOLOG MOSCOD.LIS
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC OUTREC/CO=OUTREC
$ 		FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW)/LIST OUTREC
$ 		OK=$STATUS
$ 		IF OK THEN PVV OUTREC
$ 		PURGE/NOLOG OUTREC.OBJ
$ 		PURGE/NOLOG OUTREC.LIS
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		LINK/MAP/DEBUG/EXE=I2MOSS I2MOSS,-
		I2MOSS_CLD,CLSFIL,GETF,OUTREC, -
		IFFBDY,CMDLIN,-
		MOSCOD,GET_CROSS, -
		I2MOSS.PROMSG_OBJ, -
		LSL$LIBRARY:IFFSHR/OPT,LSLSHR/OPT
$ MAPID I2MOSS
$ PURGE/NOLOG I2MOSS.EXE,I2MOSS.MAP,I2MOSS.MAPID
$ 		I2MOSSEX:
$ 		DEASS/GROUP LSL$I2MOSS_BUILDING
$ 		SET NOVER
