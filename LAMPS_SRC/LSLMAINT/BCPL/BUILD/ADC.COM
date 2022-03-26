$	ver:='f$verify(0)'
$	if p1.eqs."" then p1="*"
$	@native 'p1' adc
$	if ver then set verify
