$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-04-10 13:10:24.000000000 +0100
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
$	on control_y then goto iselacex
$	if "''f$logical("lsl$iselac_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:  define/group lsl$iselac_building "in_progress"
$	assign lsl$source_root:[imp.iselac] lsl$cmniselac
$	sd:=$lsl$sys:sd
$	set noon
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		set verify
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc iselac=iselac
$ 		fort iselac
$ 		ok=$status
$ 		if ok then pvv iselac
$ 		purge/nolog iselac.obj
$ 		delete/nolog iselac.for;*
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ link/map/exe=iselac iselac,-
 selcmd, getcmd, acskrd, setup, copent, -
 seldec , help, opnfil, skelrd, prompt, -'
 actest, reject, show, read_prompt, copy_string,-'
 reset, iselac.promsg_obj, -
		lsl$library:iffshr/opt,lslshr/opt
$ 		iselacex:
$ 		deass/group lsl$iselac_building
$ 		set nover
