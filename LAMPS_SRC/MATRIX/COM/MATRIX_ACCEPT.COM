$!
$!	ver_status=f$verify(0)
$!
$! LAMPS package "MATRIX" acceptance test command procedure.
$!
$! MOD  Ena diagnostics switched off for DTICOMBINE	KMS 01-Oct-1992
$! MOD	Acceptance tests for DTIBLEND added,
$!	 DTITILE tests modified to accommodate this	TJH 09-Jun-1988
$! Author 						DRC 22-Mar-1988
$!	Based on TVES acceptance procedure by       	DRC
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
$ ws "============        LAMPS package MATRIX        ============"
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
$ ws "MATRIX package acceptance tests"
$ ws "''b_of'"
$	ws "... Initialising the package and checking environment"
$	ws " "
$	inquire/nopunc uis "Is graphical output to a VAX workstation ? "
$	if uis then @lsl$com:matrixini u
$	if .not.uis then @lsl$com:matrixini a
$	set noon
$!
$	inq/nop nplanes "Are you using a 4 plane graphics screen ? "
$	graphics_planes=8
$	if nplanes then graphics_planes=4
$
$	Define sys$error nl:
$	Define sys$output nl:
$	Define LSL$FRT	LSL$PUBLIC_ROOT:[MATRIX.ACCEPT]	
$	Define LSL$MATRIX_ACCEPT  LSL$PUBLIC_ROOT:[MATRIX.ACCEPT]	
$!
$	deassign sys$output
$	deassign sys$error
$!
$	in_dti_file1="LSL$MATRIX_ACCEPT:MATRIX_ACCEPT1.DTI"
$	in_dti_file2="LSL$MATRIX_ACCEPT:MATRIX_ACCEPT2.DTI"
$	blend_dti_file1="LSL$MATRIX_ACCEPT:MATRIX_ACCEPTL.DTI"
$	blend_dti_file2="LSL$MATRIX_ACCEPT:MATRIX_ACCEPTR.DTI"
$	copied_blend_dti_file1="LSL$DTI:MATRIX_ACCEPTL.DTI"
$	copied_blend_dti_file2="LSL$DTI:MATRIX_ACCEPTR.DTI"
$	copied_dti_file1="LSL$DTI:MATRIX_ACCEPT1.DTI"
$	copied_dti_file2="LSL$DTI:MATRIX_ACCEPT2.DTI"
$!
$!============================================================================
$! Check the input acceptance test files exist
$!
$	if f$search(blend_dti_file1) .nes. "" then goto blend_dti_file1_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''blend_dti_file1'"
$	ws " "
$	goto tidy_exit
$!
$ blend_dti_file1_ok:
$	if f$search(blend_dti_file2) .nes. "" then goto blend_dti_file2_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''blend_dti_file2'"
$	ws " "
$	goto tidy_exit
$!
$ blend_dti_file2_ok:
$!
$	if f$search(in_dti_file1) .nes. "" then goto in_dti_file1_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''in_dti_file1'"
$	ws " "
$	goto tidy_exit
$!
$ in_dti_file1_ok:
$	if f$search(in_dti_file2) .nes. "" then goto in_dti_file2_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''in_dti_file2'"
$	ws " "
$	goto tidy_exit
$!
$ in_dti_file2_ok:
$	ws " "
$	ws "... Copying acceptance files to working LSL$DTI directory"
$!
$!
$	copy/nolog/noconfirm 'blend_dti_file1' 'copied_blend_dti_file1'
$	if $status then goto check_copied_blend_dti1_ok
$	ws " ''bell'"
$	ws "Failed to copy initial file to LSL$DTI:, tests abandoned."
$	ws "Input file was ''blend_dti_file1'"
$	ws "Output was to ''copied_blend_dti_file1'"
$	ws " "
$	goto tidy_exit
$ check_copied_blend_dti1_ok:
$	copy/nolog/noconfirm 'blend_dti_file2' 'copied_blend_dti_file2'
$	if $status then goto check_copied_blend_dti2_ok
$	ws " ''bell'"
$	ws "Failed to copy initial file to LSL$DTI:, tests abandoned."
$	ws "Input file was ''blend_dti_file2'"
$	ws "Output was to ''copied_blend_dti_file2'"
$	ws " "
$	goto tidy_exit
$ check_copied_blend_dti2_ok:
$	copy/nolog/noconfirm 'in_dti_file1' 'copied_dti_file1'
$	if $status then goto check_copied_dti1_ok
$	ws " ''bell'"
$	ws "Failed to copy initial file to LSL$DTI:, tests abandoned."
$	ws "Input file was ''in_dti_file1'"
$	ws "Output was to ''copied_dti_file1'"
$	ws " "
$	goto tidy_exit
$ check_copied_dti1_ok:
$	copy/nolog/noconfirm 'in_dti_file2' 'copied_dti_file2'
$	if $status then goto check_copied_dti2_ok
$	ws " ''bell'"
$	ws "Failed to copy initial file to LSL$DTI:, tests abandoned."
$	ws "Input file was ''in_dti_file2'"
$	ws "Output was to ''copied_dti_file2'"
$	ws " "
$	goto tidy_exit
$ check_copied_dti2_ok:
$!
$	ws "... All copied data files successfully found"
$	ws " "
$	ws "... Initialisation and environment checks complete"
$	ws " "
$	gosub go_on
$       clear_screen
$!
$! ---------------------------------------------------------------------
$! 	DTIVIEW / DTITILE
$!
$	clear_screen
$	ws "During acceptance, DTITILE is used to produce a single DTI file"
$	ws "from 2 input files that adjoin geographically."
$	ws "The two input files are first viewed in DTIVIEW."
$	ws "The quarter screen and isometric viewing options are used."
$	ws "Following merging, DTIVIEW is again used to view the new"
$	ws "DTI file."
$	ws " "
$	ws " "
$!
$	inquire/nopunc do_dtitile "Carry out acceptance for MATRIX module DTITILE ? "
$	if .not.do_dtitile then goto skip_dtitile
$!	
$	if graphics_planes.eq.4 then goto dtiview_4p1
$	DTIVIEW
ENABLE GRAPHICS
ENABLE DIVIDE
FILEIN MATRIX_ACCEPT1
ISOMETRIC
FILEIN MATRIX_ACCEPT2
ISOMETRIC
WAIT 20
EXIT
$	goto cont1
$
$ dtiview_4p1:
$	DTIVIEW
PLANES 4
ENABLE GRAPHICS
ENABLE DIVIDE
FILEIN MATRIX_ACCEPT1
ISOMETRIC
FILEIN MATRIX_ACCEPT2
ISOMETRIC
WAIT 20
EXIT
$
$ cont1:
$	DTITILE
FILEIN MATRIX_ACCEPT1
FILEIN MATRIX_ACCEPT2
ORIGIN 101 1
FILEOUT MATRIX_ACCEPT
SHOW FILES
GO
$!
$	if graphics_planes.eq.4 then goto dtiview_4p2
$	DTIVIEW
ENABLE GRAPHICS
FILEIN MATRIX_ACCEPT
ISOMETRIC
WAIT 20
EXIT
$	goto skip_dtitile
$!
$dtiview_4p2:
$	DTIVIEW
PLANES 4
ENABLE GRAPHICS
FILEIN MATRIX_ACCEPT
ISOMETRIC
WAIT 20
EXIT
$skip_dtitile:
$	clear_screen
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! 	DTIEDIT
$!
$!	take a copy before going into the editor
$	copy LSL$DTI:MATRIX_ACCEPTL.DTI LSL$DTI:MATRIX_ACCEPT_COPY.DTI
$!
$	ws "DTIEDIT is used to edit a DTI file on a VT100 compatible terminal."
$	ws "Editing is performed interactively using keypad keys "
$	ws " "
$	inquire/nopunc do_DTIEDIT "Carry out acceptance for MATRIX module DTIEDIT ? "
$	if .not.do_dtiedit then goto skip_dtiedit
$!	
$!*****************************************************************************
$!	type the following:
$!      FILE MATRIX_ACCEPT_COPY
$!      SHOW
$!      ORIGIN 1 1 
$!      PRINT 100 100
$!	ENABLE EDIT
$!      CHANGE
$!*****************************************************************************
$!	
$       assign/user TT: SYS$INPUT
$	DTIEDIT
$!
$skip_dtiedit:
$	clear_screen
$!
$!----------------------------------------------------------------------------
$! 	DTIBLEND
$!
$	type sys$input

DTIBLEND is the MATRIX DTI file edge blend utility. It takes as input two
DTI files, in this acceptance test containing terrain elevation models,
and edge matches them to avoid value discontinuities at the matrix adjoining
edge. Before and after blending DTIEDIT is used to view the blended DTI
file edges.


$!
$	inquire/nopunc do_dtiblend -
		"Carry out acceptance for MATRIX module DTIBLEND ? "
$	if .not.do_dtiblend then goto skip_dtiblend
$!
$	type sys$input

The two DTI files to be blended are:
		LSL$DTI:MATRIX_ACCEPTL.DTI   (lies on left side of join)
		LSL$DTI:MATRIX_ACCEPTR.DTI   (lies on right side of join)

$	gosub go_on
$	type sys$input

DTIEDIT is now used to examine the DTI file on the left side of the join.
To do this type the following sequence of commands in response to the
DTIEDIT> prompt:

	FILEIN MATRIX_ACCEPTL
	ORIGIN 80 1
	CHANGE

The edge which is to be blended is on the right of the screen. Take note of a
few x,y,z values along the edge that may be compared with the file resulting
from the blend process. 

Type Ctrl/z (hold down the Ctrl key and type Z) followed by EXIT
to leave DTIEDIT.

$	gosub go_on
$	assign/user TT: sys$input
$	dtiedit
$	clear_screen
$	type sys$input

DTIEDIT is now used to examine the DTI file on the right side of the join.
To do this type the following sequence of commands in response to the
DTIEDIT> prompt:

	FILEIN MATRIX_ACCEPTR
	ORIGIN 1 1
	CHANGE

The edge which is to be blended is on the left of the screen. Take note of a
few x,y,z values along the edge that may be compared with the file resulting
from the blend process. 

Type Ctrl/z (hold down the Ctrl key and type Z) followed by EXIT
to leave DTIEDIT.

$	assign/user TT: sys$input
$	dtiedit
$	clear_screen
$	gosub go_on
$	type sys$input


DTIBLEND will now be used to blend the DTI files to the mean Z-values along the
common edge. 

The results of the blend will be output to:
		LSL$DTI:MATRIX_ACCEPTL_BLENDED.DTI  (lies on left side of join)
		LSL$DTI:MATRIX_ACCEPTR_BLENDED.DTI  (lies on right side of join)


$ DTIBLEND
ENABLE DIAGNOSTICS
BLEND MATRIX_ACCEPTL MATRIX_ACCEPTL_BLENDED
0 0
BLEND MATRIX_ACCEPTR MATRIX_ACCEPTR_BLENDED
2970 0
GO
$	gosub go_on
$	clear_screen
$	clear_screen
$	type sys$input

DTIEDIT is now used to examine the DTI file on the left side of the join.
To do this type the following sequence of commands in response to the
DTIEDIT> prompt:

	FILEIN MATRIX_ACCEPTL_BLENDED
	ORIGIN 80 1
	CHANGE

The edge which has been blended is on the right of the screen. Take note of 
a few x,y,z values that may be compared with the left hand edge of 
LSL$DTI:MATRIX_ACCEPTR_BLENDED.DTI.

Type Ctrl/z (hold down the Ctrl key and type Z) followed by EXIT
to leave DTIEDIT.

$	gosub go_on
$	assign/user TT: sys$input
$	dtiedit
$	clear_screen
$	type sys$input

DTIEDIT is now used to examine the DTI file on the right side of the join.
To do this type the following sequence of commands in response to the
DTIEDIT> prompt:

	FILEIN MATRIX_ACCEPTR_BLENDED
	ORIGIN 1 1
	CHANGE

The edge which has been blended is on the left of the screen. Compare
the DTI values that correspond to the ones noted on the right hand edge of 
LSL$DTI:MATRIX_ACCEPTL_BLENDED.DTI.

Type Ctrl/z (hold down the Ctrl key and type Z) followed by EXIT
to leave DTIEDIT.

$	assign/user TT: sys$input
$	dtiedit
$	clear_screen
$	gosub go_on
$!
$ skip_dtiblend:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! 	DTICOMBINE
$!
$	ws " "
$	ws " "
$	ws "DTCOMBINE is used to combine data values in multiple DTI files"
$	ws "according to a user specified arithmetic expression."
$	ws "In this case, DTICOMBINE is used to determine differences"
$	ws "between the file edited in DTIEDIT, and the unedited version."
$	ws "An output differences file is produced."
$	ws " "
$	ws " "
$	inquire/nopunc do_DTICOMBINE "Carry out acceptance for module DTICOMBINE ? "
$	if .not.do_DTICOMBINE then goto skip_dticombine
$!
$!
$	DTICOMBINE
FILEA MATRIX_ACCEPTL
FILEB MATRIX_ACCEPT_COPY
FILEOUT MATRIX_ACCEPT_DIFFERENCES
WORD = A - B
!! ENABLE DIAGNOSTICS
GO
$!
$!
$skip_dticombine:
$	clear_screen
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! 	DTI2TEXT
$!
$	ws " "
$	ws "DTI2TEXT is used to convert DTI data values to a specified"
$	ws "ASCII format."
$	ws "In this example, it is used to display, on the terminal, values 
$	ws "in the differences produced by DTICOMBINE."
$	ws " "
$	ws " "
$	inquire/nopunc do_DTI2TEXT "Carry out acceptance for MATRIX module DTI2TEXT ? "
$	if .not.do_DTI2TEXT then goto skip_DTI2TEXT
$	DTI2TEXT
FILEIN MATRIX_ACCEPT_DIFFERENCES
UNITS MAT
WIN 1 1 50 50
ENABLE DIAG
ENABLE NINT
FORMAT 16I5
FILEOUT LSL$DTI:MATRIX_ACCEPT.DAT
CONVERT
$!
TYPE LSL$DTI:MATRIX_ACCEPT.DAT
$!
$skip_DTI2TEXT:
$	clear_screen
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$	ws " "
$	ws "DTIROTATE is used to rotate a DTI file"
$	ws "In this example, the DTI file is rotated by 90 degrees, and
$	ws "no mirroring operation is performed."
$	ws " "
$	ws " "
$! 	DTIROTATE
$!
$	ws " "
$	inquire/nopunc do_DTIROTATE "Carry out acceptance for MATRIX module DTIROTATE ? "
$	if .not.do_DTIROTATE then goto skip_DTIROTATE
$	DTIROTATE
FILEIN MATRIX_ACCEPT_COPY
DISABLE MIRROR
ENABLE ROTATE
FILEOUT MATRIX_ACCEPT_ROT
GO
$!
$!************************************************************************
$!      FILE MATRIX_ACCEPT_ROT
$!      SHOW
$!      ORIGIN 1 1 
$!      PRINT 100 100
$!      CHANGE
$!************************************************************************
$!	
$	clear_screen
$	gosub go_on
$       assign/user TT: SYS$INPUT
$       DTIEDIT
$skip_dtirotate:
$	clear_screen
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! 	DTIPATCH and DTICONVERT
$!
$	ws " "
$	inquire/nopunc do_rover "Carry out acceptance for module DTIPATCH ? "
$	if .not.do_rover then goto skip_dtipatch
$!
$!************************************************************************
$!
$!	MATRIX_ACCEPT_ROT
$!	cr
$!	cr
$!	cr
$!	cr
$!	5
$!	5
$!	cr
$!	cr
$!
$!************************************************************************
$	ws " "
$	ws "DTIPATCH is used to edit DTI header fields."
$	ws "In this example, the x and y grid intervals are changed."
$	ws " "
$	ws " "
$	assign/user TT: SYS$INPUT
$	DTIPATCH
$!
$
$skip_DTIPATCH:
$	clear_screen
$	ws " "
$	inquire/nopunc do_DTICONVERT "Carry out acceptance for module DTICONVERT ? "
$	if .not.do_DTICONVERT then goto skip_dtiCONVERT
$!
$!-----------------------------------------------------------------------
$!      convert scratch.dti from word to real
$!      MATRIX_ACCEPT_ROT
$!	MATRIX_ACCEPT_REAL
$!	LSLA
$!	32
$!	REAL
$!
$!-----------------------------------------------------------------------
$	ws " "
$	ws "DTICONVERT is used to convert between different DTI header
$	ws "header types, and to convert between different data types."
$	ws "In this example, word data contained in the input file are"
$	ws "converted to floating point values."
$	ws " "
$	ws " "
$	assign/user TT: SYS$INPUT
$	DTICONVERT
$!
$!
$!------------------------------------------------------------------------
$skip_DTICONVERT:
$	clear_screen
$	ws " "
$	inquire/nopunc do_VIEW "View the converted matrix using DTIEDIT ? "
$	if .not.do_VIEW then goto skip_view
$!
$!	
$!-----------------------------------------------------------------------
$!      convert scratch.dti from word to real
$!      FILE MATRIX_ACCEPT_REAL
$!	UNITS METRES
$!	SHOW
$!	CHANGE
$!
$!-----------------------------------------------------------------------
$       assign/user TT: SYS$INPUT
$	DTIEDIT
$!
$!
$skip_view:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! 	DTIVIEW - main acceptance
$!
$	clear_screen
$	ws " "
$	inquire/nopunc do_dtiview "Carry out acceptance for DTIVIEW ? "
$	if .not.do_dtiview then goto skip_dtiview
$	if graphics_planes.eq.4 then goto dtiview_4p3
$	DTIVIEW
ENABLE GRAPHICS
FILEIN MATRIX_ACCEPT1
ISOMETRIC
WAIT 20
CLEAR
ENABLE DIVIDE
ISOMETRIC
PHI 0
ISOMETRIC
THETA -50
PHI 45
ISOMETRIC
DIRECTION N
ISOMETRIC
WAIT 20
DISABLE DIVIDE
CLEAR
SET DEFAULT VIEW
SHOW VIEW
ZSTEP 200
ISOMETRIC
LEGEND POSITION 0.1 0.6
DRAW LEGEND
WAIT 20
ZLIMITS 0 500
CLEAR
ISOMETRIC
LABEL POSITION 0.4 0.1
LABEL SIZE 2
DRAW LEGEND
DRAW LABEL Isometric view of Loch Leven
WAIT 20
CLEAR
ZLIMITS 0 833
ZSTEP 80
ENABLE FISHNET
DIRECTION E
PERSPECTIVE
WAIT 20
CLEAR
ENABLE DIVIDE
PROFILE 1 1 1 20
PROFILE 1 1 40 40
PROFILE 30 30 45 20
PROFILE 10 4 50 30
WAIT 20
EXIT
$	
$	goto cont3
$ dtiview_4p3:
$	DTIVIEW
PLANES 4
ENABLE GRAPHICS
FILEIN MATRIX_ACCEPT1
ISOMETRIC
WAIT 20
CLEAR
ENABLE DIVIDE
ISOMETRIC
PHI 0
ISOMETRIC
THETA -50
PHI 45
ISOMETRIC
DIRECTION N
ISOMETRIC
WAIT 20
DISABLE DIVIDE
CLEAR
SET DEFAULT VIEW
SHOW VIEW
ZSTEP 200
ISOMETRIC
LEGEND POSITION 0.1 0.6
DRAW LEGEND
WAIT 20
ZLIMITS 0 500
CLEAR
ISOMETRIC
LABEL POSITION 0.4 0.1
LABEL SIZE 2
DRAW LEGEND
DRAW LABEL Isometric view of Loch Leven
WAIT 20
CLEAR
ZLIMITS 0 833
ZSTEP 80
ENABLE FISHNET
DIRECTION E
PERSPECTIVE
WAIT 20
CLEAR
ENABLE DIVIDE
PROFILE 1 1 1 20
PROFILE 1 1 40 40
PROFILE 30 30 45 20
PROFILE 10 4 50 30
WAIT 20
EXIT
$ cont3:
$	gosub go_on
$	clear_screen
$!
$ skip_dtiview:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ ws "''b_on'"
$ ws "============================================================"
$ ws "============          Laser-Scan  Ltd.          ============"
$ ws "============        LAMPS package MATRIX        ============"
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
$	purge lsl$dti:MATRIX_ACCEPT*.*
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$tidy_exit:
$	set control=y
$	deassign lsl$frt	! return lsl$frt to startup default
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
