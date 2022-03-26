$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$!	Command file for creating and submiting a batch command file
$!	for building I3D
$!
$! 	mod no longer attempts to PVV object from MACRO32!	TJH 31-May-1990
$! 	mod don't create MACRO list files if run in batch	CCB 26-Mar-1992
$! 	mod don't write flashing text to VT screen		CCB 26-Mar-1992
$!
$! 	mod1267 use DTMPREPARE service for any dtmcreate service routines
$!								 JB 13-Aug-1993
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	ver = f$verify(0)
$	ws = "write sys$output"
$	wc = "write comfil"
$	on error then goto abort2
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! do not build if someone else is already building
$!
$	disk = f$logical("sys$disk")
$	my_name = f$getjpi("","USERNAME")
$	buildingname = "lsl$i3d_building"
$	buildingwarning = "''f$logical(buildingname)'"
$	on control_y then goto abort2
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! open file to receive building commands
$!
$	comfile = "i3dbat.com"
$	if f$search(comfile).nes."" then delete/nolog 'comfile';*
$	open/write comfil i3dbat.com
$	on control_y then goto abort1
$ 	on error then goto xx260
$!
$! check for build already in progress from within the build command file
$	wc "$ 	set noverify"
$	wc "$	ws = ""write sys$output"""
$	wc "$	on control_y then goto abort1"
$	wc "$	buildingname = ""lsl$i3d_building"""
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
$	wc "$	assign here lsl$cmni3d"
$	wc "$	assign lsl$source_root:[dtmprepare.service] lsl$dtmpreparesys"
$	wc "$	assign lsl$source_root:[dtmprepare.service] lsl$dtmcreatesys"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$	set verify"
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! initialise
$	lnkopts=""
$	comopts=""
$!	comopts="/list"
$	adcopts=""
$	TRUE = "1"
$	FALSE = "0"
$!
$! new message parameters?
$	inq/nop yes "Generate message parameters ? "
$	if .not. yes then goto nomess
$	wc "$	set noverify"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$	set verify"
$	wc "$	newmsg/number=1633/prefix=i3d__/parameter=fort/runoff i3d.mes"
$	wc "$	@i3d.temp_com"
$nomess:
$!
$! compile any sources?
$	everything = FALSE
$	inq/nop anything "Compile any sources ? "
$	if .not.anything then goto xx140
$!
$! compile with debug?
$	inq/nop yes "Compile with debug ? "
$	if yes then comopts=comopts + "/debug/noopt/check=(b,o)"
$	if yes then adcopts="/co"
$!
$! compile all sources?
$	inq/nop everything "Compile all sources ? "
$!
$! compile .mar?
$xx140:
$	inq/nop mar "Compile mar ? "
$!
$! link?
$	inq/nop lnkit "Link ? "
$	if .not. lnkit then goto compile
$!
$! link with debug?
$	lnkopts="/map/full"
$	inq/nop yes "Link with debug ? "
$	if yes then lnkopts=lnkopts + "/debug"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$compile:
$	if .not anything then goto nocomp
$!
$	if everything then goto compile_a
$	inq yes	"Compile group ""a"""
$	if .not. yes then goto no_a
$compile_a:
$	on control_c then goto no_a
$	call compiler allocate_memory	'everything'
$no_a:
$	if everything then goto compile_b
$	inq yes	"Compile group ""b"""
$	if .not. yes then goto no_b
$compile_b:
$	on control_c then goto no_b
$	call compiler between		'everything'
$no_b:
$	if everything then goto compile_c
$	inq yes	"Compile group ""c"""
$	if .not. yes then goto no_c
$compile_c:
$	on control_c then goto no_c
$	call compiler cbinout		'everything'
$	call compiler checkplot_cmd	'everything'
$	call compiler check_fc		'everything'
$	call compiler check_flow	'everything'
$	call compiler check_fsn		'everything'
$	call compiler check_group	'everything'
$	call compiler check_layer	'everything'
$	call compiler check_terminal_heights	'everything'
$	call compiler check_terminal_directions	'everything'
$	call compiler clip_links	'everything'
$	call compiler close_cmd		'everything'
$	call compiler compare		'everything'
$	call compiler copy_ftrs		'everything'
$	call compiler cross		'everything'
$no_c:
$	if everything then goto compile_d
$	inq yes	"Compile group ""d"""
$	if .not. yes then goto no_d
$compile_d:
$	on control_c then goto no_d	'everything'
$	call compiler deselect_cmd	'everything'
$	call compiler disable_cmd	'everything'
$	call compiler displbtmp		'everything'
$no_d:
$	if everything then goto compile_e
$	inq yes	"Compile group ""e"""
$	if .not. yes then goto no_e
$compile_e:
$	on control_c then goto no_e	'everything'
$	call compiler enable_cmd	'everything'
$no_e:
$	if everything then goto compile_f
$	inq yes	"Compile group ""f"""
$	if .not. yes then goto no_f
$compile_f:
$	on control_c then goto no_f
$	call compiler filein_cmd	'everything'
$	call compiler fileout_cmd	'everything'
$	call compiler find_heighted_ridge_point	'everything'
$	call compiler find_heighted_river_point	'everything'
$	call compiler find_legal_flow	'everything'
$	call compiler find_network_components	'everything'
$	call compiler flow		'everything'
$no_f:
$	if everything then goto compile_g
$	inq yes	"Compile group ""g"""
$	if .not. yes then goto no_g
$compile_g:
$	on control_c then goto no_g
$	call compiler get_cmds		'everything'
$	call compiler go_cmd		'everything'
$	call compiler guess_complete_flow	'everything'
$no_g:
$	if everything then goto compile_h
$	inq yes	"Compile group ""h"""
$	if .not. yes then goto no_h
$compile_h:
$	on control_c then goto no_h
$	call compiler height_river_nodes	'everything'
$	call compiler height_ridge_nodes	'everything'
$	call compiler height_points	'everything'
$	call compiler help_cmd	'everything'
$no_h:
$	if everything then goto compile_i
$	inq yes	"Compile group ""i"""
$	if .not. yes then goto no_i
$compile_i:
$	on control_c then goto no_i
$	call compiler i3d	'everything'
$	call compiler i3d_setup	'everything'
$	call compiler initsel	'everything'
$	call compiler insert_pt	'everything'
$	call compiler interpolate	'everything'
$	call compiler interpolate_node_heights	'everything'
$	call compiler intersect	'everything'
$	call compiler intsect	'everything'
$	call compiler intsect_spot	'everything'
$	call compiler inword	'everything'
$no_i:
$	if everything then goto compile_j
$	inq yes	"Compile group ""j"""
$	if .not. yes then goto no_j
$compile_j:
$	on control_c then goto no_j
$no_j:
$	if everything then goto compile_l
$	inq yes	"Compile group ""l"""
$	if .not. yes then goto no_l
$compile_l:
$	on control_c then goto no_l
$	call compiler linknode_structure 'everything'
$	call compiler lites_cmd		 'everything'
$	call compiler load_links	 'everything'
$	call compiler lites_mess	 'everything'
$	call compiler load_terrain	 'everything'
$	call compiler lookup_cmd	 'everything'
$no_l:
$	if everything then goto compile_m
$	inq yes	"Compile group ""m"""
$	if .not. yes then goto no_m
$compile_m:
$	on control_c then goto no_m
$	call compiler mode		'everything'
$no_m:
$	if everything then goto compile_n
$	inq yes	"Compile group ""n"""
$	if .not. yes then goto no_n
$compile_n:
$	on control_c then goto no_n
$no_n:
$	if everything then goto compile_o
$	inq yes	"Compile group ""o"""
$	if .not. yes then goto no_o
$compile_o:
$	on control_c then goto no_o
$	call compiler otplstrg		'everything'
$	call compiler output_checkplot	'everything'
$	call compiler output_crt	'everything'
$	call compiler output_links	'everything'
$no_o:
$	if everything then goto compile_p
$	inq yes	"Compile group ""p"""
$	if .not. yes then goto no_p
$compile_p:
$	on control_c then goto no_p
$	call compiler pause_cmd		'everything'
$	call compiler percent		'everything'
$no_p:
$	if everything then goto compile_r
$	inq yes	"Compile group ""r"""
$	if .not. yes then goto no_r
$compile_r:
$	on control_c then goto no_r
$	call compiler readfsn		'everything'
$	call compiler readlay		'everything'
$	call compiler readrang		'everything'
$	call compiler readsel		'everything'
$	call compiler rotate_symbol	'everything'
$no_r:
$	if everything then goto compile_s
$	inq yes	"Compile group ""s"""
$	if .not. yes then goto no_s
$compile_s:
$	on control_c then goto no_s
$	call compiler select_cmd	'everything'
$	call compiler set_cmd		'everything'
$	call compiler set_initial_flow	'everything'
$	call compiler show_cmd		'everything'
$	call compiler show_dirflowerr	'everything'
$	call compiler shsele		'everything'
$	call compiler swap		'everything'
$no_s:
$	if everything then goto compile_t
$	inq yes	"Compile group ""t"""
$	if .not. yes then goto no_t
$compile_t:
$	on control_c then goto no_t
$	call compiler terrain_cmd	'everything'
$no_t:
$	if everything then goto compile_u
$	inq yes	"Compile group ""u"""
$	if .not. yes then goto no_u
$compile_u:
$	on control_c then goto no_u
$no_u:
$	if everything then goto compile_v
$	inq yes	"Compile group ""v"""
$	if .not. yes then goto no_v
$compile_v:
$	on control_c then goto no_v
$	call compiler version		'everything'
$no_v:
$	if everything then goto compile_w
$	inq yes	"Compile group ""w"""
$	if .not. yes then goto no_w
$compile_w:
$	on control_c then goto no_w
$no_w:
$	if everything then goto compile_x
$	inq yes	"Compile group ""x"""
$	if .not. yes then goto no_x
$compile_x:
$	on control_c then goto no_x
$no_x:
$	if everything then goto compile_y
$	inq yes	"Compile group ""y"""
$	if .not. yes then goto no_y
$compile_y:
$	on control_c then goto no_y
$no_y:
$	if everything then goto compile_z
$	inq yes	"Compile group ""z"""
$	if .not. yes then goto no_z
$compile_z:
$	on control_c then goto no_z
$no_z:
$	on control_c then goto abort1
$nocomp:
$	if .not. mar then goto nomar
$	wc "$	set noverify"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$ set verify"
$	wc "$	macro/nolist i3d_cmdtab + lsl$library:lslmaclib/lib"
$	wc "$ 	ok=$status"	
$	wc "$	purge/nolog i3d_cmdtab.obj"
$	wc "$	if .not.ok then emsg=emsg + "" i3d_cmdtab"""
$	wc "$! "
$	wc "$	macro/nolist group_cmdtab + lsl$library:lslmaclib/lib"
$	wc "$ 	ok=$status"	
$	wc "$	purge/nolog group_cmdtab.obj"
$	wc "$	if .not.ok then emsg=emsg + "" group_cmdtab"""
$	wc "$	set noverify"
$	wc "$! "
$nomar:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! list subroutines in which compilation errors occured
$!
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
$ 	if .not. lnkit then goto xx250
$!
$! generate a new version of "version"
$!
$	wc "$ set noverify"
$	wc "$ ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$ set verify"
$	wc "$ run lsl$exe:genver"
$	wc "$ 		adc version=version"
$   	wc "$ 		fort version"
$      	wc "$ 		ok=$status"	
$	wc "$ 		if ok then pvv version"
$	wc "$ 		purge/nolog version.obj"
$	wc "$ 		delete/nolog version.for;*"
	wc "$ 		delete adc.ide;*"
$	wc "$ set noverify"
$!
$! link
$	wc "$ ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$ set verify"
$	wc "$ 	link''lnkopts'/map=i3d/exe=i3d -"
$	wc "	i3d/opt,lsl$library:lslshr/opt,iffshr/opt"
$!	wc "$   purge/nolog *.exe,*.map"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! terminate comfile
$!
$xx250:	wc "$xx250:"
$	wc "$abort1:"
$	wc "$ 	deass/group ''buildingname'"
$	wc "$ 	set noverify"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! close comfil and submit job
$xx260:
$	on control_c then goto abort2
$	close comfil
$	ok=$status
$!
$! Do not submit job if i3d is already building
$	if "''buildingwarning'" .eqs. "" then goto xx10
$	ws "Can't submit job now because i3d is already building"
$	goto normal_exit
$!
$xx10:	if ok then inq/nop yes "Submit for batch ? "
$	if .not. yes then goto xx270
$	bat i3dbat.com
$	goto normal_exit
$!
$xx270:	if ok then inq/nop yes "Submit for FAST batch ? "
$	if .not. yes then goto xx280
$	fbat i3dbat.com
$	goto normal_exit
$!
$xx280:	if ok then inq/nop yes "Interactive ? "
$	if .not. yes then goto abort2
$	@i3dbat.com
$	ws "I3DBAT job completed"
$	goto normal_exit
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! terminate build session
$!
$abort1:close comfil
$abort2:ws "Bye!"
$normal_exit:
$	purge/nolog i3dbat.com
$!	purge/nolog *.lis
$	purge/nolog *.for
$	if ver then set verify
$	exit
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! subroutine to adc/fortran/pvv/purge file P1
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
$!	if comopts.eqs."" then	wc "$ 	delete/nolog ''p1'.for;*"
$	if comopts.nes.""  then	wc "$ 	purge/nolog ''p1'.for"
$!	if comopts.nes.""  then	wc "$ 	if ok then delete/nolog ''p1'.lis;*"
$	wc "$	if .not.ok then emsg=emsg + "" ''p1'"""
$	wc "$ 	delete adc.ide;*"
$ret:	return
$	endsubroutine
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
