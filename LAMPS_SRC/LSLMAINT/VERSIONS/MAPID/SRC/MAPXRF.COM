$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1982-05-20 15:14:44.000000000 +0100
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
$!
$! Command file to build MAPXRF
$!
$	IF P1.NES."" THEN DEB:=/DEBUG
$	IF P1.NES."" THEN FDEB:=/DEBUG/CHECK/NOOPT
$	SET NOON
$	SET VER
$	ADC MAPXRF=MAPXRF
$	FORT/NOI4'FDEB' MAPXRF
$	PVV MAPXRF
$	DELETE ADC.IDE;*,MAPXRF.FOR;*
$	LINK/MAP/CROSS'DEB' MAPXRF,SYS$LIBRARY:VIOLIB/LIB
$	PURGE MAPXRF.*
$	SET NOVER
