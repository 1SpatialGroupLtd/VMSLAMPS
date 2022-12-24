$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1982-05-26 11:02:02.000000000 +0100
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
$	ON ERROR THEN GOTO END
$!
$	REP=0
$	                 INQUIRE NEW "Create new library"
$	IF .NOT.NEW THEN INQUIRE REP "Replace in library"
$!
$	INQUIRE DDEB	"Debug"
$	IF .NOT.DDEB THEN DEB:=""
$	IF      DDEB THEN DEB:="/DEBUG"
$!
$	INQUIRE FRT	"Fortran (LDTXLIB)"
$	INQUIRE MCRO	"Macro   (LDTXFF)"
$!
$	IF .NOT.MCRO THEN GOTO NOMCRO
$	  SET VERIFY
$	  MACRO/RSX LDTXFF
$	  PIP LDTXFF.OBJ/PU
$	  IF REP THEN LIB/RSX LDTXLIB/REP LDTXFF
$	  V='F$VERIFY(0)
$ NOMCRO:
$	IF .NOT.FRT THEN GOTO NOFRT
$	  SET VERIFY
$	  ADC LDTXLIB=LDTXLIB
$	  F4P LDTXLIB=LDTXLIB.FOR
$	  PVR LDTXLIB
$	  PIP LDTXLIB.OBJ/PU
$	  DELETE ADC.IDE;*,LDTXLIB.FOR;*
$	  IF REP THEN LIB LDTXLIB/REP LDTXLIB
$	  V='F$VERIFY(0)
$ NOFRT:
$	IF .NOT.NEW THEN GOTO NONEW
$!
$	SET VERIFY
$	LIB/RSX LDTXLIB/CREATE=(BLOCKS:12,GLOBALS:50,MODULES:14)
$	LIB/RSX LDTXLIB/INSERT LDTXFF,LDTXLIB
$	PIP LDTXLIB.OLB/PU
$	V='F$VERIFY(0)
$!
$ NONEW:
$ END:	V='F$VERIFY(VER)
