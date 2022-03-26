$!
$! command file to create Versatec support routines for calcomp HCBS
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
$	ADC		VERSATEC=VERSATEC
$	FORTRAN'dbg'	VERSATEC
$	PVV		VERSATEC
$	DELETE		ADC.IDE;*
$	PURGE		VERSATEC.OBJ
$ 	if .not.debug then DELETE VERSATEC.FOR;*
$!
$	set noverify
