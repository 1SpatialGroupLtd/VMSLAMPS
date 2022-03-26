$ 	set noverify
$	on control_y then goto triangex
$	if "''f$logical("lsl$triang_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	define/group lsl$triang_building "in_progress"
$	assign lsl$source_root:[dtmcreate.triang] lsl$cmntriang
$	assign lsl$source_root:[dtmcreate.service] lsl$dtmcreatesys
$	sd:=$lsl$sys:sd
$	set noon
$	emsg=""
$ 	set noverify
$	libr = "library/replace/log  triang_fortran_sources"
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 	set verify
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
$   set verify
$   define/user lsl$dtm_gksshr lsl$exe:dtm_gksnullshr
$   link/map/full/debug/exe=triang triang/opt,lsl$library:iffshr/opt,lslshr/opt
$ 	nolnk:
$ 	triangex:
$ 	deass/group lsl$triang_building
$ 	set nover
