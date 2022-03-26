$	savver = f$verify(0)
$!
$	set noverify
$!
$	if p1.eqs."" then exit
$	file =	f$parse(p1,,,"node") + -
		f$parse(p1,,,"device") + -
		f$parse(p1,,,"directory") + -
		f$parse(p1,,,"name")
$!
$	fqual = f$edit(p2,"UPCASE")
$	if fqual.eqs."DEBUG" then fqual = -
		"/debug/noopt/check=(bounds,overflow,underflow)"
$!
$	set verify
$!
$	adc 'file'/co = 'file'
$	fort'fqual' 'file'
$	pvv 'file'
$	savver = f$verify(savver)
