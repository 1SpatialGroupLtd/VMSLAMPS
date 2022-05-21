$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1995-03-16 15:26:16.000000000 +0000
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
$!
$! Process START, or STARTMON
$!
$! set up where we keep our common files
$!
$	define cmn lsl$source_root:[table.shared]
$!
$	deb := ""
$	ldeb:= ""
$	if p1 .eqs. "D" then deb := "/debug"
$	if p1 .eqs. "N" then deb := "/debug/noopt"
$	if deb.nes. ""  then ldeb:= "/debug"
$!
$	write sys$output " "
$	inquire main  "Compile startmon                             "
$	inquire marit "Assemble macro routines                      "
$	inquire check "Compile other routines (chkprc,is_alpha_axp) "
$!
$	set verify
$	if marit
$	then
$	   macro'ldeb' checksym
$	endif
$!
$	if check
$	then
$	   adc check=chkprc,is_alpha_axp
$	   fort'deb' check
$	   pvv check
$	   delete adc.ide;*
$	   if deb.eqs."" then delete check.FOR;*
$	endif
$!
$	if main
$	then
$	   adc startmon=startmon
$	   fort'deb' startmon
$	   pvv startmon
$	   delete adc.ide;*
$	   if deb.eqs."" then delete startmon.FOR;*
$	endif
$!
$	link/map/notrace'ldeb' startmon,checksym,check,-
			lsl$library:lsllib/lib
$!
$	purge/log *.*
$	exit
