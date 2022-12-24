$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-04-06 13:41:52.000000000 +0100
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
$	SET NOVER
$	IF P1 .NES. "" THEN GOTO GOTNAM
$	INQUIRE/NOP P1 "Program ? "
$	IF P1 .EQS. "" THEN EXIT
$ GOTNAM:
$	LEN=F$LEN(P1)
$	POS=F$LOC(".",P1)
$	IF POS .NE. LEN THEN P1=F$EXT(0,POS,P1)
$	FDEB:=""
$	LDEB:=/NOTRACE
$	INQUIRE/NOP DEB "Debug ? "
$	IF .NOT.DEB THEN GOTO NODEB
$	FDEB:=/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW)
$	LDEB:=/DEBUG
$ NODEB:
$	IF F$GETSYI("ARCH_NAME").EQS."Alpha" THEN GOTO BUILD_AXP
$! here to build VAX version
$	SET VER
$	ADC 'P1'/CO='P1'
$	FORT'FDEB' 'P1'
$	PVV 'P1'
$	DELETE ADC.IDE;*
$	ADC TRLGNM/CO=TRLGNM
$	FORT'FDEB' TRLGNM
$	PVV TRLGNM
$	DELETE ADC.IDE;*
$	LINK'LDEB' 'P1',TRLGNM
$	GOTO DO_TIDY
$BUILD_AXP:
$! here to build AXP version
$	SET VER
$	COPY 'P1'.SRC .FOR
$	COPY TRLGNM.SRC .FOR
$	FORT'FDEB' 'P1'
$	FORT'FDEB' TRLGNM
$	LINK'LDEB' 'P1',TRLGNM/EXE='P1'_AXP
$DO_TIDY:
$	DELETE 'P1'.OBJ;*,TRLGNM.OBJ;*
$	PURGE/NOLOG TRLGNM.FOR,'P1'.FOR,'P1'*.EXE
$	IF FDEB .EQS. "" THEN DELETE 'P1'.FOR;,TRLGNM.FOR;
$	SET NOVER
