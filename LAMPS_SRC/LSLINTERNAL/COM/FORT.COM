$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1984-03-08 12:52:48.000000000 +0000
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
$	V='F$VERIFY(0)
$	ON WARNING THEN EXIT
$	ON CONTROL THEN EXIT
$	FORTERR="T"
$	IF P1 .EQS. "" THEN EXIT
$ GOTFIL:
$	TTTFIL=P1
$	POS=F$LOC(".",P1)
$	IF POS.EQ.F$LEN(P1) THEN TTTFIL=P1+".SRC"
$	OPFILE=F$EXT(0,POS,P1)
$	IF F$SEARCH(TTTFIL).EQS."" THEN GOTO NOFIL
$	ALLP=P2+P3+P4+P5+P6+P7
$	M=""
$	C=""
$	D=""
$	A=""
$	IF F$LOCATE("M",ALLP).LT.F$LEN(ALLP) THEN M="/MACHINE"
$	IF F$LOCATE("C",ALLP).LT.F$LEN(ALLP) THEN C="/CROSS_REFERENCE"
$	IF F$LOCATE("Y",ALLP).GE.F$LEN(ALLP) THEN Y=""
$	IF F$LOCATE("D",ALLP).LT.F$LEN(ALLP) THEN D="/DEBUG"
$	IF D.NES."" THEN A="/CO"
$	SET NOON
$	ON CONTROL THEN GOTO END
$	SET VERIFY
$	ADC 'OPFILE'='P1''A'
$	FORT/LIST/CHECK=(BOUNDS,OVERFLOW)'D''M''C' 'OPFILE'
$	IF $SEVERITY THEN FORTERR="F"	! 'F$VERIFY(0)
$	IF FORTERR THEN GOTO END
$	SET VER
$	PVV 'OPFILE'
$ END:	!'F$VERIFY(0)
$	ON WARNING THEN CONTINUE
$	ON CONTROL THEN CONTINUE
$	IF F$LOCATE("K",ALLP).LT.F$LEN(ALLP).OR. -
	   F$LOCATE("C",ALLP).LT.F$LEN(ALLP).OR. -
	   F$LOCATE("X",ALLP).LT.F$LEN(ALLP).OR. -
	   F$LOCATE("Y",ALLP).LT.F$LEN(ALLP).OR. -
	   F$LOCATE("M",ALLP).LT.F$LEN(ALLP) THEN FORTERR="T"  ! keep
$	IF      FORTERR THEN PIP 'OPFILE'.LIS/NM,.FOR/NM/PU
$	IF .NOT.FORTERR THEN PIP 'OPFILE'.LIS;*/NM,.FOR;*/NM/DE
$	DELETE ADC.IDE;*
$	EXIT
$ NOFIL:
$	WRITE SYS$OUTPUT "No such file as ",OPFILE
