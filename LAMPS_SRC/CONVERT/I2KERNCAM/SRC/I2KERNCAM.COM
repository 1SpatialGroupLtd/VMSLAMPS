$!                                   
$! Command file to build CONVERT utility I2KERNCAM
$!
$! Copyright (C) Laser-Scan Limited, Cambridge, England.
$!
$!	Amended	for I2KERN				FJB 07-Sep-1988
$!	Amended	for I2MGD				FJB 29-Jul-1988
$!	Created						TJH 12-Jan-1987
$!
$!	Mod 1435 Use new frtshr				 JB 29-Nov-1994
$!
$	ver=f$verify(0)
$!
$	on error then goto i2kerncamex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$i2kerncam_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto i2kerncamex
$	define/group lsl$i2kerncam_building "in_progress"
$	open/write comfil i2kerncambat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto i2kerncamex"
$	wc "$	if ""'","'f$logical(""lsl$i2kerncam_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$i2kerncam_building ""in_progress"""
$	wc "$	assign here lsl$cmni2kerncam"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	i2kerncam_dbg=""
$	macbuild=""
$	mes=""
$	cldgen = ""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop i2kerncam_dbg "With Debug ? "
$	if .not. i2kerncam_dbg then goto a04
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
$	CAM_FEATURE="t"
$	CLSFIL="t"
$	CMDLIN="t"
$	GET_AC="t"
$	GETF="t"
$	I2KERNCAM="t"
$	IFFBDY="t"
$	goto a11               
$ a05:	   
$!	ws " "
$!	ws ".............................MACRO32 stuff"
$!	   inq/nop macbuild	"Compile command table? "
$	ws " " 
$	ws ".............................FORTRAN sources"
$	inq/nop CAM_FEATURE "CAM_FEATURE ? "
$	inq/nop CLSFIL "CLSFIL ? "
$	inq/nop CMDLIN "CMDLIN ? "
$	inq/nop GET_AC "GET_AC ? "
$	inq/nop GETF "GETF ? "
$	inq/nop I2KERNCAM "I2KERNCAM ? "
$	inq/nop IFFBDY "IFFBDY ? "
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
$	   linkver="i2kerncam"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="i2kerncamx"
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
$		wc "$	newmsg/number=1618/name=i2kerncam/prefix=I2KERN__"+ -
		       	"/parameter=for/runoff i2kerncam.mes"
$		wc "$ @i2kerncam.temp_com"
$!	
$ do_cld:
$	if .not. cldgen then goto cmponly
$		wc "$	adc i2kerncam.tmp = i2kerncam_cld.cld"
$		wc "$	set command/object =i2kerncam_cld i2kerncam.tmp"
$		wc "$	pvv i2kerncam_cld"
$		wc "$	delete i2kerncam.tmp;*"
$		wc "$	delete adc.ide;*"
$		wc "$	purge i2kerncam_cld.obj"
$		wc "$	set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$!	
$ cmponly:		
$	if .not. compile then goto lnkonly
$	mdeb=""
$	if i2kerncam_dbg then mdeb = "/Enable=debug"
$!	if .not. macbuild then goto for2
$!		wc "$	MACRO''mdeb' i2kerncam_cmdtab"
$ for2: if .not. compile then goto lnkonly
$	
$!                    
$	if CAM_FEATURE then call compiler CAM_FEATURE
$	if CLSFIL then call compiler CLSFIL
$	if CMDLIN then call compiler CMDLIN
$	if GET_AC then call compiler GET_AC
$	if GETF then call compiler GETF
$	if I2KERNCAM then call compiler I2KERNCAM
$	if IFFBDY then call compiler IFFBDY
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
$       wc "  i2kerncam,cmdlin,getf,iffbdy,clsfil, - "
$	wc "  get_ac,cam_feature, - "
$	wc "  i2kerncam_cld,-
$       wc "  version, - "
$       wc "  i2kerncam.promsg_obj, - "
$	wc "  lsl$library:frtshr/opt, - "
$       wc "  lsl$library:iffshr/opt, - "
$       wc "  lsl$library:lslshr/opt "
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	i2kerncamex:"
$		wc "$ 	deass/group lsl$i2kerncam_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto i2kerncamex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$i2kerncam_building
$	bat i2kerncambat.com
$	goto i2kerncamx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto i2kerncamex
$	deass/group lsl$i2kerncam_building
$	@i2kerncambat.com
$	goto i2kerncamx2
$!
$ i2kerncamex:
$	deass/group lsl$i2kerncam_building
$!
$ i2kerncamx2:
$	if ver then set verify
                                         
