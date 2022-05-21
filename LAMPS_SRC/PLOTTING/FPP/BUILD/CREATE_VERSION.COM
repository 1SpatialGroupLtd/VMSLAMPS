$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-12-13 11:40:38.000000000 +0000
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
$ DISK = "LSL$SOURCE_ROOT:"
$!
$ CREATE/DIR/LOG 'DISC'[PLOTTING.FPP.'p1'.CMN]
$ CREATE/DIR/LOG 'DISC'[PLOTTING.FPP.'p1'.COM]
$ CREATE/DIR/LOG 'DISC'[PLOTTING.FPP.'p1'.DEV]
$ CREATE/DIR/LOG 'DISC'[PLOTTING.FPP.'p1'.EXE]
$ CREATE/DIR/LOG 'DISC'[PLOTTING.FPP.'p1'.HLP]
$ CREATE/DIR/LOG 'DISC'[PLOTTING.FPP.'p1'.MAR]
$ CREATE/DIR/LOG 'DISC'[PLOTTING.FPP.'p1'.OBJ]
$ CREATE/DIR/LOG 'DISC'[PLOTTING.FPP.'p1'.SRC]
$!
