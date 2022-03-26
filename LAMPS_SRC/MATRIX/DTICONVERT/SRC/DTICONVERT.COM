$!
$! 	command file to compile and link DTICONVERT
$! 	DTI format conversion program.
$!
$!	MOD1517 Add LSL$LIBRARY:LSLDLMSLIB for ADDANG routine	JB 10-Jan-1996
$!
$	set noverify
$!
$	def 	lsl$matrixsys	lsl$source_root:[matrix.service]
$!
$	dbg := ""
$	deb := ""
$!
$	inquire ans "Compile/link with debug? "
$!
$	if ans then dbg := /debug
$	if ans then deb := /debug/noopt/check=(b,o)/lis
$!
$	inquire main "main"
$       inquire copy "copy_bit,copy_byte,copy_word,copy_long,copy_real"
$	inquire mar "mar"
$	inquire lnk "link"
$!
$	testtab = 0
$	tablib = "lsl$library:tablib"
$!
$	set verify
$!
$ 	if .not. main then goto nomain
$	adc dticonvert = dticonvert
$	fort 'deb' dticonvert
$	pvv dticonvert
$	delete adc.ide;*
$	pur dticonvert.*
$!
$ nomain: if .not. copy then goto nocopy
$       adc copy = copy_bit,copy_byte,copy_word,copy_long,copy_real
$       fort 'deb' copy
$       pvv copy
$       delete adc.ide;*
$       pur copy.*
$!
$ nocopy: if .not. mar then goto link
$	macro dticmd + lsl$library:lslmaclib/lib
$	pur dticmd.obj
$!
$ link: if .not.lnk then goto nolnk
$	run lsl$exe:genver
$	adc version=version
$	fort version
$	pvv version
$       delete adc.ide;*
$	purge version.*
$!
$	link'dbg'/map	dticonvert,copy,dticmd,version,-
			lsl$matrixsys:matrix/lib,-
			lsl$library:dtilib/lib,-
			lsl$library:lsldlmslib/lib,-
			lsl$library:lslshr/opt
$	pur *.map
$	if deb .nes. "" then pur *.lis
$!
$nolnk:	set noverify
$!
