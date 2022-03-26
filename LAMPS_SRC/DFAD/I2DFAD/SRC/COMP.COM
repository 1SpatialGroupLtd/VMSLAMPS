$	savver = f$verify(1)
$	adc 'p1'/co='p1'
$	fort'p2' 'p1'
$	pvv 'p1'
$	savver = f$verify(savver)
