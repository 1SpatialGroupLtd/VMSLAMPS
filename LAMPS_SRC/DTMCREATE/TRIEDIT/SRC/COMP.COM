$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-29 13:35:14.000000000 +0100
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
$ vvv=f$verify(0)
$ if p1 .eqs. "" then inq/nop p1 "File ?"
$ ass lsl$source_root:[dtmcreate.service.src] lsl$dtmcreatesys
$ ass lsl$source_root:[dtmcreate.triedit.src] lsl$cmntriedit
$ set verify
$ adc 'p1'/co='p1'
$ fort/deb/noopt/lis/check=(bound,overflow) 'p1'
$ ok=$status
$ if ok then pvv 'p1'
$ if ok then librarian/replace/log triedit_fortran_sources 'p1'
$ purge/nolog 'p1'.for,'p1'.obj','p1'.lis
$ if .not.vvv then set noverify
