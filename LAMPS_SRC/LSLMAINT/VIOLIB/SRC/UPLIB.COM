$	v='f$verify(0)
$	tmp:='F$LOGICAL("HERE")'
$	if tmp .eqs. "" then assign 'F$LOGICAL("SYS$DISK")''F$DIR()' HERE
$	set verify
$	pip lsl$library:violib.olb/up=here:violib.olb
$	v='f$verify(v)
