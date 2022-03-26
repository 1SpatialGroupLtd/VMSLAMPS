$	ver:='f$verify(0)'
$	if p1 .nes. "?" then goto no_queer
$	type sys$input:
Single-letter switches on command line:

 D - compile, link with debug
 F - do FORTRAN compilation only
 L - link only
 M - do MACRO assembly only
$	goto tidy_ver
$!
$no_queer: ppp=p1+p2+p3+p4+p5+p6+p7
$	debug:=
$	dofor=1
$	domac=1
$	if f$locate("D",ppp) .lt. f$length(ppp) then debug:="/debug"
$	if f$locate("F",ppp) .lt. f$length(ppp) then domac=0
$	if f$locate("M",ppp) .lt. f$length(ppp) then dofor=0
$	if f$locate("L",ppp) .ge. f$length(ppp) then goto end_switch
$	dofor=0
$	domac=0
$end_switch: if .not.dofor then goto try_macro
$	on error then goto tidy_ver
$	set verify
$	adc pasup=pasup,[npg.progs]upcase
$	fortran'debug' pasup
$	pvv pasup
$	xxx:='f$verify(0)'
$	to_del="adc.ide;*"
$	if debug.eqs."" then to_del=to_del+",pasup.for;*"
$	set verify
$	purge/log pasup.obj
$	delete/log 'to_del'
$	xxx:='f$verify(0)'
$try_macro: if .not.domac then goto link_it
$	set verify
$	macro pascmd
$	purge/log pascmd.obj
$	xxx:='f$verify(0)'
$link_it: set verify
$	link'debug'/map	pasup,pascmd,-
			lsl$library:cmdlib/lib,violib/lib
$	purge/log pasup.*
$tidy_ver: xxx:='f$verify(0)'
$	if ver then set verify
