$!
$! Command file to build DFAD utility FADTMERGE
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!	Created						TJH 12-Jan-1987
$!
$	ver=f$verify(0)
$!
$	on error then goto fadtmergeex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$fadtmerge_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto fadtmergeex
$	define/group lsl$fadtmerge_building "in_progress"
$	open/write comfil fadtmergebat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto fadtmergeex"
$	wc "$	if ""'","'f$logical(""lsl$fadtmerge_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$fadtmerge_building ""in_progress"""
$	wc "$	assign lsl$source_root:[dfad.fadtcmn] lsl$fadtcmn"
$	wc "$	assign lsl$source_root:[dfad.fadtmerge] lsl$fadtmerge"
$	wc "$	sd:=$lsl$exe:sd"
$	wc "$	sd lsl$source_root:[dfad.fadtmerge]"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	fadtmerge_dbg=""
$	cldgen=""
$	mes=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop fadtmerge_dbg "With Debug ? "
$	if .not. fadtmerge_dbg then goto a04
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
$	FADTMERGE = "t"
$	GET_COMMAND = "t"
$	OPEN_FILES = "t"
$	MERGE_FILES = "t"
$	FIND_MH = "t"
$	UPDATE_MH = "t"
$	CONSTRUCT_ACCREG = "t"
$	FEATURE_ACCREG = "t"
$	FIND_NF = "t"
$	SKIP_TO_EF = "t"
$	COPY_START_NF = "t"
$	CONSTRUCT_AC = "t"
$	READ_FADT = "t"
$	READ_DSI = "t"
$	READ_HEADER = "t"
$	READ_ACC = "t"
$	READ_ACCREG = "t"
$	REPORT_FADT = "t"
$	REPORT_FEATURE = "t"
$	MARK_FADT = "t"
$	CLOSE_FILES = "t"
$	LIST_HEADING = "t"
$	LL2INT = "t"
$	DTOBIN = "t"
$	FIND_LAYER_ONE = "t"
$	COPY_TO_END = "t"
$	SEL_IFFNXT = "t"
$	cldgen="t"
$	goto a11
$ a05:	   
$	ws " "
$	ws ".............................Command stuff"
$	   inq/nop cldgen	"Generate command definitions? "
$	ws " " 
$	ws ".............................FORTRAN sources"
$	inq/nop FADTMERGE "FADTMERGE? "
$	inq/nop GET_COMMAND "GET_COMMAND? "
$	inq/nop OPEN_FILES "OPEN_FILES? "
$	inq/nop MERGE_FILES "MERGE_FILES? "
$	inq/nop FIND_MH "FIND_MH? "
$	inq/nop UPDATE_MH "UPDATE_MH? "
$	inq/nop CONSTRUCT_ACCREG "CONSTRUCT_ACCREG? "
$	inq/nop FEATURE_ACCREG "FEATURE_ACCREG? "
$	inq/nop FIND_NF "FIND_NF? "
$	inq/nop SKIP_TO_EF "SKIP_TO_EF? "
$	inq/nop COPY_START_NF "COPY_START_NF? "
$	inq/nop CONSTRUCT_AC "CONSTRUCT_AC? "
$	inq/nop READ_FADT "READ_FADT? "
$	inq/nop READ_DSI "READ_DSI? "
$	inq/nop READ_HEADER "READ_HEADER? "
$	inq/nop READ_ACC "READ_ACC? "
$	inq/nop READ_ACCREG "READ_ACCREG? "
$	inq/nop REPORT_FADT "REPORT_FADT? "
$	inq/nop REPORT_FEATURE "REPORT_FEATURE? "
$	inq/nop MARK_FADT "MARK_FADT? "
$	inq/nop CLOSE_FILES "CLOSE_FILES? "
$	inq/nop LIST_HEADING "LIST_HEADING? "
$	inq/nop LL2INT "LL2INT? "
$	inq/nop DTOBIN "DTOBIN? "
$	inq/nop FIND_LAYER_ONE "FIND_LAYER_ONE? "
$	inq/nop COPY_TO_END "COPY_TO_END? "
$	inq/nop SEL_IFFNXT "SEL_IFFNXT? "
$!
$ a11:
$	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkver="fadtmerge"
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!	   
$	   if .not. compile then goto lnkonly
$!
$ notkb:
$		wc "$ 	set noverify"
$!
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 	set verify"
$ 		if .not.mes then goto cmponly
$		wc "$	newmsg/number=1692/prefix=fm__ -"
$		wc "	/parameter=for/runoff fadtmerge.mes"
$		wc "$ @fadtmerge.temp_com"
$!	
$ cmponly:		
$	if .not. cldgen then goto for2
$		wc "$	adc fadtmerge.tmp = fadtmerge_cld.cld"
$		wc "$	set command/object =fadtmerge_cld fadtmerge.tmp"
$		wc "$	pvv fadtmerge_cld"
$		wc "$	delete fadtmerge.tmp;*"
$		wc "$	delete adc.ide;*"
$		wc "$	purge fadtmerge_cld.obj"
$ for2: if .not. compile then goto lnkonly
$!	
$!
$	if FADTMERGE then call compiler FADTMERGE
$	if GET_COMMAND then call compiler GET_COMMAND
$	if OPEN_FILES then call compiler OPEN_FILES
$	if MERGE_FILES then call compiler MERGE_FILES
$	if FIND_MH then call compiler FIND_MH
$	if UPDATE_MH then call compiler UPDATE_MH
$	if CONSTRUCT_ACCREG then call compiler CONSTRUCT_ACCREG
$	if FEATURE_ACCREG then call compiler FEATURE_ACCREG
$	if FIND_NF then call compiler FIND_NF
$	if SKIP_TO_EF then call compiler SKIP_TO_EF
$	if COPY_START_NF then call compiler COPY_START_NF
$	if CONSTRUCT_AC then call compiler CONSTRUCT_AC
$	if READ_FADT then call compiler READ_FADT
$	if READ_DSI then call compiler READ_DSI
$	if READ_HEADER then call compiler READ_HEADER
$	if READ_ACC then call compiler READ_ACC
$	if READ_ACCREG then call compiler READ_ACCREG
$	if REPORT_FADT then call compiler REPORT_FADT
$	if REPORT_FEATURE then call compiler REPORT_FEATURE
$	if MARK_FADT then call compiler MARK_FADT
$	if CLOSE_FILES then call compiler CLOSE_FILES
$	if LIST_HEADING then call compiler LIST_HEADING
$	if LL2INT then call compiler LL2INT
$	if DTOBIN then call compiler DTOBIN
$	if FIND_LAYER_ONE then call compiler FIND_LAYER_ONE
$	if COPY_TO_END then call compiler COPY_TO_END
$	if SEL_IFFNXT then call compiler SEL_IFFNXT
$	   goto lnkonly
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
$	wc "$ 	link''linkopts'/exe=''linkver' fadtmerge/opt, -"
$	WC "		lsl$library:lslshr/opt, lsl$library:iffshr/opt"
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	fadtmergeex:"
$		wc "$ 	deass/group lsl$fadtmerge_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto fadtmergeex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$fadtmerge_building
$	submit/notify/noprint/keep/restart fadtmergebat.com
$	goto fadtmergex2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto fadtmergeex
$	deass/group lsl$fadtmerge_building
$	@fadtmergebat.com
$	goto fadtmergex2
$ fadtmergeex:
$	deass/group lsl$fadtmerge_building
$ fadtmergex2:
$	if ver then set verify
