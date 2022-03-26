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
$	newmsg/number=1627/prefix=aa2i__/param=fortran/runoff/hl=2 aa2iff.mes
$	@aa2iff.temp_com
$	purge aa2iffmsg.rno
$ 		adc aagaz2iff.tmp=aagaz2iff_cld.cld
$ 		set command/object=aagaz2iff_cld aagaz2iff.tmp
$ 		ok=$status
$ 		if ok then delete aagaz2iff.tmp;*
$ 		if ok then purge/nolog aagaz2iff_cld.obj
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		fort aagaz2iff.f
$ 		purge/nolog aagaz2iff.obj
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		fort gazobey.f
$ 		purge/nolog gazobey.obj
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		fort rdpar.f
$ 		purge/nolog rdpar.obj
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		fort congaz.f
$ 		purge/nolog congaz.obj
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		fort iff_start.f
$ 		purge/nolog iff_start.obj
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		fort start_feature.f
$ 		purge/nolog start_feature.obj
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		fort coord2d.f
$ 		purge/nolog coord2d.obj
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		link/map/cross/exe=aagaz2iff aagaz2iff, -
		aagaz2iff_cld, -
		gazobey, -
		rdpar, -
		congaz, -
		iff_start, -
		start_feature, -
		coord2d, -
		aa2iff.promsg_obj, -
		lsl$library:lslfrtlib/lib,-
		lsl$library:iffshr/opt,lslshr/opt
$ 		aa2iex:
$ 		deass/group lsl$aa2i_building
$ 		set nover
