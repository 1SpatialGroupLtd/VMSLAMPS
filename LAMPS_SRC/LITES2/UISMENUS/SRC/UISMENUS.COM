$!
$! Command file to build utility UISMENUS
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!	Created						AC  19-Oct-1988
$!	Modified for general DCL version                FJB 21-May-1989
$!
$	ver=f$verify(0)
$!
$	on error then goto uismenusex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$uismenus_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto uismenusex
$	define/group lsl$uismenus_building "in_progress"
$	open/write comfil uismenusbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto uismenusex"
$	wc "$	if ""'","'f$logical(""lsl$uismenus_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$uismenus_building ""in_progress"""
$	wc "$	assign lsl$source_root:[lites2.uis.uismenus] lsl$cmnuismenus"
$	wc "$	assign lsl$source_root:[gpx.lib] gpx_lib"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	uismenus_dbg=""
$	macbuild=""
$	cld=""
$	mes=""
$	inquire/nop compile "Compile FORTRAN ? "
$	inq/nop cld "Compile CLD module ? "
$	if .not.compile then goto a11
$	inquire/nop uismenus_dbg "With Debug ? "
$	if .not. uismenus_dbg then goto a04
$	   fsw1="/debug"
$	   mldbg="/debug"
$	   inquire/nop answer "Without optimisation ? "
$	   if answer then fsw1=fsw1 + "/noopt"
$	   inquire/nop answer "Check bounds and overflow ? "
$	   if answer then fsw1=fsw1 + "/check=(bounds,overflow)"
$	   inquire/nop answer "With listings ? "
$	   if answer then fsw1=fsw1 + "/list"
$	   inquire/nop answer "Keep FORtran sources with comments ? "
$	   if answer then kpcom="/co"
$ a04:
$!
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all sources ? "
$	   if .not. everything then goto a05
$	   cld_init="t"
$	   do_monitor="t"
$	   main_loop="t"
$	   mbx_setup="t"
$	   uismenus="t"
$	   respond="t"
$	   setup_comm="t"
$	   set_toggles="t"
$	   set_groups="t"
$!
$	   goto a11
$!
$ a05:	   
$	ws " "
$ 	   inq/nop cld_init	"Compile CLD_INIT ? "
$ 	   inq/nop do_monitor	"Compile DO_MONITOR ? "
$ 	   inq/nop main_loop	"Compile MAIN_LOOP ? "
$ 	   inq/nop mbx_setup	"Compile MBX_SETUP ? "
$ 	   inq/nop uismenus	"Compile UISMENUS ? "
$ 	   inq/nop respond	"Compile RESPOND ? "
$ 	   inq/nop setup_comm 	"Compile SETUP_COMM ? "
$ 	   inq/nop set_toggles 	"Compile SET_TOGGLES ? "
$ 	   inq/nop set_groups 	"Compile SET_GROUPS ? "
$ a11:
$	   if .not. cld then goto messages
$		wc "$ 		adc uismenus.tmp=uismenus_cld.cld"
$		wc "$ 		set command/object=uismenus_cld uismenus.TMP"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv uismenus_cld"
$	      	wc "$ 		ok=$status"	
$		wc "$! "
$ messages:
$	   inq/nop mes "Generate message definitions ? "
$		wc "$ 	set noverify"
$!
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 	set verify"
$ 		if .not.mes then goto cmponly
$		wc "$	newmsg/number=1277/name=uismenus/prefix=uismen__/parameter=for/runoff uismenus.mes"
$		wc "$ @uismenus.temp_com"
$!	
$ cmponly: if .not. compile then goto lnkonly
$	if cld_init then call compiler cld_init
$      	if do_monitor then call compiler do_monitor
$	if main_loop then call compiler main_loop
$	if mbx_setup then call compiler mbx_setup
$	if uismenus then call compiler uismenus
$	if respond then call compiler respond
$	if setup_comm then call compiler setup_comm
$	if set_toggles then call compiler set_toggles
$	if set_groups then call compiler set_groups
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ compiler: subroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$		wc "$ 	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc ''p1'''kpcom'=''p1'"
$	   	wc "$	fort''fsw1' ''p1'"
$	      	wc "$ 	ok=$status"	
$		wc "$ 	if ok then pvv ''p1'"
$		wc "$ 	purge/nolog ''p1'.obj"
$		if fsw1.eqs."" then -
		wc "$ 	delete/nolog ''p1'.for;*"
$		if fsw1.nes.""  then -
		wc "$ 	purge/nolog ''p1'.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
		wc "$ 	if ok then delete/nolog ''p1'.lis;*"
$		wc "$	if .not.ok then emsg=emsg+"" ''p1'"""
$		wc "$ 	delete adc.ide;*"
$		wc "$	set noverify"
$	return
$ endsubroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ lnkonly:
$	wc "$	set noverify"
$	wc "$	if emsg.eqs."""" then goto noerr"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	write sys$output ""Compilation errors in:"""
$	wc "$	write sys$output emsg"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	noerr:"
$	wc "$   uismenusex:"
$	wc "$ 	deass/group lsl$uismenus_building"
$	wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto uismenusex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$uismenus_building
$	bat uismenusbat.com
$	goto uismenusx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto uismenusex
$	deass/group lsl$uismenus_building
$	@uismenusbat.com
$	goto uismenusx2
$ uismenusex:
$	deass/group lsl$uismenus_building
$ uismenusx2:
$	if ver then set verify
