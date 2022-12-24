$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1987-06-01 17:33:40.000000000 +0100
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
$	INQUIRE ALL "All"
$	IF .NOT. ALL THEN GOTO W_ASK
$	DEB = ""
$	OP = 1
$	BS  = 1
$	VG  = 1
$	OD  = 1
$	NL  = 1
$	NEWL = 1
$	GOTO W_MAC
$!
$ W_ASK:
$	INQUIRE DEB "With debug"
$	if DEB then dbg = "/debug/nooptimise"
$	if DEB then mdbg = "/debug"
$	INQUIRE OP  TKOPS
$	INQUIRE BS  TKBS
$	INQUIRE NL  TKNL
$	INQUIRE OD  TKOD
$	INQUIRE VG  TKVG
$	INQUIRE NEWL "New Library"
$!
$ W_MAC: ON CONTROL_Y THEN EXIT
$	REPM = .NOT. NEWL
$	SET NOON
$	SET VER
$
$	if .not.op then goto noop
$	adc tekops=tekops
$	for'dbg' tekops
$	pvv tekops
$	if .not.deb then delete tekops.for;*
$	delete adc.ide;*
$	if repm then libr/repl/log t4100lib tekops
$noop:	if bs then mac'mdbg'/obj=tkbs tkhd02+thkpar+tkws02+tkvw02+tkbs02
$	if bs .and. repm then libr/repl/log t4100lib tkbs
$	if vg then mac'mdbg'/obj=tkvg tkhd02+tkvw02+tkws02+tkvg02
$	if vg .and. repm then libr/repl/log t4100lib tkvg
$	if od then mac'mdbg'/obj=tkod -
			tkhd02+tkiw02+tkvw02+tkws02+tkod02
$	if od .and. repm then libr/repl/log t4100lib tkod
$	if nl then mac'mdbg'/obj=tknl tkhd02+tknl02
$	if nl .and. repm then libr/repl/log t4100lib tknl
$!
$	if repm then goto w_lnk
$	library/create=blocks:30 t4100lib tkbs,tknl,tkod,tkvg,tekops
$	pl t4100lib.olb
$!
$ w_lnk: pl *.obj
$	set nover
$!
