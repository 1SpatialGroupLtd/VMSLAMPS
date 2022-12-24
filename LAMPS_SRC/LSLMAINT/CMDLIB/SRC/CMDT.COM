$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1984-11-07 10:48:54.000000000 +0000
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
$	ver:='f$verify(0)
$	if p1 .nes. "?" then goto noqueer
$	type sys$input
Permitted flags are:

 F - do FORTRAN compilation, then link
 L - just link
 M - do MACRO assembly, then link
 N - not testing CMDLIB - use library from LSL$LIBRARY:

If no flag set, everything is done
$	goto reset_ver
$noqueer: on error then goto xit
$	p1=p1+p2+p3+p4+p5+p6+p7
$	dofor=1
$	domar=1
$	libdir:=
$	viodir:="lsl$library:"
$	if f$locate("F",p1) .lt. f$length(p1) then domar = 0
$	if f$locate("M",p1) .lt. f$length(p1) then dofor = 0
$	if f$locate("L",p1) .lt. f$length(p1) then domar = 0
$	if f$locate("L",p1) .lt. f$length(p1) then dofor = 0
$	if f$locate("N",p1) .lt. f$length(p1) then libdir:="lsl$library:"
$	if libdir .nes. "" then viodir:=
$	xxx=f$logical("macro_library")
$	if xxx.eqs."" then assign 'f$logical("lsl$library")' macro_library
$	set verify
$	if .not.dofor then goto nofor
$	adc cmdtst=cmdtst
$	for/deb cmdtst
$	pvv cmdtst
$	del adc.ide;*,cmdtst.for;*
$nofor:	if .not.domar then goto nomac
$	mac cmdtt
$nomac:	link/deb/map cmdtst,cmdtt,'libdir'cmdlib/lib,'viodir'violib/lib
$	pl
$	zapexe cmdtst
$xit:	xxx:='f$verify(0)'
$reset_ver: if ver then set verify
