$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-07-12 21:50:06.000000000 +0100
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
$! LSLUSER's LOGIN.COM
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$	SAVVER='F$VERIFY(0)'
$	SET NOON
$	SET NOCONTROL_Y
$!
$! call LAMPS central login definitions file (usually done from SYS$SYLOGIN)
$!
$!!!	@SYS$MANAGER:LSLOGIN
$!
$! set up symbol definitions in alphabetic order
$!
$	DI	=="DIRECTORY"		! shorthand
$	DIR	=="DIRECTORY/DATE/SIZE=ALL/OWNER/WID=(OWNER:19)" ! shorthand
$!
$! tidy up and exit
$!
$	SET CONTROL_Y
$	SET CONTROL=T
$	IF SAVVER THEN SET VERIFY
