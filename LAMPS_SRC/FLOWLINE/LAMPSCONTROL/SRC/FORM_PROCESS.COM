$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-09-28 19:15:24.000000000 +0100
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
$	goto do_help
$!
$! Title page
$!
$	def/user sys$input sys$command
$	fms/edit title_page
$!
$! Menu form
$!
$	def/user sys$input sys$command
$	fms/edit LAMPSCONTROL_MENU
$!
$! Notification forms
$!
$	def/user sys$input sys$command
$	fms/edit SESSION_FINISHED
$!
$! Creation forms
$!
$	def/user sys$input sys$command
$	fms/edit PROJECT_CREATE_FORM
$	def/user sys$input sys$command
$	fms/edit JOB_CREATE_FORM
$!
$! Definition forms
$!
$	def/user sys$input sys$command
$	fms/edit SYSTEM_DEFINITION_FORM
$	def/user sys$input sys$command
$	fms/edit FLOWLINE_DEFINITION_FORM
$	def/user sys$input sys$command
$	fms/edit ELEMENT_DEFINITION_FORM
$	def/user sys$input sys$command
$	fms/edit WIRE_DEFINITION_FORM
$	def/user sys$input sys$command
$	fms/edit PROCEDURE_DEFINITION_FORM
$!
$! Authorisation forms
$!
$	def/user sys$input sys$command
$	fms/edit OP_AUTH_FORM
$	def/user sys$input sys$command
$	fms/edit WKS_AUTH_FORM
$!
$! Form help
$!
$ do_help:
$	def/user sys$input sys$command
$	fms/edit GENERAL_FORM_HELP_1
$	def/user sys$input sys$command
$	fms/edit GENERAL_FORM_HELP_2
$	def/user sys$input sys$command
$	fms/edit GENERAL_FORM_HELP_3
$	def/user sys$input sys$command
$	fms/edit GENERAL_FORM_HELP_4
$!
$! Menu help
$!
$	def/user sys$input sys$command
$	fms/edit GENERAL_MENU_HELP_1
$	def/user sys$input sys$command
$	fms/edit GENERAL_MENU_HELP_2
$	def/user sys$input sys$command
$	fms/edit REQUEST_MENU_HELP_1
$	def/user sys$input sys$command
$	fms/edit REPORT_MENU_HELP_1
$	def/user sys$input sys$command
$	fms/edit MANAGE_MENU_HELP_1
$	def/user sys$input sys$command
$	fms/edit MANAGE_MENU_HELP_2
