$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-08-06 11:36:36.000000000 +0100
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
$! command file to create a new GKSUISLIB (multiple window)
$!
$ set noverify
$!
$	dbg = ""
$	inquire debug "with debug "
$	if debug then dbg = "/debug/noopt"
$!
$	inquire BLKD "Block data "
$	inquire LINE "GKS2       "
$	inquire AREA "GFA2       "
$	inquire TEXT "GTX2       "
$	inquire PIX "GCA2       "
$	inquire VS2  "VS2        "
$	inquire GKSCOL "GKSCOL2    "
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
$ if .not.debug then delete BLKDAT2.FOR;*
$noBLKD:if .not.LINE then goto noLINE
$	   ADC		GKS2=GKS2
$	   FORTRAN'dbg'	GKS2
$	   PVV		GKS2
$	   DELETE	ADC.IDE;*
$	   PURGE	GKS2.OBJ
$ if .not.debug then delete GKS2.FOR;*
$noLINE:if .not.AREA then goto noAREA
$	   ADC		GFA2=GFA2
$	   FORTRAN'dbg'	GFA2
$	   PVV		GFA2
$	   DELETE	ADC.IDE;*
$	   PURGE	GFA2.OBJ
$ if .not.debug then delete GFA2.FOR;*
$noAREA:if .not.TEXT then goto noTEXT
$	   ADC		GTX2=GTX2
$	   FORTRAN'dbg'	GTX2
$	   PVV		GTX2
$	   DELETE	ADC.IDE;*
$	   PURGE	GTX2.OBJ
$ if .not.debug then delete GTX2.FOR;*
$noTEXT:if .not.PIX then goto noPIX
$	   ADC		GCA2=GCA2
$	   FORTRAN'dbg'	GCA2
$	   PVV		GCA2
$	   DELETE	ADC.IDE;*
$	   PURGE	GCA2.OBJ
$ if .not.debug then delete GCA2.FOR;*
$noPIX:if .not.VS2 then goto noVS2
$	   ADC		VS2=VS2
$	   FORTRAN'dbg'	VS2
$	   PVV		VS2
$	   DELETE	ADC.IDE;*
$	   PURGE	VS2.OBJ
$ if .not.debug then delete VS2.FOR;*
$noVS2:if .not.GKSCOL then goto noGKSCOL
$	   ADC		GKSCOL2=GKSCOL2
$	   FORTRAN'dbg'	GKSCOL2
$	   PVV		GKSCOL2
$	   DELETE	ADC.IDE;*
$	   PURGE	GKSCOL2.OBJ
$ if .not.debug then delete GKSCOL2.FOR;*
$noGKSCOL:if .not.DUMMY then goto noDUMMY
$	   ADC		GKDUMM=GKDUMM
$	   FORTRAN'dbg'	GKDUMM
$	   PVV		GKDUMM
$	   DELETE	ADC.IDE;*
$	   PURGE	GKDUMM.OBJ
$ if .not.debug then delete GKDUMM.FOR;*
$NODUMMY:
$!
$! FILLSIDEQ replaces FILL_SIDE routine, but FILLSIDE.OBJ still required for
$! sorting routines
$ LIBRARY/CREATE=(BL:50) GKSUISLIB -
 BLKDAT2,GKS2,GFA2,GTX2,GCA2,VS2,GKSCOL2,GKDUMM,-
 LSL$SOURCE_ROOT:[LSLMAINT.GKSLDLIB.FILL]FILLSIDE,FILLSIDEQ,GKS_CLIP_POLY2
$!
$	set noverify
