$!
$! LINK I2IMAP
$!
$! Mod 1435 Use new frtshr			JB 28-Nov-1994
$!
$	set noverify
$	link_dir := "here:"
$	inquire DBG "link with debug           "
$	if DBG
$	then
$	  lbug  = "/debug"
$	  prog = "i2imap_debug"
$	else
$	  prog = "i2imap"
$	endif
$!
$	set verify
$	link'lbug'/map='link_dir'/exe='link_dir''prog' -
			i2imap,i2imap_cld,-
			get_command,rdpar,process,plottr,summary,-
			i2imap.promsg_obj,-
			lsl$library:frtshr/opt,-
			lsl$library:iffshr/opt,-
			lsl$library:lslshr/opt,-
			sti_libs:debuglib/incl=(rdbms_entry_points,set_addr),-
			sti_libs:gwsoff/opt,-
			sti_libs:stilib/include=(.main.),-
			sti_libs:stilib/lib,-
			sti_libs:dbmslib/lib,-
			sti_libs:usrlink/opt
$!
$	set noverify
$!
$!	purge			'link_dir'i2imap*.*
$end:
$!
