$ 	set noverify
$ 	set noon
$	on control_y then goto i2dxfex
$	if "''f$logical("lsl$i2dxf_building")'" -
		 .nes. "in_progress" then goto a0
$	WRITE SYS$OUTPUT "Someone else is building"
$	exit
$!
$a0:	define/group lsl$i2dxf_building "in_progress"
$	sd:=$lsl$sys:sd
$	set noon
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		set verify
$	newmsg i2dxf.mes/number=1622/runoff/hl=2
$	purge i2dxfmsg.rno
$	purge i2dxf.promsg_obj
$	@i2dxf.temp_com
$ 		adc i2dxf.tmp=i2dxf_cld.cld
$ 		set command/object=i2dxf_cld i2dxf.tmp
$ 		ok=$status
$ 		if ok then pvv i2dxf_cld
$ 		if ok then delete/noconfirm i2dxf.tmp;*
$ 		if ok then delete/noconfirm adc.ide;*
$ 		if ok then purge/nolog i2dxf_cld.obj
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$		set verify
$ 		adc i2dxf=i2dxf
$ 		fort i2dxf
$ 		ok=$status
$ 		if ok then pvv i2dxf
$ 		purge/nolog i2dxf.obj
$ 		purge/nolog i2dxf.for
$ 		delete/noconfirm adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc getcmd=getcmd
$ 		fort getcmd
$ 		ok=$status
$ 		if ok then pvv getcmd
$ 		purge/nolog getcmd.obj
$ 		purge/nolog getcmd.for
$ 		delete/noconfirm adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc read_iff=read_iff
$ 		fort read_iff
$ 		ok=$status
$ 		if ok then pvv read_iff
$ 		purge/nolog read_iff.obj
$ 		purge/nolog read_iff.for
$ 		delete/noconfirm adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc circle_sol=circle_sol
$ 		fort circle_sol
$ 		ok=$status
$ 		if ok then pvv circle_sol
$ 		purge/nolog circle_sol.obj
$ 		purge/nolog circle_sol.for
$ 		delete/noconfirm adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc iff_line=iff_line
$ 		fort iff_line
$ 		ok=$status
$ 		if ok then pvv iff_line
$ 		purge/nolog iff_line.obj
$ 		purge/nolog iff_line.for
$ 		delete/noconfirm adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc iff_point=iff_point
$ 		fort iff_point
$ 		ok=$status
$ 		if ok then pvv iff_point
$ 		purge/nolog iff_point.obj
$ 		purge/nolog iff_point.for
$ 		delete/noconfirm adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc iff_circle=iff_circle
$ 		fort iff_circle
$ 		ok=$status
$ 		if ok then pvv iff_circle
$ 		purge/nolog iff_circle.obj
$ 		purge/nolog iff_circle.for
$ 		delete/noconfirm adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc iff_arc=iff_arc
$ 		fort iff_arc
$ 		ok=$status
$ 		if ok then pvv iff_arc
$ 		purge/nolog iff_arc.obj
$ 		purge/nolog iff_arc.for
$ 		delete/noconfirm adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc iff_text=iff_text
$ 		fort iff_text
$ 		ok=$status
$ 		if ok then pvv iff_text
$ 		purge/nolog iff_text.obj
$ 		purge/nolog iff_text.for
$ 		delete/noconfirm adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc iff_insert=iff_insert
$ 		fort iff_insert
$ 		ok=$status
$ 		if ok then pvv iff_insert
$ 		purge/nolog iff_insert.obj
$ 		purge/nolog iff_insert.for
$ 		delete/noconfirm adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc iff_poly=iff_poly
$ 		fort iff_poly
$ 		ok=$status
$ 		if ok then pvv iff_poly
$ 		purge/nolog iff_poly.obj
$ 		purge/nolog iff_poly.for
$ 		delete/noconfirm adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc iff_circum=iff_circum
$ 		fort iff_circum
$ 		ok=$status
$ 		if ok then pvv iff_circum
$ 		purge/nolog iff_circum.obj
$ 		purge/nolog iff_circum.for
$ 		delete/noconfirm adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc newstart=newstart
$ 		fort newstart
$ 		ok=$status
$ 		if ok then pvv newstart
$ 		purge/nolog newstart.obj
$ 		purge/nolog newstart.for
$ 		delete/noconfirm adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc gttxtlnth=gttxtlnth
$ 		fort gttxtlnth
$ 		ok=$status
$ 		if ok then pvv gttxtlnth
$ 		purge/nolog gttxtlnth.obj
$ 		purge/nolog gttxtlnth.for
$ 		delete/noconfirm adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		link/map/cross/exe=i2dxf i2dxf, -
		i2dxf_cld, getcmd, read_iff, -
		circle_sol, iff_line, iff_point, -
		iff_circle, iff_arc, iff_text, iff_insert, -
		iff_poly, iff_circum, newstart, gttxtlnth, -
		here:i2dxf.promsg_obj, -
		lsl$dxfpar:dxfpar.promsg_obj, -
		lsl$dxfpar:dxfparlib/lib, -
		lsl$library:lslfrtlib/lib, lslshr/opt, -
		iffshr/opt
$ 		i2dxfex:
$ 		deass/group lsl$i2dxf_building
$ 		set nover
