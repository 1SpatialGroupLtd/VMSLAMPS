$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1989-09-25 14:02:40.000000000 +0100
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
$	if p1 .nes. "?" then goto no_queer
$	type sys$input:
Switches on command line are:

 B - recompile block-buffered record access stuff only
 D - enable DEBUG conditional; compile, link with debug
 F - (VAX version) assemble experimental FILEIO
 L - link only
 P - recompile PID and DITFIL only
 R - generate a version for the PDP-11 under RSX
 T - link with TITS (PDP version), or compile/link with debug (VAX version)
 V - generate a version for VAX under VMS (default: overrides R)

If neither compilation switch is given, both sets of modules are recompiled
$	goto restore_ver
$!
$no_queer: tits = 0
$	ncomp = 0
$	pdp = 0
$	dopid = 1
$	debug = 0
$	dobrec = 1
$	fileio = 0
$	if f$search("fileio.obj").eqs."" .and. f$search("fileio.mar").nes."" -
		then fileio = 1
$	ppp:='p1''p2''p3''p4''p5''p6''p7'
$	if f$locate("T",ppp) .lt. f$length(ppp) then tits = 1
$	if f$locate("F",ppp) .lt. f$length(ppp) then fileio = 1
$	if f$locate("L",ppp) .lt. f$length(ppp) then ncomp = 1
$	if f$locate("R",ppp) .lt. f$length(ppp) then pdp = 1
$	if f$locate("V",ppp) .lt. f$length(ppp) then pdp = 0
$	if f$locate("P",ppp) .lt. f$length(ppp) then dobrec = 0
$	if f$locate("B",ppp) .lt. f$length(ppp) then dopid = 0
$	if f$locate("D",ppp) .lt. f$length(ppp) then debug = 1
$	comsw=""
$	debsw=""
$	optsw=""
$	if debug .or. tits
$	then
$	  debsw="/debug"
$	  optsw="/noopt"
$	  comsw="/co"
$	endif
$	on error then goto restore_ver
$	if .not.fileio .or. pdp .or. f$search("fileio.mar").eqs."" then -
								goto try_pid
$	set verify
$	macro'debsw'	lsl$cmnvio:txtc+expc+here:fileio/obj=fileio
$	xxx:='f$verify(0)'
$	if f$search("fileio.obj;-1").eqs."" then goto try_pid
$	set verify
$	purge/log fileio.obj
$	xxx:='f$verify(0)'
$try_pid: if ncomp then goto link
$	if .not. dopid then goto try_brec
$	pf=""
$	if .not.pdp then pf=",wfbyte,[-.pvr]wfword"
$	set verify
$	adc pid'comsw'=pid/tr=(pdp='pdp',debug='debug'),ditfil'pf'
$	xxx:='f$verify(0)'
$	if pdp then goto pid_pdp
$	set verify
$	fortran'debsw''optsw' pid
$	pvv pid
$	xxx:='f$verify(0)'
$	pf="pid.obj"
$	if f$search("pid.for;-1").nes."" .and. (tits.or.debug) then -
							pf=pf+",.for"
$	df="adc.ide;*"
$	if .not.(tits.or.debug) then df=df+",pid.for;*"
$	set verify
$	purge/log 'pf'
$	delete/log 'df'
$	xxx:='f$verify(0)'
$	goto try_brec
$pid_pdp: set verify
$	f4p pid=pid.for
$	pvr pid
$	purge/log pid.obj
$	delete/log  pid.for;*,adc.ide;*
$	xxx:='f$verify(0)'
$try_brec: if .not.dobrec then goto link
$	set verify
$	adc brec'comsw'=brech/tr=(pdp='pdp',debug='debug'),brechs,brecwd,bsrech
$	xxx:='f$verify(0)'
$	if pdp then goto brec_pdp
$	set verify
$	fortran'debsw''optsw' brec
$	pvv brec
$	xxx:='f$verify(0)'
$	pf="brec.obj"
$	if f$search("brec.for;-1").nes."" .and. (tits.or.debug) then -
							pf=pf+",.for"
$	df="adc.ide;*"
$	if .not.(tits.or.debug) then df=df+",brec.for;*"
$	set verify
$	purge/log 'pf'
$	delete/log 'df'
$	xxx:='f$verify(0)'
$	goto link_vax
$brec_pdp: set verify
$	f4p brec=brec.for
$	pvr brec
$	purge/log brec.obj
$	delete/log  brec.for;*,adc.ide;*
$	xxx:='f$verify(0)'
$link:	if .not.pdp then goto link_vax
$	open/write bld bld.cmd
$	wb:=write bld
$	wb "pid.tsk/fp,pid.pmp/-sp=pid,brec"
$	wb "[lsl.vn.pvr]flrwvb,flboc,fmanip"
$	wb "lsl$library:liolib/lb"
$	if tits then wb "lsl$library:tits/da"
$	wb "lsl$library:f4plib/lb"
$	wb "/"
$	wb "task=...pid"
$	wb "//"
$	close bld
$	set verify
$	mcr tkb @bld
$	xxx:='f$verify(0)'
$	goto done
$link_vax: set verify
$	link'debsw'/map	pid,brec,-
			fileio,-
			lsl$library:cmdlib/lib,violib/lib
$done:	xxx:='f$verify(0)'
$	set verify
$	purge/log
$restore_ver: xxx:='f$verify(0)'
$	if ver then set verify
