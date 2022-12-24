$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1987-09-04 15:12:06.000000000 +0100
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
$	VER='F$VERIFY(0)
$	ON CONTROL THEN GOTO TIDY
$	SET NOON
$	ERR:="F"
$!
$	INQUIRE COMP "Compile"
$	IF .NOT.COMP THEN GOTO A10
$	  INQUIRE  LIS "Listings"
$	  IF .NOT. LIS THEN LIS:=""
$	  IF       LIS THEN LIS:="/LIST"
$!
$ A10:
$	INQUIRE LNK "Build"
$	IF .NOT.LNK THEN GOTO A20
$	  INQUIRE MAP "Map"
$	  IF      MAP THEN INQUIRE CRF "Cross reference"
$	  IF .NOT.MAP THEN M:=""
$	  IF      MAP THEN M:="/MAP"
$	  IF      MAP THEN IF CRF THEN M:="/MAP/CROSS"
$ A20:
$	INQUIRE  DBG "Debug"
$	IF .NOT. DBG THEN FDBG:=""
$	IF .NOT. DBG THEN DBG:=""
$	IF       DBG THEN FDBG:="/DEBUG/NOOPT/CHECK=(BOUN,OVER)"
$	IF       DBG THEN DBG:="/DEBUG"
$	IF .NOT. COMP THEN GOTO NOCOMP
$!
$	  ASSIGN 'F$LOGICAL("HERE")' CMN
$	  SET VERIFY
$	  ADC IFJ/CO=IFJ,ADDNOD
$	  FORT/NOI4 'FDBG 'LIS IFJ
$	  IF .NOT.$STATUS THEN ERR:="T"
$	  IF .NOT.ERR     THEN PVV IFJ
$	  PURGE IFJ.LIS,.FOR,.OBJ
$	  DELETE ADC.IDE;*
$	  V:='F$VERIFY(0)
$ NOCOMP:
$	IF ERR THEN GOTO TIDY
$	IF .NOT. LNK THEN GOTO TIDY
$	  SET VERIFY
$	  LINK 'DBG 'M IFJ, -
	  LSL$LIBRARY:IFFLIB /LIB, -
	  LSL$LIBRARY:VIOLIB /LIB
$	  PURGE IFJ.EXE
$	  IF MAP THEN PURGE IFJ.MAP
$ TIDY:
$	VER:='F$VERIFY(VER)
