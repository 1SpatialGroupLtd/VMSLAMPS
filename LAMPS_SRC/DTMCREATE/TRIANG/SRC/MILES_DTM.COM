$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-01-08 12:14:26.000000000 +0000
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
$ @lsl$com:dtmcreateini
$ TRIANG
fileout lsl$bureau_root:[bureau.mobile]mobile_triang
enable graphics
enable diagnostics
max 60000
win -10 -10 31962.699 20061.40
zlimits 0 250
disable square
assign CLIFF_fc 2
filein lsl$bureau_root:[bureau.mobile]mobile_triang
go
$ trider
filein lsl$bureau_root:[bureau.mobile]mobile_triang
enable diagnostics
zlimits 0 250
go
$ TRIGRID
filein lsl$bureau_root[bureau.mobile]mobile_triang
enable diagnostics
window 0 0  31952.699 20051.40
sidelength 100 100
fileout mobile_trigrid
go
