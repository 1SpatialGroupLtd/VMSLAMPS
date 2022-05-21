$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1989-05-17 13:35:06.000000000 +0100
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
$	if p1.nes."?" then goto no_queer
$	type sys$input:
Switches in P1 are:

 D - link with debug
 L - link only
 * - dummy switch so as to enable P2 to appear

If neither 'active' switch is given, the file both compiles and links.
P2 is the name of the file to compile. If it doesn't contain the string "VAX",
 VAX is appended to it (which may even prevent accidental compilation of PDP
 BCPL files!)
$	goto tidy_ver
$!
$no_queer: lk_only=0
$	if f$locate("L",p1).lt.f$length(p1) then lk_only=1
$	p1=p1-"L"
$	deb=""
$	if f$locate("D",p1).lt.f$length(p1) then deb="/debug"
$	p1=p1-"D"
$	p1=p1-"*"
$	if p1.nes."" then write sys$output "*** Silly switch values ",p1
$	if p1.nes."" then goto tidy_ver
$	if p2.eqs."ADC" then goto dont_mangle_adc
$	if f$locate("VAX",p2).ge.f$length(p2) then p2=p2+"VAX"
$dont_mangle_adc: if f$logical("bcplrts").nes."" then goto no_assign
$!
$! assign stuff from set-up file
$	write sys$output "$	bcplini"
$	bcplini
$!
$no_assign: on error then goto tidy_ver
$	if lk_only then goto link_it
$	if p2.nes."ADC" then goto not_adc
$	set verify
$	adc adc.hdr=adchdr.bcpl_src/co/ll:120/tr=(vax=1)
$	adc adc.bpl=adc.bcpl_src/co/ll:120/tr=(vax=1)
$	xxx:='f$verify(0)'
$	file_to_pur=""
$	if f$search("adc.ide;-1").nes."" then file_to_pur=file_to_pur+",adc.ide"
$	if f$search("adc.hdr;-1").nes."" then file_to_pur=file_to_pur+",adc.hdr"
$	if f$search("adc.bpl;-1").nes."" then -
					file_to_pur=file_to_pur+",adc.bpl"
$	file_to_pur=file_to_pur-","
$	if file_to_pur.eqs."" then goto not_adc
$	set verify
$	purge/log 'file_to_pur'
$	xxx:='f$verify(0)'
$not_adc: write sys$output "$	bcpl ",p2
$	define/user	sys$library		here:
$	bcpl 'p2'
$	if p2.eqs."ADC" then write sys$output "$	pvv ADC"
$	if p2.eqs."ADC" then pvv adc
$!
$link_it: set verify
$	link'deb'/map 'p2',bcplrts
$	xxx:='f$verify(0)'
$	if f$search("''p2'.*;-1").eqs."" then goto no_pur_1
$	set verify
$	purge/log 'p2'.*
$no_pur_1: xxx:='f$verify(0)'
$	if f$search("temp.ocd;-1").eqs."" then goto tidy_ver
$	set verify
$	purge/log temp.ocd
$tidy_ver: xxx:='f$verify(0)'
$	if ver then set verify
