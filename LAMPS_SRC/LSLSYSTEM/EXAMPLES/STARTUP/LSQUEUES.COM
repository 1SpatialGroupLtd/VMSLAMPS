$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-08-01 10:09:46.000000000 +0100
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
$! LSQUEUES.COM - start LSL queues. Called from LSSTARTUP.COM
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$! Starts LSL-specific batch queues. Note that the queue manager, and any
$! system batch queues are assumed to be started using the facilities in
$! the DEC-supplied file SYS$MANAGER:SYSTARTUP_V5.COM.
$!
$! Uncomment any lines below which are relevant to your installation.
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$	WS "LSQUEUES.COM - starting queues"
$!
$! start a plotter batch queue, if needed
$!
$!!!	INIT/QUE/START/BATCH/JOB_LIM=1/BASE_PRIO=4/PROT=(G:D,W:RW) PLOTBATCH
$!!!	DEFINE/SYSTEM PLOTBATCH PLOTBATCH
$!
$! Search for package specific queueini's
$!
$Q_INI:
$	QUEUEINI=F$SEARCH("LSL$STARTUP:*QUEUEINI.COM",1)
$	IF QUEUEINI.EQS."" THEN GOTO EXIT
$	@'QUEUEINI
$	GOTO Q_INI
$!
$EXIT:	EXIT
