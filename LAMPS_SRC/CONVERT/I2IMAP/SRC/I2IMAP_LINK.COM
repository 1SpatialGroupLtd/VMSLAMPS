$!
$! LINK I2IMAP
$!
$! Mod 1435 Use new frtshr			JB 28-Nov-1994
$! Mod 1463 Allow linking on AXP		ST 01-Feb-1995
$!
$	if F$GETSYI("ARCH_NAME").eqs."Alpha"
$	then
$	   define lsl$frtshr_tv lsl$library:frtshr_dummy_axp
$	   define lsl$lslshr_tv lsl$library:lslshr_dummy_axp
$	   define lsl$iffshr_tv lsl$library:iffshr_dummy_axp
$	   suffix = "_tv"
$	   axp = "/nonative_only"
$	   prog = "i2imap_axp"
$	   vaxonly = ""
$	else
$	   suffix = ""
$	   axp = ""
$	   prog = "i2imap"
$	   vaxonly = ",set_addr"
$	endif
$!
$	set noverify
$	link_dir := "here:"
$	inquire DBG "link with debug           "
$	if DBG
$	then
$	  lbug  = "/debug"
$	  prog = prog + "_debug"
$	else
$	  lbug = ""
$	endif
$!
$	set verify
$	link'lbug''axp'/map='link_dir''prog'/exe='link_dir''prog' -
			i2imap,i2imap_cld,-
			get_command,rdpar,process,plottr,summary,-
			i2imap.promsg_obj,-
			lsl$library:frtshr'suffix'/opt,-
			lsl$library:iffshr'suffix'/opt,-
			lsl$library:lslshr'suffix'/opt,-
			sti_libs:debuglib/incl=(rdbms_entry_points'vaxonly'),-
			sti_libs:gwsoff/opt,-
			!!!sti_libs:stilib/include=(.main.),-
			sti_libs:stilib/lib,-
			sti_libs:dbmslib/lib,-
			sti_libs:usrlink/opt
$!
$	set noverify
$!
$!	purge			'link_dir'i2imap*.*
$end:
$!
$	if F$GETSYI("ARCH_NAME").eqs."Alpha"
$	then
$	   deassign lsl$frtshr_tv
$	   deassign lsl$lslshr_tv
$	   deassign lsl$iffshr_tv
$	endif
