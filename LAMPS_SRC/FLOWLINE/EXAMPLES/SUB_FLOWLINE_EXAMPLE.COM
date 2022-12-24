$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-10-07 12:52:36.000000000 +0100
$! *
$! * This program is free software: you can redistribute it and/or modify
$! * it under the terms of the GNU General Public License as published by
$! * the Free Software Foundation, version 3.
$! *
$! * This program is distributed in the hope that it will be useful, but
$! * WITHOUT ANY WARRANTY; without even the implied warranty of
$! * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
$! * General Public License for more details.
$! *
$! * You should have received a copy of the GNU General Public License
$! * along with this program. If not, see http://www.gnu.org/licenses/.
$!
$!	SUB_FLOWLINE_EXAMPLE.COM
$!
$!	Copyright Laser-Scan Laboratories Ltd, Cambridge, England.
$!	Author : MWS Reid	7-October-1988
$!
$!	Example flowlne command file for flowline which may be 
$!	run as a sub-flowline. 
$!	Note that some required symbols are tested to see if they
$!	are already in existence in the outer-job. If they are in 
$!	existence then there is no need to prompt for them here.
$!
$! Set up logical names
$!
$	ws := " write sys$output"
$!
$! Set up defaults for symbols
$!
$	FLN_RESULT == "error"
$	FLN_CREATION_RESULT == "failure"
$	FLN_PROBLEM == "unknown"
$!
$! Output header
$!
$	ws ""
$	ws "   ***************************************************"
$	ws "   **                                               **"
$	ws "   **         Sheet flowline command procedure      **"
$	ws "   **                                               **"
$	ws "   ***************************************************"
$	ws ""
$	ws ""
$!
$ scale:
$	if "''fln_map_scale' .eqs "" then goto zone
$	fln_map_scale == "50000"
$	inq/nop scale "Please enter the sheet scale [''fln_map_scale'] : "
$	if scale.nes."" then fln_map_scale = scale
$ zone:
$	inq/nop zone "Which UTM zone is the sheet in ? "
$	if zone.eqs."" then goto zone
$	if f$integer(zone).ne.0 then goto stop
$	ws ""
$	ws " Illegal zone - please re-enter 1-60 "
$	ws ""
$	goto zone
$ stop:
$	ws "Please enter the edges of the map in geographicals"
$	ws ""
$!
$	ask = " Northern edge (ddd:mm:ss.ss) : "
$	@lsl$fln_dted_com:dted_get_tenths
$	SHEET_NSTOP = tenths
$!
$	ask = " Southern edge (ddd:mm:ss.ss) : "
$	@lsl$fln_dted_com:dted_get_tenths
$	SHEET_SSTOP = tenths
$!
$	ask = " Eastern edge (ddd:mm:ss.ss) : "
$	@lsl$fln_dted_com:dted_get_tenths
$	SHEET_ESTOP = tenths
$!
$	ask = " Western edge (ddd:mm:ss.ss) : "
$	@lsl$fln_dted_com:dted_get_tenths
$	SHEET_WSTOP = tenths
$ contour:
$	if "''contour_interval'" .nes. "" then goto exag
$	inq/nop contour_interval "Please input contour interval: "
$	if contour_interval .eqs. "" then goto contour
$	i3d_int= 2*f$integer('contour_interval')
$	i3d_max_interval = f$string('i3d_int')
$ exag:
$	if "''dtv_exag'" .nes. "" then goto step
$	inq/nop dtv_exag -
        "Please input DTIVIEW vertical exagerration: "
$ step:
$	if "''rover_step'" .nes. "" then goto thresh
$	inq/nop rover_step "Please input ROVER step interval: "
$	if rover_step .eqs. "" then goto step
$ thresh:
$	if "''dticheck_thresh'" .nes. "" then goto frt
$	inq/nop dticheck_thresh "Please input DTICHECK threshold: "
$	if dticheck_thresh .eqs. "" then goto thresh
$ frt:
$	if "''DTED_FRT'" .nes."" then goto sri
$	dted_frt = "dted"
$	inq/nop frt "Which FRT would you like to use ? [''dted_frt'] : "
$	if frt .nes. "" then -
	dted_frt=f$parse("''frt'","lsl$frt:dted.frt",,,"SYNTAX_ONLY")
$	if "'dted_frt'" .nes."" then goto sri
$	ws ""
$	ws "Error parsing file name - please reenter"
$	ws ""
$	goto frt
$!
$ sri:
$	if "''DTED_SRI'" .nes."" then goto tri
$	dted_sri = "dted"
$	inq/nop sri "Which SRI would you like to use ? [''dted_sri'] : "
$	if sri .nes. "" then -
	dted_sri=f$parse("''sri'","lsl$frt:dted.sri",,,"SYNTAX_ONLY")
$	if "'dted_sri'" .nes."" then goto tri
$	ws ""
$	ws "Error parsing file name - please reenter"
$	ws ""
$	goto sri
$!
$ tri:
$	if "''DTED_TRI'" .nes."" then goto patch
$	dted_tri = "dted"
$	inq/nop tri "Which tri would you like to use ? [''dted_tri'] : "
$	if tri .nes. "" then -
	dted_tri=f$parse("''tri'","lsl$frt:dted.tri",,,"SYNTAX_ONLY")
$	if "'dted_tri'" .nes."" then goto patch
$	ws ""
$	ws "Error parsing file name - please reenter"
$	ws ""
$	goto tri
$!
$ patch:
$	if "''DTED_PATCH'" .nes."" then goto lcm
$	dted_patch = "dted"
$	inq/nop patch -
	   "Which ltrak patch file would you like to use ? [''dted_patch'] : "
$	if patch  .nes. "" then -
	dted_patch = f$parse("''patch'","lsl$lk:dted_line.patch",,,"SYNTAX_ONLY")
$	if "'dted_patch'" .nes."" then goto lcm
$	ws ""
$	ws "Error parsing file name - please reenter"
$	ws ""
$	goto patch
$!
$ lcm:
$	if "''DTED_lcm'" .nes."" then goto blcm
$	dted_lcm = "dted"
$	ws "Which lites2 command file would you like to use "
$	inq/nop lcm "For editing [''dted_lcm'] ? "
$	if lcm .nes. "" then -
	dted_lcm = f$parse("''lcm'","lsl$lites2cmd:dted.lcm",,,"SYNTAX_ONLY")
$	if "'dted_lcm'" .nes."" then goto blcm2
$	ws ""
$	ws "Error parsing file name - please reenter"
$	ws ""
$	goto lcm
$!
$ blcm:
$	ws "Which lites2 command file would you like to use "
$ blcm2:
$	if "''DTED_blind_lcm'" .nes."" then goto dolog
$	dted_blind_lcm = "blind_dted"
$	inq/nop lcm "For digitising [''dted_blind_lcm'] ? "
$	if lcm .nes. "" then -
	dted_blind_lcm = f$parse("''lcm'","lsl$lites2cmd:blind_dted.lcm",,,"SYNTAX_ONLY")
$	if "'dted_blind_lcm'" .nes."" then goto dolog
$	ws ""
$	ws "Error parsing file name - please reenter"
$	ws ""
$	goto lcm
$!
$ dolog:
$	patch = "lsl$data_root:[flowline.dted.patch]"
$	cmd = "lsl$data_root:[flowline.dted.cmd]"
$	work = "lsl$site_root:[flowline.general.work]"
$	iff = "lsl$data_root:[flowline.dted.iff]"
$!
$	inq/nop RESP "Do you want to change any logical names ? "
$	ws ""
$	if .not.RESP then goto date
$!
$	patch_def = "lsl$data_root:[flowline.dted.patch]"
$	cmd_def = "lsl$data_root:[flowline.dted.cmd]"
$	work_def = "lsl$site_root:[flowline.general.work]"
$	iff_def = "lsl$data_root:[flowline.dted.iff]"
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
$	if "''work'" .nes. "" then goto liff
$	ws "Error parsing directory name"
$	ws ""
$	goto lwork
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
$!
$ date:
$	date = f$extract(0,17,f$time())
$	name := 'f$getjpi("","username")
$!
$! now write the job command file
$!
$	ws ""
$	ws "Writing job command file..."
$	ws ""
$	fln_job_comproc == dted_cmdfil
$	open/write cmdfil 'dted_cmdfil'
$	OK = $STATUS
$	if .not.OK then goto failure
$	wc := "write cmdfil"
$	wc "$!                   Sheet job command file"
$	wc "$!                   ~~~~~~~~~~~~~~~~~~~~~~" 
$	wc "$!"
$	wc "$!"
$	wc "$!      created by ''name' on ''date'"
$	wc "$!      for job ''fln_job_name'"
$	wc "$!"
$	wc "$ dted_file == ""''dted_file'""
$	wc "$ fln_map_scale == ""''fln_map_scale'""
$	wc "$ utm_zone == ""''zone'""
$	wc "$!"
$	wc "$! ........................................................"
$	wc "$!"
$	wc "$ assign ''cmd',lsl$site_root:[lites2.cmd]  lsl$lites2cmd /nolog"
$	wc "$!"
$	wc "$! ........................................................"
$	wc "$!"
$	wc "$ assign ''work' LSL$FLN_WORK /nolog"
$	wc "$!"
$	wc "$! ........................................................"
$	wc "$!"
$	wc "$ assign ''iff' lsl$if /nolog"
$	wc "$! ........................................................"
$	wc "$!"
$	wc "$ assign ''patch'  lsl$lk /nolog"
$	wc "$! ........................................................"
$	wc "$ skip:"
$	wc "$!" 
$	wc "$ rover_step == ""''rover_step'""
$	wc "$ dticheck_thresh == ""''dticheck_thresh'""
$	wc "$ dtv_exag == ""''dtv_exag'""
$	wc "$ contour_interval == ""''contour_interval'""
$	wc "$ dt_list_prefix == ""LSL$FLN_WORK:""
$	wc "$ i3d_max_interval == ""''i3d_max_interval'""
$	wc "$ dted_frt == ""''dted_frt'""
$	wc "$ dted_patch == ""''dted_patch'""
$	wc "$ dted_sri == ""''dted_sri'""
$	wc "$ dted_tri == ""''dted_tri'""
$	wc "$ dted_lites2cmd == ""''dted_lcm'""
$	wc "$!"
$	wc "$ sheet_nstop == ""''sheet_nstop'""
$	wc "$ sheet_sstop == ""''sheet_sstop'""
$	wc "$ sheet_estop == ""''sheet_estop'""
$	wc "$ sheet_wstop == ""''sheet_wstop'""
$	wc "$!"
$	wc "$ sheet_exist == ""''exist'""
$	wc "$!"
$	wc "$! set up the rest explicitly for now"
$	wc "$!"
$	wc "$ plotter == ""lsl$benson""
$	wc "$!"
$	wc "$! .........................................................."
$	wc "$	DT_LIST_PREFIX == ""LSL$FLN_WORK:""
$!
$	wc "$	DT_WORK_PREFIX == ""LSL$FLN_WORK:""
$!
$	wc "$	DT_IFF_PREFIX == ""LSL$IF:""
$	wc "$	DT_IFF_SUFFIX == "".IFF""
$!
$	wc "$	DT_LITES2_PREFIX == ""LSL$LITES2CMD:""
$	wc "$	DT_LITES2_SUFFIX == "".LCM""
$!
$	wc "$	RAW_SUFFIX == ""_RAW""
$!
$	wc "$	DT_CONTOUR_PREFIX == ""LSL$IF:""
$	wc "$	DT_CONTOUR_SUFFIX == "".CONTOUR""
$!
$	wc "$	DT_FORMLINE_PREFIX == ""LSL$IF:""
$	wc "$	DT_FORMLINE_SUFFIX == "".FORMLINE""
$!
$	wc "$	DT_RIVER_PREFIX == ""LSL$IF:""
$	wc "$	DT_RIVER_SUFFIX == "".RIVER""
$!
$	wc "$	DT_RIDGE_PREFIX == ""LSL$IF:""
$	wc "$	DT_RIDGE_SUFFIX == "".RIDGE""
$!
$	wc "$	DT_COAST_PREFIX == ""LSL$IF:""
$	wc "$	DT_COAST_SUFFIX == "".COAST""
$!
$	wc "$	DT_CLIFF_PREFIX == ""LSL$IF:""
$	wc "$	DT_CLIFF_SUFFIX == "".CLIFF""
$!
$	wc "$	DT_LAKE_PREFIX == ""LSL$IF:""
$	wc "$	DT_LAKE_SUFFIX == "".LAKE""
$!
$	wc "$	DT_SPOT_PREFIX == ""LSL$IF:""
$	wc "$	DT_SPOT_SUFFIX == "".SPOT""
$!
$	wc "$	DT_DIG_SUFFIX == ""_dig""
$	wc "$	DT_MERGE_SUFFIX == ""_mer""
$	wc "$!"
$	wc "$	DT_SELF_MERGE_SUFFIX == ""_smerge""
$	wc "$	DT_MERGE_SUFFIX	== ""_merge""
$	wc "$	DT_DIG_CLIP_SUFFIX == ""_dig_clip""
$	wc "$	DT_SHEET_CLIP_SUFFIX == ""_sheet_clip""
$	wc "$	DT_SHEET_UTM_SUFFIX == ""_sheet_utm""
$	wc "$	DT_SHEET_CODECH_SUFFIX == ""_sheet_codech""
$	wc "$   DT_3DSTART_SUFFIX == ""_3d_start""
$	wc "$   DT_LPBS_SUFFIX == ""_lpbs""
$	wc "$   DT_ONEARM_SUFFIX == ""_onearm""
$	wc "$   DT_ADDED_ONEARM_SUFFIX == ""_added_onearm""
$	wc "$   DT_STRUC_SUFFIX == ""_struc""
$	wc "$   DT_INTERP_SUFFIX == ""_interp""
$	wc "$   DT_FLOW_SUFFIX == ""_flow""
$	wc "$   DT_PLOT_FLOW_SUFFIX == ""_plot_flow""
$	wc "$   DT_COMBINE_CONTOUR_SUFFIX == "".comcontour""
$	wc "$   DT_COMBINE_WATER_SUFFIX == "".comwater""
$	wc "$   DT_COMBINE_WATER_SUFFIX == "".comspot""
$!
$	close cmdfil 
$	ok=$status
$	if OK then goto complete
$!
$! deal with errors
$!
$ failure:
$	FLN_RESULT == "error"
$	FLN_CREATION_RESULT == "failure"
$	FLN_PROBLEM == "Job file creation"
$	goto finish
$!
$! Complete
$!
$ complete:
$	ws ""
$	ws "Job command file ''dted_cmdfil'"
$	ws " written"
$	ws ""
$	FLN_RESULT == "complete"
$	FLN_CREATION_RESULT == "success"
$	FLN_PROBLEM == ""
$	FLN_OUTCOME == "1"
$!
$! and out
$!
$ finish:
$ exit
