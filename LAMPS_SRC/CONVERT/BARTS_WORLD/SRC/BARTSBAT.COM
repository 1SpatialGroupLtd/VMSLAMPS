$ 	set noverify
$	on control_y then goto bartex
$	if "''f$logical("lsl$bart_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	define/group lsl$bart_building "in_progress"
$	set noon
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		set verify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		fort process.f
$ 		purge/nolog process.obj
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		link/map/exe=barts barts, -
		barts_cld, -
		obey, -
		set_ascii, -
		process, -
		lsl$library:lslshr/opt
$ 		bartex:
$ 		deass/group lsl$bart_building
$ 		set nover
