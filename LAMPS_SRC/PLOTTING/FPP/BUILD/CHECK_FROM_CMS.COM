$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-09 12:44:52.000000000 +0100
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
$! To check a group of CMS files against disk
$! Expects P1 = CMS group, P2 (optionally) = D to delete files
$!
$ set noon
$ if P1.eqs.""
$ then
$    write sys$output "Parameter 1 should be a CMS group name"
$    exit
$ endif
$ olddir = f$environment("DEFAULT")
$ set def lsl$source_root:[plotting.fpp]
$ if f$search("cms_temp.com").nes."" then delete cms_temp.com;*
$ CMS show elem 'P1' /output=cms_temp.com /format="$ @check_diff #e ''P1' ''P2'"
$ if f$search("cms_temp.com").nes.""
$ then
$    @cms_temp
$    delete cms_temp.com;*
$ endif
$ set def 'olddir'
$ exit
