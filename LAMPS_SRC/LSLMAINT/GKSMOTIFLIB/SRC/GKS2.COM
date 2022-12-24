$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-08-10 13:15:38.000000000 +0100
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
$! command file to create a new GKSMOTIFLIB (multiple window)
$!
$ set noverify
$!
$	dbg = ""
$	inquire debug "with debug "
$	if debug then dbg = "/debug/noopt"
$!
$	inquire BLKD "Block data "
$	inquire CONTROL "GKS2       "
$	inquire LINE "GPL2       "
$	inquire AREA "GFA2       "
$	inquire TEXT "GTX2       "
$	inquire PIX "GCA2       "
$	inquire DPS "DPS        "
$	inquire VS2  "VS2        "
$	inquire MENU  "MENU       "
$	inquire GKSCOL "GKSCOL2    "
$	inquire LSG_AUX "LSG_AUX    "
$	inquire GKS_CALL "GKS_CALL   "
$	inquire DUMMY "Dummy      "
$	inquire C "C routines "
$	inquire WRAP "Display PostScript wraps "
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
$noBLKD:if .not.CONTROL then goto noCONTROL
$	   ADC		GKS2=GKS2
$	   FORTRAN'dbg'	GKS2
$	   PVV		GKS2
$	   DELETE	ADC.IDE;*
$	   PURGE	GKS2.OBJ
$ if .not.debug then delete GKS2.FOR;*
$noCONTROL:if .not.LINE then goto noLINE
$	   ADC		GPL2=GPL2
$	   FORTRAN'dbg'	GPL2
$	   PVV		GPL2
$	   DELETE	ADC.IDE;*
$	   PURGE	GPL2.OBJ
$ if .not.debug then delete GPL2.FOR;*
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
$	   MACRO	LSG_LOOP
$	   PURGE	LSG_LOOP.OBJ
$ if .not.debug then delete GCA2.FOR;*
$noPIX:if .not.DPS then goto noDPS
$	   ADC		DPS=DPS
$	   FORTRAN'dbg'	DPS
$	   PVV		DPS
$	   DELETE	ADC.IDE;*
$	   PURGE	DPS.OBJ
$	   MACRO	FONTCMD
$	   PURGE	FONTCMD.OBJ
$ if .not.debug then delete DPS.FOR;*
$noDPS:if .not.VS2 then goto noVS2
$	   ADC		VS2=VS2
$	   FORTRAN'dbg'	VS2
$	   PVV		VS2
$	   DELETE	ADC.IDE;*
$	   PURGE	VS2.OBJ
$ if .not.debug then delete VS2.FOR;*
$noVS2:if .not.MENU then goto noMENU
$	   ADC		MENU=MENU
$	   FORTRAN'dbg'	MENU
$	   PVV		MENU
$	   DELETE	ADC.IDE;*
$	   PURGE	MENU.OBJ
$ if .not.debug then delete MENU.FOR;*
$noMENU:if .not.GKSCOL then goto noGKSCOL
$	   ADC		GKSCOL2=GKSCOL2
$	   FORTRAN'dbg'	GKSCOL2
$	   PVV		GKSCOL2
$	   DELETE	ADC.IDE;*
$	   PURGE	GKSCOL2.OBJ
$ if .not.debug then delete GKSCOL2.FOR;*
$noGKSCOL:if .not.LSG_AUX then goto noLSG_AUX
$	   ADC		LSG_AUX=LSG_AUX
$	   FORTRAN'dbg'	LSG_AUX
$	   PVV		LSG_AUX
$	   DELETE	ADC.IDE;*
$	   PURGE	LSG_AUX.OBJ
$ if .not.debug then delete LSG_AUX.FOR;*
$noLSG_AUX:if .not.GKS_CALL then goto noGKS_CALL
$	   MACRO	GKS_CALL
$	   PURGE	GKS_CALL.OBJ
$noGKS_CALL:if .not.DUMMY then goto noDUMMY
$	   ADC		GKDUMM=GKDUMM
$	   FORTRAN'dbg'	GKDUMM
$	   PVV		GKDUMM
$	   DELETE	ADC.IDE;*
$	   PURGE	GKDUMM.OBJ
$ if .not.debug then delete GKDUMM.FOR;*
$noDUMMY:if .not.C then goto noC
$	   CC'dbg'	GKS_C
$	   PURGE	GKS_C.OBJ
$	   CC'dbg'	DPS_C
$	   PURGE	DPS_C.OBJ
$NOC:if .not.WRAP then goto noWRAP
$	   PSWRAP/SOURCE_OUTPUT=ANSI_C WRAPS
$	   DELETE WRAPS.H;*
$	   EDIT/EDT/COMMAND=SYS$INPUT WRAPS.C
s/DPSPrivCurrentContext()/c/w
exit
$	   PURGE	WRAPS.C
$	   CC'dbg'	WRAPS
$	   PURGE	WRAPS.OBJ
$ if .not.debug then delete WRAPS.C;*
$NOWRAP:
$!
$! FILLSIDEQ replaces FILL_SIDE routine, but FILLSIDE.OBJ still required for
$! sorting routines
$ LIBRARY/CREATE=(BL:50) [--.LIB]GKSMOTIFLIB -
 BLKDAT2,GKS2,GPL2,GFA2,GTX2,GCA2,DPS,LSG_LOOP,VS2,MENU,GKSCOL2,LSG_AUX,-
 GKS_CALL,GKDUMM,GKS_C,DPS_C,WRAPS,FONTCMD, -
 LSL$SOURCE_ROOT:[LSLMAINT.GKSLDLIB.FILL]FILLSIDE,FILLSIDEQ,GKS_CLIP_POLY2
$!
$	set noverify
