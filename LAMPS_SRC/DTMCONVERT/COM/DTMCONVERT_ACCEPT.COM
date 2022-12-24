$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-10-15 12:13:26.000000000 +0100
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
$! LAMPS package "DTMCONVERT" acceptance test command procedure.
$!
$! Author 					TJH	25-Jan-1988
$!
$! Amended to run DTI2DTED and DTED2DTI		FJB	15-June-1988
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
$ 	bell = bel+bel			! ding ding
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
$ ws "============          Laser-Scan  Ltd.          ============"
$ ws "============      LAMPS package DTMCONVERT      ============"
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
$! Defining the package symbols and setting up logical names.
$!
$ ws " "
$ ws "''b_on'"
$ ws "DTMCONVERT package acceptance tests"
$ ws "''b_of'"
$	ws "... Initialising the package and checking environment"
$	ws " "
$	ws " "
$	if f$type(DTED2DTI).eqs."" then @lsl$com:DTMCONVERTini q
$	if f$type(IDIFFERENCE).eqs."" then @lsl$com:IMPini q
$	if f$type(DTICOMBINE).eqs."" then @lsl$com:MATRIXini "" q
$	set noon
$!
$	Define LSL$DTMCONVERT_ACCEPT  LSL$PUBLIC_ROOT:[DTMCONVERT.ACCEPT]
$	ws " "
$!
$!============================================================================
$! Get the magtape device and check it
$!
$	Type Sys$Input:

These tests require use of a magtape drive for preparation of the DTED magtape
dataset. You will be asked for the device name of a suitable drive, which
should be available with a write enabled, scratch magtape loaded. The name 
should be specified complete with the final ":", eg MUA0:, MSA1: or MUB0:.

$	Inquire/nopunc magdev "Device name for magtape device [MUB0:] ?  "
$	if magdev.eqs."" then magdev="MUB0:"
$	device=f$parse(magdev,"sys$disk:",,"device","no_conceal")
$	if device.eqs."" then goto no_such_dev
$	exists=f$getdvi(device,"exists")
$	if .not.exists then goto no_such_dev
$	class=f$getdvi(device,"devclass")
$	if class.ne.2 then goto not_tape
$	goto tape_device
$no_such_dev:
$	ws " ''bell'"
$	ws "Specified magtape device could not be found."
$	ws "	Device name was ''magdev'"
$	ws " "
$	goto tidy_exit
$not_tape:
$	ws " ''bell'"
$	ws "Specified device is not magtape device."
$	ws "	Device name was ''magdev'"
$	ws " "                 
$	goto tidy_exit
$tape_device:
$	ws " "
$	ws "Magtape Device ''device' will be used."
$	ws " "
$	ws "Please ensure that it has a scratch magtape loaded."
$	ws "This will receive the DTED data."
$	ws " "
$!
$!============================================================================
$! Check the input acceptance test files exist
$!
$	in_DTI_file="LSL$DTMCONVERT_ACCEPT:DTMCONVERT_ACCEPT.DTI"
$	copied_DTI_file="LSL$DTI:DTMCONVERT_ACCEPT_COPY.DTI"
$	in_IFF_file="LSL$DTMCONVERT_ACCEPT:DTMCONVERT_ACCEPT.IFF"
$	copied_IFF_file="LSL$IF:DTMCONVERT_ACCEPT_COPY.IFF"
$	if f$search(in_iff_file) .nes. "" then goto iff_file_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''in_iff_file'"
$	ws " "
$	goto tidy_exit
$!
$ iff_file_ok:
$	if f$search(in_dti_file) .nes. "" then goto dti_file_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''in_dti_file'"
$	ws " "
$	goto tidy_exit
$!
$ dti_file_ok:
$	ws "... Input test data files successfully found"
$	ws "... Input files were:
$	ws "          ''in_iff_file'"
$	ws "          ''in_dti_file'"
$	ws " "
$	ws "... Copying them to working LSL$IF and LSL$DTI directories"
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
$	copy/log/noconfirm 'in_dti_file' 'copied_dti_file'
$	if $status then goto check_copied_dti_ok
$	ws " ''bell'"
$	ws "Failed to copy initial file to LSL$IF:, tests abandoned."
$	ws "Input file was ''in_dti_file'"
$	ws "Output was to ''copied_dti_file'"
$	ws " "
$	goto tidy_exit
$ check_copied_dti_ok:
$!
$	ws "... All copied data files successfully found"
$	ws " "
$	ws "... Initialisation and environment checks complete"
$!
$!============================================================================
$!
$ ws " "
$ ws "''b_on'"
$ ws "DTMCONVERT package acceptance tests"
$ ws "''b_of'"
$	Type Sys$input:

This acceptance procedure will use two input files:

A) in Laser-Scan DTI format, containing DTED elevation data.

B) in Laser-Scan IFF format, containing DTED Header (DSI) and Accuracy data.

$	gosub go_on
$	Type Sys$input:

Acceptance will take place in 6 phases:

1) The initial files will be read and merged to a become a source DTI file
using the DTMCONVERT module DTEDIFF.

2) This source DTI file will be converted to DTED offline format on magtape,
using DTMCONVERT module DTI2DTED. 

3) The resultant DTED tape will be read back to a second disk DTI file using
DTED2DTI. 

4) The matrix data in the resultant DTI file will be compared with the source
DTI data using the DTICOMBINE utility of the MATRIX package. 

5) The utility DTEDIFF will be used again to extract the ACC accuracy subregion
and header information from the resultant DTI file into an IFF file.

6) The extracted IFF file will be compared with the initial IFF file using the
IDIFFERENCE utility of the IMP package. 

$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	gosub go_on
$!
$	Type Sys$input:

	Phase 1

The initial files will be read and merged to a become a source DTI file
using the DTMCONVERT module DTEDIFF.

$!
$	gosub go_on
$	DTEDIFF/LOG/MERGE 'copied_DTI_file' 'copied_IFF_file'
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	gosub go_on
$!
$	Type Sys$input:

	Phase 2

The source DTI file will be converted to DTED offline format on magtape,
using DTMCONVERT module DTI2DTED. 

$!
$	gosub go_on
$!
$	wd="write datafile"
$	open/write datafile DTMCONVERT_ACCEPT_DTI2DTED.COM
$	wd "$DTI2DTED"
$	wd "ENABLE DIAGNOSTICS"
$	wd "DEVICE ''magdev'"
$	wd "FILEIN DTMCONVERT_ACCEPT_COPY.DTI"
$	wd "ABCDEF"
$	wd "LSLEXAMPLE"
$	wd "EXIT"
$	close datafile
$!
$	ALLOCATE 'magdev'
$	MOUNT/FOREIGN 'magdev'
$!
$	@DTMCONVERT_ACCEPT_DTI2DTED.COM
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	gosub go_on
$!
$	Type Sys$input:

	Phase 3

The resultant DTED tape will be read back to a second disk DTI file using
DTED2DTI. 

$!
$	gosub go_on
$!
$	wd="write datafile"
$	open/write datafile DTMCONVERT_ACCEPT_DTED2DTI.COM
$	wd "$DTED2DTI"
$	wd "ENABLE DIAGNOSTICS"
$	wd "DEVICE ''magdev'"
$	wd "REWIND"
$	wd "FILEOUT DTMCONVERT_ACCEPT_IMPORT.DTI"
$	wd "MANUSCRIPT 1"
$	wd "EXIT"
$	close datafile
$!
$	@DTMCONVERT_ACCEPT_DTED2DTI.COM
$!
$	DISMOUNT/NOUNLOAD 'magdev'
$	DEALLOCATE 'magdev'
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	gosub go_on
$!
$	Type Sys$input:

	Phase 4

The matrix data in the resultant DTI file will be compared with the source
DTI data using the DTICOMBINE utility of the MATRIX package. 

$!
$	gosub go_on
$!
$	DTICOMBINE
FILEA DTMCONVERT_ACCEPT_COPY.DTI
FILEB DTMCONVERT_ACCEPT_IMPORT.DTI
FILEOUT DTMCONVERT_ACCEPT_COMB.DTI
WORD=A-B
!ENABLE DIAGNOSTICS
GO
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	gosub go_on
$!
$	Type Sys$input:

	Phase 5

The utility DTEDIFF will be used again to extract the ACC accuracy subregion
and header information from the resultant DTI file into an IFF file.

$!
$	gosub go_on
$	DTEDIFF/LOG/NOMERGE  DTMCONVERT_ACCEPT_IMPORT.DTI DTMCONVERT_ACCEPT_IMPORT.IFF
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	gosub go_on
$!
$	Type Sys$input:

	Phase 6

The extracted IFF file will be compared with the initial IFF file using the
IDIFFERENCE utility of the IMP package. 

$!
$	gosub go_on
$	IDIFFERENCE 'Copied_IFF_file' DTMCONVERT_ACCEPT_IMPORT.IFF
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	gosub go_on
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ ws "''b_on'"
$ ws "============================================================"
$ ws "============         Laser-Scan  Ltd.           ============"
$ ws "============     LAMPS package DTMCONVERT       ============"
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
$	purge/nolog lsl$if:DTMCONVERT_ACCEPT*.*
$	purge/nolog lsl$dti:DTMCONVERT_ACCEPT*.*
$	delete DTMCONVERT_ACCEPT_DTED2DTI.COM;*
$	delete DTMCONVERT_ACCEPT_DTI2DTED.COM;*
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
$!
