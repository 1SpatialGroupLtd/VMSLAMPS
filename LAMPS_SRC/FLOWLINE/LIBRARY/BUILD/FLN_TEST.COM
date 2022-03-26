$!
$! Command file to build FLOWLINE utility fln_test
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!	Created						MWSR 29-Feb-1988$!
$	ver=f$verify(0)
$!
$	on error then goto fln_testex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$fln_test_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto fln_testex
$	define/group lsl$fln_test_building "in_progress"
$	open/write comfil fln_testbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto fln_testex"
$	wc "$	if ""'","'f$logical(""lsl$fln_test_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$fln_test_building ""in_progress"""
$	wc "$	assign lsl$source_root:[flowline.src] lsl$cmnflowline
$	wc "$	sd:=$lsl$sys:sd"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	fln_test_dbg=""
$	macbuild=""
$	cld=""
$	mes=""
$	inquire/nop compile "Compile FORTRAN ? "
$	if .not.compile then goto a11
$	inquire/nop fln_test_dbg "With Debug ? "
$	if .not. fln_test_dbg then goto a04
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
$	   fln_test="t"
$	   flntst = "t"
$!
$	   goto a11
$!
$ a05:	   
$	ws " "
$	ws ".............................First the main module"
$ 	   inq/nop fln_test	"Compile fln_test ? "
$	   inq/nop flntst       "Compile command table? "
$	ws " "
$	ws " "
$ a11:
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkver="fln_test"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="fln_testx"
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!	   
$	   inquire/nop lnktst "Link with test LSLLIB ? "
$	   if .not. compile then goto lnkonly
$!
$ notkb:
$		wc "$ 	set noverify"
$!
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 	set verify"
$!	
$ cmponly: if .not. compile then goto lnkonly
$	if fln_test then call compiler fln_test
$	if .not. flntst then goto lnkonly
$		wc "$   set verify"
$		wc "$	MACRO  flntst+lsl$library:lslmaclib/lib"
$		wc "$   set noverify"
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ compiler: subroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
$   	wc "$ 	link''linkopts'/exe=''linkver' fln_test,flntst,-"
$	wc "	lsl$cmnflowline:flowline/lib, -"
$!
$   	wc "	lsl$library:lsllib/lib"
$!
$ nolnk:
$	wc "$ 	nolnk:"
$	wc "$ 	fln_testex:"
$	wc "$   purge/log fln_test.exe,fln_test.map"
$	wc "$ 	deass/group lsl$fln_test_building"
$	wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto fln_testex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$fln_test_building
$	bat fln_testbat.com
$	goto fln_testx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto fln_testex
$	deass/group lsl$fln_test_building
$	@fln_testbat.com
$	goto fln_testx2
$ fln_testex:
$	deass/group lsl$fln_test_building
$ fln_testx2:
$	if ver then set verify
