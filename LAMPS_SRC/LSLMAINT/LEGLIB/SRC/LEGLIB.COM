$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1984-11-08 15:28:38.000000000 +0000
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
$	ver = 'f$verify(0)
$!
$! command file to build VAX versions of Leglib
$! NOTE that these are now called legVlib (multiple legenda version)
$!      and legVone (single legenda version) so that they may be
$!      distinguished from the compatability mode versions
$!
$	DBG   = ""
$	LSTSW = ""
$!
$	inquire CMP "Compile"
$	inquire BLD "Build library"
$!
$	inquire DBG "Debug"
$	if DBG then DBG = "/DEBUG"
$!
$	inquire LST "Listing"
$	if LST then LSTSW = "/LIST"
$!
$	inquire ONE "One legenda option"
$	if      ONE then NAME="LEGVONE"
$	if .not.ONE then NAME="LEGVLIB"
$!
$	on error then goto QUIET
$	if .not.CMP then goto TRYBLD
$!
$! set up truth file
$!
$	open/write O [LIB.LEGLIB]TR.SRC
$	write O "VAX = 1"
$	write O "TXTVSP = 0"
$	if      ONE then write O "ONELEG = 1"
$	if .not.ONE then write O "ONELEG =0"
$	CLOSE O
$	PIP TR.SRC/NM/PU
$!
$! compile
$!
$	set verify
$	adc 'NAME'=tr.src/TR,addleg,drlegs,fincod,finleg,legwrd
$	adc 'NAME'/AP=tr.src/TR,rdleg,rdlegs
$	fort/NOI4'DBG''LST' 'NAME'
$	pvv 'NAME'
$	delete ADC.IDE;*
$	v = 'f$verify(0)
$! build
$TRYBLD:if .not.BLD then goto QUIET
$	set verify
$	LIB 'NAME'/CRE 'NAME'
$	v = 'f$verify(0)
$	pip 'NAME'.OBJ;*/NM/DE
$	if DBG.eqs."" then pip 'NAME'.FOR;*/NM/DE
$	if DBG.nes."" then pip 'NAME'.FOR/NM/PU
$	pip 'NAME'.LIS/NM,'NAME'.OLB/NM/PU
$QUIET:	v = 'f$verify(0)
$	if VER then set verify
