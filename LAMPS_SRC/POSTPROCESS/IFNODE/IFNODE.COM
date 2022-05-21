$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-08-05 14:11:32.000000000 +0100
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
$!
$! Command file for IFNODE (Node Extraction from junction IFF files)
$! =================================================================
$!
$!	Created					 DM	02-Mar-1984
$!
$	ON ERROR THEN GOTO 100
$	ON CONTROL_Y THEN EXIT
$!
$	DISK:='F$LOGICAL("SYS$DISK")'
$!
$	IF "''F$LOGICAL("LSL$IFNODEMAKING")'" .NES. "IN_PROGRESS" THEN -
	   GOTO A0
$	WRITE SYS$OUTPUT "Someone else is MAKing"
$	EXIT
$!
$ A0:	ON CONTROL_Y THEN GOTO IFNODEX
$	DEFINE/GROUP LSL$IFNODEMAKING "IN_PROGRESS"
$	TRFILE:==MAR:PARAMS.MAR
$	MAKE 'P1' 'P2' 'P3' 'P4' 'P5' 'P6' 'P7'
$	MAKFIL IFNODEBAT.COM
$	ON CONTROL_Y THEN GOTO FILCLO
$!
$	WC	"$	ON CONTROL_Y THEN GOTO IFNODEND"
$	WC	"$	IF F$LOGICAL(""LSL$IFNODEBATTING"") -"
$	WC	"		.NES. ""IN_PROGRESS"" THEN GOTO A0"
$	WC	"$	WRITE SYS$OUTPUT ""Someone else is building"""
$	WC	"$	EXIT"
$	WC	"$!"
$	WC	"$ A0:	DEFINE/GROUP LSL$IFNODEBATTING ""IN_PROGRESS"""
$	WC	"$	ASSIGN ''DISK'[POSTPROCESS.IFNODE] SRC"
$	WC	"$	ASSIGN ''DISK'[POSTPROCESS.IFNODE] MAR"
$	WC	"$	ASSIGN ''DISK'[POSTPROCESS.IFNODE] EXE"
$	WC	"$	ASSIGN ''DISK'[POSTPROCESS.IFNODE] CMN"
$	WC	"$	SET NOON"
$!
$	INQUIRE/NOP ANSWER "Compile ? "
$	IF .NOT. ANSWER THEN GOTO LKONLY
$	FSW1=""
$	INQUIRE/NOP IFNODE_DBG "With Debug ? "
$	IF .NOT.IFNODE_DBG THEN GOTO A05
$	  MAKDEBUG
$	  INQUIRE/NOP ANSWER "Without optimisation ? "
$	  IF ANSWER THEN FSW1="/NOOPT"
$	  INQUIRE/NOP ANSWER "Check bounds and overflow ? "
$	  IF ANSWER THEN FSW1=FSW1+"/CHECK=(BOUNDS,OVERFLOW)"
$	  IF FSW1 .NES. "" THEN MAKFSW 'FSW1'
$	  INQUIRE/NOP ANSWER "With listings ? "
$	  IF ANSWER THEN MAKLIS
$	  INQUIRE/NOP ANSWER "Keep FORtran sources with comments ? "
$	  IF ANSWER THEN MAKFKP		! keep ADC'd .FOR with comments
$ A05:
$	MAKINQ ALL "Everything"
$	IF ALL THEN MAKALL
$!
$	MAKASK IFNODE "Main routine (IFNODE)"
$	IF NO THEN GOTO 1
$	MAKC AF IFNODE IFNODE
$	MAKC AM IFNODE IFNODECMD
$!
$ 1:	MAKASK INPUT "GETFIL"
$	IF NO THEN GOTO 100
$	MAKC AF GETFIL GETFIL
$!
$ 100:	ON ERROR THEN GOTO FILCLO
$	INQUIRE/NOP ANSWER "Link ? "
$	IF .NOT.ANSWER THEN GOTO NOTKB
$!
$ LKONLY:
$	WC "$	RUN EXE:GENDAT"
$	WC "$	PURGE SRC:IDENT.SRC"
$	MAKC AF IDENT IDENT
$!
$	TSKEXT=""
$	INQUIRE/NOP ANSWER "Experimental version ? "
$	IF ANSWER THEN TSKEXT="XP"
$!
$	MAKC L IFNODE 'DISK'[POSTPROCESS.IFNODE]IFNODE
$	BUILD IFNODE'TSKEXT' IFNODE
$!
$ NOTKB:
$	WC "$ IFNODEND:"
$	WC "$	DEASS/GROUP LSL$IFNODEBATTING"
$!
$	MAKEND
$	GOTO IFNODEX
$ FILCLO:
$	MAKCLO
$ IFNODEX:
$	DEASS/GROUP LSL$IFNODEMAKING
