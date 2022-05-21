$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-03-24 11:48:24.000000000 +0000
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
$ CREATE/DIR/LOG 'DISC'[LSLMAINT.LSLLIB.'p1'.COMMANDS]
$ CREATE/DIR/LOG 'DISC'[LSLMAINT.LSLLIB.'p1'.ERRORS]
$ CREATE/DIR/LOG 'DISC'[LSLMAINT.LSLLIB.'p1'.EXPC]
$ CREATE/DIR/LOG 'DISC'[LSLMAINT.LSLLIB.'p1'.FILENAME]
$ CREATE/DIR/LOG 'DISC'[LSLMAINT.LSLLIB.'p1'.IFF]
$ CREATE/DIR/LOG 'DISC'[LSLMAINT.LSLLIB.'p1'.INIT]
$ CREATE/DIR/LOG 'DISC'[LSLMAINT.LSLLIB.'p1'.IO]
$ CREATE/DIR/LOG 'DISC'[LSLMAINT.LSLLIB.'p1'.LSLDCL]
$ CREATE/DIR/LOG 'DISC'[LSLMAINT.LSLLIB.'p1'.MAGTAPE]
$ CREATE/DIR/LOG 'DISC'[LSLMAINT.LSLLIB.'p1'.MESSAGE]
$ CREATE/DIR/LOG 'DISC'[LSLMAINT.LSLLIB.'p1'.NUMBERS]
$ CREATE/DIR/LOG 'DISC'[LSLMAINT.LSLLIB.'p1'.SHARE]
$ CREATE/DIR/LOG 'DISC'[LSLMAINT.LSLLIB.'p1'.SORT]
$ CREATE/DIR/LOG 'DISC'[LSLMAINT.LSLLIB.'p1'.STRING]
$ CREATE/DIR/LOG 'DISC'[LSLMAINT.LSLLIB.'p1'.SYSTEM]
$ CREATE/DIR/LOG 'DISC'[LSLMAINT.LSLLIB.'p1'.TEST]
$ CREATE/DIR/LOG 'DISC'[LSLMAINT.LSLLIB.'p1'.TXTC]
$ CREATE/DIR/LOG 'DISC'[LSLMAINT.LSLLIB.'p1'.WORK]
