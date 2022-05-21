$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-10-01 18:07:34.000000000 +0100
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
$! LAMPS package "POLYGONS" acceptance test command procedure.
$!
$! Ripped off from PGH's STRUCTURE acceptance test file	(and after
$! he had done it on his birthday too!) 		TJH  16-Oct-1987
$!
$! Set things up
$!
$	set noon
$	ff[0,15]==%x0c			! form feed
$	ws="write sys$output"
$	wsff=="write sys$output ff,ff"
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
$ wsff
$ ws "''b_on'"
$ ws "============================================================"
$ ws "============         Laser-Scan  Ltd.          ============"
$ ws "============      LAMPS package POLYGONS        ============"
$ ws "============  Acceptance test command procedure ============"
$ ws "============================================================"
$	date_time=f$time()
$ ws "============  Starting ''date_time'  ============"
$ ws "============================================================"
$ ws "''b_of'"
$ ws " "
$ ws " "
$ ws " "
$ ws " "
$ ws " "
$ ws " "
$	gosub go_on
$!
$!***************************************************************************
$ wsff 
$ ws "''b_on'"
$ ws "POLYGONS package acceptance tests - input data checks"
$ ws "''b_of'"
$!
$! Defining the package symbols and setting up logical names.
$!
$	ws "... Initialising the package and checking environment"
$	ws " "
$	if f$type(POLMERGE).eqs."" then @lsl$com:polygonsini q
$	if f$type(ISELECT).eqs."" then @lsl$com:impini q
$	@lsl$com:lites2ini
$	set noon
$!
$	Define sys$output nl:
$	Define sys$error nl:
$	Define LSL$POLYGONS_ACCEPT	LSL$PUBLIC_ROOT:[POLYGONS.ACCEPT]
$	deassign sys$error
$	deassign sys$output
$	junc_file="LSL$POLYGONS_ACCEPT:POLYGONS_ACCEPT.IFJ"
$	seed_file="LSL$POLYGONS_ACCEPT:POLYGONS_ACCEPT.SEED"
$	defin_file="LSL$POLYGONS_ACCEPT:POLYGONS_ACCEPT.DAT"
$	pmerge_def_file="LSL$POLYGONS_ACCEPT:PMERGE_LOOKUP.DAT"
$	ifj_file="LSL$IF:POLYGONS_ACCEPT.IFJ"
$	out_file="LSL$IF:POLYGONS_ACCEPT.SEED"
$	frt_file="LSL$POLYGONS_ACCEPT:POLYGONS_ACCEPT.FRT"
$	sri_file="LSL$POLYGONS_ACCEPT:POLYGONS_ACCEPT.SRI"
$	tri_file="LSL$POLYGONS_ACCEPT:POLYGONS_ACCEPT.TRI"
$!
$! Check the input acceptance test files exist
$!
$	if f$search(junc_file) .nes. "" then goto a1
$	ws " ''bell'"
$	ws "Initial junction structured links file could not be found, tests abandoned."
$	ws "Input file was ''junc_file'"
$	ws " "
$	goto tidy_exit
$ a1:	if f$search(seed_file) .nes. "" then goto file_ok
$	ws " ''bell'"
$	ws "Initial seed point file could not be found, tests abandoned."
$	ws "Input file was ''seed_file'"
$	ws " "
$	goto tidy_exit
$!
$file_ok:
$	ws " "
$	ws "... Input junction structured links file successfully found"
$	ws "... Input junction structured links file was : "
$	ws "...			''junc_file'"
$	ws "... Copying junction structured file to working LSL$IF directory"
$!
$! Create a file ".SEED" for manipulation during the tests
$!
$	copy/noconfirm 'junc_file' 'ifj_file'
$	if $status then goto ifdir_ok1
$	ws " ''bell'"
$	ws "Failed to copy initial file to LSL$IF:, tests abandoned."
$	ws "Input file was ''junc_file'"
$	ws "Output was to ''ifj_file'"
$	ws " "
$	goto tidy_exit
$ifdir_ok1:
$	search_file=f$search(ifj_file)
$	if $status then goto ifj_file_ok
$	ws " ''bell'"
$	ws "Failed to find copied file in LSL$IF:, tests abandoned."
$	ws "File was ''ifj_file'"
$	ws " "
$	goto tidy_exit
$ifj_file_ok:
$	ws "... Copied data file sucessfully found"
$	ws "... File was ''ifj_file'"
$!
$	ws " "
$	ws "... Input seed point file successfully found"
$	ws "... Input seed point file was :"
$	ws "...			''seed_file'"
$	ws "... Copying seed point file to working LSL$IF directory"
$!
$! Create a file ".SEED" for manipulation during the tests
$!
$	copy/noconfirm 'seed_file' 'out_file'
$	if $status then goto ifdir_ok2
$	ws " ''bell'"
$	ws "Failed to copy initial file to LSL$IF:, tests abandoned."
$	ws "Input file was ''seed_file'"
$	ws "Output was to ''out_file'"
$	ws " "
$	goto tidy_exit
$ifdir_ok2:
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
$	if f$search(defin_file) .nes. "" then goto defin_file_ok
$	ws " ''bell'"
$	ws " ''bell'"
$	ws "Failed to find ISTSEL definitions file, tests abandoned."
$	ws "File was ''defin_file'"
$	ws " "
$	goto tidy_exit
$defin_file_ok:
$	ws " "
$	ws "... ISTSEL definitions file sucessfully found"
$	ws " "
$	ws "... Initialisation and environment checks complete"
$!
$	device  = f$parse("''search_file'",,,"DEVICE")
$	dirnam  = f$parse("''search_file'",,,"DIRECTORY")
$	filenam = f$parse("''search_file'",,,"NAME")
$!
$! Copied files
$	seed_file = device+dirnam+filenam+".SEED"
$	ifj_file = device+dirnam+filenam+".IFJ"
$!
$! Files to be created
$	lnk_file = device+dirnam+filenam+".LNK"
$	start_file = device+dirnam+filenam+".START_IFF"
$	sel_file = device+dirnam+filenam+".SEL"
$	pol_file = device+dirnam+filenam+".POL"
$	pmg_file = device+dirnam+filenam+".PMG"
$!
$	ws " "
$	gosub go_on
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ wsff
$ ws " "
$ ws "''b_on'"
$ ws "POLYGONS package acceptance tests"
$ ws "''b_of'"
$	Type Sys$input:
The POLYGONS package acceptance tests can now start. The 2 input files contain:

        o junction structured links
        o seed point features

The acceptance procedure exercises all 3 POLYGONS package modules in 4 stages:

   (1) IPOLYGON -  creates polygons and assigns seed points to output links
                   having left/right polygon labels.

   (2) ISTSEL -    selectively removes left/right labelled links on the basis
                   of user specified label combinations.

   (3) POLMERGE  - selectively elimimates and merges polygons on the basis of
                   polygon area and user specified polygon label combinations. 

   (4) IPOLYGON -  creates closed polygon features, which include first order
                   nested polygons, from the left/right labelled links
                   output by POLMERGE
$	gosub go_on
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Use LITES2 to show off the source data
$!
$ 	wsff
$	ws " "
$	inquire/nopunc use_lites2 "Do you want to use LITES2 to examine the IFF files ?  "
$	if .not.use_lites2 then goto skip_lites_a
$ 	ass/user sys$command sys$input
$ 	lites2 frt LSL$POLYGONS_ACCEPT:POLYGONS_ACCEPT#disable table#maps 2#read 'ifj_file'#read 'seed_file'
$!
$	gosub go_on
$!
$skip_lites_a:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ ws " "
$ ws "''b_on'"
$ ws "POLYGONS package acceptance tests"
$ ws "''b_of'"
$ ws "The current stage is shown highlighted:"
$ ws " "
$ ws b_on,-
     "   (1) IPOLYGON -  creates polygons and assigns seed points to output links"
$ ws "                   having left/right polygon labels.",b_of
$ ws " "
$ ws "   (2) ISTSEL -    selectively removes left/right labelled links on the basis"
$ ws "                   of user specified label combinations."
$ ws " "
$ ws "   (3) POLMERGE  - selectively elimimates and merges polygons on the basis of"
$ ws "                   polygon area and user specified polygon label combinations."
$ ws " "
$ ws "   (4) IPOLYGON -  creates closed polygon features, which include first order"
$ ws "                   nested polygons, from the left/right labelled links"
$ ws "                   output by POLMERGE"
$ ws "''b_on' "
$ ws "The junction structured links input file is ''ifj_file' "
$ ws " "
$ ws "The seed point input file is ''seed_file' "
$ ws " "
$ ws "The output file is ''lnk_file'",b_of'
$!
$	gosub go_on
$!
$	set verify
$ IPOLYGON/LOG/LITES2/SEGMENTS=(JUNCTIONS,LABEL, -
	OUTPUT:'lnk_file') -
	/SEED=(FC:28,FILE:'seed_file') -
	'ifj_file' 
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$	ws " "
$	inquire/nopunc use_lites2 "Do you want to use LITES2 to examine the IFF file ?  "
$	if .not.use_lites2 then goto skip_lites_b
$ 	ass/user sys$command sys$input
$ 	lites2 frt LSL$POLYGONS_ACCEPT:POLYGONS_ACCEPT#disable table#maps 2#read 'lnk_file'#read 'seed_file'#verify ac
$!
$	gosub go_on
$!
$skip_lites_b:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ wsff
$ ws " "
$ ws "''b_on'"
$ ws "POLYGONS package acceptance tests"
$ ws "''b_of'"
$ ws "The current stage is shown highlighted:"
$ ws " "
$ ws "   (1) IPOLYGON -  creates polygons and assigns seed points to output links"
$ ws "                   having left/right polygon labels."
$ ws " "
$ ws b_on, -
     "   (2) ISTSEL -    selectively removes left/right labelled links on the basis"
$ ws "                   of user specified label combinations.",b_of
$ ws " "
$ ws "   (3) POLMERGE  - selectively elimimates and merges polygons on the basis of"
$ ws "                   polygon area and user specified polygon label combinations."
$ ws " "
$ ws "   (4) IPOLYGON -  creates closed polygon features, which include first order"
$ ws "                   nested polygons, from the left/right labelled links"
$ ws "                   output by POLMERGE"
$ ws "''b_on' "
$ ws "The labelled links input file is ''lnk_file' "
$ ws " "
$ ws "The output file is ''sel_file'"
$ ws "''b_of'"
$!
$	gosub go_on
$!
$	set verify
$ ISTSEL/LOG/DEF_FILE='defin_file' 'lnk_file' 'sel_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$	ws " "
$	inquire/nopunc use_lites2 "Do you want to use LITES2 to examine the IFF file ?  "
$	if .not.use_lites2 then goto skip_lites_c
$ 	ass/user sys$command sys$input
$ 	lites2 frt LSL$POLYGONS_ACCEPT:POLYGONS_ACCEPT#disable table#maps 2#read 'sel_file'#read 'lnk_file'#verify ac
$!
$	gosub go_on
$!
$skip_lites_c:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ wsff
$ ws " "
$ ws "''b_on'"
$ ws "POLYGONS package acceptance tests"
$ ws "''b_of'"
$ ws " "
$ ws "The current stage is shown highlighted:"
$ ws " "
$ ws "   (1) IPOLYGON -  creates polygons and assigns seed points to output links"
$ ws "                   having left/right polygon labels."
$ ws " "
$ ws "   (2) ISTSEL -    selectively removes left/right labelled links on the basis"
$ ws "                   of user specified label combinations."
$ ws " "
$ ws b_on, -
     "   (3) POLMERGE  - selectively elimimates and merges polygons on the basis of"
$ ws "                   polygon area and user specified polygon label combinations.",b_of
$ ws " "
$ ws "   (4) IPOLYGON -  creates closed polygon features, which include first order"
$ ws "                   nested polygons, from the left/right labelled links"
$ ws "                   output by POLMERGE"
$ ws "''b_on' "
$ ws "The junction structured links input file is ''lnk_file' "
$ ws " "
$ ws "The output file is ''pmg_file'"
$ ws "''b_of'"
$!
$	gosub go_on
$!
$	set verify
$ POLMERGE/LOG/LOOKUP='pmerge_def_file'/ELIMINATE /MERGE=(BY_LOOKUP) -
  /AREA = (MERGE_TOL:150000,ELIM_TOL:60000) 'lnk_file' 'pmg_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$	ws " "
$	inquire/nopunc use_lites2 "Do you want to use LITES2 to examine the IFF file ?  "
$	if .not.use_lites2 then goto skip_lites_d
$ 	ass/user sys$command sys$input
$!
$	set verify
$ 	lites2 frt LSL$POLYGONS_ACCEPT:POLYGONS_ACCEPT#disable table#maps 2#read 'pmg_file'#read 'lnk_file'#verify ac
$	set noverify
$!
$	gosub go_on
$!
$skip_lites_d:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ wsff
$ ws " "
$ ws "''b_on'"
$ ws "POLYGONS package acceptance tests"
$ ws "''b_of'"
$ ws " "
$ ws "The current stage is shown highlighted:"
$ ws " "
$ ws "   (1) IPOLYGON -  creates polygons and assigns seed points to output links"
$ ws "                   having left/right polygon labels."
$ ws " "
$ ws "   (2) ISTSEL -    selectively removes left/right labelled links on the basis"
$ ws "                   of user specified label combinations."
$ ws " "
$ ws "   (3) POLMERGE  - selectively elimimates and merges polygons on the basis of"
$ ws "                   polygon area and user specified polygon label combinations."
$ ws " "
$ ws b_on, -
     "   (4) IPOLYGON -  creates closed polygon features, which include first order"
$ ws "                   nested polygons, from the left/right labelled links"
$ ws "                   output by POLMERGE"
$ ws " "
$ ws "The junction structured links input file is ''pmg_file'"
$ ws " "
$ ws "The output file is ''pol_file'"
$ ws "''b_of'"
$!
$	gosub go_on
$!
$	set verify
$ IPOLYGON/LOG/LRCODE/POLYGONS=(LABEL,FC:4,LAYER:100, -
	OUTPUT:'pol_file') -
	'pmg_file'
$	DCL_STATUS = $STATUS
$	set noverify
$	gosub chk_status
$	ws " "
$	inquire/nopunc use_lites2 "Do you want to use LITES2 to examine the polygons IFF file ?  "
$	if .not.use_lites2 then goto skip_lites_e
$ 	ass/user sys$command sys$input
$!
$	set verify
$ 	lites2 frt LSL$POLYGONS_ACCEPT:POLYGONS_ACCEPT#disable table#maps 2#read 'lnk_file'#read 'pol_file'#verify ac
$	set noverify
$!
$	gosub go_on
$!
$skip_lites_e:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$ wsff
$ ws "''b_on'"
$ ws "============================================================"
$ ws "============         Laser-Scan  Ltd.           ============"
$ ws "============      LAMPS package POLYGONS        ============"
$ ws "============  Acceptance test command procedure ============"
$ ws "============================================================"
$ date_time=f$time()
$ ws "============  Completed ''date_time' ============"
$ ws "============================================================"
$ ws " "
$ ws "''b_of'"
$ ws " "
$ ws " "
$ ws " "
$ ws " "
$ ws " "
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	set noon
$	ws "... Tidying up, please ignore any warning messages"
$	purge lsl$if:POLYGONS_ACCEPT*.*
$	purge lsl$lites2cmd:POLYGONS_accept*.*
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
