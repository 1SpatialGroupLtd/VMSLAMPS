$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-03-31 12:43:14.000000000 +0100
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
$	set nocontrol_y
$	on error then continue
$!
$! Command file to initialise Laser-Scan DFAD Package
$!
$!
$! are we on a VAX or an AXP system ?
$!
$	LSL_ARCH_NAME==F$GETSYI("ARCH_NAME")
$	IF LSL_ARCH_NAME.EQS."Alpha"
$	THEN
$	  LSL_ARCH_TV_SUFFIX=="_TV"
$	  LSL_ARCH_AXP_SUFFIX=="_AXP"
$	ELSE
$	  LSL_ARCH_TV_SUFFIX==""
$	  LSL_ARCH_AXP_SUFFIX==""
$	ENDIF
$!
$! The logical name LSL$FADTINPUT_DEFAULTS must be defined
$! in the system login if you want to use an alternative lookup file 
$! to LSL$LOOKUP:FADT_DEFAULTS.DAT which is supplied by Laser-scan.
$!
$!
$! If we are not interactive, then don't output the explanation of what
$! DFAD is and does
$!
$	if f$mode().nes."INTERACTIVE" then goto Define_symbols
$!
$! and if they have used IMPINI Q then they want Quiet, so we will also
$! skip the informational bit
$!
$	if p1.eqs."Q" then goto Define_symbols
$!
$! and lastly if they are on a non VT100 type terminal the reverse video
$! etc. may cause problems. Skip the informational bit.
$!
$	if (.not.f$getdvi("TT:","TT_AVO")) then goto Define_symbols
$!
$	ws="write sys$output"
$!
$!*****************************************************************
$!
$! Introduce the package with any relevant warnings of changes etc.
$!
$ ws "[0m[1m======  Initialising DFAD Processing package 'DFAD' Version 1.0 ======"
$ ws " "
$!
$ ws "[0m[7m"
$ WS "The DFAD modules are:                                                           "
$ ws "                                                                                "
$ ws "FADTINPUT   FADTMERGE                                                           "
$ ws "                                                                                "
$ ws "MCEHED      DFADVAL                                                             "
$ ws "                                                                                "
$ ws "I2DFAD      DFAD2I                                                              "
$ ws "                                                                                "
$ ws "[0m"
$!
$! Define symbols for image activation
$!
$ Define_symbols:
$!
$	FADTINPUT :== $LSL$EXE:FADTINPUT'LSL_ARCH_TV_SUFFIX'
$	FADTMERGE :== $LSL$EXE:FADTMERGE'LSL_ARCH_TV_SUFFIX'
$	MCEHED    :== $LSL$EXE:MCEHED'LSL_ARCH_TV_SUFFIX'
$	DFADVAL   :== $LSL$EXE:DFADVAL'LSL_ARCH_TV_SUFFIX'
$	I2DFAD    :== $LSL$EXE:I2DFAD'LSL_ARCH_TV_SUFFIX'
$	DFAD2I    :== $LSL$EXE:DFAD2I'LSL_ARCH_TV_SUFFIX'
$!
$	assign LSL$SITE_ROOT:[LSL.FADT] LSL$FADT
$	assign LSL$SITE_ROOT:[LSL.RULE] LSL$DFAD_RULE
$!
$	set control=y
$	if ver_status then set verify
