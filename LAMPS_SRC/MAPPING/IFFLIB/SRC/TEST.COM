$	adc test=test
$	for/deb/noopt test
$	pvv test
$	delete adc.ide;*
$	link/deb/map/full	test,sys$input:/opt
ifflib/lib
$	pl
