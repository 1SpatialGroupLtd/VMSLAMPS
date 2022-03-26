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
