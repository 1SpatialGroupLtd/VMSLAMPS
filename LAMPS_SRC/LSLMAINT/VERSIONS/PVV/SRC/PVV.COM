$	ver:='f$verify(0)'
$	if p1.nes."?" then goto not_help
$	type sys$input:
Command file to regenerate PVV

Switches, as usual (nowadays!) in P1 only

 D - Compile, assemble, link with debug
 NF - Don't do the Fortran bit
 NM - Don't do the Macro bit

Default is to compile and link the whole caboodle
$	goto tidy_ver
$!
$not_help: ass=1
$	if f$locate("NM",p1).lt.f$length(p1) then ass=0
$	p1=p1-"NM"
$	compile=1
$	if f$locate("NC",p1).lt.f$length(p1) then compile=0
$	p1=p1-"NC"
$	debug=0
$	if f$locate("D",p1).lt.f$length(p1) then debug=1
$	p1=p1-"D"
$	if p1.nes."" then write sys$output "*** Unexpected switches """,p1,""""
$	adeb=""
$	if debug then adeb="/de"
$	deb=""
$	if debug then deb="/debug"
$	mdeb=""
$	if debug then mdeb="/en=(deb)"
$	on error then goto tidy
$	if .not.ass then goto try_compile
$	set verify
$	macro'mdeb' rmsio
$	xxx:='f$verify(0)'
$try_compile: if .not. compile then goto link
$	set verify
$	adc pvv=cfstr'adeb',getfile,pvv'adeb',rdide'adeb'
$	fortran'deb' pvv
$	pvv pvv
$	xxx:='f$verify(0)'
$link:	set verify
$	link'deb'/map pvv,rmsio,lsl$library:violib/lib
$tidy:	xxx:='f$verify(0)'
$	set verify
$	purge/log
$tidy_ver: xxx:='f$verify(0)'
$	if ver then set verify
