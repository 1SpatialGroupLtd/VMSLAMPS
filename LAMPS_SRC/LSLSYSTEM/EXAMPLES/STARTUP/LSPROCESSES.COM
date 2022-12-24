$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-07-11 12:26:24.000000000 +0100
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
$! LSPROCESSES.COM - start LSL detached processes. Called from LSSTARTUP.COM
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$! Starts any LSL detached processes.
$!
$! Uncomment any lines below which are relevant to your installation.
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$!!!	WS "LSPROCESSES.COM - Starting detached processes"
$!
$! start the table monitor for the LITES2 Altek digitising tables
$!
$!!!	STARTMON="$LSL$EXE:STARTMON"
$!!!	STARTMON LSL$WS1_TABLE 16 100 Y
$!!!	STARTMON LSL$WS2_TABLE 16 100 Y
$!!!	STARTMON LSL$WS3_TABLE 16 100 Y
$!
$	EXIT
