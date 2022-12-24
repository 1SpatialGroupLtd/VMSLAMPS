$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-11-07 16:32:40.000000000 +0000
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
$! Produces a numerically ordered symbol table from a PAN listing file
$!
$	IF P1 .NES. "" THEN GOTO SPLIT
$	INQUIRE/NOP P1 "File name ? "
$	IF P1 .EQS. "" THEN EXIT
$SPLIT:
$	FILE:='P1'
$	LST:="LST"
$	FLEN='F$LOCATE(".",P1)
$	IF FLEN .EQ. 'F$LEN(P1)' THEN GOTO NODOT
$	FILE:='F$EXTRACT(0,FLEN,P1)
$	FLEN=FLEN+1
$	LST:='F$EXTRACT(FLEN,3,P1)
$NODOT:
$	ASS/USER 'FILE'.'LST' NOSIN
$	ASS/USER 'FILE'.TMP   NOSOUT
$	IF LST .EQS. "LIS" THEN RUN LSL$EXE:DNOS
$	IF LST .NES. "LIS" THEN RUN LSL$EXE:NOS
$!
$! Sort the output
$	ASS/USER NL: SYS$OUTPUT:
$	IF LST .EQS. "LIS" THEN -
	SORT/KEY=(POS:10,SIZE:6)/KEY=(POS:1,SIZE:6) 'FILE'.TMP 'FILE'.TMP
$	ASS/USER NL: SYS$OUTPUT:
$	IF LST .NES. "LIS" THEN -
	SORT/KEY=(POS:9,SIZE:6)/KEY=(POS:1,SIZE:6) 'FILE'.TMP 'FILE'.TMP
$! Now multicolumn the output
$	CFILE:="ML.TMP"
$	OPEN/WRITE OUTXXX 'CFILE'
$	WO:=WRITE OUTXXX
$	WO "NUMERICALLY ORDERED SYMBOL TABLE                        ''FILE'"
$	WO "  "
$	CLOSE OUTXXX
$	ASS/USER 'CFILE' FOR003
$	ASS/USER 'FILE'.NST FOR002
$	ASS/USER 'FILE'.TMP FOR001
$	ON ERROR THEN CONTINUE
$	R LSL$EXE:ML
$	DELETE 'CFILE';*
$	DELETE 'FILE'.TMP;*
$!
