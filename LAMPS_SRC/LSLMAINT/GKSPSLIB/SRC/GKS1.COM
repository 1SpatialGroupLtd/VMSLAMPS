$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-03-17 12:30:24.000000000 +0000
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
$! command file to create a new GKSPSLIB for one workstation
$!
$ set noverify
$!
$	dbg = ""
$	inquire debug "with debug "
$	if debug then dbg = "/debug/noopt"
$!
$	inquire BLKD "Block data "
$	inquire LINE "GKS1       "
$	inquire AREA "GFA1       "
$	inquire TEXT "GTX1       "
$	inquire PIX "GCA1       "
$	inquire GDP "GDP1       "
$	inquire GKSCOL "GKSCOL     "
$	inquire DUMMY "Dummy      "
$	inquire PS "Postscript "
$	inquire PROC "PS procs   "
$	inquire HP "HP-GL/2    "
$	inquire PSLIB "PS library "
$	inquire HPLIB "HP library "
$!
$ set verify
$!
$	if .not.BLKD then goto noBLKD
$	   FORTRAN'dbg'	BLKDAT1.F
$	   PURGE	BLKDAT1.OBJ
$noBLKD:if .not.LINE then goto noLINE
$	   FORTRAN'dbg'	GKS1.F
$	   PURGE	GKS1.OBJ
$noLINE:if .not.AREA then goto noAREA
$	   FORTRAN'dbg'	GFA1.F+GKS_CLIP_AREA.F
$	   PURGE	GFA1.OBJ
$noAREA:if .not.TEXT then goto noTEXT
$	   FORTRAN'dbg'	GTX1.F
$	   PURGE	GTX1.OBJ
$noTEXT:if .not.PIX then goto noPIX
$	   FORTRAN'dbg'	GCA1.F
$	   PURGE	GCA1.OBJ
$	   MACRO	LSG_LOOP
$	   PURGE	LSG_LOOP.OBJ
$noPIX:if .not.GDP then goto noGDP
$	   FORTRAN'dbg'	GDP1.F
$	   PURGE	GDP1.OBJ
$noGDP:if .not.GKSCOL then goto noGKSCOL
$	   FORTRAN'dbg'	GKSCOL.F+LSG_SIZE.F
$	   PURGE	GKSCOL.OBJ
$noGKSCOL:if .not.DUMMY then goto noDUMMY
$	   FORTRAN'dbg'	GKDUMM.F
$	   PURGE	GKDUMM.OBJ
$noDUMMY:if .not.PS then goto noPS
$	   FORTRAN'dbg'	PS.F
$	   PURGE	PS.OBJ
$	   FORTRAN'dbg'	DPS.F
$	   PURGE	DPS.OBJ
$	   CC'dbg'	DPS_C
$	   PURGE	DPS_C.OBJ
$	   MACRO	FONTCMD
$	   PURGE	FONTCMD.OBJ
$noPS:if .not.PROC then goto noPROC
$	   CALL 	PROCESS_PROC PROCSET.POSTSCRIPT PS_WRITE_PROCSET.F
$	   PURGE	PS_WRITE_PROCSET.F
$	   PID		PS_WRITE_PROCSET.F
$	   FORTRAN'dbg'	PS_WRITE_PROCSET.F
$	   PURGE	PS_WRITE_PROCSET.OBJ
$noPROC:if .not.HP then goto noHP
$	   FORTRAN'dbg'	HP.F
$	   PURGE	HP.OBJ
$noHP:
$!
$! FILLSIDEQ replaces FILL_SIDE routine, but FILLSIDE.OBJ still required for
$! sorting routines
$ if PSLIB then LIBRARY/CREATE=(BL:50) [--.LIB]GKSPSLIB -
 BLKDAT1,GKS1,GFA1,GTX1,GCA1,LSG_LOOP,GDP1,GKSCOL,GKDUMM,-
 PS,PS_WRITE_PROCSET,DPS,DPS_C,FONTCMD, -
 LSL$SOURCE_ROOT:[LSLMAINT.GKSLDLIB.FILL]FILLSIDE,FILLSIDEQ,GKS_CLIP_POLY2
$ if HPLIB then LIBRARY/CREATE=(BL:50) [--.LIB]GKSHPGL2LIB -
 BLKDAT1,GKS1,GFA1,GTX1,GCA1,LSG_LOOP,GDP1,GKSCOL,GKDUMM,HP, -
 LSL$SOURCE_ROOT:[LSLMAINT.GKSLDLIB.FILL]FILLSIDE,FILLSIDEQ,GKS_CLIP_POLY2
$	PURGE [--.LIB]
$!
$	set noverify
$	exit
$!
$! Subroutine reads PS procset file and writes it out as
$! a Fortran subroutine. Trailing PS comments are stripped, as
$! are lines like <whitespace>% This is a comment
$! Comments without the space are retained
$PROCESS_PROC: SUBROUTINE
$	set noverify
$	open/write w 'P2'
$	open/read r 'P1'
$	ww = "write w"
$!
$	ww	"	SUBROUTINE	PS_WRITE_PROCSET"
$	ww	"CDEC$	IDENT	'01JA94'"
$	ww	"	IMPLICIT NONE"
$!
$NEXT:	read/end=END r line
$	ppos = f$locate("%",line)
$	if (ppos.gt.0 .and. ppos.lt.f$length(line))
$	then
$STRIP:	  ppos = ppos-1
$	  if (ppos.lt.0) then goto NEXT
$	  c = f$extract(ppos,1,line)
$	  if (c.eqs." " .or. c.eqs."	") then goto STRIP
$	  line = f$extract(0,ppos+1,line)
$	endif
$	ww	"	CALL FLWSTR('",line,"')"
$	goto NEXT
$!
$END:	ww	"	RETURN"
$	ww	"	END"
$!
$	close r
$	close w
$	set verify
$	exit
$	ENDSUBROUTINE
