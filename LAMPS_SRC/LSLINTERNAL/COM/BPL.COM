$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-11-07 14:31:16.000000000 +0000
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
$	BPL="$LSL$EXE:BPL"$	ACG="$LSL$EXE:ACG"$	IF P1.EQS."" THEN GOTO END$	HERE:='F$LOG("SYS$DISK")''F$DIR()$	IF P2.NES."" THEN GOTO NO_COMP$	BPL 'P1$	ACG 'P1$	DELETE 'P1'.OCD;*$	MCR MAC 'P1='P1$	DELETE 'P1'.MAC;*$NO_COMP:$	OPEN/ERR=NO_TKB TKBFILE 'P1.TKB$	TKBEXISTS=1$	CLOSE TKBFILE$	GOTO TASK_BUILD$NO_TKB:$	LEXTT:='EXTTSK$	IF LEXTT.EQS."" THEN LEXTT:=11000$	OPEN/WRITE TKBFILE 'P1.TKB$	WRITE TKBFILE "''P1'.EXE,''P1'/-SP=LSL$LIBRARY:BCPLIB,''HERE'''P1'"$	IF P2.EQS."T" THEN WRITE TKBFILE "LSL$LIBRARY:TITS/DA"$	IF P2.EQS."O" THEN WRITE TKBFILE "LSL$LIBRARY:ODT/DA"$	WRITE TKBFILE "/"$	WRITE TKBFILE "UNITS=10"$	WRITE TKBFILE "EXTSCT=$$FSR1:10000"$	WRITE TKBFILE "EXTTSK=",LEXTT$	WRITE TKBFILE "ASG=SY:5:6"$	WRITE TKBFILE "//"$	CLOSE TKBFILE$	TKBEXISTS=0$TASK_BUILD:$	SET NOON$	MCR TKB @'P1.TKB$	PURGE 'P1.*$	IF .NOT.TKBEXISTS THEN DELETE 'P1.TKB;*$	SET ON$END:	EXIT