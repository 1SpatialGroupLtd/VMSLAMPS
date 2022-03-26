$	fort dtimask.f
$	fort process.f
$	macro cmdtab
$	link dtimask,process,cmdtab,-
		lsl$library:dtilib/lib,-
		lsl$library:lslshr/opt
$	delete *.obj;*
$	purge
