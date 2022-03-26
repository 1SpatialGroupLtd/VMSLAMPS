$	VER=F$VERIFY(0)
$!
$!	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
$!
$!	Created					ALB	05-Jul-1988
$!
$! 	This is a temp compilation build file for FILTER routines
$!
$!	Debug versions of object files will be used to debug 
$!	IMP IFILTER Program.   
$!
$	ON ERROR THEN GOTO FILTEREX
$	ON CONTROL_Y THEN EXIT
$!
$	DISK:='F$LOGICAL("SYS$DISK")'
$	IF "''F$LOGICAL("LSL$IFILTER_COMPILING")'" .NES. "IN_PROGRESS" -
	   THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is compiling FILTER"
$	EXIT
$A0:	ON CONTROL_Y THEN GOTO FILTEREX
$	DEFINE/GROUP LSL$FILTER_COMPILING "IN_PROGRESS"
$	OPEN/WRITE COMFIL FILTERBAT.COM
$	ON CONTROL_Y THEN GOTO FILCLO
$ 	ON ERROR THEN GOTO FILCLO
$	WC="WRITE COMFIL"
$!
$	WC 	"$ 	SET NOVERIFY"
$	WC	"$	ON CONTROL_Y THEN GOTO FILTEREX"
$	WC	"$	IF ""'","'F$LOGICAL(""LSL$FILTER_COMPILING"")'"" -"
$	WC	"		 .NES. ""IN_PROGRESS"" THEN GOTO A0"
$	WC	"$	WRITE SYS$OUTPUT ""Someone else is compiling FILTER routines"""
$	WC	"$	EXIT"
$	WC	"$!"
$	WC	"$A0:	DEFINE/GROUP LSL$FILTER_COMPILING ""IN_PROGRESS"""
$	WC	"$	INTER =F$MODE() .EQS. ""INTERACTIVE"""
$	WC	"$	ASSIGN HERE: LSL$CMNIFILT"
$	WC	"$	SD:=$LSL$SYS:SD"
$	WC	"$	SET NOON"
$	wc 	"$	emsg="""""
$!
$	RENMES=""
$	MLDBG=""
$	FSW1=""
$	KPCOM=""
$	INQUIRE/NOP COMPILE "Compile ? "
$	IF .NOT.COMPILE THEN GOTO A04
$	INQUIRE/NOP IFILT_DBG "With Debug ? "
$	IF .NOT. IFILT_DBG THEN GOTO A04
$	   FSW1="/DEBUG"
$	   MLDBG="/DEBUG"
$	   INQUIRE/NOP ANSWER "Without optimisation ? "
$	   IF ANSWER THEN FSW1=FSW1 + "/NOOPT"
$	   INQUIRE/NOP ANSWER "Check bounds and overflow ? "
$	   IF ANSWER THEN FSW1=FSW1 + "/CHECK=(BOUNDS,OVERFLOW)"
$	   INQUIRE/NOP ANSWER "With listings ? "
$	   IF ANSWER THEN FSW1=FSW1 + "/LIST"
$	   INQUIRE/NOP ANSWER "Keep FORtran sources with comments ? "
$	   IF ANSWER THEN KPCOM="/CO"
$ A04:
$	   INQ/NOP CLD "Compile CLD modules ? "
$	   IF .NOT.COMPILE THEN GOTO A11
$!
$	   INQ/NOP EVERYTHING "Compile all FORTRAN sources ? "
$	   IF .NOT. EVERYTHING THEN GOTO A05
$	BUNCH="T"
$	BUNCH_FILTER="T"
$	BUNCH_FLUSH="T"
$	BUNCH_INIT="T"
$	BUNCH_LINE="T"
$	BUNCH_POINT="T"
$	DP_INIT="T"
$	DP_LINE="T"
$	REDUCE="T"
$	   GOTO A11
$!
$ A05:	   INQ/NOP BUNCH	"BUNCH?			"
$	   INQ/NOP BUNCH_FILTER "BUNCH_FILTER?		"
$	   INQ/NOP BUNCH_FLUSH 	"BUNCH_FLUSH?		"
$	   INQ/NOP BUNCH_INIT	"BUNCH_INIT?		"
$	   INQ/NOP BUNCH_LINE 	"BUNCH_LINE?		"
$	   INQ/NOP BUNCH_POINT 	"BUNCH_POINT?		"
$	   INQ/NOP DP_INIT	"DP_INIT?		"
$	   INQ/NOP DP_LINE	"DP_LINE?		"
$	   INQ/NOP REDUCE	"REDUCE?		"
$!
$ A11:
$!
$		WC "$ WRITE SYS$OUTPUT ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		WC "$ 		SET VERIFY"
$ FORTONLY:		
$	IF .NOT. COMPILE THEN GOTO finish
$	if BUNCH then call compiler BUNCH
$	if BUNCH_FILTER then call compiler BUNCH_FILTER
$	if BUNCH_FLUSH then call compiler BUNCH_FLUSH
$	if BUNCH_INIT then call compiler BUNCH_INIT
$	if BUNCH_LINE then call compiler BUNCH_LINE
$	if BUNCH_POINT then call compiler BUNCH_POINT
$	if DP_INIT then call compiler DP_INIT
$	if DP_LINE then call compiler DP_LINE
$	if REDUCE then call compiler REDUCE
$	   goto finish
$!----------------------------------------------------------------------
$ compiler: subroutine 
$!----------------------------------------------------------------------
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
$		wc "$	set noverify"
$	return
$ endsubroutine
$!----------------------------------------------------------------------
$ finish:
$	wc "$	set noverify"
$	wc "$	if emsg.eqs."""" then goto noerr"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	write sys$output ""Compilation errors in:"""
$	wc "$	write sys$output emsg"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	noerr:"
$!
$ FILCLO:
$	SET NOVERIFY
$	ON ERROR THEN GOTO FILTEREX
$	ON CONTROL_Y THEN GOTO FILTEREX
$	CLOSE COMFIL
$	PURGE/NOLOG FILTERBAT.COM
$	OK=$STATUS
$	IF OK THEN INQ/NOP ANSWER_BAT "Submit for batch ? "
$	IF .NOT. ANSWER_BAT THEN GOTO INT
$	DEASS/GROUP LSL$FILTER_COMPILING
$	BAT FILTERBAT.COM
$	GOTO FILTERX2
$ INT:	
$	IF OK THEN INQ/NOP ANSWER "Interactive ? "
$	IF .NOT.ANSWER THEN GOTO FILTEREX
$	DEASS/GROUP LSL$FILTER_COMPILING
$	@FILTERBAT.COM
$	GOTO FILTERX2
$ FILTEREX:
$	DEASS/GROUP LSL$FILTER_COMPILING
$ FILTERX2:
$	IF VER THEN SET VERIFY
