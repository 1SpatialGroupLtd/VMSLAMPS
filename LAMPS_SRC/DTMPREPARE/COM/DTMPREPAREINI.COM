$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-01-07 18:12:18.000000000 +0000
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
$! Command file to initialise Laser-Scan IFF Manipulation Package 'DTMPREPARE'
$!
$! Allow for differences for OpenVMS Alpha AXP
$!
$	ARCH_NAME=F$GETSYI("ARCH_NAME")
$	ARCH_SUFFIX=""
$	IF ARCH_NAME.EQS."Alpha" THEN ARCH_SUFFIX="_TV"
$!
$! if we are not interactive, then don't output the explanation of what
$! DTMPREPARE is and does
$!
$	if f$mode().nes."INTERACTIVE" then goto define_symbols
$!
$! and if they have used DTMPREPARE Q then they want Quiet, so we will also
$! skip the informational bit
$!
$	if p1.eqs."Q" then goto define_symbols
$!
$! And lastly if they are on a non VT100 type terminal the reverse video
$! etc. may cause problems. Skip the informational bit.
$	if (.not.f$getdvi("TT:","TT_AVO")) then goto define_symbols
$!
$	ws="write sys$output"
$	esc[0,7]=27 
$	bel[0,7]=7
$	bell = bel+bel
$	flash=esc+"[5m" 
$!
$! Introduce the package 
$!
$ ws "[0m[1m======  Initialising 'DTMPREPARE' Version 1.1 ======"
$ ws " "
$!
$ ws "[0m[7m"
$ WS "The DTMPREPARE modules are:                                                     "
$ ws "                                                                                "
$ ws "I3D         ITCHECK                                                             "
$ ws "                                                                                "
$ ws "[0m"
$!
$! Define symbols for image activation
$!
$! DTMPREPAREINI.COM - Command file to set up DTMPREPARE package commands
$!
$define_symbols:
$!
$!
$ ITCHECK	:== $LSL$EXE:ITCHECK'ARCH_SUFFIX'	! terrain checker
$ I3D		:== $LSL$EXE:I3D'ARCH_SUFFIX'		! ridge/river heighting
$!
$	if ver_status then set verify
$	exit
$!
