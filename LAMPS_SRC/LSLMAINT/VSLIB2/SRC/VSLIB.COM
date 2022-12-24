$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1987-05-07 11:53:02.000000000 +0100
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
$	set noverify
$! this command file creates a VSLIB library
$	write sys$output "Command file to create VSLIB"
$!
$	inquire VSCOM "Compile"
$	inquire VSLNK "Link with VSCI"
$	inquire VDBG  "Debug"
$	MDBG:=""
$	LDBG:=""
$	FDBG:=""
$	if VDBG then MDBG:="/en=dbg"
$	if VDBG then LDBG:="/debug"
$	if VDBG then FDBG:="/debug"
$! here, see if we are simply linking with VSCI
$	if VSCOM then goto askall
$	set verify
$	goto v_lnk
$!
$! now check how much we must do
$askall:inquire ALL "All"
$	if .NOT. ALL then goto V_ASK
$	VG=1
$	OD=1
$	BS=1
$	CS=1
$	SG=1
$	DC=1
$	NEWL=1
$	READ=1
$	GET=1
$	goto v_mac
$!
$v_ask:
$	inquire VG	VSVG
$	inquire OD	VSOD
$	inquire BS	VSBS
$	inquire CS	VSCS
$	inquire	SG	VSSG
$	inquire DC	VSDC
$	inquire GET	"Sigma GETSYSC"
$	inquire	READ	"Read routines"
$	inquire NEWL	"New Library"
$!
$v_mac:
$	on CONTROL_Y then EXIT
$	REPM = .not.NEWL
$	set verify
$	if .not.VG then goto novg
$	   MAC'mdbg'/OBJ=VSVG VSDF02+VSWS02+VSIW02+VSVG02
$	   if REPM then LIBR/REPL/LOG VSLIB VSVG
$novg:	if .not.OD then goto nood
$	   MAC'mdbg'/OBJ=VSOD LSL$CMNVS:IDXPAR+HERE:VSDF02+VSWS02+VSIW02+VSOD02
$	   if REPM then LIBR/REPL/LOG VSLIB VSOD
$nood:	if .not.BS then goto nobs
$	   MAC'mdbg'/OBJ=VSBS VSDF02+VSWS02+VSBS02
$	   if REPM then LIBR/REPL/LOG VSLIB VSBS
$nobs:	if .not.CS then goto nocs
$	   MAC'mdbg'/OBJ=VSCS VSDF02+VSWS02+VSIW02+VSCS02
$	   if REPM then LIBR/REPL/LOG VSLIB VSCS
$nocs:	if .not.SG then goto nosg
$	   MAC'mdbg'/OBJ=VSSG LSL$CMNVS:IDXPAR+HERE:VSDF02+VSWS02+VSIW02+VSSG02
$	   if REPM then LIBR/REPL/LOG VSLIB VSSG
$nosg:	if .not.DC then goto nodc
$	   MAC'mdbg'/OBJ=VSDC VSDF02+VSDDCP+VSWS02+VSIW02+VSDC02
$	   ADC VSDDCG=VSDDCG,DSUBST,DREPT,SUBSTT
$	   FOR'fdbg' VSDDCG
$	   PVV VSDDCG
$	   DELETE ADC.IDE;*,VSDDCG.FOR;*
$	   if REPM then LIBR/REPL/LOG VSLIB VSDC,VSDDCG
$nodc:	if .not.GET then goto noget
$	   ADC GETSYSC=GETSYSC,GETLIN
$	   FOR'fdbg' GETSYSC
$	   PVV GETSYSC
$	   DELETE ADC.IDE;*,GETSYSC.FOR;*
$	   if REPM then LIBR/REPL/LOG VSLIB GETSYSC
$noget:	if .not.READ then goto nord
$	   MAC'mdbg'/OBJ=VSSYSC VSDF02+VSTXTC+VSSYSC
$	   ADC FREAD=BSCH,BSLN,RDCH,RDCHS,RDINT,RDHEX
$	   FOR'fdbg' FREAD
$	   PVV FREAD
$	   DELETE ADC.IDE;*,FREAD.FOR;*
$	   if REPM then LIBR/REPL/LOG VSLIB VSSYSC,FREAD
$!
$nord:	if REPM then goto v_lnk
$	LIBR/CREATE=BLOCKS:30 VSLIB VSBS,VSOD,VSVG,VSCS,VSSG,-
				VSDC,VSDDCG,GETSYSC,VSSYSC,FREAD
$	PUR VSLIB.OLB
$!
$v_lnk:	if .not.VSLNK then goto v_exit
$	LINK'ldbg'/MAP VSCI,VSCMD,VSLIB/LIB,-
			LSL$LIBRARY:CMDLIB/LIB,-
			LSL$LIBRARY:VIOLIB/LIB
$!
$v_exit:
$	set noverify
$!
$	PUR
$	if .not.VSCOM then goto endit
$	if VG then DELETE VSVG.OBJ;*
$	if OD then DELETE VSOD.OBJ;*
$	if BS then DELETE VSBS.OBJ;*
$	if CS then DELETE VSCS.OBJ;*
$	if SG then DELETE VSSG.OBJ;*
$	if DC then DELETE VSDC.OBJ;*, VSDDCG.OBJ;*
$	if READ then DELETE VSSYSC.OBJ;*, FREAD.OBJ;*
$	if GET  then DELETE GETSYSC.OBJ;*
$endit:
$!
