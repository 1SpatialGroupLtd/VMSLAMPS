$!
$	set noverify
$	on control then goto end
$	on error then goto end
$!
$	set verify
$	adc appendix = appendix
$	fort appendix
$	pvv appendix
$	delete	adc.ide;*
$	purge appendix.obj
$	delete  appendix.for;*
$!
$	adc md2dat = lsl$cmniff:md2dat
$	fort md2dat
$	pvv md2dat
$	delete adc.ide;*
$	purge md2dat.obj
$	delete md2dat.for;*
$!!!	link	appendix,md2dat,lsl$SOURCE_ROOT:[LSLMAINT.GCTPLIB]gctpdlib/lib,-
$!!!                     lsl$library:lsllib/lib
$	link	appendix,md2dat,lsl$library:gctplib/lib,-
                     lsl$library:lsllib/lib
$	delete md2dat.obj;*,appendix.obj;*
$	purge appendix.exe
$	run appendix
$	runoff appendix
$	purge appendix.rno
$	purge appendix.mem
$ end:	set noverify
