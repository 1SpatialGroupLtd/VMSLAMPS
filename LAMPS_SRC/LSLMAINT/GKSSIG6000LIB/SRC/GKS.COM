$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1987-08-23 17:12:04.000000000 +0100
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
$! command file to create a new GKSSIGLIB for Sigma 6100
$!
$ set noverify
$!
$	dbg = ""
$	inquire debug "with debug "
$	if debug then dbg = "/debug/noopt"
$!
$	inquire BLKD "Block data   "
$	inquire LINE "GKS          "
$	inquire AREA "GFA          "
$	inquire CELL "GCA          "
$	inquire TEXT "GTX          "
$	inquire DUM  "Dummy        "
$	inquire COL  "Colour table "
$!
$ set verify
$!
$	if .not.BLKD then goto noBLKD
$	   ADC		BLKDAT=BLKDAT
$	   FORTRAN'dbg'	BLKDAT
$	   PVV		BLKDAT
$	   DELETE	ADC.IDE;*
$	   PURGE	BLKDAT.OBJ
$noBLKD:if .not.LINE then goto noLINE
$	   ADC		GKS=GKS
$	   FORTRAN'dbg'	GKS
$	   PVV		GKS
$	   DELETE	ADC.IDE;*
$	   PURGE	GKS.OBJ
$noLINE:if .not.AREA then goto noAREA
$	   ADC		GFA=GFA
$	   FORTRAN'dbg'	GFA
$	   PVV		GFA
$	   DELETE	ADC.IDE;*
$	   PURGE	GFA.OBJ
$noAREA:if .not.CELL then goto noCELL
$	   ADC		GCA=GCA
$	   FORTRAN'dbg'	GCA
$	   PVV		GCA
$	   DELETE	ADC.IDE;*
$	   PURGE	GCA.OBJ
$noCELL:if .not.TEXT then goto noTEXT
$	   ADC		GTX=GTX
$	   FORTRAN'dbg'	GTX
$	   PVV		GTX
$	   DELETE	ADC.IDE;*
$	   PURGE	GTX.OBJ
$noTEXT:if .not.DUM then goto noDUM
$	   ADC		GKDUMM=GKDUMM
$	   FORTRAN'dbg'	GKDUMM
$	   PVV		GKDUMM
$	   DELETE	ADC.IDE;*
$	   PURGE	GKDUMM.OBJ
$noDUM:if .not.COL then goto noCOL
$	   ADC		GKSCOL=GKSCOL
$	   FORTRAN'dbg'	GKSCOL
$	   PVV		GKSCOL
$	   DELETE	ADC.IDE;*
$	   PURGE	GKSCOL.OBJ
$noCOL:
$!
$ if .not.debug then delete *.FOR;*
$!
$ LIBRARY/CREATE=(BL:50)  GKSSIGLIB  BLKDAT,GKS,GFA,GCA,GTX,GKDUMM,GKSCOL
$!
