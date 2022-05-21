$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1986-01-06 18:02:10.000000000 +0000
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
$	DEBF=""
$	DEBL=""
$	IF P1 .NES. "" THEN DEBF="/DEBUG/NOOPT"
$	IF P1 .NES. "" THEN DEBL="/DEBUG"
$	SET VER
$	ADC LAPATCH/CO=LAPATCH
$	FORTRAN'DEBF' LAPATCH
$	PVV LAPATCH
$	DELETE ADC.IDE;*
$	LINK'DEBL' LAPATCH,LSL$LIBRARY:IFFLIB/LIB,CMDLIB/LIB,VIOLIB/LIB
$	DELETE LAPATCH.OBJ;*
$	PURGE LAPATCH.EXE
$	SET NOVER
$	IF P1 .EQS. "" THEN DELETE LAPATCH.FOR;*
