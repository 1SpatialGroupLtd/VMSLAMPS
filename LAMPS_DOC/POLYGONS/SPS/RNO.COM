$! Jiffy command file to run-off the POLYGONS SPS
$!
$! Created (copied from [IMP.SPS]RNO.COM)		TJH  10-Apr-1987
$!	
$	ver_stat=f$verify(0)
$	inq/nop qump "Print directly onto QUME? "
$	out=""
$	if qump then out="/output=lsl$lqp:/backspace"
$	runoff/underline/bold=3'out' POLYGONS_SPS
$	if .not.qump then purge/log POLYGONS_sps.mem
$	if ver_stat then set ver
