$!	FLOWLINE_EXAMPLE.COM
$!
$!	Copyright Laser-Scan Laboratories Ltd, Cambridge, England.
$!	Author : MWS Reid	7-October-1988
$!
$!	
$!	Example flowline command procedure.
$!	This command procedure is executed whenever a job is launched
$!	on this flowline. It prompts for information relevant to the 
$!	job and constructs the job command file for execution 
$!	before each task. This particular flowline deals with the 
$!	digitising of maps
$!
$! Set up logical names
$!
$	ws := " write sys$output"
$!
$! Set up defaults for FLOWLINE system symbols
$!
$	FLN_CREATION_RESULT == "failure"
$	FLN_RESULT == "error"
$	FLN_PROBLEM == "unknown"
$!
$! Output header
$!
$	ws ""
$	ws "   ***************************************************"
$	ws "   **                                               **"
$	ws "   **          Flowline command procedure           **"
$	ws "   **                                               **"
$	ws "   ***************************************************"
$	ws ""
$	ws ""
$!
$! get the name of the job command file
$!
$ rename:
$	dfad_file = project_prefix + "_" + fln_job_name
$!
$	map = dfad_file + "_job.com"
$	inq/nop filename "Please enter job command file name [''map'] ?  : "
$	if filename .eqs. "" then filename = map
$!
$	filename = f$parse("''filename'","lsl$fln_dfad_job:job.com",,)
$	if "''filename'" .nes. "" then goto check
$	ws "Error parsing job command file name"
$	ws ""
$	goto rename
$!
$! see if this file already exists
$!
$ check:
$	check = f$search(filename)
$	if check .eqs."" then goto scale
$	ws "WARNING : This job file already exists "
$	inq/nop RESP "  - do you want to continue [y/n] :"
$	ws ""
$	if .not.RESP then goto rename
$!
$! map scale
$!
$ scale:
$	fln_map_scale = "1250"
$	inq/nop map_scale "Please input the map scale [''fln_map_scale'] : "
$	if map_scale .nes. "" then fln_map_scale=map_scale
$!
$! and the rest...
$!
$ zone:
$	inq/nop fln_zone "Which UTM zone is the map in : "
$	if fln_zone .eqs. "" then goto zone
$!
$ elefrt:
$	dfadfid_frt = "dfadfid"
$	ws "Which FRT do you want to use ;"
$	inq/nop frt "     - for the electrostatic plotter [''dfadfid_frt'] ? : "
$	if frt .nes. "" then dfadfid_frt = frt
$	name = f$parse("''dfadfid_frt'","lsl$frt:dfadfid.frt",,"NAME","SYNTAX_ONLY")
$	type = f$parse("''dfadfid_frt'","lsl$frt:dfadfid.frt",,"TYPE","SYNTAX_ONLY")
$	dfadfid_frt=name + type
$	if "''dfadfid_frt'" .nes. "" then goto frt
$	ws "Error parsing file name"
$	ws ""
$	goto elefrt
$ frt:
$	dfad_frt = "dfad"
$	inq/nop frt "     - for everything else [''dfad_frt'] ? : "
$	if frt .nes. "" then dfad_frt = frt
$	name =f$parse("''dfad_frt'","lsl$frt:dfad.frt",,"NAME","SYNTAX_ONLY")
$	type =f$parse("''dfad_frt'","lsl$frt:dfad.frt",,"TYPE","SYNTAX_ONLY")
$	dfad_frt=name + type
$	if "''dfad_frt'" .nes. "" then goto sri
$	ws "Error parsing file name"
$	ws ""
$	goto frt
$!
$ sri:
$	dfad_sri = "dfad"
$	inq/nop sri "Which SRI do you want to use [''dfad_sri'] ? : "
$	if sri .nes. "" then dfad_sri = sri
$	name =f$parse("''dfad_sri'","lsl$frt:dfad.sri",,"NAME","SYNTAX_ONLY")
$	type =f$parse("''dfad_sri'","lsl$frt:dfad.sri",,"TYPE","SYNTAX_ONLY")
$	dfad_sri= name + type
$	if "''dfad_sri'" .nes. "" then goto tri
$	ws "Error parsing file name"
$	ws ""
$	goto sri
$!
$ tri:
$	dfad_tri = "dfad"
$	inq/nop tri "Which TRI do you want to use [''dfad_tri'] ? : "
$	if tri .nes. "" then dfad_tri=tri
$	name =f$parse("''dfad_tri'","lsl$frt:dfad.tri",,"NAME","SYNTAX_ONLY")
$	type =f$parse("''dfad_tri'","lsl$frt:dfad.tri",,"TYPE","SYNTAX_ONLY")
$	dfad_tri= name + type
$	if "''dfad_tri'" .nes. "" then goto fcp
$	ws "Error parsing file name"
$	ws ""
$	goto tri
$!
$ fcp:
$	dfad_fcp = "dfad"
$	inq/nop fcp "Which ILINK FCP do you want to use [''dfad_fcp'] ? : "
$	if fcp .nes. "" then dfad_fcp = fcp
$	name =f$parse("''dfad_fcp'","lsl$if:dfad.fcp",-
		,"NAME","SYNTAX_ONLY")
$	type =f$parse("''dfad_fcp'","lsl$if:dfad.fcp",-
		,"TYPE","SYNTAX_ONLY")
$	dfad_fcp= name + type
$	if "''dfad_fcp'" .nes. "" then goto lcp
$	ws "Error parsing file name"
$	ws ""
$	goto fcp
$!
$ lcp:
$	dfad_lcp = "dfad"
$	inq/nop lcp "Which ILINK FCP do you want to use [''dfad_lcp'] ? : "
$	if lcp .nes. "" then dfad_lcp = lcp
$	name =f$parse("''dfad_lcp'","lsl$if:dfad.lcp",-
		,"NAME","SYNTAX_ONLY")
$	type =f$parse("''dfad_lcp'","lsl$if:dfad.lcp",-
		,"TYPE","SYNTAX_ONLY")
$	dfad_lcp= name + type
$	if "''dfad_lcp'" .nes. "" then goto lpatch
$	ws "Error parsing file name"
$	ws ""
$	goto lcp
$!
$ lpatch:
$	dfad_lpatch = "dfad_line"
$	ws "Which patch file do you want to use -"
$	inq/nop lpatch "  For the line trace [''dfad_lpatch'] ? : "
$	if lpatch  .nes. "" then dfad_lpatch = lpatch
$	name = f$parse("''dfad_lpatch'","lsl$lk:dfad_line.patch",-
		,"NAME","SYNTAX_ONLY")
$	type = f$parse("''dfad_lpatch'","lsl$lk:dfad_line.patch",-
		,"TYPE","SYNTAX_ONLY")
$	dfad_lpatch = name + type
$	if "''dfad_lpatch'" .nes. "" then goto apatch
$	ws "Error parsing file name"
$	ws ""
$	goto lpatch
$!
$ apatch:
$	dfad_apatch = "dfad_area"
$	inq/nop apatch "  For the area trace [''dfad_apatch'] ? : "
$	if apatch  .nes. "" then dfad_apatch = apatch
$	name = f$parse("''dfad_apatch'","lsl$lk:dfad_area.patch",-
		,"NAME","SYNTAX_ONLY")
$	type = f$parse("''dfad_apatch'","lsl$lk:dfad_area.patch",-
		,"TYPE","SYNTAX_ONLY")
$	dfad_apatch = name + type
$	if "''dfad_apatch'" .nes. "" then goto lcm
$	ws "Error parsing file name"
$	ws ""
$	goto apatch
$!
$ lcm:
$	dfad_lcm = "dfad"
$	ws "Which LITES2 startup macro do you want to use ;"
$	inq/nop lcm "For editing [''dfad_lcm'] ? : "
$	if lcm .nes. "" then dfad_lcm = lcm
$	name = f$parse("''dfad_lcm'","lsl$lites2cmd:dfad.lcm",-
		,"NAME","SYNTAX_ONLY")
$	type = f$parse("''dfad_lcm'","lsl$lites2cmd:dfad.lcm",-
		,"TYPE","SYNTAX_ONLY")
$	dfad_lcm = name + type
$	if "''dfad_lcm'" .nes. "" then goto blind
$	ws "Error parsing file name"
$	ws ""
$	goto lcm
$!
$ blind:
$	dfad_blind_lcm = "blind_dfad"
$	inq/nop blcm "For blind digitising [''dfad_blind_lcm'] ? : "
$	if blcm .nes. "" then dfad_blind_lcm = blcm
$	name = f$parse("''dfad_blind_lcm'",-
		"lsl$lites2cmd:blind_dfad.lcm",,"NAME","SYNTAX_ONLY")
$	type = f$parse("''dfad_blind_lcm'",-
		"lsl$lites2cmd:blind_dfad.lcm",,"TYPE","SYNTAX_ONLY")
$	dfad_blind_lcm = name + type
$	if "''dfad_blind_lcm'" .nes. "" then goto rule
$	ws "Error parsing file name"
$	ws ""
$	goto blind
$!
$ rule:
$	dfad_rule = "valtab"
$	inq/nop rul -
     "Which RULE table do you want to use [''dfad_rule'] ? : "
$	if rul .nes. "" then dfad_rule=rul
$	name = f$parse("''dfad_rule'","lsl$dfad_rule:valtab.rule",-
		,"NAME","SYNTAX_ONLY")
$	type = f$parse("''dfad_rule'","lsl$dfad_rule:valtab.rule",-
		,"TYPE","SYNTAX_ONLY")
$	dfad_rule = name + type
$	if "''dfad_rule'" .nes. "" then goto dodef
$	ws "Error parsing file name"
$	ws ""
$	goto rule
$!
$ dodef:
$	patch = "lsl$data_root:[flowline.dfad.patch]"
$	cmd = "lsl$data_root:[flowline.dfad.cmd]"
$	work = "lsl$site_root:[flowline.general.work]"
$	fadt = "lsl$data_root:[flowline.dfad.fadt]"
$	iff = "lsl$data_root:[flowline.dfad.iff]"
$!
$ restart:
$	ws ""
$	ws "Please enter the corner points in millimeters "
$	ws ""
$ nw:
$	inq/nop nwx  "       North west x coordinate : "
$	if nwx .eqs."" then goto nw
$	inq/nop nwy  "       North west y coordinate : "
$	if nwy .eqs."" then goto nw
$ sw:
$	ws ""
$	inq/nop swx  "       South west x coordinate : "
$	if swx .eqs."" then goto sw
$	inq/nop swy  "       South west y coordinate : "
$	if swy .eqs."" then goto sw
$ se:
$	ws ""
$	inq/nop sex  "       South east x coordinate : "
$	if sex .eqs."" then goto se
$	inq/nop sey  "       South east y coordinate : "
$	if sey .eqs."" then goto se
$ ne:
$	ws ""
$	inq/nop nex  "       North east x coordinate : "
$	if nex .eqs."" then goto ne
$	inq/nop ney  "       North east y coordinate : "
$	if ney .eqs."" then goto ne
$	ws ""
$	ws "Corner points are : "
$	ws ""
$	ws "  nw	''nwx'	,	''nwy'"
$	ws "  sw	''swx'	,	''swy'"
$	ws "  se	''sex'	,	''sey'"
$	ws "  ne	''nex'	,	''ney'"
$	ws ""
$	inq/nop RESP "Are these correct ? "
$	if .not. RESP then goto restart
$!
$!
$! We need to get the origin of the map in tenths of seconds
$!
$	ask = " Please enter the latitude of the sheet origin (ddd:mm:ss.ss) : "
$	@lsl$fln_dfad_com:dfad_get_tenths
$	ORIG_LA = tenths
$!
$	ask = " Please enter the longitude sheet origin (ddd:mm:ss.ss) : "
$	@lsl$fln_dfad_com:dfad_get_tenths
$	ORIG_LO = tenths
$!
$! And the SW corner
$!
$	ws " Please enter the coordinates of the south west corner of the sheet"
$	ask = " Latitude (ddd:mm:ss.ss) : "
$	@lsl$fln_dfad_com:dfad_get_tenths
$	SW_LA = tenths
$!
$	ask = " Longitude (ddd:mm:ss.ss) : "
$	@lsl$fln_dfad_com:dfad_get_tenths
$	SW_LO = tenths
$!
$! And the extent - so we can work out the other corners
$!
$	ws " Now please enter the extent of the sheet"
$	ask = " Latitude (ddd:mm:ss.ss) : "
$	@lsl$fln_dfad_com:dfad_get_tenths
$	EXT_LA = tenths
$!
$	ask = " Longitude (ddd:mm:ss.ss) : "
$	@lsl$fln_dfad_com:dfad_get_tenths
$	EXT_LO = tenths
$	ws ""
$!
$	inq/nop RESP "Do you want to change any logical names ? "
$	ws ""
$	if .not.RESP then goto date
$!
$	patch_def = "lsl$data_root:[flowline.dfad.patch]"
$	cmd_def = "lsl$data_root:[flowline.dfad.cmd]"
$	work_def = "lsl$site_root:[flowline.general.work]"
$	fadt_def = "lsl$data_root:[flowline.dfad.fadt]"
$	iff_def = "lsl$data_root:[flowline.dfad.iff]"
$!
$	ws "Where do you want the LITES2 command files to go ? "
$	inq/nop cmd "default = ''cmd_def' : " 
$	cmd_node = f$parse("''cmd'","''cmd_def'",,"node","syntax_only")
$	cmd_dev  = f$parse("''cmd'","''cmd_def'",,"device","syntax_only")
$	cmd_dir  = f$parse("''cmd'","''cmd_def'",,"directory","syntax_only")
$	cmd = cmd_node + cmd_dev + cmd_dir
$!
$ lwork:
$	ws ""
$	ws "Where do you want the work directory to be ? "
$	inq/nop work "default = ''work_def' : " 
$	work_node = f$parse("''work'","''work_def'",,"node","syntax_only")
$	work_dev  = f$parse("''work'","''work_def'",,"device","syntax_only")
$	work_dir  = f$parse("''work'","''work_def'",,"directory","syntax_only")
$	work = work_node + work_dev + work_dir
$	if "''work'" .nes. "" then goto lFADT
$	ws "Error parsing directory name"
$	ws ""
$	goto lwork
$!
$ lfadt:
$	ws ""
$	ws "Where do you want the FADT files to go ? "
$	inq/nop fadt "default = ''fadt_def' : " 
$	fadt_node = f$parse("''fadt'","''fadt_def'",,"node","syntax_only")
$	fadt_dev  = f$parse("''fadt'","''fadt_def'",,"device","syntax_only")
$	fadt_dir  = f$parse("''fadt'","''fadt_def'",,"directory","syntax_only")
$	fadt = fadt_node + fadt_dev + fadt_dir
$	if "''fadt'" .nes. "" then goto liff
$	ws "Error parsing directory name"
$	ws ""
$	goto lfadt
$!
$ liff:
$	ws ""
$	ws "Where do you want the iff files to go ? "
$	inq/nop iff "default = ''iff_def' : " 
$	iff_node = f$parse("''iff'","''iff_def'",,"node","syntax_only")
$	iff_dev  = f$parse("''iff'","''iff_def'",,"device","syntax_only")
$	iff_dir  = f$parse("''iff'","''iff_def'",,"directory","syntax_only")
$	iff = iff_node + iff_dev + iff_dir
$	if "''iff'" .nes. "" then goto lopatch
$	ws "Error parsing directory name"
$	ws ""
$	goto liff
$!
$ lopatch:
$	ws ""
$	ws "Where do you want the patch files to go ? "
$	inq/nop patch "default = ''patch_def' : " 
$	patch_node = f$parse("''patch'","''patch_def'",,"node","syntax_only")
$	patch_dev  = f$parse("''patch'","''patch_def'",,"device","syntax_only")
$	patch_dir  = f$parse("''patch'","''patch_def'",,"directory","syntax_only")
$	patch = patch_node + patch_dev + patch_dir
$	if "''patch'" .nes. "" then goto date
$	ws "Error parsing directory name"
$	ws ""
$	goto lopatch
$!
$! some other things that may come in handy
$!
$ date:
$	ws ""
$	date = f$extract(0,17,f$time())
$	name := 'f$getjpi("","username")
$!
$! now write the job command file
$!
$	dfad_cmdfil = filename
$	fln_job_comproc == dfad_cmdfil
$	open/write cmdfil 'dfad_cmdfil'
$	OK = $STATUS
$	if .not.OK then goto failure
$	wc := "write cmdfil"
$	wc "$!                   Job command file"
$	wc "$!                   ~~~~~~~~~~~~~~~~" 
$	wc "$!"
$	wc "$!"
$	wc "$!      created by ''name' on ''date'"
$	wc "$!      for job ''fln_job_name'"
$	wc "$!"
$	wc "$ dfad_file == ""''dfad_file'""
$	wc "$ fln_map_scale == ""''fln_map_scale'""
$	wc "$ fln_zone == ""''fln_zone'""
$	wc "$!"
$	wc "$! ........................................................"
$	wc "$!"
$	wc "$ assign /nolog ''cmd',lsl$site_root:[lites2.cmd] lsl$lites2cmd"
$	wc "$!"
$	wc "$! ........................................................"
$	wc "$!"
$	wc "$!"
$	wc "$ assign /nolog ''work' LSL$FLN_WORK"
$	wc "$!"
$	wc "$! ........................................................"
$	wc "$!"
$	wc "$ assign /nolog ''fadt' lsl$fadt"
$	wc "$! ........................................................"
$	wc "$!"
$	wc "$ assign /nolog ''iff' lsl$if"
$	wc "$! ........................................................"
$	wc "$!"
$	wc "$ assign /nolog ''patch' lsl$lk"
$	wc "$! ........................................................"
$	wc "$ skip:"
$	wc "$!" 
$	wc "$ dfad_frt == ""LSL$FRT:''dfad_frt'""
$	wc "$ dfadfid_frt == ""LSL$FRT:''dfadfid_frt'""
$	wc "$ dfad_lpatch == ""LSL$LK:''dfad_lpatch'""
$	wc "$ dfad_apatch == ""LSL$LK:''dfad_apatch'""
$	wc "$ dfad_sri == ""LSL$FRT:''dfad_sri'""
$	wc "$ dfad_tri == ""LSL$FRT:''dfad_tri'""
$	wc "$ dfad_fcp == ""LSL$IF:''dfad_fcp'""
$	wc "$ dfad_lcp == ""LSL$IF:''dfad_lcp'""
$	wc "$ dfad_lites2cmd == ""LSL$LITES2CMD:''dfad_lcm'""
$	wc "$ dfad_blind_lites2cmd == ""LSL$LITES2CMD:''dfad_blind_lcm'""
$	wc "$ dfad_rule  == ""LSL$DFAD_RULE:''dfad_rule'""
$	wc "$!"
$	wc "$! set up the rest explicitly for now"
$	wc "$!"
$	wc "$ plotter == ""lsl$benson""
$	wc "$!"
$	wc "$ orig_la == ''orig_la'"
$	wc "$ orig_lo == ''orig_lo'"
$	wc "$ sw_la  == ''sw_la'"
$	wc "$ sw_lo  == ''sw_lo'"
$	wc "$ ext_la  == ''ext_la'"
$	wc "$ ext_lo  == ''ext_lo'"
$	wc "$!"
$	wc "$ fln_nw_control_x == ""''nwx'""
$	wc "$ fln_nw_control_y == ""''nwy'""
$	wc "$ fln_sw_control_x == ""''swx'""
$	wc "$ fln_sw_control_y == ""''swy'""
$	wc "$ fln_se_control_x == ""''sex'""
$	wc "$ fln_se_control_y == ""''sey'""
$	wc "$ fln_ne_control_x == ""''nex'""
$	wc "$ fln_ne_control_y == ""''ney'""
$	wc "$ TAPE_DEV=""MSA0:""
$	wc "$!"
$	wc "$! Prefix for all DFAD filenames"
$	wc "$!"
$	wc "$	DFAD_PREFIX == ""DFAD_""
$	wc "$!"
$	wc "$! Prefixes and suffixes for point, line, area and combined IFF files"
$	wc "$!"
$	wc "$	DF_RAW_PLA_SUFFIX == ""_RAW""
$	wc "$!"
$	wc "$	DF_AREA_PREFIX == ""LSL$IF:""
$	wc "$	DF_AREA_SUFFIX == "".AREA""
$	wc "$!"
$	wc "$	DF_LINE_PREFIX == ""LSL$IF:""
$	wc "$	DF_LINE_SUFFIX == "".LINE""
$	wc "$!
$	wc "$	DF_POINT_PREFIX == ""LSL$IF:""
$	wc "$	DF_POINT_SUFFIX == "".POINT""
$	wc "$!"
$	wc "$	DF_PLA_PREFIX ==""LSL$IF:""
$	wc "$	DF_PLA_SUFFIX == "".PLA""
$	wc "$!"
$	wc "$	DF_PLA_EDIT_PREFIX ==""LSL$IF:""
$	wc "$	DF_PLA_EDIT_SUFFIX == ""_PLA.EDIT""
$	wc "$!"
$	wc "$! Prefix, suffix for checked combined IFF file"
$	wc "$!"
$	wc "$	DF_CHECK_PREFIX == ""LSL$IF:""
$	wc "$	DF_CHECK_SUFFIX == "".CHECK""
$	wc "$!"
$	wc "$! Infix for processed IFF files (LAPROCESS,MERGE etc)"
$	wc "$!"
$	wc "$	DFAD_PROC == ""_PROC""
$	wc "$!"
$	wc "$! Suffix for the LITES2 command file produced by ICHECK"
$	wc "$!"
$	wc "$	DF_LCM_PREFIX == ""LSL$LITES2CMD:""
$	wc "$	DF_LCM_SUFFIX == "".LCM""
$	wc "$	DFAD_ICHECK_LCM_SUFFIX == ""_ICHECK.LCM""
$	wc "$!"
$	wc "$! Prefix, suffix for edited combined IFF file"
$	wc "$!"
$	wc "$	DF_EDIT_PREFIX == ""LSL$IF:""
$	wc "$	DF_EDIT_SUFFIX == "".EDIT""
$	wc "$!"
$	wc "$! Finished geometry file"
$	wc "$!"
$	wc "$	DF_GEOMETRY_PREFIX == ""LSL$IF:""
$	wc "$	DF_GEOMETRY_SUFFIX == "".GEO""
$	wc "$!"
$	wc "$! Prefix, suffix for FADT file and associated list file"
$	wc "$!"
$	wc "$	DF_FADT_PREFIX == ""LSL$FADT:""
$	wc "$	DF_FADT_SUFFIX == "".FADT""
$	wc "$!"
$	wc "$	DF_FADT_NEW_SUFFIX == ""_NEW.FADT""
$	wc "$	DF_FADT_EDIT_SUFFIX == ""_EDIT.FADT""
$	wc "$!"
$	wc "$	DF_FADT_LIST_PREFIX == ""LSL$FLN_WORK:""
$	wc "$	DF_FADT_LIST_SUFFIX == ""_FADT.LIS""
$	wc "$!"
$	wc "$! Prefix, suffix for merged FADT/IFF file i.e. DFAD IFF file"
$	wc "$!"
$	wc "$	DF_MERGE_PREFIX == ""LSL$IF:""
$	wc "$	DF_MERGE_SUFFIX == "".MERGE""
$	wc "$!"
$	wc "$	DF_MERGE_LIST_PREFIX == ""LSL$FLN_WORK:""
$	wc "$	DF_MERGE_LIST_SUFFIX == ""_MERGE.LIS""
$	wc "$!"
$	wc "$! Prefix, suffix for DFAD/IFF (+ list and lcm) after first validation"
$	wc "$!"
$	wc "$	DF_VAL_PREFIX == ""LSL$IF:""
$	wc "$	DF_VAL_SUFFIX == "".VAL""
$	wc "$!"
$	wc "$	DF_VAL_LCM_PREFIX == ""LSL$LITES2CMD:""
$	wc "$	DF_VAL_LCM_SUFFIX == ""_VAL.LCM""
$	wc "$!"
$	wc "$	DF_VAL_LIST_PREFIX == ""LSL$FLN_WORK:""
$	wc "$	DF_VAL_LIST_SUFFIX == ""_VAL.LIS""
$	wc "$!"
$	wc "$! Suffix for Lites2 command file from IWINDOW"
$	wc "$!"
$	wc "$	DF_IWINDOW_LCM_SUFFIX == ""_IWINDOW.LCM""
$	wc "$!"
$	wc "$! Prefix, suffix for DFAD/IFF after clipping"
$	wc "$!"
$	wc "$	DF_CLIP_PREFIX == ""LSL$IF:""
$	wc "$	DF_CLIP_SUFFIX == "".CLIP""
$	wc "$!"
$	wc "$! Prefix, suffix for DFAD/IFF after addition of hierarchy & acc regions"
$	wc "$!"
$	wc "$	DF_ACCREG_PREFIX == ""LSL$IF:""
$	wc "$	DF_ACCREG_SUFFIX == "".ACCREG""
$	wc "$!"
$	wc "$! Prefix, suffix for DFAD/IFF after final sort"
$	wc "$!"
$	wc "$	DF_SORT_PREFIX == ""LSL$IF:""
$	wc "$	DF_SORT_SUFFIX == ""_FIN.SORT""
$	wc "$!"
$	wc "$! Prefix, suffix for DFAD/IFF after tidying"
$	wc "$!"
$	wc "$	DF_TIDY_PREFIX == ""LSL$IF:""
$	wc "$	DF_TIDY_SUFFIX == "".TIDY""
$	wc "$!"
$	wc "$! Prefix, suffix for IFF file during and after final element"
$	wc "$!"
$	wc "$	DF_FIN_EDIT_PREFIX == ""LSL$IF:""
$	wc "$	DF_FIN_EDIT_SUFFIX == ""_FINAL.EDIT""
$	wc "$!"
$	wc "$! Prefix, suffix for DFAD/IFF (+ list and lcm) after final validation"
$	wc "$!"
$	wc "$	DF_FINAL_PREFIX == ""LSL$IF:""
$	wc "$	DF_FINAL_SUFFIX == "".FINAL""
$	wc "$!"
$	wc "$	DF_FINAL_LIST_PREFIX == ""LSL$FLN_WORK:""
$	wc "$	DF_FINAL_LIST_SUFFIX == ""_FINAL.LIS""
$	wc "$!"
$	wc "$	DF_WORK_PREFIX == ""LSL$FLN_WORK:""
$	wc "$!"
$	wc "$	DF_FINAL_LCM_PREFIX == ""LSL$LITES2CMD:""
$	wc "$	DF_FINAL_LCM_SUFFIX == ""_FINAL.LCM""
$	wc "$!"
$	wc "$! Prefix, suffix for verification DFAD/IFF read back from tape"
$	wc "$!"
$	wc "$	DF_VER_PREFIX == ""LSL$IF:""  
$	wc "$	DF_VER_SUFFIX == ""_VER""
$	wc "$!"
$	wc "$! Prefix, suffix for validation rule file"
$	wc "$!"
$	wc "$	DF_RULE_PREFIX == ""LSL$DFAD_RULE:""
$	wc "$	DF_RULE_SUFFIX == "".RULE""
$	wc "$!"
$	wc "$! Prefix, suffix for FRT file used in Lites2 editing"
$	wc "$!"
$	wc "$	DF_FRT_PREFIX == ""LSL$FRT:""
$	wc "$	DF_FRT_SUFFIX == "".FRT""
$	wc "$!"
$	wc "$! Backup list pre / suf "
$	wc "$!"
$	wc "$ 	DF_LIST_PREFIX == ""lsl$fln_work:""
$	wc "$	DF_backup_LIST_SUFFIX == ""_back.list""
$	wc "$!"
$	wc "$	DF_JOB_PREFIX == ""lsl$fln_dfad_job:""
$	wc "$	DF_JOB_SUFFIX == ""_job.com""
$	wc "$!"
$	wc "$! Finally set up the pointers to where files should be deleted " 
$	wc "$! from at the end of each job"
$	wc "$!"
$	wc "$	DELETE_PREFIX1 == ""LSL$LITES2CMD:""
$	wc "$	DELETE_PREFIX2 == ""LSL$FADT:""
$	wc "$	DELETE_PREFIX3 == ""LSL$IF:""
$	wc "$	NUM_DEL == 3"
$	wc "$!"
$	close cmdfil
$	OK = $STATUS
$	if .not.OK then goto failure
$	ws "Job command file ''dfad_cmdfil' written"
$	FLN_CREATION_RESULT == "success"
$	FLN_RESULT == "complete"
$	FLN_PROBLEM == ""
$	goto finish
$!
$! deal with errors
$!
$ failure:
$	FLN_CREATION_RESULT == "failure"
$	FLN_RESULT == "error"
$	FLN_PROBLEM == "Job file creation"
$	goto finish
$!
$! and out
$!
$ finish:
$ exit
