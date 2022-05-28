$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-02-16 18:56:28.000000000 +0000
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
$	V='f$verify(0)
$	CMDOPN=1
$	open/read INPUT1 'f$logical("SYS$COMMAND")'
$	on warning then goto END1
$	OLDLINE=""
$!
$! Alan Wylie's command file to append a name to the header at the top
$! of a listing
$! amended, 16 May 1985, by TJI - refer to LSTVAX explicitly, rather than
$! the old compatability version program
$!
$! P1 is the name, and P2 is the file
$!
$	if P1 .eqs. "" then inquire P1 "WHO"
$	if P1 .nes. "" then goto A0
$	  if V then set verify
$	  exit %X110
$ A0:
$	NOP2=(P2.EQS."")
$	IF .NOT.NOP2 THEN GOTO A3
$ A2:
$	read/end=END1/prompt="LST>" INPUT'CMDOPN' P2
$	if P2.eqs."" then goto A2
$ A3:
$	LINE=P2
$	A=f$locate(",",LINE)
$	LINE=f$extract(0,A,P2)
$	P2=P2-LINE-","
$	if f$extract(0,1,LINE).nes."@" then goto A33
$	  LINE=f$parse(LINE-"@",".COM",,)
$	  CMDOPN=CMDOPN+1
$	  OLDLINE=""
$	  open/read/error=A3 INPUT'CMDOPN' 'LINE'
$	  goto A2
$ A33:
$	a=f$locate("/",LINE)
$	LINE1F=f$extract(0,A,LINE)
$	LINE1S=f$extract(A,1000,LINE)
$	LINE1F=f$parse(LINE1F,,OLDLINE,)
$	DUNONE=0
$	if LINE1F.nes."" then goto A35
$	  LINE1F=LINE
$	  goto A5
$ A35:
$	OLDLINE=LINE1F
$	OLDLINE2=""
$ A4:
$	LINE2=F$SEARCH(LINE1F)
$	if LINE2.eqs."" then goto A5
$	if LINE2.eqs.OLDLINE2 then goto A5
$	OLDLINE2=LINE2
$	DUNONE=1
$	write SYS$OUTPUT LINE2
$	temp_lst = "$lsl$exe:lstvax"
$	temp_lst 'LINE2''LINE1S'/T'P1'
$	goto A4
$ A5:
$	if .not.DUNONE then write SYS$OUTPUT "*** No such file(s) as ",LINE1F
$	if CMDOPN.ne.1 then goto A2
$	if P2.nes.""  then goto A3
$	if NOP2 then goto A2
$ END1:
$	if CMDOPN.eq.1 then goto A6
$	  close INPUT'CMDOPN'
$	  CMDOPN=CMDOPN-1
$	  goto A5
$ A6:	close INPUT1
$	if V then set verify
