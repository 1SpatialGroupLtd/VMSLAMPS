$	v:='f$verify(0)'
$	set verify
$	pip lsl$library:cmdlib.olb/up=here:cmdlib.olb
$	xxx:='f$verify(0)'
$	if v then set verify
