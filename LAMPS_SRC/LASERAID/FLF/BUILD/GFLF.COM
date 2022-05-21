$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1986-06-25 16:51:04.000000000 +0100
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
$! Command file to create truth and parameter files for Laseraid
$!
$!	Last edited				 DM	25-Jun-1986
$!	Created						19-Aug-1980
$!
$	IF F$LOGICAL("LSL$LAJMAKING").EQS."" THEN GOTO A1
$	WRITE SYS$OUTPUT "Someone else is MAKing"
$	EXIT
$ A1:	IF F$LOGICAL("LSL$LAJBATTING").EQS."" THEN GOTO A2
$	WRITE SYS$OUTPUT "Someone else is BATting"
$	EXIT
$ A2:	ON CONTROL THEN GOTO CONTROL
$!
$	MAKE 'P1' 'P2' 'P3' 'P4' 'P5' 'P6' 'P7'
$	MAKFIL EXE:PARAMS.COM
$	TRUTH  EXE:PARAMS.MAR
$	ASSIGN EXE:PARAMS.MAR TR
$	VAX=1
$	AREA==0
$	RASTER==0
$	MAKINQ NORMAL "Converged Laseraid (LAJ)"
$	IF NORMAL THEN GOTO A3
$	MAKINQ AREA   "Area-scan Laseraid (LAA)"
$	IF   AREA THEN GOTO A3
$	MAKINQ RASTER "Oxford raster scan (LAR)"
$ A3:
$!
$	WT "	.LIBRARY	/LSL$LIBRARY:LSLMACLIB/"
$	WT "VAX    = 1 ; VAX version"
$	IF	AREA   THEN WT "AREA   = 1 ; Area-scan Laseraid (LAA)"
$	IF .NOT.AREA   THEN WT "AREA   = 0 ; Not LAA"
$	IF	RASTER THEN WT "RASTER = 1 ; Oxford raster scan (LAR)"
$	IF .NOT.RASTER THEN WT "RASTER = 0 ; Not LAR"
$	MAKSET VAX
$	MAKSET AREA
$	MAKSET RASTER
$	WC "$	TRFILE==""",TRFILE,""""
$!
$	MAKCLO
$	EDIT/EDT/NOCOMM EXE:PARAMS.COM
DEL ALL "CHARGE"
EXIT
$	GOTO PUR
$ CONTROL:
$	CLOSE DATA
$	CLOSE TRUTH
$ PUR:
$	PURGE EXE:PARAMS.MAR,EXE:PARAMS.COM
