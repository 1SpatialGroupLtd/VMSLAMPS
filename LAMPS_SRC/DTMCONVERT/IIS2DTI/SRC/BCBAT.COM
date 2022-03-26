$ 	set noverify
$	on control_y then goto bcex
$	if "''f$logical("lsl$bc_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	define/group lsl$bc_building "in_progress"
$	sd:=$lsl$sys:sd
$	set noon
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		set verify
$ 		adc block_copy.tmp=block_copy_cld.cld
$ 		set command/object=block_copy_cld block_copy.tmp
$ 		ok=$status
$ 		if ok then pvv block_copy_cld
$ 		if ok then delete block_copy.tmp;*
$ 		if ok then purge/nolog block_copy_cld.obj
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		adc block_copy =block_copy
$ 		fort block_copy
$ 		ok=$status
$ 		if ok then pvv block_copy
$ 		purge/nolog block_copy.obj
$ 		purge/nolog block_copy.for
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		link/map/cross/exe=block_copy block_copy,-
		block_copy_cld, -
		lsl$library:lslshr/opt
$ 		bcex:
$ 		deass/group lsl$bc_building
$ 		set nover
