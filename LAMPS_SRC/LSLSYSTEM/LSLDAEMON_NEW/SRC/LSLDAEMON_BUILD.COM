$	cdebug=p1.EQS."D"
$	fswitch=""
$	lswitch=""
$	IF cdebug THEN fswitch="/DEBUG/NOOPT"
$	IF cdebug THEN lswitch="/DEBUG"
$	ADC lsldaemon=lsldaemon
$	FORT lsldaemon'fswitch'
$	PVV lsldaemon
$	DELETE adc.ide;*
$	IF .NOT.cdebug THEN DELETE lsldaemon.for;*
$	LINK lsldaemon'lswitch'
$	PURGE lsldaemon.*
