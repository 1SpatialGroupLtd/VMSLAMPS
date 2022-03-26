$	set verify
$	assign lsl$source_root:[alvey.satmap.2d_ori.transp] lsl$rcp
$	assign lsl$source_root:[alvey.satmap.2d_ori.transp] lsl$hdr
$	assign lsl$source_root:[alvey.satmap.2d_ori.transp] lsl$help
$	transp :== $lsl$source_root:[alvey.satmap.2d_ori.transp]transp
$	set noverify
