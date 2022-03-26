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
