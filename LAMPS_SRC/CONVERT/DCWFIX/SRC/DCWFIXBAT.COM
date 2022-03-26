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
