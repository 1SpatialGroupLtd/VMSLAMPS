$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1987-12-15 11:45:16.000000000 +0000
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
$	on control_y then goto irenumberex
$	if "''f$logical("lsl$irenumber_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	define/group lsl$irenumber_building "in_progress"
$	assign lsl$source_root:[imp.irenumber] lsl$cmnirenumber
$	sd:=$lsl$sys:sd
$	set noon
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		set verify
$	newmsg/number=1206/name=irenumber/prefix=iren__/parameter=for irenumber.mes
$ @irenumber.temp_com
$ 		adc IRENUMBER.TMP=IRENUMBER_cld.CLD
$ 		set command/object=IRENUMBER_CLD IRENUMBER.TMP
$ 		ok=$status
$ 		if ok then pvv IRENUMBER_CLD
$ 		ok=$status
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc irenumber=irenumber
$ 		fort irenumber
$ 		ok=$status
$ 		if ok then pvv irenumber
$ 		purge/nolog irenumber.obj
$ 		delete/nolog irenumber.for;*
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc getcmd=getcmd
$ 		fort getcmd
$ 		ok=$status
$ 		if ok then pvv getcmd
$ 		purge/nolog getcmd.obj
$ 		delete/nolog getcmd.for;*
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc closef =closef 
$ 		fort closef 
$ 		ok=$status
$ 		if ok then pvv closef 
$ 		purge/nolog closef.obj
$ 		delete/nolog closef.for;*
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc renum =renum 
$ 		fort renum 
$ 		ok=$status
$ 		if ok then pvv renum 
$ 		purge/nolog renum.obj
$ 		delete/nolog renum.for;*
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc chkqual=chkqual
$ 		fort chkqual
$ 		ok=$status
$ 		if ok then pvv chkqual
$ 		purge/nolog chkqual.obj
$ 		delete/nolog chkqual.for;*
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		link/map/CROSS/exe=irenumber irenumber, -
		irenumber_cld, getcmd, chkqual, renum,-
		closef , -'
		irenumber.promsg_obj, -
		lsl$library:iffshr/opt,lslshr/opt
$ 		irenumberex:
$ 		deass/group lsl$irenumber_building
$ 		set nover
