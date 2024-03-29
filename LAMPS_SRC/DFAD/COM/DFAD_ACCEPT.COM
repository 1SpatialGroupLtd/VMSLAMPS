$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-10-11 15:44:20.000000000 +0100
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
$! LAMPS package "DFAD" acceptance test command procedure.
$!
$! Author 					DRC	27-May-1988
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
$ ws "============         LAMPS package DFAD         ============"
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
$ ws "DFAD package acceptance tests"
$ ws "''b_of'"
$	ws "... Initialising the package and checking environment"
$	ws " "
$	@lsl$com:dfadini
$	set noon
$!
$	Define sys$error nl:
$!	Define sys$output nl:
$!
$	Define LSL$DFAD_RULE	LSL$PUBLIC_ROOT:[DFAD.ACCEPT]	
$	Define LSL$DFAD_ACCEPT  LSL$PUBLIC_ROOT:[DFAD.ACCEPT]	
$!
$!	Assign various things so that we can invoke FADINTPUT with
$!	command line qualifiers
$!
$!	deassign sys$output
$	deassign sys$error
$!
$	in_dfad_file1="LSL$DFAD_ACCEPT:DFAD_ACCEPT1.IFF"
$	in_dfad_file2="LSL$DFAD_ACCEPT:DFAD_ACCEPT2.IFF"
$	in_fadt      ="LSL$DFAD_ACCEPT:DFAD_ACCEPT.FADT"
$	rule_file    ="LSL$DFAD_RULE:DFAD_ACCEPT.RULE"
$	fadt_list    ="LSL$IF:DFAD_ACCEPT.LIS"
$!
$	copied_dfad_file1 ="LSL$IF:DFAD_ACCEPT1.IFF"
$	copied_dfad_file2 ="LSL$IF:DFAD_ACCEPT2.IFF"
$	copied_fadt       ="LSL$FADT:DFAD_ACCEPT.FADT"
$!
$	Define LSL$FADTINPUT_FADT 'COPIED_FADT'
$	Define LSL$FADTINPUT_RULE 'RULE_FILE'
$	Define LSL$FADTINPUT_LIST 'FADT_LIST'
$!
$!============================================================================
$! Check the input acceptance test files exist
$!
$	if f$search(in_dfad_file1) .nes. "" then goto in_dfad_file1_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''in_dfad_file1'"
$	ws " "
$	goto tidy_exit
$!
$ in_dfad_file1_ok:
$	if f$search(in_dfad_file2) .nes. "" then goto in_dfad_file2_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''in_dfad_file2'"
$	ws " "
$	goto tidy_exit
$!
$ in_dfad_file2_ok:
$	if f$search(in_fadt) .nes. "" then goto in_fadt_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''in_fadt'"
$	ws " "
$	goto tidy_exit
$!
$ in_fadt_ok:
$	if f$search(rule_file) .nes. "" then goto rule_file_ok
$	ws " ''bell'"
$	ws "Initial file could not be found, tests abandoned."
$	ws "Input file was ''rule_file'"
$	ws " "
$	goto tidy_exit
$!
$ rule_file_ok:
$!
$	ws "... Input acceptance test data files successfully found"
$	ws "... Input files were:
$	ws "          ''in_dfad_file1'"
$	ws "          ''in_dfad_file2'"
$	ws "          ''in_fadt'"
$	ws " "
$	ws "... Input acceptance test validation file successfully found"
$	ws "... Input file is:
$	ws "          ''rule_file'"
$	ws " "
$	ws "... Copying them to working LSL$IF and LSL$FADT directories"
$!
$! Create new ".IFF" files for manipulation during the tests
$!
$	copy/nolog/noconfirm 'in_dfad_file1' 'copied_dfad_file1'
$	if $status then goto copied_dfad_file1_ok
$	ws " ''bell'"
$	ws "Failed to copy test file to LSL$IF:, tests abandoned."
$	ws "Input file was ''in_dfad_file1'"
$	ws "Output was to ''copied_dfad_file1'"
$	ws " "
$	goto tidy_exit
$ copied_dfad_file1_ok:
$	iff_search_file=f$search(copied_dfad_file1)
$	if $status then goto found_copied_file1_ok
$	ws " ''bell'"
$	ws "Failed to find copied file in LSL$IF:, tests abandoned."
$	ws "File was ''copied_dfad_file1'"
$	ws " "
$	goto tidy_exit
$!
$ found_copied_file1_ok:
$	copy/nolog/noconfirm 'in_dfad_file2' 'copied_dfad_file2'
$	if $status then goto copied_dfad_file2_ok
$	ws " ''bell'"
$	ws "Failed to copy test file to LSL$IF:, tests abandoned."
$	ws "Input file was ''in_dfad_file2'"
$	ws "Output was to ''copied_dfad_file2'"
$	ws " "
$	goto tidy_exit
$!
$ copied_dfad_file2_ok:
$	iff_search_file=f$search(copied_dfad_file2)
$	if $status then goto found_copied_file2_ok
$	ws " ''bell'"
$	ws "Failed to find copied file in LSL$IF:, tests abandoned."
$	ws "File was ''copied_dfad_file2'"
$	ws " "
$	goto tidy_exit
$!
$ found_copied_file2_ok:
$	copy/nolog/noconfirm 'in_fadt' 'copied_fadt'
$	if $status then goto check_fadt_file_ok
$	ws " ''bell'"
$	ws "Failed to copy initial file to LSL$FADT:, tests abandoned."
$	ws "Input file was ''in_fadt'"
$	ws "Output was to ''copied_fadt'"
$	ws " "
$	goto tidy_exit
$!
$ check_fadt_file_ok:
$	iff_search_file=f$search(copied_fadt)
$	if $status then goto found_fadt_file_ok
$	ws " ''bell'"
$	ws "Failed to find copied file in LSL$FADT:, tests abandoned."
$	ws "File was ''copied_fadt'"
$	ws " "
$	goto tidy_exit
$!
$ found_fadt_file_ok:
$!
$	ws "... All copied data files sucessfully found"
$	ws " "
$	ws "... Initialisation and environment checks complete"
$	ws " "
$       clear_screen
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$	clear_screen
$	ws " "
$	inquire/nopunc do_fadtinput "Carry out acceptance for DFAD module FADTINPUT ?"
$	if .not.do_fadtinput then goto ask_FADTMERGE
$!
$	clear_screen
$	WS "FADTINPUT is used to create, edit and list an FADT file"
$	WS "The FADT contains manuscript header records, accuracy region
$	WS "records, and feature attribute records."
$	WS " "
$	WS "For acceptance a partially created FADT file is provided."
$	WS "The header and accuracy records have already been entered."
$	WS "All but 3 feature atrribute records have also been entered."
$	WS "The remaining records will be entered interactively during acceptance."
$	WS " "
$	WS "Following entry of these records it will be possible to list the"
$	WS "contents of the FADT on the line-printer."
$	WS " "
$	gosub go_on
$	define/user sys$input sys$command
$	define lsl$fadtinput_action 2
$	FADTINPUT
$!
$!
$	clear_screen
$	inquire/nopunc do_list "List the contents of the FADT file on the line-printer ?"
$	if .not.do_list then goto ask_fadtmerge
$!
$	define lsl$fadtinput_action 3
$	FADTINPUT
$!
$	PRINT 'fadt_list'
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$	ask_fadtmerge:
$	clear_screen
$	inquire/nopunc do_fadtmerge "Carry out acceptance for FADTMERGE ?"
$	if .not.do_fadtmerge then goto skip_ipatch2
$!
$	WS "FADTMERGE is used to combine attribtue information held in a FADT"
$	WS "file, with geometry data held in an IFF file."
$	WS " "
$	WS "Using FADTMERGE it is possible to transfer DFAD header records"
$	WS "to a map header in the IFF file; FADT accuracy data records to"
$	WS "layer 0 in the IFF file, and to merge feature analysis data"
$	WS "with the feature geometry.  Merging is performed on the basis"
$	WS "of FAC in the FADT file, and FSN in the IFF file."
$	WS " "
$	gosub go_on
$	clear_screen
$!
$	inquire/nopunc do_ipatch1 "Examine the the premerged IFF file using IPATCH ?"
$	if .not.do_ipatch1 then goto skip_ipatch1
$!
$!	Simply call up IPATCH and let the operator do the rest.
$!	Instructions are provided in the acceptance tests.
$	assign/user tt: sys$input
$	IPATCH 'copied_dfad_file1'
$!
$	clear_screen
$	gosub go_on
$	skip_ipatch1:
$!
$	FADTMERGE/FC/HEADER/ACCURACY/FADT='copied_fadt' 'copied_dfad_file1' dfad_accept1_merged
$!
$	clear_screen
$	inquire/nopunc do_ipatch2 "Examine the the merged IFF file using IPATCH ?"
$	if .not.do_ipatch2 then goto skip_ipatch2
$!
$!	Simply call up IPATCH and let the operator do the rest.
$!	Instructions are provided in the acceptance tests.
$!
$	assign/user tt: sys$input
$	IPATCH dfad_accept1_merged
$!
$	skip_ipatch2:
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$	clear_screen
$	inquire/nopunc do_mcehed "Carry out acceptance for DFAD module MCEHED ?"
$	if .not.do_MCEHED then goto ask_dfadval
$!
$	clear_screen
$	WS "MCEHED enables an IFF MCE Map Header to be interactively examined"
$	WS "and edited."
$	WS "The Map Header contains information transferred from the FADT file"
$	WS "on the coverage and overall accuracy of the manuscript, and data 
$	WS "relating to the generation of the dataset."
$	WS " "
$	WS "The Map Header data is transferred to the Manuscript and Data Set"
$	WS "Identification (DSI) records of a DFAD tape using I2DFAD."
$	WS " "
$	WS " "
$	gosub go_on
$	clear_screen
$!
$!	Call up MCEHED and let the operator do the rest
$	assign/user tt: sys$input
$	MCEHED dfad_accept1_merged
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$	ask_dfadval:
$	clear_screen
$!
$	inquire/nopunc do_dfadval "Carry out acceptance for DFAD module DFADVAL ?"
$	if .not.do_DFADVAL then goto ask_I2DFAD
$	clear_screen
$	WS "DFADVAL validates the DFAD MCE Map Header Data, the geometry and"
$	WS "attributes of DFAD accuracy regions, and the geometry and attribute"s
$	WS "of DFAD point, line and area features, held in the IFF file."
$	WS " "
$	WS "The geometry and attribute checks are performed together."
$	WS " "
$	WS " "
$	gosub go_on
$	clear_screen
$!
$	DFADVAL/AC/BOUNDS/TYPE=AC/RULE='RULE_FILE' DFAD_ACCEPT1_MERGED
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$	ask_i2dfad:
$	clear_screen
$!
$! 	I2DFAD and DFAD2I	(always run together to prove correct transfer)
$!
$	clear_screen
$	ws " "
$	inquire/nopunc do_i2dfad "Carry out acceptance for DFAD module I2DFAD and DFAD2I ?"
$	if .not.do_I2DFAD then goto skip_IDIFF
$!
$!	Is the DFAD acceptance tape already mounted on the
$!	tape drive.  Note this must be a scratch tape, as any
$!	data on the tape will be overwritten.
$!
$	WS "I2DFAD transfers DFAD data held in an IFF file"
$       WS "to a DFAD magnetic tape."
$	WS "  "
$	WS "In this acceptance procedure I2DFAD is run twice" 
$       WS "in order to transfer data from 2 IFF files."
$	WS "In the first run, the tape is intialised,"
$       WS "so that the data is written as the first manuscript."
$       WS "In the second run, the tape is rewound, 
$       WS "but the data is appended to the previous manuscript."
$	WS "  "
$	gosub go_on
$	clear_screen
$!
$ get_tape_name:
$       read/end=question/prompt="Name of tape device to be used for acceptance [default is MTA0:] ?  " -
		sys$command source
$	source=f$edit(source,"upcase,collapse")
$	if source.eqs."" then source="MTA0:"
$	name=f$parse(source,,,"name","no_conceal")
$	if name.nes."" then goto get_tape_name
$	node=f$parse(source,,,"node","no_conceal")
$	if node.nes."" then goto get_tape_name
$	device=f$parse(source,"sys$disk:",,"device","no_conceal")
$	if device.eqs."" then goto no_such
$	exists=f$getdvi(device,"exists")
$	if .not.exists then goto no_such
$	class=f$getdvi(device,"devclass")
$	if class.ne.2 then goto get_tape_name
$	goto tape_device
$!
$! ************************************************************************
$!
$! error cases
$!
$no_such:
$	WS "''source' is not available"
$	goto get_tape_name
$!
$! ************************************************************************
$!
$tape_device:
$	WS "Please load a scratch tape on ''source'"
$       read/end=question/prompt="Hit RETURN when ready " -
		sys$command yes
$!
$!	Mount the DFAD acceptance tape 
$	mount 'source'/foreign
$	if .not.$status then goto tape_device
$	set on
$
$!	Write the manuscript as the first manuscript on the
$!	tape.  This is achieved using the /REWIND qualifier
$!	in I2DFAD.
$!
$	I2DFAD/REWIND/DEVICE='source'/DIAGNOSTICS DFAD_ACCEPT1_MERGED.IFF
$!
$!	Write a second manuscript.  This time we append the
$!	manuscript to the data already on the tape.
$!	This is achieved using the /APPEND qualifier.
$!	
$	I2DFAD/APPEND/DEVICE='source'/DIAGNOSTICS 'COPIED_DFAD_FILE2'
$!
$	clear_screen
$	inquire/nopunc do_dump "Do you want to use DUMP to examine the first 4 records on the tape ?"
$	if .not.do_dump then goto skip_dump
$!
$!	Rewind the tape to BOT
$!
$	DISMOUNT 'source'/NOUNLOAD
$!
$	MOUNT/FOR 'source'
$!
$!	Dump the first 4 blocks of the tape to examine a
$!	header, DSI, ACC and 1 data record.
$!
$	DUMP/AS/BLOCKS=(COUNT:4) 'source'
$!
$	skip_dump:
$	clear_screen
$	gosub go_on
$!	Convert the first manuscript on the tape back to IFF.
$!	This is done using the /MANUSCRIPT qualifer, and
$!	specifying REWIND. (/MANUSCRIPT = 1 is not really 
$!	required in this case, since the default action is to
$!	read the next manuscript on the tape.
$!
$	DFAD2I/REWIND/DEVICE='source'/MANUSCRIPT=1/FC/DIAG=BRIEF DFAD1_IMPORTED
$!
$!	Read the second manuscript on the tape.  In this case rather than
$!	using /MANUSCRIPT = 2 , we search for the manuscript on the
$!	latitude and longitude origin.  The latitude origin is specified
$!	in the format DDMMSS.SH, while longitude is specified in the
$!	format DDDMMSS.SH
$!	The DIAGNOSTICS qualifier is used to output details read from
$!	the ACC and DSI record, and brief details on each DFAD features.
$!	
$	DFAD2I/REWIND/DEVICE='source'/LATITUDE=575900.0N/LONG=0040100.0W/DIAG=BRIEF DFAD2_IMPORTED
$!
$!	Dismount the tape
$	DISMOUNT/NOUNLOAD 'source'
$!
$!	To verify that the data has been correctly read from the tape,
$!	the IMP utility IDIFFERENCE is used to compare the files generated
$!	by DFAD2I with the original files.
$!	Any differences are tabulated on the terminal.
$!
$	clear_screen
$	inquire/nopunc do_idiff "Do you want to use IDIFFERENCE to compare the files created by DFAD2I with the original files ?"
$	if .not.do_idiff then goto skip_idiff
$!	Ensure the symbol IDIFFERENCE is set up
$	@LSL$COM:impini q
$!
$	IDIFFERENCE DFAD_ACCEPT1_MERGED DFAD1_IMPORTED
$!
$	IDIFFERENCE 'COPIED_DFAD_FILE2' DFAD2_IMPORTED
$!
$	skip_idiff:
$	clear_screen
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ ws "''b_on'"
$ ws "============================================================"
$ ws "============    Laser-Scan Laboratories Ltd.    ============"
$ ws "============        LAMPS package "DFAD"        ============"
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
$	purge lsl$if:DFAD_ACCEPT*.*
$	purge lsl$fadt:DFAD_ACCEPT*.*
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
