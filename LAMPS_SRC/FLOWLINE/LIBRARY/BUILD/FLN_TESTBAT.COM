$ 	set noverify
$	on control_y then goto fln_testex
$	if "''f$logical("lsl$fln_test_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	define/group lsl$fln_test_building "in_progress"
$	assign lsl$source_root:[flowline.src] lsl$cmnflowline
$	sd:=$lsl$sys:sd
$	set noon
$	emsg=""
$ 	set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 	set verify
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLN_TEST/co=FLN_TEST
$	fort/debug/noopt/check=(bounds,overflow)/list FLN_TEST
$ 	ok=$status
$ 	if ok then pvv FLN_TEST
$ 	purge/nolog FLN_TEST.obj
$ 	purge/nolog FLN_TEST.for
$ 	if ok then delete/nolog FLN_TEST.lis;*
$	if .not.ok then emsg=emsg+" FLN_TEST"
$ 	delete adc.ide;*
$	set noverify
$   set verify
$	MACRO  flntst+lsl$library:lslmaclib/lib
$   set noverify
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
$ 	link/map/debug/exe=fln_test fln_test,flntst,-
	lsl$cmnflowline:flowline/lib, -
	lsl$library:lsllib/lib
$ 	nolnk:
$ 	fln_testex:
$   purge/log fln_test.exe,fln_test.map
$ 	deass/group lsl$fln_test_building
$ 	set nover
