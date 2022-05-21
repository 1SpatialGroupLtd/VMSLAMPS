$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-27 12:43:40.000000000 +0100
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
!
lookup lsl$public_root:[dtmprepare.accept]dtmprepare_accept.dat
filein here:dtmprepare_accept_i3d_intersected1.iff
fileout here:dtmprepare_accept_i3d_interpolated.iff
checkplot here:dtmprepare_accept_i3d_checkplot.iff
lites here:dtmprepare_accept_i3d_heightnodes.lcm
enable mode flow
set symbol_scale 0.5
set arrow_fc 101
set box_fc 102
set max_interval 70.0
set clip_tolerance 150
!go
