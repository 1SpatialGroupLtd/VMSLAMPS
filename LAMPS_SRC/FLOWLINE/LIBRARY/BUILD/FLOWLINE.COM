$!
$! Command file to build the FLOWLINE library routines
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!	Created						MWSR 26-Feb-1988
$!
$	ver=f$verify(0)
$!
$	on error then goto flowlineex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$flowline_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto flowlineex
$	define/group lsl$flowline_building "in_progress"
$	define lsl$cmnflowline lsl$source_root:[flowline.library] 
$	open/write comfil flowlinebat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto flowlineex"
$	wc "$	if ""'","'f$logical(""lsl$flowline_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$flowline_building ""in_progress"""
$	wc "$	assign lsl$source_root:[flowline.library] lsl$cmnflowline"
$	wc "$   rfort:=$sys$system:rdbpre/fortran"
$	wc "$	sd:=$lsl$exe:sd"
$	wc "$	sd lsl$cmnflowline"
$!!!	wc "$	@lsl$com:flowlineini SITE DECCA2 INPUT"
$	wc "$	define lsl$fln_database lsl$source_root:[flowline.com]
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	flowline_dbg=""
$	mes=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop flowline_dbg "With Debug ? "
$	if .not. flowline_dbg then goto a04
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
$	   fln_add_string="f"
$	   fln_archive_job="f"
$	   fln_archive_session="f"
$	   fln_archive_task="f"
$	   fln_authorise_operator="f"
$	   fln_authorise_workstation="f"
$	   fln_begin_task="f"
$	   fln_change_par="f"
$	   fln_change_proj_pri="f"
$	   fln_change_job_name="f"
$	   fln_change_job_hist_name="f"
$	   fln_change_job_pri="f"
$	   fln_check_element="f"
$	   fln_check_element_flow="f"
$	   fln_check_flowline="f"
$	   fln_check_job="f"
$	   fln_check_lampsauth="f"
$	   fln_check_offline ="f"
$	   fln_check_operator="f"
$	   fln_check_procedure="f"
$	   fln_check_project="f"
$	   fln_check_workstation="f"
$	   fln_check_operator_auth="f"
$	   fln_check_workstation_auth="f"
$	   fln_complete_task="f"
$	   fln_complete_update="f"
$	   fln_conditions_syntax="f"
$	   fln_create_job="f"
$	   fln_create_project="f"
$	   fln_create_operator="f"
$	   fln_create_workstation="f"
$	   fln_define_element="f"
$	   fln_define_flowline="f"
$	   fln_define_procedure="f"
$	   fln_define_system="f"
$	   fln_define_wire="f"
$	   fln_delete_job="f"
$	   fln_delete_locals="f"
$	   fln_delete_operator="f"
$	   fln_delete_project="f"
$	   fln_delete_workstation="f"
$	   fln_end_flowline="f"
$	   fln_end_session="f"
$	   fln_end_sub_job="f"
$	   fln_eval="f"
$	   fln_get_all_wires="f"
$	   fln_get_comproc="f"
$	   fln_get_day_time="f"
$	   fln_get_externals="f"
$	   fln_get_flowln="f"
$	   fln_get_input_par="f"
$	   fln_get_locals ="f"
$	   fln_get_readys="f"
$	   fln_get_job_id="f"
$	   fln_get_job="f"
$	   fln_get_parameter_id="f"
$	   fln_get_session_id="f"
$	   fln_get_sub_jobs="f"
$	   fln_get_tasks="f"
$	   fln_get_tasks_job="f"
$	   fln_get_task_id="f"
$	   fln_get_task_info="f"
$	   fln_get_task_session="f"
$	   fln_get_wire_ends="f"
$	   fln_get_wires="f"
$	   fln_get_wire_status="f"
$	   fln_had_task="f"
$	   fln_hold_job="f"
$	   fln_hold_project="f"
$	   fln_hold_task="f"
$	   fln_init="f"
$	   fln_is_ready="f"
$	   fln_jobstart_update="f"
$	   fln_start_job="f"
$	   fln_list_op_auth="f"
$	   fln_list_authorised_tasks ="f"
$	   fln_list_job ="f"
$	   fln_list_task ="f"
$	   fln_list_session ="f"
$	   fln_list_job_his ="f"
$	   fln_list_task_his ="f"
$	   fln_list_session_his ="f"
$	   fln_process_outcome="f"
$	   fln_release_job="f"
$	   fln_release_project="f"
$	   fln_release_task="f"
$	   fln_remove_spaces="f"
$	   fln_reset_job="f"
$	   fln_reset_job_int="f"
$	   fln_reset_op_auth="f"
$	   fln_reset_update="f"
$	   fln_reset_work_auth="f"
$	   fln_retrieve_active_sessions="f"
$	   fln_retrieve_all_flowlines="f"
$	   fln_retrieve_all_flowline_ids="f"
$	   fln_retrieve_all_jobs="f"
$	   fln_retrieve_all_operators="f"
$	   fln_retrieve_all_oper_ids="f"
$	   fln_retrieve_all_projects="f"
$	   fln_retrieve_all_sessions="f"
$	   fln_retrieve_all_tasks="f"
$	   fln_retrieve_all_workstations="f"
$	   fln_retrieve_all_work_ids="f"
$	   fln_retrieve_created_jobs="f"
$	   fln_retrieve_created_projects="f"
$	   fln_retrieve_info_job_id="f"
$	   fln_retrieve_outer_info_job_id="f"
$	   fln_retrieve_wires_flowline="f"
$	   fln_retrieve_elements_flowline="f"
$	   fln_retrieve_elem_ids_flowline="f"
$	   fln_retrieve_all_procedures="f"
$	   fln_retrieve_job_hist_project="f"
$	   fln_retrieve_jobs_project="f"
$	   fln_retrieve_task_hist_job="f"
$	   fln_retrieve_tasks_job="f"
$	   fln_retrieve_operator_auth="f"
$	   fln_retrieve_workstation_auth="f"
$	   fln_retrieve_current="f"
$	   fln_retrieve_current_job="f"
$	   fln_retrieve_current_project="f"
$	   fln_retrieve_current_task="f"
$	   fln_retrieve_element_def="f"
$	   fln_retrieve_wire_def="f"
$	   fln_retrieve_procedure_def="f"
$	   fln_retrieve_flowline_def="f"
$	   fln_retrieve_system_def="f"
$	   fln_retrieve_job_task="f"
$	   fln_retrieve_jobs="f"
$	   fln_retrieve_projects="f"
$	   fln_retrieve_project_timings="f"
$	   fln_retrieve_job_timings="f"
$	   fln_retrieve_session_timings="f"
$	   fln_retrieve_task_timings="f"
$	   fln_retrieve_element_timings="f"
$	   fln_retrieve_flowline_timings="f"
$	   fln_retrieve_elem_oper_timings="f"
$	   fln_retrieve_elem_work_timings="f"
$	   fln_retrieve_oper_work_timings="f"
$	   fln_retrieve_work_oper_timings="f"
$	   fln_retrieve_oper_elem_timings="f"
$	   fln_retrieve_work_elem_timings="f"
$	   fln_retrieve_oper_total_timings="f"
$	   fln_retrieve_work_total_timings="f"
$	   fln_retrieve_resets="f"
$	   fln_retrieve_session_pje="f"
$	   fln_retrieve_tasks="f"
$	   fln_sess_complete="f"
$	   fln_sess_continue="f"
$	   fln_sess_error="f"
$	   fln_sess_offline="f"
$	   fln_sess_restart="f"
$	   fln_sess_subflowline="f"
$	   fln_set_wires="f"
$	   fln_setup_tasks="f"
$	   fln_set_current="f"
$	   fln_set_current_pje="f"
$	   fln_set_current_task="f"
$	   fln_set_current_job="f"
$	   fln_set_current_project="f"
$	   fln_set_globals="f"
$	   fln_set_job="f"
$	   fln_set_locals="f"
$	   fln_set_locals_tr="f"
$	   fln_set_project="f"
$	   fln_set_task="f"
$	   fln_set_task_status="f"
$	   fln_skip_task="f"
$	   fln_start_job="f"
$	   fln_start_project="f"
$	   fln_start_session="f"
$	   fln_start_task="f"
$!
$	   inq/nop everything "Compile all sources ? "
$	   if .not. everything then goto a05
$	   fln_add_string="t"
$	   fln_archive_job="t"
$	   fln_archive_session="t"
$	   fln_archive_task="t"
$	   fln_authorise_operator="t"
$	   fln_authorise_workstation="t"
$	   fln_begin_task="t"
$	   fln_change_par="t"
$	   fln_change_proj_pri="t"
$	   fln_change_job_name="t"
$	   fln_change_job_hist_name="t"
$	   fln_change_job_pri="t"
$	   fln_check_element="t"
$	   fln_check_element_flow="t"
$	   fln_check_flowline="t"
$	   fln_check_job="t"
$	   fln_check_lampsauth="t"
$	   fln_check_offline ="t"
$	   fln_check_operator="t"
$	   fln_check_procedure="t"
$	   fln_check_project="t"
$	   fln_check_workstation="t"
$	   fln_check_operator_auth="t"
$	   fln_check_workstation_auth="t"
$	   fln_complete_task="t"
$	   fln_complete_update="t"
$	   fln_conditions_syntax="t"
$	   fln_create_job="t"
$	   fln_create_project="t"
$	   fln_create_operator="t"
$	   fln_create_workstation="t"
$	   fln_define_element="t"
$	   fln_define_flowline="t"
$	   fln_define_procedure="t"
$	   fln_define_system="t"
$	   fln_define_wire="t"
$	   fln_delete_job="t"
$	   fln_delete_locals="t"
$	   fln_delete_operator="t"
$	   fln_delete_project="t"
$	   fln_delete_workstation="t"
$	   fln_end_flowline="t"
$	   fln_end_session="t"
$	   fln_end_sub_job="t"
$	   fln_eval="t"
$	   fln_get_all_wires="t"
$	   fln_get_comproc="t"
$	   fln_get_day_time="t"
$	   fln_get_externals="t"
$	   fln_get_flowln="t"
$	   fln_get_locals ="t"
$	   fln_get_input_par="t"
$	   fln_get_readys="t"
$	   fln_get_job="t"
$	   fln_get_job_id="t"
$	   fln_get_parameter_id="t"
$	   fln_get_session_id="t"
$	   fln_get_sub_jobs="t"
$	   fln_get_tasks="t"
$	   fln_get_tasks_job="t"
$	   fln_get_task_id="t"
$	   fln_get_task_info="t"
$	   fln_get_task_session="t"
$	   fln_get_wire_ends="t"
$	   fln_get_wires="t"
$	   fln_get_wire_status="t"
$	   fln_had_task="t"
$	   fln_hold_job="t"
$	   fln_hold_project="t"
$	   fln_hold_task="t"
$	   fln_init="t"
$	   fln_is_ready="t"
$	   fln_jobstart_update="t"
$	   fln_start_project="t"
$	   fln_list_op_auth="t"
$	   fln_list_authorised_tasks="t"
$	   fln_list_job ="t"
$	   fln_list_task ="t"
$	   fln_list_session ="t"
$	   fln_list_job_his ="t"
$	   fln_list_task_his ="t"
$	   fln_list_session_his ="t"
$	   fln_process_outcome="t"
$	   fln_release_job="t"
$	   fln_release_project="t"
$	   fln_release_task="t"
$	   fln_remove_spaces="t"
$	   fln_reset_job="t"
$	   fln_reset_job_int="t"
$	   fln_reset_op_auth="t"
$	   fln_reset_work_auth="t"
$	   fln_reset_update="t"
$	   fln_retrieve_wires_flowline="t"
$	   fln_retrieve_elements_flowline="t"
$	   fln_retrieve_elem_ids_flowline="t"
$	   fln_retrieve_all_procedures="t"
$	   fln_retrieve_active_sessions="t"
$	   fln_retrieve_all_flowlines="t"
$	   fln_retrieve_all_flowline_ids="t"
$	   fln_retrieve_all_jobs="t"
$	   fln_retrieve_all_operators="t"
$	   fln_retrieve_all_oper_ids="t"
$	   fln_retrieve_all_projects="t"
$	   fln_retrieve_all_sessions="t"
$	   fln_retrieve_all_tasks="t"
$	   fln_retrieve_all_workstations="t"
$	   fln_retrieve_all_work_ids="t"
$	   fln_retrieve_created_jobs="t"
$	   fln_retrieve_created_projects="t"
$	   fln_retrieve_info_job_id="t"
$	   fln_retrieve_outer_info_job_id="t"
$	   fln_retrieve_job_hist_project="t"
$	   fln_retrieve_jobs_project="t"
$	   fln_retrieve_task_hist_job="t"
$	   fln_retrieve_tasks_job="t"
$	   fln_retrieve_current="t"
$	   fln_retrieve_current_job="t"
$	   fln_retrieve_current_project="t"
$	   fln_retrieve_current_task="t"
$	   fln_retrieve_element_def="t"
$	   fln_retrieve_wire_def="t"
$	   fln_retrieve_procedure_def="t"
$	   fln_retrieve_flowline_def="t"
$	   fln_retrieve_system_def="t"
$	   fln_retrieve_job_task="t"
$	   fln_retrieve_jobs="t"
$	   fln_retrieve_operator_auth="t"
$	   fln_retrieve_workstation_auth="t"
$	   fln_retrieve_projects="t"
$	   fln_retrieve_project_timings="t"
$	   fln_retrieve_job_timings="t"
$	   fln_retrieve_session_timings="t"
$	   fln_retrieve_task_timings="t"
$	   fln_retrieve_element_timings="t"
$	   fln_retrieve_elem_oper_timings="t"
$	   fln_retrieve_elem_work_timings="t"
$	   fln_retrieve_oper_work_timings="t"
$	   fln_retrieve_work_oper_timings="t"
$	   fln_retrieve_oper_elem_timings="t"
$	   fln_retrieve_work_elem_timings="t"
$	   fln_retrieve_flowline_timings="t"
$	   fln_retrieve_oper_total_timings="t"
$	   fln_retrieve_work_total_timings="t"
$	   fln_retrieve_resets="t"
$	   fln_retrieve_session_pje="t"
$	   fln_retrieve_tasks="t"
$	   fln_sess_complete="t"
$	   fln_sess_continue="t"
$	   fln_sess_error="t"
$	   fln_sess_offline="t"
$	   fln_sess_restart="t"
$	   fln_sess_subflowline="t"
$	   fln_set_wires="t"
$	   fln_setup_tasks="t"
$	   fln_set_current="t"
$	   fln_set_current_pje="t"
$	   fln_set_current_task="t"
$	   fln_set_current_job="t"
$	   fln_set_current_project="t"
$	   fln_set_globals="t"
$	   fln_set_job="t"
$	   fln_set_locals="t"
$	   fln_set_locals_tr="t"
$	   fln_set_project="t"
$	   fln_set_task="t"
$	   fln_set_task_status="t"
$	   fln_start_job="t"
$	   fln_skip_task="t"
$	   fln_start_project="t"
$	   fln_start_session="t"
$	   fln_start_task="t"
$!
$	   goto a11
$!
$ a05:	   
$	   inq/nop next_lot     "a, b routines ? "
$ 	   if .not. next_lot then goto cr
$	   inq/nop fln_add_string "Compile fln_add_string ? " 
$	   inq/nop fln_archive_job "Compile fln_archive_job ? " 
$	   inq/nop fln_archive_task "Compile fln_archive_task ? " 
$	   inq/nop fln_archive_session "Compile fln_archive_session ? " 
$	   inq/nop fln_authorise_operator "Compile fln_authorise_operator ? " 
$	   inq/nop fln_authorise_workstation "Compile fln_authorise_workstation ? " 
$	   inq/nop fln_begin_task "Compile fln_begin_task? " 
$ cr:	   
$	   inq/nop next_lot     "c  routines ? "
$ 	   if .not. next_lot then goto er
$	   inq/nop fln_change_proj_pri "Compile fln_change_proj_pri ?" 
$	   inq/nop fln_change_job_name "Compile fln_change_job_name ?" 
$	   inq/nop fln_change_job_hist_name "Compile fln_change_job_hist_name ?" 
$	   inq/nop fln_change_job_pri "Compile fln_change_job_pri ?" 
$	   inq/nop fln_change_par "Compile fln_change_par ?" 
$	   inq/nop fln_check_element  "Compile fln_check_element ?" 
$	   inq/nop fln_check_element_flow  "Compile fln_check_element_flow ?" 
$	   inq/nop fln_check_flowline "Compile fln_check_flowline ?" 
$	   inq/nop fln_check_job "Compile fln_check_job ?" 
$	   inq/nop fln_check_lampsauth "Compile fln_check_lampsauth ?" 
$	   inq/nop fln_check_offline "Compile fln_check_offline ?" 
$	   inq/nop fln_check_operator "Compile fln_check_operator ?" 
$	   inq/nop fln_check_procedure "Compile fln_check_procedure ?" 
$	   inq/nop fln_check_project "Compile fln_check_project ?" 
$	   inq/nop fln_check_operator_auth "Compile fln_check_operator_auth? " 
$	   inq/nop fln_check_workstation "Compile fln_check_workstation ?" 
$	   inq/nop fln_check_workstation_auth "Compile fln_check_workstation_auth? " 
$	   inq/nop fln_complete_task "Compile fln_complete_task? " 
$	   inq/nop fln_complete_update "Compile fln_complete_update? " 
$	   inq/nop fln_conditions_syntax "Compile fln_conditions_syntax ? " 
$	   inq/nop fln_create_job "Compile fln_create_job ? " 
$	   inq/nop fln_create_project "Compile fln_create_project ? " 
$	   inq/nop fln_create_operator "Compile fln_create_operator ? " 
$	   inq/nop fln_create_workstation "Compile fln_create_workstation ? " 
$ er:	   
$	   inq/nop next_lot     "d, e, f routines ? "
$ 	   if .not. next_lot then goto gr
$	   inq/nop fln_define_element "Compile fln_define_element ? "
$	   inq/nop fln_define_flowline "Compile fln_define_flowline ? "
$	   inq/nop fln_define_procedure  "Compile fln_define_procedure? "
$	   inq/nop fln_define_wire "Compile fln_define_wire ? "
$	   inq/nop fln_delete_job "Compile fln_delete_job ? "
$	   inq/nop fln_delete_locals "Compile fln_delete_locals ? "
$	   inq/nop fln_delete_operator "Compile fln_delete_operator ? "
$	   inq/nop fln_delete_project "Compile fln_delete_project ? "
$	   inq/nop fln_delete_workstation "Compile fln_delete_workstation ? "
$	   inq/nop fln_end_flowline "Compile fln_end_flowline ? "
$	   inq/nop fln_end_session "Compile fln_end_session ? "
$	   inq/nop fln_end_sub_job "Compile fln_end_sub_job ? "
$	   inq/nop fln_eval "Compile fln_eval ? "
$ gr:	   
$	   inq/nop next_lot     "g  routines ? "
$ 	   if .not. next_lot then goto hr
$	   inq/nop fln_get_all_wires "Compile fln_get_all_wires ? "
$	   inq/nop fln_get_comproc "Compile fln_get_comproc ? "
$	   inq/nop fln_get_day_time "Compile fln_get_day_time ? "
$	   inq/nop fln_get_externals "Compile fln_get_externals ? "
$	   inq/nop fln_get_flowln "Compile fln_get_flowln ? "
$	   inq/nop fln_get_locals "Compile fln_get_locals ? "
$	   inq/nop fln_get_input_par "Compile fln_get_input_par ? "
$	   inq/nop fln_get_readys "Compile fln_get_readys ? "
$	   inq/nop fln_get_job "Compile fln_get_job ? "
$	   inq/nop fln_get_job_id "Compile fln_get_job_id ? "
$	   inq/nop fln_get_parameter_id "Compile fln_get_paramaeter_id ? "
$	   inq/nop fln_get_session_id "Compile fln_get_session_id ? "
$	   inq/nop fln_get_sub_jobs "Compile fln_get_sub_jobs ? "
$	   inq/nop fln_get_tasks "Compile fln_get_tasks ? "
$	   inq/nop fln_get_tasks_job "Compile fln_get_tasks_job ? "
$	   inq/nop fln_get_task_id "Compile fln_get_task_id ? "
$	   inq/nop fln_get_task_session  "Compile fln_get_task_session  ? "
$	   inq/nop fln_get_task_info "Compile fln_get_task_info ? "
$	   inq/nop fln_get_wire_ends	"Compile fln_get_wire_ends ? "
$	   inq/nop fln_get_wires "Compile fln_get_wires ? "
$	   inq/nop fln_get_wire_status "Compile fln_get_wire_status ? "
$ hr:	   
$	   inq/nop next_lot     "h, i,j  routines ? "
$ 	   if .not. next_lot then goto lr
$	   inq/nop fln_had_task "Compile fln_had_task ? "
$	   inq/nop fln_hold_job "Compile fln_hold_job ? "
$	   inq/nop fln_hold_project "Compile fln_hold_project ? "
$	   inq/nop fln_hold_task "Compile fln_hold_task ? "
$	   inq/nop fln_init "Compile fln_init ? " 
$	   inq/nop fln_is_ready "Compile fln_is_ready ? "
$	   inq/nop fln_jobstart_update "Compile fln_jobstart_update ? "
$ lr:	   
$	   inq/nop next_lot     "l,m,n, o routines ? "
$ 	   if .not. next_lot then goto pr
$	   inq/nop fln_list_op_auth "Compile fln_list_op_auth ? "
$	   inq/nop fln_list_authorised_tasks "Compile fln_list_authorised_tasks ? "
$	   inq/nop fln_list_job "Compile fln_list_job ? "
$	   inq/nop fln_list_task "Compile fln_list_task ? "
$	   inq/nop fln_list_session "Compile fln_list_session ? "
$	   inq/nop fln_list_job_his "Compile fln_list_job_his ? "
$	   inq/nop fln_list_task_his "Compile fln_list_task_his ? "
$	   inq/nop fln_list_session_his "Compile fln_list_session_his ? "
$ pr:	   
$	   inq/nop next_lot     "p, q, r without retrieve routines ? "
$ 	   if .not. next_lot then goto rer
$	   inq/nop fln_process_outcome "Compile fln_process_outcome ? "
$	   inq/nop fln_release_job "Compile fln_release_job ? "
$	   inq/nop fln_release_project "Compile fln_release_project ? "
$	   inq/nop fln_release_task "Compile fln_release_task ? "
$	   inq/nop fln_remove_spaces "Compile fln_remove_spaces ? "
$	   inq/nop fln_reset_job "Compile fln_reset_job ? "
$	   inq/nop fln_reset_job_int "Compile fln_reset_job_int ? "
$	   inq/nop fln_reset_op_auth "Compile fln_reset_op_auth ? "
$	   inq/nop fln_reset_update "Compile fln_reset_update ? "
$	   inq/nop fln_reset_work_auth "Compile fln_reset_work_auth ? "
$ rer:	   
$	   inq/nop next_lot     "retrieve routines ? "
$ 	   if .not. next_lot then goto rt
$	   inq/nop fln_retrieve_wires_flowline "Compile fln_retrieve_wires_flowline? "
$	   inq/nop fln_retrieve_elements_flowline "Compile fln_retrieve_elements_flowline? "
$	   inq/nop fln_retrieve_elem_ids_flowline "Compile fln_retrieve_elem_ids_flowline? "
$	   inq/nop fln_retrieve_all_procedures "Compile fln_retrieve_all_procedures? "
$	   inq/nop fln_retrieve_active_sessions "Compile fln_retrieve_active_sessions? "
$	   inq/nop fln_retrieve_all_flowlines "Compile fln_retrieve_all_flowlines? "
$	   inq/nop fln_retrieve_all_flowline_ids "Compile fln_retrieve_all_flowline_ids? "
$	   inq/nop fln_retrieve_all_jobs "Compile fln_retrieve_all_jobs? "
$	   inq/nop fln_retrieve_all_operators "Compile fln_retrieve_all_operators ? "
$	   inq/nop fln_retrieve_all_oper_ids "Compile fln_retrieve_all_oper_ids ? "
$	   inq/nop fln_retrieve_all_projects "Compile fln_retrieve_all_projects ? "
$	   inq/nop fln_retrieve_all_sessions "Compile fln_retrieve_all_sessions ? "
$	   inq/nop fln_retrieve_all_tasks "Compile fln_retrieve_all_tasks ? "
$	   inq/nop fln_retrieve_all_workstations "Compile fln_retrieve_all_workstations ? "
$	   inq/nop fln_retrieve_all_work_ids "Compile fln_retrieve_all_work_ids ? "
$	   inq/nop fln_retrieve_created_jobs "Compile fln_retrieve_created_jobs ?"
$	   inq/nop fln_retrieve_created_projects "Compile fln_retrieve_created_projects ?"
$	   inq/nop fln_retrieve_current "Compile fln_retrieve_current ? "
$	   inq/nop fln_retrieve_current_job "Compile fln_retrieve_current_job ? "
$	   inq/nop fln_retrieve_current_project "Compile fln_retrieve_current_project ? "
$	   inq/nop fln_retrieve_current_task "Compile fln_retrieve_current_task ? "
$	   inq/nop fln_retrieve_element_def "Compile fln_retrieve_element_def ? "
$	   inq/nop fln_retrieve_flowline_def "Compile fln_retrieve_flowline_def ? "
$	   inq/nop fln_retrieve_wire_def "Compile fln_retrieve_wire_def ? "
$	   inq/nop fln_retrieve_procedure_def "Compile fln_retrieve_procedure_def ? "
$	   inq/nop fln_retrieve_system_def "Compile fln_retrieve_system_def ? "
$	   inq/nop fln_retrieve_info_job_id  "Compile fln_retrieve_info_job_id ? "
$	   inq/nop fln_retrieve_outer_info_job_id  "Compile fln_retrieve_outer_info_job_id ? "
$	   inq/nop fln_retrieve_jobs "Compile fln_retrieve_jobs? "
$	   inq/nop fln_retrieve_job_task "Compile fln_retrieve_job_task ? "
$	   inq/nop fln_retrieve_job_hist_project "Compile fln_retrieve_job_hist_project ? "
$	   inq/nop fln_retrieve_jobs_project "Compile fln_retrieve_jobs_project ? "
$	   inq/nop fln_retrieve_projects "Compile fln_retrieve_projects? "
$	   inq/nop fln_retrieve_operator_auth "Compile fln_retrieve_operator_auth? "
$	   inq/nop fln_retrieve_tasks_job "Compile fln_retrieve_tasks_job ? "
$	   inq/nop fln_retrieve_workstation_auth "Compile fln_retrieve_workstation_auth? "
$	   inq/nop fln_retrieve_resets "Compile fln_retrieve_resets? "
$	   inq/nop fln_retrieve_session_pje "Compile fln_retrieve_session_pje? "
$	   inq/nop fln_retrieve_tasks "Compile fln_retrieve_tasks? "
$	   inq/nop fln_retrieve_task_hist_job "Compile fln_retrieve_task_hist_job ? "
$ rt:
$	   inq/nop next_lot     "timing routines ? "
$ 	   if .not. next_lot then goto sr
$	   inq/nop fln_retrieve_element_timings  "Compile fln_retrieve_element_timings ? "
$	   inq/nop fln_retrieve_elem_oper_timings  "Compile fln_retrieve_elem_oper_timings ? "
$	   inq/nop fln_retrieve_elem_work_timings  "Compile fln_retrieve_elem_work_timings ? "
$	   inq/nop fln_retrieve_flowline_timings  "Compile fln_retrieve_flowline_timings ? "
$	   inq/nop fln_retrieve_job_timings  "Compile fln_retrieve_job_timings ? "
$	   inq/nop fln_retrieve_oper_elem_timings  "Compile fln_retrieve_oper_elem_timings ? "
$	   inq/nop fln_retrieve_oper_total_timings  "Compile fln_retrieve_oper_total_timings ? "
$	   inq/nop fln_retrieve_oper_work_timings  "Compile fln_retrieve_oper_work_timings ? "
$	   inq/nop fln_retrieve_project_timings  "Compile fln_retrieve_project_timings ? "
$	   inq/nop fln_retrieve_session_timings "Compile fln_retrieve_session_timings ? "
$	   inq/nop fln_retrieve_task_timings  "Compile fln_retrieve_task_timings ? "
$	   inq/nop fln_retrieve_work_elem_timings  "Compile fln_retrieve_work_elem_timings ? "
$	   inq/nop fln_retrieve_work_oper_timings  "Compile fln_retrieve_work_oper_timings ? "
$	   inq/nop fln_retrieve_work_total_timings  "Compile fln_retrieve_work_total_timings ? "
$ sr:	   
$	   inq/nop next_lot     "s  routines ? "
$ 	   if .not. next_lot then goto tr
$	   inq/nop fln_sess_complete "Compile fln_sess_complete ? "  
$	   inq/nop fln_sess_continue "Compile fln_sess_continue? "  
$	   inq/nop fln_sess_error "Compile fln_sess_error ? "  
$	   inq/nop fln_sess_offline "Compile fln_sess_offline ? "  
$	   inq/nop fln_sess_restart "Compile fln_sess_restart ? "  
$	   inq/nop fln_sess_subflowline "Compile fln_sess_subflowline ? "  
$	   inq/nop fln_set_wires "Compile fln_set_wires ? "  
$	   inq/nop fln_setup_tasks "Compile fln_setup_tasks ? " 
$	   inq/nop fln_set_current "Compile fln_set_current ? " 
$	   inq/nop fln_set_current_job "Compile fln_set_current_job ? " 
$	   inq/nop fln_set_current_pje "Compile fln_set_current_pje ? " 
$	   inq/nop fln_set_current_project "Compile fln_set_current_project ? " 
$	   inq/nop fln_set_current_task "Compile fln_set_current_task ? " 
$	   inq/nop fln_set_globals "Compile fln_set_globals ? " 
$	   inq/nop fln_set_job "Compile fln_set_job ? " 
$	   inq/nop fln_set_locals "Compile fln_set_locals ? " 
$	   inq/nop fln_set_locals_tr "Compile fln_set_locals_tr ? " 
$	   inq/nop fln_set_project "Compile fln_set_project ? " 
$	   inq/nop fln_set_task "Compile fln_set_task ? " 
$	   inq/nop fln_set_task_status "Compile fln_set_task_status ? " 
$	   inq/nop fln_skip_task "Compile fln_skip_task ? "
$	   inq/nop fln_start_job "Compile fln_start_job ? "
$	   inq/nop fln_start_project "Compile fln_start_project ? "
$	   inq/nop fln_start_session "Compile fln_start_session ? " 
$	   inq/nop fln_start_task "Compile fln_start_task ? " 
$ tr:	   
$	   inq/nop next_lot     "t,u,v,w,x,y,z  routines ? "
$ 	   if .not. next_lot then goto a11
$!  
$a11:	   inq/nop mes "Generate message definitions ? " 
$ 	   inq/nop newlib "Create new flowline library ? "
$	   if .not.newlib then goto oldlib
$	        wc "$	library/create  flowline"
$	   	wc "$	libr = ""library/insert/log  flowline"""
$	   goto do_mess
$ oldlib:
$	   	wc "$	libr = ""library/replace/log  flowline"""
$ do_mess:	wc "$ 	set noverify" 
$! 
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++""" 
$		wc "$ 	set verify" 
$ 		if .not.mes then goto cmponly 
$!		wc "$   define/trans=(c,t) local dua0:[lslsource.flowline.]"
$ wc "$	newmsg/number=1711/name=fln/prefix=fln__ /parameter=for flowline.mes /runoff"
$		wc "$ @flowline.temp_com"
$		wc "$ if $status then libr flowline.promsg_obj"
$	if (.not.compile) then goto compile_finished
$!	
$ cmponly:		
$ for:	if fln_add_string then call compiler fln_add_string
$	if fln_archive_job then call rcompiler fln_archive_job
$	if fln_archive_session then call rcompiler fln_archive_session
$	if fln_archive_task then call rcompiler fln_archive_task
$	if fln_authorise_operator then call compiler fln_authorise_operator
$	if fln_authorise_workstation then call compiler fln_authorise_workstation
$	if fln_begin_task then call rcompiler fln_begin_task
$	if fln_change_par then call rcompiler fln_change_par
$	if fln_change_proj_pri then call rcompiler fln_change_proj_pri
$	if fln_change_job_name then call rcompiler fln_change_job_name
$	if fln_change_job_hist_name then call rcompiler fln_change_job_hist_name
$	if fln_change_job_pri then call rcompiler fln_change_job_pri
$	if fln_check_element then call rcompiler fln_check_element
$	if fln_check_element_flow then call rcompiler fln_check_element_flow
$	if fln_check_flowline then call rcompiler fln_check_flowline
$	if fln_check_job then call rcompiler fln_check_job
$	if fln_check_lampsauth then call compiler fln_check_lampsauth
$	if fln_check_offline then call rcompiler fln_check_offline
$	if fln_check_operator then call rcompiler fln_check_operator
$	if fln_check_procedure then call rcompiler fln_check_procedure
$	if fln_check_project then call rcompiler fln_check_project
$	if fln_check_operator_auth then call rcompiler fln_check_operator_auth
$	if fln_check_workstation then call rcompiler fln_check_workstation
$	if fln_check_workstation_auth then call rcompiler fln_check_workstation_auth
$	if fln_complete_task then call compiler fln_complete_task
$	if fln_complete_update then call rcompiler fln_complete_update
$	if fln_conditions_syntax then call compiler fln_conditions_syntax
$	if fln_create_job then call rcompiler fln_create_job
$	if fln_create_project then call rcompiler fln_create_project
$	if fln_create_operator then call rcompiler fln_create_operator
$	if fln_create_workstation then call rcompiler fln_create_workstation 
$	if fln_define_element then call rcompiler fln_define_element
$	if fln_define_flowline then call rcompiler fln_define_flowline
$	if fln_define_procedure then call rcompiler fln_define_procedure
$	if fln_define_system then call rcompiler fln_define_system
$	if fln_define_wire then call rcompiler fln_define_wire
$	if fln_delete_job then call rcompiler fln_delete_job
$	if fln_delete_locals then call rcompiler fln_delete_locals
$	if fln_delete_operator then call rcompiler fln_delete_operator
$	if fln_delete_project  then call rcompiler fln_delete_project
$	if fln_delete_workstation then call rcompiler fln_delete_workstation
$ 	if fln_end_flowline then call rcompiler fln_end_flowline
$ 	if fln_end_session then call rcompiler fln_end_session
$ 	if fln_end_sub_job then call rcompiler fln_end_sub_job
$	if fln_eval then call compiler fln_eval
$	if fln_get_all_wires then call rcompiler fln_get_all_wires
$	if fln_get_comproc then call rcompiler fln_get_comproc
$	if fln_get_day_time then call rcompiler fln_get_day_time
$	if fln_get_externals then call rcompiler fln_get_externals
$	if fln_get_flowln then call rcompiler fln_get_flowln
$	if fln_get_readys then call rcompiler fln_get_readys
$	if fln_get_input_par  then call rcompiler fln_get_input_par
$	if fln_get_locals then call rcompiler fln_get_locals
$	if fln_get_job then call rcompiler fln_get_job
$	if fln_get_job_id then call rcompiler fln_get_job_id
$	if fln_get_parameter_id then call rcompiler fln_get_parameter_id 
$	if fln_get_session_id then call rcompiler fln_get_session_id 
$	if fln_get_sub_jobs then call rcompiler fln_get_sub_jobs
$	if fln_get_tasks then call rcompiler fln_get_tasks
$	if fln_get_tasks_job then call rcompiler fln_get_tasks_job
$	if fln_get_task_id then call rcompiler fln_get_task_id 
$	if fln_get_task_session then call rcompiler fln_get_task_session
$	if fln_get_task_info  then call rcompiler fln_get_task_info 
$	if fln_get_wire_ends then call rcompiler fln_get_wire_ends
$	if fln_get_wires then call rcompiler fln_get_wires
$	if fln_get_wire_status then call rcompiler fln_get_wire_status
$	if fln_had_task then call rcompiler fln_had_task
$	if fln_hold_job then call compiler fln_hold_job
$	if fln_hold_project then call compiler fln_hold_project
$	if fln_hold_task then call rcompiler fln_hold_task
$	if fln_init then call compiler fln_init
$	if fln_is_ready then call rcompiler fln_is_ready
$	if fln_jobstart_update then call rcompiler fln_jobstart_update
$	if fln_list_op_auth then call compiler fln_list_op_auth
$	if fln_list_authorised_tasks then call compiler fln_list_authorised_tasks
$	if fln_list_job then call rcompiler fln_list_job
$	if fln_list_task then call rcompiler fln_list_task
$	if fln_list_session then call rcompiler fln_list_session
$	if fln_list_job_his then call rcompiler fln_list_job_his
$	if fln_list_task_his then call rcompiler fln_list_task_his
$	if fln_list_session_his then call rcompiler fln_list_session_his
$	if fln_process_outcome then call compiler fln_process_outcome
$	if fln_release_job then call compiler fln_release_job
$	if fln_release_project then call compiler fln_release_project
$	if fln_release_task then call rcompiler fln_release_task
$	if fln_remove_spaces then call compiler fln_remove_spaces
$	if fln_reset_job then call compiler fln_reset_job
$	if fln_reset_job_int then call compiler fln_reset_job_int
$	if fln_reset_op_auth then call rcompiler fln_reset_op_auth
$	if fln_reset_update then call rcompiler fln_reset_update
$	if fln_reset_work_auth then call rcompiler fln_reset_work_auth
$	if fln_retrieve_active_sessions then call rcompiler fln_retrieve_active_sessions
$	if fln_retrieve_wires_flowline then call rcompiler fln_retrieve_wires_flowline
$	if fln_retrieve_elements_flowline then call rcompiler fln_retrieve_elements_flowline
$	if fln_retrieve_elem_ids_flowline then call rcompiler fln_retrieve_elem_ids_flowline
$	if fln_retrieve_all_procedures then call rcompiler fln_retrieve_all_procedures
$	if fln_retrieve_all_flowlines then call rcompiler fln_retrieve_all_flowlines
$	if fln_retrieve_all_flowline_ids then call rcompiler fln_retrieve_all_flowline_ids
$	if fln_retrieve_all_jobs then call rcompiler fln_retrieve_all_jobs
$	if fln_retrieve_all_operators then call rcompiler fln_retrieve_all_operators
$	if fln_retrieve_all_oper_ids then call rcompiler fln_retrieve_all_oper_ids
$	if fln_retrieve_all_projects then call rcompiler fln_retrieve_all_projects
$	if fln_retrieve_all_sessions then call rcompiler fln_retrieve_all_sessions
$	if fln_retrieve_all_tasks then call rcompiler fln_retrieve_all_tasks
$	if fln_retrieve_all_workstations then call rcompiler fln_retrieve_all_workstations
$	if fln_retrieve_all_work_ids then call rcompiler fln_retrieve_all_work_ids
$	if fln_retrieve_created_jobs then call rcompiler fln_retrieve_created_jobs
$	if fln_retrieve_created_projects then call rcompiler fln_retrieve_created_projects
$	if fln_retrieve_current then call rcompiler fln_retrieve_current
$	if fln_retrieve_current_job then call rcompiler fln_retrieve_current_job
$	if fln_retrieve_operator_auth then call rcompiler fln_retrieve_operator_auth
$	if fln_retrieve_workstation_auth then call rcompiler fln_retrieve_workstation_auth
$	if fln_retrieve_current_project then call rcompiler fln_retrieve_current_project
$	if fln_retrieve_current_task then call rcompiler fln_retrieve_current_task
$	if fln_retrieve_element_def then call rcompiler fln_retrieve_element_def
$	if fln_retrieve_flowline_def then call rcompiler fln_retrieve_flowline_def
$	if fln_retrieve_info_job_id then call rcompiler fln_retrieve_info_job_id
$	if fln_retrieve_outer_info_job_id then call rcompiler fln_retrieve_outer_info_job_id
$	if fln_retrieve_procedure_def then call rcompiler fln_retrieve_procedure_def
$	if fln_retrieve_wire_def then call rcompiler fln_retrieve_wire_def
$	if fln_retrieve_system_def then call rcompiler fln_retrieve_system_def
$	if fln_retrieve_job_task then call rcompiler fln_retrieve_job_task
$	if fln_retrieve_jobs then call rcompiler fln_retrieve_jobs
$	if fln_retrieve_job_hist_project then call rcompiler fln_retrieve_job_hist_project
$	if fln_retrieve_jobs_project then call rcompiler fln_retrieve_jobs_project
$	if fln_retrieve_projects then call rcompiler fln_retrieve_projects
$	if fln_retrieve_element_timings then call rcompiler fln_retrieve_element_timings
$	if fln_retrieve_oper_work_timings then call rcompiler fln_retrieve_oper_work_timings
$	if fln_retrieve_work_oper_timings then call rcompiler fln_retrieve_work_oper_timings
$	if fln_retrieve_oper_elem_timings then call rcompiler fln_retrieve_oper_elem_timings
$	if fln_retrieve_work_elem_timings then call rcompiler fln_retrieve_work_elem_timings
$	if fln_retrieve_elem_oper_timings then call rcompiler fln_retrieve_elem_oper_timings
$	if fln_retrieve_elem_work_timings then call rcompiler fln_retrieve_elem_work_timings
$	if fln_retrieve_work_total_timings then call rcompiler fln_retrieve_work_total_timings
$	if fln_retrieve_oper_total_timings then call rcompiler fln_retrieve_oper_total_timings
$	if fln_retrieve_flowline_timings then call rcompiler fln_retrieve_flowline_timings
$	if fln_retrieve_project_timings then call rcompiler fln_retrieve_project_timings
$	if fln_retrieve_job_timings then call rcompiler fln_retrieve_job_timings
$	if fln_retrieve_session_timings then call rcompiler fln_retrieve_session_timings
$	if fln_retrieve_task_timings then call rcompiler fln_retrieve_task_timings
$	if fln_retrieve_resets then call rcompiler fln_retrieve_resets
$	if fln_retrieve_session_pje then call rcompiler fln_retrieve_session_pje
$	if fln_retrieve_tasks then call rcompiler fln_retrieve_tasks
$	if fln_retrieve_tasks_job then call rcompiler fln_retrieve_tasks_job
$	if fln_retrieve_task_hist_job then call rcompiler fln_retrieve_task_hist_job
$	if fln_sess_complete then call rcompiler fln_sess_complete
$	if fln_sess_continue then call rcompiler fln_sess_continue
$	if fln_sess_error then call rcompiler fln_sess_error
$	if fln_sess_offline then call rcompiler fln_sess_offline
$	if fln_sess_restart then call rcompiler fln_sess_restart
$	if fln_sess_subflowline then call rcompiler fln_sess_subflowline
$	if fln_set_current then call rcompiler fln_set_current
$	if fln_set_current_pje then call rcompiler fln_set_current_pje
$	if fln_set_current_job then call rcompiler fln_set_current_job
$	if fln_set_current_project then call rcompiler fln_set_current_project
$	if fln_set_current_task then call rcompiler fln_set_current_task
$	if fln_set_globals then call rcompiler fln_set_globals
$	if fln_set_wires then call rcompiler fln_set_wires
$	if fln_setup_tasks then call rcompiler fln_setup_tasks
$	if fln_set_job then call rcompiler fln_set_job 
$	if fln_set_locals then call rcompiler fln_set_locals
$	if fln_set_locals_tr then call rcompiler fln_set_locals_tr
$	if fln_set_project then call rcompiler fln_set_project
$	if fln_set_task then call rcompiler fln_set_task
$!	if fln_set_task_status then call rcompiler fln_set_task_status
$	if fln_skip_task then call rcompiler fln_skip_task
$	if fln_start_job then call rcompiler fln_start_job
$	if fln_start_project then call rcompiler fln_start_project 
$	if fln_start_session then call rcompiler fln_start_session 
$	if fln_start_task then call rcompiler fln_start_task
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ compiler: subroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$		wc "$ 	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc ''p1'''kpcom'=''p1'"
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
$		wc "$	if ok then libr ''p1'"
$		wc "$ 	delete ''p1'.obj;*"
$		wc "$	set noverify"
$	return
$ endsubroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ rcompiler: subroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$		wc "$ 	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc ''p1'.rfo''kpcom'=''p1'"
$	   	wc "$	rfort''fsw1' ''p1'"
$	      	wc "$ 	ok=$status"	
$		wc "$ 	if ok then pvv ''p1'"
$		wc "$ 	purge/nolog ''p1'.obj"
$		if fsw1.eqs."" then -
		wc "$ 	delete/nolog ''p1'.for;*"
$		if fsw1.nes.""  then -
		wc "$ 	purge/nolog ''p1'.for"
$		if fsw1.eqs."" then -
		wc "$ 	delete/nolog ''p1'.rfo;*"
$		if fsw1.nes.""  then -
		wc "$ 	purge/nolog ''p1'.rfo"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
		wc "$ 	if ok then delete/nolog ''p1'.lis;*"
$		wc "$	if .not.ok then emsg=emsg+"" ''p1'"""
$		wc "$ 	delete adc.ide;*"
$		wc "$	if ok then libr ''p1'"
$		wc "$ 	delete ''p1'.obj;*"
$		wc "$	set noverify"
$	return
$ endsubroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ compile_finished:
$	wc "$	set noverify"
$	wc "$	if emsg.eqs."""" then goto noerr"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	write sys$output ""Compilation errors in:"""
$	wc "$	write sys$output emsg"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	noerr:"
$!
$ nolnk:
$		wc "$ 	flowlineex:"
$		wc "$ 	deass/group lsl$flowline_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto flowlineex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$flowline_building
$	submit	/ident/notify/restart/noprint/keep -
		/log=lsl$cmnflowline:flowlinebat.log -
	flowlinebat.com
$	goto flowlinex2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto flowlineex
$	deass/group lsl$flowline_building
$	@flowlinebat.com
$	goto flowlinex2
$ flowlineex:
$	deass/group lsl$flowline_building
$ flowlinex2:
$	if ver then set verify
