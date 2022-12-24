$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-08-03 10:49:36.000000000 +0100
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
$! LSTERMS.COM - set LSL terminal charactistics. Called from LSSTARTUP.COM
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$! Sets the terminal characteristics, protections, and logical names for any
$! serial line devices used by LSL software. See also separate file called
$! LSPORTS.COM for devices on terminal server connections.
$!
$! Uncomment and modify any lines below which are relevant to your installation.
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$	WS "LSTERMS.COM - Setting up serial lines"
$!
$! First deal with the console port on a VAXstation, if VTRAK in use
$!
$	IF F$SEARCH("LSL$PUBLIC_ROOT:[000000]VTRAK.DIR").EQS."" THEN GOTO NO_VTRAK
$	IF F$GETSYI("XCPU") .EQS. "4"
$	THEN
$! it's a VS3100 - so use TT terminal
$ 	   DEFINE/SYSTEM/EXECUTIVE_MODE/NOLOG CSA0 TTA3:
$	ELSE
$! assume it's a Q-BUS VAXstation so can use CSA0 after we connect it
$	   SYSGEN := $SYSGEN
$	   IF F$GETSYI("WS_OPA0") .AND. .NOT. F$GETDVI("CSA0:","EXISTS") THEN -
		SYSGEN CONNECT CONSOLE
$	ENDIF
$	IF .NOT. F$GETDVI("CSA0:","EXISTS") THEN GOTO NO_VTRAK
$!
$! Either way, we set the protection, so we can allocate it
$!
$	SET PROTECTION=(W:RWLP)/DEVICE/OWNER=[LSLSOFT] CSA0:
$	SET TERM/PERM CSA0:/NOTYPE/NOTTSY/NOHOST/NOBROADCAST
$	DEFINE/SYSTEM	LSL$CONSOLE	CSA0:
$!
$NO_VTRAK:
$!
$! now set up things for LITES2 workstations
$!
$!
$! LITES2 workstation 1 example for VWS display with Kontron table on TTA3:
$! If it was part of a cluster, then instead of WTXX, it would be MYNODE_WTXX
$!
$!!!	Define/System	LSL$WS1_VDU			WTXX
$!!!	Define/System	LSL$WS1_GDU			WTXX
$!!!	Set Term/perm/speed=9600/notype/nobroad/alt	TTA3:	! Table
$!!!	Define/System	LSL$WS1_TABLE			TTA3:
$!!!	Define/System	LSL$TABMON_ROUTINE_TTA3		LSL$EXE:KONTRON_001.EXE
$!!!	Set Protection=(W:RWLP)/device			TTA3:
$!
$! LITES2 workstation 1 example for Sigmex 6000 GDU and Altek table on TX lines
$!
$!!!	Set Term/perm/full/speed=9600/vt100 		TXA0:	! VDU
$!!!	Define/System	LSL$WS1_VDU			TXA0:
$!!!	Set Term/perm/speed=9600/notype/nobroad/alt	TXA1:	! Table
$!!!	Define/System	LSL$WS1_TABLE			TXA1:
$!!!	Set Protection=(W:RWLP)/device			TXA1:
$!!!	Set Term/perm/full/speed=19200/vt100		TXA2:	! GDU
$!!!	Define/System	LSL$WS1_GDU			TXA2:
$!!!	Set Protection=(W:RWLP)/device			TXA2:
$!!!	Define/System	LSL$WS1_TYPE			SIG6000
$!
$! Hewlett Packard plotter (as an example)
$!
$!!!	Set Term/perm/notype/nobroad/speed=9600		TXA7:
$!!!	Set Protection=(W:RWLP)/device			TXA7:
$!!!	Define/System	LSL$HP				TXA7:
$!!!	Define/System	LSL$HPINPUT			TXA7:
$!
$	EXIT
