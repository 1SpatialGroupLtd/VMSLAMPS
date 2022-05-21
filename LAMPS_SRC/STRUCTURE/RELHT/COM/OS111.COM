$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1987-01-28 12:21:20.000000000 +0000
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
$! OS111.COM - command file for structuring the OS sheet 111 digitised data
$	SAVVER=F$VERIFY(0)
$	CHARGE J26245
$	ILINK=="$LSL$DISK:[MCE.ILINK.EXE]ILINK"
$	RELHT=="$LSL$DISK:[OS.RELHT]RELHT"
$	IF "''F$TRNLNM(""LSL$LITES2CMD"")'".EQS."" THEN LITES2INI
$	IF "''F$TRNLNM(""LSL$RELHT_PRIO"")'".EQS."" THEN -
		DEFINE LSL$RELHT_PRIO DUA0:[OS.RELHT]RELHT.PRIO
$	MONSW=""
$	IF F$MODE().EQS."INTERACTIVE" THEN MONSW="/MONITOR"
$	SD DUA0:[OS.RELHT]
$	SI DUA0:[OS.RELHT]
$	IF P1.EQS."RELHT" THEN GOTO RELHT
$	IF P1.EQS."LPJOIN" THEN GOTO LPJOIN
$	IF P1.EQS."BREAK" THEN GOTO BREAK
$	IF P1.EQS."PPJOIN" THEN GOTO PPJOIN
$	SET VERIFY
$!
$	ILINK OS111T OS111A/LLJOIN/JNTOL=20/BREAK/FCP=[OS.RELHT]OS111/LAYER=(0:9)'MONSW'
$	XX=f$VERIFY(0)
$LPJOIN:
$	SET VERIFY
$	ILINK OS111A OS111B/LPJOIN/JNTOL=15/EXT=15/VERTEX/BREAK/LAYER=(0:3,5:9)'MONSW'
$	XX=f$VERIFY(0)
$BREAK:
$	SET VERIFY
$	ILINK OS111B OS111C/BREAK/LAYER=(0:9)'MONSW'
$	XX=f$VERIFY(0)
$PPJOIN:
$	SET VERIFY
$	ILINK OS111C OS111D/PPJOIN/JNTOL=10/MID/STRUCTURE'MONSW'
$	XX=f$VERIFY(0)
$!
$RELHT:
$	SET VERIFY
$	RELHT OS111D OS111H/NODE/LOG/LITES
$!
$	PURGE/LOG OS111*.IFF,OS111*.LIS,LSL$LITES2CMD:OS111*.LCM
$	SET NOVERIFY
$	COST
$	IF SAVVER THEN SET VERIFY
