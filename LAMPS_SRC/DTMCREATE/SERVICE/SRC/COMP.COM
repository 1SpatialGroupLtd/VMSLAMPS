$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-28 17:50:20.000000000 +0100
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
$ ass lsl$source_root:[dtmcreate.service.src] lsl$dtmcreatesys
$ if p1 .eqs. "" then inq/nop p1 "File? "
$ if p1.nes."" then call compiler 'p1'
$ exit
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ compiler: subroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc 'p1'/co='p1'
$	fort/deb/noopt/che=(b,o) 'p1'
$ 	ok=$status
$ 	if ok then pvv 'p1'
$ 	if ok then lib/rep/lo dtmcreate 'p1'
$ 	purge/nolog 'p1'.obj
$	purge/nolog 'p1'.for
$ 	delete adc.ide;*
$	set noverify
$	return
$ endsubroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
