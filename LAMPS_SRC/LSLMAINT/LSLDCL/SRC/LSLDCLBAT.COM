$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1986-07-10 17:34:06.000000000 +0100
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
$	ON CONTROL_Y THEN GOTO DCLEX
$	IF "''F$LOGICAL("LSL$DCL_BUILDING")'" -
		 .NES. "IN_PROGRESS" THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$!
$A0:	DEFINE/GROUP LSL$DCL_BUILDING "IN_PROGRESS"
$	SD:=$LSL$SYS:SD
$	SET NOON
$ 	SET NOVERIFY
$	ERROR="
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ ADC DCL_FILE/CO = DCL_FILE		
$ FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW) DCL_FILE
$ OK=$STATUS
$ IF .NOT. OK THEN ERROR=ERROR+" DCL_FILE"
$ IF OK THEN PVV DCL_FILE
$ PURGE/NOLOG DCL_FILE.OBJ
$ DELETE ADC.IDE;*
$ SET NOVER
$ IF ERROR.NES."" THEN WRITE SYS$OUTPUT "Errors in"+ERROR
$ DCLEX:
$	DEASS/GROUP LSL$DCL_BUILDING
