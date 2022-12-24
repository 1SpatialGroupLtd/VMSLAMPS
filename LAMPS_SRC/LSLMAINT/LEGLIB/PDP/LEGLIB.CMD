;
; * This file is part of the LAMPS distribution, released as a software
; * preservation project to archive digital history for future historians.
; * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
; *
; * Timestamp of this file for the 2002 release was: 1980-06-03 10:40:48.000000000 +0100
; *
; * This program is free software: you can redistribute it and/or modify
; * it under the terms of the GNU General Public License as published by
; * the Free Software Foundation, version 3.
; *
; * This program is distributed in the hope that it will be useful, but
; * WITHOUT ANY WARRANTY; without even the implied warranty of
; * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
; * General Public License for more details.
; *
; * You should have received a copy of the GNU General Public License
; * along with this program. If not, see http://www.gnu.org/licenses/.
;
	.ENABLE LOWERCASE
	.ENABLE SUBSTITUTION
	.ENABLE GLOBAL
	 SET DEF [MARTIN.LEGLIB]
.;
	.IFNDF $M .ASK $M Assemble
	.IFNDF $F .ASK $F Compile
	.IFF $F .SETF $LC
	.IFNDF $LC .ASK $LC List /LEGEND/
	.IFNDF $L .ASK $L Build library
	.IFNDF $O .ASK $O One legenda option
.;
	.SETS X ".ONE"
	.IFF $O .SETS X ".LOT"
	.OPEN TR.SRC
	.DATA CODDAT = 1	; all code data of interest
	.DATA WINLEG = 0	; not using SOL''s window mechanism
	.IFT $O .DATA ONELEG = 1	; only one legenda file
	.IFF $O .DATA ONELEG = 0	; lots of legenda files
	.CLOSE
	PIP TR.SRC/PU
.;
	.IFF $M .GOTO 100
	PIP *.OBJ;*/DE
	MAC ADDLEG = TR.SRC,LEGEND,ERRORS,ADDLEG
	MAC FINCOD = TR.SRC,LEGEND,ERRORS,FINCOD
	MAC FINLEG = TR.SRC,LEGEND,ERRORS,FINLEG
	MAC FLRWVB = TR.SRC,LEGEND,ERRORS,FLRWVB
	MAC INILEG = TR.SRC,LEGEND,ERRORS,INILEG
	MAC RDLEGS = TR.SRC,LEGEND,ERRORS,RDLEGS
	PIP LEGLIB.OBM=*.OBJ
	PIP *.OBJ;*/DE
.;
.100:	.IFF $F .GOTO 200
	ADC LEGEND'X'/CO/LL:100=TR/TR,LEGEND.CMN
	.IFT $LC LST LEGEND'X'
	PIP LEGEND'X'/PU
	ADC LEGLIB.FTN = TR/TR,DRLEGS,LEGWRD,RDLEG
	F4P LEGLIB.OBF = LEGLIB
	PIP LEGLIB.FTN;*/DE
.;
.200:	.IFF $L .GOTO 900
	LBR LEGLIB'X'/CR:20=LEGLIB.OBF,LEGLIB.OBM
.;
.900:	PIP LEGLIB.*/PU
