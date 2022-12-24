$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-09-01 09:58:52.000000000 +0100
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
$ inquire DSR "Compile DSR"
$ inquire KRISS "Compile KRISS"
$ inquire LKRISS "Link KRISS"
$ sd obj
$ if DSR
$ then
$   open/write tr spot.tr
$   write tr "SPOT = 0"
$   close tr
$   adc xdsr_dummy=spot.tr/tr,lsl$source_root:[lites2.kern]dsr_dummy
$   fortran xdsr_dummy
$   pvv xdsr_dummy
$   delete spot.tr;*,adc.ide;*,xdsr_dummy.for;*
$   pl xdsr_dummy.obj
$ endif
$!
$ if KRISS
$ then
$   adc xkriss_dummy=lsl$source_root:[lites2.kern]kriss_dummy
$   fortran xkriss_dummy
$   pvv xkriss_dummy
$   delete adc.ide;*,xkriss_dummy.for;*
$   pl xkriss_dummy.obj
$ endif
$!
$ if LKRISS
$ then
$   sd obj:
$   link/share/exe=exe:lites2kriss_dummyshr/map=lites2kriss_dummyshr/full -
	sys$input:/opt, -
	lsl$library:lslshr/opt
UNSUPPORTED=1
XDSR_DUMMY,XKRISS_DUMMY
!
universal = DSR_INIT
universal = DSR_READ
universal = DSR_MOVE
universal = DSR_START
universal = DSR_TRN
universal = KRISS_INIT
universal = KRISS_DISMOD
universal = KRISS_GPL
universal = KRISS_UPDATE
universal = KRISS_REFRSH
universal = KRISS_RFSTOP
universal = KRISS_VISIBLE
universal = KRISS_VECT
universal = KRISS_RECT
universal = KRISS_TRACK
universal = KRISS_STOP
universal = KRISS_SIDE
universal = KRISS_SUSPEND
universal = KRISS_REGIST
!
$   sd exe:
$   purge lites2kriss_dummyshr.exe,obj:lites2kriss_dummyshr.map
$ endif
$!
