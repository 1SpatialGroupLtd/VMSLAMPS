$!
$! command file to create Benson 3000 support routines for calcomp HCBS
$!
$ set noverify
$!
$	dbg = ""
$	inquire debug "with debug "
$	if debug then dbg = "/debug/noopt"
$!
$!
$ set verify
$!
$	ADC		BEN3000=BEN3000
$	FORTRAN'dbg'	BEN3000
$	PVV		BEN3000
$	DELETE		ADC.IDE;*
$	PURGE		BEN3000.OBJ
$ 	if .not.debug then DELETE BEN3000.FOR;*
$!
$	set noverify
