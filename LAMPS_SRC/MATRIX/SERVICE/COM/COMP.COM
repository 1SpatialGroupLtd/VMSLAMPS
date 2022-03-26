$ ass lsl$source_root:[matrix.service] lsl$matrixsys
$ if p1 .eqs. "" then inq/nop p1 "File? "
$ if p1.nes."" then call compiler 'p1'
$ exit
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ compiler: subroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc 'p1'/co='p1'
$	fort/deb/noopt/che=(b,o) 'p1'
$ 	ok=$status
$ 	if ok then pvv 'p1'
$ 	purge/nolog 'p1'.obj
$	purge/nolog 'p1'.for
$ 	delete adc.ide;*
$	set noverify
$	return
$ endsubroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
