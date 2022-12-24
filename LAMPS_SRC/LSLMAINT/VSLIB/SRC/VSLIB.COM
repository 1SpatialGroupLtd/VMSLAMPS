$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1983-12-21 13:59:42.000000000 +0000
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
$	ASS DRA1:[ROBIN.CMD] CMD
$!
$	INQUIRE VSCOM "Compile"
$	INQUIRE VSLNK "Link with VSCI"
$	INQUIRE VDBG  "Debug"
$	MDBG:=""
$	DBG:=""
$	IF VDBG THEN MDBG:="/EN=DBG"
$	IF VDBG THEN LDBG:="/DEBUG"
$	IF .NOT. VSCOM THEN GOTO V_LNK
$	INQUIRE ALL "All"
$	IF .NOT. ALL THEN GOTO V_ASK
$	VG=1
$	OD=1
$	BS=1
$	CH=1
$	CS=1
$	NEWL=1
$	GOTO V_MAC
$!
$V_ASK:
$	INQUIRE BS	VSBS
$	INQUIRE OD	VSOD
$	INQUIRE VG	VSVG
$	INQUIRE CS	VSCS
$	INQUIRE CH	CHARS
$	INQUIRE NEWL	"New Library"
$!
$V_MAC:
$	ON CONTROL_Y THEN EXIT
$	REPM = .NOT. NEWL
$	SET VER
$	IF VG THEN MAC'MDBG'/OBJ=VSVG VSDF01+VSWS01+VSIW01+VSVG01
$	IF VG .AND. REPM THEN LIBR/REPL VSLIB VSVG
$	IF OD THEN MAC'MDBG'/OBJ=VSOD VSDF01+VSWS01+VSIW01+VSOD01
$	IF OD .AND. REPM THEN LIBR/REPL VSLIB VSOD
$	IF BS THEN MAC'MDBG'/OBJ=VSBS VSDF01+VSWS01+VSBS01
$	IF BS .AND. REPM THEN LIBR/REPL VSLIB VSBS
$	IF CS THEN MAC'MDBG'/OBJ=VSCS VSDF01+VSWS01+VSIW01+VSCS01
$	IF CS .AND. REPM THEN LIBR/REPL VSLIB VSCS
$	IF CH THEN MAC/OBJ=CHARS CHARS
$	IF CH .AND. REPM THEN LIBR/REPL VSLIB CHARS
$!
$	IF REPM THEN GOTO V_LNK
$	LIBR/CREATE=BLOCKS:30 VSLIB VSBS,VSOD,VSVG,VSCS,CHARS
$	PUR VSLIB.OLB
$!
$V_LNK:
$	IF .NOT. VSLNK THEN GOTO V_EXIT
$	LINK'LDBG' VSCI,VSCMD,VSLIB/LIB,CMD:CMDLIB/LIB,LSL$LIBRARY:VIOLIB/LIB
$!
$V_EXIT:
$	PUR
$	DEL VSVG.OBJ;*,VSOD.OBJ;*,VSBS.OBJ;*,VSCS.OBJ;*,CHARS.OBJ;*
$	SET NOV
$!
