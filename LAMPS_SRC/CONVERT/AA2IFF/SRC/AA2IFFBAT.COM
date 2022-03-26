$ 	set noverify
$	on control_y then goto aa2iex
$	if "''f$logical("lsl$aa2i_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	define/group lsl$aa2i_building "in_progress"
$	set noon
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		set verify
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		link/map/exe=aa2iff aa2iff, -
		aa2iff_cld, -
		obey, -
		rdpar, -
		process, -
		iff_start, -
		start_feature, -
		coord, -
		flush, -
		aa2iff.promsg_obj, -
		lsl$library:lslfrtlib/lib,-
		lsl$library:iffshr/opt,lslshr/opt
$ 		aa2iex:
$ 		deass/group lsl$aa2i_building
$ 		set nover
