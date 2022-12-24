$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-07-13 10:55:02.000000000 +0100
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
$! These sets use LINEAR interpolation
$!
$! First set with SEPARATION parameter being varied
$!  
$ sd lsl$source_root:[imp.ifilter]  
$ si here
$ impini q
$ ifilter/linear=(sep:2.000)/fc=74/nodp diag_2 diag_2_li1
$ ifilter/linear=(sep:1.000)/fc=74/nodp diag_2 diag_2_li2
$ ifilter/linear=(sep:0.500)/fc=74/nodp diag_2 diag_2_li3
$ ifilter/linear=(sep:0.250)/fc=74/nodp diag_2 diag_2_li4
$ ifilter/linear=(sep:0.125)/fc=74/nodp diag_2 diag_2_li5
