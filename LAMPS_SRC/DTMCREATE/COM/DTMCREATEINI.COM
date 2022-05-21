$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-17 16:21:08.000000000 +0100
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
$! Version for transition between PANACEA and DTMCREATE   TJH   25-Jan-1988
$!
$! Command file to initialise Laser-Scan IFF Manipulation Package 'DTMCREATE'
$!
$! Allow for differences for OpenVMS Alpha AXP
$!
$	ARCH_NAME=F$GETSYI("ARCH_NAME")
$	ARCH_SUFFIX=""
$	IF ARCH_NAME.EQS."Alpha" THEN ARCH_SUFFIX="_TV"
$!
$! if we are not interactive, then don't output the explanation of what
$! DTMCREATE is and does
$!
$	if f$mode().nes."INTERACTIVE" then goto define_symbols
$!
$! and if they have used DTMCREATEINI Q then they want Quiet, so we will also
$! skip the informational bit
$!
$	if p1.eqs."Q" then goto define_symbols
$! and lastly if they are on a non VT100 type terminal the reverse video
$! etc. may cause problems. Skip the informational bit.
$	if (.not.f$getdvi("TT:","TT_AVO")) then goto define_symbols
$!
$	ws="write sys$output"
$!
$!*****************************************************************
$! We need to have a 3 DTMCREATE graphics lookup files to define
$! what graphics are available on each terminal line (by line ID).
$!
$! TERMTYPE.DAT  - for TRIANG, TRIDER and TRIGRID
$! CONFIGDEF.DAT - for TRIEDIT defaults
$! CONFIGURE.DAT - for checking TRIEDIT user selections
$!
$! If using a terminal server (and therefore serial line IDs are
$! ephemeral) graphics lookup can be achieved by assigning logical
$! name LSL$DTMCREATETERMINAL to a suitable terminal line ID in
$! the relevant lookup file. All 3 lookup files are in LSL$LOOKUP on 
$! the public tree.
$!
$!*****************************************************************
$!
$! Introduce the package with any relevant warnings of changes etc.
$!
$ ws "[0m[1m====  Initialising Laser-Scan DTM creation package 'DTMCREATE' Version 1.0 ====="
$ ws " "
$!
$ ws "[0m[7m"
$ WS "The DTMCREATE modules are:                                                      "
$ ws "                                                                                "
$ ws "TRIANG          TRIDER           TRIEDIT          TRIGRID                       "
$ ws "                                                                                "
$ ws "[0m"
$!
$! Define symbols for image activation
$!
$ define_symbols:
$!
$! Check if we are on a terminal server. If so set up logical name
$! LSL$DTMCREATETERMINAL as LT number changes every time.
$	term	= f$trnlnm("TT")
$	if f$locate("LT",term) .ne. f$length(term) then -
		define	lsl$dtmcreateterminal	ltxx
$   	if f$trnlnm("DECW$DISPLAY").nes.""
$    	then
$          ver = "MOTIF"
$	   define lsl$dtmcreateterminal wta1
$    	else
$   	   if f$trnlnm("SYS$WORKSTATION").nes.""
$    	   then
$             ver = "UIS"
$    	   else
$	      ver = "NULL"
$	   endif
$       endif
$	define lsl$dtm_gksshr'ARCH_SUFFIX' lsl$exe:dtm_gks'ver'shr'ARCH_SUFFIX'
$!
$	TRIANG:==$LSL$EXE:TRIANG'ARCH_SUFFIX'
$	TRIDER:==$LSL$EXE:TRIDER'ARCH_SUFFIX'
$	TRIGRID:==$LSL$EXE:TRIGRID'ARCH_SUFFIX'
$	TRIEDIT:==$LSL$EXE:TRIEDIT'ARCH_SUFFIX'
$	if ver_status then set verify
