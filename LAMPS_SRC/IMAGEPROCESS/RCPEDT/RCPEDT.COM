$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$!	Command file for creating and submiting a batch command file
$!	for building RCPEDT
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
$	buildingname = "lsl$rcpedt_building"
$	buildingwarning = "''f$logical(buildingname)'"
$	on control_y then goto abort2
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! OPEN FILE TO RECEIVE BUILDING COMMANDS
$	comfile = "rcpedtbat.com"
$	if f$search(comfile).nes."" then delete/nolog 'comfile';*
$	open/write comfil rcpedtbat.com
$	on control_y then goto abort1
$ 	on error then goto xx260
$!
$! CHECK FOR BUILD ALREADY IN PROGRESS FROM WITHIN THE BUILD COMMAND FILE
$	wc "$ 	set noverify"
$	wc "$	ws = ""write sys$output"""
$	wc "$	on control_y then goto abort1"
$	wc "$	buildingname = ""lsl$rcpedt_building"""
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
$	wc "$	assign lsl$source_root:[alvey.satmap.gcp_input.rcpedt] lsl$cmnrcpedt"
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
$	wc "$	newmsg rcpedt.mes/number=1902/prefix=rcpedt__/parameter=fortran/runoff"
$	wc "$	@rcpedt.temp_com"
$	wc "$	purge rcpedtmsg.rno"
$	wc "$	set noverify"
$	wc "$!"
$nomes:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$	if .not. anything then goto nocomp
$!
$	call compiler add_comment	'everything'
$	call compiler add_rcp		'everything'
$	call compiler delete		'everything'
$	call compiler delete_comment	'everything'
$	call compiler delete_rcp	'everything'
$	call compiler display		'everything'
$	call compiler edit_rcp		'everything'
$	call compiler get_commands	'everything'
$	call compiler help		'everything'
$	call compiler rcpedt		'everything'
$	call compiler read_aux_data	'everything'
$	call compiler read_comment	'everything'
$	call compiler read_rcp_file	'everything'
$	call compiler read_xyz		'everything'
$	call compiler write_rcp_file	'everything'
$!
$	on control_c then goto abort1
$nocomp:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Compile CLD module
$	if.not.cld then goto nocld
$	wc "$	set noverify"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$ set verify"
$	wc "$	adc rcpedt.tmp = rcpedt.cld"
$	wc "$	set command/object = rcpedt_cld rcpedt.tmp"
$	wc "$ 	ok=$status"	
$	wc "$	if ok then pvv rcpedt_cld"
$	wc "$	delete rcpedt.tmp;*"
$	wc "$	purge rcpedt_cld.obj"
$	wc "$	delete adc.ide;*"
$	wc "$	if .not.ok then emsg=emsg + "" rcpedtcld"""
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
$	wc "$	macro''macopts'/object=rcpedt_mar rcpedt"
$	wc "$ 	ok=$status"	
$	wc "$	purge/nolog rcpedt_mar.obj"
$	wc "$	if .not.ok then emsg=emsg + "" rcpedt_mar"""
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
$	wc "$ 	link''lnkopts'/map=rcpedt/exe=rcpedt -"
$	wc "	rcpedt/opt,lsl$library:lslshr/opt"
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
$! Do not submit job if rcpedt is already building
$	if "''buildingwarning'" .eqs. "" then goto xx10
$	ws "Can't submit job now because rcpedt is already building"
$	goto normal_exit
$!
$xx10:	if ok then inq/nop yes "Submit for batch ? "
$	if .not. yes then goto xx270
$	bat rcpedtbat.com
$	goto normal_exit
$!
$xx270:	if ok then inq/nop yes "Submit for FAST batch ? "
$	if .not. yes then goto xx280
$	fbat rcpedtbat.com
$	goto normal_exit
$!
$xx280:	if ok then inq/nop yes "Interactive ? "
$	if .not. yes then goto abort2
$	@rcpedtbat.com
$	ws "[1m[5mrcpedtBAT job completed[m"
$	goto normal_exit
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! TERMINATE BUILD SESSION
$!
$abort1:close comfil
$abort2:ws "Bye!"
$normal_exit:
$	purge/nolog rcpedtbat.com
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
