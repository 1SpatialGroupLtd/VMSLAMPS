$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-11-11 19:27:58.000000000 +0000
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
$	V='F$VERIFY(0)'$	IF F$GETDVI("MT","MNT").AND.-	  (F$GETDVI("MT","PID").EQS.F$GETJPI(0,"PID")) THEN -	  DISMOUNT MT:/NOUNLOAD$	DELETE/SYMBOL/GLOBAL LOGOUT$	IF P1.NES."" THEN GOTO END$	ESC[0,7]	=27$	DEVTYPE		=F$GETDVI(F$LOGICAL("TT"),"DEVTYPE")$	DEVDEPEND2	=F$GETDVI(F$LOGICAL("TT"),"DEVDEPEND2")$	TT2$M_DECCRT	=%X20000000$	DT$_VT52	=64$	IF  DEVTYPE.EQ.DT$_VT52 THEN GOTO VT52$	IF (DEVDEPEND2.AND.TT2$M_DECCRT).EQ.0 THEN GOTO END$	WRITE SYS$OUTPUT ESC,"[H",ESC,"[2J"$	GOTO END$ VT52:	WRITE SYS$OUTPUT ESC,"H",ESC,"J"$ END:$!!!	IF "''SYS$ACCOUNT'" .EQS. "" THEN GOTO NOACC$!!!	A="        "$!!!	A[0,8]:='SYS$ACCOUNT'$!!!	SEARCH/EXACT SYS$MANAGER:JOBNOS.DAT "''A'"$NOACC:	COST$	IF P1 .EQS. "" THEN LOGOUT/FULL$	LOGOUT/BRIEF