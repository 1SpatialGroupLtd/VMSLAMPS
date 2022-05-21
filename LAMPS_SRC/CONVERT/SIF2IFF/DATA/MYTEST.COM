$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-08-25 13:15:20.000000000 +0100
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
$ set nover
$ convertini q
$ define sys$input sys$command
$ sif2iff == "$lsl$source_root:[convert.sif2iff]sif2iff"
$ set ver
!$ sif2iff /debug/log/par=sif.fdf here:sifoutput.sif here:
!$ sif2iff /log/par=here:sif.fdf here:tji_test.sif here:tji_test
$ sif2iff /log/par=here:sif.fdf here:siftest2.sif here:sifoutput
$set nover
$pur
