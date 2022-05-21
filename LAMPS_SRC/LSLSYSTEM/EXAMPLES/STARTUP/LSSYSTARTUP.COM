$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-07-20 17:54:20.000000000 +0100
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
$! LSSYSTARTUP.COM - VMS System startup file for Laser-Scan Mapping/GIS. 
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL, after DM			PGH	11-Jul-1990
$!
$! This procedure can be called from the end of SYSTARTUP_V5.COM,
$! just before the call to LSSTARTUP which defines the required LSL environment.
$!
$! This file contains VMS system management commands which may or may not be
$! appropriate to your system, and are not strict prerequisites for the 
$! operation of LSL software. They may however be useful as reminders and
$! templates for setting up your VMS environment.
$!
$! Uncomment and modify any lines below which are relevant to your installation.
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$	WS "Entering LSSYSTARTUP.COM - Laser-Scan system startup file"
$!
$! Set parameters for the VMS Workstation Software for more windows.
$! Note that this line should only be uncommented if the appropriate values
$! for NPAGEDYN etc have been set in MODPARAMS.DAT (see VWS Installation Guide).
$!
$!!!!	DEFINE/SYSTEM/EXEC	UIS$QVSS_POOL_SIZE	1522300
$!
$! This command defines a message to be displayed before each user logs in. 
$	NODE=F$TRNLNM("SYS$NODE") - "::"
$	DEASSIGN /SYSTEM SYS$ANNOUNCE
$	DEFINE /SYSTEM SYS$ANNOUNCE -
	"	Welcome to Laser-Scan node ''NODE' running VAX/VMS ''F$GETSYI("VERSION")'"
$	DEFINE/SYSTEM	PSM$ANNOUNCE	"Laser-Scan node ''NODE'"
$!
$! odds and ends
$!!!	SET ACCOUNTING/DISABLE=(LOGIN_FAILURE,PRINT)
$!!!	PURGE SYS$MANAGER:OPERATOR.LOG/KEEP=2
$!
$	EXIT
