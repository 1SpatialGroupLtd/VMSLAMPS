$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-07-05 11:13:50.000000000 +0100
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
$	ON CONTROL_Y THEN GOTO IMENDEX
$	IF "''F$LOGICAL("LSL$IMEND_BUILDING")'" -
		 .NES. "IN_PROGRESS" THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$!
$A0:	DEFINE/GROUP LSL$IMEND_BUILDING "IN_PROGRESS"
$	SD:=$LSL$SYS:SD
$	SET NOON
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		SET VERIFY
$ 		ASSIGN LSL$SOURCE_ROOT:[IMP.IMEND] LSL$CMNIMEND
$ 		ADC IMEND=IMEND
$ 		FORT IMEND
$ 		OK=$STATUS
$ 		IF OK THEN PVV IMEND
$ 		PURGE/NOLOG IMEND.OBJ
$ 		PURGE/NOLOG IMEND.FOR
$ 		DELETE ADC.IDE;*
$ 		LINK/MAP/EXE=IMEND IMEND,IMEND_CLD,IMEND.PROMSG_OBJ, -
		LSL$LIBRARY:IFFSHR/OPT,LSL$LIBRARY:LSLSHR/OPT
$ 		IMENDEX:
$ 		DEASS/GROUP LSL$IMEND_BUILDING
$ 		SET NOVER
