$!
$! 	Copyright Laser-Scan Limited, Cambridge, England.
$!
$! 	Command file for building IIS2DTI
$!
$	ver=f$verify(0)
$!
$	on error then goto iis2dtiex
$	on control_y then exit
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$iis2dti_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto iis2dtiex
$	define/group lsl$iis2dti_building "in_progress"
$	open/write comfil iis2dtibat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto iis2dtiex"
$	wc	"$	if ""'","'f$logical(""lsl$iis2dti_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$a0:	define/group lsl$iis2dti_building ""in_progress"""
$	wc	"$	assign here lsl$cmniis2dti"
$	wc	"$	sd:=$lsl$sys:sd"
$	wc	"$	set noon"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop iis2dti_dbg "With Debug ? "
$	if .not. iis2dti_dbg then goto a04
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
$	   inq/nop cld "Compile CLD modules ? "
$	   inq/nop mes "Compile messages ? "
$!
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all FORTRAN sources ? "
$	   if .not. everything then goto a05
$	   iis2dti="t"
$	   goto a11
$!
$ a05:	   inq/nop iis2dti	"Compile IIS2DTI?	"
$	   write sys$output " "
$!
$ a11:	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   linkver="iis2dti"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="iis2dtix"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$	   
$ notkb:
$!
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		set verify"
$!
$		if .not. mes then goto nomes
$!
$		newmsg  iis2dti/dti/number=1674/runoff/par=fortran/pref=i2d__
$		@iis2dti.temp_com
$		purge iis2dtimsg.*
$!
$!.............................................................................
$nomes:
$	   if .not. cld then goto fortonly
$		wc "$ 		adc iis2dti.tmp=iis2dti_cld.cld"
$		wc "$ 		set command/object=iis2dti_cld iis2dti.tmp"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv iis2dti_cld"
$		wc "$ 		if ok then delete iis2dti.tmp;*"
$		wc "$ 		if ok then purge/nolog iis2dti_cld.obj"
$
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. iis2dti then goto lnkonly
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		adc iis2dti''kpcom'=iis2dti"
$	   	wc "$ 		fort''fsw1' iis2dti"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv iis2dti"
$		wc "$ 		purge/nolog iis2dti.obj"
$		wc "$ 		purge/nolog iis2dti.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog iis2dti.lis"
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		link''linkopts'/exe=''linkver' iis2dti,-"
$	   	wc "		iis2dti_cld, -"
$	   	wc "		iis2dti.promsg_obj, -"
$	   	wc "		lsl$library:dtilib/lib,lslshr/opt"
$!
$ nolnk:
$		wc "$ 		iis2dtiex:"
$		wc "$ 		deass/group lsl$iis2dti_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto iis2dtiex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$iis2dti_building
$	bat iis2dtibat.com
$	goto iis2dtix2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto iis2dtiex
$	deass/group lsl$iis2dti_building
$	@iis2dtibat.com
$	goto iis2dtix2
$!
$ iis2dtiex:
$	deass/group lsl$iis2dti_building
$ iis2dtix2:
$	purge iis2dtibat.com
$	purge iis2dti.map
$	delete adc.ide;*
$!
$	if ver then set verify
$!
