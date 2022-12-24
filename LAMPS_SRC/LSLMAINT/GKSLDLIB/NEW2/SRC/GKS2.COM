$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-08-06 14:56:08.000000000 +0100
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
$! command file to create a new GKSLDLIB for two workstations
$!
$ set noverify
$!
$	dbg = ""
$	inquire debug "with debug "
$	if debug then dbg = "/debug/noopt"
$!
$	inquire BLKD  "Block data "
$	inquire LINE  "GKS2       "
$	inquire AREA  "GFA2       "
$	inquire TEXT  "GTX2       "
$	inquire PIX   "GCA2       "
$	inquire COL   "Colour table"
$	inquire DUMMY "Dummy      "
$!
$ set verify
$!
$	if .not.BLKD then goto noBLKD
$	   ADC		BLKDAT2=BLKDAT2
$	   FORTRAN'dbg'	BLKDAT2
$	   PVV		BLKDAT2
$	   DELETE	ADC.IDE;*
$	   PURGE	BLKDAT2.OBJ
$noBLKD:if .not.LINE then goto noLINE
$	   ADC		GKS2=GKS2
$	   FORTRAN'dbg'	GKS2
$	   PVV		GKS2
$	   DELETE	ADC.IDE;*
$	   PURGE	GKS2.OBJ
$noLINE:if .not.AREA then goto noAREA
$	   ADC		GFA2=GFA2
$	   FORTRAN'dbg'	GFA2
$	   PVV		GFA2
$	   DELETE	ADC.IDE;*
$	   PURGE	GFA2.OBJ
$noAREA:if .not.TEXT then goto noTEXT
$	   ADC		GTX2=GTX2
$	   FORTRAN'dbg'	GTX2
$	   PVV		GTX2
$	   DELETE	ADC.IDE;*
$	   PURGE	GTX2.OBJ
$noTEXT:if .not.PIX then goto noPIX
$	   ADC		GCA2=GCA2
$	   FORTRAN'dbg'	GCA2
$	   PVV		GCA2
$	   DELETE	ADC.IDE;*
$	   PURGE	GCA2.OBJ
$noPIX:if .not.COL then goto noCOL
$	   ADC		GKSCOL=GKSCOL
$	   FORTRAN'dbg'	GKSCOL
$	   PVV		GKSCOL
$	   DELETE	ADC.IDE;*
$	   PURGE	GKSCOL.OBJ
$noCOL:if .not.DUMMY then goto noDUMMY
$	   ADC		GKDUMM=GKDUMM
$	   FORTRAN'dbg'	GKDUMM
$	   PVV		GKDUMM
$	   DELETE	ADC.IDE;*
$	   PURGE	GKDUMM.OBJ
$NODUMMY:
$!
$!
$ if .not.debug then delete *.FOR;*
$!
$! FILLSIDEQ replaces FILL_SIDE routine, but FILLSIDE.OBJ still required for
$! sorting routines
$ LIBRARY/CREATE=(BL:50)  GKSLDLIB2  BLKDAT2,GKS2,GFA2,GTX2,GCA2,-
			GKSCOL,GKDUMM,[-.FILL]FILLSIDE,FILLSIDEQ
$!
