$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1997-05-30 13:29:36.000000000 +0100
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
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$!	Command file for creating and submiting a batch command file
$!	for building ROVER
$!
$!	use tves_service library				JB 10-Aug-1993
$!
$!	mod1427 use new frtshr, frt_graph_init			JB 16-Nov-1994
$!	change rover.com to build and link roverben3000
$!	using lsl$foreign_root:[benson.grpv.online] in 
$!	roverben3000.opt
$!
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
$	buildingname = "lsl$rover_building"
$	buildingwarning = "''f$logical(buildingname)'"
$	if "''buildingwarning'" .eqs. "" then goto xx10
$		ws "''buildingwarning'"
$		exit
$!
$! set up group-wide flag to show that rover is now building
$!
$xx10:	on control_y then goto abort2
$	define/group 'buildingname' "''my_name' is building rover"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! open file to receive building commands
$!
$	comfile = "here:roverbat.com"
$	if f$search(comfile).nes."" then delete/nolog 'comfile';*
$	open/write comfil roverbat.com
$	on control_y then goto abort1
$ 	on error then goto xx260
$!
$! check for build already in progress from within the build command file
$!
$	wc "$ 	set noverify"
$	wc "$	ws = ""write sys$output"""
$	wc "$	on control_y then goto abort1"
$	wc "$	buildingname = ""lsl$rover_building"""
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
$	wc "$	assign here lsl$cmnrover"
$	wc "$	assign lsl$source_root:[tves.service] lsl$tvessys"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$	set verify"
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! initialise
$!
$	lis     = ""
$	lnkopts = ""
$	macopts = "/nolist"
$	comopts = ""
$	adcopts = ""
$	TRUE    = "1"
$	FALSE   = "0"
$!
$! decide which workstation you are building for
$!
$askbld:inq/nop bldarg   "build for ARGS ? "
$	inq/nop blduis   "build for UIS ? "
$	inq/nop bldmotif "build for MOTIF ? "
$	inq/nop bldsig   "build for SIG6000 ? "
$	inq/nop bldcal   "build for CAL5800 ? "
$	inq/nop bldben   "build for BEN3000 ? "
$	inq/nop bldvrs   "build for VERSATEC ? "
$	inq/nop bldpi    "build for PI448 ? "
$!
$	if bldarg   then goto xx15
$	if blduis   then goto xx15
$	if bldmotif then goto xx15
$	if bldsig   then goto xx15
$	if bldcal   then goto xx15
$	if bldben   then goto xx15
$	if bldvrs   then goto xx15
$	if bldpi    then goto xx15
$	goto askbld
$xx15:
$!
$! compile any sources?
$	everything = FALSE
$	inq/nop anything "Compile any sources ? "
$	if .not.anything then goto xx140
$!
$! compile with listings?
$	inq/nop lis "With listings ? "
$	if lis then comopts=comopts + "/list"
$	if .not.lis then comopts=comopts + "/nolist"
$!
$! compile with debug?
$	inq/nop deb "Compile with debug ? "
$	if deb then comopts=comopts + "/debug/noopt/check=(b,o)"
$	if deb then adcopts="/co"
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
$	if .not. lnkit then goto xx150
$!
$! link with debug?
$	lnkopts="/map"
$	inq/nop yes "Link with debug ? "
$	if yes then lnkopts=lnkopts + "/debug"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$xx150:
$	dummy	= FALSE
$!
$	if .not anything then goto nocomp
$	if .not. everything then goto xx160
$!
$	rover		= TRUE
$	init		= TRUE
$	opnfil		= TRUE
$	show		= TRUE
$	display		= TRUE
$	coords		= TRUE
$	legend		= TRUE
$	vector		= TRUE
$	draw		= TRUE
$	body		= TRUE
$	misc		= TRUE
$	digitise	= TRUE
$	rasted		= TRUE
$	specific	= TRUE
$	interp		= TRUE
$	status		= TRUE
$	registration	= TRUE
$	command_file    = TRUE
$	if bldarg .or. blduis .or. bldsig .or. bldpi then dummy = TRUE
$!
$	goto xx170
$xx160:
$	inq rover		"Compile cluster ""ROVER"""
$	inq body		"Compile cluster ""BODY"""
$	inq command_file        "Compile cluster ""COMMAND_FILE"""
$	inq coords		"Compile cluster ""COORDS"""
$	inq digitise		"Compile cluster ""DIGITISE"""
$	inq display		"Compile cluster ""DISPLAY"""
$	inq draw		"Compile cluster ""DRAW"""
$	inq init		"Compile cluster ""INIT"""
$	inq interp		"Compile cluster ""INTERP"""
$	inq legend		"Compile cluster ""LEGEND"""
$	inq misc		"Compile cluster ""MISC"""
$	inq opnfil		"Compile cluster ""OPNFIL"""
$	inq rasted		"Compile cluster ""RASTED"""
$	inq registration	"Compile cluster ""REGISTRATION"""
$	inq show		"Compile cluster ""SHOW"""
$	inq status		"Compile cluster ""STATUS"""
$	inq vector		"Compile cluster ""VECTOR"""
$	inq specific		"Compile cluster ""SPECIFIC"""
$	if bldarg .or. blduis .or. bldsig .or. bldpi then -
$		inq dummy	"Compile cluster ""DUMMY"""
$xx170:
$	if .not.rover then goto norover
$	call compiler rover
$norover:
$	If.not.init then goto noinit
$	call compiler init_device
$	call compiler init_display
$	call compiler init_raster
$	call compiler init_vector
$	call compiler rover_exit_handler
$	call compiler exit_init
$noinit:
$	if.not.opnfil then goto noopnfil
$       call compiler opnfil
$	call compiler rovfil
$	call compiler open_colour_map
$	call compiler clofil
$!
$noopnfil:
$	if.not.show then goto noshow
$       call compiler show
$	call compiler rovwin
$	call compiler chkwin
$	call compiler check_sample
$	call compiler showerr
$	call compiler show_enable
$	call compiler show_range
$	call compiler show_position
$	call compiler show_settings
$!
$noshow:
$	if.not.display then goto nodisplay
$	call compiler disply
$	call compiler rovdis
$	call compiler clear
$	call compiler icol
$	call compiler lutset
$	call compiler setstp
$	call compiler disval
$	call compiler display_read
$	call compiler modten
$	call compiler test_range
$!
$nodisplay:
$	if.not.coords then goto nocoords
$	call compiler getdti
$	call compiler set_tracking_area
$	call compiler update_transformations
$       call compiler transf
$       call compiler transform_dti
$	call compiler ctrlcast
$	call compiler hadctrlc
$	call compiler wait
$	call compiler gettab
$	call compiler getiff
$	call compiler output
$!
$nocoords:
$	if.not.legend then goto nolegend
$	call compiler legend
$	call compiler text
$	call compiler anotat
$!
$nolegend:
$	if.not.vector then goto novector
$	call compiler opniff
$	call compiler set_iffwin
$	call compiler set_iffdti
$	call compiler reset_iffwin
$	call compiler rdsel
$	call compiler rdfsn
$	call compiler rdlay
$	call compiler rdrang
$	call compiler shsele
$	call compiler displbtmp
$	call compiler inword
$	call compiler otplstrg
$!
$novector:
$	if.not.draw then goto nodraw
$	call compiler stdraw
$	call compiler gencir
$	call compiler stcirc
$	call compiler interp
$	call compiler addpts
$	call compiler addblk
$	call compiler outblk
$	call compiler blkdat
$	call compiler colset
$!
$nodraw:
$	if.not. body then goto nobody
$	call compiler iffbdy
$	call compiler loopy
$	call compiler inigks
$	call compiler resgks
$	call compiler pltiff
$	call compiler buffer
$	call compiler setlin
$	call compiler setcol
$	call compiler chkst
$	call compiler angsiz
$	call compiler intsct
$	call compiler srtoff
$	call compiler off
$	call compiler ofseg
$	call compiler pstosz
$	call compiler drwlab
$	call compiler setcon
$!
$nobody:
$	if .not.misc then goto nomisc
$	call compiler flood
$	call compiler cvtang
$	call compiler rdfang
$	call compiler readll
$	call compiler help
$	call compiler check_mode
$	call compiler setup_ball_timer
$!
$nomisc:
$	if .not. digitise then goto nodigitise
$	call compiler getstr
$	call compiler opnout
$	call compiler clsout
$!
$nodigitise:
$	if .not.rasted then goto norasted
$	call compiler single_move
$	call compiler move_cursor
$	call compiler set_dti_position
$	call compiler set_rotate
$	call compiler rovmove
$	call compiler display_edit
$	call compiler edit
$	call compiler end_edit
$	call compiler join_pix
$	call compiler tt_read_number
$	call compiler replace_edit
$	call compiler init_edit
$	call compiler reverse
$	call compiler edited_already
$	call compiler rov_remove
$	call compiler rovzoom
$	call compiler zoom
$	call compiler finish_edit
$	call compiler inter_flood
$	call compiler update_heights
$	call compiler reset_planes
$	call compiler start_edit
$	call compiler read_dti_position
$!
$norasted:
$	if .not. specific then goto nospecific
$	if .not. blduis then goto nouis
$	call compiler balinit_uis
$	call compiler read_trkb_uis
$	call compiler mouse_uis
$	call compiler set_ptr_vis_uis
$	call compiler set_trkb_uis
$	call compiler get_button_uis
$	call compiler reset_ball_uis
$!
$nouis:
$	if .not. bldmotif then goto nomotif
$!
$! note use of UIS routines
$!
$	call compiler balinit_motif
$	call compiler read_trkb_uis
$	call compiler mouse_motif
$	call compiler set_ptr_vis_uis
$	call compiler set_trkb_uis
$	call compiler get_button_uis
$	call compiler reset_ball_uis
$!
$nomotif:
$	if .not. bldarg then goto noarg
$	call compiler balinit_args
$	call compiler read_trkb_args
$	call compiler set_ptr_vis_args
$	call compiler set_trkb_args
$	call compiler get_button_args
$	call compiler reset_ball_args
$!
$noarg:
$	if .not. bldsig then goto nosig
$	call compiler balinit_sig6000
$	call compiler read_trkb_sig6000
$	call compiler set_ptr_vis_sig6000
$	call compiler set_trkb_sig6000
$	call compiler reset_ball_sig6000
$	call compiler get_button_sig6000
$!
$nosig:
$	if .not. bldcal then goto nobldcal
$	call compiler balinit_cal5800
$	call compiler read_trkb_cal5800
$	call compiler set_ptr_vis_cal5800
$	call compiler set_trkb_cal5800
$	call compiler reset_ball_cal5800
$	call compiler get_button_cal5800
$!
$nobldcal:
$	if .not. bldben then goto nospecific
$	call compiler balinit_cal5800
$	call compiler read_trkb_cal5800
$	call compiler set_ptr_vis_cal5800
$	call compiler set_trkb_cal5800
$	call compiler reset_ball_cal5800
$	call compiler get_button_cal5800
$!
$nospecific:
$	if .not.interp then goto nointerp
$	call compiler end_interp
$	call compiler interp_edit
$	call compiler put_dti_val
$	call compiler get_dti_val
$	call compiler end_poly
$	call compiler poly_edit
$!
$nointerp:
$	if .not.status then goto nostatus
$	call compiler update_status
$	call compiler setup_status
$	call compiler write_vals
$	call compiler clear_status
$!
$nostatus:
$	if .not. registration then goto noregistration
$	call compiler show_rcp_file
$	call compiler select_rcp_file
$	call compiler close_rcp_file
$	call compiler begin_registration
$	call compiler open_rcp_file
$	call compiler create_rcp_file
$	call compiler read_rcp_file
$	call compiler write_rcp_file
$	call compiler end_registration
$	call compiler get_free_and_base
$	call compiler get_ls_lin_transf
$	call compiler rcp_command
$	call compiler rcp_add
$	call compiler rcp_delete
$	call compiler rcp_edit
$	call compiler rcp_move
$	call compiler rcp_set_default
$	call compiler rcp_enable_default
$	call compiler rcp_check_id
$	call compiler rcp_convert_from_mouse
$	call compiler rcp_convert_to_mouse
$	call compiler matrix_point_five
$!
$noregistration: 
$	if .not. command_file then goto nocommand_file
$	call compiler rovresp
$	call compiler rovat
$	call compiler rovmess
$	call compiler rovcont
$	call compiler rovping
$!
$nocommand_file:
$nocomp:
$	if .not. mar then goto nomar
$	wc "$	set noverify"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$ set verify"
$	wc "$	macro''macopts'/object=rover_mar rover + lsl$library:lslmaclib/lib"
$	wc "$ 	ok=$status"	
$	wc "$	purge/nolog rover_mar.obj"
$	wc "$	if .not.ok then emsg=emsg + "" rover_mar"""
$	wc "$! "
$	wc "$	macro''macopts'/object=efwm efwm+ lsl$library:lslmaclib/lib"
$	wc "$ 	ok=$status"	
$	wc "$	purge/nolog efwm.obj"
$	wc "$	if .not.ok then emsg=emsg + "" efwm"""
$	wc "$	set noverify"
$	wc "$! "
$!
$nomar:
$	if .not. dummy then goto nodummy
$	if .not.(bldarg .or. blduis .or. bldsig) then goto nodummyuis
$	wc "$	set noverify"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$ set verify"
$	wc "$	macro''macopts'/object=uis_dummy uis_dummy + lsl$library:lslmaclib/lib"
$	wc "$ 	ok=$status"	
$	wc "$	purge/nolog uis_dummy.obj"
$	wc "$	if .not.ok then emsg=emsg + "" uis_dummy"""
$	wc "$! "
$!
$nodummyuis:
$	if .not. bldpi then goto nodummypi
$	wc "$	set noverify"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$ set verify"
$	wc "$	macro''macopts'/object=pi448_dummy pi448_dummy + lsl$library:lslmaclib/lib"
$	wc "$ 	ok=$status"	
$	wc "$	purge/nolog pi448_dummy.obj"
$	wc "$	if .not.ok then emsg=emsg + "" pi448_dummy"""
$	wc "$! "
$!
$nodummypi:
$nodummy:
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
$! link
$!
$ 	if .not. lnkit then goto xx250
$!
$	wc "$ ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$ set verify"
$!
$	wc "$	run lsl$exe:genver"
$	wc "$	adc version=version"
$	wc "$	fort/nolist version"
$	wc "$	pvv version"
$	wc "$	delete adc.ide;*,version.for;*"
$	wc "$	purge version.*"
$!
$	if .not.bldarg then goto nolnkarg
$	wc "$ 	link''lnkopts'/map=roverargs/exe=roverargs -"
$	wc "	rovercommon/opt,roverargs/opt,-"
$	wc "	version,lsl$tvessys:tves_service/lib,-"
$	wc "	lsl$library:lslshr/opt,iffshr/opt,frtshr/opt,dtishr/opt"
$	wc "$	mapid roverargs
$	wc "$!"
$!
$nolnkarg: if .not.blduis then goto nolnkuis
$	wc "$ 	link''lnkopts'/map=roveruis/exe=roveruis -"
$	wc "	rovercommon/opt,roveruis/opt,-"
$	wc "	version,lsl$tvessys:tves_service/lib,-"
$	wc "	lsl$library:lslshr/opt,iffshr/opt,frtshr/opt,dtishr/opt"
$	wc "$	mapid roveruis"
$	wc "$!"
$!
$nolnkuis: if .not.bldmotif then goto nolnkmotif
$	wc "$ 	link''lnkopts'/map=rovermotif/exe=rovermotif -"
$	wc "	rovercommon/opt, here:rovermotif/opt,-"
$	wc "	version,lsl$tvessys:tves_service/lib,-"
$	wc "	lsl$library:lslshr/opt,iffshr/opt,frtshr/opt,dtishr/opt"
$	wc "$	mapid rovermotif"
$	wc "$!"
$!
$nolnkmotif: if .not.bldsig then goto nolnksig
$	wc "$ 	link''lnkopts'/map=roversig6000/exe=roversig6000 -"
$	wc "	rovercommon/opt,roversig6000/opt,-"
$	wc "	version,lsl$tvessys:tves_service/lib,-"
$	wc "	lsl$library:lslshr/opt,iffshr/opt,frtshr/opt,dtishr/opt"
$	wc "$	mapid roversig6000"
$	wc "$!"
$!
$nolnksig: if .not.bldcal then goto nolnkcal
$	wc "$ 	link''lnkopts'/map=rovercal5800/exe=rovercal5800 -"
$	wc "	rovercommon/opt,rovercal5800/opt,-"
$	wc "	version,lsl$tvessys:tves_service/lib,-"
$	wc "    lsl$library:lslshr/opt,iffshr/opt,frtshr/opt,dtishr/opt"
$	wc "$	mapid rovercal5800"
$	wc "$!"
$!
$nolnkcal: if .not.bldben then goto nolnkben
$	wc "$ 	link''lnkopts'/map=roverben3000/exe=roverben3000 -"
$	wc "	rovercommon/opt,roverben3000/opt,-"
$	wc "	version,lsl$tvessys:tves_service/lib,-"
$	wc "	lsl$library:lslshr/opt,iffshr/opt,frtshr/opt,dtishr/opt"
$	wc "$	mapid roverben3000"
$	wc "$!"
$!
$nolnkben: if .not.bldvrs then goto nolnkvrs
$	wc "$ 	link''lnkopts'/map=rovervrsc2v1/exe=rovervrsc2v1 -"
$	wc "	rovercommon/opt,rovervrsc2v1/opt,-"
$	wc "	version,lsl$tvessys:tves_service/lib,-"
$	wc "	lsl$library:lslshr/opt,iffshr/opt,frtshr/opt,dtishr/opt"
$	wc "$	mapid rovervrsc2v1"
$	wc "$!"
$!
$nolnkvrs: if .not.bldpi then goto nolnkpi
$	wc "$ 	link''lnkopts'/map=roverpi448/exe=roverpi448 -"
$	wc "	rovercommon/opt,roverpi448/opt,-"
$	wc "	version,lsl$tvessys:tves_service/lib,-"
$	wc "	lsl$library:lslshr/opt,iffshr/opt,frtshr/opt,dtishr/opt"
$	wc "$	mapid roverpi448"
$	wc "$!"
$nolnkpi:
$!
$	wc "$   delete/nolog *.map;*"
$	wc "$   purge/nolog *.mapid"
$!	wc "$   purge/nolog *.exe"
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
$!
$xx260:
$	on error then goto abort2
$	close comfil
$	ok=$status
$!
$	if ok then inq/nop yes "Submit for batch ? "
$	if .not. yes then goto xx270
$	deass/group 'buildingname'
$	bat roverbat.com
$	goto normal_exit
$xx270:
$	if ok then inq/nop yes "Submit for FAST batch ? "
$	if .not. yes then goto xx280
$	deass/group 'buildingname'
$	fbat roverbat.com
$	goto normal_exit
$xx280:	
$	if ok then inq/nop yes "Interactive ? "
$	if .not.yes then goto abort2
$	deass/group 'buildingname'
$	@roverbat.com
$	goto normal_exit
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! terminate build session
$!
$abort1:close comfil
$abort2:deass/group 'buildingname'
$normal_exit:
$	purge/nolog roverbat.com
$	if ver then set verify
$	exit
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! subroutine to adc/fortran/pvv/purge file P1
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$compiler:
$	subroutine
$	wc "$ 	set noverify"
$	wc "$	ws ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$	set verify"
$	wc "$ 	adc ''p1'''adcopts'= ''p1'"
$	wc "$	fort''comopts' ''p1'"
$	wc "$ 	ok=$status"
$	wc "$	lis = ""''lis'"" "
$	wc "$ 	if ok then pvv ''p1'"
$	wc "$ 	purge/nolog ''p1'.obj"
$	if .not.deb then	wc "$ 	delete/nolog ''p1'.for;*"
$	if deb then		wc "$ 	purge/nolog ''p1'.for"
$	if (f$locate("nolist",comopts).ge.f$length(comopts)) -
		then		wc "$ 	if ok.and.lis then delete/nolog ''p1'.lis;*"
$	wc "$	if .not.ok then emsg=emsg + "" ''p1'"""
$	wc "$ 	delete adc.ide;*"
$	return
$	endsubroutine
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
