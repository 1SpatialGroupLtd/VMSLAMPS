$!
$	ilink=="$lsl$alpha_root:[structure.exe]ilink"
$!	@lsl$com:structureini
$!
$	icase=="$lsl$source_root:[structure.icase]icase"
$!
$	si lsl$source_root:[structure.icase]
$!
$	ilink/break	test1.iff test1.ifj
$	ilink/struct	test1.ifj test1.ifj
$	ilink/sortarms	test1.ifj test1.ifj
$!
$	icase   /par=lsl$source_root:[structure.icase]test1.par -
		test1.ifj -
		test1_cased.iff
$!
$	purge 	test1.*
$!
