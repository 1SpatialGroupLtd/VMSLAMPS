$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$!	Command file for creating and submiting a batch command file
$!	for building TRANSP
$!MOD	Correct definition of Lsl$CMNTRANSP, and
$!	get rid of stupid flashing text on VT		CCB	26-Mar-1992
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	ver = f$verify(0)
$	ws = "write sys$output"
$	wc = "write comfil"
$	on error then goto abort2
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! DO NOT BUILD IF SOMEONE ELSE IS ALREADY BUILDING
$	disk = f$logical("sys$disk")
$	my_name = f$getjpi("","USERNAME")
$	buildingname = "lsl$transp_building"
$	buildingwarning = "''f$logical(buildingname)'"
$	on control_y then goto abort2
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! OPEN FILE TO RECEIVE BUILDING COMMANDS
$	comfile = "transpbat.com"
$	if f$search(comfile).nes."" then delete/nolog 'comfile';*
$	open/write comfil transpbat.com
$	on control_y then goto abort1
$ 	on error then goto xx260
$!
$! CHECK FOR BUILD ALREADY IN PROGRESS FROM WITHIN THE BUILD COMMAND FILE
$	wc "$ 	set noverify"
$	wc "$	ws = ""write sys$output"""
$	wc "$	on control_y then goto abort1"
$	wc "$	buildingname = ""lsl$transp_building"""
$	wc "$	buildingwarning = ""'","'f$logical(buildingname)'""
$	wc "$	if ""'","'buildingwarning'"" .eqs. """" then goto xx20"
$	wc "$	ws ""'","'buildingwarning'"""
$	wc "$	exit"
$	wc "$!"
$	wc "$xx20:"
$	wc "$	define/group ''buildingname' ""in_progress"""
$	wc "$	sd:=$lsl$sys:sd"
$	wc "$	set noon"
$	wc "$	emsg="""""
$	wc "$	assign lsl$source_root:[imageprocess.transp] lsl$cmntransp"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$	set verify"
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! INITIALISE
$	lnkopts=""
$	macopts=""
$	comopts="/list"
$	adcopts=""
$	TRUE = "1"
$	FALSE = "0"
$!
$! COMPILE ANY SOURCES?
$	everything = FALSE
$	inq/nop anything "Compile any sources ? "
$	if .not.anything then goto xx140
$!
$! COMPILE WITH DEBUG?
$	inq/nop yes "Compile with debug ? "
$	if yes then comopts=comopts + "/debug/noopt/check=(b,o)"
$	if yes then adcopts="/co"
$!
$! COMPILE ALL SOURCES?
$	inq/nop everything "Compile all sources ? "
$!
$xx140:
$! COMPILE .MAR?
$	inq/nop mar "CMDLIB commands ? "
$! COMPILE .CLD?
$	inq/nop cld "DCL commands ? "
$! COMPILE .MES?
$	inq/nop mes "message definitions ? "
$!
$! LINK?
$	inq/nop lnkit "Link ? "
$	if .not. lnkit then goto compile
$!
$! LINK WITH DEBUG?
$	lnkopts="/map/full"
$	inq/nop yes "Link with debug ? "
$	if yes then lnkopts=lnkopts + "/debug"
$!
$compile:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Build message files
$	if.not.mes then goto nomes
$	wc "$	set noverify"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$	set verify"
$	wc "$	newmsg transp.mes/number=1902/prefix=transp__/parameter=fortran/runoff"
$	wc "$	@transp.temp_com"
$	wc "$	purge transpmsg.rno"
$	wc "$	set noverify"
$	wc "$!"
$nomes:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	if .not anything then goto nocomp
$!
$	call compiler affine_transf	'everything'
$	call compiler calculate_residuals	'everything'
$	call compiler cholesky		'everything'
$	call compiler get_commands	'everything'
$	call compiler get_rcp_pairs	'everything'
$	call compiler help		'everything'
$	call compiler normalise		'everything'
$	call compiler polynomial_transf	'everything'
$	call compiler projective_transf	'everything'
$	call compiler read_points	'everything'
$	call compiler read_rcp_file	'everything'
$	call compiler read_spot_header	'everything'
$	call compiler select_points	'everything'
$	call compiler show_points	'everything'
$	call compiler sort_by_id	'everything'
$	call compiler transp		'everything'
$	call compiler write_line	'everything'
$	call compiler write_parameters	'everything'
$!
$	on control_c then goto abort1
$nocomp:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Compile CLD module
$	if.not.cld then goto nocld
$	wc "$	set noverify"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$ set verify"
$	wc "$	adc transp.tmp = transp.cld"
$	wc "$	set command/object = transp_cld transp.tmp"
$	wc "$ 	ok=$status"	
$	wc "$	if ok then pvv transp_cld"
$	wc "$	delete transp.tmp;*"
$	wc "$	delete adc.ide;*"
$	wc "$	purge transp_cld.obj"
$	wc "$	if .not.ok then emsg=emsg + "" transpcld"""
$	wc "$	set noverify"
$	wc "$! "
$!
$nocld:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Compile .MAR
$	if .not. mar then goto nomar
$	wc "$	set noverify"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$	set verify"
$	wc "$	macro''macopts'/object=transp_mar transp"
$	wc "$ 	ok=$status"	
$	wc "$	purge/nolog transp_mar.obj"
$	wc "$	if .not.ok then emsg=emsg + "" transp_mar"""
$	wc "$	set noverify"
$	wc "$! "
$nomar:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! LIST SUBROUTINES IN WHICH COMPILATION ERRORS OCCURED
$	wc "$	set noverify"
$	wc "$	if emsg.eqs."""" then goto noerr"
$	wc "$	ws ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	ws ""Compilation errors in:"""
$	wc "$	ws emsg"
$	wc "$	ws ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	goto xx250"
$	wc "$	noerr:"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! LINK
$ 	if .not. lnkit then goto xx250
$!
$	wc "$ ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$ set verify"
$!
$	wc "$ 	link''lnkopts'/map=transp/exe=transp -"
$	wc "	transp/opt,lsl$library:lslshr/opt"
$!
$	wc "$   purge/nolog *.exe,*.map"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! TERMINATE COMFILE
$!
$xx250:	wc "$xx250:"
$	wc "$abort1:"
$	wc "$ 	deass/group ''buildingname'"
$	wc "$ 	set noverify"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! CLOSE COMFIL AND SUBMIT JOB
$xx260:
$	on control_c then goto abort2
$	close comfil
$	ok=$status
$!
$! Do not submit job if transp is already building
$	if "''buildingwarning'" .eqs. "" then goto xx10
$	ws "Can't submit job now because transp is already building"
$	goto normal_exit
$!
$xx10:	if ok then inq/nop yes "Submit for batch ? "
$	if .not. yes then goto xx270
$	bat transpbat.com
$	goto normal_exit
$!
$xx270:	if ok then inq/nop yes "Submit for FAST batch ? "
$	if .not. yes then goto xx280
$	fbat transpbat.com
$	goto normal_exit
$!
$xx280:	if ok then inq/nop yes "Interactive ? "
$	if .not. yes then goto abort2
$	@transpbat.com
$	ws "TRANSPBAT job completed"
$	goto normal_exit
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! TERMINATE BUILD SESSION
$!
$abort1:close comfil
$abort2:ws "Bye!"
$normal_exit:
$	purge/nolog transpbat.com
$	if ver then set verify
$	exit
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! SUBROUTINE TO ADC/FORTRAN/PVV/PURGE FILE p1
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$compiler:
$	subroutine
$	if p2 then goto no_ask
$	inq/nop yes "Compile ''p1' ? "
$	if .not. yes then goto ret
$no_ask:wc "$ 	set noverify"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$	set verify"
$	wc "$ 	adc ''p1'''adcopts'= ''p1'"
$	wc "$	fort''comopts' ''p1'"
$	wc "$ 	ok=$status"	
$	wc "$ 	if ok then pvv ''p1'"
$	wc "$ 	purge/nolog ''p1'.obj"
$	if comopts.eqs."" then	wc "$ 	delete/nolog ''p1'.for;*"
$	if comopts.nes.""  then	wc "$ 	purge/nolog ''p1'.for"
$	if comopts.nes.""  then	wc "$ 	if ok then delete/nolog ''p1'.lis;*"
$	wc "$	if .not.ok then emsg=emsg + "" ''p1'"""
$	wc "$ 	delete adc.ide;*"
$ret:	return
$	endsubroutine
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
