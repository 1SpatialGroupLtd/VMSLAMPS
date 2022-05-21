$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1983-08-05 17:56:26.000000000 +0100
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
$	v:='f$verify(0)'
$	tits = 0
$	pdp = 0
$	ppp:='p1''p2''p3''p4''p5''p6''p7'
$	if f$locate("T",ppp) .lt. f$length(ppp) then tits = 1
$	if f$locate("P",ppp) .lt. f$length(ppp) then pdp = 1
$	on error then goto tidy
$	set verify
$	mac/rsx flrwvb
$	mac/rsx flboc
$	adc fmanip.ftn=rfbyte,rfword,rwfupd,spfadr,wfbyte,wfword
$	f4p fmanip=fmanip
$	pvr fmanip
$	if .not.pdp then adc rdtitl.ftn=getitm,rdfilt
$	if .not.pdp then f4p rdtitl=rdtitl
$	if .not.pdp then pvr rdtitl
$	adc pvr.ftn=pvr
$	f4p pvr=pvr
$	pvr pvr
$	if .not.pdp then del pvr.ftn;*,fmanip;*,rdtitl;*,adc.ide;*
$	if pdp then del pvr.ftn;*,fmanip;*,adc.ide;*
$	xxx:='f$verify(0)'
$	open/write bld bld.cmd
$	wb:=write bld
$	if .not.pdp then wb "pvr,pvr/-sp=pvr,rdtitl,flrwvb,flboc,fmanip"
$	if pdp then wb "pvr.tsk/fp,pvr.pmp/-sp=pvr,flrwvb,flboc,fmanip"
$	wb "sys$library:liolib/lb"
$	if tits then wb "sys$library:tits/da"
$	if .not.pdp then wb "sys$library:f4pots/lb"
$	if pdp then wb "sys$library:f4plib/lb"
$	wb "/"
$	wb "task=...pvr"
$	wb "//"
$	close bld
$	set verify
$	mcr tkb @bld
$	del bld.cmd;*
$tidy:	purge
$	xxx:='f$verify(0)'
$	if v then set verify
