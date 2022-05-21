$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-12-13 11:48:44.000000000 +0000
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
$! To check a all FPP groups in CMS files against disk
$! Expects P1 (optionally) = D to delete files
$!
$ set noon
$ olddir = f$environment("DEFAULT")
$ set def lsl$source_root:[plotting.fpp]
$ @check_from_cms CMN 'P1'
$ @check_from_cms COM 'P1'
$ @check_from_cms DEV 'P1'
$ @check_from_cms HLP 'P1'
$ @check_from_cms MAR 'P1'
$ @check_from_cms OBJ 'P1'
$ @check_from_cms SRC 'P1'
$ set def 'olddir'
$ exit
