$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1989-06-08 09:55:00.000000000 +0100
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
$ FDEBSW=""
$ LDEBSW=""
$ IF P1.EQS."D" THEN FDEBSW="/DEBUG/NOOPT"
$ IF P1.EQS."D" THEN LDEBSW="/DEBUG"
$ SET VER
$ ADC IMGHDR_IDENT=IMGHDR_IDENT
$ FORT IMGHDR_IDENT'FDEBSW'
$ PVV IMGHDR_IDENT
$ DELETE ADC.IDE;*
$ LINK'LDEBSW' IMGHDR_IDENT,SYS$INPUT/OPT
LSL$LSLSHR/SHARE
SYS$SYSTEM:SYS.STB
$ PURGE IMGHDR_IDENT.*
$ SET NOVER
