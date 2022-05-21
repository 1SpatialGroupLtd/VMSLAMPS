$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1986-08-15 14:18:46.000000000 +0100
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
$	V='F$VERIFY(0)'
$	SET ON
$	ON ERROR THEN GOTO EXIT
$	ON CONTROL THEN GOTO EXIT
$	P2=F$PARSE(P1,,,"TYPE") - "."
$	P1=P1 - ".''P2'"
$ AGAIN:
$	IF P2 .EQS. "FLF" .OR. P2 .EQS. "LAJ" .OR. P2 .EQS. "ELA" -
	THEN GOTO GOTTYP
$	INQUIRE/NOP P2 "FLF, LAJ or ELA ? "
$	GOTO AGAIN
$!!!	IF P2 .EQS. "" THEN P2="LAJ"
$!!!	IF P2 .EQS. "LAJ" THEN GOTO GOTTYP
$!!!	WRITE SYS$OUTPUT "File must be of type .LAJ"
$!!!	GOTO EXIT
$ GOTTYP:
$	P2=F$PARSE(P1,"*.''P2';*")
$	IF P2 .NES. "" THEN GOTO OK
$	P2=F$SEARCH(P1)
$	GOTO EXIT				! report error & exit
$ OK:	DIR=F$PARSE(P2,,,"DEVICE") + F$PARSE(P2,,,"DIRECTORY")
$	ASSIGN 'DIR' LSL$LK
$	LAPATCH="$LSL$EXE:LAPATCH"
$	OLDFIL=""
$ !
$ REC:	ON ERROR THEN GOTO CHECK
$ LOOP:
$	FILNAM=F$SEARCH(P2)
$	IF FILNAM .EQS. "" THEN GOTO EXIT
$	IF FILNAM .EQS. OLDFIL THEN GOTO EXIT
$	OLDFIL=FILNAM
$	FILNAM="LSL$LK:" + FILNAM - DIR
$!!!	WRITE SYS$OUTPUT "Updating ''FILNAM'"
$	ASSIGN/USER TT DBG$INPUT
$	ASSIGN/USER TT DBG$OUTPUT
$	LAPATCH 'FILNAM'
$	GOTO LOOP
$ !
$ CHECK:IF $STATUS .EQS. "%X00000024" THEN GOTO	REC   ! priv violation ?
$ EXIT:	IF V THEN SET VERIFY
