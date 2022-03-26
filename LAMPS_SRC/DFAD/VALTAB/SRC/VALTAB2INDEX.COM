$	set verify
$!
$	vti :== $lsl$source_root:[dfad.valtab]valtab2index
$	ass lsl$source_root:[dfad.fadtcmn] lsl$fadtcmn
$!
$	fort valtab2index.src
$	fort display_rule.src
$	fort open_files.src
$	fort close_files.src
$	fort read_rule.src
$	fort write_rule.src
$!
$	link -
	 	valtab2index,-
		display_rule,-
		open_files,-
		close_files,-
		read_rule,-
		write_rule,-
		lsl$library:lslshr/opt
$	set noverify
