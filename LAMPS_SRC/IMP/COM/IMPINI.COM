$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-12-16 18:11:38.000000000 +0000
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
$! Command file to initialise Laser-Scan IFF Manipulation Package 'IMP'
$!
$! Allow for differences for OpenVMS Alpha AXP
$!
$	ARCH_NAME=F$GETSYI("ARCH_NAME")
$	ARCH_SUFFIX=""
$	IF ARCH_NAME.EQS."Alpha" THEN ARCH_SUFFIX="_TV"
$!
$! If we are not interactive, then don't output the explanation of what
$! IMP is and does
$!
$	if f$mode().nes."INTERACTIVE" then goto obsolete_names
$!
$! and if they have used IMPINI Q then they want Quiet, so we will also
$! skip the informational bit
$!
$	if p1.eqs."Q" then goto obsolete_names
$! and lastly if they are on a non VT100 type terminal the reverse video
$! etc. may cause problems. Skip the informational bit.
$	if (.not.f$getdvi("TT:","TT_AVO")) then goto obsolete_names
$!
$	ws="write sys$output"
$!
$!*****************************************************************
$! We need to have an IMP lookup file to hold AC skeleton file for
$! the 10th wonder of the universe ISELAC. ACSKEL.DAT
$! is in LSL$LOOKUP on the public tree.
$!*****************************************************************
$!
$! Introduce the package with any relevant warnings of changes etc.
$!
$ ws "[0m[1m======  Initialising IFF Map Processing package 'IMP' Version 1.0 ======"
$ ws " "
$!
$ ws "[0m[7m"
$ WS "The IMP modules are:                                                            "
$ ws "                                                                                "
$ ws "ICHECK      ICUT           IDIFFERENCE      IFILTER      IFIXAREA     IFROMTEXT "
$ ws "                                                                                "
$ ws "IINFO       ILAYFC         IMEND            IMERGE       IPATCH       IRECODE   "
$ ws "                                                                                "
$ ws "IRENUMBER   IREPORT        ISELAC           ISELECT      ISORT        ISTART    "
$ ws "                                                                                "
$ ws "ITOTEXT     ITRANS         IWINDOW                                              "
$ ws "                                                                                "
$ ws "[0m"
$!
$! Define symbols for image activation
$!
$ Obsolete_names:
$	I2TEXT:=="WRITE SYS$OUTPUT ""Use ITOTEXT instead"""
$	TEXT2I:=="WRITE SYS$OUTPUT ""Use IFROMTEXT instead"""
$	IWRITE:=="WRITE SYS$OUTPUT ""Write a text or IFF file? Use ITOTEXT instead"""
$	IREAD :=="WRITE SYS$OUTPUT ""Read a text or IFF file? Use IFROMTEXT instead"""
$!
$	ICHECK:==$LSL$EXE:ICHECK'ARCH_SUFFIX'
$	ICUT:==$LSL$EXE:ICUT'ARCH_SUFFIX'
$	IDIFF*ERENCE:==$LSL$EXE:IDIFFERENCE'ARCH_SUFFIX'
$	IFILT*ER:==$LSL$EXE:IFILTER'ARCH_SUFFIX'
$	IINF*O:==$LSL$EXE:IINFO'ARCH_SUFFIX'
$	ILAY*FC:==$LSL$EXE:ILAYFC'ARCH_SUFFIX'
$	IMEND:==$LSL$EXE:IMEND'ARCH_SUFFIX'
$	IMER*GE:==$LSL$EXE:IMERGE'ARCH_SUFFIX'
$	IPAT*CH:==$LSL$EXE:IPATCH'ARCH_SUFFIX'
$	IREC*ODE:==$LSL$EXE:IRECODE'ARCH_SUFFIX'
$	IREP*ORT:==$LSL$EXE:IREPORT'ARCH_SUFFIX'
$	ISELAC:==$LSL$EXE:ISELAC'ARCH_SUFFIX'
$	ISELECT:==$LSL$EXE:ISELECT'ARCH_SUFFIX'
$	ISORT:==$LSL$EXE:ISORT'ARCH_SUFFIX'
$	ISTA*RT:==$LSL$EXE:ISTART'ARCH_SUFFIX'
$	ITRA*NS:==$LSL$EXE:ITRANS'ARCH_SUFFIX'
$!
$! Changed names
$!
$	ITO*TEXT:==$LSL$EXE:ITOTEXT'ARCH_SUFFIX'
$	IWIN*DOW:==$LSL$EXE:IWINDOW'ARCH_SUFFIX'
$	IFIXA*REA:==$LSL$EXE:IFIXAREA'ARCH_SUFFIX'
$	IREN*UMBER:==$LSL$EXE:IRENUMBER'ARCH_SUFFIX'
$	IFROM*TEXT:==$LSL$EXE:IFROMTEXT'ARCH_SUFFIX'
$!
$! Define logical to point to OS Map Header translation table
$!
$	IF F$TRNLNM("LSL$OS_MH_TABLE").EQS."" THEN -
	   DEFINE LSL$OS_MH_TABLE LSL$LOOKUP:OSMH_NEW_TABLE.DAT
$!
$	if ver_status then set verify
