$!
$	ilink=="$lsl$alpha_root:[structure.exe]ilink"
$!	@lsl$com:structureini
$!
$	ioffset=="$lsl$source_root:[structure.icase.ioffset]ioffset"
$!
$	si lsl$source_root:[structure.icase.ioffset]
$!
$	ilink/break	test.iff test.ifj
$	ilink/struct	test.ifj test.ifj
$	ilink/sortarms	test.ifj test.ifj
$!
$	ioffset /par=lsl$source_root:[structure.icase.ioffset]test.par -
		test.ifj -
		test_cased.iff
$!
$	purge 	test.*
$!
