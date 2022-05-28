$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-11-07 17:24:52.000000000 +0000
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
$	FILE:='P1'
$!NB Egs uses .LST as the default type of the listing file in agreement
$!with the old assembler, the new assembler uses .LIS
$	LST:="LST"
$	FLEN='F$LOCATE(".",P1)
$	IF FLEN .EQ. 'F$LEN(P1)' THEN GOTO NODOT
$	FILE:='F$EXTRACT(0,FLEN,P1)'
$	FLEN=FLEN+1
$	LST:='F$EXTRACT(FLEN,3,P1)'
$ NODOT:
$	ASS/USER 'FILE'.DEF EGSOUT
$	ASS/USER 'FILE'.'LST' EGSIN
$	IF LST .EQS. "LIS" THEN RUN LSL$EXE:DEGS
$	IF LST .NES. "LIS" THEN RUN LSL$EXE:EGS
