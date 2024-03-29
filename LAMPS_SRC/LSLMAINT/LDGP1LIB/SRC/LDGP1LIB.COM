$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-02-20 15:43:28.000000000 +0000
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
$	VER='F$VERIFY(0)
$	ASSIGN LSL$SOURCE_ROOT:[LSLMAINT.LDGP1LIB]    CMN"
$	NOVER=0
$	MAXCOUNT = 5
$	ON ERROR THEN GOTO END
$!
$	LDGP1L="HERE:LDGP1LIB"
$	INQUIRE DEBUG "Debug"
$	IF .NOT.DEBUG THEN DEBUG=""
$	IF      DEBUG THEN DEBUG="/DEBUG"
$!	IF	DEBUG.NES.""  THEN LDGP1L ="HERE:LDGP1DLIB"
$	OPTIM=1
$	IF DEBUG .NES. "" THEN INQUIRE OPTIM "Optimisation"
$	IF .NOT.OPTIM THEN DEBUG=DEBUG + "/NOOPT"
$	CHECKS = 0
$	IF DEBUG .NES. "" THEN INQUIRE CHECKS "Checks"
$	IF CHECKS THEN DEBUG=DEBUG + "/CHECK=(BOUNDS,OVERFLOW)"
$
$	INQUIRE NEW	"Create new library"
$	REP=0
$	IF .NOT.NEW THEN INQUIRE REP	"Replace in library"
$	IF .NOT.NEW THEN GOTO NONEW
$	  SET VERIFY
$	  LIBRARY 'LDGP1L'/CREATE=(BLOCKS:20)
$	  IF VER.NE.1 THEN SET NOVERIFY
$NONEW:
$!
$	MOD0="LDINIT,LDFPPM,UNITS,ORIGIN"
$	MOD1="DIFRAM,PEN,THICK"
$	MOD2="MOVTO,LINTO"
$	MOD3="LDWAIT"
$	MOD4="DASHED,DOTTED,CHARS,CHSIZE"
$	MOD5="SET_LOGICAL"
$!
$	COUNT=0
$ A:
$	ANS'COUNT'=1
$	COUNT=COUNT+1
$	IF COUNT.LE.MAXCOUNT THEN GOTO A
$!
$	TRNMAC = 1
$
$	INQUIRE  ALL	"Compile ALL modules"
$	IF ALL THEN GOTO COMPILE
$!
$	COUNT=0
$ AA:	
$	ANS'COUNT'=0
$	COUNT=COUNT+1
$	IF COUNT.LE.MAXCOUNT THEN GOTO AA
$!
$	COUNT=0
$	ON CONTROL_Y THEN GOTO COMPILE
$ NXTMOD:
$	XXX=MOD'COUNT'
$	IF COUNT.GT.0 THEN GOTO NOTXT
$	INQUIRE/nop  ANS'COUNT' "Compile: ''XXX'  ? "
$	GOTO NXTONE
$ NOTXT:
$	INQUIRE/NOP ANS'COUNT'  "         ''XXX'  ? "
$ NXTONE:
$	COUNT=COUNT+1
$	IF COUNT.LE.MAXCOUNT THEN GOTO NXTMOD
$!
$ COMPILE:
$	ON CONTROL_Y THEN GOTO END
$	COUNT=0
$ AAA:
$	IF .NOT.ANS'COUNT' THEN GOTO NXTC
$	  XXX=MOD'COUNT'
$	  SET VERIFY
$	  ADC FILE'COUNT'='XXX'
$	  FORT'DEBUG' FILE'COUNT'
$	  PVV FILE'COUNT'
$	  IF VER.NE.1 THEN SET NOVERIFY
$	  IF REP.OR.NEW THEN LIBRARY 'LDGP1L'/REP/LOG FILE'COUNT'
$	  IF "''DEBUG'".EQS."" THEN DELETE/LOG FILE'COUNT'.FOR;*
$	  IF "''DEBUG'".NES."" THEN IF F$SEARCH("*.FOR;-1").NES."" THEN -
	  PURGE/LOG FILE'COUNT'.FOR
$	  DELETE ADC.IDE;*
$ NXTC:
$	COUNT=COUNT+1
$	IF COUNT.LE.MAXCOUNT THEN GOTO AAA
$!
$ PL:
$	PURGE/LOG *.OBJ
$	IF .NOT.(NEW.OR.REP) THEN GOTO NOCOMPRESS
$	LIBRARY/COMPRESS 'LDGP1L'
$	SET FILE/TRUNCATE 'LDGP1L'.OLB
$ NOCOMPRESS:
$	IF F$SEARCH("''LDGP1L'.OLB").NES."" THEN PURGE/LOG 'LDGP1L'.OLB
$	IF NEW.OR.REP THEN DELETE/LOG FILE*.OBJ;*
$END:
$	IF VER.EQ.1 THEN SET VERIFY
$	IF VER.EQ.0 THEN SET NOVERIFY
