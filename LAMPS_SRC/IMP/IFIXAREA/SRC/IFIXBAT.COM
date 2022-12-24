$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-11-03 18:16:12.000000000 +0000
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
$	on control_y then goto ifixex
$	if "''f$logical("lsl$ifix_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	define/group lsl$ifix_building "in_progress"
$	assign lsl$source_root:[imp.ifixarea] lsl$cmnifixarea
$	sd:=$lsl$sys:sd
$	set noon
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		set verify
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc fixit=fixit,rev,clmin,clock
$ 		fort fixit   
$ 		ok=$status
$ 		if ok then pvv fixit   
$ 		purge/nolog fixit.obj
$ 		delete/nolog fixit.for;*
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 	link/map/exe=ifixarea ifixarea, -
	ifix_cld, getcmd, getfil, chkqual, -
	clofil , fixit, dfdcmd, fixinfo, -'
	ifix.promsg_obj, -
    LSL$LIBRARY:IFFSHR/OPT,-
    LSL$LIBRARY:LSLSHR/OPT
$ 		ifixex:
$ 		deass/group lsl$ifix_building
$ 		set nover
