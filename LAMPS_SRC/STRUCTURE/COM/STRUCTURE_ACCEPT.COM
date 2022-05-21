$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-09-30 16:16:38.000000000 +0100
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
$! LAMPS package "STRUCTURE" acceptance test command procedure.
$!
$! /MERGE file now used as input to /LPJOIN process!	TJH	19-Oct-1987
$! Author (and on my birthday too)			PGH	20-Aug-1987
$!
$! Set things up
$!
$	set noon
$	ws="write sys$output"
$	esc[0,7]=27
$	bel[0,7]=7
$	b_on = esc+"[0m"+esc+"[1m" 	! bold on
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
$!
$lets_go:
$!
$ ws "''b_on'"
$ ws "============================================================"
$ ws "============          Laser-Scan Ltd.           ============"
$ ws "============      LAMPS package STRUCTURE       ============"
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
$	if f$type(ILINK).eqs."" then @lsl$com:structureini q
$!	if f$type(LITES2).eqs."" then @lsl$com:lites2ini
$	@lsl$com:lites2ini
$	set noon
$!
$	Define LSL$STRUCTURE_ACCEPT	LSL$PUBLIC_ROOT:[STRUCTURE.ACCEPT]	
$	in_file="LSL$STRUCTURE_ACCEPT:STRUCTURE_ACCEPT.START_IFF"
$	out_file="LSL$IF:STRUCTURE_ACCEPT.IFF"
$	frt_file="LSL$STRUCTURE_ACCEPT:STRUCTURE_ACCEPT.FRT"
$	sri_file="LSL$STRUCTURE_ACCEPT:STRUCTURE_ACCEPT.SRI"
$	tri_file="LSL$STRUCTURE_ACCEPT:STRUCTURE_ACCEPT.TRI"
$!
$! Check the input acceptance test files exist
$!
$	if f$search(in_file) .nes. "" then goto file_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''in_file'"
$	ws " "
$	goto tidy_exit
$!
$file_ok:
$	ws "... Input test data IFF file successfully found"
$	ws "... Input file was ''in_file'"
$	ws " "
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
$	ws "... Copied data file sucessfully found"
$	ws "... File was ''out_file'"
$	ws " "
$	ws "... Initialisation and environment checks complete"
$	device  = f$parse("''search_file'",,,"DEVICE")
$	dirnam  = f$parse("''search_file'",,,"DIRECTORY")
$	filenam = f$parse("''search_file'",,,"NAME")
$	iff_file = device+dirnam+filenam+".IFF"
$	llj_file = device+dirnam+filenam+".LLJ"
$	mer_file = device+dirnam+filenam+".MER"
$	lpj_file = device+dirnam+filenam+".LPJ"
$	ppj_file = device+dirnam+filenam+".PPJ"
$	brk_file = device+dirnam+filenam+".BRK"
$	ifj_file = device+dirnam+filenam+".IFJ"
$	ws " "
$	gosub go_on
$	ws " "
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	Type Sys$input:

In these tests, the original data file contains vector "spaghetti" representing
some soil type polygons and a roads overlay. The acceptance procedure steps
through geometry idealisation and structure formation using ILINK in 6 stages. 

	(1) LLJOIN - to align coincident lines.
	(2) MERGE  - to amalgamate coincident lines.
	(3) LPJOIN - to extend or truncate line ends to meet at T junctions.
	(4) PPJOIN - to form unique junction points at line ends.
	(5) BREAK  - to break crossing lines.
	(6) STRUCT - to generate IFF (link/node) junction structure.

$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Use LITES2 to show off the source data
$!
$	ws " "
$	inquire/nopunc use_lites2 "Do you want to use LITES2 to examine the IFF file ?  "
$	if .not.use_lites2 then goto skip_lites_a
$ 	ass/user sys$command sys$input
$ 	lites2 frt LSL$STRUCTURE_ACCEPT:STRUCTURE_ACCEPT#disable table#iff 'iff_file'
$!
$	gosub go_on
$!
$skip_lites_a:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ ws " "
$ ws "''b_on'"
$ ws "STRUCTURE package module ILINK tests"
$ ws "''b_of'"
$ ws "ILINK is used 6 times, the current task is shown in ''b_on'bold''b_of':"
$ ws " "
$ ws b_on,-
     "           (1) LLJOIN - to align coincident lines",b_of
$ ws "           (2) MERGE  - to amalgamate coincident lines"
$ ws "           (3) LPJOIN - to extend or truncate line ends to meet at T junctions"
$ ws "           (4) PPJOIN - to form unique junction points at line ends"
$ ws "           (5) BREAK  - to break crossing lines"
$ ws "           (6) STRUCT - to generate IFF (link/node) junction structure"
$ ws "''b_on' "
$ ws "The input file is  ''iff_file' "
$ ws " "
$ ws "The output file is ''llj_file' "
$ ws "''b_of'"
$!
$	gosub go_on
$!
$	set verify
$	ILINK/LLJOIN/BPF=3/JNTOL=40/LITES2=STRUCTURE_ACCEPT_LLJ -
		'iff_file' -
		'llj_file' -
		/FCP=LSL$STRUCTURE_ACCEPT:FCP1
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$	ws " "
$	inquire/nopunc use_lites2 "Do you want to use LITES2 to examine the IFF file ?  "
$	if .not.use_lites2 then goto skip_lites_b
$ 	ass/user sys$command sys$input
$ 	lites2 frt LSL$STRUCTURE_ACCEPT:STRUCTURE_ACCEPT#disable table#iff 'llj_file'
$!
$	gosub go_on
$!
$skip_lites_b:
$!
$!
$ ws " "
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ ws " "
$ ws "''b_on'"
$ ws "STRUCTURE package module ILINK tests"
$ ws "''b_of'"
$ ws "ILINK is used 6 times, the current task is shown in ''b_on'bold''b_of':"
$ ws " "
$ ws "           (1) LLJOIN - to align coincident lines"
$ ws b_on,-
     "           (2) MERGE  - to amalgamate coincident lines",b_of
$ ws "           (3) LPJOIN - to extend or truncate line ends to meet at T junctions"
$ ws "           (4) PPJOIN - to form unique junction points at line ends"
$ ws "           (5) BREAK  - to break crossing lines"
$ ws "           (6) STRUCT - to generate IFF (link/node) junction structure"
$ ws "''b_on' "
$ ws "The input file is  ''llj_file' "
$ ws " "
$ ws "The output file is ''mer_file' "
$ ws "''b_of'"
$!
$	gosub go_on
$!
$	set verify
$	ILINK/MERGE/BPF=3/LITES2=STRUCTURE_ACCEPT_MER -
		'llj_file' -
		'mer_file' -
		/FCC=LSL$STRUCTURE_ACCEPT:FCC -
		/FCP=LSL$STRUCTURE_ACCEPT:FCP1
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$	ws " "
$	inquire/nopunc use_lites2 "Do you want to use LITES2 to examine the IFF file ?  "
$	if .not.use_lites2 then goto skip_lites_c
$ 	ass/user sys$command sys$input
$ 	lites2 frt LSL$STRUCTURE_ACCEPT:STRUCTURE_ACCEPT#disable table#iff 'mer_file'
$!
$	gosub go_on
$!
$skip_lites_c:
$!
$!
$ ws " "
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ ws " "
$ ws "''b_on'"
$ ws "STRUCTURE package module ILINK tests"
$ ws "''b_of'"
$ ws "ILINK is used 6 times, the current task is shown in ''b_on'bold''b_of':"
$ ws " "
$ ws "           (1) LLJOIN - to align coincident lines "
$ ws "           (2) MERGE  - to amalgamate coincident lines"
$ ws b_on,-
     "           (3) LPJOIN - to extend or truncate line ends to meet at T junctions",b_of
$ ws "           (4) PPJOIN - to form unique junction points at line ends"
$ ws "           (5) BREAK  - to break crossing lines"
$ ws "           (6) STRUCT - to generate IFF (link/node) junction structure"
$ ws "''b_on' "
$ ws "The input file is  ''mer_file' "
$ ws " "
$ ws "The output file is ''lpj_file' "
$ ws " "
$ ws "''b_of'"
$!
$	gosub go_on
$!
$	set verify
$	ILINK/LPJOIN/LITES2=STRUCTURE_ACCEPT_LPJ/EXTOL=50/JNTOL=50 -
		'mer_file' -
		'lpj_file' -
		/FCP=LSL$STRUCTURE_ACCEPT:FCP2
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$	ws " "
$	inquire/nopunc use_lites2 "Do you want to use LITES2 to examine the IFF file ?  "
$	if .not.use_lites2 then goto skip_lites_d
$ 	ass/user sys$command sys$input
$ 	lites2 frt LSL$STRUCTURE_ACCEPT:STRUCTURE_ACCEPT#disable table#iff 'lpj_file'
$!
$	gosub go_on
$!
$skip_lites_d:
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ ws " "
$ ws "''b_on'"
$ ws "STRUCTURE package module ILINK tests"
$ ws "''b_of'"
$ ws "ILINK is used 6 times, the current task is shown in ''b_on'bold''b_of':"
$ ws " "
$ ws "           (1) LLJOIN - to align coincident lines "
$ ws "           (2) MERGE  - to amalgamate coincident lines"
$ ws "           (3) LPJOIN - to extend or truncate line ends to meet at T junctions"
$ ws b_on,-
     "           (4) PPJOIN - to form unique junction points at line ends",b_of
$ ws "           (5) BREAK  - to break crossing lines"
$ ws "           (6) STRUCT - to generate IFF (link/node) junction structure"
$ ws "''b_on'"
$ ws "The input file is  ''lpj_file' "
$ ws " "
$ ws "The output file is ''ppj_file' "
$ ws " "
$ ws "''b_of'"
$ 	ws " "
$	gosub go_on
$	set verify
$	ILINK/PPJOIN/LITES2=STRUCTURE_ACCEPT_PPJ/EXTOL=70/JNTOL=50 -
		'lpj_file' -
		'ppj_file' -
		/FCP=LSL$STRUCTURE_ACCEPT:FCP3
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$	ws " "
$	inquire/nopunc use_lites2 "Do you want to use LITES2 to examine the IFF file ?  "
$	if .not.use_lites2 then goto skip_lites_e
$ 	ass/user sys$command sys$input
$ 	lites2 frt LSL$STRUCTURE_ACCEPT:STRUCTURE_ACCEPT#disable table#iff 'ppj_file'
$!
$	gosub go_on
$!
$skip_lites_e:
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ ws "''b_on'"
$ ws "STRUCTURE package module ILINK tests"
$ ws "''b_of'"
$ ws "ILINK is used 6 times, the current task is shown in ''b_on'bold''b_of':"
$ ws " "
$ ws "           (1) LLJOIN - to align coincident lines "
$ ws "           (2) MERGE  - to amalgamate coincident lines"
$ ws "           (3) LPJOIN - to extend or truncate line ends to meet at T junctions"
$ ws "           (4) PPJOIN - to form unique junction points at line ends"
$ ws b_on,-
     "           (5) BREAK  - to break crossing lines",b_of
$ ws "           (6) STRUCT - to generate IFF (link/node) junction structure"
$ ws "''b_on' "
$ ws "The input file is  ''ppj_file' "
$ ws " "
$ ws "The output file is ''brk_file' "
$ ws " "
$ ws "''b_of'"
$!
$	gosub go_on
$!
$	set verify
$	ILINK/BREAK -
		'ppj_file' -
		'brk_file' -
		/FCP=LSL$STRUCTURE_ACCEPT:FCP4
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$	ws " "
$	inquire/nopunc use_lites2 "Do you want to use LITES2 to examine the IFF file ?  "
$	if .not.use_lites2 then goto skip_lites_f
$ 	ass/user sys$command sys$input
$ 	lites2 frt LSL$STRUCTURE_ACCEPT:STRUCTURE_ACCEPT#disable table#iff 'brk_file'
$!
$	gosub go_on
$!
$skip_lites_f:
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ structure_it:
$ ws " "
$ ws "''b_on'"
$ ws "STRUCTURE package module ILINK tests"
$ ws "''b_of'"
$ ws "ILINK is used 6 times, the current task is shown in ''b_on'bold''b_of':"
$ ws " "
$ ws "           (1) LLJOIN - to align coincident lines "
$ ws "           (2) MERGE  - to amalgamate coincident lines"
$ ws "           (3) LPJOIN - to extend or truncate line ends to meet at T junctions"
$ ws "           (4) PPJOIN - to form unique junction points at line ends"
$ ws "           (5) BREAK  - to break crossing lines"
$ ws b_on,-
     "           (6) STRUCT - to generate IFF (link/node) junction structure",b_of
$ ws "''b_on'"
$ ws "The input file is  ''brk_file' "
$ ws " "
$ ws "The output file is ''ifj_file' "
$ ws "''b_of'"
$ ws " "
$	gosub go_on
$!
$	set verify
$	ILINK/STRUCTURE -
		'brk_file' -
		'ifj_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$!
$	ws " "
$	inquire/nopunc use_lites2 "Do you want to use LITES2 to examine the IFF file ?  "
$	if .not.use_lites2 then goto skip_lites_g
$ 	ass/user sys$command sys$input
$ 	lites2 frt LSL$STRUCTURE_ACCEPT:STRUCTURE_ACCEPT#disable table#iff 'ifj_file'
$!
$	gosub go_on
$!
$skip_lites_g:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ ws "''b_on'"
$ ws "============================================================"
$ ws "============         Laser-Scan Ltd.            ============"
$ ws "============     LAMPS package STRUCTURE        ============"
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
$	purge lsl$if:structure_accept*.*
$	purge lsl$lites2cmd:structure_accept*.*
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
