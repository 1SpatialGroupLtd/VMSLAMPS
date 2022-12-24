$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-08-06 15:00:44.000000000 +0100
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
$!
$! command file to create a new GKSAEGLIB for one workstation
$!
$ ver = 'f$verify(0)
$ set noon
$!
$	dbg = ""
$	inquire debug "with debug "
$	if debug then dbg = "/debug/noopt"
$!
$	inquire BLKD	"Block data "
$	inquire CONTROL	"Control    "
$	inquire ESCAPE	"Escape     "
$	inquire TRANS	"Transforms "
$	inquire LINE	"Polyline   "
$	inquire MARKER	"Polymarker "
$	inquire AREA	"Fill Area  "
$	inquire GDP	"GDP        "
$	inquire UTIL	"Utilities  "
$	inquire AEG	"AEG        "
$!
$ set verify
$!
$	if .not.BLKD then goto noBLKD
$	   ADC		BLKDAT1=BLKDAT1
$	   FORTRAN'dbg'	BLKDAT1
$	   PVV		BLKDAT1
$	   DELETE	ADC.IDE;*
$	   PURGE	BLKDAT1.OBJ
$noBLKD:if .not.CONTROL then goto noCONTROL
$	   ADC		CONTROL=CONTROL
$	   FORTRAN'dbg'	CONTROL
$	   PVV		CONTROL
$	   DELETE	ADC.IDE;*
$	   PURGE	CONTROL.OBJ
$noCONTROL:if .not.ESCAPE then goto noESCAPE
$	   ADC		ESCAPE=ESCAPE
$	   FORTRAN'dbg'	ESCAPE
$	   PVV		ESCAPE
$	   DELETE	ADC.IDE;*
$	   PURGE	ESCAPE.OBJ
$noESCAPE:if .not.TRANS then goto noTRANS
$	   ADC		TRANS=TRANS
$	   FORTRAN'dbg'	TRANS
$	   PVV		TRANS
$	   DELETE	ADC.IDE;*
$	   PURGE	TRANS.OBJ
$noTRANS:if .not.LINE then goto noLINE
$	   ADC		LINE=LINE
$	   FORTRAN'dbg'	LINE
$	   PVV		LINE
$	   DELETE	ADC.IDE;*
$	   PURGE	LINE.OBJ
$noLINE:if .not.MARKER then goto noMARKER
$	   ADC		MARKER=MARKER
$	   FORTRAN'dbg'	MARKER
$	   PVV		MARKER
$	   DELETE	ADC.IDE;*
$	   PURGE	MARKER.OBJ
$noMARKER:if .not.AREA then goto noAREA
$	   ADC		AREA=AREA
$	   FORTRAN'dbg'	AREA
$	   PVV		AREA
$	   DELETE	ADC.IDE;*
$	   PURGE	AREA.OBJ
$noAREA:if .not.GDP then goto noGDP
$	   ADC		GDP=GDP
$	   FORTRAN'dbg'	GDP
$	   PVV		GDP
$	   DELETE	ADC.IDE;*
$	   PURGE	GDP.OBJ
$noGDP:if .not.UTIL then goto noUTIL
$	   ADC		UTIL=UTIL
$	   FORTRAN'dbg'	UTIL
$	   PVV		UTIL
$	   DELETE	ADC.IDE;*
$	   PURGE	UTIL.OBJ
$noUTIL:if .not.AEG then goto noAEG
$	   ADC		AEG=AEG
$	   FORTRAN'dbg'	AEG
$	   PVV		AEG
$	   DELETE	ADC.IDE;*
$	   PURGE	AEG.OBJ
$noAEG:
$!
$ if .not.debug then delete *.FOR;*
$!
$! FILLSIDEQ replaces FILL_SIDE routine, but FILLSIDE.OBJ still required for
$! sorting routines
$ LIBRARY/CREATE=(BL:50) GKSAEGLIB -
		BLKDAT1,CONTROL,ESCAPE,TRANS,-
		LINE,MARKER,AREA,GDP,UTIL,AEG,-
		[LSLMAINT.GKSLDLIB.FILL]FILLSIDE,FILLSIDEQ
$!	'F$VERIFY(0)
$	IF VER THEN SET VERIFY
$!
