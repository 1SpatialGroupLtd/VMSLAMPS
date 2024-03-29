$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-06-23 12:18:56.000000000 +0100
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
$	ON ERROR   THEN GOTO ERR
$	ON CONTROL THEN GOTO ERR
$!
$	OPEN/WRITE B ICDBAT.COM
$!
$	WRITE B "$	VER:='F$VERIFY(0)"
$	WRITE B "$	ERR:=""F"""
$	WRITE B "$	SET NOON"
$	WRITE B "$	ON SEVERE  THEN GOTO END"
$	WRITE B "$	ON ERROR   THEN ERR:=""T"""
$	WRITE B "$	ON CONTROL THEN GOTO END"
$!
$	BLD:=""
$!
$	INQUIRE  SBAT "Submit for batch"
$!
$	INQUIRE  DEBUG "Debug"
$	IF .NOT. DEBUG THEN LDEBUG:=""
$	IF .NOT. DEBUG THEN DEBUG:=""
$	IF       DEBUG THEN LDEBUG:="/DEBUG"
$	IF       DEBUG THEN DEBUG:="/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW)"
$!
$	INQUIRE  COMP  "Compile"
$	IF .NOT. COMP THEN GOTO INQBLD
$!
$	INQUIRE  LIST "Listings"
$	IF .NOT. LIST THEN LIST:=""
$	IF       LIST THEN LIST:="/LIST"
$!
$	INQUIRE ICD
$	INQUIRE DRAW
$	INQUIRE DRWGRD
$	INQUIRE FINDPT
$	INQUIRE GARBAG
$	INQUIRE CLIP
$!
$ INQBLD:
$	INQUIRE  BLD "Link"
$	IF .NOT. BLD THEN GOTO COMP
$!
$	INQUIRE  MAP "Map"
$	IF .NOT. MAP THEN MAP:=""
$	IF       MAP THEN MAP:="/MAP"
$!
$ COMP:
$	IF .NOT. COMP THEN GOTO BLD
$!
$	WRITE B "$	SET VERIFY"
$!
$	IF .NOT. ICD THEN GOTO C1
$	WRITE B "$	ADC ICD=ICD2"
$	WRITE B "$	FORT ''LIST' ''DEBUG' ICD"
$	WRITE B "$	PVV ICD"
$	WRITE B "$	DELETE ICD.FOR;*,ADC.IDE;*"
$ C1:
$	IF .NOT. DRAW THEN GOTO C2
$	WRITE B "$	ADC DRAW=DRAW2"
$	WRITE B "$	FORT ''LIST' ''DEBUG' DRAW"
$	WRITE B "$	PVV DRAW"
$	WRITE B "$	DELETE DRAW.FOR;*,ADC.IDE;*"
$ C2:
$	IF .NOT. DRWGRD THEN GOTO C3
$	WRITE B "$	ADC DRWGRD=DRWGRD"
$	WRITE B "$	FORT ''LIST' ''DEBUG' DRWGRD"
$	WRITE B "$	PVV DRWGRD"
$	WRITE B "$	DELETE DRWGRD.FOR;*,ADC.IDE;*"
$ C3:
$	IF .NOT. FINDPT THEN GOTO C4
$	WRITE B "$	ADC FINDPT=FINDPT2"
$	WRITE B "$	FORT ''LIST' ''DEBUG' FINDPT"
$	WRITE B "$	PVV FINDPT"
$	WRITE B "$	DELETE FINDPT.FOR;*,ADC.IDE;*"
$ C4:
$	IF .NOT. GARBAG THEN GOTO C5
$	WRITE B "$	ADC GARBAG=GARBAG2"
$	WRITE B "$	FORT ''LIST' ''DEBUG' GARBAG"
$	WRITE B "$	PVV GARBAG"
$	WRITE B "$	DELETE GARBAG.FOR;*,ADC.IDE;*"
$ C5:
$	IF .NOT. CLIP THEN GOTO BLD
$	WRITE B "$	ADC CLIP=CLIP"
$	WRITE B "$	FORT ''LIST' ''DEBUG' CLIP"
$	WRITE B "$	PVV CLIP"
$	WRITE B "$	DELETE CLIP.FOR;*,ADC.IDE;*"
$ BLD:
$	IF .NOT.BLD THEN GOTO END
$!
$	WRITE B "$	IF ERR THEN GOTO END"
$	IF .NOT. COMP THEN WRITE B "$	SET VERIFY"
$!
$	WRITE B "$	LINK/MAP  ''LDEBUG' ICD, -"
$	WRITE B "	DRAW,DRWGRD,FINDPT,GARBAG,CLIP, -"
$	WRITE B "	LSL$LIBRARY:LDLIB/LIB"
$	WRITE B "$	MAPID ICD"
$	IF .NOT. MAP THEN WRITE B "$	DELETE ICD.MAP;*"
$ END:
$	WRITE B "$ END:"
$!
$	IF COMP THEN WRITE B "$	PUR *.OBJ,*.LIS
$	IF BLD  THEN WRITE B "$	PUR ICD.EXE,.MAP
$!
$	WRITE B "$	V:='F$VERIFY(VER)"
$!
$	CLOSE B
$!
$	PUR ICDBAT.COM
$!
$	IF       SBAT THEN BAT ICDBAT
$	IF .NOT. SBAT THEN @ICDBAT
$!
$	EXIT
$ ERR:
$	ON ERROR THEN CONTINUE
$	CLOSE B
$	PUR ICDBAT.COM
