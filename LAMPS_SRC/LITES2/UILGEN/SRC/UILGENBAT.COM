$ 	set noverify
$	on control_y then goto uilgenex
$	if "''f$logical("lsl$uilgen_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	define/group lsl$uilgen_building "in_progress"
$	assign lsl$source_root:[lites2.motif.uilgen] lsl$cmnuilgen
$	set noon
$	emsg=""
$ 	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc PROCESS_FILE=PROCESS_FILE
$	fort PROCESS_FILE
$ 	ok=$status
$ 	if ok then pvv PROCESS_FILE
$ 	purge/nolog PROCESS_FILE.obj
$ 	delete/nolog PROCESS_FILE.for;*
$	if .not.ok then emsg=emsg+" PROCESS_FILE"
$ 	delete adc.ide;*
$	set noverify
$	set verify
$	link/exe=UILGENMOTIF  uilgen, -
	uilgencmd, -
	cld_init, -
	init_uil, -
	process_file, -
	process_icon, -
	write_callback, -
	write_uil, -
	uilgen_cld, -
	uilgen.promsg_obj, -
	lsl$library:lslshr/opt
$	purge/nolog uilgenmotif.*
$	set noverify
$	if emsg.eqs."" then goto noerr
$	write sys$output "&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"
$	write sys$output "Compilation errors in:"
$	write sys$output emsg
$	write sys$output "&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"
$	noerr:
$   uilgenex:
$ 	deass/group lsl$uilgen_building
$ 	set nover
