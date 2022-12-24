$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-04-14 12:56:30.000000000 +0100
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
$define lsl$polygons_polmax 10000
$define lsl$polygons_average_sides 10
$define lsl$fill_cutsmax 250000
$define lsl$fill_pointsmax 20000
$ipolygon=="$lsl$source_root:[polygons.ipolygon]ipolygon"
$si lsl$source_root:[polygons.ipolygon]
$!ilink/struct uk_urban.brk uk_urban.str
$IPOLYGON/ONEARM=DELETE/POLYGONS=(OUT:UK_URBAN.POL,LABEL)-
/LITES2/LOG/SEED=(USE:FSN,PAIR:HERE:uk_urban.PAIR,FC:(3755:3779)) UK_URBAN.STR
