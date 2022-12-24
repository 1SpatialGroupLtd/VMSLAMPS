$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-06-14 16:52:40.000000000 +0100
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
$! fetch the FPP things required to build a GKS shareable from CMS
$! P1 = name of GKS version e.g. POSTSCRIPT
$ sd lsl$fpp_root:[000000]
$ CMS
fetch/nolog gksshr.com /output=[com] ""
fetch/nolog gksshr.opt /output=[dev] ""
fetch/nolog gksvec.mar /output=[mar] ""
fetch/nolog gksdum.src /output=[src] ""
fetch/nolog fpp.com /output=[com] ""
$ CMS fetch/nolog fpp'p1'.opt,'p1'blk.src/output=[dev] ""
$ exit
