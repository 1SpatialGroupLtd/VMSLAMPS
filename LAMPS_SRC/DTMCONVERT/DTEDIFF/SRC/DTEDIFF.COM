$!
$! Copyright Laser-Scan Limited, Cambridge, England.
$! Command file for building DTEDIFF
$! Author  :  D R Catlow
$! Created :  4 June 1988
$!
$	ver=f$verify(0)
$!
$	on error then goto dtediffex
$	on control_y then goto dtediffex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$dtediff_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto dtediffex
$	define/group lsl$dtediff_building "in_progress"
$	open/write comfil dtediffbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto dtediffex"
$	wc	"$	if ""'","'f$logical(""lsl$dtediff_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$a0:	define/group lsl$dtediff_building ""in_progress"""
$	wc	"$	sd:=$lsl$sys:sd"
$	wc	"$	set noon"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop dtediff_dbg "With Debug ? "
$	if .not. dtediff_dbg then goto a04
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
$	   inq/nop everything "Compile all FORTRAN sources ? "
$	   if .not. everything then goto a05
$	   dtediff ="t"
$	   files   ="t"
$	   read    ="t"
$	   write_f ="t"
$	   subacc  ="t"
$	   goto a11
$!
$ a05:     inq/nop dtediff	 "dtediff,get_commands ? "
$ 	   inq/nop files         "open/close_iff_file,open/close_dti_file ? "
$ 	   inq/nop read          "read_dsi,read_acc,read_poly,read_iff ? "
$ 	   inq/nop write_f       "write_hdr,write_dsi,write_acc ? "
$	   inq/nop subacc        "subacc,getsac ? "
$!
$	   write sys$output " "
$a11:	   inquire/nop commands "Compile Command Table ? "
$	   inquire/nop cld "Compile CLD ? "
$	   inq/nop mes "Generate message definitions ? "
$          inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   linkver="dtediff"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="dtediffx"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$	   
$ notkb:
$	        wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	        wc "$ 		set verify"
$ 		if .not. mes then goto nomessing
$  	        wc "$ newmsg/dti/runoff/number=1675/prefix=dtediff__ dtediff.mes"
$  		wc "$ @dtediff.temp_com "
$ nomessing:
$	   if .not. cld then goto fortonly
$		wc "$ 		adc dtediff.tmp=dtediff_cld.cld"
$		wc "$ 		set command/object=dtediff_cld dtediff.tmp"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dtediff_cld"
$	      	wc "$ 		delete dtediff.tmp;*"	
$		wc "$		purge/nolog dtediff_cld.obj"
$	      	wc "$ 		ok=$status"	
$!
$ fortonly:		
$	if .not. compile then goto lnkonly
$!
$ 	   if .not. dtediff then goto a120
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc dtediff''kpcom'=dtediff,get_commands"
$	   	wc "$ 		fort''fsw1' dtediff"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dtediff"
$		wc "$ 		purge/nolog dtediff.obj"
$		if fsw1.eqs."" then -
			wc "$ 		delete dtediff.for;*"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog dtediff.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$	 	purge/nolog dtediff.lis"
$		wc "$ 	delete adc.ide;*"
$!
$ a120:	   if .not. files then goto a130
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc files''kpcom'=open_iff_file,close_iff_file,open_dti_file,close_dti_file"
$	   	wc "$ 		fort''fsw1' files"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv files"
$		wc "$ 		purge/nolog files.obj"
$		if fsw1.nes."" then -
		wc "$ 		purge/nolog files.for"
$		if fsw1.eqs."" then -
		wc "$ 		delete files.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
		wc "$ 		purge/nolog files.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a130:	   if .not. read then goto a140
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc read''kpcom'=read_dsi,read_acc,read_poly,read_iff"
$	   	wc "$ 		fort''fsw1' read"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv read"
$		wc "$ 		purge/nolog read.obj"
$		if fsw1.nes."" then -
		wc "$ 		purge/nolog read.for"
$		if fsw1.eqs."" then -
		wc "$ 		delete read.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
		wc "$ 		purge/nolog read.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a140:	   if .not. write_f then goto a150
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc write_f ''kpcom'=write_hdr,write_dsi,write_acc"
$	   	wc "$ 		fort''fsw1' write_f"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv write_f"
$		wc "$ 		purge/nolog write_f.obj"
$		if fsw1.nes."" then -
		wc "$ 		purge/nolog write_f.for"
$		if fsw1.eqs."" then -
		wc "$ 		delete write_f.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
		wc "$ 		purge/nolog write_f.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a150:	   if .not. subacc then goto a160
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc subacc''kpcom'=subacc,getsac"
$	   	wc "$ 		fort''fsw1' subacc"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv subacc"
$		wc "$ 		purge/nolog subacc.obj"
$		if fsw1.nes."" then -
		wc "$ 		purge/nolog subacc.for"
$		if fsw1.eqs."" then -
		wc "$ 		delete subacc.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
		wc "$ 		purge/nolog subacc.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a160:	   
$!
$ lnkonly:
$       if .not. commands then goto dolnk
$	        wc "$ macro dtediff_commands+lsl$library:lslmaclib/lib "
$	        wc "$ purge/nolog dtediff_commands.obj"
$ dolnk:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		link''linkopts'/exe=''linkver' dtediff, -"
$               wc "		dtediff_commands,dtediff_cld,-"
$		wc "		files,read,write_f,subacc,-"
$		wc "		dtediff.promsg_obj,-"
$	   	wc "		lsl$library:dtilib/lib, -"
$	        wc "            lsl$library:lsldlmslib/lib, -"
$               wc "	        lsl$library:iffshr.opt/opt,-
$               wc "	        lsl$library:lslshr.opt/opt
$!
$ nolnk:
$		wc "$ 		dtediffex:"
$		wc "$ 		deass/group lsl$dtediff_building"
$               wc "$           purge/nolog *.map,*.com
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto dtediffex
$	on control_y then goto dtediffex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$dtediff_building
$	bat dtediffbat.com
$	goto dtediffx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto dtediffex
$	deass/group lsl$dtediff_building
$	@dtediffbat.com
$	goto dtediffx2
$!
$ dtediffex:
$	deass/group lsl$dtediff_building
$!
$ dtediffx2:
$	if ver then set verify
$!
