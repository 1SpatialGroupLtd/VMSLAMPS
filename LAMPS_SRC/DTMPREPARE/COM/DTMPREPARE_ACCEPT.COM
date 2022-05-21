$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-23 17:17:48.000000000 +0100
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
$	ver_status=f$verify(0)
$!
$! LAMPS package "DTMPREPARE" acceptance test command procedure.
$!
$! Authors						ALB 26-May-1988
$!							ACM 30-Jan-1989
$! Amendments
$!		In presponse to SPR 960, to ensure that the status flag
$!		is set from the Program and not the DCL "set verify"
$!							RWH  8-Nov-1990
$!
$!		Set LITES2INI at each call of lites2 	 JB 23-Aug-1993
$!
$! Set things up
$!
$	ws="write sys$output"
$	wl="write lcmfil"
$	esc[0,7]=27
$	bel[0,7]=7
$	b_on = esc+"[0m"+esc+"[1m" 	! bold on
$	clr_src = esc+"[2J" 		! clear screen
$	b_of = esc+"[0m"		! bold off
$ 	bell = bel+bel			! ding ding
$	vt100_ok=1			! assume VT100
$!
$! If we have a non VT100 terminal then switch off bolding etc...
$!
$	if f$getdvi("TT:","TT_ANSICRT") then goto lets_go
$	b_on = ""	 	! bold on
$	b_of = ""		! bold off
$ 	bell = ""		! no ding ding
$	vt100_ok=0		! not VT100
$!
$!***************************************************************************
$lets_go:
$!
$ ws "''b_on'"
$ ws "============================================================"
$ ws "============          Laser-Scan  Ltd.          ============"
$ ws "============      LAMPS package DTMPREPARE      ============"
$ ws "============  Acceptance test command procedure ============"
$ ws "============================================================"
$	date_time=f$time()
$ ws "============  Starting ''date_time'  ============"
$ ws "============================================================"
$ ws " "
$ ws "''b_of'"
$ ws " "
$	gosub go_on
$!
$!***************************************************************************
$!
$! Defining the package symbols and setting up logical names.
$!
$	ws "... Initialising the package and checking environment"
$	ws " "
$	revlevel_set = ""
$	old_revlevel = ""
$!
$! Set up for clean exit if error or control y
$!
$	on error then goto prepare_to_exit
$	on control_y then goto prepare_to_exit
$!
$	if f$type(I3D).eqs."" then @lsl$com:dtmprepareini 
$	if f$trnlnm("LSL$LITES2CMD").eqs."" then @lsl$com:lites2ini
$	if f$trnlnm("LSL$IFF_OUTPUT_REVISION").eqs."" then goto set_revlevel
$	if f$trnlnm("LSL$IFF_OUTPUT_REVISION").eqs."1" then goto revlevel_ok
$!
$	old_revlevel = f$trnlnm("LSL$IFF_OUTPUT_REVISION")
$	Define LSL$IFF_OUTPUT_REVISION 1
$	goto revlevel_ok
$!
$set_revlevel: 
$!
$	revlevel_set = "T"
$	Define LSL$IFF_OUTPUT_REVISION 1
$!
$revlevel_ok: 
$!
$!	set noon
$!
$	define LSL$DTMPREPARE_ACCEPT	LSL$PUBLIC_ROOT:[DTMPREPARE.ACCEPT]	
$	frt_file="LSL$DTMPREPARE_ACCEPT:DTMPREPARE_ACCEPT.FRT"
$	sri_file="LSL$DTMPREPARE_ACCEPT:DTMPREPARE_ACCEPT.SRI"
$	tri_file="LSL$DTMPREPARE_ACCEPT:DTMPREPARE_ACCEPT.TRI"
$!
$! Check the input acceptance test files exist
$!
$	in_file="LSL$DTMPREPARE_ACCEPT:DTMPREPARE_ACCEPT.IFF"
$	out_file="LSL$IF:DTMPREPARE_ACCEPT.IFF"
$	gosub check_file
$	itcheck_file=out_file
$!
$! Make copy of unheighted river/ridge file
$	in_file="LSL$DTMPREPARE_ACCEPT:DTMPREPARE_ACCEPT_I3D.START_IFF"
$	out_file="LSL$IF:DTMPREPARE_ACCEPT_I3D_START.IFF"
$	gosub check_file
$	i3d_start_file=out_file
$!
$! Make copy of after-editing intersected river/ridge file
$	in_file="LSL$DTMPREPARE_ACCEPT:DTMPREPARE_ACCEPT_I3D.INTERSECTED2_IFF"
$	out_file="LSL$IF:DTMPREPARE_ACCEPT_I3D_INTERSECTED2.IFF"
$	gosub check_file
$	i3d_intersected_file2=out_file
$!
$! Make copy of terrain file
$	in_file="LSL$DTMPREPARE_ACCEPT:DTMPREPARE_ACCEPT_I3D.TERRAIN_IFF"
$	out_file="LSL$IF:DTMPREPARE_ACCEPT_I3D_TERRAIN.IFF"
$	gosub check_file
$	i3d_terrain_file=out_file
$!
$! Note names of files yet to be generated
$	i3d_intersected_file1="LSL$IF:DTMPREPARE_ACCEPT_I3D_INTERSECTED1.IFF"
$	i3d_interpolated_file="LSL$IF:DTMPREPARE_ACCEPT_I3D_INTERPOLATED.IFF"
$	i3d_checkplot_file   ="LSL$IF:DTMPREPARE_ACCEPT_I3D_CHECKPLOT.IFF"
$!
$	ws " "
$	ws "... Initialisation and environment checks complete"
$	ws " "
$	gosub go_on
$	ws " "
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	type Sys$input:

The acceptance tests for DTMPREPARE are in two parts.
The first is for module ITCHECK, the terrain checking utility,
the second is for I3D the river/ridgeline heighting utility.

$	ws " "
$	inquire yes "Do you want to skip ITCHECK and go direct to I3D ?  "
$	if yes then goto do_i3d
$	ws " "
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ 	ws " "
$ 	ws "''b_on'                ITCHECK''b_of'"
$ 	ws " "
$	type Sys$input:

In these tests the original data contains a number of errors commonly found in
IFF files after initial digitising. The purpose of ITCHECK is to scan this IFF
to identify these errors.  The acceptance procedure runs ITCHECK 6 times with a
different checking procedure in each run.  Finally, these errors are displayed
using the LITES2 Cartographic Editor and a LITES2 command file generated for
each ITCHECK run. Errors such as missing contours are only recorded in the
Error Tabulation file. 


	(1) CHECK 1 - contours in range, divisible by contour interval etc.
	(2) CHECK 2 - item within boundary, etc.
	(3) CHECK 3 - touching or crossing features
	(4) CHECK 4 - validity of heights of neighbouring items
	(5) CHECK 5 - loops, duplicate points etc.
	(6) CHECK 6 - spot height and neighbouring contour heights

$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Use LITES2 to show the source data
$!
$!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
$!
$!	ws " "
$	inquire/nopunc use_lites2 "Do you want to use LITES2 to examine the input IFF file ?  "
$	if .not.use_lites2 then goto skip_lites_a
$!
$	if f$type(lites2).eqs."" then @lsl$com:lites2ini
$	ass/user sys$command sys$input
$	lites2 frt lsl$public_root:[dtmprepare.accept]dtmprepare_accept#scale fac 1#disable table#iff 'itcheck_file'
$!
$!	gosub go_on
$!
$skip_lites_a:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ ws " "
$ ws "''b_on'"
$ ws "DTMPREPARE package module ITCHECK tests"
$ ws "''b_of'"
$ ws "ITCHECK is used 6 times, the current task is shown in ''b_on'bold''b_of':"
$ ws " "
$ ws b_on,-
     "           (1) CHECK 1 - contours in range, divisible by contour interval etc.''b_of'"
$ ws "           (2) CHECK 2 - item within boundary, etc."
$ ws "           (3) CHECK 3 - touching or crossing features"
$ ws "           (4) CHECK 4 - validity of heights of neighbouring items"
$ ws "           (5) CHECK 5 - loops, duplicate points etc."
$ ws "           (6) CHECK 6 - spot height and neighbouring contour heights"
$ ws "''b_on' "
$ ws "The input file is  ''itcheck_file' "
$ ws "''b_of'"
$!
$	gosub go_on
$!
$	set verify
$!
$	itcheck
lookup lsl$public_root:[dtmprepare.accept]dtmprepare_accept.dat
iff dtmprepare_accept.iff
lites dtmprepare_accept1.lcm
list dtmprepare_accept1.lis
contour_interval = 10
index_interval = 50
supplementary_interval = 2
zlimits 10 190
check 1
go
exit
$	dcl_status = $status	! 'f$verify(0)
$	gosub chk_status
$!
$	check_no = "1"
$	gosub end_check
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ ws " "
$ ws "''b_on'"
$ ws "DTMPREPARE package module ITCHECK tests"
$ ws "''b_of'"
$ ws "ITCHECK is used 6 times, the current task is shown in ''b_on'bold''b_of':"
$ ws " "
$ ws "           (1) CHECK 1 - contours in range, divisible by contour interval etc."
$ ws b_on,-
     "           (2) CHECK 2 - item within boundary, etc.''b_of'"
$ ws "           (3) CHECK 3 - touching or crossing features"
$ ws "           (4) CHECK 4 - validity of heights of neighbouring items"
$ ws "           (5) CHECK 5 - loops, duplicate points etc."
$ ws "           (6) CHECK 6 - spot height and neighbouring contour heights"
$ ws "''b_on' "
$ ws "The input file is  ''itcheck_file' "
$ ws "''b_of'"
$!
$	gosub go_on
$!
$	set verify
$!
$	itcheck
lookup lsl$public_root:[dtmprepare.accept]dtmprepare_accept.dat
iff dtmprepare_accept.iff
lites lsl$lites2cmd:dtmprepare_accept2.lcm
list dtmprepare_accept2.lis
tolerance border 1
tolerance minimum 1
tolerance maximum 5
check 2
go
exit
$	dcl_status = $status	! 'f$verify(0)
$	gosub chk_status
$!
$	check_no = "2"
$	gosub end_check
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ ws " "
$ ws "''b_on'"
$ ws "DTMPREPARE package module ITCHECK tests"
$ ws "''b_of'"
$ ws "ITCHECK is used 6 times, the current task is shown in ''b_on'bold''b_of':"
$ ws " "
$ ws "           (1) CHECK 1 - contours in range, divisible by contour interval etc."
$ ws "           (2) CHECK 2 - item within boundary, etc."
$ ws b_on,- 
     "           (3) CHECK 3 - touching or crossing features''b_of'"
$ ws "           (4) CHECK 4 - validity of heights of neighbouring items"
$ ws "           (5) CHECK 5 - loops, duplicate points etc."
$ ws "           (6) CHECK 6 - spot height and neighbouring contour heights"
$ ws "''b_on' "
$ ws "The input file is  ''itcheck_file' "
$ ws "''b_of'"
$!
$	gosub go_on
$!
$	set verify
$!
$	itcheck
lookup lsl$public_root:[dtmprepare.accept]dtmprepare_accept.dat
iff dtmprepare_accept.iff
lites lsl$lites2cmd:dtmprepare_accept3.lcm
list dtmprepare_accept3.lis
check 3
go
exit
$	dcl_status = $status	! 'f$verify(0)
$	gosub chk_status
$!
$	check_no = "3"
$	gosub end_check
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ ws " "
$ ws "''b_on'"
$ ws "DTMPREPARE package module ITCHECK tests"
$ ws "''b_of'"
$ ws "ITCHECK is used 6 times, the current task is shown in ''b_on'bold''b_of':"
$ ws " "
$ ws "           (1) CHECK 1 - contours in range, divisible by contour interval etc."
$ ws "           (2) CHECK 2 - item within boundary, etc."
$ ws "           (3) CHECK 3 - touching or crossing features"
$ ws b_on,-
     "           (4) CHECK 4 - validity of heights of neighbouring items''b_of'"
$ ws "           (5) CHECK 5 - loops, duplicate points etc."
$ ws "           (6) CHECK 6 - spot height and neighbouring contour heights"
$ ws "''b_on' "
$ ws "The input file is  ''itcheck_file' "
$ ws "''b_of'"
$!
$	gosub go_on
$!
$	set verify
$!
$	itcheck
lookup lsl$public_root:[dtmprepare.accept]dtmprepare_accept.dat
iff dtmprepare_accept.iff
lites lsl$lites2cmd:dtmprepare_accept4.lcm
list dtmprepare_accept4.lis
check 4
contour_interval 10
profile_interval 5
go
exit
$	dcl_status = $status	! 'f$verify(0)
$	gosub chk_status
$!
$	check_no = "4"
$	gosub end_check
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ ws " "
$ ws "''b_on'"
$ ws "DTMPREPARE package module ITCHECK tests"
$ ws "''b_of'"
$ ws "ITCHECK is used 6 times, the current task is shown in ''b_on'bold''b_of':"
$ ws " "
$ ws "           (1) CHECK 1 - contours in range, divisible by contour interval etc."
$ ws "           (2) CHECK 2 - item within boundary, etc."
$ ws "           (3) CHECK 3 - touching or crossing features"
$ ws "           (4) CHECK 4 - validity of heights of neighbouring items"
$ ws b_on,-
     "           (5) CHECK 5 - loops, duplicate points etc.''b_of'"
$ ws "           (6) CHECK 6 - spot height and neighbouring contour heights"
$ ws "''b_on' "
$ ws "The input file is  ''itcheck_file' "
$ ws "''b_of'"
$!
$	gosub go_on
$!
$	set verify
$!
$	itcheck
lookup lsl$public_root:[dtmprepare.accept]dtmprepare_accept.dat
iff dtmprepare_accept.iff
lites lsl$lites2cmd:dtmprepare_accept5.lcm
list dtmprepare_accept5.lis
check 5
go
exit
$	dcl_status = $status	! 'f$verify(0)
$	gosub chk_status
$!
$	check_no = "5"
$	gosub end_check
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ ws " "
$ ws "''b_on'"
$ ws "DTMPREPARE package module ITCHECK tests"
$ ws "''b_of'"
$ ws "ITCHECK is used 6 times, the current task is shown in ''b_on'bold''b_of':"
$ ws " "
$ ws "           (1) CHECK 1 - contours in range, divisible by contour interval etc."
$ ws "           (2) CHECK 2 - item within boundary, etc."
$ ws "           (3) CHECK 3 - touching or crossing features"
$ ws "           (4) CHECK 4 - validity of heights of neighbouring items"
$ ws "           (5) CHECK 5 - loops, duplicate points etc."
$ ws b_on,-
     "           (6) CHECK 6 - spot height and neighbouring contour heights''b_of'"
$ ws "''b_on' "
$ ws "The input file is  ''itcheck_file' "
$ ws "''b_of'"
$!
$	gosub go_on
$!
$	set verify
$!
$	itcheck
lookup lsl$public_root:[dtmprepare.accept]dtmprepare_accept.dat
iff dtmprepare_accept.iff
lites lsl$lites2cmd:dtmprepare_accept6.lcm
list dtmprepare_accept6.lis
check 6
contour_interval 10
go
exit
$	dcl_status = $status	! 'f$verify(0)
$	gosub chk_status
$!
$	check_no = "6"
$	gosub end_check
$! 
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	check_no = "1"
$	gosub lites_look
$	check_no = "2"
$	gosub lites_look
$	check_no = "3"
$	gosub lites_look
$	check_no = "4"
$	gosub lites_look
$	check_no = "5"
$	gosub lites_look
$	check_no = "6"
$	gosub lites_look
$! 
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$!	************** I3D ***************
$do_i3d:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!	
$!
$ 	ws " "
$ 	ws "''b_on'                I3D''b_of'"
$ 	ws " "
$ 	type sys$input:

This utility is used to provide height control for terrain modelling.
It produces three dimensional river and ridge strings by intersecting
the digitised rivers and ridges with the contours and spot heights.

The heighting process involves at least two passes through the I3D module.  The
first pass uses the terrain data to insert heighted terrain intersection points
into river/ridge strings. The second pass first attempts to find a consistent
flow through the river/ridge network and height all river/ridge nodes. If this
is successful it will then go on to interpolate a height for each river/ridge
vertex and produce fully height interpolated 3D output IFF files. Otherwise
extra node heights must be edited into the intersected river/ridge data, before
repeating stage two again. 

$!
$	gosub go_on
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Use LITES2 to show the source data
$!
$!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
$!
$	ws " "
$	inquire/nopunc use_lites2 "Do you want to use LITES2 to examine the original IFF files ?  " 
$	if .not.use_lites2 then goto skip_lites_aa
$!
$! Create LITES2 command file lsl$lites2cmd:temp.lcm to take LITES2 commands
$!
$	open/write lcmfil lsl$lites2cmd:temp.lcm
$	wl "frt lsl$public_root:[dtmprepare.accept]dtmprepare_accept"
$	wl "scale fac1"
$	wl "disable table"
$	wl "maps 2"
$	wl "iff ''i3d_terrain_file'"
$	wl "iff ''i3d_start_file'"
$	close lcmfil
$!
$	if f$type(lites2).eqs."" then @lsl$com:lites2ini 
$ 	ass/user sys$command sys$input
$ 	lites2 @temp
$	delete/nolog/noconf lsl$lites2cmd:temp.lcm;*
$!
$	gosub go_on
$!
$skip_lites_aa:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$!	Use I3D to insert heighted terrain intersection points into the
$!	river/ridgeline network"
$!
$!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
$ 	ws " "
$ 	ws "First pass through I3D to insert heighted terrain intersection points in to the"
$	ws "river/ridgeline network"
$ 	ws " "
$!
$	set verify
$!
$	i3d
lookup lsl$public_root:[dtmprepare.accept]dtmprepare_accept.dat
filein dtmprepare_accept_i3d_start.iff
terrain dtmprepare_accept_i3d_terrain.iff
fileout dtmprepare_accept_i3d_intersected1.iff
set touch_tolerance 10
enable mode intersect
go
$	dcl_status = $status	! 'f$verify(0)
$	gosub chk_status
$!
$	ws " "
$	gosub go_on
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Use LITES2 to show the source data with extra heights added
$!
$!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
$!
$	ws " "
$	inquire/nopunc use_lites2 "Do you want to use LITES2 to examine the IFF files with heighted terrain intersection points added?  "
$	if .not.use_lites2 then goto skip_lites_cc
$!
$! Create LITES2 command file lsl$lites2cmd:temp.lcm to take LITES2 commands
$!
$	open/write lcmfil lsl$lites2cmd:temp.lcm
$	wl "frt lsl$public_root:[dtmprepare.accept]dtmprepare_accept"
$	wl "scale fac1"
$	wl "disable table"
$	wl "maps 2"
$	wl "iff ''i3d_terrain_file'"
$	wl "iff ''i3d_intersected_file1'"
$	close lcmfil
$!
$	if f$type(lites2).eqs."" then @lsl$com:lites2ini 
$ 	ass/user sys$command sys$input
$ 	lites2 @temp
$	delete/nolog/noconf lsl$lites2cmd:temp.lcm;*
$!
$	gosub go_on
$!
$skip_lites_cc:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$!	Use I3D to try to height all selected river and ridgeline data
$!
$!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
$!
$	ws " "
$ 	ws "Second pass through I3D to try to height all selected river and ridgeline data"
$ 	ws " "
$!
$	set verify
$!
$	i3d
lookup lsl$public_root:[dtmprepare.accept]dtmprepare_accept.dat
filein dtmprepare_accept_i3d_intersected1.iff
!fileout dtmprepare_accept_i3d_interpolated.iff
checkplot dtmprepare_accept_i3d_checkplot.iff
lites lsl$lites2cmd:dtmprepare_accept_i3d_heightnodes.lcm
enable mode flow
set symbol_scale 0.5
set arrow_fc 101
set box_fc 102
set max_interval 70.0
set clip_tolerance 150
go
$	dcl_status = $status	! 'f$verify(0)
$	gosub chk_status
$!
$	ws " "
$	gosub go_on
$!
$	ws " "
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Use LITES2 to let the user have a go at node height editing
$!
$!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
$!
$	ws " "
$	ws "I3D has found several nodes for which a height could not be determined,"
$	ws "and several river terminal links for which a direction could not be"
$	ws "determined automatically."
$	inquire/nopunc use_lites2 "Do you want to use LITES2 to have a go at editing in the required node heights?"
$	ws " "
$	if .not.use_lites2 then goto skip_lites_bb
$!	ws "''clr_scr'"
$ 	ws " "
$ 	ws "The LITES2 cartographic editor is being invoked. "
$ 	ws " "
$ 	ws "Before starting LITES2 command file, move VT2xx window outside of the data area. "
$ 	ws " "
$ 	ws "You will be prompted to supply a height for each node which could not be"
$	ws "heighted automatically by I3D. "
$ 	ws " "
$ 	ws "To escape from LITES2 command file press: ''b_on' <CTRL/C> ''b_of'"
$ 	ws " "
$ 	ws " "
$!
$	gosub go_on
$!
$! Create LITES2 command file lsl$lites2cmd:temp.lcm to take LITES2 commands
$!
$	open/write lcmfil lsl$lites2cmd:temp.lcm
$	wl "frt lsl$public_root:[dtmprepare.accept]dtmprepare_accept"
$	wl "scale fac1"
$	wl "disable table"
$	wl "maps 3"
$	wl "iff ''i3d_terrain_file'"
$	wl "iff ''i3d_intersected_file1'"
$	wl "iff ''i3d_checkplot_file'"
$	wl "@dtmprepare_accept_i3d_heightnodes"
$	close lcmfil
$!
$	if f$type(lites2).eqs."" then @lsl$com:lites2ini 
$ 	ass/user sys$command sys$input
$ 	lites2 @temp
$	delete/nolog/noconf lsl$lites2cmd:temp.lcm;*
$!
$	gosub go_on
$!
$skip_lites_bb:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$!	Use I3D to try again to height all selected river and ridgeline data
$!
$!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
$!
$	ws " "
$ 	ws "Third pass through I3D to try again to height all selected river and ridgeline data"
$ 	ws " "
$!
$	set verify
$!
$	i3d
lookup lsl$public_root:[dtmprepare.accept]dtmprepare_accept.dat
filein dtmprepare_accept_i3d_intersected2.iff
fileout dtmprepare_accept_i3d_interpolated.iff
checkplot dtmprepare_accept_i3d_checkplot.iff
lites lsl$lites2cmd:dtmprepare_accept_i3d_heightnodes.lcm
enable diagnostics
enable mode interpolate
set symbol_scale 0.5
set arrow_fc 101
set box_fc 102
set max_interval 70.0
set clip_tolerance 150
go
$	dcl_status = $status	! 'f$verify(0)
$	gosub chk_status
$!
$	ws " "
$	gosub go_on
$!
$	ws " "
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Use LITES2 to show height interpolated network
$!
$!::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
$!
$	ws " "
$	inquire/nopunc use_lites2 "Do you want to use LITES2 to see the results of I3D heighting process ?  "
$	if .not.use_lites2 then goto skip_lites_dd
$!	ws "''clr_scr'"
$ 	ws " "
$ 	ws "The LITES2 cartographic editor is being invoked. "
$ 	ws " "
$ 	ws "You can examine height attribute for any river or ridgeline feature. "
$ 	ws " "
$ 	ws "Note: features with fc = 8 were not heighted.  This is due to the FC "
$ 	ws "not being included in the group definition table (LOOKUP file). "
$ 	ws " "
$	ws " "
$	gosub go_on
$!
$	ws " "
$!
$! Create LITES2 command file lsl$lites2cmd:temp.lcm to take LITES2 commands
$!
$	open/write lcmfil lsl$lites2cmd:temp.lcm
$	wl "frt lsl$public_root:[dtmprepare.accept]dtmprepare_accept"
$	wl "scale fac1"
$	wl "disable table"
$	wl "maps 3"
$	wl "iff ''i3d_terrain_file'"
$	wl "iff ''i3d_interpolated_file'"
$	wl "iff ''i3d_checkplot_file'"
$	close lcmfil
$!
$	if f$type(lites2).eqs."" then @lsl$com:lites2ini 
$ 	ass/user sys$command sys$input
$ 	lites2 @temp
$	delete/nolog/noconf lsl$lites2cmd:temp.lcm;*
$!
$	gosub go_on
$!
$skip_lites_dd:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ ws "''b_on'"
$ ws "============================================================"
$ ws "============          Laser-Scan  Ltd.           ==========="
$ ws "============     LAMPS package "DTMPREPARE"      ==========="
$ ws "============  Acceptance test command procedure  ==========="
$ ws "============================================================"
$ date_time=f$time()
$ ws "============  Completed ''date_time' ============"
$ ws "============================================================"
$ ws " "
$ ws "''b_of'"
$ ws " "
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$prepare_to_exit:
$	set noon
$	ws "... Tidying up, please ignore any warning messages"
$	purge/nolog lsl$if:dtmprepare_accept_i3d_*.*
$	purge/nolog lsl$lites2cmd:dtmprepare_accept*.*
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$tidy_exit:
$	set control=y
$!
$	if old_revlevel.eqs."" then goto no_reset_revlevel
$	define LSL$IFF_OUTPUT_REVISION 'old_revlevel'
$!
$no_reset_revlevel: 
$!
$	if revlevel_set.eqs."t" then deassign LSL$IFF_OUTPUT_REVISION
$	deassign LSL$DTMPREPARE_ACCEPT	
$!
$	exit
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!	SUBROUTINES
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Subroutine chk_status
$!
$ chk_status:
$	ws " "
$	ws "Return $STATUS was ''f$message(dcl_status)'"
$	return
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Subroutine go_on
$!
$ go_on:
$ 	ws " "
$	inquire/nopunc continue - 
	"Press ''b_on'<RETURN> ''b_of'to continue "
$ 	ws " "
$	return
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Subroutine check_file
$!
$check_file:	! subroutine to check input files
$!
$	if f$search(in_file) .nes. "" then goto file_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''in_file'"
$	ws " "
$	goto tidy_exit
$!
$file_ok:
$	ws " "
$	ws "... Input test data IFF file successfully found"
$	ws "... Input file was ''in_file'"
$	ws "... Copying it to working LSL$IF directory"
$!
$! Create a file ".IFF" for manipulation during the tests
$!
$	copy/noconfirm 'in_file' 'out_file'
$	if $status then goto ifdir_ok
$	ws " ''bell'"
$	ws "Failed to copy initial file to LSL$IF:, tests abandoned."
$	ws "Input file was ''in_file'"
$	ws "Output was to ''out_file'"
$	ws " "
$	goto tidy_exit
$ifdir_ok:
$	search_file=f$search(out_file)
$	if $status then goto out_file_ok
$	ws " ''bell'"
$	ws "Failed to find copied file in LSL$IF:, tests abandoned."
$	ws "File was ''out_file'"
$	ws " "
$	goto tidy_exit
$out_file_ok:
$	ws "... Copied data file successfully found"
$	ws "... File was ''out_file'"
$	ws " "
$	return
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Subroutine end_check
$!
$ end_check:
$ ws "''b_on'"
$ ws " "
$ ws " "
$ ws "============================================================"
$ ws "============                                    ============"
$ ws "============    CHECK  ''check_no' complete               ============"
$ ws "============                                    ============"
$ ws "============================================================"
$ ws " "
$ ws "''b_of'"
$ ws " "
$ ws " "
$ ws " "
$	inquire/nopunc yes -
 "''r_on'Do you want the Tabulated Errors file and LITES2 command file printed ?  ''r_off'"
$	if .not.yes then goto skip_print
$	print dtmprepare_accept'check_no'.lis
$	print lsl$lites2cmd:dtmprepare_accept'check_no'.lcm
$!
$skip_print:
$	return
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Subroutine lites_look
$!
$lites_look:
$	ws " "
$	inquire/nopunc yes -
 "Do you want to use LITES2 to examine the errors found in CHECK ''check_no' ?  "
$	if .not.yes then goto skip_lites
$!
$	if f$type(lites2).eqs."" then @lsl$com:lites2ini 
$ 	ass/user sys$command sys$input
$	lites2 frt lsl$public_root:[dtmprepare.accept]dtmprepare_accept#scale fac 1#disable table#iff 'itcheck_file'#@DTMPREPARE_ACCEPT'check_no'
$!
$	gosub go_on
$!
$skip_lites:
$	return
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
