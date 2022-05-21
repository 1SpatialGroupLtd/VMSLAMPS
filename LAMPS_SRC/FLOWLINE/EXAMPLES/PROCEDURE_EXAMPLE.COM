$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-10-07 13:49:42.000000000 +0100
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
$!	PROCEDURE_EXAMPLE.COM
$!
$!	Copyright Laser-Scan Laboratories Ltd, Cambridge, England
$!	Author: MWS Reid		6th October 1988
$!
$!	Example procedure command procedure.
$!	It creates an indirect command file to run the Laser-Scan 
$!	IMP package program ISTART.
$!
$!
$! Set up defaults for LAMPSCONTROL system variables 
$! Assume failure
$	FLN_RESULT == "error"
$	FLN_PROBLEM == "unknown"
$!
$! Set up template IFF file using ISTART
$!
$	write sys$output "Creating template for IFF file"
$!
$	if LTRAK then goto startltrak
$!
$	open/write cmdfil 'istart_temp'
$	OK = $status
$	if OK then goto dowrite
$	ws "Error opening temporary command file"
$	FLN_RESULT == "error"
$	FLN_PROBLEM == "open"
$	goto finish
$!
$ dowrite:
$	wc :== write cmdfil
$	wc "$	ISTART /fc=300/MCE/LAYER=''LAY_NUM' ''RAW_IFF'"
$	wc "		''fln_map_scale'"
$	wc "		''fln_nw_control_x' ''fln_nw_control_y'"
$	wc "		''fln_sw_control_x' ''fln_sw_control_y'"
$	wc "		''fln_se_control_x' ''fln_se_control_y'"
$	wc "		''fln_ne_control_x' ''fln_ne_control_y'"
$	close cmdfil
$	OK = $STATUS
$	if OK then goto istartdone
$	goto failure
$!
$ startltrak:
$	open/write cmdfil 'istart_temp'
$	OK = $status
$	if OK then goto dolwrite
$	ws "Error opening temporary command file"
$	FLN_RESULT == "error"
$	FLN_PROBLEM == "open"
$	goto finish
$!
$ dolwrite:
$	wc :== write cmdfil
$	wc "$	ISTART/LASERAID/MCE/LAYER=''LAY_NUM' ''RAW_IFF'"
$	wc "		''fln_map_scale'"
$	wc "		''fln_nw_control_x' ''fln_nw_control_y'"
$	wc "		''fln_sw_control_x' ''fln_sw_control_y'"
$	wc "		''fln_se_control_x' ''fln_se_control_y'"
$	wc "		''fln_ne_control_x' ''fln_ne_control_y'"
$	close cmdfil
$	OK = $STATUS
$	if .not.OK then goto failure
$!
$ istartdone:
$!
$! execute the command procedure created
$	@'istart_temp'
$	ok = $status
$	if .not.OK then goto failure
$	ws ""
$	ws "ISTART completed successfully"
$	ws ""
$	FLN_RESULT == "complete"
$	FLN_PROBLEM == ""
$	FLN_OUTCOME == "1"
$	goto finish
$!
$! Deal with errors in ISTART
$! and find out if user wants to carry on regardless
$!
$ failure:
$	FLN_RESULT == "error"
$	FLN_PROBLEM == "istart"
$	ws "Failure to create template IFF file"
$	goto finish
$!
$! Exit
$!
$ finish:
$!
