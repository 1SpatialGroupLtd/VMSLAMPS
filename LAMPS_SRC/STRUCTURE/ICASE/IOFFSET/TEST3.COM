$!
$	ilink=="$lsl$alpha_root:[structure.exe]ilink"
$!	@lsl$com:structureini
$!
$	icase=="$lsl$source_root:[structure.icase]icase"
$!
$	si lsl$source_root:[structure.icase]
$!
$	ilink/break/mintol=0.3	test3.iff test3.ifj
$	ilink/struct		test3.ifj test3.ifj
$	ilink/sortarms		test3.ifj test3.ifj
$!
$	icase   /par=lsl$source_root:[structure.icase]test3.par -
		test3.ifj -
		test3_cased.iff
$!
$	purge 	test3.*
$!
