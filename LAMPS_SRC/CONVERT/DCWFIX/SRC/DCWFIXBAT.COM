$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-14 12:56:10.000000000 +0100
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
$	on control_y then goto dcwfixex
$	if "''f$logical("lsl$dcwfix_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	define/group lsl$dcwfix_building "in_progress"
$	assign lsl$source_root:[convert.dcwfix] lsl$cmndcwfix
$	sd:=$lsl$sys:sd
$	set noon
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		set verify
$	newmsg/number=1206/name=dcwfix/prefix=iren__/parameter=for dcwfix.mes
$ @dcwfix.temp_com
$ 		adc DCWFIX.TMP=DCWFIX_cld.CLD
$ 		set command/object=DCWFIX_CLD DCWFIX.TMP
$ 		ok=$status
$ 		if ok then pvv DCWFIX_CLD
$ 		ok=$status
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc dcwfix=dcwfix
$ 		fort dcwfix
$ 		ok=$status
$ 		if ok then pvv dcwfix
$ 		purge/nolog dcwfix.obj
$ 		delete/nolog dcwfix.for;*
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
$ 		adc fix =fix 
$ 		fort fix 
$ 		ok=$status
$ 		if ok then pvv fix 
$ 		purge/nolog fix.obj
$ 		delete/nolog fix.for;*
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
$ 		link/map/exe=dcwfix dcwfix, -
		dcwfix_cld, getcmd, chkqual, fix,-
		closef , -'
		dcwfix.promsg_obj, -
		lsl$library:iffshr/opt,lslshr/opt
$ 		dcwfixex:
$ 		deass/group lsl$dcwfix_building
$ 		set nover
