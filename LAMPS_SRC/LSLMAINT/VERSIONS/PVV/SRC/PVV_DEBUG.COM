$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1995-01-23 15:05:46.000000000 +0000
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
$	if p1.nes."?" then goto not_help
$	type sys$input:
Command file to regenerate PVV

Switches, as usual (nowadays!) in P1 only

 D - Compile, assemble, link with debug
 NF - Don't do the Fortran bit
 NM - Don't do the Macro bit

Default is to compile and link the whole caboodle
$	goto tidy_ver
$!
$not_help: ass=1
$	if f$locate("NM",p1).lt.f$length(p1) then ass=0
$	p1=p1-"NM"
$	compile=1
$	if f$locate("NC",p1).lt.f$length(p1) then compile=0
$	p1=p1-"NC"
$	debug=0
$	if f$locate("D",p1).lt.f$length(p1) then debug=1
$	p1=p1-"D"
$	if p1.nes."" then write sys$output "*** Unexpected switches """,p1,""""
$	adeb=""
$	if debug then adeb="/de"
$	deb=""
$	noopt=""
$	if debug then deb="/debug"
$	if debug then noopt="/noopt"
$	mdeb=""
$	if debug then mdeb="/en=(deb)"
$	on error then goto tidy
$	if .not.ass then goto try_compile
$	set verify
$	macro'mdeb' rmsio
$	xxx:='f$verify(0)'
$try_compile: if .not. compile then goto link
$	set verify
$	adc pvv=cfstr'adeb',getfile,pvv'adeb',rdide'adeb'
$	fortran'deb''noopt' pvv
$	pvv pvv
$	xxx:='f$verify(0)'
$link:	set verify
$	link'deb'/map pvv,rmsio,lsl$library:violib/lib
$tidy:	xxx:='f$verify(0)'
$	set verify
$	purge/log
$tidy_ver: xxx:='f$verify(0)'
$	if ver then set verify
