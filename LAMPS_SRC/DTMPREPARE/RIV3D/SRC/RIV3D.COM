$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1986-09-25 14:45:32.000000000 +0100
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
$! command file to create RIV3D image
$!
$	set noverify
$	on error then goto fred
$	deb :=
$	fdeb:=
$	rfor:=
$	pmestr :=
$!
$	inquire dbg    "fortran with debug"
$	if .not.dbg then goto nodbg
$	  fdeb := "/deb"
$	  inquire rfor "retain .FOR files "
$	  inquire nop  "no optimisation   "
$	  if nop then fdeb := "/deb/noop"
$!
$nodbg:	inquire mar   "macro cmds   (RIV3DCMD)            	"
$	inquire fl1   "chkbox,chkcon,chkmap,segint		"
$	inquire fl2   "divbox,divsec,rdfnam,rdrang		"
$	inquire fl3   "getstr,getnods,ndtorv,nodhgts,stoipt	"
$	inquire fl4   "getcmds,help,minmax,state,uppercase	"
$	inquire fl5   "riv3d,getrivs,setrivs,wrtrivs,appriv	"
$!
$	inquire dbg   "link with debug"
$	if .not.dbg then goto nolbg
$	   deb := "/deb"
$	   goto start
$!
$nolbg:	inquire dopme "link with pme  "
$	if .not.dopme then goto start
$	   assign	sys$sysdisk:[sysmgr.util]	pme
$	   deb := "/debug=pme:pme"
$	   pmestr:= ",starlet/lib"
$!
$start:	set verify
$!
$	if .not.mar then goto nomar
$	macro RIV3DCMD
$!
$nomar:	if .not.fl1 then goto nofl1
$	adc R3D1 = chkbox,chkcon,chkmap,segint
$	for'fdeb' R3D1
$	pvv R3D1
$	delete adc.ide;*
$	if .not.rfor then delete R3D1.for;*
$!
$nofl1:	if .not.fl2 then goto nofl2
$	adc R3D2 = divbox,divsec,rdfnam,rdrang
$	for'fdeb' R3D2
$	pvv R3D2
$	delete adc.ide;*
$	if .not.rfor then delete R3D2.for;*
$!
$nofl2:	if .not.fl3 then goto nofl3
$	adc R3D3 = getstr,getnods,ndtorv,nodhgts,stoipt
$	for'fdeb' R3D3
$	pvv R3D3
$	delete adc.ide;*
$	if .not.rfor then delete R3D3.for;*
$!
$nofl3:	if .not.fl4 then goto nofl4
$	adc R3D4 = getcmds,help,minmax,state,uppercase
$	for'fdeb' R3D4
$	pvv R3D4
$	delete adc.ide;*
$	if .not.rfor then delete R3D4.for;*
$!
$nofl4:	if .not.fl5 then goto nofl5
$	adc R3D5 = riv3d,getrivs,setrivs,wrtrivs,appriv
$	for'fdeb' R3D5
$	pvv R3D5
$	delete adc.ide;*
$	if .not.rfor then delete R3D5.for;*
$
$!
$! and link things
$!
$nofl5:
$	link'deb'/map/cross	R3D1,R3D2,R3D3,R3D4,R3D5,RIV3DCMD,-
				lsl$library:cmdlib/lib,-
				lsl$library:violib/lib,-
				ifflib/lib'pmestr'
$nolnk:	set noverify
$	pur *.obj,*.map
$	pl *.exe/keep=2
$	goto end
$fred:	set noverify
$end:
