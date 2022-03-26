$!
$	ilink=="$lsl$alpha_root:[structure.exe]ilink"
$!	@lsl$com:structureini
$!
$	icase=="$lsl$source_root:[structure.icase]icase"
$!
$	si lsl$source_root:[structure.icase]
$!
$	ilink/break	test2.iff test2.ifj
$	ilink/struct	test2.ifj test2.ifj
$	ilink/sortarms	test2.ifj test2.ifj
$!
$	icase   /par=lsl$source_root:[structure.icase]test2.par -
		test2.ifj -
		test2_cased.iff
$!
$	purge 	test2.*
$!
