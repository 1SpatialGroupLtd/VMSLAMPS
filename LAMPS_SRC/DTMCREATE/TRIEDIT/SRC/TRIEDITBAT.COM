$ 	set noverify
$	on control_y then goto trieditex
$	if "''f$logical("lsl$triedit_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	define/group lsl$triedit_building "in_progress"
$	assign lsl$source_root:[dtmcreate.triedit] lsl$cmntriedit
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
$ 	run lsl$exe:genver
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc version=version
$	fort version
$ 	ok=$status
$ 	if ok then pvv version
$ 	purge/nolog version.obj
$ 	delete/nolog version.for;*
$	if .not.ok then emsg=emsg+" version"
$ 	delete adc.ide;*
$	set noverify
$ 	purge/nolog version.src
$   set verify
$   define/user lsl$dtm_gksshr lsl$exe:dtm_gksnullshr
$ 	link/map/full/cross/exe=triedit triedit/opt,lsl$library:iffshr/opt,lslshr/opt
$ 	nolnk:
$ 	trieditex:
$ 	deass/group lsl$triedit_building
$ 	set nover
