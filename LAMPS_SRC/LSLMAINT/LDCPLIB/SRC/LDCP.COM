$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-02-19 16:06:56.000000000 +0000
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
$	VER='F$VERIFY(0)
$	inquire CMP "Compile"
$	inquire BLD "Build"
$	inquire DBG "Debug"
$	if .not.DBG then DEB=""
$	if	DBG then DEB="/DEBUG"
$	inquire LST "Listing"
$	if .not.LST then LST=""
$	if	LST then LST="/LIST"
$	on error then goto QUIET
$	if .not.CMP then goto TRYBLD
$! compile
$	SET VERIFY
$	ADC CPPGEN=CPPGEN,DSUBST,DREPT
$	FORTRAN/NOI4'DEB''LST' CPPGEN
$	PVV CPPGEN
$	DELETE ADC.IDE;*
$
$	ADC LDCPLIB=LDCPLIB
$	FORTRAN/NOI4'DEB''LST' LDCPLIB
$	PVV LDCPLIB
$	DELETE ADC.IDE;*
$	V='F$VERIFY(0)
$! build
$TRYBLD:if .not.BLD then goto QUIET
$	SET VERIFY
$	LIB/CRE LDCPLIB LDCPLIB,CPPGEN
$	V='F$VERIFY(0)
$	DELETE LDCPLIB.OBJ;*,CPPGEN.OBJ;*
$	if DEB.EQS."" then DELETE LDCPLIB.FOR;*,CPPGEN.FOR;*
$	purge
$QUIET:	V='F$VERIFY(0)
$	IF VER THEN SET VERIFY
