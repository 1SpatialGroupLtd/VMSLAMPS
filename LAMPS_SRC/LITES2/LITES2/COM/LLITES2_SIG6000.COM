$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1997-07-04 16:45:08.000000000 +0100
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
$! LLITES2.COM - LITES2 relink
$	savver='f$verify(0)
$	set noon
$	VER="LITES2"+P2
$	IF P2.EQS."" then VER = "LITES2SIG6000"
$	DEBSW=""
$	D=""
$	if P1.eqs."D" then DEBSW="/DEBUG"
$	if P1.eqs."D" then D="D"
$	ws="write sys$output"
$	sd obj:
$	assign EXE:LITES2TR.MAR TR
$	set verify
$!  ++++++++++++++++++++  Options  ++++++++++++++++++++
$	if P4.eqs."n" .or. P4.eqs."N" then goto no_new_date
$	RUN LSL$EXE:GENVER
$	ADC VERSION/CD:CMN:=TR:/TR,OBJ:VERSION
$	FORTRAN/NOLIST VERSION
$	PVV VERSION
$	DELETE VERSION.SRC;*,VERSION.FOR;*,ADC.IDE;*
$	PURGE/NOLOG VERSION.OBJ
$no_new_date:
$	ADC 'VER'.OPT=TR:/TR,COM:'VER'.LNK
$	PURGE/NOLOG 'VER'.OPT
$!
$	adc gctp = lsl$cmniff:md2dat
$	fort/nolist/debug/noopt gctp
$	pvv gctp
$	delete	adc.ide;*
$	delete gctp.for;*
$	purge/nolog obj:gctp.obj
$!
$	LIBR/REM=ABANDN LITES2
$	LIBR/REM=SUBVAR LITES2
$!  ++++++++++++++++++++  Linking  ++++++++++++++++++++
$	LINK'DEBSW'/NOMAP'P3'/EXE=EXE:'VER''D'  -
	SYS$INPUT:/OPT,-
	LSL$LIBRARY:FRTSHR/OPT,-
	LSL$LIBRARY:IFFSHR/OPT,-
	LSL$LIBRARY:LSLSHR/OPT,-
	LSL$LIBRARY:DTISHR/OPT,-
	OBJ:GCTP,-
	OBJ:'VER'/OPTIONS
 CLUSTER=SIG6000,,,-
	OBJ:SIG6000/INCLUDE=(TRITXT)
$	PURGE/NOLOG EXE:'VER''D'.EXE,OBJ:'VER'.MAP
$!	'f$verify(0)
$	sd .
$	if savver then set verify
