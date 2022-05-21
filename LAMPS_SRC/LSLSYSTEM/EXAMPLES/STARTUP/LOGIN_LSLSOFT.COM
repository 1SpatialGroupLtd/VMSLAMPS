$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-07-12 22:50:26.000000000 +0100
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
$! LSLSOFT's LOGIN.COM
$	SAVVER='F$VERIFY(0)'
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$!
$! call LAMPS central login definitions file (usually done from SYS$SYLOGIN)
$!
$!!!	@SYS$MANAGER:LSLOGIN
$!
$	IF F$MODE().EQS."NETWORK" THEN GOTO NETJOB	! speed up FAL
$!
$! set up symbol definitions in alphabetic order
$!
$	DI	=="DIRECTORY"		! shorthand
$	DIR	=="DIRECTORY/DATE/SIZE=ALL/OWNER/WID=(OWNER:19)" ! shorthand
$	EDT	=="EDIT/EDT"		! normal editor
$	CED	==EDT			! must come after EDT
$	CVT	=="$LSL$EXE:CVT"	! number conversion
$	ERR*OR	==CVT+"/ERROR"		! convert number to system error msg
$	NV	=="@LSL$COM:NV"		! New Version - EDT,PID,PURGE
$	PID	=="$LSL$EXE:PID"	! patch identification field
$	PL	=="PURGE/LOG"		! shorthand
$	PRO*TECT=="@LSL$SYS:PROTECT"	! file protection
$	SL	=="SHOW LOGICAL"	! shorthand
$	SQB	=="SHOW QUEUE/BATCH/ALL"! shorthand
$	SQP	=="SHOW QUEUE/DEVICE/ALL"	! Show devices (printers)
$	SS	=="SHOW SYMBOL"		! shorthand
$	V	==EDT+"/READONLY/NOCREATE"	! look at file without changing
$!
$! network jobs join here
$NETJOB:
$EXIT:
$!
$! tidy up and exit
$!
$	SET CONTROL_Y
$	SET CONTROL=T
$	IF SAVVER THEN SET VERIFY
