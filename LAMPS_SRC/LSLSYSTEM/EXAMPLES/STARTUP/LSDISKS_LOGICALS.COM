$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-07-12 09:51:38.000000000 +0100
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
$! LSDISKS_LOGICALS.COM - define LSL disks. Called from LSSTARTUP.COM
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$! Set up logical names for all the disks currently known to the system,
$! setting LSL$DISKxxx names to all mounted disks, as used by FREE.COM.
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$	WS "LSDISKS_LOGICALS.COM - Defining LSL disk logical names"
$!
$	SHOW DEVICE D/BRIEF/MOUNT/OUT=SYS$SCRATCH:SHOW_DEVICE_TEMP.TMD
$	ON ERROR THEN GOTO TIDY
$	ON CONTROL THEN GOTO TIDY
$	OPEN/ERR=TIDY	FILE	SYS$SCRATCH:SHOW_DEVICE_TEMP.TMD
$	ON ERROR THEN GOTO DONE
$	ON CONTROL THEN GOTO DONE
$	READ/END=DONE/ERR=DONE	FILE	LINE	! skip header junk
$	READ/END=DONE/ERR=DONE	FILE	LINE
$	READ/END=DONE/ERR=DONE	FILE	LINE
$!
$! now start looking for devices
$	I=0
$	J=0
$LOOP:	
$	READ/END=DONE/ERR=DONE	FILE	LINE
$	IF "''F$EXTRACT(0,1,LINE)'" .EQS. " " THEN GOTO LOOP
$	POS=F$LOCATE(":",LINE) + 1
$	DEV=F$EXTRACT(0,POS,LINE)
$	IF F$GETDVI(DEV,"DEVCLASS") .NE. 1 .OR. -
	   .NOT. F$GETDVI(DEV,"MNT") THEN GOTO LOOP
$!
$! assign system-wide logical names
$	ASSIGN/SYSTEM	"''DEV'"	LSL$DISK_'F$EXTRACT(48,14,LINE)'
$!
$	IF F$GETDVI("''DEV'","REMOTE_DEVICE") THEN GOTO REMOTE
$!
$	ASSIGN/SYSTEM	"''DEV'"	LSL$DISK'I'
$	I=I + 1
$	GOTO LOOP
$!
$REMOTE:
$	ASSIGN/SYSTEM	"''DEV'"	LSL$DISKX'J'
$	J=J + 1
$	GOTO LOOP
$!
$DONE:	CLOSE FILE
$TIDY:	DELETE/NOCONFIRM SYS$SCRATCH:SHOW_DEVICE_TEMP.TMD;*
$!
$	EXIT
