$	ws="write sys$output"
$	set noverify
$	on control_y then goto ipolygonex
$	is_build = f$logical("lsl$ipolygon_building")
$	if "''is_build'".eqs."in_progress"
$	then
$	  ws "Someone else is building"
$	  exit
$	endif
$!
$	define/group lsl$ipolygon_building "in_progress"
$ assign lsl$source_root:[newpolygons.service.src] lsl$cmnpolygons
$ assign lsl$source_root:[newpolygons.service.lib] lsl$cmnpolygonsl
$ assign lsl$source_root:[newpolygons.ipolygon.src] lsl$cmnipolygon
$	set noon
$	emsg=""
$	linkit="T"
$	set noverify

$	ws "----------------------compiling SIDE_TAB -------"
$	ws ""
$	adc SIDE_TAB=SIDE_TAB
$	set verify
$	fort/list SIDE_TAB
$	ok=$status
$	set noverify
$	purge/nolog SIDE_TAB.for
$	delete adc.ide;*
$	if ok
$	then
$	  delete/nolog SIDE_TAB.lis;*
$	endif
$!
$	if ok
$	then
$	  pvv SIDE_TAB
$	  purge/nolog SIDE_TAB.obj
$	else
$	  emsg=emsg+" SIDE_TAB"
$	  goto err
$	endif
$err:	set noverify
$	if emsg.nes.""
$	then
$	  ws "----------------------"
$	  ws "Compilation errors in:"
$	  ws emsg
$	  ws ""
$	  linkit = "F"
$	endif
$	ipolygonex:
$	deass/group lsl$ipolygon_building
$	set nover
