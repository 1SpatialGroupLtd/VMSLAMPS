$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-07-13 13:48:56.000000000 +0100
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
$! These sets use MCCONALOGUE interpolation
$!
$! First set with SEPARATION parameter being varied
$!  
$ sd lsl$source_root:[imp.ifilter]  
$ si here
$ impini q
$! ifilter/mcconalogue=(sep:2.000)/fc=74/nodp diag_2 diag_2_mc1
$! ifilter/mcconalogue=(sep:1.000)/fc=74/nodp diag_2 diag_2_mc2
$! ifilter/mcconalogue=(sep:0.500)/fc=74/nodp diag_2 diag_2_mc3
$! ifilter/mcconalogue=(sep:0.250)/fc=74/nodp diag_2 diag_2_mc4
$! ifilter/mcconalogue=(sep:0.125)/fc=74/nodp diag_2 diag_2_mc5
$!
$! Second set with CHORD parameter being varied
$!  
$! ifilter/mcconalogue=(cho:0.16)/fc=74/nodp diag_2 diag_2_mc6
$! ifilter/mcconalogue=(cho:0.08)/fc=74/nodp diag_2 diag_2_mc7
$! ifilter/mcconalogue=(cho:0.04)/fc=74/nodp diag_2 diag_2_mc8
$! ifilter/mcconalogue=(cho:0.02)/fc=74/nodp diag_2 diag_2_mc9
$! ifilter/mcconalogue=(cho:0.01)/fc=74/nodp diag_2 diag_2_mc10
$!
$! Third set with DEVIATION parameter being varied
$!  
$ ifilter/mcconalogue=(dev:0.8)/fc=74/nodp diag_2 diag_2_mc11
$ ifilter/mcconalogue=(dev:0.4)/fc=74/nodp diag_2 diag_2_mc12
$ ifilter/mcconalogue=(dev:0.2)/fc=74/nodp diag_2 diag_2_mc13
$ ifilter/mcconalogue=(dev:0.1)/fc=74/nodp diag_2 diag_2_mc14
$ ifilter/mcconalogue=(dev:0.05)/fc=74/nodp diag_2 diag_2_mc15
