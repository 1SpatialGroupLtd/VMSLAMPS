$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-10-26 12:44:24.000000000 +0000
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
$	ver_status=f$verify(0)
$!
$! LAMPS CONVERT package:
$!			  "IFFKERNCAM" acceptance test command procedure.
$!
$! Author 					TJH	25-Jan-1988
$! Amended to run DTI2DTED and DTED2DTI		FJB	15-June-1988
$! Amended to run I2MGD and MGD2I		FJB	25-July-1988
$! Amended to run I2KERNCAM and KERNCAM2I	FJB	22-Sept-1988
$!
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
$ ws "============    Laser-Scan Laboratories Ltd.    ============"
$ ws "============       LAMPS package CONVERT        ============"
$ ws "============         Module IFFKERNCAM          ============"   
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
$ ws " "
$ ws "''b_on'"
$ ws "CONVERT package acceptance tests"
$ ws "''b_of'"
$	ws "... Initialising the package and checking environment"
$	ws " "
$	ws " "
$	if f$type(I2KERNCAM).eqs."" then @lsl$com:CONVERTini q
$	if f$type(IDIFFERENCE).eqs."" then @lsl$com:IMPini q
$	set noon
$!
$	Define LSL$CONVERT_ACCEPT  LSL$PUBLIC_ROOT:[CONVERT.ACCEPT]
$	Define LSL$FRT_ACDMAX      50
$	ws " "
$!
$!============================================================================
$! Check the input acceptance test files exist
$!
$! Reference originals:
$	in_IFF_file="LSL$CONVERT_ACCEPT:IFFKERNCAM_ACCEPT.IFF"
$	in_FRT_file="LSL$CONVERT_ACCEPT:KERN_CAM.FRT"
$!
$! Working copies:
$	copied_IFF_file="LSL$IF:IFFKERNCAM_ACCEPT_COPY.IFF"
$	copied_FRT_file="LSL$FRT:IFFKERNCAM_ACCEPT_COPY.FRT"
$!
$! Converted into:
$	out_KERNCAM_file="SYS$DISK:[]IFFKERNCAM_ACCEPT_CONVERT.DAT"
$!
$! and back to:
$	out_IFF_file="LSL$IF:IFFKERNCAM_ACCEPT_OUT.IFF"
$!
$	if f$search(in_IFF_file) .nes. "" then goto iff_file_ok
$	ws " ''bell'"
$ 	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''in_iff_file'"
$	ws " "
$	goto tidy_exit
$!
$ iff_file_ok:
$	if f$search(in_FRT_file) .nes. "" then goto frt_file_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''in_FRT_file'"
$	ws " "
$	goto tidy_exit
$!
$ frt_file_ok:
$	ws "... Input test data files successfully found"
$	ws "... Input files were:
$	ws "          ''in_iff_file'"
$	ws "          ''in_frt_file'"
$	ws " "
$	ws "... Copying to working LSL$IF and LSL$FRT directories"
$!
$!============================================================================
$! Create new files for manipulation during the tests
$!
$	copy/log/noconfirm 'in_iff_file' 'copied_iff_file'
$	if $status then goto check_copied_iff_ok
$	ws " ''bell'"
$	ws "Failed to copy initial file to LSL$IF:, tests abandoned."
$	ws "Input file was ''in_iff_file'"
$	ws "Output was to ''copied_iff_file'"
$	ws " "
$	goto tidy_exit
$ check_copied_iff_ok:
$!                                                    
$	copy/log/noconfirm 'in_frt_file' 'copied_frt_file'
$	if $status then goto check_copied_frt_ok
$	ws " ''bell'"
$	ws "Failed to copy initial file to LSL$IF:, tests abandoned."
$	ws "Input file was ''in_frt_file'"
$	ws "Output was to ''copied_frt_file'"
$	ws " "
$	goto tidy_exit
$ check_copied_frt_ok:
$!
$	ws " "
$	ws "... All copied data files sucessfully found"
$	ws " "
$	ws "... Initialisation and environment checks complete"
$!
$!============================================================================
$!
$ ws " "
$ ws "''b_on'"
$ ws "CONVERT package acceptance tests"
$ ws "''b_of'"
$	Type Sys$input:

This acceptance procedure will use two input files:

A) in Laser-Scan IFF format, containing a variety of graphical features.

B) a Laser-Scan FRT file, containing a KERN CAM ACD table.

$	gosub go_on
$	Type Sys$input:

Acceptance will take place in 3 phases:

1) The source IFF file will be converted to a KERN CAM formatted disc file,
using CONVERT module I2KERNCAM. 

2) The resultant KERN CAM disc file will be read back to a second IFF file
using CONVERT utility KERNCAM2I.

3) The second IFF file will be compared with the initial IFF file using the
IDIFFERENCE utility of the IMP package. 

$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	gosub go_on
$!
$	Type Sys$input:

	Phase 1


The source IFF file will be converted to KERN CAM format on disc, using 
CONVERT module I2KERNCAM. The FRT file is used by I2KERNCAM for this conversion.

$!
$	gosub go_on
$!
$	set ver
$ I2KERNCAM/DIAG/FRT='copied_frt_file' 'copied_iff_file' 'out_KERNCAM_file'
$	set nover
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	gosub go_on
$!
$	Type Sys$input:

	Phase 2

The resultant KERN CAM disc file will be read back to a second disk IFF file
using CONVERT module KERNCAM2I. The FRT file is used by KERNCAM2I for this 
conversion.

$!
$	gosub go_on
$!             
$	set ver
$ KERNCAM2I/FRT='copied_frt_file' 'out_KERNCAM_file' 'out_iff_file'
$	set nover
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	gosub go_on
$!
$	Type Sys$input:

	Phase 3

The extracted IFF file will be compared with the initial IFF file using the
IDIFFERENCE utility of the IMP package. Note that only the History (HI) entry 
and New Section (NS) entry show different dates, and that all features are identical. 

$!
$	gosub go_on
$!
$	set ver
$ IDIFFERENCE/FRT='copied_frt_file' 'copied_iff_file' 'out_iff_file'
$	set nover
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	gosub go_on
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ ws "''b_on'"
$ ws "============================================================"
$ ws "============    Laser-Scan Laboratories Ltd.    ============"
$ ws "============       LAMPS package CONVERT        ============"
$ ws "============         Module IFFKERNCAM          ============"
$ ws "============  Acceptance test command procedure ============"
$ ws "============================================================"
$	date_time=f$time()
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
$	purge/nolog lsl$if:IFFKERNCAM_ACCEPT*.*
$	purge/nolog lsl$frt:IFFKERNCAM_ACCEPT*.*
$	purge/nolog sys$disk:[]IFFKERNCAM_ACCEPT*.*
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$tidy_exit:
$	set control=y
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
