$	set noverify
$! command file to compile and link GENVER
$	set verify
$	adc GENVER=GENVER
$	fort GENVER
$	pvv GENVER
$	delete adc.ide;*
$	delete GENVER.FOR;*
$	link GENVER
$	delete GENVER.OBJ;*
$	purge GENVER.EXE
$	set noverify
