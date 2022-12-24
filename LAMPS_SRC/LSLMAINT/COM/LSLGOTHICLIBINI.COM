$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-27 09:32:34.000000000 +0100
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
$	ver_status=f$verify(0)
$	on control then continue
$	on error then continue
$!
$! Command file to initialise environment for working with LSLGOTHICLIB
$!                                                
$! 						R.W. Russell	26-Jul-1993 
$!
$	if f$mode().nes."INTERACTIVE" then goto define_names
$!
$! and if they have used "Q" then they want Quiet, so we will also
$! skip the informational bit
$!
$	if p1.eqs."Q" then goto define_names
$! and lastly if they are on a non VT100 type terminal the reverse video
$! etc. may cause problems. Skip the informational bit.
$	if (.not.f$getdvi("TT:","TT_AVO")) then goto define_names
$!
$	ws="write sys$output"
$!
$!
$ ws "[0m[1m"
$ ws "            ======  Initialising LSLGOTHICLIB environment ======               "
$ ws "                                                                               "
$!
$ ws "[0m[7m"
$ WS "The following logical names are being set up -"
$ ws "                                                                                "
$ ws "SYS                                                                             "
$ ws "                                                                                "
$ ws "LSL$CMNLSLGOTHIC                                                                "
$ ws "                                                                                "
$ ws "[0m"
$!
$! Define logical names
$!
$ Define_names:
$	define sys sys$library
$	define lsl$cmnlslgothic lsl$public_root:[lslmaint.common.lslgothiclib]
$!
$	if ver_status then set verify
