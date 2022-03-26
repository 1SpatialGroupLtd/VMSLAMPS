$ 	set noverify
$	ws = "write sys$output"
$	on control_y then goto abort1
$	buildingname = "lsl$rcpedt_building"
$	buildingwarning = "''f$logical(buildingname)'"
$	if "''buildingwarning'" .eqs. "" then goto xx20
$	ws "''buildingwarning'"
$	exit
$!
$xx20:
$	define/group lsl$rcpedt_building "in_progress"
$	sd:=$lsl$sys:sd
$	set noon
$	emsg=""
$	assign lsl$source_root:[alvey.satmap.gcp_input.rcpedt] lsl$cmnrcpedt
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$	newmsg rcpedt.mes/number=1902/prefix=rcpedt__/parameter=fortran/runoff
$	@rcpedt.temp_com
$	purge rcpedtmsg.rno
$	set noverify
$!
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ADD_COMMENT= ADD_COMMENT
$	fort/list ADD_COMMENT
$ 	ok=$status
$ 	if ok then pvv ADD_COMMENT
$ 	purge/nolog ADD_COMMENT.obj
$ 	purge/nolog ADD_COMMENT.for
$ 	if ok then delete/nolog ADD_COMMENT.lis;*
$	if .not.ok then emsg=emsg + " ADD_COMMENT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ADD_RCP= ADD_RCP
$	fort/list ADD_RCP
$ 	ok=$status
$ 	if ok then pvv ADD_RCP
$ 	purge/nolog ADD_RCP.obj
$ 	purge/nolog ADD_RCP.for
$ 	if ok then delete/nolog ADD_RCP.lis;*
$	if .not.ok then emsg=emsg + " ADD_RCP"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc DELETE= DELETE
$	fort/list DELETE
$ 	ok=$status
$ 	if ok then pvv DELETE
$ 	purge/nolog DELETE.obj
$ 	purge/nolog DELETE.for
$ 	if ok then delete/nolog DELETE.lis;*
$	if .not.ok then emsg=emsg + " DELETE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc DELETE_COMMENT= DELETE_COMMENT
$	fort/list DELETE_COMMENT
$ 	ok=$status
$ 	if ok then pvv DELETE_COMMENT
$ 	purge/nolog DELETE_COMMENT.obj
$ 	purge/nolog DELETE_COMMENT.for
$ 	if ok then delete/nolog DELETE_COMMENT.lis;*
$	if .not.ok then emsg=emsg + " DELETE_COMMENT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc DELETE_RCP= DELETE_RCP
$	fort/list DELETE_RCP
$ 	ok=$status
$ 	if ok then pvv DELETE_RCP
$ 	purge/nolog DELETE_RCP.obj
$ 	purge/nolog DELETE_RCP.for
$ 	if ok then delete/nolog DELETE_RCP.lis;*
$	if .not.ok then emsg=emsg + " DELETE_RCP"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc DISPLAY= DISPLAY
$	fort/list DISPLAY
$ 	ok=$status
$ 	if ok then pvv DISPLAY
$ 	purge/nolog DISPLAY.obj
$ 	purge/nolog DISPLAY.for
$ 	if ok then delete/nolog DISPLAY.lis;*
$	if .not.ok then emsg=emsg + " DISPLAY"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc EDIT_RCP= EDIT_RCP
$	fort/list EDIT_RCP
$ 	ok=$status
$ 	if ok then pvv EDIT_RCP
$ 	purge/nolog EDIT_RCP.obj
$ 	purge/nolog EDIT_RCP.for
$ 	if ok then delete/nolog EDIT_RCP.lis;*
$	if .not.ok then emsg=emsg + " EDIT_RCP"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc GET_COMMANDS= GET_COMMANDS
$	fort/list GET_COMMANDS
$ 	ok=$status
$ 	if ok then pvv GET_COMMANDS
$ 	purge/nolog GET_COMMANDS.obj
$ 	purge/nolog GET_COMMANDS.for
$ 	if ok then delete/nolog GET_COMMANDS.lis;*
$	if .not.ok then emsg=emsg + " GET_COMMANDS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc HELP= HELP
$	fort/list HELP
$ 	ok=$status
$ 	if ok then pvv HELP
$ 	purge/nolog HELP.obj
$ 	purge/nolog HELP.for
$ 	if ok then delete/nolog HELP.lis;*
$	if .not.ok then emsg=emsg + " HELP"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc RCPEDT= RCPEDT
$	fort/list RCPEDT
$ 	ok=$status
$ 	if ok then pvv RCPEDT
$ 	purge/nolog RCPEDT.obj
$ 	purge/nolog RCPEDT.for
$ 	if ok then delete/nolog RCPEDT.lis;*
$	if .not.ok then emsg=emsg + " RCPEDT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc READ_AUX_DATA= READ_AUX_DATA
$	fort/list READ_AUX_DATA
$ 	ok=$status
$ 	if ok then pvv READ_AUX_DATA
$ 	purge/nolog READ_AUX_DATA.obj
$ 	purge/nolog READ_AUX_DATA.for
$ 	if ok then delete/nolog READ_AUX_DATA.lis;*
$	if .not.ok then emsg=emsg + " READ_AUX_DATA"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc READ_COMMENT= READ_COMMENT
$	fort/list READ_COMMENT
$ 	ok=$status
$ 	if ok then pvv READ_COMMENT
$ 	purge/nolog READ_COMMENT.obj
$ 	purge/nolog READ_COMMENT.for
$ 	if ok then delete/nolog READ_COMMENT.lis;*
$	if .not.ok then emsg=emsg + " READ_COMMENT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc READ_RCP_FILE= READ_RCP_FILE
$	fort/list READ_RCP_FILE
$ 	ok=$status
$ 	if ok then pvv READ_RCP_FILE
$ 	purge/nolog READ_RCP_FILE.obj
$ 	purge/nolog READ_RCP_FILE.for
$ 	if ok then delete/nolog READ_RCP_FILE.lis;*
$	if .not.ok then emsg=emsg + " READ_RCP_FILE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc READ_XYZ= READ_XYZ
$	fort/list READ_XYZ
$ 	ok=$status
$ 	if ok then pvv READ_XYZ
$ 	purge/nolog READ_XYZ.obj
$ 	purge/nolog READ_XYZ.for
$ 	if ok then delete/nolog READ_XYZ.lis;*
$	if .not.ok then emsg=emsg + " READ_XYZ"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc WRITE_RCP_FILE= WRITE_RCP_FILE
$	fort/list WRITE_RCP_FILE
$ 	ok=$status
$ 	if ok then pvv WRITE_RCP_FILE
$ 	purge/nolog WRITE_RCP_FILE.obj
$ 	purge/nolog WRITE_RCP_FILE.for
$ 	if ok then delete/nolog WRITE_RCP_FILE.lis;*
$	if .not.ok then emsg=emsg + " WRITE_RCP_FILE"
$ 	delete adc.ide;*
$	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$	adc rcpedt.tmp = rcpedt.cld
$	set command/object = rcpedt_cld rcpedt.tmp
$ 	ok=$status
$	if ok then pvv rcpedt_cld
$	delete rcpedt.tmp;*
$	purge rcpedt_cld.obj
$	delete adc.ide;*
$	if .not.ok then emsg=emsg + " rcpedtcld"
$	set noverify
$! 
$	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$	macro/object=rcpedt_mar rcpedt
$ 	ok=$status
$	purge/nolog rcpedt_mar.obj
$	if .not.ok then emsg=emsg + " rcpedt_mar"
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
$ 	link/map/full/map=rcpedt/exe=rcpedt -
	rcpedt/opt,lsl$library:lslshr/opt
$   purge/nolog *.exe,*.map
$xx250:
$abort1:
$ 	deass/group lsl$rcpedt_building
$ 	set noverify
