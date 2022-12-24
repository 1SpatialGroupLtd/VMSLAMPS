$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1987-10-15 15:49:42.000000000 +0100
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
$	ver:='f$verify(0)'
$	if p1 .nes. "?" then goto nohlp
$	type sys$input:
Available switches are:

 D - Compile with DEBUG
 T - Link with testing CMDLIB
$	goto tidy_ver
$!
$nohlp:	deb=""
$	if f$locate("D",p1) .lt. f$length(p1) then deb="/debug"
$	cmdlib="lsl$library:cmdlib/lib,"
$	if f$locate("T",p1) .lt. f$length(p1) then cmdlib=-
					"cmdlib/lib,lsl$library:"
$	set verify
$	adc cvt=cvt
$	fortran'deb' cvt
$	pvv cvt
$	macro cvtcom
$	link/map'deb' cvt,cvtcom,'cmdlib'violib/lib
$	xxx:='f$verify(0)'
$	cvtt=="$''f$logical("here")'cvt"
$	sh sym cvtt
$grut:	set verify
$	purge/log
$	xxx:='f$verify(0)'
$tidy_ver: if ver then set verify
