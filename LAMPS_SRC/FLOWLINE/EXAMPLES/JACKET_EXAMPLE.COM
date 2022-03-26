$! LAMPSCONTROL created jacket command procedure
$! Function    Task execution
$!
$! Operator    MARTINR             
$! Workstation LSLM3A$LTXXX        
$! Project     TEST_RESET          
$! Job         PETER_RONO          
$! Element     START_LINE_TRACE    
$!
$	on warning then continue
$	on error then goto jacket_error
$	fln_local_set_up = ""
$	FLN_START == f$getjpi("","CPUTIM")
$	ws == "write sys$output"
$	FLN_JACKET_TYPE :== TASK
$	if f$type(FLN_MODE).eqs."STRING" then -
		goto defined_fln_mode
$	FLN_MODE == "OPERATE"
$	if f$mode().nes."INTERACTIVE" then - 
		FLN_MODE == "BATCH"
$!
$ defined_fln_mode:
$	if f$type(FLN_INT).eqs."STRING" then -
		goto defined_fln_int
$	FLN_INT == "t"
$	if f$mode().nes."INTERACTIVE" then -
		FLN_INT == ""
$	if FLN_MODE.eqs."SLAVE" then FLN_INT == "t"
$!
$ defined_fln_int:
$	fln_log_file_qual = "/log=LSL$FLN_LOG:FLN.LOG"
$	FLN_JACKET_COMPROC :== LSL$FLN_JACKET:MARTINR1_LSLM3A$LTXXX_JACKET.COM
$	FLN_PROJECT_COMPROC :== LSL$FLN_PROJECT:TEST_RESET_PROJECT.COM
$	FLN_JOB_COMPROC :== LSL$SITE_ROOT:[FLOWLINE.DFAD.JOB]RES_PETER_RONO_JOB.COM;
$	FLN_ELEMENT_COMPROC :== LSL$FLN_DFAD_COM:EL_DFAD_LINE_CREATE.COM
$	FLN_PROCEDURE_COMPROC :== LSL$FLN_DFAD_COM:DFAD_CREATE_IFF.COM
$	FLN_OPERATOR :== MARTINR             
$	FLN_WORKSTATION :== LSLM3A$LTXXX        
$	FLN_PROJECT_ID :== TEST_RESET          
$	FLN_JOB_ID :== 259
$	FLN_JOB_NAME :== PETER_RONO          
$	FLN_ELEMENT_ID :== START_LINE_TRACE    
$	FLN_TASK_ID :== 2361
$	FLN_TASK_STATUS :== NEW                 
$	FLN_SESSION_ID :== 1126
$	FLN_SESSION_STATUS :== NEW                 
$	FLN_RESULT :== ERROR
$	FLN_OUTCOME :== 1
$	FLN_PROBLEM == "Session startup" 
$	FLN_CPU :== 0
$	FLN_LOCAL_PARAM == ""
$	FLN_GLOBAL_PARAM == ""
$	FLN_EXTERNAL_PARAM == ""
$	fln_local_set_up = "t"
$	@'FLN_PROJECT_COMPROC' 
$	@'FLN_JOB_COMPROC' 
$	@'FLN_ELEMENT_COMPROC' 
$	FLN_END == f$getjpi("","CPUTIM")
$	FLN_CPU == f$string(FLN_END - FLN_START)
$	if FLN_RESULT .eqs. "" then -
		FLN_RESULT :== ERROR
$	if FLN_PROBLEM .eqs. "" then -
		FLN_PROBLEM :== None
$	if FLN_OUTCOME .eqs. "" then -
		FLN_OUTCOME :== 1
$	if FLN_CPU .eqs. "" then -
		FLN_CPU :== 0
$ do_notify:
$	on error then continue
$	on warning then continue
$	if FLN_LOCAL_PARAM.nes. "" then -
		goto with_parameters
$	if FLN_GLOBAL_PARAM.nes. "" then -
		goto with_parameters
$	if FLN_EXTERNAL_PARAM.nes. "" then -
		goto with_parameters
$	LAMPSCONTROL/NOTIFY/NOMENU/NOCOMMAND_FILE -
		'fln_log_file_qual' - 
		/SESSION_ID='FLN_SESSION_ID' -
		/SESSION_RESULT='FLN_RESULT' -
		/PROBLEM="''FLN_PROBLEM'" -
		/OUTCOME='FLN_OUTCOME' -
		/CPU='FLN_CPU' 
$	goto after_notify
$ with_parameters:
$	LAMPSCONTROL/NOTIFY/NOMENU/NOCOMMAND_FILE -
		'fln_log_file_qual' - 
		/SESSION_ID='FLN_SESSION_ID' -
		/SESSION_RESULT='FLN_RESULT' -
		/PARAMETERS - 
		/PROBLEM="''FLN_PROBLEM'" -
		/OUTCOME='FLN_OUTCOME' -
		/CPU='FLN_CPU' 
LOCAL <FLN_LOCAL_PARAM>
GLOBAL <FLN_GLOBAL_PARAM>
EXTERNAL <FLN_EXTERNAL_PARAM>
EXIT
$ after_notify:
$	PROC = f$environment("PROCEDURE")
$	delete/nolog/noconf 'PROC' 
$	exit
$ jacket_error:
$	on error then continue
$	on warning then continue
$	if fln_local_set_up then goto do_notify
$	FLN_RESULT :== ERROR
$	FLN_OUTCOME :== 1
$	FLN_CPU :== 0
$	FLN_PROBLEM == "Jacket command procedure"
$	goto do_notify
