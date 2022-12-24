$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1985-09-24 10:51:06.000000000 +0100
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
$	VER='F$VERIFY(0)
$	ON CONTROL THEN GOTO CHANGE_ERROR
$	ON ERROR THEN GOTO CHANGE_ERROR
$!
$!	Last edited				 DM	24-Sep-1985
$!	MODU.FLF stuff commented out		AJW	05-Jul-1982
$!
$! Command file to update a Laseraid source file, automatically
$! recording the change in LSL$DISK:[FLF.FLF]FLF.UPD, and preventing
$! two people from simultaneously editing the same file
$! The first parameter is the file to be edited, - if it is "*", then
$! no file is edited, but the updates procedure is followed
$!
$	WS="WRITE SYS$OUTPUT"
$	MYPID=F$GETJPI("","PID")
$!
$	IF P1 .EQS. ""  THEN EXIT %X38048
$	IF P1 .EQS. "*" THEN GOTO CHANGE_NOMODS
$!	
$	IF F$SEARCH(P1).NES."" THEN GOTO CHANGE_YESFIL
$	  WS "File ",P1," does not exist"
$	  EXIT
$ CHANGE_YESFIL: -
$!
$! Stake our claim to the file, and then check that no-one
$! else is editing it
$	AAA=F$PARSE(P1)
$	DEFINE/GROUP FLF$UP_'MYPID' 'AAA'
$!
$! Loop for all processes
$	CONTEXT=""
$ CHANGE_NEXTP:
$	PID=F$PID(CONTEXT)
$	IF PID.EQS.""    THEN GOTO CHANGE_NO_ONE_ELSE
$	IF PID.EQS.MYPID THEN GOTO CHANGE_NEXTP
$	IF F$LOGICAL("FLF$UP_"+PID) .NES. AAA THEN -
$	  GOTO CHANGE_NEXTP
$	  XXX=F$GETJPI(PID,"PRCNAM")
$	  WS "Sorry, ",XXX," is editing ",P1
$	  DEASSIGN/GROUP FLF$UP_'MYPID'
$	  EXIT
$ CHANGE_NO_ONE_ELSE: -
$!
$	IF "''CED'" .EQS. "" THEN XXX="EDIT/EDT"
$	IF "''CED'" .NES. "" THEN XXX=CED
$	ASSIGN/USER TT SYS$INPUT
$	XXX 'P1'
$	DEASSIGN/GROUP FLF$UP_'MYPID'
$	AAA="LSL$DISK:[FLF.FLF]FLF.UPD"
$	DEFINE/GROUP FLF$UP_'MYPID' 'AAA'
$!
$! Loop for all processes
$ CHANGE_NEXTP3:
$	CONTEXT=""
$ CHANGE_NEXTP2:
$	PID=F$PID(CONTEXT)
$	IF PID.EQS.""    THEN GOTO CHANGE_NOMODS
$	IF PID.EQS.MYPID THEN GOTO CHANGE_NEXTP2
$	IF F$LOGICAL("FLF$UP_"+PID) .NES. AAA THEN -
$	  GOTO CHANGE_NEXTP2
$	  XXX=F$GETJPI(PID,"PRCNAM")
$	  WS "Sorry, ",XXX," is editing ",AAA," - please wait"
$	  WAIT 00:00:05.00
$	  GOTO CHANGE_NEXTP3
$ CHANGE_NOMODS: -
$	T:='F$TIME()		! to lose leading spaces
$	L=F$LOCATE(" ",T)
$	T=F$EXTRACT(0,L,T)
$	N=F$PROCESS()
$	OPEN/WRITE FIL CHANGETMP.EDT
$	IF F$SEARCH("EDTINI") .EQS. "" THEN GOTO CHANGE_NOEDITFILE
$	  WRITE FIL "INCLUDE EDTINI =EDTINI"
$	  WRITE FIL "DEFINE MACRO EDTINI;EDTINI"
$	  WRITE FIL "FIND =MAIN"
$	  GOTO CHANGE_EDITFILE
$ CHANGE_NOEDITFILE: -
$	  WRITE FIL "SET MODE CHANGE"
$ CHANGE_EDITFILE: -
$	WRITE FIL "SET SCREEN 80"
$	WRITE FIL "FIND END"
$	WRITE FIL "I;"
$	WRITE FIL "I;",T,"	",P1,"	- ",N
$	WRITE FIL "I;X"
$	WRITE FIL "F .-1"
$	WRITE FIL "S/X/		/"
$	CLOSE FIL
$	ASS/USER TT SYS$INPUT
$	EDIT LSL$DISK:[FLF.FLF]FLF.UPD/EDT/COMMAND=CHANGETMP.EDT
$	ASSIGN/USER NL: SYS$OUTPUT
$	ASSIGN/USER NL: SYS$ERROR
$	PURGE LSL$DISK:[FLF.FLF]FLF.UPD
$	GOTO CHANGE_EXIT
$!
$ CHANGE_ERROR: -
$	ON ERROR THEN CONTINUE
$	CLOSE FIL
$ CHANGE_EXIT: -
$	ASSIGN/USER NL: SYS$OUTPUT
$	ASSIGN/USER NL: SYS$ERROR
$	DELETE CHANGETMP.EDT;*
$	IF F$LOGICAL("FLF$UP_"+MYPID).NES."" THEN -
$	  DEASSIGN/GROUP FLF$UP_'MYPID'
$	IF VER THEN SET VERIFY
