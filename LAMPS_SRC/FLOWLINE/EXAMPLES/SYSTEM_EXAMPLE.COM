$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-10-07 11:13:08.000000000 +0100
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
$!	SYSTEM_EXAMPLE.COM
$!
$!	Copyright Laser-Scan Laboratories Ltd, Cambridge, England.
$!	Author : MWS Reid	7-October-1988
$!
$!	Example flowline command procedure.
$!	This command procedure is executed whenever a project is 
$!	launched on the system.
$!	It prompts for information relevant to the 
$!	project and constructs the project command file for execution 
$!	before each task. 
$!
$! Set up logical names
$!
$	assign SYS$OUTPUT S$O
$	ws := " write sys$output"
$!
$! Set up defaults for symbols
$!
$	FLN_RESULT == "error"
$	FLN_PROBLEM == "unknown"
$!
$! Output header
$!
$	ws ""
$	ws "   ***************************************************"
$	ws "   **                                               **"
$	ws "   **          System command procedure             **"
$	ws "   **                                               **"
$	ws "   ***************************************************"
$	ws ""
$	ws ""
$!
$! get the project name
$!
$	proj  = fln_project_id + "_project.com"
$	inq/nop filename "Please enter project command file name [''proj'] ?  >> "
$	if filename .eqs. "" then filename = proj
$!
$! see if this file already exists
$!
$	check = f$search("lsl$fln_project:" + filename)
$	if check .eqs."" then goto prefix
$	ws "WARNING : This project file already exists "
$	inq/nop RESP "  - are you sure you want to continue [y/n] :"
$	if .not.RESP then goto abort
$!
$! project prefix
$!
$ prefix:
$	inq/nop prop "Please enter project prefix >> "
$	ws ""
$!
$! some other things that may come in handy
$!
$	project = fln_project_id
$	date = f$extract(0,17,f$time())
$	name := 'f$getjpi("","username")
$!
$! now write the project command file
$!
$	dfad_cmdfil = "lsl$fln_project:" + filename
$	fln_project_comproc == dfad_cmdfil
$	open/write cmdfil 'dfad_cmdfil'
$	OK = $STATUS
$	if .not.OK then goto failure
$	wc := "write cmdfil"
$	wc "$!                   Project  command file"
$	wc "$!                   ~~~~~~~~~~~~~~~~~~~~~" 
$	wc "$!"
$	wc "$!"
$	wc "$!      created by ''name' on ''date'"
$	wc "$!      for project  ''project'"
$	wc "$!"
$	wc "$ project_prefix == ""''prop'""
$	close cmdfil
$	OK = $STATUS
$	if .not.OK then goto failure
$	ws ""
$	ws "Project command file ''dfad_cmdfil' written"
$	ws ""
$	FLN_RESULT == "complete"
$	FLN_PROBLEM == ""
$	goto finish
$!
$! deal with errors
$!
$	FLN_RESULT == "error"
$	FLN_PROBLEM == "System command file creation"
$!
$! User controlled abort
$!
$ abort:
$	ws "ouch !"
$	FLN_RESULT == "abort"
$	FLN_PROBLEM == ""
$	goto finish
$!
$! and out
$!
$ finish:
$ exit
