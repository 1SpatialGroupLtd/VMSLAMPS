$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-12-20 12:52:26.000000000 +0000
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
$!$! Created 10AU87   by DRC.$! Mod     20DE90   by J Barber for ver 1.1$!$	ver_status=f$verify(0)$	on control then continue$	on error then continue$!$! Command file to initialise Laser-Scan Image Processing Package $! 'IMAGEPROCESS'$!$! if we are not interactive, then don't output the explanation of what$! IMAGEPROCESS is and does$!$	if f$mode().nes."INTERACTIVE" then goto define_symbols$!$! and if they have used IMAGEPROCESSINI Q then they want Quiet, so we will also$! skip the informational bit$!$	if p1.eqs."Q" then goto define_symbols$! and lastly if they are on a non VT100 type terminal the reverse video$! etc. may cause problems. Skip the informational bit.$	if (.not.f$getdvi("TT:","TT_AVO")) then goto define_symbols$!$	ws="write sys$output"$!$! Introduce the package with any relevant warnings of changes etc.$!$ ws "[0m[1m====== Initialising Image Processing Package ====="$ ws "[0m[1m======       IMAGEPROCESS Version 1.1        ====="$ ws " "$!$ ws "[0m[7m"$ WS "The IMAGEPROCESS modules are:                                                   "$ ws "                                                                                "$ WS "READCCT     DTIFILTER     SRP2DTI     RCPEDT     TRANSP                         "$ ws "                                                                                "$ ws "[0m"$!$! Define symbols for image activation$!$ define_symbols:$	READCCT   :==$LSL$EXE:READCCT$	DTIFILTER :==$LSL$EXE:DTIFILTER$	SRP2DTI   :==$LSL$EXE:SRP2DTI$	RCPEDT    :==$LSL$EXE:RCPEDT$	TRANSP    :==$LSL$EXE:TRANSP$!$	if ver_status then set verify$!