$!MOD	/MAP added to LINK statement				TJH 17-Oct-1989
$!
$	set noverify
$	on control_y then goto endlab
$	on error then goto errorlab
$	if "''f$logical("lsl$uismenus_building")'" -
			.nes. "in_progress" then goto lab10
$	write sys$output	"Someone else is building"
$	exit
$!
$lab10:	
$	define/group	lsl$uismenus_building "in_progress"
$!
$	inquire/nop deb_flag "                Debug ? "
$	if (.not.deb_flag) then QUALS="/nodeb"
$	if (     deb_flag) then QUALS="/deb"
$!
$	set verify
$	link/map 'QUALS' uismenus, -
			cld_init, -
			do_monitor, -
			main_loop, -
			mbx_setup, -
			respond, -
			setup_comm, -
			set_toggles, -
			set_groups, -
			uismenus_cld, -
			uismenus.promsg_obj, -
			gpx_lib:wsuilib/lib, -
			gpx_lib:wsiolib/lib, -
			gpx_lib:mbxlib/lib, -
			gpx_lib:odds/lib, -
			lsl$library:lslshr/opt, -
			sys$input:/opt
sys$library:vaxcrtl/share
$	set noverify
$!
$errorlab:
$!
$endlab:
$	deassign/group lsl$uismenus_building
$	set noverify
