$!
$	si lsl$source_root:[convert.i2digit]
$!
$!	i2digit=="$lsl$source_root:[convert.i2digit]i2digit"
$!
$!	i2digit	/part=atestttt -
$!		/para=test.par -
$!		/log -
$!		/noappend -
$!		/RESOLUTION 	=7-
$!		/SCALE_IFF	=777.7-
$!		/SCALE_SHEET	=77777.7-
$!		/OFFSET		=(777,777)-
$!		/BORDER		=70-
$!		/XMIN		=700.0-
$!		/XMAX		=17000.0-
$!		/YMIN		=700.0-
$!		/YMAX		=17000.0-
$!		test -
$!		mub1:
$	i2digit	/part=atestttt -
		/para=test.par -
		/log -
		/noappend -
		/RESOLUTION 	=20-
		/OFFSET		=(10,10)-
		/BORDER		=10-
		/XMIN		=0-
		/XMax		=300-
		/yMax		=300-
		/scale_factor  -
		abercontour -
		mub1:
$!
$	purge test.*
$!
