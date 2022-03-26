$	set noverify
$	inquire DBG "with debug"
$	deb:=""
$	if DBG then deb:="/debug"
$!
$	set verify
$	mac vscmd
$	adc vsci=vsci
$	for'deb' vsci
$	pvv vsci
$	delete vsci.for;*,adc.ide;*
$	pur vsci.obj
$	set noverify
$!
