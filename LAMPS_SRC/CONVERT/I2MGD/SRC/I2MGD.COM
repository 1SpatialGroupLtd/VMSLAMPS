$!                           
$! Command file to build CONVERT utility I2MGD
$!
$! Copyright (C) Laser-Scan Limited, Cambridge, England.
$!
$!	Amended	for I2MGD				FJB 29-Jul-1988
$!	Created						TJH 12-Jan-1987
$!
$!	Mod 1435 Use new frtshr				 JB 29-Nov-1994
$!
$	ver=f$verify(0)
$!
$	on error then goto i2mgdex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$i2mgd_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto i2mgdex
$	define/group lsl$i2mgd_building "in_progress"
$	open/write comfil i2mgdbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto i2mgdex"
$	wc "$	if ""'","'f$logical(""lsl$i2mgd_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$i2mgd_building ""in_progress"""
$	wc "$	assign here lsl$cmni2mgd"
$!	wc "$	assign lsl$source_root:[convert.service] lsl$convertsys"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	i2mgd_dbg=""
$	macbuild=""
$	mes=""
$	cldgen = ""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop i2mgd_dbg "With Debug ? "
$	if .not. i2mgd_dbg then goto a04
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
$	ACDATA="t"
$	ACHEAD="t"
$	ANAME="t"
$	CLSFIL="t"
$	CMDLIN="t"
$	CODATA="t"
$	GETF="t"
$	I2MGD="t"
$	IFFBDY="t"
$	OUTREC="t"
$	goto a11               
$ a05:	   
$!	ws " "
$!	ws ".............................MACRO32 stuff"
$!	   inq/nop macbuild	"Compile command table? "
$	ws " " 
$	ws ".............................FORTRAN sources"
$	inq/nop ACDATA "ACDATA ? "
$	inq/nop ACHEAD "ACHEAD ? "
$	inq/nop ANAME "ANAME ? "
$	inq/nop CLSFIL "CLSFIL ? "
$	inq/nop CMDLIN "CMDLIN ? "
$	inq/nop CODATA "CODATA ? "
$	inq/nop GETF "GETF ? "
$	inq/nop I2MGD "I2MGD ? "
$	inq/nop IFFBDY "IFFBDY ? "
$	inq/nop OUTREC "OUTREC ? "
$!
$ a11:
$	   inq/nop mes "Generate message definitions ? "
$	   inq/nop cldgen "Generate command definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   linkver="i2mgd"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="i2mgdx"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!	   
$ notkb:
$		wc "$ 	set noverify"
$!
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 	set verify"
$ 		if .not.mes then goto do_cld
$		wc "$	newmsg/number=1617/name=i2mgd/prefix=I2MGD__"+ -
		       	"/parameter=for/runoff i2mgd.mes"
$		wc "$ @i2mgd.temp_com"
$!	
$ do_cld:
$	if .not. cldgen then goto cmponly
$		wc "$	adc i2mgd.tmp = i2mgd_cld.cld"
$		wc "$	set command/object =i2mgd_cld i2mgd.tmp"
$		wc "$	pvv i2mgd_cld"
$		wc "$	delete i2mgd.tmp;*"
$		wc "$	delete adc.ide;*"
$		wc "$	purge i2mgd_cld.obj"
$		wc "$	set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$!	
$ cmponly:		
$	if .not. compile then goto lnkonly
$	mdeb=""
$	if i2mgd_dbg then mdeb = "/Enable=debug"
$!	if .not. macbuild then goto for2
$!		wc "$	MACRO''mdeb' i2mgd_cmdtab"
$ for2: if .not. compile then goto lnkonly
$	
$!                    
$	if ACDATA then call compiler ACDATA
$	if ACHEAD then call compiler ACHEAD
$	if ANAME then call compiler ANAME
$	if CLSFIL then call compiler CLSFIL
$	if CMDLIN then call compiler CMDLIN
$	if CODATA then call compiler CODATA
$	if GETF then call compiler GETF
$	if I2MGD then call compiler I2MGD
$	if IFFBDY then call compiler IFFBDY
$	if OUTREC then call compiler OUTREC
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
$	wc "$ link''linkopts'/exe=''linkver' - "
$       wc "  i2mgd,cmdlin,getf,aname,iffbdy,clsfil, - "
$       wc "  acdata,achead,codata,outrec, - "
$	wc "  i2mgd_cld,-
$       wc "  version, - "
$       wc "  i2mgd.promsg_obj, - "
$	wc "  lsl$library:frtshr/opt, - "
$       wc "  lsl$library:iffshr/opt, - "
$       wc "  lsl$library:lslshr/opt "
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	i2mgdex:"
$		wc "$ 	deass/group lsl$i2mgd_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto i2mgdex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$i2mgd_building
$	bat i2mgdbat.com
$	goto i2mgdx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto i2mgdex
$	deass/group lsl$i2mgd_building
$	@i2mgdbat.com
$	goto i2mgdx2
$!
$ i2mgdex:
$	deass/group lsl$i2mgd_building
$!
$ i2mgdx2:
$	if ver then set verify
$!                                         
