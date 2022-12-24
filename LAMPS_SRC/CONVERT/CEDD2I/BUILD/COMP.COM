$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-08-25 21:08:00.000000000 +0100
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
$	savver = f$verify(0)
$!
$	set noverify
$!
$	if p1.eqs."" then exit
$	file =	f$parse(p1,,,"node") + -
		f$parse(p1,,,"device") + -
		f$parse(p1,,,"directory") + -
		f$parse(p1,,,"name")
$!
$	fqual = f$edit(p2,"UPCASE")
$	if fqual.eqs."DEBUG" then fqual = -
		"/debug/noopt/check=(bounds,overflow,underflow)"
$!
$	set verify
$!
$	adc 'file'/co = 'file'
$	fort'fqual' 'file'
$	pvv 'file'
$	savver = f$verify(savver)
