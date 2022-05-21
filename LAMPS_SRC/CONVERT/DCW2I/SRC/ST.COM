$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-12-03 13:09:58.000000000 +0000
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
!DEVICE LSL$DATA_ROOT:
!TARGET LSL$DATA_ROOT:[DCW.IFF]
DEVICE LSLV4D$DKA200:
!TARGET LSLV4D$DKA100:[LSLDATA.DCW]
TARGET LSL$SOURCE_ROOT:[CONVERT.DCW2I]
!DESEL CLASS ALL
!SEL CLASS LINE
SEL LIB SASAUS
!SEL COV AE,CL,DQ,DS,HS,LC,OF,PH,PO,RD,RR,TS,UT
SEL COV DN
SEL GEO TJ,UJ,VJ,TH,UH,VH,TG,UG,VG
ACFILE DCW.ACT
FCFILE DCW.FCT
GO
