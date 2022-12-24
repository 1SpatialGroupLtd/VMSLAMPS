$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1987-04-14 12:00:58.000000000 +0100
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
$	NOVER=0
$	MAXCOUNT = 2
$	ON ERROR THEN GOTO END
$!
$	B_BOX="HERE:B_BOX_LIB"
$	DEBF =""			! not debug files
$	INQUIRE DEBUG "Debug"
$	IF .NOT.DEBUG THEN DEBUG=""
$	IF      DEBUG THEN DEBUG="/DEBUG"
$	IF	DEBUG.NES.""  THEN B_BOX ="HERE:B_BOX_D_LIB"
$	IF	DEBUG.NES.""  THEN DEBF="D"
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
$	  LIBRARY 'B_BOX'/CREATE=(BLOCKS:20)
$	  IF VER.NE.1 THEN SET NOVERIFY
$NONEW:
$!
$	MOD0="B_BOX_SET_AST"
$	MOD1="B_BOX_AST"
$	MOD2="B_BOX_WRITE"
$!
$	COUNT=0
$ A:
$	ANS'COUNT'=1
$	COUNT=COUNT+1
$	IF COUNT.LE.MAXCOUNT THEN GOTO A
$!
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
$	  YYY:=FILE'DEBF''COUNT'
$	  SET VERIFY
$	  ADC 'YYY'='XXX'
$	  FORT'DEBUG' 'YYY'
$	  PVV 'YYY'
$	  IF REP.OR.NEW THEN LIBRARY 'B_BOX'/REP/LOG 'YYY'
$	  IF "''DEBUG'".EQS."" THEN DELETE/LOG 'YYY'.FOR;*
$	  IF "''DEBUG'".NES."" THEN IF F$SEARCH("*.FOR;-1").NES."" THEN -
	  PURGE/LOG 'YYY'.FOR
$	  IF VER.NE.1 THEN SET NOVERIFY
$	  DELETE ADC.IDE;*
$ NXTC:
$	COUNT=COUNT+1
$	IF COUNT.LE.MAXCOUNT THEN GOTO AAA
$!
$! compress library
$	LIBR/COMP 'B_BOX'
$	SET FILE/TRUNCATE/LOG 'B_BOX'.OLB
$	PURGE/LOG *.OLB
$	PURGE/LOG *.OBJ
$	IF F$SEARCH("'B_BOX'").NES."" THEN PURGE/LOG 'B_BOX'.OLB
$	IF NEW.OR.REP THEN DELETE/LOG *.OBJ;*
$END:
$	IF VER.EQ.1 THEN SET VERIFY
