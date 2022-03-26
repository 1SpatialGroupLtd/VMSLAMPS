$ 	set noverify
$	on control_y then goto dticontourex
$	if "''f$logical("lsl$dticontour_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	define/group lsl$dticontour_building "in_progress"
$	assign lsl$source_root:[dtmprocess.dticontour] lsl$cmndticontour
$	assign lsl$source_root:[dtmprocess.service] lsl$dtmprocesssys
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
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc VERSION=VERSION
$	fort VERSION
$ 	ok=$status
$ 	if ok then pvv VERSION
$ 	purge/nolog VERSION.obj
$ 	delete/nolog VERSION.for;*
$	if .not.ok then emsg=emsg+" VERSION"
$ 	delete adc.ide;*
$	set noverify
$ 	purge/nolog version.src
$ set verify
$ 	link/map/debug/exe=dticontour dticontour/opt
$ 	nolnk:
$ 	dticontourex:
$ 	deass/group lsl$dticontour_building
$ 	set nover
