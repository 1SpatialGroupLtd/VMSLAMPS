$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-09-17 11:12:38.000000000 +0100
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
$	on error then continue
$!
$! Command file to initialise Laser-Scan IFF Manipulation Package MATRIX
$! Add DTIFROMTEXT for version 1.1 			JB 17-Sep-1993
$!
$! Allow for differences for OpenVMS Alpha AXP
$!
$	ARCH_NAME=F$GETSYI("ARCH_NAME")
$	ARCH_SUFFIX=""
$	IF ARCH_NAME.EQS."Alpha" THEN ARCH_SUFFIX="_TV"
$!
$! If MATRIXINI ? Q then they want Quiet, so we will also
$! skip the informational bit
$!
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
$ ws " "
$ ws "[0m[1m=========  Initialising Laser-Scan package 'MATRIX' Version 1.1 =========="
$ ws " "
$!
$ ws "[0m[7m"
$ WS " The MATRIX modules are:                                                  "
$ ws "                                                                          "
$ ws " DTI2TEXT       DTIBLEND       DTICOMBINE      DTICONVERT        DTIEDIT  "
$ ws "                                                                          "
$ ws " DTIPATCH       DTIROTATE      DTITILE         DTITRANS          DTIVIEW  "
$ ws "                                                                          "
$ ws " DTIFROMTEXT                                                              "
$ ws "                                                                          "
$ ws "[0m"
$!
$!
$ define_symbols:
$!
$ if p1.eqs."A"
$ then
$    ver = "TEK_ARGS"
$ endif
$!
$ if p1.eqs."S"
$ then
$    ver = "SIG6000"
$ endif
$!
$ if p1.nes."A" .and. p1.nes."S"
$ then
$    if f$trnlnm("DECW$DISPLAY").nes.""
$    then
$       ver = "MOTIF"
$    else
$       ver = "UIS"
$    endif
$ endif
$!
$	DTIBLEND	:== $LSL$EXE:DTIBLEND'ARCH_SUFFIX'
$	DTIEDIT		:== $LSL$EXE:DTIEDIT'ARCH_SUFFIX'
$	DTICOMBINE	:== $LSL$EXE:DTICOMBINE'ARCH_SUFFIX'
$	DTICONVERT	:== $LSL$EXE:DTICONVERT'ARCH_SUFFIX'
$	DTIPATCH	:== $LSL$EXE:DTIPATCH'ARCH_SUFFIX'
$	DTIROTATE	:== $LSL$EXE:DTIROTATE'ARCH_SUFFIX'
$	DTITILE		:== $LSL$EXE:DTITILE'ARCH_SUFFIX'
$	DTI2TEXT	:== $LSL$EXE:DTI2TEXT'ARCH_SUFFIX'
$	DTITRANS	:== $LSL$EXE:DTITRANS'ARCH_SUFFIX'
$	DTIVIEW		:== $LSL$EXE:DTIVIEW'ver''ARCH_SUFFIX'
$	DTIFROMTEXT	:== $LSL$EXE:DTIFROMTEXT'ARCH_SUFFIX'
$!
$	if ver_status then set verify
$!
