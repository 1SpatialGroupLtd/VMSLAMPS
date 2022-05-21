$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-10-09 12:05:14.000000000 +0100
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
$! LAMPS package "TVES" acceptance test command procedure.
$!
$! Author 					DRC	27-Jan-1988
$! Based on DTMCREATE acceptance procedure by   TJH
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
$ ws "============           Laser-Scan Ltd.          ============"
$ ws "============         LAMPS package TVES         ============"
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
$ ws "TVES package acceptance tests"
$ ws "''b_of'"
$	ws "... Initialising the package and checking environment"
$	ws " "
$	inquire/nopunc uis "Is graphical output to a VAX workstation ? "
$	if uis then @lsl$com:tvesini u
$	if .not.uis then @lsl$com:tvesini a
$	set noon
$!
$	Define sys$error nl:
$	Define sys$output nl:
$	Define LSL$FRT	LSL$PUBLIC_ROOT:[TVES.ACCEPT]	
$	Define LSL$TVES_ACCEPT  LSL$PUBLIC_ROOT:[TVES.ACCEPT]	
$!
$	deassign sys$output
$	deassign sys$error
$!
$	in_dti_file="LSL$TVES_ACCEPT:TVES_ACCEPT.DTI"
$	in_iff_file="LSL$TVES_ACCEPT:TVES_ACCEPT_OVERLAY.IFF"
$	in_vis_file="LSL$TVES_ACCEPT:TVES_ACCEPT.VIS"
$	frt_file="LSL$TVES_ACCEPT:TVES_ACCEPT.FRT"
$	sri_file="LSL$TVES_ACCEPT:TVES_ACCEPT.SRI"
$	tri_file="LSL$TVES_ACCEPT:TVES_ACCEPT.TRI"
$!
$	copied_iff_file="LSL$IF:TVES_ACCEPT_OVERLAY.IFF"
$	copied_dti_file="LSL$DTI:TVES_ACCEPT.DTI"
$	copied_vis_file="LSL$DTI:TVES_ACCEPT.VIS"
$!
$!============================================================================
$! Check the input acceptance test files exist
$!
$	if f$search(in_dti_file) .nes. "" then goto in_dti_file_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''in_dti_file'"
$	ws " "
$	goto tidy_exit
$!
$ in_dti_file_ok:
$	if f$search(in_iff_file) .nes. "" then goto in_iff_file_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''in_iff_file'"
$	ws " "
$	goto tidy_exit
$!
$ in_iff_file_ok:
$	if f$search(in_vis_file) .nes. "" then goto in_vis_file_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''in_vis_file'"
$	ws " "
$	goto tidy_exit
$!
$ in_vis_file_ok:
$	if f$search(frt_file) .nes. "" then goto frt_file_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''frt_file'"
$	ws " "
$	goto tidy_exit
$!
$ frt_file_ok:
$	if f$search(sri_file) .nes. "" then goto sri_file_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''sri_file'"
$	ws " "
$	goto tidy_exit
$!
$ sri_file_ok:
$	if f$search(tri_file) .nes. "" then goto tri_file_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''tri_file'"
$	ws " "
$	goto tidy_exit
$!
$ tri_file_ok:
$!
$	ws "... Input test data files successfully found"
$	ws "... Input files were:
$	ws "          ''in_dti_file'"
$	ws "          ''in_iff_file'"
$	ws "          ''in_vis_file'"
$	ws " "
$	ws "... Input test lookup files successfully found"
$	ws "... Input file were:
$	ws "          ''frt_file'"
$	ws "          ''sri_file'"
$	ws "          ''tri_file'"
$	ws " "
$	ws "... Copying them to working LSL$IF and LSL$DTI directories"
$!
$! Create new ".IFF" files for manipulation during the tests
$!
$	copy/nolog/noconfirm 'in_iff_file' 'copied_iff_file'
$	if $status then goto check_copied_iff_ok
$	ws " ''bell'"
$	ws "Failed to copy initial file to LSL$IF:, tests abandoned."
$	ws "Input file was ''in_iff_file'"
$	ws "Output was to ''copied_iff_file'"
$	ws " "
$	goto tidy_exit
$ check_copied_iff_ok:
$	iff_search_file=f$search(copied_iff_file)
$	if $status then goto iff_copied_file_ok
$	ws " ''bell'"
$	ws "Failed to find copied file in LSL$IF:, tests abandoned."
$	ws "File was ''copied_iff_file'"
$	ws " "
$	goto tidy_exit
$ iff_copied_file_ok:
$	copy/nolog/noconfirm 'in_dti_file' 'copied_dti_file'
$	if $status then goto check_copied_dti_ok
$	ws " ''bell'"
$	ws "Failed to copy initial file to LSL$DTI:, tests abandoned."
$	ws "Input file was ''in_dti_file'"
$	ws "Output was to ''copied_dti_file'"
$	ws " "
$	goto tidy_exit
$ check_copied_dti_ok:
$	iff_search_file=f$search(copied_dti_file)
$	if $status then goto copied_dti_file_ok
$	ws " ''bell'"
$	ws "Failed to find copied file in LSL$DTI:, tests abandoned."
$	ws "File was ''copied_dti_file'"
$	ws " "
$	goto tidy_exit
$ copied_dti_file_ok:
$	copy/nolog/noconfirm 'in_vis_file' 'copied_vis_file'
$	if $status then goto check_copied_vis_ok
$	ws " ''bell'"
$	ws "Failed to copy initial file to LSL$DTI:, tests abandoned."
$	ws "Input file was ''in_vis_file'"
$	ws "Output was to ''copied_vis_file'"
$	ws " "
$	goto tidy_exit
$ check_copied_vis_ok:
$	iff_search_file=f$search(copied_vis_file)
$	if $status then goto copied_vis_ok
$	ws " ''bell'"
$	ws "Failed to find copied file in LSL$DTI:, tests abandoned."
$	ws "File was ''copied_vis_file'"
$	ws " "
$	goto tidy_exit
$ copied_vis_ok:
$!
$	ws "... All copied data files successfully found"
$	ws " "
$	ws "... Initialisation and environment checks complete"
$	ws " "
$       clear_screen
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! 	ROVER (without editing)
$!
$	clear_screen
$	ws " "
$	inquire/nopunc do_rover "Carry out acceptance for TVES module ROVER ? "
$	if .not.do_rover then goto skip_rover
$!
$	ROVER
!Default window and display parameters
FILE TVES_ACCEPT
DISPLAY
WAIT 20
!Window definition
WIN 1 1 200 200
!Step and range definition
RANGE 0 500
STEP 50
RANGE 0 500
DISPLAY
WAIT 20
WINDOW 1 1 291 241
RANGE 0 850
DISPLAY
!overlay of all IFF features
IFF TVES_ACCEPT_OVERLAY
FRT TVES_ACCEPT
SRI TVES_ACCEPT
TRI TVES_ACCEPT
OVERLAY
!selection of picture
WAIT 20
DISABLE PICTURE 2
WAIT 10
ENABLE PICTURE 2
WAIT 10
DISABLE PICTURE 1
WAIT 10
ENABLE PICTURE 1
WAIT 10
CLEAR PICTURE 2
!selection of IFF features
SELECT FC ROADS RIVERS
OVERLAY
WAIT 10
SELECT ALL
SELECT FC CONTOUR
!set colour to white
SET COLOUR 1
OVERLAY
WAIT 20
CLEAR
!use of divided screen
ENABLE DIVIDE
FILEIN TVES_ACCEPT
STEP 50
DISPLAY
STEP 200
DISPLAY
DISPLAY
ENABLE MASK
SET COLOUR 0
OVERLAY
WAIT 10
!selection of quadrant
CLEAR QUADRANT 2
QUADRANT 2
!rotation
ROTATE N
DISPLAY
!disable legend and text
ROTATE S
QUADRANT 4
STEP 100
DISABLE LEGEND
DISABLE TEXT
DISP
WAIT 20
EXIT
$!
$	gosub go_on
$	clear_screen
$!
$skip_rover:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! 	SLOPES
$!
$	clear_screen
$	ws " "
$	inquire/nopunc do_slopes "Carry out acceptance for TVES module SLOPES ? "
$	if .not.do_slopes then goto skip_slopes
$!
$	SLOPES
ENABLE GRAPHICS
FILEIN TVES_ACCEPT
SHOW FILES
!
!slope map - default parameters
SLOPE
WAIT 10
!
!redefine step values
STEP 10 10 20
SHOW SLOPE
SLOPE
WAIT 10
DISABLE CLEAR
!
!restrict to gradient and height range
VALUE_RANGE 0 30
ZLIMITS 0 500
SLOPE
WAIT 10
!
!slope algorithm 2
SLOPE 2
DEFAULT SLOPE
ZLIMITS 0 850
WAIT 10
CLEAR
ENABLE CLEAR
!
!aspect - default values
DEFAULT ASPECT
ASPECT
WAIT 20
!
!redefine angular interval
ANGLE_INTERVAL 45
ASPECT
WAIT 20
!
!greyscale image
ENABLE GREY
ASPECT
WAIT 10
DISABLE CLEAR
!
!shaded overlays - default sun position
DEFAULT SHADE
SHADE
WAIT 10
!
!sun in NE
SUN_POSITION 45
SHADE
WAIT 10
!
!sun angle of 30 degrees
SUN_ANGLE 30
SHADE
WAIT 20
DEFAULT SHADE
CLEAR
ENABLE CLEAR
!
!output to screen and DTI disk file
WINDOW 1 1 291 241
FILEOUT TVES_ACCEPT.SHD
SHADE
WAIT 20
EXIT
$!
$	gosub go_on
$	clear_screen
$!
$ROVER
!
!select shaded overlay generated by SLOPES
FILE TVES_ACCEPT.SHD
WIN 1 1 291 241
!
!plane and colour table definition
PLANES 6
LUT ROVERG6
FIRST_COLOUR 32
COLOURS 31
DISPLAY
!
!IFF on shaded overlay
IFF TVES_ACCEPT_OVERLAY
FRT TVES_ACCEPT
SEL FC RIVERS ROADS
OVERLAY
WAIT 20
CLEAR PICTURE 2
SEL ALL
SEL FC CONTOUR
ENABLE MASK
SET COLOUR 0
OVERLAY
WAIT 20
!
!divided screen
CLEAR
ENABLE DIVIDE
WIN 1 1 197 163
DISPLAY
!
!second file
FILEIN TVES_ACCEPT
WIN 1 1 197 163
COLOURS 31
STEP 100
DISPLAY
WAIT 20
!
!select first file again
SELECT FILEIN 1
DISPLAY
IFFWIN 150 220 347 383
ENABLE MASK
OVERLAY
WAIT 20
EXIT
$!
$	gosub go_on
$	clear_screen
$!
$skip_slopes:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! 	PROFILE
$!
$	clear_screen
$	ws " "
$	inquire/nopunc do_profile "Carry out acceptance for TVES module PROFILE ? "
$	if .not.do_profile then goto skip_profile
$!
$	PROFILE
!Define input DTM
ENABLE DIAGNOSTICS
FILE TVES_ACCEPT
UNITS MATRIX
WIN 1 1 50 50
POSITION 25 25
SAMPLE 100
SHOW PARAMETERS
IFF TVES_ACCEPT_PROFILE1
GO
!
WIN 1 1 181 160
POSITION 46 27
PROFILE 5
SECTOR 4500
BAND 1 1000 200
BAND 2 2000 100
BAND 3 1500 50
SHOW PARAMETERS
IFF TVES_ACCEPT_PROFILE2
GO
EXIT
$!
$	gosub go_on
$!
$! Use ROVER to display the paths of the profile on the DTM
$!
$  ROVER
FILEIN TVES_ACCEPT
WIN 1 1 50 50
FRT TVES_ACCEPT
SRI TVES_ACCEPT
TRI TVES_ACCEPT
STEP 50
DISPLAY
IFF TVES_ACCEPT_PROFILE1
SET COLOUR 1
OVERLAY
WAIT 20
CLEAR
WIN 1 1 181 160
IFF TVES_ACCEPT_PROFILE2
DISPLAY
OVERLAY
WAIT 20
CLEAR PICTURE 2
ENABLE OVERRIDE 1 7
OVERLAY
WAIT 20
EXIT
$!
$	gosub go_on
$	clear_screen
$!
$skip_PROFILE:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! 	COVER
$!
$	clear_screen
$	ws " "
$	inquire/nopunc do_cover "Carry out acceptance for TVES module COVER ? "
$	if .not.do_cover then goto skip_cover
$!
$	COVER
!Define input DTM
ENABLE DIAGNOSTICS
FILEIN TVES_ACCEPT
WIN 1 1 250 240
!
!Define position and view paramaters for observer 1
UNITS MATRIX
DEFINE OBSERVER 1
POS 131 86
DIRECTION 0	!north
CONE 90
DISTANCE 200.0
SHOW OBSERVER
FILEOUT TVES_ACCEPT_COVER.VIS
GO
!
!Display cover map
DISPLAY TVES_ACCEPT_COVER
WAIT 20
!
!Display file with 2 observers
DISPLAY TVES_ACCEPT
WAIT 20
!Select just observer 1
SELECT OBSERVER 1
REDISPLAY
WAIT 20
EXIT
$!
$	gosub go_on
$	clear_screen
$!
$skip_cover:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! 	VECTORISE
$!
$	clear_screen
$	ws " "
$	inquire/nopunc do_vect "Carry out acceptance for TVES module VECTORISE ? "
$	if .not.do_vect then goto skip_vectorise
$!
$	VECTORISE
FILEIN TVES_ACCEPT_COVER.VIS
RANGE 1
SET INTERIOR_FC 3
SET BORDER_FC 6
UNITS MATRIX
WIN 1 1 250 240
ENABLE DIAGNOSTICS
IFF TVES_ACCEPT_VECTORISE.IFJ
GO
EXIT
$!
$	gosub go_on
$!
$	ROVER
FILEIN TVES_ACCEPT_COVER.VIS
WIN 1 1 250 240
STEP 1
DISP
FRT TVES_ACCEPT
IFF TVES_ACCEPT_VECTORISE.IFJ
ENABLE MASK
SET COLOUR 0
OVERLAY
WAIT 10
IFF TVES_ACCEPT_OVERLAY
IFFWIN 150 220 400 460
DISABLE MASK
SET COL FRT
OVERLAY
WAIT 20
EXIT
$!
$	gosub go_on
$	clear_screen
$!
$skip_vectorise:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! 	I2GRID
$!
$	clear_screen
$	ws " "
$	inquire/nopunc do_i2grid "Carry out acceptance for TVES module I2GRID ? "
$	if .not. do_i2grid then goto skip_i2grid
$!
$	I2GRID
IFF TVES_ACCEPT_OVERLAY
DISABLE ABSOLUTE
IFFWINDOW 150 220 440 460
FRT TVES_ACCEPT
SELECT FC WOODS
ATTRIBUTE FC
PRESET FC 0 = 100
GRID 1 1
CREATE TVES_ACCEPT.RAS
ENABLE LOG
SHOW PARAMETERS
GO
SELECT ALL
SELECT FC ROADS RIVERS
PRESET FC 1 = 200
PRESET FC 6 = 300
SHOW PARAMETERS
GO
EXIT
$!
$	gosub go_on
$!
$!Display the result in ROVER
$!
$	ROVER
!Define input DTM
FILEIN TVES_ACCEPT.RAS
WIN 1 1 291 241
DISPLAY
FRT TVES_ACCEPT
SRI TVES_ACCEPT
TRI TVES_ACCEPT
IFF TVES_ACCEPT_OVERLAY
SEL FC WOODS
OVERLAY
SEL ALL
SEL FC RIVERS ROADS
SET COL 1
OVERLAY
WAIT 20
EXIT
$!
$	gosub go_on
$	clear_screen
$!
$skip_i2grid:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! 	DTICONTOUR
$!
$	clear_screen
$	ws " "
$	inquire/nopunc do_cont "Carry out acceptance for TVES module DTICONTOUR ? "
$	if .not.do_cont then goto skip_dticontour
$!
$	DTICONTOUR
!Define input DTM
FILEIN TVES_ACCEPT
!
!Define output contour file
UNITS MAT
FILEOUT TVES_ACCEPT_DTICONTOUR
!
!Enable smoothing
ENABLE SMOOTH 2
!
!Define intervals and feature codes
INTERVAL 50
INDEX_INTERVAL 250
SET CONTOUR_FC 5
SET INDEX_FC 3
ZLIMIT 0 850
!
!Labelling
ENABLE LABELLING
SET LABEL_FC 6
SET INDEX_LABEL_FC 6
LABEL SIZE 70
LABEL MINGAP 1000
LABEL MAXCURVE 0.75
LABEL MODULUS 0
LABEL INTEGER
LABEL INDEX_MODULUS 250
ENABLE DIAGNOSTICS
GO
$	clear_screen
$	ws " "
$	inquire/nopunc do_rover_cont "Display contour map in ROVER ? "
$	if .not.do_rover_cont then goto skip_do_rover_cont
$!
$	ROVER
!Define input DTM
FILEIN TVES_ACCEPT
WIN 1 1 291 241
STEP 50
DISPLAY
!
!Contour file
IFF TVES_ACCEPT_DTICONTOUR
FRT TVES_ACCEPT
SRI TVES_ACCEPT
TRI TVES_ACCEPT
OVERLAY
WAIT 20
EXIT
$!
$	goto skip_dticontour
$
$skip_do_rover_cont:
$!
$	clear_screen
$	ws " "
$	inquire/nopunc do_LITES2_cont "Display contour map in LITES2 ? "
$	if .not.do_LITES2_cont then goto skip_dticontour
$
$lites2ini
$ASSIGN/USER SYS$COMMAND SYS$INPUT
$lites2 frt tves_accept # iff tves_accept_dticontour
$!
$skip_dticontour:
$!
$	gosub go_on
$	clear_screen
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! 	DTICHECK
$!
$	clear_screen
$	ws " "
$	inquire/nopunc do_check "Carry out acceptance for TVES module DTICHECK ? "
$	if .not.do_check then goto skip_dticheck
$!
$	DTICHECK
!Define input DTM
FILEIN TVES_ACCEPT
!
!Define an area of interest
UNITS MATRIX
WINDOW 100 100 291 241
!
!Define output contour file
ROVER TVES_ACCEPT_DTICHECK
!
!Enable diagnostics
ENABLE DIAGNOSTICS
!
!Enable slope checking
ENABLE SLOPE
!
!Set Z difference value to suitable value 
SLOPE 50
GO
$!
$	clear_screen
$	ws " "
$	inquire/nopunc do_rover_check "Display suspect points in ROVER ? "
$	if .not.do_rover_check then goto skip_do_rover_check
$!
$ ROVER
!Define input DTM
FILEIN TVES_ACCEPT
WINDOW 100 100 291 241
ENABLE EDIT
!
!To run ROVER.RCM file now type @TVES_ACCEPT_DTICHECK
!On completion type EXIT
$!
$	goto skip_dticheck
$
$skip_do_rover_check:
$!
$skip_dticheck:
$!
$	gosub go_on
$	clear_screen
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! 	DTIVIEW - vector overlay
$!
$	clear_screen
$	ws " "
$	inquire/nopunc do_dtiview "Carry out acceptance for DTIVIEW overlay ? "
$	if .not.do_dtiview then goto skip_dtiview
$!
$	if uis then @lsl$com:matrixini u q
$	if .not.uis then @lsl$com:matrixini u q
$!
$	DTIVIEW
ENABLE GRAPHICS
FILE TVES_ACCEPT
WIN 1 1 200 200
COLOUR 1
ENABLE OVERLAY
FRT LSL$PUBLIC_ROOT:[MATRIX.ACCEPT]MATRIX_ACCEPT
SRI TVES_ACCEPT
IFF TVES_ACCEPT_OVERLAY
IFFWIN 150 220 350 420
ISOMETRIC
SELECT FC WOODS
OVERLAY
SELECT ALL
SELECT FC ROADS RIVERS
OVERLAY
WAIT 20
DISABLE PICTURE 2
WAIT 10
ENABLE PICTURE 2
WAIT 10
EXIT
$!
$	gosub go_on
$	clear_screen
$!
$ skip_dtiview:
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! 	ROVER editing
$!
$	clear_screen
$	ws " "
$	inquire/nopunc do_rover_ed "Carry out acceptance for TVES module ROVER edit ? "
$	if .not.do_rover_ed then goto skip_rover_edit
$	copy LSL$DTI:TVES_ACCEPT.DTI LSL$DTI:TVES_ACCEPT_COPY.DTI
$!
$	ROVER
ENABLE COLOUR_MAP
!Open DTI file for editing
UPDATE_FILEIN TVES_ACCEPT_COPY.DTI
DISPLAY
!
!IFF overlay - may be disabled by means of DISABLE PICTURE 2
FRT TVES_ACCEPT
SRI TVES_ACCEPT
TRI TVES_ACCEPT
IFF TVES_ACCEPT_OVERLAY
SELECT FC RIVERS ROADS
OVERLAY
!
!enable editing
ENABLE EDIT
$!
$	gosub go_on
$	clear_screen
$!
$skip_rover_edit:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ ws "''b_on'"
$ ws "============================================================"
$ ws "============          Laser-Scan  Ltd.          ============"
$ ws "============        LAMPS package "TVES"        ============"
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
$	purge lsl$if:TVES_ACCEPT*.*
$	purge lsl$dti:TVES_ACCEPT*.*
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$tidy_exit:
$	set control=y
$	deassign lsl$frt	! return lsl$frt to startup default
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
