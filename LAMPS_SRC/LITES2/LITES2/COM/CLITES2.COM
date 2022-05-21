$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-03 17:36:14.000000000 +0100
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
$! CLITES2.COM - LITES2 recompile and replace in library
$	SAVVER='f$verify(0)
$	set noon
$	if P2.eqs."" then inquire P2 "Module"
$	if P2.eqs."" then goto ERRXT
$	P2:='P2'
$	if P2.eqs."BLKDAT" then P1="D"
$	ws="write sys$output"
$	LIB="LITES2"
$	if P3.nes."" then LIB=P3
$	SRCDIR=f$trnlnm("SRC")
$	IF P3.nes."" then SRCDIR=SRCDIR-"SRC]"+P3+"]"
$	EFILE=SRCDIR
$	IF P3.nes."" then EFILE=EFILE+P3+"_"
$	EFILE=EFILE+P2+".SRC"
$	FFILE=f$search(EFILE)
$	if FFILE.nes."" then goto ok
$	  WS "File ",EFILE," does not exist"
$	  exit
$ok:	DEBSW=""
$	DELCOM="DELETE"
$	PIPSW=";*"
$       keepcom = ""              	! temporary 	rwr 5/3/93
$	if P1.nes."D" then goto nod
$	DEBSW="/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW)"
$	DELCOM="PURGE/NOLOG"
$	PIPSW=""
$	keepcom = "/co"			! temporary 	rwr 5/3/93
$	if P2.eqs."BLKDAT" then keepcom = ""
$nod:$	SAVDIR=f$environment("DEFAULT")
$	set def OBJ:
$	assign EXE:LITES2TR.MAR TR
$	set verify
$	ADC X'P2''keepcom'/CD:CMN:=TR:/TR,'EFILE'
$	FORTRAN/NOLIST'DEBSW' X'P2'
$	IF .NOT.$STATUS THEN GOTO EXIT
$	'DELCOM' X'P2'.FOR'PIPSW'
$	PVV X'P2'
$	DELETE ADC.IDE;*
$	LIBR/REPLACE/LOG 'LIB' X'P2'
$	IF $STATUS THEN DELETE X'P2'.OBJ;*
$EXIT:
$!	'f$verify(0)
$	set def 'SAVDIR'
$ERRXT:	if savver then set verify
