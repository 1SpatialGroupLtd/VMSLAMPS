$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-11-25 18:07:32.000000000 +0000
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
$! LSDISKS_MOUNT.COM - mount LSL disks. Called from LSSTARTUP.COM
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$! Mount any LSL-specific disks.
$! It is now more usual to mount system-wide disks from SYSTARTUP_V5.COM,
$! unless this is a dedicated LSL configured cluster.
$!
$! Uncomment and modify any lines below which are relevant to your installation.
$!
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$	WS "LSDISKS_MOUNT.COM - Mounting LSL disks"
$!
$! If not boot node, then first wait around for a bit because our local disks
$! may not be visible on the other nodes yet !
$!
$	NODENAME=F$GETSYI("NODENAME")
$!!!	IF NODENAME.NES."SERVER"
$!!!	THEN
$!!!	  WS "... Waiting for MSCP-served disks to appear on other nodes"
$!!!	  WAIT 0:01:00.00
$!!!	  WS "... Wait complete"
$!!!	ENDIF
$!
$! now call mount procedure for each disk
$!
$!!!	CALL DOMOUNT	$1$DKA0:	DISK0		LSL$DISK0 ! programs etc
$!!!	CALL DOMOUNT	$1$DKA100:	DISK1		LSL$DISK1 ! data
$!!!	CALL DOMOUNT	$1$DKA200:	DISK2		LSL$DISK2 ! more data
$!!!	CALL DOMOUNT	$1$DKA300:	DISK3		LSL$DISK3 ! VMS system
$!!!	CALL DOMOUNT	$2$DKA0:	DISK4		LSL$DISK4 ! more data
$!!!	CALL DOMOUNT	$3$DKA0:	DISK5		LSL$DISK5 ! more data
$!!!	CALL DOMOUNT	$1$DKA700:	OPTIC0		LSL$OPTIC0 ! Optical
$!
$!!! local mount only  	$2$DKA300:			! page & swap
$!!! local mount only  	$3$DKA300:			! page & swap
$!
$	GOTO EXIT
$!
$! DOMOUNT - subroutine to ensure disks mounted cluster-wide
$!
$DOMOUNT:SUBROUTINE
$	IF .NOT.F$GETDVI(P1,"EXISTS") THEN GOTO CANT
$	IF .NOT.F$GETDVI(P1,"AVL") THEN GOTO CANT
$	IF .NOT.F$GETDVI(P1,"HOST_AVAIL") THEN GOTO CANT
$	MOUNT/CLUSTER 'P1' 'P2' 'P3'
$	GOTO ENDDOMOUNT
$CANT:
$	WRITE SYS$OUTPUT P1," (",P2,") not yet available."
$ENDDOMOUNT:
$	IF F$TRNLNM(P3).EQS."" THEN DEFINE/SYS/EXEC/TRANS=(CONC,TERM) 'P3' 'P1'
$	ENDSUBROUTINE
$!
$! all done
$!
$EXIT:
$	EXIT
