$!	ELEMENT_4.com
$!
$!	Copyright Laser-Scan Laboratories Ltd, Cambridge, England.
$!	Author : MWSR	28-May-1988
$!
$!	ACCEPT  flowline Element command procedure dummy:
$!
$	ws = "write SYS$OUTPUT"
$!
$!	
$	ws "                 PROCESS_4 command file" 
$	ws " "
$	ws "Symbol 1 = ''job_symbol1'"
$	ws "Symbol 2 = ''job_symbol2'"
$	ws "Symbol 3 = ''job_symbol3'"
$	ws " "
$	ws " "
$	inquire/nop/loca RESP "Is the job now complete ? "
$	if RESP then goto  finished
$!
$	FLN_OUTCOME == "2"
$       goto end	
$
$finished:
$       FLN_OUTCOME ="1"      
$!
$end:
$	FLN_RESULT == "complete" 
