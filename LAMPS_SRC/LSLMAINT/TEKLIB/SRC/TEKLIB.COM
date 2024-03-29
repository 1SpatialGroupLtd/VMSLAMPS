$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1983-12-13 11:35:08.000000000 +0000
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
$	INQUIRE TKCOM "Compile"
$	INQUIRE TKLNK "Link with TEKCI"
$	INQUIRE TKDBG "Debug"
$	MDBG:=""
$	DBG:=""
$	IF TKDBG THEN MDBG:="/EN=DBG"
$	IF TKDBG THEN DBG:="/DEBUG"
$	IF .NOT. TKCOM THEN GOTO T_LINK
$!
$	INQUIRE ALL "All"
$	IF .NOT. ALL THEN GOTO T_ASK
$	DDC = 1
$	BS  = 1
$	VG  = 1
$	OD  = 1
$	NL  = 1
$	IN  = 1
$	RF  = 1
$	NEWL = 1
$	GOTO T_MAC
$!
$ T_ASK:
$	INQUIRE DDC "TDDC01 & TKDDCG"
$	INQUIRE BS  TKBS
$	INQUIRE VG  TKVG
$	INQUIRE OD  TKOD
$	INQUIRE IN  TKIN
$	INQUIRE RF  TKRF
$	INQUIRE NL  TKNL
$	INQUIRE NEWL "New Library"
$ T_MAC:
$	ON CONTROL_Y THEN EXIT
$	REPM = .NOT. NEWL
$	SET VER
$	IF .NOT. DDC THEN GOTO T_MAC1
$	ADC TKDDCG=TKDDCG
$	FORT'DBG'/NOI4 TKDDCG
$	PVV TKDDCG
$	DEL TKDDCG.FOR;*,ADC.IDE;*
$	MAC'MDBG'/OBJ=TDDC TKHD01+THKPAR+TKDDCP+TKWS01+TKVW01+TDDC01
$	IF .NOT. NEWL THEN LIBR/REPL TEKLIB TKDDCG,TDDC
$ T_MAC1:
$	IF BS THEN MAC'MDBG'/OBJ=TKBS TKHD01+TKWS01+TKVW01+TKBS01
$	IF BS .AND. REPM THEN LIBR/REPL TEKLIB TKBS
$	IF VG THEN MAC'MDBG'/OBJ=TKVG TKHD01+TKVW01+TKWS01+TKVG01
$	IF VG .AND. REPM THEN LIBR/REPL TEKLIB TKVG
$	IF OD THEN MAC'MDBG'/OBJ=TKOD TKHD01+TKIW01+TKVW01+TKWS01+TKOD01
$	IF OD .AND. REPM THEN LIBR/REPL TEKLIB TKOD
$	IF NL THEN MAC'MDBG'/OBJ=TKNL TKHD01+TKNL01
$	IF NL .AND. REPM THEN LIBR/REPL TEKLIB TKNL
$	IF IN THEN MAC'MDBG'/OBJ=TKIN -
			TKHD01+TKIW01+TKRW01+TKVW01+TKWS01+TKIN01
$	IF IN .AND. REPM THEN LIBR/REPL TEKLIB TKIN
$	IF RF THEN MAC'MDBG'/OBJ=TKRF -
			TKHD01+TKRW01+TKIW01+TKVW01+TKWS01+TKRF01
$	IF RF .AND. REPM THEN LIBR/REPL TEKLIB TKRF
$!
$	IF REPM THEN GOTO T_LINK
$	LIBR/CREATE=BLOCKS:30 TEKLIB TKDDCG,TDDC,TKBS,TKIN,TKNL,TKOD,TKRF,TKVG
$	PURGE TEKLIB.OLB
$!
$ T_LINK:
$	SET VER
$	IF .NOT.TKLNK THEN GOTO NOLNK
$	ADC PICL=PICL
$	FORT'DBG'/NOI4 PICL
$	PVV PICL
$	DEL PICL.FOR;*,ADC.IDE;*
$	LIBR/REPL TEKLIB PICL
$	ADC TEKCI=TEKCI
$	FORT'DBG'/NOI4 TEKCI
$	PVV TEKCI
$	DEL TEKCI.FOR;*,ADC.IDE;*
$	LINK'DBG'/MAP -
TEKCI,TEKLIB/INCLUDE=(PICL,TDDC,TKBS,TKIN,TKDDCG,TKNL,TKOD,TKRF,TKVG), -
LSL$LIBRARY:VIOLIB/LIB
$	PUR TEKCI.*
$ NOLNK:
$	DEL *.OBJ;*
$	SET NOVER
$!
