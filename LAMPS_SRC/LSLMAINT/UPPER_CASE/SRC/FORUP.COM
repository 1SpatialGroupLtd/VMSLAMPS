$	ver:='f$verify(0)'
$	if p1 .nes. "?" then goto noqueer
$	type sys$input
FOR/MARUP build command file

Switches are:-
  D - Compile, link with debug
  F - Make a FORUP (default, overrides M)
  M - Make a MARUP
$	goto rever
$noqueer: on error then goto tidy
$	ppp:='p1''p2''p3''p4''p5''p6''p7'
$	forup=1
$	if f$locate("M",ppp) .lt. f$length(ppp) then forup=0
$	if f$locate("F",ppp) .lt. f$length(ppp) then forup=1
$	debug:=
$	if f$locate("D",ppp) .lt. f$length(ppp) then debug:="/debug"
$	file_to_build:="forup"
$	if .not.forup then file_to_build:="marup"
$	set verify
$	adc 'file_to_build'=forup/tr=(forup='forup')
$	fortran'debug' 'file_to_build'
$	pvv 'file_to_build'
$	delete adc.ide;*
$	link/map'debug' 'file_to_build',lsl$library:violib/library
$	purge/log 'file_to_build'.*
$tidy:	xxx:='f$verify(0)'
$rever:	if ver then set verify
