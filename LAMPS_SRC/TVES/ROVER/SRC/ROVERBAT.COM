$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1999-12-03 12:11:14.000000000 +0000
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
$ 	set noverify
$	ws = "write sys$output"
$	on control_y then goto abort1
$	buildingname = "lsl$rover_building"
$	buildingwarning = "''f$logical(buildingname)'"
$	if "''buildingwarning'" .eqs. "" then goto xx20
$	ws "''buildingwarning'"
$	exit
$!
$xx20:
$	define/group lsl$rover_building "in_progress"
$	sd:=$lsl$sys:sd
$	set noon
$	emsg=""
$	assign here lsl$cmnrover
$	assign lsl$source_root:[tves.service] lsl$tvessys
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ROVER= ROVER
$	fort/nolist ROVER
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv ROVER
$ 	purge/nolog ROVER.obj
$ 	delete/nolog ROVER.for;*
$	if .not.ok then emsg=emsg + " ROVER"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc INIT_DEVICE= INIT_DEVICE
$	fort/nolist INIT_DEVICE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv INIT_DEVICE
$ 	purge/nolog INIT_DEVICE.obj
$ 	delete/nolog INIT_DEVICE.for;*
$	if .not.ok then emsg=emsg + " INIT_DEVICE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc INIT_DISPLAY= INIT_DISPLAY
$	fort/nolist INIT_DISPLAY
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv INIT_DISPLAY
$ 	purge/nolog INIT_DISPLAY.obj
$ 	delete/nolog INIT_DISPLAY.for;*
$	if .not.ok then emsg=emsg + " INIT_DISPLAY"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc INIT_RASTER= INIT_RASTER
$	fort/nolist INIT_RASTER
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv INIT_RASTER
$ 	purge/nolog INIT_RASTER.obj
$ 	delete/nolog INIT_RASTER.for;*
$	if .not.ok then emsg=emsg + " INIT_RASTER"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc INIT_VECTOR= INIT_VECTOR
$	fort/nolist INIT_VECTOR
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv INIT_VECTOR
$ 	purge/nolog INIT_VECTOR.obj
$ 	delete/nolog INIT_VECTOR.for;*
$	if .not.ok then emsg=emsg + " INIT_VECTOR"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ROVER_EXIT_HANDLER= ROVER_EXIT_HANDLER
$	fort/nolist ROVER_EXIT_HANDLER
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv ROVER_EXIT_HANDLER
$ 	purge/nolog ROVER_EXIT_HANDLER.obj
$ 	delete/nolog ROVER_EXIT_HANDLER.for;*
$	if .not.ok then emsg=emsg + " ROVER_EXIT_HANDLER"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc EXIT_INIT= EXIT_INIT
$	fort/nolist EXIT_INIT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv EXIT_INIT
$ 	purge/nolog EXIT_INIT.obj
$ 	delete/nolog EXIT_INIT.for;*
$	if .not.ok then emsg=emsg + " EXIT_INIT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc OPNFIL= OPNFIL
$	fort/nolist OPNFIL
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv OPNFIL
$ 	purge/nolog OPNFIL.obj
$ 	delete/nolog OPNFIL.for;*
$	if .not.ok then emsg=emsg + " OPNFIL"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ROVFIL= ROVFIL
$	fort/nolist ROVFIL
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv ROVFIL
$ 	purge/nolog ROVFIL.obj
$ 	delete/nolog ROVFIL.for;*
$	if .not.ok then emsg=emsg + " ROVFIL"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc OPEN_COLOUR_MAP= OPEN_COLOUR_MAP
$	fort/nolist OPEN_COLOUR_MAP
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv OPEN_COLOUR_MAP
$ 	purge/nolog OPEN_COLOUR_MAP.obj
$ 	delete/nolog OPEN_COLOUR_MAP.for;*
$	if .not.ok then emsg=emsg + " OPEN_COLOUR_MAP"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc CLOFIL= CLOFIL
$	fort/nolist CLOFIL
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv CLOFIL
$ 	purge/nolog CLOFIL.obj
$ 	delete/nolog CLOFIL.for;*
$	if .not.ok then emsg=emsg + " CLOFIL"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SHOW= SHOW
$	fort/nolist SHOW
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SHOW
$ 	purge/nolog SHOW.obj
$ 	delete/nolog SHOW.for;*
$	if .not.ok then emsg=emsg + " SHOW"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ROVWIN= ROVWIN
$	fort/nolist ROVWIN
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv ROVWIN
$ 	purge/nolog ROVWIN.obj
$ 	delete/nolog ROVWIN.for;*
$	if .not.ok then emsg=emsg + " ROVWIN"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc CHKWIN= CHKWIN
$	fort/nolist CHKWIN
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv CHKWIN
$ 	purge/nolog CHKWIN.obj
$ 	delete/nolog CHKWIN.for;*
$	if .not.ok then emsg=emsg + " CHKWIN"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc CHECK_SAMPLE= CHECK_SAMPLE
$	fort/nolist CHECK_SAMPLE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv CHECK_SAMPLE
$ 	purge/nolog CHECK_SAMPLE.obj
$ 	delete/nolog CHECK_SAMPLE.for;*
$	if .not.ok then emsg=emsg + " CHECK_SAMPLE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SHOWERR= SHOWERR
$	fort/nolist SHOWERR
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SHOWERR
$ 	purge/nolog SHOWERR.obj
$ 	delete/nolog SHOWERR.for;*
$	if .not.ok then emsg=emsg + " SHOWERR"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SHOW_ENABLE= SHOW_ENABLE
$	fort/nolist SHOW_ENABLE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SHOW_ENABLE
$ 	purge/nolog SHOW_ENABLE.obj
$ 	delete/nolog SHOW_ENABLE.for;*
$	if .not.ok then emsg=emsg + " SHOW_ENABLE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SHOW_RANGE= SHOW_RANGE
$	fort/nolist SHOW_RANGE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SHOW_RANGE
$ 	purge/nolog SHOW_RANGE.obj
$ 	delete/nolog SHOW_RANGE.for;*
$	if .not.ok then emsg=emsg + " SHOW_RANGE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SHOW_POSITION= SHOW_POSITION
$	fort/nolist SHOW_POSITION
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SHOW_POSITION
$ 	purge/nolog SHOW_POSITION.obj
$ 	delete/nolog SHOW_POSITION.for;*
$	if .not.ok then emsg=emsg + " SHOW_POSITION"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SHOW_SETTINGS= SHOW_SETTINGS
$	fort/nolist SHOW_SETTINGS
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SHOW_SETTINGS
$ 	purge/nolog SHOW_SETTINGS.obj
$ 	delete/nolog SHOW_SETTINGS.for;*
$	if .not.ok then emsg=emsg + " SHOW_SETTINGS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc DISPLY= DISPLY
$	fort/nolist DISPLY
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv DISPLY
$ 	purge/nolog DISPLY.obj
$ 	delete/nolog DISPLY.for;*
$	if .not.ok then emsg=emsg + " DISPLY"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ROVDIS= ROVDIS
$	fort/nolist ROVDIS
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv ROVDIS
$ 	purge/nolog ROVDIS.obj
$ 	delete/nolog ROVDIS.for;*
$	if .not.ok then emsg=emsg + " ROVDIS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc CLEAR= CLEAR
$	fort/nolist CLEAR
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv CLEAR
$ 	purge/nolog CLEAR.obj
$ 	delete/nolog CLEAR.for;*
$	if .not.ok then emsg=emsg + " CLEAR"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ICOL= ICOL
$	fort/nolist ICOL
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv ICOL
$ 	purge/nolog ICOL.obj
$ 	delete/nolog ICOL.for;*
$	if .not.ok then emsg=emsg + " ICOL"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc LUTSET= LUTSET
$	fort/nolist LUTSET
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv LUTSET
$ 	purge/nolog LUTSET.obj
$ 	delete/nolog LUTSET.for;*
$	if .not.ok then emsg=emsg + " LUTSET"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SETSTP= SETSTP
$	fort/nolist SETSTP
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SETSTP
$ 	purge/nolog SETSTP.obj
$ 	delete/nolog SETSTP.for;*
$	if .not.ok then emsg=emsg + " SETSTP"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc DISVAL= DISVAL
$	fort/nolist DISVAL
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv DISVAL
$ 	purge/nolog DISVAL.obj
$ 	delete/nolog DISVAL.for;*
$	if .not.ok then emsg=emsg + " DISVAL"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc DISPLAY_READ= DISPLAY_READ
$	fort/nolist DISPLAY_READ
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv DISPLAY_READ
$ 	purge/nolog DISPLAY_READ.obj
$ 	delete/nolog DISPLAY_READ.for;*
$	if .not.ok then emsg=emsg + " DISPLAY_READ"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc MODTEN= MODTEN
$	fort/nolist MODTEN
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv MODTEN
$ 	purge/nolog MODTEN.obj
$ 	delete/nolog MODTEN.for;*
$	if .not.ok then emsg=emsg + " MODTEN"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc TEST_RANGE= TEST_RANGE
$	fort/nolist TEST_RANGE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv TEST_RANGE
$ 	purge/nolog TEST_RANGE.obj
$ 	delete/nolog TEST_RANGE.for;*
$	if .not.ok then emsg=emsg + " TEST_RANGE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc GETDTI= GETDTI
$	fort/nolist GETDTI
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv GETDTI
$ 	purge/nolog GETDTI.obj
$ 	delete/nolog GETDTI.for;*
$	if .not.ok then emsg=emsg + " GETDTI"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SET_TRACKING_AREA= SET_TRACKING_AREA
$	fort/nolist SET_TRACKING_AREA
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SET_TRACKING_AREA
$ 	purge/nolog SET_TRACKING_AREA.obj
$ 	delete/nolog SET_TRACKING_AREA.for;*
$	if .not.ok then emsg=emsg + " SET_TRACKING_AREA"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc UPDATE_TRANSFORMATIONS= UPDATE_TRANSFORMATIONS
$	fort/nolist UPDATE_TRANSFORMATIONS
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv UPDATE_TRANSFORMATIONS
$ 	purge/nolog UPDATE_TRANSFORMATIONS.obj
$ 	delete/nolog UPDATE_TRANSFORMATIONS.for;*
$	if .not.ok then emsg=emsg + " UPDATE_TRANSFORMATIONS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc TRANSF= TRANSF
$	fort/nolist TRANSF
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv TRANSF
$ 	purge/nolog TRANSF.obj
$ 	delete/nolog TRANSF.for;*
$	if .not.ok then emsg=emsg + " TRANSF"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc TRANSFORM_DTI= TRANSFORM_DTI
$	fort/nolist TRANSFORM_DTI
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv TRANSFORM_DTI
$ 	purge/nolog TRANSFORM_DTI.obj
$ 	delete/nolog TRANSFORM_DTI.for;*
$	if .not.ok then emsg=emsg + " TRANSFORM_DTI"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc CTRLCAST= CTRLCAST
$	fort/nolist CTRLCAST
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv CTRLCAST
$ 	purge/nolog CTRLCAST.obj
$ 	delete/nolog CTRLCAST.for;*
$	if .not.ok then emsg=emsg + " CTRLCAST"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc HADCTRLC= HADCTRLC
$	fort/nolist HADCTRLC
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv HADCTRLC
$ 	purge/nolog HADCTRLC.obj
$ 	delete/nolog HADCTRLC.for;*
$	if .not.ok then emsg=emsg + " HADCTRLC"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc WAIT= WAIT
$	fort/nolist WAIT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv WAIT
$ 	purge/nolog WAIT.obj
$ 	delete/nolog WAIT.for;*
$	if .not.ok then emsg=emsg + " WAIT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc GETTAB= GETTAB
$	fort/nolist GETTAB
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv GETTAB
$ 	purge/nolog GETTAB.obj
$ 	delete/nolog GETTAB.for;*
$	if .not.ok then emsg=emsg + " GETTAB"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc GETIFF= GETIFF
$	fort/nolist GETIFF
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv GETIFF
$ 	purge/nolog GETIFF.obj
$ 	delete/nolog GETIFF.for;*
$	if .not.ok then emsg=emsg + " GETIFF"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc OUTPUT= OUTPUT
$	fort/nolist OUTPUT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv OUTPUT
$ 	purge/nolog OUTPUT.obj
$ 	delete/nolog OUTPUT.for;*
$	if .not.ok then emsg=emsg + " OUTPUT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc LEGEND= LEGEND
$	fort/nolist LEGEND
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv LEGEND
$ 	purge/nolog LEGEND.obj
$ 	delete/nolog LEGEND.for;*
$	if .not.ok then emsg=emsg + " LEGEND"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc TEXT= TEXT
$	fort/nolist TEXT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv TEXT
$ 	purge/nolog TEXT.obj
$ 	delete/nolog TEXT.for;*
$	if .not.ok then emsg=emsg + " TEXT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ANOTAT= ANOTAT
$	fort/nolist ANOTAT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv ANOTAT
$ 	purge/nolog ANOTAT.obj
$ 	delete/nolog ANOTAT.for;*
$	if .not.ok then emsg=emsg + " ANOTAT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc OPNIFF= OPNIFF
$	fort/nolist OPNIFF
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv OPNIFF
$ 	purge/nolog OPNIFF.obj
$ 	delete/nolog OPNIFF.for;*
$	if .not.ok then emsg=emsg + " OPNIFF"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SET_IFFWIN= SET_IFFWIN
$	fort/nolist SET_IFFWIN
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SET_IFFWIN
$ 	purge/nolog SET_IFFWIN.obj
$ 	delete/nolog SET_IFFWIN.for;*
$	if .not.ok then emsg=emsg + " SET_IFFWIN"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SET_IFFDTI= SET_IFFDTI
$	fort/nolist SET_IFFDTI
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SET_IFFDTI
$ 	purge/nolog SET_IFFDTI.obj
$ 	delete/nolog SET_IFFDTI.for;*
$	if .not.ok then emsg=emsg + " SET_IFFDTI"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc RESET_IFFWIN= RESET_IFFWIN
$	fort/nolist RESET_IFFWIN
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv RESET_IFFWIN
$ 	purge/nolog RESET_IFFWIN.obj
$ 	delete/nolog RESET_IFFWIN.for;*
$	if .not.ok then emsg=emsg + " RESET_IFFWIN"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc RDSEL= RDSEL
$	fort/nolist RDSEL
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv RDSEL
$ 	purge/nolog RDSEL.obj
$ 	delete/nolog RDSEL.for;*
$	if .not.ok then emsg=emsg + " RDSEL"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc RDFSN= RDFSN
$	fort/nolist RDFSN
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv RDFSN
$ 	purge/nolog RDFSN.obj
$ 	delete/nolog RDFSN.for;*
$	if .not.ok then emsg=emsg + " RDFSN"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc RDLAY= RDLAY
$	fort/nolist RDLAY
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv RDLAY
$ 	purge/nolog RDLAY.obj
$ 	delete/nolog RDLAY.for;*
$	if .not.ok then emsg=emsg + " RDLAY"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc RDRANG= RDRANG
$	fort/nolist RDRANG
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv RDRANG
$ 	purge/nolog RDRANG.obj
$ 	delete/nolog RDRANG.for;*
$	if .not.ok then emsg=emsg + " RDRANG"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SHSELE= SHSELE
$	fort/nolist SHSELE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SHSELE
$ 	purge/nolog SHSELE.obj
$ 	delete/nolog SHSELE.for;*
$	if .not.ok then emsg=emsg + " SHSELE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc DISPLBTMP= DISPLBTMP
$	fort/nolist DISPLBTMP
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv DISPLBTMP
$ 	purge/nolog DISPLBTMP.obj
$ 	delete/nolog DISPLBTMP.for;*
$	if .not.ok then emsg=emsg + " DISPLBTMP"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc INWORD= INWORD
$	fort/nolist INWORD
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv INWORD
$ 	purge/nolog INWORD.obj
$ 	delete/nolog INWORD.for;*
$	if .not.ok then emsg=emsg + " INWORD"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc OTPLSTRG= OTPLSTRG
$	fort/nolist OTPLSTRG
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv OTPLSTRG
$ 	purge/nolog OTPLSTRG.obj
$ 	delete/nolog OTPLSTRG.for;*
$	if .not.ok then emsg=emsg + " OTPLSTRG"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc STDRAW= STDRAW
$	fort/nolist STDRAW
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv STDRAW
$ 	purge/nolog STDRAW.obj
$ 	delete/nolog STDRAW.for;*
$	if .not.ok then emsg=emsg + " STDRAW"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc GENCIR= GENCIR
$	fort/nolist GENCIR
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv GENCIR
$ 	purge/nolog GENCIR.obj
$ 	delete/nolog GENCIR.for;*
$	if .not.ok then emsg=emsg + " GENCIR"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc STCIRC= STCIRC
$	fort/nolist STCIRC
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv STCIRC
$ 	purge/nolog STCIRC.obj
$ 	delete/nolog STCIRC.for;*
$	if .not.ok then emsg=emsg + " STCIRC"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc INTERP= INTERP
$	fort/nolist INTERP
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv INTERP
$ 	purge/nolog INTERP.obj
$ 	delete/nolog INTERP.for;*
$	if .not.ok then emsg=emsg + " INTERP"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ADDPTS= ADDPTS
$	fort/nolist ADDPTS
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv ADDPTS
$ 	purge/nolog ADDPTS.obj
$ 	delete/nolog ADDPTS.for;*
$	if .not.ok then emsg=emsg + " ADDPTS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ADDBLK= ADDBLK
$	fort/nolist ADDBLK
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv ADDBLK
$ 	purge/nolog ADDBLK.obj
$ 	delete/nolog ADDBLK.for;*
$	if .not.ok then emsg=emsg + " ADDBLK"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc OUTBLK= OUTBLK
$	fort/nolist OUTBLK
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv OUTBLK
$ 	purge/nolog OUTBLK.obj
$ 	delete/nolog OUTBLK.for;*
$	if .not.ok then emsg=emsg + " OUTBLK"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc BLKDAT= BLKDAT
$	fort/nolist BLKDAT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv BLKDAT
$ 	purge/nolog BLKDAT.obj
$ 	delete/nolog BLKDAT.for;*
$	if .not.ok then emsg=emsg + " BLKDAT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc COLSET= COLSET
$	fort/nolist COLSET
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv COLSET
$ 	purge/nolog COLSET.obj
$ 	delete/nolog COLSET.for;*
$	if .not.ok then emsg=emsg + " COLSET"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc IFFBDY= IFFBDY
$	fort/nolist IFFBDY
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv IFFBDY
$ 	purge/nolog IFFBDY.obj
$ 	delete/nolog IFFBDY.for;*
$	if .not.ok then emsg=emsg + " IFFBDY"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc LOOPY= LOOPY
$	fort/nolist LOOPY
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv LOOPY
$ 	purge/nolog LOOPY.obj
$ 	delete/nolog LOOPY.for;*
$	if .not.ok then emsg=emsg + " LOOPY"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc INIGKS= INIGKS
$	fort/nolist INIGKS
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv INIGKS
$ 	purge/nolog INIGKS.obj
$ 	delete/nolog INIGKS.for;*
$	if .not.ok then emsg=emsg + " INIGKS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc RESGKS= RESGKS
$	fort/nolist RESGKS
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv RESGKS
$ 	purge/nolog RESGKS.obj
$ 	delete/nolog RESGKS.for;*
$	if .not.ok then emsg=emsg + " RESGKS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc PLTIFF= PLTIFF
$	fort/nolist PLTIFF
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv PLTIFF
$ 	purge/nolog PLTIFF.obj
$ 	delete/nolog PLTIFF.for;*
$	if .not.ok then emsg=emsg + " PLTIFF"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc BUFFER= BUFFER
$	fort/nolist BUFFER
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv BUFFER
$ 	purge/nolog BUFFER.obj
$ 	delete/nolog BUFFER.for;*
$	if .not.ok then emsg=emsg + " BUFFER"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SETLIN= SETLIN
$	fort/nolist SETLIN
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SETLIN
$ 	purge/nolog SETLIN.obj
$ 	delete/nolog SETLIN.for;*
$	if .not.ok then emsg=emsg + " SETLIN"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SETCOL= SETCOL
$	fort/nolist SETCOL
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SETCOL
$ 	purge/nolog SETCOL.obj
$ 	delete/nolog SETCOL.for;*
$	if .not.ok then emsg=emsg + " SETCOL"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc CHKST= CHKST
$	fort/nolist CHKST
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv CHKST
$ 	purge/nolog CHKST.obj
$ 	delete/nolog CHKST.for;*
$	if .not.ok then emsg=emsg + " CHKST"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ANGSIZ= ANGSIZ
$	fort/nolist ANGSIZ
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv ANGSIZ
$ 	purge/nolog ANGSIZ.obj
$ 	delete/nolog ANGSIZ.for;*
$	if .not.ok then emsg=emsg + " ANGSIZ"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc INTSCT= INTSCT
$	fort/nolist INTSCT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv INTSCT
$ 	purge/nolog INTSCT.obj
$ 	delete/nolog INTSCT.for;*
$	if .not.ok then emsg=emsg + " INTSCT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SRTOFF= SRTOFF
$	fort/nolist SRTOFF
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SRTOFF
$ 	purge/nolog SRTOFF.obj
$ 	delete/nolog SRTOFF.for;*
$	if .not.ok then emsg=emsg + " SRTOFF"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc OFF= OFF
$	fort/nolist OFF
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv OFF
$ 	purge/nolog OFF.obj
$ 	delete/nolog OFF.for;*
$	if .not.ok then emsg=emsg + " OFF"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc OFSEG= OFSEG
$	fort/nolist OFSEG
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv OFSEG
$ 	purge/nolog OFSEG.obj
$ 	delete/nolog OFSEG.for;*
$	if .not.ok then emsg=emsg + " OFSEG"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc PSTOSZ= PSTOSZ
$	fort/nolist PSTOSZ
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv PSTOSZ
$ 	purge/nolog PSTOSZ.obj
$ 	delete/nolog PSTOSZ.for;*
$	if .not.ok then emsg=emsg + " PSTOSZ"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc DRWLAB= DRWLAB
$	fort/nolist DRWLAB
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv DRWLAB
$ 	purge/nolog DRWLAB.obj
$ 	delete/nolog DRWLAB.for;*
$	if .not.ok then emsg=emsg + " DRWLAB"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SETCON= SETCON
$	fort/nolist SETCON
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SETCON
$ 	purge/nolog SETCON.obj
$ 	delete/nolog SETCON.for;*
$	if .not.ok then emsg=emsg + " SETCON"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FLOOD= FLOOD
$	fort/nolist FLOOD
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv FLOOD
$ 	purge/nolog FLOOD.obj
$ 	delete/nolog FLOOD.for;*
$	if .not.ok then emsg=emsg + " FLOOD"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc CVTANG= CVTANG
$	fort/nolist CVTANG
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv CVTANG
$ 	purge/nolog CVTANG.obj
$ 	delete/nolog CVTANG.for;*
$	if .not.ok then emsg=emsg + " CVTANG"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc RDFANG= RDFANG
$	fort/nolist RDFANG
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv RDFANG
$ 	purge/nolog RDFANG.obj
$ 	delete/nolog RDFANG.for;*
$	if .not.ok then emsg=emsg + " RDFANG"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc READLL= READLL
$	fort/nolist READLL
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv READLL
$ 	purge/nolog READLL.obj
$ 	delete/nolog READLL.for;*
$	if .not.ok then emsg=emsg + " READLL"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc HELP= HELP
$	fort/nolist HELP
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv HELP
$ 	purge/nolog HELP.obj
$ 	delete/nolog HELP.for;*
$	if .not.ok then emsg=emsg + " HELP"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc CHECK_MODE= CHECK_MODE
$	fort/nolist CHECK_MODE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv CHECK_MODE
$ 	purge/nolog CHECK_MODE.obj
$ 	delete/nolog CHECK_MODE.for;*
$	if .not.ok then emsg=emsg + " CHECK_MODE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SETUP_BALL_TIMER= SETUP_BALL_TIMER
$	fort/nolist SETUP_BALL_TIMER
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SETUP_BALL_TIMER
$ 	purge/nolog SETUP_BALL_TIMER.obj
$ 	delete/nolog SETUP_BALL_TIMER.for;*
$	if .not.ok then emsg=emsg + " SETUP_BALL_TIMER"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc GETSTR= GETSTR
$	fort/nolist GETSTR
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv GETSTR
$ 	purge/nolog GETSTR.obj
$ 	delete/nolog GETSTR.for;*
$	if .not.ok then emsg=emsg + " GETSTR"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc OPNOUT= OPNOUT
$	fort/nolist OPNOUT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv OPNOUT
$ 	purge/nolog OPNOUT.obj
$ 	delete/nolog OPNOUT.for;*
$	if .not.ok then emsg=emsg + " OPNOUT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc CLSOUT= CLSOUT
$	fort/nolist CLSOUT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv CLSOUT
$ 	purge/nolog CLSOUT.obj
$ 	delete/nolog CLSOUT.for;*
$	if .not.ok then emsg=emsg + " CLSOUT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SINGLE_MOVE= SINGLE_MOVE
$	fort/nolist SINGLE_MOVE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SINGLE_MOVE
$ 	purge/nolog SINGLE_MOVE.obj
$ 	delete/nolog SINGLE_MOVE.for;*
$	if .not.ok then emsg=emsg + " SINGLE_MOVE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc MOVE_CURSOR= MOVE_CURSOR
$	fort/nolist MOVE_CURSOR
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv MOVE_CURSOR
$ 	purge/nolog MOVE_CURSOR.obj
$ 	delete/nolog MOVE_CURSOR.for;*
$	if .not.ok then emsg=emsg + " MOVE_CURSOR"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SET_DTI_POSITION= SET_DTI_POSITION
$	fort/nolist SET_DTI_POSITION
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SET_DTI_POSITION
$ 	purge/nolog SET_DTI_POSITION.obj
$ 	delete/nolog SET_DTI_POSITION.for;*
$	if .not.ok then emsg=emsg + " SET_DTI_POSITION"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SET_ROTATE= SET_ROTATE
$	fort/nolist SET_ROTATE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SET_ROTATE
$ 	purge/nolog SET_ROTATE.obj
$ 	delete/nolog SET_ROTATE.for;*
$	if .not.ok then emsg=emsg + " SET_ROTATE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ROVMOVE= ROVMOVE
$	fort/nolist ROVMOVE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv ROVMOVE
$ 	purge/nolog ROVMOVE.obj
$ 	delete/nolog ROVMOVE.for;*
$	if .not.ok then emsg=emsg + " ROVMOVE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc DISPLAY_EDIT= DISPLAY_EDIT
$	fort/nolist DISPLAY_EDIT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv DISPLAY_EDIT
$ 	purge/nolog DISPLAY_EDIT.obj
$ 	delete/nolog DISPLAY_EDIT.for;*
$	if .not.ok then emsg=emsg + " DISPLAY_EDIT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc EDIT= EDIT
$	fort/nolist EDIT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv EDIT
$ 	purge/nolog EDIT.obj
$ 	delete/nolog EDIT.for;*
$	if .not.ok then emsg=emsg + " EDIT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc END_EDIT= END_EDIT
$	fort/nolist END_EDIT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv END_EDIT
$ 	purge/nolog END_EDIT.obj
$ 	delete/nolog END_EDIT.for;*
$	if .not.ok then emsg=emsg + " END_EDIT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc JOIN_PIX= JOIN_PIX
$	fort/nolist JOIN_PIX
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv JOIN_PIX
$ 	purge/nolog JOIN_PIX.obj
$ 	delete/nolog JOIN_PIX.for;*
$	if .not.ok then emsg=emsg + " JOIN_PIX"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc TT_READ_NUMBER= TT_READ_NUMBER
$	fort/nolist TT_READ_NUMBER
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv TT_READ_NUMBER
$ 	purge/nolog TT_READ_NUMBER.obj
$ 	delete/nolog TT_READ_NUMBER.for;*
$	if .not.ok then emsg=emsg + " TT_READ_NUMBER"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc REPLACE_EDIT= REPLACE_EDIT
$	fort/nolist REPLACE_EDIT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv REPLACE_EDIT
$ 	purge/nolog REPLACE_EDIT.obj
$ 	delete/nolog REPLACE_EDIT.for;*
$	if .not.ok then emsg=emsg + " REPLACE_EDIT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc INIT_EDIT= INIT_EDIT
$	fort/nolist INIT_EDIT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv INIT_EDIT
$ 	purge/nolog INIT_EDIT.obj
$ 	delete/nolog INIT_EDIT.for;*
$	if .not.ok then emsg=emsg + " INIT_EDIT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc REVERSE= REVERSE
$	fort/nolist REVERSE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv REVERSE
$ 	purge/nolog REVERSE.obj
$ 	delete/nolog REVERSE.for;*
$	if .not.ok then emsg=emsg + " REVERSE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc EDITED_ALREADY= EDITED_ALREADY
$	fort/nolist EDITED_ALREADY
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv EDITED_ALREADY
$ 	purge/nolog EDITED_ALREADY.obj
$ 	delete/nolog EDITED_ALREADY.for;*
$	if .not.ok then emsg=emsg + " EDITED_ALREADY"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ROV_REMOVE= ROV_REMOVE
$	fort/nolist ROV_REMOVE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv ROV_REMOVE
$ 	purge/nolog ROV_REMOVE.obj
$ 	delete/nolog ROV_REMOVE.for;*
$	if .not.ok then emsg=emsg + " ROV_REMOVE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ROVZOOM= ROVZOOM
$	fort/nolist ROVZOOM
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv ROVZOOM
$ 	purge/nolog ROVZOOM.obj
$ 	delete/nolog ROVZOOM.for;*
$	if .not.ok then emsg=emsg + " ROVZOOM"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ZOOM= ZOOM
$	fort/nolist ZOOM
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv ZOOM
$ 	purge/nolog ZOOM.obj
$ 	delete/nolog ZOOM.for;*
$	if .not.ok then emsg=emsg + " ZOOM"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc FINISH_EDIT= FINISH_EDIT
$	fort/nolist FINISH_EDIT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv FINISH_EDIT
$ 	purge/nolog FINISH_EDIT.obj
$ 	delete/nolog FINISH_EDIT.for;*
$	if .not.ok then emsg=emsg + " FINISH_EDIT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc INTER_FLOOD= INTER_FLOOD
$	fort/nolist INTER_FLOOD
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv INTER_FLOOD
$ 	purge/nolog INTER_FLOOD.obj
$ 	delete/nolog INTER_FLOOD.for;*
$	if .not.ok then emsg=emsg + " INTER_FLOOD"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc UPDATE_HEIGHTS= UPDATE_HEIGHTS
$	fort/nolist UPDATE_HEIGHTS
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv UPDATE_HEIGHTS
$ 	purge/nolog UPDATE_HEIGHTS.obj
$ 	delete/nolog UPDATE_HEIGHTS.for;*
$	if .not.ok then emsg=emsg + " UPDATE_HEIGHTS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc RESET_PLANES= RESET_PLANES
$	fort/nolist RESET_PLANES
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv RESET_PLANES
$ 	purge/nolog RESET_PLANES.obj
$ 	delete/nolog RESET_PLANES.for;*
$	if .not.ok then emsg=emsg + " RESET_PLANES"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc START_EDIT= START_EDIT
$	fort/nolist START_EDIT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv START_EDIT
$ 	purge/nolog START_EDIT.obj
$ 	delete/nolog START_EDIT.for;*
$	if .not.ok then emsg=emsg + " START_EDIT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc READ_DTI_POSITION= READ_DTI_POSITION
$	fort/nolist READ_DTI_POSITION
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv READ_DTI_POSITION
$ 	purge/nolog READ_DTI_POSITION.obj
$ 	delete/nolog READ_DTI_POSITION.for;*
$	if .not.ok then emsg=emsg + " READ_DTI_POSITION"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc BALINIT_MOTIF= BALINIT_MOTIF
$	fort/nolist BALINIT_MOTIF
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv BALINIT_MOTIF
$ 	purge/nolog BALINIT_MOTIF.obj
$ 	delete/nolog BALINIT_MOTIF.for;*
$	if .not.ok then emsg=emsg + " BALINIT_MOTIF"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc READ_TRKB_UIS= READ_TRKB_UIS
$	fort/nolist READ_TRKB_UIS
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv READ_TRKB_UIS
$ 	purge/nolog READ_TRKB_UIS.obj
$ 	delete/nolog READ_TRKB_UIS.for;*
$	if .not.ok then emsg=emsg + " READ_TRKB_UIS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc MOUSE_MOTIF= MOUSE_MOTIF
$	fort/nolist MOUSE_MOTIF
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv MOUSE_MOTIF
$ 	purge/nolog MOUSE_MOTIF.obj
$ 	delete/nolog MOUSE_MOTIF.for;*
$	if .not.ok then emsg=emsg + " MOUSE_MOTIF"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SET_PTR_VIS_UIS= SET_PTR_VIS_UIS
$	fort/nolist SET_PTR_VIS_UIS
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SET_PTR_VIS_UIS
$ 	purge/nolog SET_PTR_VIS_UIS.obj
$ 	delete/nolog SET_PTR_VIS_UIS.for;*
$	if .not.ok then emsg=emsg + " SET_PTR_VIS_UIS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SET_TRKB_UIS= SET_TRKB_UIS
$	fort/nolist SET_TRKB_UIS
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SET_TRKB_UIS
$ 	purge/nolog SET_TRKB_UIS.obj
$ 	delete/nolog SET_TRKB_UIS.for;*
$	if .not.ok then emsg=emsg + " SET_TRKB_UIS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc GET_BUTTON_UIS= GET_BUTTON_UIS
$	fort/nolist GET_BUTTON_UIS
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv GET_BUTTON_UIS
$ 	purge/nolog GET_BUTTON_UIS.obj
$ 	delete/nolog GET_BUTTON_UIS.for;*
$	if .not.ok then emsg=emsg + " GET_BUTTON_UIS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc RESET_BALL_UIS= RESET_BALL_UIS
$	fort/nolist RESET_BALL_UIS
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv RESET_BALL_UIS
$ 	purge/nolog RESET_BALL_UIS.obj
$ 	delete/nolog RESET_BALL_UIS.for;*
$	if .not.ok then emsg=emsg + " RESET_BALL_UIS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc END_INTERP= END_INTERP
$	fort/nolist END_INTERP
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv END_INTERP
$ 	purge/nolog END_INTERP.obj
$ 	delete/nolog END_INTERP.for;*
$	if .not.ok then emsg=emsg + " END_INTERP"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc INTERP_EDIT= INTERP_EDIT
$	fort/nolist INTERP_EDIT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv INTERP_EDIT
$ 	purge/nolog INTERP_EDIT.obj
$ 	delete/nolog INTERP_EDIT.for;*
$	if .not.ok then emsg=emsg + " INTERP_EDIT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc PUT_DTI_VAL= PUT_DTI_VAL
$	fort/nolist PUT_DTI_VAL
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv PUT_DTI_VAL
$ 	purge/nolog PUT_DTI_VAL.obj
$ 	delete/nolog PUT_DTI_VAL.for;*
$	if .not.ok then emsg=emsg + " PUT_DTI_VAL"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc GET_DTI_VAL= GET_DTI_VAL
$	fort/nolist GET_DTI_VAL
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv GET_DTI_VAL
$ 	purge/nolog GET_DTI_VAL.obj
$ 	delete/nolog GET_DTI_VAL.for;*
$	if .not.ok then emsg=emsg + " GET_DTI_VAL"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc END_POLY= END_POLY
$	fort/nolist END_POLY
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv END_POLY
$ 	purge/nolog END_POLY.obj
$ 	delete/nolog END_POLY.for;*
$	if .not.ok then emsg=emsg + " END_POLY"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc POLY_EDIT= POLY_EDIT
$	fort/nolist POLY_EDIT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv POLY_EDIT
$ 	purge/nolog POLY_EDIT.obj
$ 	delete/nolog POLY_EDIT.for;*
$	if .not.ok then emsg=emsg + " POLY_EDIT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc UPDATE_STATUS= UPDATE_STATUS
$	fort/nolist UPDATE_STATUS
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv UPDATE_STATUS
$ 	purge/nolog UPDATE_STATUS.obj
$ 	delete/nolog UPDATE_STATUS.for;*
$	if .not.ok then emsg=emsg + " UPDATE_STATUS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SETUP_STATUS= SETUP_STATUS
$	fort/nolist SETUP_STATUS
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SETUP_STATUS
$ 	purge/nolog SETUP_STATUS.obj
$ 	delete/nolog SETUP_STATUS.for;*
$	if .not.ok then emsg=emsg + " SETUP_STATUS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc WRITE_VALS= WRITE_VALS
$	fort/nolist WRITE_VALS
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv WRITE_VALS
$ 	purge/nolog WRITE_VALS.obj
$ 	delete/nolog WRITE_VALS.for;*
$	if .not.ok then emsg=emsg + " WRITE_VALS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc CLEAR_STATUS= CLEAR_STATUS
$	fort/nolist CLEAR_STATUS
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv CLEAR_STATUS
$ 	purge/nolog CLEAR_STATUS.obj
$ 	delete/nolog CLEAR_STATUS.for;*
$	if .not.ok then emsg=emsg + " CLEAR_STATUS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SHOW_RCP_FILE= SHOW_RCP_FILE
$	fort/nolist SHOW_RCP_FILE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SHOW_RCP_FILE
$ 	purge/nolog SHOW_RCP_FILE.obj
$ 	delete/nolog SHOW_RCP_FILE.for;*
$	if .not.ok then emsg=emsg + " SHOW_RCP_FILE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc SELECT_RCP_FILE= SELECT_RCP_FILE
$	fort/nolist SELECT_RCP_FILE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv SELECT_RCP_FILE
$ 	purge/nolog SELECT_RCP_FILE.obj
$ 	delete/nolog SELECT_RCP_FILE.for;*
$	if .not.ok then emsg=emsg + " SELECT_RCP_FILE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc CLOSE_RCP_FILE= CLOSE_RCP_FILE
$	fort/nolist CLOSE_RCP_FILE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv CLOSE_RCP_FILE
$ 	purge/nolog CLOSE_RCP_FILE.obj
$ 	delete/nolog CLOSE_RCP_FILE.for;*
$	if .not.ok then emsg=emsg + " CLOSE_RCP_FILE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc BEGIN_REGISTRATION= BEGIN_REGISTRATION
$	fort/nolist BEGIN_REGISTRATION
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv BEGIN_REGISTRATION
$ 	purge/nolog BEGIN_REGISTRATION.obj
$ 	delete/nolog BEGIN_REGISTRATION.for;*
$	if .not.ok then emsg=emsg + " BEGIN_REGISTRATION"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc OPEN_RCP_FILE= OPEN_RCP_FILE
$	fort/nolist OPEN_RCP_FILE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv OPEN_RCP_FILE
$ 	purge/nolog OPEN_RCP_FILE.obj
$ 	delete/nolog OPEN_RCP_FILE.for;*
$	if .not.ok then emsg=emsg + " OPEN_RCP_FILE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc CREATE_RCP_FILE= CREATE_RCP_FILE
$	fort/nolist CREATE_RCP_FILE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv CREATE_RCP_FILE
$ 	purge/nolog CREATE_RCP_FILE.obj
$ 	delete/nolog CREATE_RCP_FILE.for;*
$	if .not.ok then emsg=emsg + " CREATE_RCP_FILE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc READ_RCP_FILE= READ_RCP_FILE
$	fort/nolist READ_RCP_FILE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv READ_RCP_FILE
$ 	purge/nolog READ_RCP_FILE.obj
$ 	delete/nolog READ_RCP_FILE.for;*
$	if .not.ok then emsg=emsg + " READ_RCP_FILE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc WRITE_RCP_FILE= WRITE_RCP_FILE
$	fort/nolist WRITE_RCP_FILE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv WRITE_RCP_FILE
$ 	purge/nolog WRITE_RCP_FILE.obj
$ 	delete/nolog WRITE_RCP_FILE.for;*
$	if .not.ok then emsg=emsg + " WRITE_RCP_FILE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc END_REGISTRATION= END_REGISTRATION
$	fort/nolist END_REGISTRATION
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv END_REGISTRATION
$ 	purge/nolog END_REGISTRATION.obj
$ 	delete/nolog END_REGISTRATION.for;*
$	if .not.ok then emsg=emsg + " END_REGISTRATION"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc GET_FREE_AND_BASE= GET_FREE_AND_BASE
$	fort/nolist GET_FREE_AND_BASE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv GET_FREE_AND_BASE
$ 	purge/nolog GET_FREE_AND_BASE.obj
$ 	delete/nolog GET_FREE_AND_BASE.for;*
$	if .not.ok then emsg=emsg + " GET_FREE_AND_BASE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc GET_LS_LIN_TRANSF= GET_LS_LIN_TRANSF
$	fort/nolist GET_LS_LIN_TRANSF
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv GET_LS_LIN_TRANSF
$ 	purge/nolog GET_LS_LIN_TRANSF.obj
$ 	delete/nolog GET_LS_LIN_TRANSF.for;*
$	if .not.ok then emsg=emsg + " GET_LS_LIN_TRANSF"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc RCP_COMMAND= RCP_COMMAND
$	fort/nolist RCP_COMMAND
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv RCP_COMMAND
$ 	purge/nolog RCP_COMMAND.obj
$ 	delete/nolog RCP_COMMAND.for;*
$	if .not.ok then emsg=emsg + " RCP_COMMAND"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc RCP_ADD= RCP_ADD
$	fort/nolist RCP_ADD
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv RCP_ADD
$ 	purge/nolog RCP_ADD.obj
$ 	delete/nolog RCP_ADD.for;*
$	if .not.ok then emsg=emsg + " RCP_ADD"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc RCP_DELETE= RCP_DELETE
$	fort/nolist RCP_DELETE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv RCP_DELETE
$ 	purge/nolog RCP_DELETE.obj
$ 	delete/nolog RCP_DELETE.for;*
$	if .not.ok then emsg=emsg + " RCP_DELETE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc RCP_EDIT= RCP_EDIT
$	fort/nolist RCP_EDIT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv RCP_EDIT
$ 	purge/nolog RCP_EDIT.obj
$ 	delete/nolog RCP_EDIT.for;*
$	if .not.ok then emsg=emsg + " RCP_EDIT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc RCP_MOVE= RCP_MOVE
$	fort/nolist RCP_MOVE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv RCP_MOVE
$ 	purge/nolog RCP_MOVE.obj
$ 	delete/nolog RCP_MOVE.for;*
$	if .not.ok then emsg=emsg + " RCP_MOVE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc RCP_SET_DEFAULT= RCP_SET_DEFAULT
$	fort/nolist RCP_SET_DEFAULT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv RCP_SET_DEFAULT
$ 	purge/nolog RCP_SET_DEFAULT.obj
$ 	delete/nolog RCP_SET_DEFAULT.for;*
$	if .not.ok then emsg=emsg + " RCP_SET_DEFAULT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc RCP_ENABLE_DEFAULT= RCP_ENABLE_DEFAULT
$	fort/nolist RCP_ENABLE_DEFAULT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv RCP_ENABLE_DEFAULT
$ 	purge/nolog RCP_ENABLE_DEFAULT.obj
$ 	delete/nolog RCP_ENABLE_DEFAULT.for;*
$	if .not.ok then emsg=emsg + " RCP_ENABLE_DEFAULT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc RCP_CHECK_ID= RCP_CHECK_ID
$	fort/nolist RCP_CHECK_ID
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv RCP_CHECK_ID
$ 	purge/nolog RCP_CHECK_ID.obj
$ 	delete/nolog RCP_CHECK_ID.for;*
$	if .not.ok then emsg=emsg + " RCP_CHECK_ID"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc RCP_CONVERT_FROM_MOUSE= RCP_CONVERT_FROM_MOUSE
$	fort/nolist RCP_CONVERT_FROM_MOUSE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv RCP_CONVERT_FROM_MOUSE
$ 	purge/nolog RCP_CONVERT_FROM_MOUSE.obj
$ 	delete/nolog RCP_CONVERT_FROM_MOUSE.for;*
$	if .not.ok then emsg=emsg + " RCP_CONVERT_FROM_MOUSE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc RCP_CONVERT_TO_MOUSE= RCP_CONVERT_TO_MOUSE
$	fort/nolist RCP_CONVERT_TO_MOUSE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv RCP_CONVERT_TO_MOUSE
$ 	purge/nolog RCP_CONVERT_TO_MOUSE.obj
$ 	delete/nolog RCP_CONVERT_TO_MOUSE.for;*
$	if .not.ok then emsg=emsg + " RCP_CONVERT_TO_MOUSE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc MATRIX_POINT_FIVE= MATRIX_POINT_FIVE
$	fort/nolist MATRIX_POINT_FIVE
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv MATRIX_POINT_FIVE
$ 	purge/nolog MATRIX_POINT_FIVE.obj
$ 	delete/nolog MATRIX_POINT_FIVE.for;*
$	if .not.ok then emsg=emsg + " MATRIX_POINT_FIVE"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ROVRESP= ROVRESP
$	fort/nolist ROVRESP
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv ROVRESP
$ 	purge/nolog ROVRESP.obj
$ 	delete/nolog ROVRESP.for;*
$	if .not.ok then emsg=emsg + " ROVRESP"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ROVAT= ROVAT
$	fort/nolist ROVAT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv ROVAT
$ 	purge/nolog ROVAT.obj
$ 	delete/nolog ROVAT.for;*
$	if .not.ok then emsg=emsg + " ROVAT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ROVMESS= ROVMESS
$	fort/nolist ROVMESS
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv ROVMESS
$ 	purge/nolog ROVMESS.obj
$ 	delete/nolog ROVMESS.for;*
$	if .not.ok then emsg=emsg + " ROVMESS"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ROVCONT= ROVCONT
$	fort/nolist ROVCONT
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv ROVCONT
$ 	purge/nolog ROVCONT.obj
$ 	delete/nolog ROVCONT.for;*
$	if .not.ok then emsg=emsg + " ROVCONT"
$ 	delete adc.ide;*
$ 	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc ROVPING= ROVPING
$	fort/nolist ROVPING
$ 	ok=$status
$	lis = "" 
$ 	if ok then pvv ROVPING
$ 	purge/nolog ROVPING.obj
$ 	delete/nolog ROVPING.for;*
$	if .not.ok then emsg=emsg + " ROVPING"
$ 	delete adc.ide;*
$	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$	macro/nolist/object=rover_mar rover + lsl$library:lslmaclib/lib
$ 	ok=$status
$	purge/nolog rover_mar.obj
$	if .not.ok then emsg=emsg + " rover_mar"
$! 
$	macro/nolist/object=efwm efwm+ lsl$library:lslmaclib/lib
$ 	ok=$status
$	purge/nolog efwm.obj
$	if .not.ok then emsg=emsg + " efwm"
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
$	run lsl$exe:genver
$	adc version=version
$	fort/nolist version
$	pvv version
$	delete adc.ide;*,version.for;*
$	purge version.*
$ 	link/map/debug/map=rovermotif/exe=rovermotif -
	rovercommon/opt, here:rovermotif/opt,-
	version,lsl$tvessys:tves_service/lib,-
	lsl$library:lslshr/opt,iffshr/opt,frtshr/opt,dtishr/opt
$	mapid rovermotif
$!
$   delete/nolog *.map;*
$   purge/nolog *.mapid
$xx250:
$abort1:
$ 	deass/group lsl$rover_building
$ 	set noverify
