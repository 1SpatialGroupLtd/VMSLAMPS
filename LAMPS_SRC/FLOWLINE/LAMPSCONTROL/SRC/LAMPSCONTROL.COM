$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-05-06 16:06:04.000000000 +0100
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
$	sd lsl$source_root:[flowline.lampscontrol]
$!
$! Command file to build DFAD utility LAMPSCONTROL
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!	Created						TJH 12-Jan-1987
$!
$	ver=f$verify(0)
$!
$	on error then goto lampscontrolex
$!
$	disk:='f$logical("sys$disk")'
$!	if "''f$logical("lsl$lampscontrol_building")'" .nes. "in_progress" -
$!	   then goto a0
$!	write sys$output "Someone else is building"
$!	exit
$!
$a0:	on control_y then goto lampscontrolex
$!
$	define/group lsl$lampscontrol_building "in_progress"
$	define lsl$lampscontrol -
			lsl$source_root:[flowline.lampscontrol]
$	define lsl$compile -
			lsl$source_root:[flowline.lampscontrol.compile]
$	define lsl$cmnflowline -
			lsl$source_root:[flowline.library]
$	open/write comfil lampscontrolbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto lampscontrolex"
$	wc "$	if ""'","'f$logical(""lsl$lampscontrol_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$lampscontrol_building ""in_progress"""
$	wc "$	assign lsl$source_root:[flowline.lampscontrol] lsl$lampscontrol"
$	wc "$	assign lsl$source_root:[flowline.lampscontrol.compile] lsl$compile"
$!	wc "$	assign lsl$source_root:[flowline.data] lsl$fln_database"
$	wc "$	assign lsl$source_root:[flowline.library] LSL$CMNFLOWLINE"
$	wc "$	sd:=$lsl$exe:sd"
$	wc "$	sd lsl$compile"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	lampscontrol_dbg=""
$	cldgen=""
$	mes=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop lampscontrol_dbg "With Debug ? "
$	if .not. lampscontrol_dbg then goto a04
$	   fsw1="/debug"
$	   mldbg="/debug"
$	   inquire/nop answer "Without optimisation ? "
$	   if answer then fsw1=fsw1 + "/noopt"
$	   inquire/nop answer "Check bounds and overflow ? "
$	   if answer then fsw1=fsw1 + "/check=(bounds,overflow)"
$	   inquire/nop answer "With listings ? "
$	   if answer then fsw1=fsw1 + "/list"
$	   inquire/nop answer "Keep FORtran sources with comments ? "
$	   if answer then kpcom="/co"
$ a04:
$!
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all sources ? "
$	   if .not. everything then goto a05
$!
$	LAMPSCONTROL = "t"
$	LAMPSCONTROL_INIT = "t"
$	SETUP_EXIT_HANDLER = "T"
$	EXIT_HANDLER = "T"
$	TITLE_PAGE = "t"
$	LAMPSCONTROL_CLOSEDOWN = "t"
$	GET_COMMAND = "t"
$	DEFINE_PARAMETERS = "T"
$	PARSE_PARAM_STRING = "T"
$	STORE_PARAM_STRING = "T"
$	CHECK_AUTHORISATION = "t"
$	FIND_OPERATOR_ID = "t"
$	FIND_WORKSTATION_ID = "t"
$	NOTIFY_STATUS = "t"
$	NOTIFY_JOB_STARTED = "t"
$	NOTIFY_PROJECT_STARTED = "t"
$	NOTIFY_SESSION_FINISHED = "t"
$	REQUEST_MENU = "t"
$	NON_INTERACTIVE_REQUEST = "t"
$	TASK_REQUEST_MENU = "t"
$	JOB_REQUEST_MENU = "t"
$	PROJECT_REQUEST_MENU = "t"
$	MANAGE_MENU = "t"
$	SYSTEM_DEFINITION_MENU = "t"
$	CREATE_SYSTEM_DEFINITION = "t"
$	CREATE_FLOWLINE_DEFINITION = "t"
$	CREATE_ELEMENT_DEFINITION = "t"
$	DISPLAY_ELEMENT_OUTCOMES_AREA = "T"
$	GET_ELEMENT_OUTCOMES_AREA = "T"
$	CREATE_WIRE_DEFINITION = "t"
$	CREATE_PROCEDURE_DEFINITION = "t"
$	MANAGE_CREATION_MENU = "t"
$	NON_INTERACTIVE_CREATE_JOB = "t"
$	PROJECT_INITIATION = "t"
$	JOB_INITIATION = "t"
$	MANAGE_AUTHORISATION_MENU = "t"
$	OPERATOR_AUTH_FORM = "t"
$	WORKSTATION_AUTH_FORM = "t"
$	GET_AUTH_AREA = "t"
$	DISPLAY_AUTH_AREA = "t"
$	PROJECT_STATUS_MENU = "t"
$	JOB_STATUS_MENU = "t"
$	JOB_MOVE_ELEMENT_MENU = "t"
$	TASK_STATUS_MENU = "t"
$	MANAGE_NOTIFICATION_MENU = "t"
$	PROJECT_NOTIFICATION_MENU = "t"
$	JOB_NOTIFICATION_MENU = "t"
$	SESSION_NOTIFICATION_MENU = "t"
$	SESSION_FINISHED_FORM = "t"
$	GET_PARAMETERS_FORM = "T"
$	REPORT_MENU = "t"
$	REPORT_DEFINITION_MENU = "t"
$	FLOWLINE_DEFINITION_REPORT = "t"
$	FLOWLINE_SELECTION_MENU = "t"
$	ELEMENT_DEFINITION_REPORT = "t"
$	WIRE_DEFINITION_REPORT = "t"
$	PROCEDURE_DEFINITION_REPORT = "t"
$	REPORT_STATUS_MENU = "t"
$	PROJECT_STATUS_REPORT = "t"
$	JOB_STATUS_REPORT = "t"
$	SESSION_STATUS_REPORT = "t"
$	OPERATOR_STATUS_REPORT = "t"
$	WORKSTATION_STATUS_REPORT = "t"
$	TASK_STATUS_REPORT = "t"
$	REPORT_STATISTICS_MENU = "t"
$	PROJECT_STATISTICS_MENU = "t"
$	PROJECT_STATISTICS_REPORT = "t"
$	JOB_STATISTICS_MENU = "t"
$	JOB_STATISTICS_REPORT = "t"
$	TASK_STATISTICS_MENU = "t"
$	TASK_STATISTICS_REPORT = "t"
$	SESSION_STATISTICS_REPORT = "t"
$	FLOWLINE_STATISTICS_MENU = "t"
$	FLOWLINE_STATISTICS_REPORT = "t"
$	ELEMENT_STATISTICS_MENU = "t"
$	ELEMENT_STATISTICS_REPORT = "t"
$	PER_ELEMENT_STATISTICS_MENU = "t"
$	ELEM_OPER_STATISTICS_REPORT = "t"
$	ELEM_WORK_STATISTICS_REPORT = "t"
$	OPERATOR_STATISTICS_MENU = "t"
$	OPER_TOTAL_STATISTICS_REPORT = "t"
$	PER_OPERATOR_STATISTICS_MENU = "t"
$	PER_OPER_WORK_STATISTICS_REPORT = "T"
$	PER_OPER_ELEM_STATISTICS_REPORT = "T"
$	WORKSTATION_STATISTICS_MENU = "t"
$	WORK_TOTAL_STATISTICS_REPORT = "t"
$	PER_WORKSTATION_STATISTICS_MENU = "t"
$	PER_WORK_OPER_STATISTICS_REPORT = "T"
$	PER_WORK_ELEM_STATISTICS_REPORT = "T"
$	OPEN_REPORT_FILE = "t"
$	CLOSE_REPORT_FILE = "t"
$	CONTROL_MENU = "t"
$	DISPLAY_MENU = "t"
$	GET_MENU_OPTION = "t"
$	DISPLAY_AREA_OPTION = "t"
$	GET_AREA_OPTION = "t"
$	SETUP_DCL = "t"
$	OPEN_COMMAND_FILE = "t"
$	WRITE_COMMAND_FILE = "t"
$	OUTPUT_SHARED_DCL = "t"
$	WRITE_TASK_COMPROC = "t"
$	WRITE_LOGOFF_COMPROC = "t"
$	WRITE_NULL_COMPROC = "t"
$	WRITE_ERROR_COMPROC = "t"
$	WRITE_WAIT_COMPROC = "t"
$	WRITE_CREATE_JOB_COMPROC = "t"
$	WRITE_CREATE_PROJECT_COMPROC = "t"
$	CLOSE_COMMAND_FILE = "t"
$	DISPLAY_HELP_LINE = "T"
$	FORM_GETLINE = "t"
$	FORM_PUTMSG = "t"
$	CLEAR_MESSAGE_LINES = "t"
$	DISPLAY_HELPLINE = "t"
$	LCONT_PUTMSG = "t"
$	LCONT_ADDMSG = "t"
$	LOG_ENTRY = "t"
$	OPEN_LOG_FILE = "t"
$	FIND_LOG_DETAILS = "t"
$	CLOSE_LOG_FILE = "t"
$	WIDE_SCREEN = "t"
$	WANT_CURSOR = "t"
$	WANT_TYPE_AHEAD = "t"
$	WANT_ECHO = "t"
$	EDIT_FILE = "t"
$	OUTPUT_CONTROL_STRING = "t"
$	CENTRE_STRING = "T"
$	STRIP_DOUBLE_QUOTES = "T"
$	SIGNCH = "t"
$	CONVERT_TIME_TO_STRING = "T"
$	CONVERT_DAY_TO_STRING = "T"
$	EXCEPTION_HANDLER = "t"
$!	
$	cldgen="t"
$	mes = "t"
$	frmgen = "t"
$	goto a11
$!
$ a05:	   
$!
$	ws " " 
$	ws ".............................FORTRAN sources"
$	inq/nop LAMPSCONTROL "LAMPSCONTROL ? "
$	inq/nop LAMPSCONTROL_INIT "LAMPSCONTROL_INIT ? "
$	inq/nop SETUP_EXIT_HANDLER "SETUP_EXIT_HANDLER ? "
$	inq/nop EXIT_HANDLER "EXIT_HANDLER ? "
$	inq/nop TITLE_PAGE "TITLE_PAGE ? "
$	inq/nop LAMPSCONTROL_CLOSEDOWN "LAMPSCONTROL_CLOSEDOWN ? "
$	inq/nop GET_COMMAND "GET_COMMAND ? "
$	inq/nop DEFINE_PARAMETERS "DEFINE_PARAMETERS ? "
$	inq/nop PARSE_PARAM_STRING "PARSE_PARAM_STRING ? "
$	inq/nop STORE_PARAM_STRING "STORE_PARAM_STRING ? "
$	inq/nop CHECK_AUTHORISATION "CHECK_AUTHORISATION ? "
$	inq/nop FIND_OPERATOR_ID "FIND_OPERATOR_ID ? "
$	inq/nop FIND_WORKSTATION_ID "FIND_WORKSTATION_ID ? "
$	inq/nop NOTIFY_STATUS "NOTIFY_STATUS ? "
$	inq/nop NOTIFY_JOB_STARTED "NOTIFY_JOB_STARTED ? "
$	inq/nop NOTIFY_PROJECT_STARTED "NOTIFY_PROJECT_STARTED ? "
$	inq/nop NOTIFY_SESSION_FINISHED "NOTIFY_SESSION_FINISHED ? "
$	inq/nop REQUEST_MENU "REQUEST_MENU ? "
$	inq/nop NON_INTERACTIVE_REQUEST "NON_INTERACTIVE_REQUEST ? "
$	inq/nop TASK_REQUEST_MENU "TASK_REQUEST_MENU ? "
$	inq/nop JOB_REQUEST_MENU "JOB_REQUEST_MENU ? "
$	inq/nop PROJECT_REQUEST_MENU "PROJECT_REQUEST_MENU ? "
$	inq/nop MANAGE_MENU "MANAGE_MENU ? "
$	inq/nop SYSTEM_DEFINITION_MENU "SYSTEM_DEFINITION_MENU ? "
$	inq/nop CREATE_SYSTEM_DEFINITION "CREATE_SYSTEM_DEFINITION ? "
$	inq/nop CREATE_FLOWLINE_DEFINITION -
				"CREATE_FLOWLINE_DEFINITION ? "
$	inq/nop CREATE_ELEMENT_DEFINITION "CREATE_ELEMENT_DEFINITION ? "
$	inq/nop DISPLAY_ELEMENT_OUTCOMES_AREA -
				"DISPLAY_ELEMENT_OUTCOMES_AREA ? "
$	inq/nop GET_ELEMENT_OUTCOMES_AREA -
				"GET_ELEMENT_OUTCOMES_AREA ? "
$	inq/nop CREATE_WIRE_DEFINITION "CREATE_WIRE_DEFINITION ? "
$	inq/nop CREATE_PROCEDURE_DEFINITION -
				"CREATE_PROCEDURE_DEFINITION ? "
$	inq/nop MANAGE_CREATION_MENU "MANAGE_CREATION_MENU ? "
$	inq/nop NON_INTERACTIVE_CREATE_JOB -
				"NON_INTERACTIVE_CREATE_JOB ? "
$	inq/nop PROJECT_INITIATION "PROJECT_INITIATION ? "
$	inq/nop JOB_INITIATION "JOB_INITIATION ? "
$	inq/nop MANAGE_AUTHORISATION_MENU "MANAGE_AUTHORISATION_MENU ? "
$	inq/nop OPERATOR_AUTH_FORM "OPERATOR_AUTH_FORM ? "
$	inq/nop WORKSTATION_AUTH_FORM "WORKSTATION_AUTH_FORM ? "
$	inq/nop GET_AUTH_AREA "GET_AUTH_AREA ? "
$	inq/nop DISPLAY_AUTH_AREA "DISPLAY_AUTH_AREA ? "
$	inq/nop PROJECT_STATUS_MENU "PROJECT_STATUS_MENU ? "
$	inq/nop JOB_STATUS_MENU "JOB_STATUS_MENU ? "
$	inq/nop JOB_MOVE_ELEMENT_MENU "JOB_MOVE_ELEMENT_MENU ? "
$	inq/nop TASK_STATUS_MENU "TASK_STATUS_MENU ? "
$	inq/nop MANAGE_NOTIFICATION_MENU "MANAGE_NOTIFICATION_MENU ? "
$	inq/nop PROJECT_NOTIFICATION_MENU "PROJECT_NOTIFICATION_MENU ? "
$	inq/nop JOB_NOTIFICATION_MENU "JOB_NOTIFICATION_MENU ? "
$	inq/nop SESSION_NOTIFICATION_MENU "SESSION_NOTIFICATION_MENU ? "
$	inq/nop SESSION_FINISHED_FORM "SESSION_FINISHED_FORM ? "
$	inq/nop GET_PARAMETERS_FORM "GET_PARAMETERS_FORM ? "
$	inq/nop REPORT_MENU "REPORT_MENU ? "
$	inq/nop REPORT_DEFINITION_MENU "REPORT_DEFINITION_MENU ? "
$	inq/nop FLOWLINE_DEFINITION_REPORT -
					"FLOWLINE_DEFINITION_REPORT ? "
$	inq/nop FLOWLINE_SELECTION_MENU -
					"FLOWLINE_SELECTION_MENU ? "
$	inq/nop ELEMENT_DEFINITION_REPORT -
					"ELEMENT_DEFINITION_REPORT ? "
$	inq/nop WIRE_DEFINITION_REPORT -
					"WIRE_DEFINITION_REPORT ? "
$	inq/nop PROCEDURE_DEFINITION_REPORT -
					"PROCEDURE_DEFINITION_REPORT ? "
$	inq/nop REPORT_STATUS_MENU "REPORT_STATUS_MENU ? "
$	inq/nop PROJECT_STATUS_REPORT "PROJECT_STATUS_REPORT ? "
$	inq/nop JOB_STATUS_REPORT "JOB_STATUS_REPORT ? "
$	inq/nop SESSION_STATUS_REPORT "SESSION_STATUS_REPORT ? "
$	inq/nop OPERATOR_STATUS_REPORT "OPERATOR_STATUS_REPORT ? "
$	inq/nop WORKSTATION_STATUS_REPORT "WORKSTATION_STATUS_REPORT ? "
$	inq/nop TASK_STATUS_REPORT "TASK_STATUS_REPORT ? "
$	inq/nop REPORT_STATISTICS_MENU "REPORT_STATISTICS_MENU ? "
$	inq/nop PROJECT_STATISTICS_MENU "PROJECT_STATISTICS_MENU ? "
$	inq/nop PROJECT_STATISTICS_REPORT "PROJECT_STATISTICS_REPORT ? "
$	inq/nop JOB_STATISTICS_MENU "JOB_STATISTICS_MENU ? "
$	inq/nop JOB_STATISTICS_REPORT "JOB_STATISTICS_REPORT ? "
$	inq/nop TASK_STATISTICS_MENU "TASK_STATISTICS_MENU ? "
$	inq/nop TASK_STATISTICS_REPORT "TASK_STATISTICS_REPORT ? "
$	inq/nop SESSION_STATISTICS_REPORT "SESSION_STATISTICS_REPORT ? "
$	inq/nop FLOWLINE_STATISTICS_MENU "FLOWLINE_STATISTICS_MENU ? "
$	inq/nop FLOWLINE_STATISTICS_REPORT "FLOWLINE_STATISTICS_REPORT ? "
$	inq/nop ELEMENT_STATISTICS_MENU "ELEMENT_STATISTICS_MENU ? "
$	inq/nop ELEMENT_STATISTICS_REPORT "ELEMENT_STATISTICS_REPORT ? "
$	inq/nop PER_ELEMENT_STATISTICS_MENU "PER_ELEMENT_STATISTICS_MENU ? "
$	inq/nop ELEM_OPER_STATISTICS_REPORT "ELEM_OPER_STATISTICS_REPORT ? "
$	inq/nop ELEM_WORK_STATISTICS_REPORT "ELEM_WORK_STATISTICS_REPORT ? "
$	inq/nop OPERATOR_STATISTICS_MENU "OPERATOR_STATISTICS_MENU ? "
$	inq/nop OPER_TOTAL_STATISTICS_REPORT "OPER_TOTAL_STATISTICS_REPORT ? "
$	inq/nop PER_OPERATOR_STATISTICS_MENU "PER_OPERATOR_STATISTICS_MENU ? "
$	inq/nop PER_OPER_WORK_STATISTICS_REPORT "PER_OPER_WORK_STATISTICS_REPORT ? "
$	inq/nop PER_OPER_ELEM_STATISTICS_REPORT "PER_OPER_ELEM_STATISTICS_REPORT ? "
$	inq/nop WORKSTATION_STATISTICS_MENU "WORKSTATION_STATISTICS_MENU ? "
$	inq/nop WORK_TOTAL_STATISTICS_REPORT "WORK_TOTAL_STATISTICS_REPORT ? "
$	inq/nop PER_WORKSTATION_STATISTICS_MENU "PER_WORKSTATION_STATISTICS_MENU ? "
$	inq/nop PER_WORK_OPER_STATISTICS_REPORT "PER_WORK_OPER_STATISTICS_REPORT ? "
$	inq/nop PER_WORK_ELEM_STATISTICS_REPORT "PER_WORK_ELEM_STATISTICS_REPORT ? "
$	inq/nop OPEN_REPORT_FILE "OPEN_REPORT_FILE ? "
$	inq/nop CLOSE_REPORT_FILE "CLOSE_REPORT_FILE ? "
$	inq/nop CONTROL_MENU "CONTROL_MENU ? "
$	inq/nop DISPLAY_MENU "DISPLAY_MENU ? "
$	inq/nop GET_MENU_OPTION "GET_MENU_OPTION ? "
$	inq/nop DISPLAY_AREA_OPTION "DISPLAY_AREA_OPTION ? "
$	inq/nop GET_AREA_OPTION "GET_AREA_OPTION ? "
$	inq/nop SETUP_DCL "SETUP_DCL ? "
$	inq/nop OPEN_COMMAND_FILE "OPEN_COMMAND_FILE ? "
$	inq/nop WRITE_COMMAND_FILE "WRITE_COMMAND_FILE ? "
$	inq/nop OUTPUT_SHARED_DCL "OUTPUT_SHARED_DCL ? "
$	inq/nop WRITE_TASK_COMPROC "WRITE_TASK_COMPROC ? "
$	inq/nop WRITE_LOGOFF_COMPROC "WRITE_LOGOFF_COMPROC ? "
$	inq/nop WRITE_NULL_COMPROC "WRITE_NULL_COMPROC ? "
$	inq/nop WRITE_ERROR_COMPROC "WRITE_ERROR_COMPROC ? "
$	inq/nop WRITE_WAIT_COMPROC "WRITE_WAIT_COMPROC ? "
$	inq/nop WRITE_CREATE_JOB_COMPROC "WRITE_CREATE_JOB_COMPROC ? "
$	inq/nop WRITE_CREATE_PROJECT_COMPROC -
				"WRITE_CREATE_PROJECT_COMPROC ? "
$	inq/nop CLOSE_COMMAND_FILE "CLOSE_COMMAND_FILE ? "
$	inq/nop CLEAR_MESSAGE_LINES "CLEAR_MESSAGE_LINES ? "
$	inq/nop DISPLAY_HELP_LINE "DISPLAY_HELP_LINE ? "
$	inq/nop FORM_GETLINE "FORM_GETLINE ? "
$	inq/nop FORM_PUTMSG "FORM_PUTMSG ? "
$	inq/nop LCONT_PUTMSG "LCONT_PUTMSG ? "
$	inq/nop LCONT_ADDMSG "LCONT_ADDMSG ? "
$	inq/nop LOG_ENTRY "LOG_ENTRY ? "
$	inq/nop OPEN_LOG_FILE "OPEN_LOG_FILE ? "
$	inq/nop FIND_LOG_DETAILS "FIND_LOG_DETAILS ? "
$	inq/nop CLOSE_LOG_FILE "CLOSE_LOG_FILE ? "
$	inq/nop WIDE_SCREEN "WIDE_SCREEN ? "
$	inq/nop WANT_CURSOR "WANT_CURSOR ? "
$	inq/nop WANT_TYPE_AHEAD "WANT_TYPE_AHEAD ? "
$	inq/nop WANT_ECHO "WANT_ECHO ? "
$	inq/nop EDIT_FILE "EDIT_FILE ? "
$	inq/nop OUTPUT_CONTROL_STRING "OUTPUT_CONTROL_STRING ? "
$	inq/nop STRIP_DOUBLE_QUOTES "STRIP_DOUBLE_QUOTES ? "
$	inq/nop CENTRE_STRING "CENTRE_STRING ? "
$	inq/nop SIGNCH "SIGNCH ? "
$	inq/nop CONVERT_TIME_TO_STRING "CONVERT_TIME_TO_STRING ? "
$	inq/nop CONVERT_DAY_TO_STRING "CONVERT_DAY_TO_STRING ? "
$	inq/nop EXCEPTION_HANDLER "EXCEPTION_HANDLER ? "
$!
$ a11:
$!
$	inq/nop cldgen	"Generate command definitions? "
$	inq/nop frmgen "Generate form library? "
$	inq/nop mes "Generate message definitions ? "
$	inq/nop lnkit "Link ? "
$	if .not. lnkit then goto notkb
$!
$	   linkver="lampscontrol"
$!
$	   linkopts="/map/full"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!
$ notkb:
$		wc "$ 	set noverify"
$!
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 	set verify"
$!
$	if .not.mes then goto do_frm
$!
$		wc "$	newmsg/runoff/number=1712/prefix=LSC__ -"
$		wc "	/parameter=for/runoff -"
$		wc "	lsl$lampscontrol:lampscontrol.mes"
$		wc "$ @lampscontrol.temp_com"
$		wc "$	rename/log/noconf lsl$compile:lampscontrolmsg.par; -"
$		wc "		lsl$lampscontrol:lampscontrolmsg.par;"
$!	
$ do_frm:
$!
$	if .not. frmgen then goto do_cld
$!
$		wc "$	fms/library/create lampscontrol_form_lib -"
$		wc "	   lsl$lampscontrol:title_page,-"
$		wc "	   lsl$lampscontrol:lampscontrol_menu,-"
$		wc "	   lsl$lampscontrol:general_menu_help_1,-"
$		wc "	   lsl$lampscontrol:general_menu_help_2,-"
$		wc "	   lsl$lampscontrol:request_menu_help_1,-"
$		wc "	   lsl$lampscontrol:report_menu_help_1,-"
$		wc "	   lsl$lampscontrol:manage_menu_help_1,-"
$		wc "	   lsl$lampscontrol:manage_menu_help_2,-"
$		wc "	   lsl$lampscontrol:general_form_help_1,-"
$		wc "	   lsl$lampscontrol:general_form_help_2,-"
$		wc "	   lsl$lampscontrol:general_form_help_3,-"
$		wc "	   lsl$lampscontrol:general_form_help_4,-"
$		wc "	   lsl$lampscontrol:project_create_form,-"
$		wc "	   lsl$lampscontrol:job_create_form,-"
$		wc "	   lsl$lampscontrol:op_auth_form,-"
$		wc "	   lsl$lampscontrol:wks_auth_form,-"
$		wc "	   lsl$lampscontrol:session_finished, -"
$		wc "	   lsl$lampscontrol:parameter_form, -"
$		wc "	   lsl$lampscontrol:element_definition_form, -"
$		wc "	   lsl$lampscontrol:flowline_definition_form, -"
$		wc "	   lsl$lampscontrol:procedure_definition_form,-"
$		wc "	   lsl$lampscontrol:system_definition_form, -"
$		wc "	   lsl$lampscontrol:wire_definition_form"
$		wc "$	fms/object lampscontrol_form_lib.flb"
$!
$ do_cld:
$!
$	if .not. cldgen then goto do_cmp
$!
$		wc "$	macro/object=lsl$compile:parameter_cmd.obj lsl$lampscontrol:parameter_cmd.mar"
$		wc "$	purge lsl$compile:parameter_cmd.obj"
$!
$		wc "$	adc lampscontrol.tmp = lsl$lampscontrol:lampscontrol_cld.cld"
$		wc "$	set command/object =lampscontrol_cld lampscontrol.tmp"
$		wc "$	pvv lampscontrol_cld"
$		wc "$	delete lampscontrol.tmp;*"
$		wc "$	delete adc.ide;*"
$		wc "$	purge lampscontrol_cld.obj"
$!
$ do_cmp: 
$	if .not. compile then goto lnkonly
$!	
$ cmponly:		
$!
$	if LAMPSCONTROL then call compiler LAMPSCONTROL
$	if LAMPSCONTROL_INIT then call compiler LAMPSCONTROL_INIT
$	if SETUP_EXIT_HANDLER then call compiler SETUP_EXIT_HANDLER
$	if EXIT_HANDLER then call compiler EXIT_HANDLER
$	if TITLE_PAGE then call compiler TITLE_PAGE
$	if LAMPSCONTROL_CLOSEDOWN then -
				call compiler LAMPSCONTROL_CLOSEDOWN
$	if GET_COMMAND then call compiler GET_COMMAND
$	if DEFINE_PARAMETERS then call compiler DEFINE_PARAMETERS
$	if PARSE_PARAM_STRING then call compiler PARSE_PARAM_STRING
$	if STORE_PARAM_STRING then call compiler STORE_PARAM_STRING
$	if CHECK_AUTHORISATION then call compiler CHECK_AUTHORISATION
$	if FIND_OPERATOR_ID then call compiler FIND_OPERATOR_ID
$	if FIND_WORKSTATION_ID then call compiler FIND_WORKSTATION_ID
$	if NOTIFY_STATUS then call compiler NOTIFY_STATUS
$	if NOTIFY_JOB_STARTED then call compiler NOTIFY_JOB_STARTED
$	if NOTIFY_PROJECT_STARTED then -
				call compiler NOTIFY_PROJECT_STARTED
$	if NOTIFY_SESSION_FINISHED then -
				call compiler NOTIFY_SESSION_FINISHED
$	if REQUEST_MENU then call compiler REQUEST_MENU
$	if NON_INTERACTIVE_REQUEST then -
				call compiler NON_INTERACTIVE_REQUEST
$	if TASK_REQUEST_MENU then call compiler TASK_REQUEST_MENU
$	if JOB_REQUEST_MENU then call compiler JOB_REQUEST_MENU
$	if PROJECT_REQUEST_MENU then call compiler PROJECT_REQUEST_MENU
$	if MANAGE_MENU then call compiler MANAGE_MENU
$	if SYSTEM_DEFINITION_MENU then -
				call compiler SYSTEM_DEFINITION_MENU
$	if CREATE_SYSTEM_DEFINITION then -
				call compiler CREATE_SYSTEM_DEFINITION
$	if CREATE_FLOWLINE_DEFINITION then -
				call compiler CREATE_FLOWLINE_DEFINITION
$	if CREATE_ELEMENT_DEFINITION then -
				call compiler CREATE_ELEMENT_DEFINITION
$	if DISPLAY_ELEMENT_OUTCOMES_AREA then -
			call compiler DISPLAY_ELEMENT_OUTCOMES_AREA
$	if GET_ELEMENT_OUTCOMES_AREA then -
			call compiler GET_ELEMENT_OUTCOMES_AREA
$	if CREATE_WIRE_DEFINITION then -
				call compiler CREATE_WIRE_DEFINITION
$	if CREATE_PROCEDURE_DEFINITION then call -
				compiler CREATE_PROCEDURE_DEFINITION
$	if MANAGE_CREATION_MENU then call compiler MANAGE_CREATION_MENU
$	if NON_INTERACTIVE_CREATE_JOB then -
				call compiler NON_INTERACTIVE_CREATE_JOB
$	if PROJECT_INITIATION then call compiler PROJECT_INITIATION
$	if JOB_INITIATION then call compiler JOB_INITIATION
$	if MANAGE_AUTHORISATION_MENU then -
				call compiler MANAGE_AUTHORISATION_MENU
$	if OPERATOR_AUTH_FORM then call compiler OPERATOR_AUTH_FORM
$	if WORKSTATION_AUTH_FORM then -
				call compiler WORKSTATION_AUTH_FORM
$	if GET_AUTH_AREA then call compiler GET_AUTH_AREA
$	if DISPLAY_AUTH_AREA then call compiler DISPLAY_AUTH_AREA
$	if PROJECT_STATUS_MENU then call compiler PROJECT_STATUS_MENU
$	if JOB_STATUS_MENU then call compiler JOB_STATUS_MENU
$	if JOB_MOVE_ELEMENT_MENU then -
			call compiler JOB_MOVE_ELEMENT_MENU
$	if TASK_STATUS_MENU then call compiler TASK_STATUS_MENU
$	if MANAGE_NOTIFICATION_MENU then -
			call compiler MANAGE_NOTIFICATION_MENU
$	if PROJECT_NOTIFICATION_MENU then -
			call compiler PROJECT_NOTIFICATION_MENU
$	if JOB_NOTIFICATION_MENU then -
			call compiler JOB_NOTIFICATION_MENU
$	if SESSION_NOTIFICATION_MENU then -
			call compiler SESSION_NOTIFICATION_MENU
$	if SESSION_FINISHED_FORM then -
			call compiler SESSION_FINISHED_FORM
$	if GET_PARAMETERS_FORM then -
			call compiler GET_PARAMETERS_FORM
$	if REPORT_MENU then call compiler REPORT_MENU
$	if REPORT_DEFINITION_MENU then -
				call compiler REPORT_DEFINITION_MENU 
$	if FLOWLINE_DEFINITION_REPORT then -
			call compiler FLOWLINE_DEFINITION_REPORT
$	if FLOWLINE_SELECTION_MENU then -
			call compiler FLOWLINE_SELECTION_MENU
$	if ELEMENT_DEFINITION_REPORT then -
			call compiler ELEMENT_DEFINITION_REPORT 
$	if WIRE_DEFINITION_REPORT then -
			call compiler WIRE_DEFINITION_REPORT 
$	if PROCEDURE_DEFINITION_REPORT then -
			call compiler PROCEDURE_DEFINITION_REPORT 
$	if REPORT_STATUS_MENU then -
				call compiler REPORT_STATUS_MENU 
$	if PROJECT_STATUS_REPORT then -
				call compiler PROJECT_STATUS_REPORT
$	if JOB_STATUS_REPORT then -
				call compiler JOB_STATUS_REPORT
$	if SESSION_STATUS_REPORT then -
				call compiler SESSION_STATUS_REPORT
$	if OPERATOR_STATUS_REPORT then -
				call compiler OPERATOR_STATUS_REPORT
$	if WORKSTATION_STATUS_REPORT then -
				call compiler WORKSTATION_STATUS_REPORT
$	if TASK_STATUS_REPORT then -
				call compiler TASK_STATUS_REPORT
$	if REPORT_STATISTICS_MENU then -
				call compiler REPORT_STATISTICS_MENU 
$	if PROJECT_STATISTICS_MENU then -
				call compiler PROJECT_STATISTICS_MENU
$	if PROJECT_STATISTICS_REPORT then -
				call compiler PROJECT_STATISTICS_REPORT 
$	if JOB_STATISTICS_MENU then -
				call compiler JOB_STATISTICS_MENU
$	if JOB_STATISTICS_REPORT then -
				call compiler JOB_STATISTICS_REPORT 
$	if TASK_STATISTICS_MENU then -
				call compiler TASK_STATISTICS_MENU
$	if TASK_STATISTICS_REPORT then -
				call compiler TASK_STATISTICS_REPORT 
$	if SESSION_STATISTICS_REPORT then -
				call compiler SESSION_STATISTICS_REPORT 
$	if FLOWLINE_STATISTICS_MENU then -
				call compiler FLOWLINE_STATISTICS_MENU
$	if FLOWLINE_STATISTICS_REPORT then -
				call compiler FLOWLINE_STATISTICS_REPORT
$	if ELEMENT_STATISTICS_MENU then -
				call compiler ELEMENT_STATISTICS_MENU
$	if ELEMENT_STATISTICS_REPORT then -
				call compiler ELEMENT_STATISTICS_REPORT
$	if PER_ELEMENT_STATISTICS_MENU then call -
				compiler PER_ELEMENT_STATISTICS_MENU
$	if ELEM_OPER_STATISTICS_REPORT then call -
				compiler ELEM_OPER_STATISTICS_REPORT
$	if ELEM_WORK_STATISTICS_REPORT then call -
				compiler ELEM_WORK_STATISTICS_REPORT
$	if  OPERATOR_STATISTICS_MENU then -
			call compiler OPERATOR_STATISTICS_MENU
$	if OPER_TOTAL_STATISTICS_REPORT then -
			call compiler OPER_TOTAL_STATISTICS_REPORT
$	if PER_OPERATOR_STATISTICS_MENU then -
			call compiler PER_OPERATOR_STATISTICS_MENU
$	if PER_OPER_WORK_STATISTICS_REPORT then -
			call compiler PER_OPER_WORK_STATISTICS_REPORT
$	if PER_OPER_ELEM_STATISTICS_REPORT then -
			call compiler PER_OPER_ELEM_STATISTICS_REPORT
$	if WORKSTATION_STATISTICS_MENU then -
			call compiler WORKSTATION_STATISTICS_MENU
$	if WORK_TOTAL_STATISTICS_REPORT then -
			call compiler WORK_TOTAL_STATISTICS_REPORT
$	if PER_WORKSTATION_STATISTICS_MENU then -
			call compiler PER_WORKSTATION_STATISTICS_MENU
$	if PER_WORK_OPER_STATISTICS_REPORT then -
			call compiler PER_WORK_OPER_STATISTICS_REPORT
$	if PER_WORK_ELEM_STATISTICS_REPORT then -
			call compiler PER_WORK_ELEM_STATISTICS_REPORT
$	if OPEN_REPORT_FILE then call compiler OPEN_REPORT_FILE
$	if CLOSE_REPORT_FILE then call compiler CLOSE_REPORT_FILE
$	if CONTROL_MENU then call compiler CONTROL_MENU
$	if DISPLAY_MENU then call compiler DISPLAY_MENU
$	if GET_MENU_OPTION then call compiler GET_MENU_OPTION
$	if DISPLAY_AREA_OPTION then call compiler DISPLAY_AREA_OPTION
$	if GET_AREA_OPTION then call compiler GET_AREA_OPTION
$	if SETUP_DCL then call compiler SETUP_DCL
$	if OPEN_COMMAND_FILE then call compiler OPEN_COMMAND_FILE
$	if WRITE_COMMAND_FILE then call compiler WRITE_COMMAND_FILE
$	if OUTPUT_SHARED_DCL then call compiler OUTPUT_SHARED_DCL
$	if WRITE_TASK_COMPROC then call compiler WRITE_TASK_COMPROC
$	if WRITE_LOGOFF_COMPROC then call compiler WRITE_LOGOFF_COMPROC
$	if WRITE_NULL_COMPROC then call compiler WRITE_NULL_COMPROC
$	if WRITE_ERROR_COMPROC then call compiler WRITE_ERROR_COMPROC
$	if WRITE_WAIT_COMPROC then call compiler WRITE_WAIT_COMPROC
$	if WRITE_CREATE_JOB_COMPROC then -
			call compiler WRITE_CREATE_JOB_COMPROC
$	if WRITE_CREATE_PROJECT_COMPROC then -
			call compiler WRITE_CREATE_PROJECT_COMPROC
$	if CLOSE_COMMAND_FILE then call compiler CLOSE_COMMAND_FILE
$	if FORM_GETLINE then call compiler FORM_GETLINE
$	if FORM_PUTMSG then call compiler FORM_PUTMSG
$	if CLEAR_MESSAGE_LINES then call compiler CLEAR_MESSAGE_LINES
$	if DISPLAY_HELP_LINE then call compiler DISPLAY_HELP_LINE
$	if LCONT_PUTMSG then call compiler LCONT_PUTMSG
$	if LCONT_ADDMSG then call compiler LCONT_ADDMSG
$	if LOG_ENTRY then call compiler LOG_ENTRY
$	if OPEN_LOG_FILE then call compiler OPEN_LOG_FILE
$	if FIND_LOG_DETAILS then call compiler FIND_LOG_DETAILS
$	if CLOSE_LOG_FILE then call compiler CLOSE_LOG_FILE
$	if WIDE_SCREEN then call compiler WIDE_SCREEN
$	if WANT_CURSOR then call compiler WANT_CURSOR
$	if WANT_TYPE_AHEAD then call compiler WANT_TYPE_AHEAD
$	if WANT_ECHO then call compiler WANT_ECHO
$	if EDIT_FILE then call compiler EDIT_FILE
$	if OUTPUT_CONTROL_STRING then - 
			call compiler OUTPUT_CONTROL_STRING
$	if CENTRE_STRING then call compiler CENTRE_STRING
$	if STRIP_DOUBLE_QUOTES then call compiler STRIP_DOUBLE_QUOTES
$	if SIGNCH then call compiler SIGNCH
$	if CONVERT_TIME_TO_STRING then -
			call compiler CONVERT_TIME_TO_STRING
$	if CONVERT_DAY_TO_STRING then -
			call compiler CONVERT_DAY_TO_STRING
$	if EXCEPTION_HANDLER then call compiler EXCEPTION_HANDLER
$!
$	   goto lnkonly
$!----------------------------------------------------------------------
$ compiler: subroutine 
$!----------------------------------------------------------------------
$		wc "$ 	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc lsl$compile:''p1'''kpcom'=lsl$lampscontrol:''p1'"
$	   	wc "$	fort''fsw1' ''p1'"
$	      	wc "$ 	ok=$status"	
$		wc "$ 	if ok then pvv ''p1'"
$		wc "$ 	purge/nolog ''p1'.obj"
$		if fsw1.eqs."" then -
		wc "$ 	delete/nolog ''p1'.for;*"
$		if fsw1.nes.""  then -
		wc "$ 	purge/nolog ''p1'.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
		wc "$ 	if ok then delete/nolog ''p1'.lis;*"
$		wc "$	if .not.ok then emsg=emsg+"" ''p1'"""
$		wc "$ 	delete adc.ide;*"
$		wc "$	set noverify"
$	return
$ endsubroutine
$!----------------------------------------------------------------------
$ lnkonly:
$	wc "$	set noverify"
$	wc "$	if emsg.eqs."""" then goto noerr"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	write sys$output ""Compilation errors in:"""
$	wc "$	write sys$output emsg"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	goto nolnk"
$	wc "$	noerr:"
$ 	if .not. lnkit then goto nolnk
$	wc "$ set noverify"
$	wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$ set verify"
$	wc "$ 	link''linkopts'/exe=lsl$lampscontrol:''linkver' -"
$	wc "		lsl$lampscontrol:lampscontrol/opt, -"
$	WC "		LSL$CMNFLOWLINE:flowline/lib, -"
$	WC "		lsl$library:lslshr/opt"
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	lampscontrolex:"
$		wc "$	sd lsl$lampscontrol"
$		wc "$ 	deass/group lsl$lampscontrol_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto lampscontrolex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Batch ? "
$	if .not. answer_bat then goto spw
$	deass/group lsl$lampscontrol_building
$	submit	/ident/notify/restart/noprint/keep/priority=109 -
		/log=lsl$compile:lampscontrolbat.log -
		lampscontrolbat.com
$!
$	goto lampscontrolx2
$ spw:
$	inq/nop answer_spawn "Spawn ? "
$	if .not. answer_spawn then goto int
$	deass/group lsl$lampscontrol_building
$	spawn	/notify/nowait -
		/output=lsl$compile:lampscontrolbat.log -
		@lampscontrolbat
$!
$	goto lampscontrolx2
$ int:	
$	inq/nop answer "Interactive ? "
$	if .not.answer then goto lampscontrolex
$	deass/group lsl$lampscontrol_building
$	@lampscontrolbat.com
$	goto lampscontrolx2
$ lampscontrolex:
$	deass/group lsl$lampscontrol_building
$ lampscontrolx2:
$	if ver then set verify
