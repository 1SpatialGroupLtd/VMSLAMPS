$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-10-01 17:14:34.000000000 +0100
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
$! LAMPS package "DTMCREATE" acceptance test command procedure.
$!
$! Author 					TJH	25-Jan-1988
$!
$! Set things up
$!
$	set noon
$	ws="write sys$output"
$	esc[0,7]=27
$	bel[0,7]=7
$	ff[0,15]==%x0c			! form feed
$	clear_screen:== write sys$output FF,FF
$	b_on = esc+"[0m"+esc+"[1m" 	! bold on
$	b_of = esc+"[0m"		! bold off
$ 	bell =bel+bel			! ding ding
$	top  ="#3"			! big letters (top)
$	bot  ="#4"			! big letters (bottom)
$ 	i_on = ""			! inverse video on
$	vt100_ok=1			! assume VT100
$!
$! If we have a non VT100 terminal then switch off bolding etc...
$!
$	if f$getdvi("TT:","TT_ANSICRT") then goto lets_go
$	b_on = ""	 	! bold on
$	b_of = ""		! bold off
$ 	bell = ""		! no ding ding
$ 	i_on = ""		! inverse video on
$	top  =""		! no big letters (top)
$	bot  =""		! no big letters (bottom)
$	vt100_ok=0		! not VT100
$	clear_screen:== write sys$output " "
$!
$!***************************************************************************
$!
$lets_go:
$!
$ ws "''b_on'"
$ ws "============================================================"
$ ws "============          Laser-Scan Ltd.           ============"
$ ws "============      LAMPS package DTMCREATE       ============"
$ ws "============  Acceptance test command procedure ============"
$ ws "============================================================"
$	date_time=f$time()
$ ws "============  Starting ''date_time'  ============"
$ ws "============================================================"
$ ws " "
$ ws "''b_of'"
$ ws " "
$	gosub go_on
$ clear_screen
$!
$!***************************************************************************
$!
$! Defining the package symbols and setting up logical names.
$!
$ ws " "
$ ws "''b_on'"
$ ws "DTMCREATE package acceptance tests"
$ ws "''b_of'"
$	ws "... Initialising the package and checking environment"
$	ws " "
$	ws " "
$	ws " "
$	ws " "
$	inq/nop is_gpx "Are you using a VAXstation/GPX screen ? "
$	grafdev="A"		! A is for ARGS
$	if is_gpx then grafdev="GPX"
$	inq/nop nplanes "Are you using a 4 plane graphics screen ? "
$	graphics_planes=8
$	if nplanes then graphics_planes=4
$	if f$type(TRIANG).eqs."" then @lsl$com:dtmcreateini q
$	@lsl$com:matrixini 'grafdev' q
$	if f$type(LITES2).eqs."" then @lsl$com:lites2ini
$	set noon
$!
$	Define sys$error nl:
$	Define sys$output nl:
$	Define LSL$FRT	LSL$PUBLIC_ROOT:[DTMCREATE.ACCEPT]	
$	Define LSL$DTMCREATE_ACCEPT  LSL$PUBLIC_ROOT:[DTMCREATE.ACCEPT]	
$	if f$trnlnm("HERE").eqs.f$trnlnm("lsl$if") then goto switch_on
$	old_dir=f$trnlnm("HERE")
$	sd lsl$if
$ switch_on:
$	deassign sys$output
$	deassign sys$error
$	in_spot_iff_file="LSL$DTMCREATE_ACCEPT:DTMCREATE_ACCEPT_SPOT.START_IFF"
$	in_cont_iff_file="LSL$DTMCREATE_ACCEPT:DTMCREATE_ACCEPT_CONT.START_IFF"
$	in_riv_iff_file="LSL$DTMCREATE_ACCEPT:DTMCREATE_ACCEPT_RIV.START_IFF"
$	in_rid_iff_file="LSL$DTMCREATE_ACCEPT:DTMCREATE_ACCEPT_RID.START_IFF"
$	in_dti_file="LSL$DTMCREATE_ACCEPT:DTMCREATE_ACCEPT.START_DTI"
$	copied_spot_iff_file="LSL$IF:DTMCREATE_ACCEPT_SPOT.IFF"
$	copied_cont_iff_file="LSL$IF:DTMCREATE_ACCEPT_CONT.IFF"
$	copied_riv_iff_file="LSL$IF:DTMCREATE_ACCEPT_RIV.IFF"
$	copied_rid_iff_file="LSL$IF:DTMCREATE_ACCEPT_RID.IFF"
$	copied_dti_file="LSL$DTI:DTMCREATE_ACCEPT.DTI"
$	frt_file="LSL$DTMCREATE_ACCEPT:DTMCREATE_ACCEPT.FRT"
$	sri_file="LSL$DTMCREATE_ACCEPT:DTMCREATE_ACCEPT.SRI"
$	tri_file="LSL$DTMCREATE_ACCEPT:DTMCREATE_ACCEPT.TRI"
$!
$!============================================================================
$! Check the input acceptance test files exist
$!
$	if f$search(in_spot_iff_file) .nes. "" then goto iff_spot_file_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''in_spot_iff_file'"
$	ws " "
$	goto tidy_exit
$!
$ iff_spot_file_ok:
$	if f$search(in_cont_iff_file) .nes. "" then goto iff_cont_file_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''in_cont_iff_file'"
$	ws " "
$	goto tidy_exit
$!
$ iff_cont_file_ok:
$	if f$search(in_riv_iff_file) .nes. "" then goto iff_riv_file_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''in_riv_iff_file'"
$	ws " "
$	goto tidy_exit
$!
$ iff_riv_file_ok:
$	if f$search(in_rid_iff_file) .nes. "" then goto iff_rid_file_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''in_rid_iff_file'"
$	ws " "
$	goto tidy_exit
$!
$ iff_rid_file_ok:
$	if f$search(in_dti_file) .nes. "" then goto dti_file_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''in_dti_file'"
$	ws " "
$	goto tidy_exit
$!
$ dti_file_ok:
$	ws "... Input test data IFF files successfully found"
$	ws "... Input files were:
$	ws "          ''in_spot_iff_file'"
$	ws "          ''in_cont_iff_file'"
$	ws "          ''in_riv_iff_file'"
$	ws "          ''in_rid_iff_file'"
$	ws " "
$	ws "... Input test data DTI file successfully found"
$	ws "... Input file was ''in_dti_file'"
$	ws " "
$	ws "... Copying them to working LSL$IF and LSL$DTI directories"
$!
$! Create new ".IFF" files for manipulation during the tests
$!
$	copy/nolog/noconfirm 'in_spot_iff_file' 'copied_spot_iff_file'
$	if $status then goto check_copied_iff_spot_ok
$	ws " ''bell'"
$	ws "Failed to copy initial file to LSL$IF:, tests abandoned."
$	ws "Input file was ''in_spot_iff_file'"
$	ws "Output was to ''copied_spot_iff_file'"
$	ws " "
$	goto tidy_exit
$ check_copied_iff_spot_ok:
$	iff_search_file=f$search(copied_spot_iff_file)
$	if $status then goto iff_spot_copied_file_ok
$	ws " ''bell'"
$	ws "Failed to find copied file in LSL$IF:, tests abandoned."
$	ws "File was ''copied_spot_iff_file'"
$	ws " "
$	goto tidy_exit
$ iff_spot_copied_file_ok:
$	copy/nolog/noconfirm 'in_cont_iff_file' 'copied_cont_iff_file'
$	if $status then goto check_copied_iff_cont_ok
$	ws " ''bell'"
$	ws "Failed to copy initial file to LSL$IF:, tests abandoned."
$	ws "Input file was ''in_cont_iff_file'"
$	ws "Output was to ''copied_cont_iff_file'"
$	ws " "
$	goto tidy_exit
$ check_copied_iff_cont_ok:
$	iff_search_file=f$search(copied_cont_iff_file)
$	if $status then goto iff_cont_copied_file_ok
$	ws " ''bell'"
$	ws "Failed to find copied file in LSL$IF:, tests abandoned."
$	ws "File was ''copied_cont_iff_file'"
$	ws " "
$	goto tidy_exit
$ iff_cont_copied_file_ok:
$	copy/nolog/noconfirm 'in_riv_iff_file' 'copied_riv_iff_file'
$	if $status then goto check_copied_iff_riv_ok
$	ws " ''bell'"
$	ws "Failed to copy initial file to LSL$IF:, tests abandoned."
$	ws "Input file was ''in_riv_iff_file'"
$	ws "Output was to ''copied_riv_iff_file'"
$	ws " "
$	goto tidy_exit
$ check_copied_iff_riv_ok:
$	iff_search_file=f$search(copied_riv_iff_file)
$	if $status then goto iff_riv_copied_file_ok
$	ws " ''bell'"
$	ws "Failed to find copied file in LSL$IF:, tests abandoned."
$	ws "File was ''copied_riv_iff_file'"
$	ws " "
$	goto tidy_exit
$ iff_riv_copied_file_ok:
$	copy/nolog/noconfirm 'in_rid_iff_file' 'copied_rid_iff_file'
$	if $status then goto check_copied_iff_rid_ok
$	ws " ''bell'"
$	ws "Failed to copy initial file to LSL$IF:, tests abandoned."
$	ws "Input file was ''in_rid_iff_file'"
$	ws "Output was to ''copied_rid_iff_file'"
$	ws " "
$	goto tidy_exit
$ check_copied_iff_rid_ok:
$	iff_search_file=f$search(copied_rid_iff_file)
$	if $status then goto iff_rid_copied_file_ok
$	ws " ''bell'"
$	ws "Failed to find copied file in LSL$IF:, tests abandoned."
$	ws "File was ''copied_rid_iff_file'"
$	ws " "
$	goto tidy_exit
$ iff_rid_copied_file_ok:
$!
$!====================================================================
$! Create a file ".DTI" for manipulation during the tests
$!
$	copy/nolog/noconfirm 'in_dti_file' 'copied_dti_file'
$	if $status then goto dtdir_ok
$	ws " ''bell'"
$	ws "Failed to copy initial file to LSL$DTI:, tests abandoned."
$	ws "Input file was ''in_dti_file'"
$	ws "Output was to ''copied_dti_file'"
$	ws " "
$	goto tidy_exit
$dtdir_ok:
$	dti_search_file=f$search(copied_dti_file)
$	if $status then goto dti_copied_file_ok
$	ws " ''bell'"
$	ws "Failed to find copied file in LSL$DTI:, tests abandoned."
$	ws "File was ''copied_dti_file'"
$	ws " "
$	goto tidy_exit
$dti_copied_file_ok:
$	ws "... All copied data files sucessfully found"
$	ws " "
$	ws "... Initialisation and environment checks complete"
$!
$! Make up the input and output file-specs
$	device  = f$parse("''iff_search_file'",,,"DEVICE")
$	dirnam  = f$parse("''iff_search_file'",,,"DIRECTORY")
$	nod_file = device+dirnam+"DTMCREATE_ACCEPT.NOD"
$	dta_file = device+dirnam+"DTMCREATE_ACCEPT.DTA"
$	der_file = device+dirnam+"DTMCREATE_ACCEPT.DER"
$	device  = f$parse("''dti_search_file'",,,"DEVICE")
$	dirnam  = f$parse("''dti_search_file'",,,"DIRECTORY")
$	north_dti_file = device+dirnam+"DTMCREATE_ACCEPT_NORTH.DTI"
$	south_dti_file = device+dirnam+"DTMCREATE_ACCEPT_SOUTH.DTI"
$	ws " "
$	gosub go_on
$ clear_screen
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ ws " "
$ ws "''b_on'"
$ ws "DTMCREATE package acceptance tests"
$ ws "''b_of'"
$	Type Sys$input:

In these tests DTMCREATE uses vector input from 4 IFF vector files which
contain:

          contours,
          3D river features,
          3D ridgeline features, and,
          spot heights

Part of an existing DTI file is also input to show how new DTMs can be
easily edge matched to existing ones.

$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Use LITES2 to show off the source data
$!
$	gosub go_on
$	clear_screen
$	ws " "
$	inquire/nopunc use_lites2 "Do you want to use LITES2 to examine the IFF files ?  "
$	if .not.use_lites2 then goto skip_lites_a
$ 	ass/user sys$command sys$input
$ 	lites2 frt LSL$DTMCREATE_ACCEPT:DTMCREATE_ACCEPT#disable table#maps 4#iff 'copied_spot_iff_file'#iff 'copied_cont_iff_file'#iff 'copied_riv_iff_file'#iff 'copied_rid_iff_file'
$!
$	gosub go_on
$	clear_screen
$!
$skip_lites_a:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ ws " "
$ ws "''b_on'"
$ ws "DTMCREATE package acceptance tests"
$ ws "''b_of'"
$ ws "The DTMCREATE acceptance tests fall into 4 stages, the current task is shown in ''b_on'bold''b_of':"
$ ws " "
$ ws b_on,-
     "           (1) TRIANG - to generate a constrained Delaunay triangulation",b_of
$ ws "           (2) TRIEDIT - to examine and edit the triangulation"
$ ws "           (3) TRIDER - to estimate triangle vertex slope derivatives "
$ ws "           (4) TRIGRID - to generate a grid DTM from the triangulation"
$ 	gosub go_on
$	clear_screen
$ ws "''b_on' "
$ 	ws " "
$ 	ws "''top'                TRIANG"
$ 	ws "''bot'                TRIANG"
$ 	ws " "
$ 	ws -
"The data input and triangulation module."
$ 	ws " "
$ 	ws -
"The digitised contours, spot heights, lakes and 3 "
$ 	ws -
"dimensional river and ridgeline strings are read in and a unique nearest "
$ 	ws -
"neighbour triangulation created so that all digitised points are included "
$ 	ws -
"in the terrain model creation process."
$ 	ws -
"The unique triangulation is then constrained to prevent triangle ""leakage"". "
$ 	ws " "
$ ws "The input files are:"
$ ws "                 ''copied_dti_file' "
$ ws "                 ''copied_spot_iff_file' "
$ ws "                 ''copied_cont_iff_file' "
$ ws "                 ''copied_riv_iff_file' "
$ ws "                 ''copied_rid_iff_file' "
$ ws " "
$ ws "The output files are:
$ ws "                 ''nod_file' "
$ ws "                 ''dta_file' "
$ ws "''b_of'"
$!
$	gosub go_on
$!
$	set verify
$	TRIANG
ENABLE GRAPHICS
ENABLE CONSTRAINT
WIN 400 300 1300 1300
FILEOUT DTMCREATE_ACCEPT.DTA
ZLIMITS 0 3000
MAXPOINTS 2000
DISABLE SQUARE
FORMAT DTI
FILEIN DTMCREATE_ACCEPT.DTI
300 400
FORMAT IFF
FILEIN DTMCREATE_ACCEPT_SPOT.IFF
DESELECT LAYER 5
ASSIGN BREAKLINE_FC 4
FILEIN DTMCREATE_ACCEPT_CONT.IFF
SELECT ALL
ASSIGN RIVER_FC 2
FILEIN DTMCREATE_ACCEPT_RIV.IFF
ASSIGN RIDGE_FC 9
FILEIN DTMCREATE_ACCEPT_RID.IFF
ENABLE DIAGNOSTICS
GO
$	set noverify
$	gosub go_on
$	clear_screen
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ ws " "
$ ws "''b_on'"
$ ws "DTMCREATE package acceptance tests"
$ ws "''b_of'"
$ ws "The DTMCREATE acceptance tests fall into 4 stages, the current task is shown in ''b_on'bold''b_of':"
$ ws " "
$ ws "           (1) TRIANG - to generate a constrained Delaunay triangulation"
$ ws b_on,-
     "           (2) TRIEDIT - to examine and edit the triangulation",b_of
$ ws "           (3) TRIDER - to estimate triangle vertex slope derivatives "
$ ws "           (4) TRIGRID - to generate a grid DTM from the triangulation"
$	gosub go_on
$	clear_screen
$ ws "''b_on' "
$ 	ws " "
$ 	ws "''top'                TRIEDIT"
$ 	ws "''bot'                TRIEDIT"
$ 	ws " "
$ 	ws -
"TRIEDIT is the DTMCREATE interactive graphic editor. It takes"
$ 	ws -
"triangulation files produced by TRIANG and enables additional information to"
$ 	ws -
"be added, and present relationships and attributes to be modified."
$ 	ws " "
$ ws " "
$ ws "The triangulation input files are:"
$ ws "                 ''nod_file' "
$ ws "                 ''dta_file' "
$ ws "''b_of'"
$!
$	gosub go_on
$	clear_screen
$!
$	SET VERIFY
$	ASSIGN/USER TT: SYS$INPUT
$	TRIEDIT 'dta_file'
$	set noverify
$	gosub go_on
$	clear_screen
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ ws " "
$ ws "''b_on'"
$ ws "DTMCREATE package acceptance tests"
$ ws "''b_of'"
$ ws "The DTMCREATE acceptance tests fall into 4 stages, the current task is shown in ''b_on'bold''b_of':"
$ ws " "
$ ws "           (1) TRIANG - to generate a constrained Delaunay triangulation"
$ ws "           (2) TRIEDIT - to examine and edit the triangulation",b_of
$ ws b_on,-
     "           (3) TRIDER - to estimate triangle vertex slope derivatives ",b_of
$ ws "           (4) TRIGRID - to generate a grid DTM from the triangulation"
$ 	gosub go_on
$ ws "''b_on' "
$ 	ws " "
$ 	ws "''top'                TRIDER"
$ 	ws "''bot'                TRIDER"
$ 	ws " "
$ 	ws -
" The slope derivative calculation module."
$ 	ws " "
$ 	ws -
" For each node in the triangulation the slope derivative in X and Y"
$ 	ws -
" is calculated. Heights and slope derivatives are also estimated for "
$ 	ws -
" the boundary of the area being modelled."
$ 	ws " "
$ ws " "
$ ws "The triangulation input files are:"
$ ws "                 ''nod_file' "
$ ws "                 ''dta_file' "
$ ws "The slope derivative output file is :"
$ ws "                 ''der_file' "
$ ws "''b_of'"
$	gosub go_on
$	clear_screen
$	set verify
$	TRIDER
ENABLE GRAPHICS
IMAGINARY TREND 1.0
ZLIMITS 0 3000
FILEIN DTMCREATE_ACCEPT.DTA
GO
$	set noverify
$	gosub go_on
$	clear_screen
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ ws " "
$ ws "''b_on'"
$ ws "DTMCREATE package acceptance tests"
$ ws "''b_of'"
$ ws "The DTMCREATE acceptance tests fall into 4 stages, the current task is shown in ''b_on'bold''b_of':"
$ ws " "
$ ws "           (1) TRIANG - to generate a constrained Delaunay triangulation"
$ ws "           (2) TRIEDIT - to examine and edit the triangulation",b_of
$ ws "           (3) TRIDER - to estimate triangle vertex slope derivatives "
$ ws b_on,-
     "           (4) TRIGRID - to generate a grid DTM from the triangulation"
$ ws " "
$	gosub go_on
$	clear_screen
$ 	ws b_on
$	ws " "
$ 	ws "''top'                TRIGRID"
$ 	ws "''bot'                TRIGRID"
$	ws " "
$	ws -
" The DTM (matrix) generation module. "
$	ws " "
$	ws -
" The triangulated data and the slope derivatives are used to create a "
$	ws -
" grid or matrix of heights to a user specified size and resolution "
$	ws -
" For the purposes of the DTMCREATE acceptance tests TRIGRID will be used"
$	ws -
" to generate two DTMs from the triangulated data area. This demonstrates the"
$	ws -
" TRIGRID window facility, and when the 2 DTMs are joined, the quality of inter-
$	ws -
" DTM edge matching achieved by the DTMCREATE software."
$ ws " "
$ ws "The triangulation input files are:
$ ws "                 ''nod_file' "
$ ws "                 ''dta_file' "
$ ws "                 ''der_file' "
$ ws " "
$ ws "The output file for the first TRIGRID run is:"
$ ws "                 ''north_dti_file' "
$ ws " "
$ ws "The output file for the second TRIGRID run is:"
$ ws "                 ''south_dti_file' "
$ ws "''b_of'"
$	gosub go_on
$	clear_screen
$!
$ ws "First we will generate a DTM for the north half of the data area"
$ set verify
$ TRIGRID
WINDOW 400 800 1200 1200
SIZ 161 81
ZLIMITS 0 3000
TRIANGLE_LIMITS 3 8
ENABLE TRACE
ENABLE GRAPHICS 
ENABLE DIAGNOSTICS
FILEIN DTMCREATE_ACCEPT.DTA
FILEOUT DTMCREATE_ACCEPT_NORTH.DTI
GO
$ set noverify
$!
$ ws " "
$ ws "Now we will generate a DTM for the south half of the data area"
$ set verify
$ TRIGRID
WINDOW 400 400 1200 800
SIZ 161 81
ZLIMITS 0 3000
TRIANGLE_LIMITS 3 8
ENABLE TRACE
ENABLE GRAPHICS 
ENABLE DIAGNOSTICS
FILEIN DTMCREATE_ACCEPT.DTA
FILEOUT DTMCREATE_ACCEPT_SOUTH.DTI
GO
$ set noverify
$	gosub go_on
$	clear_screen
$	type sys$input	

The MATRIX utility DTITILE will now be used to join the two DTI format
DTM files produced by these acceptance tests. 

$ set verify
$ DTITILE
FILEIN DTMCREATE_ACCEPT_SOUTH
ORIGIN 1 1
FILEIN DTMCREATE_ACCEPT_NORTH
ORIGIN 1 81
FILEOUT DTMCREATE_ACCEPT_FINAL_DTM.DTI
SHOW FILES
GO
$ set noverify
$	gosub go_on
$	clear_screen
$	type sys$input

The MATRIX utility DTIVIEW is now used to display isometric views of
the two half DTMs and finally the whole area DTM created by DTITILE.

$	if graphics_planes.eq.4 then goto four_planes
$	dtiview
filein dtmcreate_accept_south.dti
enable graphics
enable divide
direction n
isometric
label position 0.07 0.1
draw label View from North-West
direction e
isometric
label position 0.15 0.1
draw label View from North-East
dir s
isometric
draw label View from South-East
dir w
isometric
draw label View from South-West
wait 10
clear
filein dtmcreate_accept_north.dti
dir n
iso
label position 0.07 0.1
draw label View from North-West
dir e
iso
label position 0.15 0.1
draw label View from North-East
dir s
iso
draw label View from South-East
dir w
iso
draw label View from South-West
wait 10
disable divide
clear
file dtmcreate_accept_final_dtm
iso
label size 2
label position 0.4 0.045
draw label VIEW FROM THE SOUTH-WEST
legend position 0.005 0.5
draw legend
wait 10
exit
$ goto both_planes
$!
$! Four plane version
$ four_planes:
$	dtiview
filein dtmcreate_accept_south.dti
planes 4
enable graphics
enable divide
direction n
isometric
label position 0.07 0.1
draw label View from North-West
direction e
isometric
label position 0.15 0.1
draw label View from North-East
dir s
isometric
draw label View from South-East
dir w
isometric
draw label View from South-West
wait 10
clear
filein dtmcreate_accept_north.dti
dir n
iso
label position 0.07 0.1
draw label View from North-West
dir e
iso
label position 0.15 0.1
draw label View from North-East
dir s
iso
draw label View from South-East
dir w
iso
draw label View from South-West
wait 10
disable divide
clear
file dtmcreate_accept_final_dtm
iso
label size 2
label position 0.4 0.045
draw label VIEW FROM THE SOUTH-WEST
legend position 0.005 0.5
draw legend
wait 10
exit
$!
$ both_planes:
$	gosub go_on
$	clear_screen
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ ws "''b_on'"
$ ws "============================================================"
$ ws "============          Laser-Scan Ltd.           ============"
$ ws "============     LAMPS package "DTMCREATE"      ============"
$ ws "============  Acceptance test command procedure ============"
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
$	set noon
$	ws "... Tidying up, please ignore any warning messages"
$	purge lsl$if:DTMCREATE_ACCEPT*.IFF
$	purge lsl$dti:DTMCREATE_ACCEPT*.*
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$tidy_exit:
$	set control=y
$	deassign lsl$frt	! return lsl$frt to startup default
$	if old_dir.nes."" then sd 'old_dir'
$	if ver_status then set verify
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
