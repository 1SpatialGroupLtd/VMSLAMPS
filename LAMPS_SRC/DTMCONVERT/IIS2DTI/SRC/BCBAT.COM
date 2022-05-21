$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-06-05 12:48:02.000000000 +0100
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
$	on control_y then goto bcex
$	if "''f$logical("lsl$bc_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	define/group lsl$bc_building "in_progress"
$	sd:=$lsl$sys:sd
$	set noon
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		set verify
$ 		adc block_copy.tmp=block_copy_cld.cld
$ 		set command/object=block_copy_cld block_copy.tmp
$ 		ok=$status
$ 		if ok then pvv block_copy_cld
$ 		if ok then delete block_copy.tmp;*
$ 		if ok then purge/nolog block_copy_cld.obj
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		adc block_copy =block_copy
$ 		fort block_copy
$ 		ok=$status
$ 		if ok then pvv block_copy
$ 		purge/nolog block_copy.obj
$ 		purge/nolog block_copy.for
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		link/map/cross/exe=block_copy block_copy,-
		block_copy_cld, -
		lsl$library:lslshr/opt
$ 		bcex:
$ 		deass/group lsl$bc_building
$ 		set nover
