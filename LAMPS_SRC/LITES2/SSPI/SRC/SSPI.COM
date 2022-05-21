$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-05-15 14:44:22.000000000 +0100
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
$! command file to build shared image for SSPI stereoplotter input to LITES2
$! VIAK version					PGH	14-May-1990
$!
$ Set verify
$!
$! first compile and link the shared image
$!
$ Fort DSR_SSPI.F
$ Purge DSR_SSPI.*
$!
$ Link/share/exe=LITES2SSPISHR/map=LITES2SSPISHR/full -
	sys$input:/opt
unsupported=1	! force demand_zero compression of shared images
DSR_SSPI
!
universal = DSR_INIT
universal = DSR_READ
universal = DSR_MOVE
universal = DSR_START
universal = DSR_TRN
$!
$ Purge LITES2SSPISHR.EXE,LITES2SSPISHR.MAP
$!
$! and now the test program
$!
$ Fort TEST_SSPI.F
$ Link TEST_SSPI,DSR_SSPI
$ Purge TEST_SSPI.*
$!
$ Set noverify
$!
