$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1989-02-03 17:36:20.000000000 +0000
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
$	CHARGE J14699
$	ASSIGN NL: TR
$	ON CONTROL THEN GOTO END
$	IF "''F$LOGICAL("FORMAT_LCM$BATTING")'" .EQS. "" -
	  THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$!
$ A0:
$	DEFINE/GROUP FORMAT_LCM$BATTING "IN_PROGRESS"
$	ASSIGN LSL$SOURCE_ROOT:[LITES2.FORMAT_LCM] EXE
$	ASSIGN LSL$SOURCE_ROOT:[LITES2.FORMAT_LCM] SRC
$	SD LSL$SOURCE_ROOT:[LITES2.FORMAT_LCM]
$	SET NOON
$!
$!  +++++++++++++++++ compare CLD file  +++++++++++++++++
$	ADC FORMAT_LCM.TMP=FORMAT_LCM_CLD.CLD
$	SET COMMAND/OBJECT=FORMAT_LCM_CLD FORMAT_LCM.TMP
$	OK=$STATUS
$	IF OK THEN PVV FORMAT_LCM_CLD
$	OK=$STATUS
$	PURGE FORMAT_LCM_CLD.OBJ
$	DEL FORMAT_LCM.TMP;*
$!
$!  +++++++++++++++++  Compile FORMAT_LCM  +++++++++++++++++
$	ADC FORMAT_LCM/CO= FORMAT_LCM
$!	FORTRAN/NOLIST/DEBUG/NOOPT/OBJECT=FORMAT_LCM SRC:FORMAT_LCM
$	FORTRAN/NOLIST/OBJECT=FORMAT_LCM SRC:FORMAT_LCM
$	PURGE FORMAT_LCM.OBJ
$	DELETE ADC.IDE;*
$	ADC FORMAT_LCM.OPT=TR:/TR,SRC:FORMAT_LCM.LNK
$	PURGE FORMAT_LCM.OBJ
$	PURGE FORMAT_LCM.FOR
$!
$!  ++++++++++++++++++++  Linking  ++++++++++++++++++++
$!	LINK/MAP/DEBUG/EXE=EXE:FORMAT_LCM  FORMAT_LCM/OPTIONS
$	LINK/MAP/EXE=EXE:FORMAT_LCM  FORMAT_LCM/OPTIONS
$	PURGE EXE:FORMAT_LCM.EXE
$	PURGE FORMAT_LCM.MAP
$	DELETE FORMAT_LCM.OPT;*
$ END:
$	DEASS/GROUP FORMAT_LCM$BATTING
$	SD .
