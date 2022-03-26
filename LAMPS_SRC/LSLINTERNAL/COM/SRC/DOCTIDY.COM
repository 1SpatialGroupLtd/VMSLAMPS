$! command file to tidy up [DOC...] directories
$! Author PGH 28-Apr-1988
$! TeX stuff added	PGH	27-Aug-1990
$!
$	TYPE SYS$INPUT:

***	This procedure will purge the complete [LSLDOC...] tree to 2 versions
***	excluding files created in previous 4 days, to 1 version excluding
***	files created in previous 2 months, and will delete all .LNI, .MEM, 
***	.RNT, .RNX, .BRN, .PS, , .DVI, .LIS, LN3 files older than 2 weeks.

$	IF P1.EQS."" THEN INQUIRE P1 "Go ahead and do it ?  "
$	IF .NOT.P1 THEN EXIT
$!
$	PURGE/LOG LSL$DOC_ROOT:[*...]/KEEP=2/BEF="TODAY-4-"
$!
$	PURGE/LOG LSL$DOC_ROOT:[*...]/KEEP=1/BEF="TODAY-60-"
$!
$	DELETE/LOG/EXCLUDE=*.DIR/BEFORE="TODAY-14-" -
   LSL$DOC_ROOT:[*...]*.LNI;*,*.MEM;*,*.RNT;*,*.RNX;*,*.BRN;*,-
   *.PS;*,*.DVI;*,*.LIS;*,*.LN3;*
$!
