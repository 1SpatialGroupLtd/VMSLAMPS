$ 	set noverify
$	ws = "write sys$output"
$	on control_y then goto abort1
$	buildingname = "lsl$transp_building"
$	buildingwarning = "''f$logical(buildingname)'"
$	if "''buildingwarning'" .eqs. "" then goto xx20
$	ws "''buildingwarning'"
$	exit
$!
$xx20:
$	define/group lsl$transp_building "in_progress"
$	sd:=$lsl$sys:sd
$	set noon
$	emsg=""
$	assign lsl$source_root:[imageprocess.transp] lsl$cmntransp
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$	newmsg transp.mes/number=1902/prefix=transp__/parameter=fortran/runoff
$	@transp.temp_com
$	purge transpmsg.rno
$	set noverify
$!
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc AFFINE_TRANSF= AFFINE_TRANSF
$	fort/list AFFINE_TRANSF
$ 	ok=$status
$ 	if ok then pvv AFFINE_TRANSF
$ 	purge/nolog AFFINE_TRANSF.obj
$ 	purge/nolog AFFINE_TRANSF.for
$ 	if ok then delete/nolog AFFINE_TRANSF.lis;*
$	if .not.ok then emsg=emsg + " AFFINE_TRANSF"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc CALCULATE_RESIDUALS= CALCULATE_RESIDUALS
$	fort/list CALCULATE_RESIDUALS
$ 	ok=$status
$ 	if ok then pvv CALCULATE_RESIDUALS
$ 	purge/nolog CALCULATE_RESIDUALS.obj
$ 	purge/nolog CALCULATE_RESIDUALS.for
$ 	if ok then delete/nolog CALCULATE_RESIDUALS.lis;*
$	if .not.ok then emsg=emsg + " CALCULATE_RESIDUALS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc CHOLESKY= CHOLESKY
$	fort/list CHOLESKY
$ 	ok=$status
$ 	if ok then pvv CHOLESKY
$ 	purge/nolog CHOLESKY.obj
$ 	purge/nolog CHOLESKY.for
$ 	if ok then delete/nolog CHOLESKY.lis;*
$	if .not.ok then emsg=emsg + " CHOLESKY"
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
$ 	adc GET_RCP_PAIRS= GET_RCP_PAIRS
$	fort/list GET_RCP_PAIRS
$ 	ok=$status
$ 	if ok then pvv GET_RCP_PAIRS
$ 	purge/nolog GET_RCP_PAIRS.obj
$ 	purge/nolog GET_RCP_PAIRS.for
$ 	if ok then delete/nolog GET_RCP_PAIRS.lis;*
$	if .not.ok then emsg=emsg + " GET_RCP_PAIRS"
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
$ 	adc NORMALISE= NORMALISE
$	fort/list NORMALISE
$ 	ok=$status
$ 	if ok then pvv NORMALISE
$ 	purge/nolog NORMALISE.obj
$ 	purge/nolog NORMALISE.for
$ 	if ok then delete/nolog NORMALISE.lis;*
$	if .not.ok then emsg=emsg + " NORMALISE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc POLYNOMIAL_TRANSF= POLYNOMIAL_TRANSF
$	fort/list POLYNOMIAL_TRANSF
$ 	ok=$status
$ 	if ok then pvv POLYNOMIAL_TRANSF
$ 	purge/nolog POLYNOMIAL_TRANSF.obj
$ 	purge/nolog POLYNOMIAL_TRANSF.for
$ 	if ok then delete/nolog POLYNOMIAL_TRANSF.lis;*
$	if .not.ok then emsg=emsg + " POLYNOMIAL_TRANSF"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc PROJECTIVE_TRANSF= PROJECTIVE_TRANSF
$	fort/list PROJECTIVE_TRANSF
$ 	ok=$status
$ 	if ok then pvv PROJECTIVE_TRANSF
$ 	purge/nolog PROJECTIVE_TRANSF.obj
$ 	purge/nolog PROJECTIVE_TRANSF.for
$ 	if ok then delete/nolog PROJECTIVE_TRANSF.lis;*
$	if .not.ok then emsg=emsg + " PROJECTIVE_TRANSF"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc READ_POINTS= READ_POINTS
$	fort/list READ_POINTS
$ 	ok=$status
$ 	if ok then pvv READ_POINTS
$ 	purge/nolog READ_POINTS.obj
$ 	purge/nolog READ_POINTS.for
$ 	if ok then delete/nolog READ_POINTS.lis;*
$	if .not.ok then emsg=emsg + " READ_POINTS"
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
$ 	adc READ_SPOT_HEADER= READ_SPOT_HEADER
$	fort/list READ_SPOT_HEADER
$ 	ok=$status
$ 	if ok then pvv READ_SPOT_HEADER
$ 	purge/nolog READ_SPOT_HEADER.obj
$ 	purge/nolog READ_SPOT_HEADER.for
$ 	if ok then delete/nolog READ_SPOT_HEADER.lis;*
$	if .not.ok then emsg=emsg + " READ_SPOT_HEADER"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SELECT_POINTS= SELECT_POINTS
$	fort/list SELECT_POINTS
$ 	ok=$status
$ 	if ok then pvv SELECT_POINTS
$ 	purge/nolog SELECT_POINTS.obj
$ 	purge/nolog SELECT_POINTS.for
$ 	if ok then delete/nolog SELECT_POINTS.lis;*
$	if .not.ok then emsg=emsg + " SELECT_POINTS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SHOW_POINTS= SHOW_POINTS
$	fort/list SHOW_POINTS
$ 	ok=$status
$ 	if ok then pvv SHOW_POINTS
$ 	purge/nolog SHOW_POINTS.obj
$ 	purge/nolog SHOW_POINTS.for
$ 	if ok then delete/nolog SHOW_POINTS.lis;*
$	if .not.ok then emsg=emsg + " SHOW_POINTS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SORT_BY_ID= SORT_BY_ID
$	fort/list SORT_BY_ID
$ 	ok=$status
$ 	if ok then pvv SORT_BY_ID
$ 	purge/nolog SORT_BY_ID.obj
$ 	purge/nolog SORT_BY_ID.for
$ 	if ok then delete/nolog SORT_BY_ID.lis;*
$	if .not.ok then emsg=emsg + " SORT_BY_ID"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc TRANSP= TRANSP
$	fort/list TRANSP
$ 	ok=$status
$ 	if ok then pvv TRANSP
$ 	purge/nolog TRANSP.obj
$ 	purge/nolog TRANSP.for
$ 	if ok then delete/nolog TRANSP.lis;*
$	if .not.ok then emsg=emsg + " TRANSP"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc WRITE_LINE= WRITE_LINE
$	fort/list WRITE_LINE
$ 	ok=$status
$ 	if ok then pvv WRITE_LINE
$ 	purge/nolog WRITE_LINE.obj
$ 	purge/nolog WRITE_LINE.for
$ 	if ok then delete/nolog WRITE_LINE.lis;*
$	if .not.ok then emsg=emsg + " WRITE_LINE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc WRITE_PARAMETERS= WRITE_PARAMETERS
$	fort/list WRITE_PARAMETERS
$ 	ok=$status
$ 	if ok then pvv WRITE_PARAMETERS
$ 	purge/nolog WRITE_PARAMETERS.obj
$ 	purge/nolog WRITE_PARAMETERS.for
$ 	if ok then delete/nolog WRITE_PARAMETERS.lis;*
$	if .not.ok then emsg=emsg + " WRITE_PARAMETERS"
$ 	delete adc.ide;*
$	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$	adc transp.tmp = transp.cld
$	set command/object = transp_cld transp.tmp
$ 	ok=$status
$	if ok then pvv transp_cld
$	delete transp.tmp;*
$	delete adc.ide;*
$	purge transp_cld.obj
$	if .not.ok then emsg=emsg + " transpcld"
$	set noverify
$! 
$	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$	macro/object=transp_mar transp
$ 	ok=$status
$	purge/nolog transp_mar.obj
$	if .not.ok then emsg=emsg + " transp_mar"
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
$ 	link/map/full/map=transp/exe=transp -
	transp/opt,lsl$library:lslshr/opt
$   purge/nolog *.exe,*.map
$xx250:
$abort1:
$ 	deass/group lsl$transp_building
$ 	set noverify
