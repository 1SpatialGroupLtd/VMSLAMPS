$!	ELEMENT_3.com
$!
$!	Copyright Laser-Scan Laboratories Ltd, Cambridge, England.
$!	Author : MWSR	28-May-1988
$!
$!	ACCEPT  flowline Element command procedure dummy:
$!
$	ws = "write SYS$OUTPUT"
$!
$!	
$	ws "                 PROCESS_3 command file" 
$	ws " "
$	ws "Symbol 1 = ''job_symbol1'"
$	ws "Symbol 2 = ''job_symbol2'"
$	ws "Symbol 3 = ''job_symbol3'"
$	ws " "
$	inq/nop/loca RESP "   Press <RETURN> when you are ready to continue "
$	FLN_OUTCOME == "1"
$	FLN_RESULT == "complete" 
$!
$! Exit
$!
$ finish:
$!
