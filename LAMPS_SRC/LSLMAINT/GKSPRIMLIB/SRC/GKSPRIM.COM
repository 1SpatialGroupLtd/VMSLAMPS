$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-09-01 13:19:22.000000000 +0100
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
$ STATE:='F$VERIFY(0)'
$!
$! Command file to create a new GKSPRIMLIB for one workstation
$!
$! Created	26-Apr-1989	(stolen from GKSLDLIB.COM)
$! Last edited	26-Apr-1989	[JHR]
$!
$ set noon
$!
$	assign	lsl$source_root:[lslmaint.gksprimlib]	cmn
$	assign	cmn					fppcmn
$	cmsold = f$trnlnm("CMS$LIB")
$	cms
	SET LIBRARY lsl$source_root:[plotting.fpp.cmslib]
	FETCH efnlun.par ""
	EXIT
$	if cmsold.nes."" then define CMS$LIB 'cmsold'
$!
$	dbg = ""
$	inquire debug "with debug "
$	if debug then dbg = "/debug/noopt"
$!
$	inquire BLOCK "Block data "
$	inquire DUMMY "Dummy	  "
$	inquire LINE  "GKS1       "
$	inquire AREA  "GFA1       "
$!
$!
$ if .not.BLOCK then goto noBLOCK
$	   SET VERIFY
$	   ADC		BLKDAT1=BLKDAT1
$	   FORTRAN'dbg'	BLKDAT1
$	   PVV		BLKDAT1
$	   DELETE	ADC.IDE;*
$	   PURGE	BLKDAT1.OBJ, BLKDAT1.FOR
$	   STATE:='F$VERIFY(0)'
$noBLOCK:
$!
$ if .not.DUMMY then goto noDUMMY
$	   SET VERIFY
$	   ADC		GKDUMM=GKDUMM
$	   FORTRAN'dbg'	GKDUMM
$	   PVV		GKDUMM
$	   DELETE	ADC.IDE;*
$	   PURGE	GKDUMM.OBJ, GKDUMM.FOR
$	   STATE:='F$VERIFY(0)'
$noDUMMY:
$!
$ if .not.LINE then goto noLINE
$	   SET VERIFY
$	   ADC		GKS1=GKS1
$	   FORTRAN'dbg'	GKS1
$	   PVV		GKS1
$	   DELETE	ADC.IDE;*
$	   PURGE	GKS1.OBJ, GKS1.FOR
$	   STATE:='F$VERIFY(0)'
$noLINE:
$!
$ if .not.AREA then goto noAREA
$	   SET VERIFY
$	   ADC		GFA1=GFA1,GKS_CLIP_AREA
$	   FORTRAN'dbg'	GFA1
$	   PVV		GFA1
$	   DELETE	ADC.IDE;*
$	   PURGE	GFA1.OBJ, GFA1.FOR
$	   STATE:='F$VERIFY(0)'
$noAREA:
$!
$ if .not.debug then delete *.FOR;*
$!
$! FILLSIDEQ replaces FILL_SIDE routine, but FILLSIDE.OBJ still required for
$! sorting routines
$ SET VERIFY
$ LIBRARY/CREATE=(BL:50) GKSPRIMLIB BLKDAT1,GKS1,GFA1,GKDUMM,-
 LSL$SOURCE_ROOT:[LSLMAINT.GKSLDLIB.FILL]FILLSIDE,FILLSIDEQ,GKS_CLIP_POLY2
$ PURGE/KEEP=2 GKSPRIMLIB.OLB
$!
$	   STATE:='F$VERIFY(0)'
$	   DELETE EFNLUN.PAR;*
$	   DEASS CMN
$	   DEASS FPPCMN
$!
