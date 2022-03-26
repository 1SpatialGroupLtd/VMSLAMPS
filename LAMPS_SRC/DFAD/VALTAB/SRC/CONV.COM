$	set verify
$	wait 00:02
$	mtd valtab_dump=mt:/bl:4:150/icl/ch/wid:44/nh
$	set noverify
