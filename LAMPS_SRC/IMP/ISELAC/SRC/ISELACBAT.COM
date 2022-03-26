$ 	set noverify
$	on control_y then goto iselacex
$	if "''f$logical("lsl$iselac_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:  define/group lsl$iselac_building "in_progress"
$	assign lsl$source_root:[imp.iselac] lsl$cmniselac
$	sd:=$lsl$sys:sd
$	set noon
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		set verify
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc iselac=iselac
$ 		fort iselac
$ 		ok=$status
$ 		if ok then pvv iselac
$ 		purge/nolog iselac.obj
$ 		delete/nolog iselac.for;*
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ link/map/exe=iselac iselac,-
 selcmd, getcmd, acskrd, setup, copent, -
 seldec , help, opnfil, skelrd, prompt, -'
 actest, reject, show, read_prompt, copy_string,-'
 reset, iselac.promsg_obj, -
		lsl$library:iffshr/opt,lslshr/opt
$ 		iselacex:
$ 		deass/group lsl$iselac_building
$ 		set nover
