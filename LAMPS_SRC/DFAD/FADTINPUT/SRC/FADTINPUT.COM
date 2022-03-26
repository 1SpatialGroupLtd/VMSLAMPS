$!
$! Command file to build DFAD utility FADTINPUT
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!	Created						TJH 12-Jan-1987
$!
$	ver=f$verify(0)
$!
$	on error then goto fadtinputex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$fadtinput_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto fadtinputex
$	define/group lsl$fadtinput_building "in_progress"
$	open/write comfil fadtinputbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto fadtinputex"
$	wc "$	if ""'","'f$logical(""lsl$fadtinput_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$fadtinput_building ""in_progress"""
$	wc "$	assign lsl$source_root:[dfad.fadtinput] lsl$fadtinput"
$	wc "$	assign lsl$source_root:[dfad.fadtcmn] lsl$fadtcmn"
$	wc "$	sd:=$lsl$exe:sd"
$	wc "$	sd lsl$source_root:[dfad.fadtinput]"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	fadtinput_dbg=""
$	frmgen=""
$	mes=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop fadtinput_dbg "With Debug ? "
$	if .not. fadtinput_dbg then goto a04
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
$	FADTINPUT = "t"
$	FADTINPUT_INIT = "t"
$	READ_LOGICAL_NAMES = "t"
$	FORM_MSG = "t"
$	FORM_SETUP = "t"
$	FORM_CLOSEDOWN = "t"
$	FILE_FORM = "t"
$	COMMAND_FORM = "t"
$	LIST_FORM = "t"
$	ENTER_RECORDS = "t"
$	ENTER_FORM = "t"
$	ACC_FORM = "t"
$	ACCREG_FORM = "t"
$	DSI_FORM = "t"
$	FADT_FORM = "t"
$	HEADER_FORM = "t"
$	ACC_READ = "t"
$	ACC_WRITE = "t"
$	ACCREG_READ = "t"
$	ACCREG_WRITE = "t"
$	DSI_READ = "t"
$	DSI_WRITE = "t"
$	FADT_READ = "t"
$	FADT_DELETE = "t"
$	FADT_WRITE = "t"
$	HEADER_READ = "t"
$	HEADER_WRITE = "t"
$	DEFCMD = "t"
$	READ_DEF = "t"
$	READ_ACC_DEF = "t"
$	READ_DSI_DEF = "t"
$	READ_DLMS_DEF = "t"
$	READ_FADT_DEF = "t"
$	SWAP = "t"
$	CF = "t"
$	COPY_STRING = "t"
$	FIND_LEVEL = "t"
$	LATLONG_VALIDATE = "t"
$	FADT_VALIDATE = "t"
$	DATE_VALIDATE = "t"
$!	READ_RULE = "t"
$	READ_DEF_RULE = "t"
$	READ_FILE_RULE = "t"
$	CHECK_BY_RULE = "t"
$	OUTPUT_LIST = "t"
$	LIST_DSI = "t"
$	LIST_FADT = "t"
$	LIST_ACC = "t"
$	LIST_ACCREG = "t"
$	LIST_HEADER = "t"
$	OPEN_FILES = "t"
$	OPEN_FADT = "t"
$	COPY_OLD_FADT = "t"
$	OPEN_RULE = "t"
$	OPEN_LIST = "t"
$	CLOSE_FILES = "t"
$	goto a11
$ a05:	   
$	ws " " 
$	ws ".............................FORTRAN sources"
$	inq/nop FADTINPUT "FADTINPUT? "
$	inq/nop FADTINPUT_INIT "FADTINPUT_INIT? "
$	inq/nop READ_LOGICAL_NAMES "READ_LOGICAL_NAMES?"
$	inq/nop FORM_MSG "FORM_MSG? "
$	inq/nop FORM_SETUP "FORM_SETUP? "
$	inq/nop FORM_CLOSEDOWN "FORM_CLOSEDOWN? "
$	inq/nop FILE_FORM "FILE_FORM? "
$	inq/nop COMMAND_FORM "COMMAND_FORM? "
$	inq/nop LIST_FORM "LIST_FORM? "
$	inq/nop ENTER_RECORDS "ENTER_RECORDS? "
$	inq/nop ENTER_FORM "ENTER_FORM? "
$	inq/nop ACC_FORM "ACC_FORM? "
$	inq/nop ACCREG_FORM "ACCREG_FORM? "
$	inq/nop DSI_FORM "DSI_FORM? "
$	inq/nop FADT_FORM "FADT_FORM? "
$	inq/nop HEADER_FORM "HEADER_FORM? "
$	inq/nop ACC_READ "ACC_READ? "
$	inq/nop ACC_WRITE "ACC_WRITE? "
$	inq/nop ACCREG_READ "ACCREG_READ? "
$	inq/nop ACCREG_WRITE "ACCREG_WRITE? "
$	inq/nop DSI_READ "DSI_READ? "
$	inq/nop DSI_WRITE "DSI_WRITE? "
$	inq/nop FADT_READ "FADT_READ? "
$	inq/nop FADT_DELETE "FADT_DELETE? "
$	inq/nop FADT_WRITE "FADT_WRITE? "
$	inq/nop	HEADER_READ "HEADER_READ? "
$	inq/nop HEADER_WRITE "HEADER_WRITE? "
$	inq/nop DEFCMD "DEFCMD? "
$	inq/nop READ_DEF "READ_DEF? "
$	inq/nop READ_ACC_DEF "READ_ACC_DEF? "
$	inq/nop READ_DSI_DEF "READ_DSI_DEF? "
$	inq/nop READ_DLMS_DEF "READ_DLMS_DEF? "
$	inq/nop READ_FADT_DEF "READ_FADT_DEF? "
$	inq/nop SWAP "SWAP? "
$	inq/nop CF "CF? "
$	inq/nop COPY_STRING "COPY_STRING? "
$	inq/nop FIND_LEVEL "FIND_LEVEL? "
$	inq/nop LATLONG_VALIDATE "LATLONG_VALIDATE? "
$	inq/nop FADT_VALIDATE "FADT_VALIDATE? "
$	inq/nop DATE_VALIDATE "DATE_VALIDATE? "
$!	inq/nop READ_RULE "READ_RULE? "
$	inq/nop READ_DEF_RULE "READ_DEF_RULE? "
$	inq/nop READ_FILE_RULE "READ_FILE_RULE? "
$	inq/nop CHECK_BY_RULE "CHECK_BY_RULE? "
$	inq/nop OUTPUT_LIST "OUTPUT_LIST? "
$	inq/nop LIST_DSI "LIST_DSI? "
$	inq/nop LIST_FADT "LIST_FADT? "
$	inq/nop LIST_ACC "LIST_ACC? "
$	inq/nop LIST_ACCREG "LIST_ACCREG? "
$	inq/nop LIST_HEADER "LIST_HEADER? "
$	inq/nop OPEN_FILES "OPEN_FILES? "
$	inq/nop OPEN_FADT "OPEN_FADT? "
$	inq/nop COPY_OLD_FADT "COPY_OLD_FADT? "
$	inq/nop OPEN_RULE "OPEN_RULE? "
$	inq/nop OPEN_LIST "OPEN_LIST? "
$	inq/nop CLOSE_FILES "CLOSE_FILES? "
$!
$ a11:
$	   inq/nop frmgen "Generate form library? "
$	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$!
$	   if .not. lnkit then goto notkb
$!
$	   linkver="fadtinput"
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!	   
$ notkb:
$		wc "$ 	set noverify"
$!
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 	set verify"
$!
$ 	if .not.mes then goto cmponly
$
$		wc "$	newmsg/number=1645/prefix=fadtin__ -"
$		wc "	/parameter=for/runoff fadtinput.mes"
$		wc "$ @fadtinput.temp_com"
$	
$ cmponly:		
$!
$	if .not. frmgen then goto for2
$!
$		wc "$	fms/library/create fadtin comopt,fr_fil, -
$		wc "		lstfil,recopt,acc,dsi,fadt,level, -"
$		wc "		accreg, header"
$		wc "$	fms/object fadtin.flb"
$!
$!		wc "$	adc fadtinput.tmp = fadtinput_cld.cld"
$!		wc "$	set command/object =fadtinput_cld fadtinput.tmp"
$!		wc "$	pvv fadtinput_cld"
$!		wc "$	delete fadtinput.tmp;*"
$!		wc "$	delete adc.ide;*"
$!		wc "$	purge fadtinput_cld.obj"
$!
$ for2: 
$!
$	if .not. compile then goto lnkonly
$!
$	if FADTINPUT then call compiler FADTINPUT
$	if FADTINPUT_INIT then call compiler FADTINPUT_INIT
$	if READ_LOGICAL_NAMES then call compiler READ_LOGICAL_NAMES
$	if FORM_MSG then call compiler FORM_MSG
$	if FORM_SETUP then call compiler FORM_SETUP
$	if FORM_CLOSEDOWN then call compiler FORM_CLOSEDOWN
$	if FILE_FORM then call compiler FILE_FORM
$	if COMMAND_FORM then call compiler COMMAND_FORM
$	if LIST_FORM then call compiler LIST_FORM
$	if ENTER_RECORDS then call compiler ENTER_RECORDS
$	if ENTER_FORM then call compiler ENTER_FORM
$	if ACC_FORM then call compiler ACC_FORM
$	if ACCREG_FORM then call compiler ACCREG_FORM
$	if DSI_FORM then call compiler DSI_FORM
$	if FADT_FORM then call compiler FADT_FORM
$	if HEADER_FORM then call compiler HEADER_FORM
$	if ACC_READ then call compiler ACC_READ
$	if ACC_WRITE then call compiler ACC_WRITE
$	if ACCREG_READ then call compiler ACCREG_READ
$	if ACCREG_WRITE then call compiler ACCREG_WRITE
$	if DSI_READ then call compiler DSI_READ
$	if DSI_WRITE then call compiler DSI_WRITE
$	if FADT_READ then call compiler FADT_READ
$	if FADT_DELETE then call compiler FADT_DELETE
$	if FADT_WRITE then call compiler FADT_WRITE
$	if HEADER_READ then call compiler HEADER_READ
$	if HEADER_WRITE then call compiler HEADER_WRITE
$	if DEFCMD then call mcompiler DEFCMD
$	if READ_DEF then call compiler READ_DEF
$	if READ_ACC_DEF then call compiler READ_ACC_DEF
$	if READ_DSI_DEF then call compiler READ_DSI_DEF
$	if READ_DLMS_DEF then call compiler READ_DLMS_DEF
$	if READ_FADT_DEF then call compiler READ_FADT_DEF
$	if SWAP then call compiler SWAP
$	if CF then call compiler CF
$	if COPY_STRING then call compiler COPY_STRING
$	if FIND_LEVEL then call compiler FIND_LEVEL
$	if DATE_VALIDATE then call compiler DATE_VALIDATE
$	if LATLONG_VALIDATE then call compiler LATLONG_VALIDATE
$	if FADT_VALIDATE then call compiler FADT_VALIDATE
$!	if READ_RULE then call compiler READ_RULE
$	if READ_DEF_RULE then call compiler READ_DEF_RULE
$	if READ_FILE_RULE then call compiler READ_FILE_RULE
$	if CHECK_BY_RULE then call compiler CHECK_BY_RULE
$	if OUTPUT_LIST then call compiler OUTPUT_LIST
$	if LIST_DSI then call compiler LIST_DSI
$	if LIST_FADT then call compiler LIST_FADT
$	if LIST_ACC then call compiler LIST_ACC
$	if LIST_ACCREG then call compiler LIST_ACCREG
$	if LIST_HEADER then call compiler LIST_HEADER
$	if OPEN_FILES then call compiler OPEN_FILES
$	if OPEN_FADT then call compiler OPEN_FADT
$	if COPY_OLD_FADT then call compiler COPY_OLD_FADT
$	if OPEN_RULE then call compiler OPEN_RULE
$	if OPEN_LIST then call compiler OPEN_LIST
$	if CLOSE_FILES then call compiler CLOSE_FILES
$	   goto lnkonly
$!----------------------------------------------------------------------
$ compiler: subroutine 
$!----------------------------------------------------------------------
$		wc "$ 	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc ''p1'''kpcom'=''p1'"
$	      	wc "$ 	fort''fsw1' ''p1'"	
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
$!----------------------------------------------------------------------
$ mcompiler: subroutine 
$!----------------------------------------------------------------------
$		wc "$ 	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$	   	wc "$	macro''mldbg' ''p1'"
$		wc "$ 	purge/nolog ''p1'.obj"
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
$!
$!	wc "$ 	run lsl$exe:genver"
$!		call compiler version
$!	wc "$ 	purge/nolog version.src"
$!	wc "$ set verify"
$!
$	wc "$ 	link''linkopts'/exe=''linkver' fadtinput/opt, -"
$	WC "		lsl$library:lslshr/opt"
$	wc "$ 	purge/nolog *.exe,*.map
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	fadtinputex:"
$		wc "$ 	deass/group lsl$fadtinput_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto fadtinputex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$fadtinput_building
$	submit/notify/restart/keep/noprint/que=fastbatch_m3e fadtinputbat.com
$	goto fadtinputx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto fadtinputex
$	deass/group lsl$fadtinput_building
$	@fadtinputbat.com
$	goto fadtinputx2
$ fadtinputex:
$	deass/group lsl$fadtinput_building
$ fadtinputx2:
$	if ver then set verify
