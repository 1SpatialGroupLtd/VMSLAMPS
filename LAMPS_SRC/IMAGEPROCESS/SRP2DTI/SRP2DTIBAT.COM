$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-12-21 15:08:06.000000000 +0000
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
$	on control_y then goto srp2dtiex
$	if "''f$logical("lsl$srp2dti_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	define/group lsl$srp2dti_building "in_progress"
$	assign lsl$source_root:[imageprocess.srp2dti] lsl$cmnsrp2dti
$	assign lsl$source_root:[tves.service] lsl$tvessys
$	assign lsl$source_root:[dtmcreate.service] lsl$dtmcreatesys
$	sd:=$lsl$sys:sd
$	set noon
$	emsg=""
$	set noverify
$	if emsg.eqs."" then goto noerr
$	write sys$output "&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"
$	write sys$output "Compilation errors in:"
$	write sys$output emsg
$	write sys$output "&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"
$	goto nolnk
$	noerr:
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 	run lsl$exe:genver
$ 	adc version=version
$	fort version
$ 	ok=$status
$ 	if ok then pvv version
$ 	purge/nolog version.obj
$ 	delete/nolog version.for;*
$	if .not.ok then emsg=emsg+" version"
$ 	delete adc.ide;*
$ 	purge/nolog version.src
$ set verify
$ 	link/map/cross/exe=srp2dti srp2dti/opt,lsl$library:lslshr/opt
$ 	nolnk:
$ 	srp2dtiex:
$ 	deass/group lsl$srp2dti_building
$ 	set nover
