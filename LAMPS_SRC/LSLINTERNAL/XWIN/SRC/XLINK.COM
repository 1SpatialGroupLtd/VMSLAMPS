$!	'f$verify(0)
$	QUALS = " "
$ 	IF (P2.EQS."D") THEN QUALS = "/debug"
$!
$	set verify
$	link 'QUALS' 'P1',sys$input:/opt
sys$share:decw$dwtlibshr/share
sys$share:decw$xlibshr/share
sys$library:vaxcrtl/share
$!	'f$verify(0)
$	purge 'P1'.exe
$       purge 'P1'.obj
