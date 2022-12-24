$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-09-29 12:08:58.000000000 +0100
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
$ 	set noverify
$	on control_y then goto lampscontrolex
$	if "''f$logical("lsl$lampscontrol_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$a0:	define/group lsl$lampscontrol_building "in_progress"
$	assign lsl$source_root:[flowline.lampscontrol] lsl$lampscontrol
$	assign lsl$source_root:[flowline.lampscontrol.compile] lsl$compile
$	assign lsl$source_root:[flowline.library] LSL$CMNFLOWLINE
$	sd:=$lsl$exe:sd
$	sd lsl$compile
$	set noon
$	emsg=""
$ 	set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 	set verify
$	fms/library/create lampscontrol_form_lib -
	   lsl$lampscontrol:title_page,-
	   lsl$lampscontrol:lampscontrol_menu,-
	   lsl$lampscontrol:general_menu_help_1,-
	   lsl$lampscontrol:general_menu_help_2,-
	   lsl$lampscontrol:request_menu_help_1,-
	   lsl$lampscontrol:report_menu_help_1,-
	   lsl$lampscontrol:manage_menu_help_1,-
	   lsl$lampscontrol:manage_menu_help_2,-
	   lsl$lampscontrol:general_form_help_1,-
	   lsl$lampscontrol:general_form_help_2,-
	   lsl$lampscontrol:general_form_help_3,-
	   lsl$lampscontrol:general_form_help_4,-
	   lsl$lampscontrol:project_create_form,-
	   lsl$lampscontrol:job_create_form,-
	   lsl$lampscontrol:op_auth_form,-
	   lsl$lampscontrol:wks_auth_form,-
	   lsl$lampscontrol:session_finished, -
	   lsl$lampscontrol:parameter_form, -
	   lsl$lampscontrol:element_definition_form, -
	   lsl$lampscontrol:flowline_definition_form, -
	   lsl$lampscontrol:procedure_definition_form,-
	   lsl$lampscontrol:system_definition_form, -
	   lsl$lampscontrol:wire_definition_form
$	fms/object lampscontrol_form_lib.flb
$	set noverify
$	if emsg.eqs."" then goto noerr
$	write sys$output "&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"
$	write sys$output "Compilation errors in:"
$	write sys$output emsg
$	write sys$output "&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"
$	goto nolnk
$	noerr:
$ 	nolnk:
$ 	lampscontrolex:
$	sd lsl$lampscontrol
$ 	deass/group lsl$lampscontrol_building
$ 	set nover
