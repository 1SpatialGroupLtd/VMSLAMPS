$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-04-19 10:57:38.000000000 +0100
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
$ rfort:=$sys$system:rdbpre/fortran
$ if p1 .eqs. "" then inq/nop p1 "File ?"
$ set verify
$ adc 'p1'.rfo/co='p1'
$ rfort/deb/noopt/lis/check=(bound,overflow) 'p1'
$ purge/nolog 'p1'.for,'p1'.obj','p1'.lis
$ library/replace/log  flowline 'p1'
$ if .not.vvv then set noverify
