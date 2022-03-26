$ 	set noverify
$	ws = "write sys$output"
$	on control_y then goto abort1
$	buildingname = "lsl$dtifilter_building"
$	buildingwarning = "''f$logical(buildingname)'"
$	if "''buildingwarning'" .eqs. "" then goto xx20
$	ws "''buildingwarning'"
$	exit
$!
$xx20:
$	define/group lsl$dtifilter_building "in_progress"
$	sd:=$lsl$sys:sd
$	set noon
$	emsg=""
$	assign lsl$source_root:[imageprocess.dtifilter] lsl$cmndtifilter
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$	newmsg dtifilter.mes/number=1269/prefix=dtifil__/parameter=fortran/runoff
$	@dtifilter.temp_com
$	purge dtifiltermsg.rno
$	set noverify
$!
$	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$	macro/object=dtifilter_mar dfilcmd
$ 	ok=$status
$	purge/nolog dtifilter_mar.obj
$	if .not.ok then emsg=emsg + " dtifilter_mar"
$	set noverify
$! 
$	set noverify
$	if emsg.eqs."" then goto noerr
$	ws "&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"
$	ws "Compilation errors in:"
$	ws emsg
$	ws "&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"
$	goto xx250
$	noerr:
$ ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 	link/map/full/map=dtifilter/exe=dtifilter -
	dtifilter/opt,lsl$library:lslshr/opt
$   purge/nolog *.exe,*.map
$xx250:
$abort1:
$ 	deass/group lsl$dtifilter_building
$ 	set noverify
