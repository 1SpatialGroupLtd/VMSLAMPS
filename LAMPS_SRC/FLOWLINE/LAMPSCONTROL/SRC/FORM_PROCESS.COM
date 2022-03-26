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
