$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-06-16 11:12:42.000000000 +0100
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
$	CHARGE J14535
$	ASSIGN EXE:PARAMS.MAR TR
$	ON CONTROL THEN GOTO FLFEND
$	IF "''F$LOGICAL("LSL$LAJBATTING")'" .EQS. "" -
	  THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$!
$ A0:
$	DEFINE/GROUP LSL$LAJBATTING "IN_PROGRESS"
$	ASSIGN/TRANS=(CONCEALED,TERMINAL) -
	       LSL750$DUA0:[LSLSOURCE.LASERAID.] LSL$LASERAID_ROOT
$	ASSIGN LSL$LASERAID_ROOT LSL$DISK
$	ASSIGN LSL$DISK:[FLF.SOURCE] SRC
$	ASSIGN LSL$DISK:[FLF.MACRO] MAR
$	ASSIGN LSL$DISK:[FLF.COMMON] CMN
$	ASSIGN LSL$DISK:[FLF.LAJEXE] EXE
$	SD LSL$DISK:[FLF.LAJOBJ]
$	SET NOON
$	RUN LSL$DISK:[FLF.FLF]GENDAT
$	RENAME IDENT.SRC SRC:IDENT.SRC
$	PURGE SRC:IDENT.SRC
$	ADC IDENT/CD:CMN:=TR:/TR,SRC:IDENT
$	FORTRAN/NOI4/NOLIST IDENT
$	DELETE IDENT.FOR;*
$	PVV IDENT
$	DELETE ADC.IDE;*
$	PURGE IDENT.OBJ
$	ADC LAJ.OPT=TR:/TR,LSL$DISK:[FLF.FLF]FLF.LNK
$	PURGE LAJ.OPT
$!  ++++++++++++++++++++  Linking  ++++++++++++++++++++
$	LINK/DEBUG/MAP/EXE=EXE:LAJEXP  LAJ/OPTIONS
$	PURGE EXE:LAJEXP.EXE
$	PURGE LAJ.MAP
$ FLFEND:
$	DEASS/GROUP LSL$LAJBATTING
