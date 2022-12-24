$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-09-04 16:56:42.000000000 +0100
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
$	if f$logical("LSL$CMNIOFFSET") .eqs. "" then -
	assign 'f$dir()' lsl$cmnioffset
$	ppp=p1+p2+p3+p4+p5+p6+p7
$	debug:="/debug"
$	noopt:="/noopt"
$!	debug:=
$!	noopt:=
$	main=0
$	proc=0
$	misc=0
$	loop=0
$	lnk=0
$	cld=0
$	len=f$length(ppp)
$	if f$locate("DEB",ppp) 	.lt.	len then debug:="/debug"
$	if f$locate("DEB",ppp)	.lt.	len then noopt:="/check=bounds/noopt"
$	if f$locate("MAIN",ppp) .lt.	len then main=1
$	if f$locate("PROC",ppp) .lt.	len then proc=1
$	if f$locate("LOOP",ppp) .lt.	len then loop=1
$	if f$locate("MISC",ppp) .lt.	len then misc=1
$	if f$locate("CLD",ppp) .lt.	len then cld=1
$	if f$locate("LINK",ppp) .lt.	len then lnk=1
$	if f$locate("ALL",ppp)  .lt.	len then goto all
$	if len .gt. 0 then goto start
$all:
$	main=1
$	proc=1
$	loop=1
$	misc=1
$	cld=1
$	obey=1
$	lnk=1
$start: ver=f$verify(1)
$	on error then goto endit
$	set verify
$	if .not. main then goto do_proc
$	adc ioffset=ioffset
$	fortran'debug''noopt' ioffset
$	pvv ioffset
$do_proc:
$	if .not. proc then goto do_loop
$	adc process=process,offset
$	fortran'debug''noopt' process
$	pvv process
$do_loop:
$	if .not. loop then goto do_misc
$	adc rmloop=remove_rev,intsct
$	fortran'debug''noopt' rmloop
$	pvv rmloop
$do_misc:
$	if .not. misc then goto do_cld
$	adc misc=add2nf,get_command,getwid,getftr,putftr
$	fortran'debug''noopt' misc
$	pvv misc
$do_cld:
$	if .not. cld then goto do_link
$	adc ioffset.tmp=ioffset.cld
$	set command/object=ioffset_cld ioffset.tmp
$	pvv ioffset_cld
$	delete ioffset.tmp;*
$do_link:
$	if .not. lnk then goto endit
$	link'debug'/map/cross	ioffset,process,rmloop,misc,ioffset_cld,-
	lsl$library:ifflib/lib,lsllib/lib
$endit:	set noverify
$	if ver then set verify
$	delete adc.ide;*
$!	delete *.map;
$	if debug .nes. "" then exit
$	delete ioffset.for;*
$!	purge/keep=2 *.*
