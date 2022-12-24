$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1984-12-18 18:38:10.000000000 +0000
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
$	INQUIRE WDBG "Debug"
$	DBG:=""
$	IF WDBG THEN DBG:="/DEBUG"
$	INQUIRE TEK "Tekci"
$	INQUIRE PIC "Picl,Cspeed,Chtest"
$	INQUIRE	WLNK "Link"
$	SET VER
$	if .not. TEK then goto NOTEK
$	mac tekcmd
$	adc tekci=tekci
$	fort'dbg'/noi4 tekci
$	pvv tekci
$	del tekci.for;*,adc.ide;*
$ NOTEK: if .not. PIC then goto NOPIC
$	adc picl=picl,cspeed,chtest
$	fort'dbg'/noi4 picl
$	pvv picl
$	del picl.for;*,adc.ide;*
$ NOPIC: if .not. WLNK then goto nolnk
	link'dbg'/map -
TEKCI,TEKCMD,PICL, -
WOSPLIB/INCLUDE=(LSCH)/LIB, -
LSL$LIBRARY:cmdlib/lib, -
LSL$LIBRARY:VIOLIB/LIB
$	pl tekci.*
$ nolnk: pl *.obj
$	set nover
$!
