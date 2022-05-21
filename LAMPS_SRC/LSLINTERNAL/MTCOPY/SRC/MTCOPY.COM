$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-02-15 19:03:36.000000000 +0000
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
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Command file for building MTCOPY
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Initialise
$	set noverify
$!
$	on error then goto nolink
$	on control then goto exit
$!
$	TRUE  = 1
$	FALSE = 0
$!
$	assign lsl$source_root:[lslinternal.dmtlib.mtcopy] lsl$cmnmtcopy
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Decide what needs doing
$!
$	inquire mes  "MTCOPY message definitions"
$	inquire cld  "MTCOPY command definitions"
$	inquire cmp  "compile"
$	inquire lnk  "link MTCOPY"
$	cdbg = ""
$	ldbg = ""
$	dbg = FALSE
$	if cmp.or.lnk then inquire dbg "debug"
$	if dbg then fdbg = "/debug/nooptimise/check=(b,o)"
$	if dbg then ldbg = "/debug"
$!
$	if.not.cmp then goto noask
$	inquire all  "compile everything"
$	if.not.all then goto notall
$!
$	m1  = TRUE
$	m2  = TRUE
$	m3  = TRUE
$	m4  = TRUE
$	m5  = TRUE
$	m6  = TRUE
$!
$	goto noask
$notall:
$	m1  = FALSE
$	m2  = FALSE
$	m3  = FALSE
$	m4  = FALSE
$	m5  = FALSE
$	m6  = FALSE
$!
$	INQUIRE m1   "compile file_to_tape"
$	INQUIRE m2   "compile get_commands"
$	INQUIRE m3   "compile identify_io_devices"
$	INQUIRE m4   "compile mtcopy"
$	INQUIRE m5   "compile tape_to_file"
$	INQUIRE m6   "compile tape_to_tape"
$noask:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Build message files
$	if.not.mes then goto nomes
$	set verify
$	newmsg mtcopy.mes/number=1902/parameter=(fortran)
$	@mtcopy.temp_com
$nomes:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Compile
$	if.not.cmp then goto nocmp
$	set verify
$!
$	if.not.m1 then goto nom1
$	adc file_to_tape = file_to_tape
$	fortran'fdbg' file_to_tape
$	pvv file_to_tape
$!
$nom1:	if.not.m2 then goto nom2
$	adc get_commands = get_commands
$	fortran'fdbg' get_commands
$	pvv get_commands
$!
$nom2:	if.not.m3 then goto nom3
$	adc identify_io_devices = identify_io_devices
$	fortran'fdbg' identify_io_devices
$	pvv identify_io_devices
$!
$nom3:	if.not.m4 then goto nom4
$	adc mtcopy = mtcopy
$	fortran'fdbg' mtcopy
$	pvv mtcopy
$!
$nom4:	if.not.m5 then goto nom5
$	adc tape_to_file = tape_to_file
$	fortran'fdbg' tape_to_file
$	pvv tape_to_file
$!
$nom5:	if.not.m6 then goto nom6
$	adc tape_to_tape = tape_to_tape
$	fortran'fdbg' tape_to_tape
$	pvv tape_to_tape
$!
$nom6:
$!
$nocmp:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Compile CLD module
$	if.not.cld then goto nocld
$	set verify
$	adc mtcopy.tmp = mtcopy.cld
$	set command/object = mtcopycld mtcopy.tmp
$	pvv mtcopycld
$	delete mtcopy.tmp;*
$!
$nocld:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Link
$	if.not.lnk then goto nolink
$	set verify
$	link'ldbg'/map -
		mtcopy,file_to_tape,get_commands,-	! routines
		identify_io_devices,-
		tape_to_file,tape_to_tape,-
		mtcopycld,-			! commands
		mtcopy.promsg_obj,-		! message table
		lsl$library:lslshr/opt		! for I/O
$!
$nolink:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Purge
$	purge/log *.obj,*.for,*.exe
$	del adc.ide;*
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Exit
$exit:	set noverify
$	exit
