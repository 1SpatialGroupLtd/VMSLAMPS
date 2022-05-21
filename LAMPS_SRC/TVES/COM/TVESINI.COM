$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1996-05-16 16:31:52.000000000 +0100
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
$	ver_status=f$verify(0)
$	on control then continue
$	on error then continue
$!
$! Command file to initialise Laser-Scan IFF Manipulation Package 'TVES'
$!
$!mod	Don't try to use UIS versions on DEC Alpha
$!	LAMPS WI/CC 1544, SPR3230				PGH/TJM	16/5/96
$!
$! Allow for differences for OpenVMS Alpha AXP
$!
$	ARCH_NAME=F$GETSYI("ARCH_NAME")
$	ARCH_SUFFIX=""
$	IF ARCH_NAME.EQS."Alpha" THEN ARCH_SUFFIX="_TV"
$!
$! If TVESINI ? Q then they want Quiet, so we will also
$! skip the informational bit
$!
$	if p1.eqs."Q" then goto define_symbols
$	if p2.eqs."Q" then goto define_symbols
$!
$! And lastly if they are on a non VT100 type terminal the reverse video
$! etc. may cause problems. Skip the informational bit.
$	if (.not.f$getdvi("TT:","TT_AVO")) then goto define_symbols
$!
$	ws="write sys$output"
$!
$!*****************************************************************
$!
$! Introduce the package with any relevant warnings of changes etc.
$!
$ ws "[0m[1m==========  Initialising Laser-Scan package 'TVES' Version 1.0 ==========="
$ ws " "
$!
$ ws "[0m[7m"
$ WS "The TVES modules are:                                                      "
$ ws "                                                                           "
$ ws "COVER          DTICHECK       DTICONTOUR       I2GRID                      "	
$ ws "PROFILE        ROVER          SLOPES           VECTORISE                   "
$ ws "                                                                           "
$ ws "[0m"
$!
$!
$define_symbols:
$!
$!	NB also ben3000, cal5800, pi448 and vrsc2v1 for ROVER
$!
$ if p1.eqs."A"
$ then
$    ver = "ARGS"
$ endif
$!
$ if p1.eqs."S"
$ then
$    ver = "SIG6000"
$ endif
$!
$ if p1.nes."A" .and. p1.nes."S" 
$ then
$!
$    if f$trnlnm("DECW$DISPLAY").nes."" .or. ARCH_NAME.eqs."Alpha"
$    then
$       ver = "MOTIF"
$    else
$       ver = "UIS"
$    endif
$ endif
$!
$	COVER		:== $LSL$EXE:COVER'ver''ARCH_SUFFIX'
$	DTICHECK	:== $LSL$EXE:DTICHECK'ARCH_SUFFIX'
$	DTICONTOUR	:== $LSL$EXE:DTICONTOUR'ARCH_SUFFIX'
$	I2GRID		:== $LSL$EXE:I2GRID'ARCH_SUFFIX'
$	PROFILE		:== $LSL$EXE:PROFILE'ARCH_SUFFIX'
$	ROVER		:== $LSL$EXE:ROVER'ver''ARCH_SUFFIX'
$       SLOPES		:== $LSL$EXE:SLOPES'ver''ARCH_SUFFIX'
$	VECTORISE	:== $LSL$EXE:VECTORISE'ARCH_SUFFIX'
$!
$! define a logical name for ROVER guidance files
$	DEFINE LSL$ROVERCMD LSL$SITE_ROOT:[ROVER.CMD]
$!
$	if ver_status then set verify
$!
