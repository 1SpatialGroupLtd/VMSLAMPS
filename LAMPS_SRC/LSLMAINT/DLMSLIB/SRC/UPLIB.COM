$	v='f$verify(0)
$	set verify
$	pip lsl$library:dlmslib.olb/up=here:dlmslib.olb
$	v='f$verify(v)
