$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-12-22 14:55:18.000000000 +0000
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
$	if p1.nes."?" then goto not_queery
$	type sys$input
File to compile and link new WIRE program

Switches, in p1, are single letters, and take values:

 A - recompile all .SRCs in the directory
 C - compress WW.OLB before link
 D - compile, link with debug
 L - do link (NB this isn't the standard way round for an RF-file)
 M - generate a WIREMOD (iff L)
 N - create a new WW.OLB (implies A)
 Y - re-assemble WIRECM
 Z - generate a WIRENEW

p2-p7 are names of modules to (re)compile, taken from:
		CHARZ,CTAPES,DIAG,DNDATE,FAULT,FORM,GETPIN,
		HEAD,INIT,INPUT,JCLIST,JSTAT,LIBSCN,LIBSET,
		LINOUT,MERGE,MOAN,MTAPES,NAME,ORDER,OUTPUT,PARTS,
		PUTIC,REFER,UNMULT,UPDATE,WIREMAIN,WIRERP
$	goto tidy_ver
$!
$not_queery: all_of_them=0
$	if f$locate("A",p1).lt.f$length(p1) then all_of_them=1
$	p1=p1-"A"
$	compress_lib=0
$	if f$locate("C",p1).lt.f$length(p1) then compress_lib=1
$	p1=p1-"C"
$	debsw:=
$	if f$locate("D",p1).lt.f$length(p1) then debsw:="/debug"
$	p1=p1-"D"
$	do_link=0
$	if f$locate("L",p1).lt.f$length(p1) then do_link=1
$	p1=p1-"L"
$	mod_=""
$	if f$locate("M",p1).lt.f$length(p1) then mod_="mod"
$	p1=p1-"M"
$	new_olb=0
$	if f$locate("N",p1).lt.f$length(p1) then new_olb=1
$	if new_olb then all_of_them=1
$	repsw="/replace"
$	if new_olb then repsw="/insert"
$	p1=p1-"N"
$	wire_new=0
$	if f$locate("Z",p1).lt.f$length(p1) then wire_new=1
$	if wire_new then mod_="new"
$	mod_main="main"
$	if mod_.nes."" then mod_main=mod_
$	p1=p1-"Z"
$	assemble_wirecm=0
$	if f$locate("Y",p1).lt.f$length(p1) then assemble_wirecm=1
$	p1=p1-"Y"
$	s:=
$	if f$length(p1).gt.1 then s="S"
$	if p1.nes."" then write sys$output -
		      "%WIRECOMMANDFIL-I-''f$length(p1)'MORECHARCTER",-
				 s,"THANNEEDED - """,p1,""" not decoded"
$	on error then goto tidy_ver
$	if .not.new_olb then goto no_new_olb
$!	pip /fr
$!	inquire/nopunc siz "Size for new library: "
$!	if siz.nes."" then siz="=bl:"+siz
$	set verify
$	lib/create'siz' ww
$	purge/log ww.olb
$	xxx:='f$verify(0)'
$no_new_olb: if all_of_them then goto do_em_all
$	if p2 .eqs. "" then goto try_assemble
$compile_one: fordel:=
$	if debsw.eqs."" then fordel=",.for;*"
$	adcsw=""
$	if debsw.nes."" then adcsw="/co"
$	fordeb=""
$	if debsw.nes."" then fordeb="/debug/noopt"
$	set verify
$	adc 'p2''adcsw'='p2'
$	fortran/i4'fordeb' 'p2'
$	pvv 'p2'
$	lib'repsw'/log ww 'p2'
$	delete/log adc.ide;*,'p2'.obj;*'fordel'
$	xxx:='f$verify(0)'
$	if debsw.eqs."" then goto not_to_pur_for
$	set verify
$	purge/log 'p2'.for
$	xxx:='f$verify(0)'
$not_to_pur_for: if .not.all_of_them then goto try_p3
$do_em_all: p2=f$search("*.src",1)
$	if p2.eqs."" then goto try_assemble
$	p2=f$parse(p2,,, "name")
$	goto compile_one
$try_p3: if p3.eqs."" then goto try_p4
$	p2=p3
$	p3:=
$	goto compile_one
$try_p4: if p4.eqs."" then goto try_p5
$	p2=p4
$	p4:=
$	goto compile_one
$try_p5: if p5.eqs."" then goto try_p6
$	p2=p5
$	p5:=
$	goto compile_one
$try_p6: if p6.eqs."" then goto try_p7
$	p2=p6
$	p6:=
$	goto compile_one
$try_p7: if p7.eqs."" then goto try_assemble
$	p2=p7
$	p7:=
$	goto compile_one
$try_assemble: if .not.assemble_wirecm then goto try_comp
$	set verify
$	macro wirecm
$	lib'repsw'/log ww wirecm
$	delete/log wirecm.obj;*
$	xxx:='f$verify(0)'
$try_comp: if .not.compress_lib then goto try_link
$	set verify
$	lib/compress ww
$	purge/log ww.olb
$	xxx:='f$verify(0)'
$try_link: if .not.do_link then goto tidy_ver
$	if mod_.eqs."mod" then mod_extn=".new"
$	set verify
$	link/exe=wire'mod_''mod_extn'/map=wire'mod_''debsw' -
			ww/incl=wire'mod_main'/lib, -
			lsl$library:cmdlib/lib,violib/lib
$	xxx:='f$verify(0)'
$	if mod_.nes."mod" then mod_extn=".exe"
$	set verify
$	purge/log wire'mod_''mod_extn',.map
$tidy_ver: xxx:='f$verify(0)'
$	if ver then set verify
