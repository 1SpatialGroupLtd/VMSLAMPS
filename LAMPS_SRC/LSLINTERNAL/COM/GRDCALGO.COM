$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1989-02-03 15:34:02.000000000 +0000
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
$	IF P1 .EQS. "" THEN -
   INQUIRE P1 "Serial line for table [RETURN if connected to a MUART LITES] ? "
$	IF P1 .EQS "" THEN GOTO A
$	COL:=""
$	IF 'F$LOCATE(":",P1)' .EQ. 'F$LEN(P1)' THEN COL:=":"
$	ALL 'P1''COL'
$	SET TERM/NOEIGHT 'P1''COL'
$	ASS/USER 'P1''COL' LD0
$	MCR LSL$EXE:FLUSH
$	ASS/USER 'P1''COL' GRIDIN
$ A:
$	INQUIRE MACH "Table number"
$	INQUIRE TTYPE "Table type (ALT(def), KON, ...)"
$	IF TTYPE.EQS."" THEN TTYPE="ALT"
$	ASS/USER GRD'MACH'.RES GRDRES
$	ASS/USER GRD'MACH'.DAT GRDDAT
$	ASS/USER LSL$EXE:RDC'TTYPE'.EXE LSL$RDCTAB
$	RUN/NODEBUG LSL$EXE:GRDCAL
