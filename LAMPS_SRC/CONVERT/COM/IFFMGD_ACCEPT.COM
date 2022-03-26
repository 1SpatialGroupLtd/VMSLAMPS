$	ver_status=f$verify(0)
$!
$! LAMPS CONVERT package:
$!			  "IFFMGD" acceptance test command procedure.
$!
$! Author 					TJH	25-Jan-1988
$! Amended to run DTI2DTED and DTED2DTI		FJB	15-June-1988
$! Amended to run I2MGD and MGD2I		FJB	25-July-1988
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
$ ws "============          Module IFFMGD             ============"   
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
$	if f$type(I2MGD).eqs."" then @lsl$com:CONVERTini q
$	if f$type(IDIFFERENCE).eqs."" then @lsl$com:IMPini q
$	set noon
$!
$	Define LSL$CONVERT_ACCEPT  LSL$PUBLIC_ROOT:[CONVERT.ACCEPT]
$	Define LSL$FRT_ACDMAX      200
$	ws " "
$!
$!============================================================================
$! Get the magtape device and check it
$!
$	Type Sys$Input:

These tests require use of a magtape drive for preparation of the MGD77 magtape
dataset. You will be asked for the device name of a suitable drive, which
should be available with a write enabled, scratch magtape loaded. The name 
should be specified complete with the final ":", eg MUA0:, MSA1: or MUB0:.

$	Inquire/nopunc magdev "Device name for magtape device [MUB1:] ?  "
$	if magdev.eqs."" then magdev="MUB1:"
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
$	ws "This will receive the MGD77 data."
$	ws " "
$!
$!============================================================================
$! Check the input acceptance test files exist
$!
$	in_IFF_file="LSL$CONVERT_ACCEPT:IFFMGD_ACCEPT.IFF"
$	in_FRT_file="LSL$CONVERT_ACCEPT:MGD77_ACD_TABLE.FRT"
$	copied_IFF_file="LSL$IF:IFFMGD_ACCEPT_COPY.IFF"
$	copied_FRT_file="LSL$FRT:IFFMGD_ACCEPT_ACD.FRT"
$	out_IFF_file="LSL$IF:IFFMGD_ACCEPT_OUT.IFF"
$	if f$search(in_IFF_file) .nes. "" then goto iff_file_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
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

A) in Laser-Scan IFF format, containing a header feature and data features.

B) a Laser-Scan FRT file, containing a complete MGD77 ACD table.

$	gosub go_on
$	Type Sys$input:

Acceptance will take place in 4 phases:

1) This source IFF file will be converted to MGD77 offline format on magtape,
using CONVERT module I2MGD. 

2) The MGD77 tape will be read by the VMS utility DUMP to confirm a MGD77
format tape has been written. The first 2 blocks will be listed to the terminal

3) The resultant MGD77 tape will be read back to a second disk IFF file
using CONVERT utility MGD2I.

4) The second IFF file will be compared with the initial IFF file using the
IDIFFERENCE utility of the IMP package. 

$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	gosub go_on
$!
$	Type Sys$input:

	Phase 1


The source IFF file will be converted to MGD77 offline format on magtape,
using CONVERT module I2MGD. The FRT file is used by I2MGD for this conversion.

$!
$	gosub go_on
$!
$	ALLOCATE 'magdev'
$	MOUNT/FOREIGN 'magdev'
$!
$	set ver
$ I2MGD/DEVICE='magdev'/REW/FRT='copied_frt_file' 'copied_iff_file'
$	set nover
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	gosub go_on
$!
$	Type Sys$input:

	Phase 2

The MGD77 tape will be read by the VMS utility DUMP to confirm a MGD77
format tape has been written. The first 2 blocks will be listed to the terminal
Use of the HOLD key is reccommended to temporarily halt the listing to allow
easy viewing.

$!
$	gosub go_on
$!
$! get back to BOT
$	DISMOUNT/NOUNLOAD 'magdev'
$	MOUNT/FOREIGN 'magdev'
$	                      
$	DUMP/AS/BLOCKS=(START:1,END:2) 'magdev'
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	gosub go_on
$!
$	Type Sys$input:

	Phase 3

The resultant MGD77 tape will be read back to a second disk IFF file using
using CONVERT module MGD2I. The FRT file is used by MGD2I for this conversion.
Note that a normal warning message will be output indicating that there
is no Data Centre number - this is a U.S. Data Centre private field which is not
written to the MGD77 tape by I2MGD 

$!
$	gosub go_on
$!             
$	set ver
$ MGD2I/DEVICE='magdev'/REW/SEL=1/FRT='copied_frt_file' 'out_iff_file'
$	set nover
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

The extracted IFF file will be compared with the initial IFF file using the
IDIFFERENCE utility of the IMP package. Note that only the HIstory entry
is different and that all features are identical. 

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
$ ws "============     LAMPS package "CONVERT"        ============"
$ ws "============          Module IFFMGD             ============"   
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
$	purge/nolog lsl$if:IFFMGD_ACCEPT*.*
$	purge/nolog lsl$frt:IFFMGD_ACCEPT*.*
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
