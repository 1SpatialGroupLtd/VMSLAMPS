$!
$! 	Command file to build MATRIX utility DTICOMBINE
$!
$! 	Copyright Laser-Scan Limited, Cambridge, England.
$!	Created						TJH 12-Jan-1987
$!
$!	Modified to use matrix service library 		ALB 17-Jun-1988
$!	Classification added				JHR 20-Sep-1988
$!      Modhead routine added			       MWSR 24-Nov-1988
$!
$	ver=f$verify(0)
$!
$	on error then goto dticombineex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$dticombine_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto dticombineex
$	define/group lsl$dticombine_building "in_progress"
$	open/write comfil dticombinebat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto dticombineex"
$	wc "$	if ""'","'f$logical(""lsl$dticombine_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$dticombine_building ""in_progress"""
$	wc "$	assign here lsl$cmndticombine"
$	wc "$	assign lsl$source_root:[matrix.service] lsl$matrixsys"
$	wc "$	assign lsl$source_root:[matrix.service] lsl$dtmcreatesys"
$	wc "$	sd:=$lsl$sys:sd"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	dticombine_dbg=""
$	macbuild=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop dticombine_dbg "With Debug ? "
$	if dticombine_dbg
$	then
$	   fsw1="/debug/noopt/check=(bounds,overflow)/list"
$	   mldbg="/debug"
$	   kpcom="/co"
$	endif
$ a04:
$!
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all sources ? "
$	   if .not. everything then goto a05
$	   arithm="t"
$	   bridge="t"
$	   check_operands="t"
$	   classification1="t"
$	   classification2="t"
$	   close_files="t"
$	   copy_string="t"
$	   dticombine="t"
$	   evlxpr="t"
$	   excp_hand="t"
$	   expression="t"
$	   filein_cmd="t"
$	   fileout_cmd="t"
$	   help_cmd="t"
$	   modhead="t"
$	   opndti="t"
$	   parse="t"
$	   readll="t"
$	   prec="t"
$	   show_cmd="t"
$	   units_cmd="t"
$	   window_cmd="t"
$	   macbuild="t"
$	goto a11
$ a05:	   
$	ws " "
$	ws ".............................MACRO32 stuff"
$	   inq/nop macbuild	"Compile command table? "
$	ws " " 
$	ws ".............................FORTRAN sources"
$	inq/nop arithm "arithm "
$	inq/nop bridge "bridge "
$	inq/nop check_operands "check_operands "
$	inq/nop classification1 "classification - class_* functions "
$	inq/nop classification2 "classification - *_class functions "
$	inq/nop close_files "close_files "
$	inq/nop copy_string "copy_string "
$	inq/nop dticombine "dticombine "
$	inq/nop evlxpr "evlxpr "
$	inq/nop excp_hand "excp_hand "
$	inq/nop expression "expression "
$	inq/nop filein_cmd "filein_cmd "
$	inq/nop fileout_cmd "fileout_cmd "
$	inq/nop help_cmd "help_cmd "
$	inq/nop modhead "modhead "
$	inq/nop opndti "opndti "
$	inq/nop parse "parse "
$	inq/nop prec "prec "
$	inq/nop readll "readll "
$	inq/nop show_cmd "show_cmd "
$	inq/nop units_cmd "units_cmd "
$	inq/nop window_cmd "window_cmd "
$!
$ a11:
$	ws " " 
$	ws ".............................LINK options"
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkver="dticombine"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="dticombinex"
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer
$	   then
$	     linkopts=linkopts+"/debug/cross"
$	   else
$	     inquire/nop answer "code performance analyser ?"
$	     if answer then linkopts=linkopts+"/debug=SYS$LIBRARY:PCA$OBJ.OBJ"
$	   endif
$!	   
$	   if .not. compile then goto lnkonly
$!
$ notkb:
$		wc "$ 	set noverify"
$!
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ cmponly:		
$	mdeb=""
$	if dticombine_dbg then mdeb = "/Enable=debug"
$	if .not. macbuild then goto for2
$		wc "$ 	set verify"
$		wc "$	MACRO''mdeb' dticombine_cmdtab"
$ for2: if .not. compile then goto lnkonly
$	
$!
$	if arithm then call compiler arithm
$	if bridge then call compiler bridge
$	if check_operands then call compiler check_operands
$	if classification1 then call compiler class_process
$	if classification1 then call compiler class_eval
$	if classification1 then call compiler class_parse_clear
$	if classification1 then call compiler class_invoke
$	if classification1 then call compiler show_class
$	if classification2 then call compiler create_class
$	if classification2 then call compiler fnd_class
$	if classification2 then call compiler cmp_class
$	if classification2 then call compiler store_class
$	if classification2 then call compiler tst_class
$	if close_files then call compiler close_files
$	if copy_string then call compiler copy_string
$	if dticombine then call compiler dticombine
$	if excp_hand then call compiler excp_hand
$	if evlxpr then call compiler evlxpr
$	if expression then call compiler expression
$	if filein_cmd then call compiler filein_cmd
$	if fileout_cmd then call compiler fileout_cmd
$	if help_cmd then call compiler help_cmd
$	if modhead then call compiler modhead
$	if opndti then call compiler opndti
$	if parse then call compiler parse
$	if prec then call compiler prec
$	if readll then call compiler readll
$	if show_cmd then call compiler show_cmd
$	if units_cmd then call compiler units_cmd
$	if window_cmd then call compiler window_cmd
$	   goto lnkonly
$!----------------------------------------------------------------------
$ compiler: subroutine 
$		wc "$   on error then exit 4"
$		wc "$ 	set noverify"
$		wc "$	write sys$output "".------------------------."""
$		wc "$	write sys$output ""| .- .-. . . .-. O .  .- |"""
$		wc "$	write sys$output ""| |  | | |V| |-' | |  +- |"""
$		wc "$	write sys$output ""| `- `-' ' ` '   + `- `- |"""
$		wc "$	write sys$output ""`------------------------'"""
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
$	wc "$ 	link''linkopts'/exe=''linkver' dticombine/opt,lsl$library:lslshr/opt"
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	dticombineex:"
$		wc "$ 	deass/group lsl$dticombine_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto dticombineex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$dticombine_building
$	bat dticombinebat.com
$	goto dticombinex2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto dticombineex
$	deass/group lsl$dticombine_building
$	@dticombinebat.com
$	goto dticombinex2
$ dticombineex:
$	deass/group lsl$dticombine_building
$ dticombinex2:
$	if ver then set verify
$	purge dticombine.map
$	purge dticombinebat.com
$!
