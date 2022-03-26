$	adc vssiglib=vssiglib
$	for vssiglib
$	pvv vssiglib
$	delete adc.ide;*
$	libr/cre vssiglib vssiglib
$	pl
