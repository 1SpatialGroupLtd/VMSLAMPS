$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-07-13 15:30:16.000000000 +0100
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
$! Command procedure to run IFILTER to generate documentation diagrams
$! These sets use DP filter
$!
$ sd lsl$source_root:[imp.ifilter]  
$ si here
$ impini q
$!
$! LATITUDE parameter being varied
$!  
$ ifilter/dp=(lat:0.0625)/fc=74 diag diag_dp1
$ ifilter/dp=(lat:0.125)/fc=74 diag diag_dp2
$ ifilter/dp=(lat:0.25)/fc=74 diag diag_dp3
$ ifilter/dp=(lat:0.5)/fc=74 diag diag_dp4
$ ifilter/dp=(lat:1.0)/fc=74 diag diag_dp5
