$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-12-13 10:48:12.000000000 +0000
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
$! fetch all FPP sources from the CMS
$! (except the obj group, which only contains MAPIDs)
$ sd lsl$fpp_root:[000000]
$ CMS
fetch/nolog cmn /output=[cmn] ""
fetch/nolog com /output=[com] ""
fetch/nolog dev /output=[dev] ""
fetch/nolog hlp /output=[hlp] ""
fetch/nolog mar /output=[mar] ""
fetch/nolog src /output=[src] ""
$ exit
