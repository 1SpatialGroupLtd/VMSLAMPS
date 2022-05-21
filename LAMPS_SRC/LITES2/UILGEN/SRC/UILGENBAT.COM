$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-07-08 14:37:38.000000000 +0100
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
$ 	set noverify
$	on control_y then goto uilgenex
$	if "''f$logical("lsl$uilgen_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	define/group lsl$uilgen_building "in_progress"
$	assign lsl$source_root:[lites2.motif.uilgen] lsl$cmnuilgen
$	set noon
$	emsg=""
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc PROCESS_FILE=PROCESS_FILE
$	fort PROCESS_FILE
$ 	ok=$status
$ 	if ok then pvv PROCESS_FILE
$ 	purge/nolog PROCESS_FILE.obj
$ 	delete/nolog PROCESS_FILE.for;*
$	if .not.ok then emsg=emsg+" PROCESS_FILE"
$ 	delete adc.ide;*
$	set noverify
$	set verify
$	link/exe=UILGENMOTIF  uilgen, -
	uilgencmd, -
	cld_init, -
	init_uil, -
	process_file, -
	process_icon, -
	write_callback, -
	write_uil, -
	uilgen_cld, -
	uilgen.promsg_obj, -
	lsl$library:lslshr/opt
$	purge/nolog uilgenmotif.*
$	set noverify
$	if emsg.eqs."" then goto noerr
$	write sys$output "&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"
$	write sys$output "Compilation errors in:"
$	write sys$output emsg
$	write sys$output "&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"
$	noerr:
$   uilgenex:
$ 	deass/group lsl$uilgen_building
$ 	set nover
