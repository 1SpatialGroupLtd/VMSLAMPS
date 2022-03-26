$!
$! 	command file to compile and link DTIPATCH
$!
$	def	lsl$matrixsys	lsl$source_root:[matrix.service]
$!
$	set verify
$	deb=""
$	inquire compile "compile"
$	inquire debug "debug"
$	inquire lnk  "link"
$!
$	if .not.debug then goto nodebug
$	if debug then deb = "/debug/noopt/check=(b,o)"
$	if debug then ibug = "/debug"
$!
$nodebug: if .not.compile then goto LINK
$!
$	adc dtipatch = dtipatch
$	fortran 'deb' dtipatch
$	pvv 'objprel' dtipatch
$	purge dtipatch.for
$!
$link: if .not.lnk then goto nolnk
$	run lsl$exe:genver
$	adc version=version
$	fortran version
$	pvv version
$	purge version.*
$	delete adc.ide;*
$!
$	link/map 'ibug'	dtipatch,-
			version,-
			lsl$matrixsys:matrix/lib,-
			lsl$library:dtilib/lib,-
			lsl$library:lslshr.opt/opt
$!	purge *.exe
$!
$nolnk:	set noverify
$!
