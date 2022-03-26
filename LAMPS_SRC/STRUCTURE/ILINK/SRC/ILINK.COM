$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$!	Command file for creating and submiting a batch command file
$!	for building ILINK
$!
$!	Modified to take parameter S for fortran/standard to warn about
$!	some coding idiocies
$!	Mod 1424 for new FRTSHR
$!	and LSLSHR, IFFSHR
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
$! WORK OUT WHAT DIRECTORY WE ARE USING
$!
$	proc=f$environment("procedure")
$	dir_spec=f$parse(proc,,,"directory")
$	full_spec=f$parse(proc,,,"device")+dir_spec
$	write sys$output "Directory is ",full_spec
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! DO NOT BUILD IF SOMEONE ELSE IS ALREADY BUILDING IN THIS DIRECTORY
$	my_name = f$getjpi("","USERNAME")
$	buildingname = "LSL$ILINK_BUILDING_"+dir_spec-"["-"]"
$	buildingwarning = "''f$logical(buildingname)'"
$	if "''buildingwarning'" .eqs. "" then goto xx10
$		ws "''buildingwarning'"
$		exit
$!
$! SET UP GROUP-WIDE FLAG TO SHOW THAT ILINK IS NOW BUILDING
$xx10:	on control_y then goto abort2
$	define/group 'buildingname' "''my_name' is building ILINK"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! OPEN FILE TO RECEIVE BUILDING COMMANDS
$	comfile = "ilinkbat.com"
$	if f$search(comfile).nes."" then delete/nolog 'comfile';*
$	open/write comfil ilinkbat.com
$	on control_y then goto abort1
$ 	on error then goto xx260
$!
$! CHECK FOR BUILD ALREADY IN PROGRESS FROM WITHIN THE BUILD COMMAND FILE
$	wc "$ 	set noverify"
$	wc "$	ws = ""write sys$output"""
$	wc "$	on control_y then goto abort1"
$	wc "$	buildingname = """,buildingname,""""
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
$	wc "$	assign ",full_spec," lsl$cmnilink"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$	set verify"
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! INITIALISE
$	lnkopts=""
$	comopts="/list"
$	if p1 .eqs. "s" then comopts = comopts + "/standard"
$	if p1 .eqs. "S" then comopts = comopts + "/standard"
$	adcopts=""
$	TRUE = "1"
$	FALSE = "0"
$!
$! NEW MESSAGE PARAMETERS?
$	inq/nop yes "Generate message parameters ? "
$	if .not. yes then goto nomess
$	wc "$	set noverify"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$	set verify"
$	wc "$	newmsg/number=1251/prefix=ilink__/par=fortran/run ilink.mes"
$	wc "$	@ilink.temp_com"
$	wc "$	purge/nolog ilinkmsg.rno"
$nomess:
$!
$! COMPILE .CLD?
$	inq/nop yes "Compile cld ? "
$	if .not. yes then goto nocld
$	wc "$	set noverify"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$ 		adc ilink.tmp=ilink.cld"
$	wc "$ 		set command/object=ilink_cld ilink.tmp"
$	wc "$ 		ok=$status"
$	wc "$ 		if ok then pvv ilink_cld"
$	wc "$ 		ok=$status"
$	wc "$		if ok then purge/nolog ilink_cld.obj
$	wc "$		if ok then delete ilink.tmp;"
$	wc "$	set verify"
$nocld:
$! COMPILE ANY SOURCES?
$	everything = FALSE
$	inq/nop anything "Compile any sources ? "
$	if .not.anything then goto xx140
$!
$! COMPILE WITH DEBUG?
$	inq/nop dbg "Compile with debug ? "
$	if dbg then comopts=comopts + "/debug/noopt/check=(b,o)"
$	if dbg then adcopts="/co"
$!
$! COMPILE ALL SOURCES?
$	inq/nop everything "Compile all sources ? "
$!
$xx140:
$! LINK?
$	inq/nop lnkit "Link ? "
$	if .not. lnkit then goto xx150
$!
$! LINK WITH DEBUG?
$	lnkopts="/map=ilink/cross"
$	inq/nop yes "Link with debug ? "
$	if yes then lnkopts=lnkopts + "/debug"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$xx150:
$	if .not. anything then goto nocomp
$!
$	if everything then goto compile_a
$	inq yes	"Compile group ""a"""
$	if .not. yes then goto no_a
$!
$compile_a:
$	call compiler a2l		'everything'
$	call compiler add_ftr		'everything'
$	call compiler allocate_memory	'everything'
$	call compiler angle		'everything'
$	call compiler append_ftr	'everything'
$	call compiler assign_val	'everything'
$no_a:
$	if everything then goto compile_b
$	inq yes	"Compile group ""b"""
$	if .not. yes then goto no_b
$compile_b:
$	call compiler between		'everything'
$	call compiler boxint		'everything'
$	call compiler break		'everything'
$	call compiler break_ftrs	'everything'
$no_b:
$	if everything then goto compile_c
$	inq yes	"Compile group ""c"""
$	if .not. yes then goto no_c
$compile_c:
$	call compiler check_alignment	'everything'
$	call compiler check_map		'everything'
$	call compiler chknds		'everything'
$	call compiler chkpts1		'everything'
$	call compiler chkpts2		'everything'
$	call compiler chkvex1		'everything'
$	call compiler chkvex2		'everything'
$	call compiler chkvex3		'everything'
$	call compiler count_join	'everything'
$	call compiler create_ftr	'everything'
$	call compiler create_pt		'everything'
$	call compiler create_shr	'everything'
$no_c:
$	if everything then goto compile_d
$	inq yes	"Compile group ""d"""
$	if .not. yes then goto no_d
$compile_d:
$	call compiler del1		'everything'
$	call compiler del3		'everything'
$	call compiler delpt		'everything'
$	call compiler del_duppts_frm_ary	'everything'
$	call compiler discon1		'everything'
$	call compiler discon2		'everything'
$no_d:
$	if everything then goto compile_f
$	inq yes	"Compile group ""f"""
$	if .not. yes then goto no_f
$compile_f:
$	call compiler fill_out_jps	'everything'
$	call compiler fix_ends		'everything'
$no_f:
$	if everything then goto compile_g
$	inq yes	"Compile group ""g"""
$	if .not. yes then goto no_g
$compile_g:
$	call compiler getarm		'everything'
$	call compiler get_acp		'everything'
$	call compiler get_cb		'everything'
$	call compiler get_cmds		'everything'
$	call compiler get_data		'everything'
$	call compiler get_fcc		'everything'
$	call compiler get_fcc_args	'everything'
$	call compiler get_fcp		'everything'
$	call compiler get_frt		'everything'
$	call compiler get_ftr		'everything'
$	call compiler get_lookup_files	'everything'
$	call compiler get_lcp		'everything'
$	call compiler get_pac		'everything'
$	call compiler get_tol		'everything'
$	call compiler ground		'everything'
$no_g:
$	if everything then goto compile_i
$	inq yes	"Compile group ""i"""
$	if .not. yes then goto no_i
$compile_i:
$	call compiler ilink		'everything'
$	call compiler insert_pt		'everything'
$	call compiler inset		'everything'
$	call compiler int_reorder	'everything'
$	call compiler int_ripplesort	'everything'
$	call compiler isearch		'everything'
$no_i:
$	if everything then goto compile_j
$	inq yes	"Compile group ""j"""
$	if .not. yes then goto no_j
$compile_j:
$	call compiler join_histogram	'everything'
$no_j:
$	if everything then goto compile_l
$	inq yes	"Compile group ""l"""
$	if .not. yes then goto no_l
$compile_l:
$	call compiler l2a		'everything'
$	call compiler length		'everything'
$	call compiler linint		'everything'
$	call compiler lin_pac		'everything'
$	call compiler linknode		'everything'
$	call compiler list_output	'everything'
$	call compiler lites2_opn	'everything'
$	call compiler lljoin		'everything'
$	call compiler lpjoin		'everything'
$	call compiler lpjsub		'everything'
$	call compiler lteqgt		'everything'
$no_l:
$	if everything then goto compile_m
$	inq yes	"Compile group ""m"""
$	if .not. yes then goto no_m
$compile_m:
$	call compiler mark_align	'everything'
$	call compiler mark_nodes	'everything'
$	call compiler mov2		'everything'
$	call compiler move_ends_to_lines	'everything'
$no_m:
$	if everything then goto compile_n
$	inq yes	"Compile group ""n"""
$	if .not. yes then goto no_n
$compile_n:
$	call compiler nocycles		'everything'
$no_n:
$	if everything then goto compile_p
$	inq yes	"Compile group ""p"""
$	if .not. yes then goto no_p
$compile_p:
$	call compiler picpac		'everything'
$	call compiler pick_cb		'everything'
$	call compiler ppjoin		'everything'
$	call compiler prjvex		'everything'
$	call compiler put_cb		'everything'
$	call compiler put_ftrs		'everything'
$no_p:
$	if everything then goto compile_r
$	inq yes	"Compile group ""r"""
$	if .not. yes then goto no_r
$compile_r:
$	call compiler rdrang		'everything'
$	call compiler remove_2nodes	'everything'
$no_r:
$	if everything then goto compile_s
$	inq yes	"Compile group ""s"""
$	if .not. yes then goto no_s
$compile_s:
$	call compiler scan_iff		'everything'
$	call compiler set_broken	'everything'
$	call compiler set_cb		'everything'
$	call compiler set_prv		'everything'
$	call compiler set_pt_dst	'everything'
$	call compiler set_pt_pr_ftr	'everything'
$	call compiler show_cmds		'everything'
$	call compiler show_pairs	'everything'
$	call compiler sortarms		'everything'
$	call compiler sort_and_merge	'everything'
$	call compiler sort_arms		'everything'
$	call compiler start_lites2	'everything'
$no_s:
$	if everything then goto compile_t
$	inq yes	"Compile group ""t"""
$	if .not. yes then goto no_t
$compile_t:
$	call compiler thin		'everything'
$	call compiler transfer_ftr	'everything'
$no_t:
$	if everything then goto compile_u
$	inq yes	"Compile group ""u"""
$	if .not. yes then goto no_u
$compile_u:
$	call compiler undo_end_joins	'everything'
$	call compiler undo_small_loops	'everything'
$no_u:
$! Always generate new VERSION when compiling without debug
$	if .not. dbg then goto genver		!
$	if everything then goto genver		!
$	inq/nop yes "Compile VERSION ? "	!
$	if .not. yes then goto no_ver		!
$genver:wc "$	run lsl$exe:genver"		! update VERSION routine
$	wc "$	purge/nolog version.src"	!
$	call compiler version		'TRUE'	!
$no_ver:
$!
$	if everything then goto compile_v
$	inq yes	"Compile group ""v"""
$	if .not. yes then goto no_v
$compile_v:
$	call compiler vecint		'everything'
$no_v:
$	if everything then goto compile_w
$	inq yes	"Compile group ""w"""
$	if .not. yes then goto no_w
$compile_w:
$	call compiler write_ftr		'everything'
$	call compiler write_ftr_ifj	'everything'
$	call compiler write_jb		'everything'
$	call compiler write_part_ftr	'everything'
$	call compiler write_whole_ftr	'everything'
$	call compiler wrtstr		'everything'
$no_w:
$nocomp:
$!
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
$	wc "$	link''lnkopts'/exe=ilink ilink/opt,lsl$library:frtshr/opt,lslshr/opt,iffshr/opt"
$!	wc "$	if f$search(""ilink.exe;-1"").nes."""" then purge/nolog ilink.exe"
$!	wc "$	if f$search(""ilink.map;-1"").nes."""" then purge/nolog ilink.map"
$	wc "$	mapid ilink"
$!	wc "$	if f$search(""ilink.mapid;-1"").nes."""" then purge/nolog ilink.mapid"
$!
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
$	on error then goto abort2
$	close comfil
$	ok=$status
$!
$	if ok then inq/nop yes "Submit for batch ? "
$	if .not. yes then goto xx270
$	deass/group 'buildingname'
$	bat ilinkbat.com
$	goto normal_exit
$xx270:
$	if ok then inq/nop yes "Submit for FAST batch ? "
$	if .not. yes then goto xx280
$	deass/group 'buildingname'
$	fbat ilinkbat.com
$	goto normal_exit
$xx280:	
$	if ok then inq/nop yes "Interactive ? "
$	if .not.yes then goto abort2
$	deass/group 'buildingname'
$	@ilinkbat.com
$	ws "ILINKBAT job completed"
$	goto normal_exit
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! TERMINATE BUILD SESSION
$!
$abort1:close comfil
$abort2:deass/group 'buildingname'
$normal_exit:
$	if f$search("ilinkbat.com;-1").nes."" then purge/nolog ilinkbat.com
$!
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
$	if (f$locate("nolist",comopts).ge.f$length(comopts)) -
		then		wc "$ 	if ok then delete/nolog ''p1'.lis;*"
$	wc "$	if .not.ok then emsg=emsg + "" ''p1'"""
$	wc "$ 	delete adc.ide;*"
$ret:	return
$	endsubroutine
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
