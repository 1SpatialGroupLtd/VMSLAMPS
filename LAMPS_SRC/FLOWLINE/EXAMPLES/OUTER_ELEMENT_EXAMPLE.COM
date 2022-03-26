$!	OUTER_ELEMENT_EXAMPLE.COM
$!
$!	Copyright Laser-Scan Laboratories Ltd, Cambridge, England.
$!	Author : MWS Reid	7-October-1988
$!
$!	An element command file to launch a number of 
$!	jobs on a sub-flowline DTED_SHEET
$!
$! Find out the number of sub-jobs. In this case we launch a sub-job for
$! every map sheet.
$ nototal:
$	inq/nop num_sheets " Please enter the number of sheets : "
$	if num_sheets .eqs. "" then goto nototal
$!
$! store the number of sheets as a global parameter
$	FLN_GLOBAL_PARAM == """NUM_SHEET = ''num_sheets'"""	
$!
$	JOB_COUNT = 0 
$	SHEET_JOB_TOTAL = f$integer("''num_sheets'")
$!
$! create a unique jacket command file name for call to LAMPSCONTROL
$!
$	COMMAND_FILE == "lsl$fln_jacket:" + f$getjpi("","prcnam") +"_" + -
	fln_workstation + "_sheet_sub.com"
$!
$! main loop starts here
$! ......................................................................
$	ws ""
$	ws " Please enter the names of the sheets - most south westerly first"
$ start_loop:
$	ws ""
$	JOB_COUNT = JOB_COUNT + 1
$!
$ rename:
$!
$! determine the name of the sub-job - 
$ getname:
$	jname = FLN_JOB_NAME + "_''JOB_COUNT'"
$	ws " Enter the name of sheet ''JOB_COUNT'"
$	inq/nop SUB_JOB_NAME " - default = ''JNAME' : "
$       if SUB_JOB_NAME .eqs. "" then SUB_JOB_NAME = JNAME
$!
$	if job_count .ne. 1 then goto cmdfil
$	ws ""
$	inq/nop RESP " Is this the most south westerly sheet in the cell ? "
$	ws ""
$	if .not.RESP then goto rename
$	inq/nop EXIST " Does this file already exist in digital form ? "
$	ws ""
$!
$! Get the command file name
$!
$ cmdfil:
$	dted_cmdfil = "lsl$fln_dted_job:" + sub_job_name + "_sheet_job.com"
$!
$! .........................................................................
$! call LAMPSCONTROL to create the JOB
$ dolamp:
$	ws ""
$	LAMPSCONTROL	/MANAGE/NOMENU/COMMAND_FILE='COMMAND_FILE' -
			/CREATE_JOB = 'SUB_JOB_NAME' -
			/FLOWLINE_ID = DTED_SHEET -
			/PROJECT_ID = 'FLN_PROJECT_ID' -
			/OUTER_TASK_ID = 'FLN_TASK_ID'
$!
$! execute the jacket command file - the sub-flowline command file
$! is called from within it
$       @'COMMAND_FILE'
$!
$! see if there are any more jobs
$ any_more:
$	if JOB_COUNT .lt. SHEET_JOB_TOTAL - 
	then goto start_loop
$!
$! loop ends here
$! .........................................................................
$! 
$! Say we are in a subflowline, and finish
$!
$	FLN_RESULT == "subflowline"
$	goto finish
$!
$ failure:
$	FLN_RESULT == "error"
$	FLN_PROBLEM == "subflowline command file creation"
$!
$! Exit
$!
$ finish:
$!
