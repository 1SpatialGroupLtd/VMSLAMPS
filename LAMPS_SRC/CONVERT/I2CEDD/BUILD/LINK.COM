$ 	set noverify
$	on control_y then goto i2ceddex
$	if "''f$logical("lsl$i2cedd_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	define/group lsl$i2cedd_building "in_progress"
$	assign lsl$source_root:[convert.i2cedd] lsl$i2cedd
$	sd:=$lsl$exe:sd
$	sd lsl$source_root:[convert.i2cedd]
$	set noon
$	emsg=""
$ 	set noverify
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
$ 	link/map/debug/exe=i2cedd i2cedd/opt, -
		i2cedd.promsg_obj, -
		lsl$library:lslfrtlib/lib,-
		lsl$library:lslshr/opt, lsl$library:iffshr/opt
$ 	nolnk:
$ 	i2ceddex:
$ 	deass/group lsl$i2cedd_building
$ 	set nover
