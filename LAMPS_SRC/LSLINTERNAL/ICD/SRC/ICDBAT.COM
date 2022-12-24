$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-06-23 12:20:24.000000000 +0100
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
$	VER:='F$VERIFY(0)
$	ERR:="F"
$	SET NOON
$	ON SEVERE  THEN GOTO END
$	ON ERROR   THEN ERR:="T"
$	ON CONTROL THEN GOTO END
$	IF ERR THEN GOTO END
$	SET VERIFY
$	LINK/MAP   ICD, -
	DRAW,DRWGRD,FINDPT,GARBAG,CLIP, -
	LSL$LIBRARY:LDLIB/LIB
$	MAPID ICD
$	DELETE ICD.MAP;*
$ END:
$	PUR ICD.EXE,.MAP
$	V:='F$VERIFY(VER)
