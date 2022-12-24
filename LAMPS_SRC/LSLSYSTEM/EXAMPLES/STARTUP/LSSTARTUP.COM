$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-08-01 10:05:40.000000000 +0100
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
$! LSSTARTUP.COM - System startup file for Laser-Scan Mapping/GIS. 
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$! This procedure should be called from the end of SYSTARTUP_V5.COM.
$! It in turn calls the various parts of the Laser-Scan startup.
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$	WS "Entering LSSTARTUP.COM - Laser-Scan startup procedure"
$!
$! Define name for the directory(s) containing the subsequent LSL startup files
$! This should only need to be changed on complex systems (eg dual boot node).
$!
$	DEFINE/SYSTEM	LSL$STARTUP	SYS$MANAGER
$!
$! Define and possibly mount disks (usually already done in SYSTARTUP_V5.COM).
$!
$	@LSL$STARTUP:LSDISKS
$!
$! define logical names.
$!
$	@LSL$STARTUP:LSDEFNS
$!
$! set up terminals.
$!
$	@LSL$STARTUP:LSTERMS
$!
$! set up server ports (assumes LTLOAD.COM already called from SYSTARTUP_V5.COM)
$!
$	@LSL$STARTUP:LSPORTS
$!
$! install known images, if any.
$!
$	@LSL$STARTUP:LSIMAGES
$!
$! start detached processes, if any.
$!
$	@LSL$STARTUP:LSPROCESSES
$!
$! start LSL batch queues (assumes queue manager started in SYSTARTUP_V5.COM)
$!
$	@LSL$STARTUP:LSQUEUES
$!
$! set up LSL printer queues (if not done in SYSTARTUP_V5)
$!
$	@LSL$STARTUP:LSPRINTERS	
$!
$! call any package startup procedures
$!
$NEXTPROC:
$	FILESPEC=F$SEARCH("LSL$STARTUP:LSSTARTUP_*.COM")
$	IF FILESPEC.EQS."" THEN GOTO END
$	@'FILESPEC'
$	GOTO NEXTPROC
$!
$! all done
$!
$END:	WS "Finished LSSTARTUP.COM"
$	EXIT
