$!	ACCEPT_FLOWLINE.COM
$!
$!	Copyright Laser-Scan Laboratories Ltd, Cambridge, England.
$!	Author : MWSR 	28th May 1988
$!      From DFAD one by IMcL
$!	ACCEPT  job flowline command procedure to :
$!		Prompt the system manager for information 
$!		relevent to the job and construct the job
$!		command file for execution before each element.
$!
$!	Input/Output files are symbols :
$!
$!		JOB_FILE	the command file written by this file
$!
$!	Other symbols used are :
$!		FLN_RESULT	result code of command procedure :
$!					error
$!					abort
$!					complete
$!		FLN_PROBLEM	cause of error return (eg module name)
$!
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
$	ws "   **          Flowline ACCEPT command procedure    **"
$	ws "   **                                               **"
$	ws "   ***************************************************"
$	ws ""
$	ws ""
$!
$	ws " This DCL command file creates a command file with symbols"
$       ws " which are specific to the ''fln_job_name' job running on "
$       ws " the ACCEPT flowline."
$	ws ""
$	ws ""
$! map name
$!
$	filename = fln_job_name + ".com"
$	sym1 = "value_1"
$	inq/nop symbol1  "Enter value for symbol 1 [''sym1'] ? >> "
$	if symbol1 .eqs. "" then symbol1= sym1
$	sym2 = "value_2"
$	inq/nop symbol2  "Enter value for symbol 2 [''sym2'] ? >> "
$	if symbol2 .eqs. "" then symbol2= sym2
$	sym3 = "value_3"
$	inq/nop symbol3  "Enter value for symbol 3 [''sym3'] ? >> "
$	if symbol3 .eqs. "" then symbol3= sym3
!
$ 	ws " "
$	inquire/nopunc continue - 
	"Press ''b_on'<RETURN> ''b_of'to continue "
$ 	ws " "
$!
$	dfad_cmdfil = "LSL$FLN_WORK:"+ filename
$	fln_job_comproc == dfad_cmdfil
$	open/write cmdfil 'dfad_cmdfil'
$	OK = $STATUS
$	if .not.OK then goto failure
$	wc := "write cmdfil"
$	wc "$!                   Job command file"
$	wc "$!                   ~~~~~~~~~~~~~~~~" 
$	wc "$ job_symbol1 == ""''symbol1'""
$	wc "$ job_symbol2 == ""''symbol2'""
$	wc "$ job_symbol3 == ""''symbol3'""
$	close cmdfil
$	OK = $STATUS
$	if .not.OK then goto failure
$	ws "Job command file ''dfad_cmdfil' written"
$	FLN_RESULT == "complete"
$	FLN_PROBLEM == ""
$	goto finish
$!
$! deal with errors
$!
$ failure:
$	FLN_RESULT == "error"
$	FLN_PROBLEM == "Job file creation"
$!
$! User controlled abort
$!
$ abort:
$	FLN_RESULT == "abort"
$	FLN_PROBLEM == ""
$	goto finish
$!
$! and out
$!
$ finish:
$ exit
