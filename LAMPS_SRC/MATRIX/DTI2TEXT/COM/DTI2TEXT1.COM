$!
$! Command file to build DTMCREATE utility DTI2TEXT
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!	Created						TJH 12-Jan-1987
$!
$	ver=f$verify(0)
$!
$	on error then goto dti2textex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$dti2text_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto dti2textex
$	define/group lsl$dti2text_building "in_progress"
$	open/write comfil dti2textbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto dti2textex"
$	wc "$	if ""'","'f$logical(""lsl$dti2text_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$dti2text_building ""in_progress"""
$	wc "$	assign lsl$source_root:[dtmprocess.dti2text] lsl$cmndti2text"
$	wc "$	assign lsl$source_root:[dtmprocess.service] lsl$dtmprocesssys"
$	wc "$	assign lsl$source_root:[dtmcreate.service] lsl$dtmcreatesys"
$	wc "$	sd:=$lsl$sys:sd"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	dti2text_dbg=""
$	macbuild=""
$	mes=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop dti2text_dbg "With Debug ? "
$	if .not. dti2text_dbg then goto a04
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
$	CHECK_FORMAT="t"
$	DISABLE_CMD="t"
$	ENABLE_CMD="t"
$	FILEIN_CMD="t"
$	FILEOUT_CMD="t"
$	GET_CMDS="t"
$	HELP_CMD="t"
$	DTI2TEXT="t"
$	OPNDTI="t"
$	READLL="t"
$	SHOW_CMD="t"
$	UNITS_CMD="t"
$	WINDOW_CMD="t"
$	FORMAT_CMD="t"
$	NULL_CMD="t"
$	PARSE_FORMAT="t"
$	TEXT_OUTPUT="t"
$	WNULL_SUBST="t"
$	macbuild="t"
$	goto a11
$ a05:	   
$	ws " "
$	ws ".............................MACRO32 stuff"
$	   inq/nop macbuild	"Compile command table? "
$	ws " " 
$	ws ".............................FORTRAN sources"
$	inq/nop CHECK_FORMAT "CHECK_FORMAT? "
$	inq/nop FORMAT_CMD "FORMAT_CMD? "
$	inq/nop NULL_CMD "NULL_CMD? "
$	inq/nop PARSE_FORMAT "PARSE_FORMAT? "
$	inq/nop TEXT_OUTPUT "TEXT_OUTPUT? "
$	inq/nop WNULL_SUBST "WNULL_SUBST? "
$	inq/nop DISABLE_CMD "DISABLE_CMD? "
$	inq/nop DTI2TEXT "DTI2TEXT? "
$	inq/nop DUPLIC "DUPLIC? "
$	inq/nop ENABLE_CMD "ENABLE_CMD? "
$	inq/nop FILEIN_CMD "FILEIN_CMD? "
$	inq/nop FILEOUT_CMD "FILEOUT_CMD? "
$	inq/nop GET_CMDS "GET_CMDS? "
$	inq/nop HELP_CMD "HELP_CMD? "
$	inq/nop OPNDTI "OPNDTI? "
$	inq/nop READLL "READLL? "
$	inq/nop SHOW_CMD "SHOW_CMD? "
$	inq/nop UNITS_CMD "UNITS_CMD? "
$	inq/nop WINDOW_CMD "WINDOW_CMD? "
$!
$ a11:
$	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkver="dti2text"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="dti2textx"
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
$		wc "$	newmsg/number=1642/prefix=dticont__-"
$		wc "	/parameter=for/name=dticont/runoff dti2text.mes"
$		wc "$ @dti2text.temp_com"
$!	
$ cmponly:		
$	mdeb=""
$	if dti2text_dbg then mdeb = "/Enable=debug"
$	if .not. macbuild then goto for2
$		wc "$	MACRO''mdeb' dti2text_cmdtab"
$ for2: if .not. compile then goto lnkonly
$	
$!
$	if CHECK_FORMAT then call compiler CHECK_FORMAT
$	if FORMAT_CMD then call compiler FORMAT_CMD
$	if NULL_CMD then call compiler NULL_CMD
$	if PARSE_FORMAT then call compiler PARSE_FORMAT
$	if TEXT_OUTPUT then call compiler TEXT_OUTPUT
$	if WNULL_SUBST then call compiler WNULL_SUBST
$	if DISABLE_CMD then call compiler DISABLE_CMD
$	if DTI2TEXT then call compiler DTI2TEXT
$	if ENABLE_CMD then call compiler ENABLE_CMD
$	if FILEIN_CMD then call compiler FILEIN_CMD
$	if FILEOUT_CMD then call compiler FILEOUT_CMD
$	if GET_CMDS then call compiler GET_CMDS
$	if HELP_CMD then call compiler HELP_CMD
$	if OPNDTI then call compiler OPNDTI
$	if READLL then call compiler READLL
$	if SHOW_CMD then call compiler SHOW_CMD
$	if UNITS_CMD then call compiler UNITS_CMD
$	if WINDOW_CMD then call compiler WINDOW_CMD
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
$	wc "$ 	run lsl$exe:genver"
$		call compiler version
$	wc "$ 	purge/nolog version.src"
$	wc "$ set verify"
$	wc "$ 	link''linkopts'/exe=''linkver' dti2text/opt"
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	dti2textex:"
$		wc "$ 	deass/group lsl$dti2text_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto dti2textex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$dti2text_building
$	bat dti2textbat.com
$	goto dti2textx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto dti2textex
$	deass/group lsl$dti2text_building
$	@dti2textbat.com
$	goto dti2textx2
$ dti2textex:
$	deass/group lsl$dti2text_building
$ dti2textx2:
$	if ver then set verify
