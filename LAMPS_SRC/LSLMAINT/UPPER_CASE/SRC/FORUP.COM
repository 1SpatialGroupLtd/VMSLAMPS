$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1985-06-03 14:51:08.000000000 +0100
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
$	if p1 .nes. "?" then goto noqueer
$	type sys$input
FOR/MARUP build command file

Switches are:-
  D - Compile, link with debug
  F - Make a FORUP (default, overrides M)
  M - Make a MARUP
$	goto rever
$noqueer: on error then goto tidy
$	ppp:='p1''p2''p3''p4''p5''p6''p7'
$	forup=1
$	if f$locate("M",ppp) .lt. f$length(ppp) then forup=0
$	if f$locate("F",ppp) .lt. f$length(ppp) then forup=1
$	debug:=
$	if f$locate("D",ppp) .lt. f$length(ppp) then debug:="/debug"
$	file_to_build:="forup"
$	if .not.forup then file_to_build:="marup"
$	set verify
$	adc 'file_to_build'=forup/tr=(forup='forup')
$	fortran'debug' 'file_to_build'
$	pvv 'file_to_build'
$	delete adc.ide;*
$	link/map'debug' 'file_to_build',lsl$library:violib/library
$	purge/log 'file_to_build'.*
$tidy:	xxx:='f$verify(0)'
$rever:	if ver then set verify
