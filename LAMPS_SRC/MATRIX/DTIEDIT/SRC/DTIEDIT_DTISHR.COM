$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! Copyright Laser-Scan Limited, Cambridge, England.
$! Command file for building DTIEDIT
$! Author  :  D R Catlow 		29 March  1988
$! Mod1264 :  J Barber			11 August 1993
$!	      Use MATRIX service library
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	ver=f$verify(0)
$!
$	assign	lsl$source_root:[matrix.service]   lsl$matrixsys
$!
$	on error then goto dtieditex
$	on control_y then goto dtieditex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$dtiedit_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto dtieditex
$	define/group lsl$dtiedit_building "in_progress"
$	open/write comfil dtieditbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto dtieditex"
$	wc	"$	if ""'","'f$logical(""lsl$dtiedit_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$a0:	define/group lsl$dtiedit_building ""in_progress"""
$	wc	"$	assign lsl$source_root:[imp.dtiedit] lsl$cmndtiedit"
$	wc	"$	sd:=$lsl$sys:sd"
$	wc	"$	set noon"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop dtiedit_dbg "With Debug ? "
$	if .not. dtiedit_dbg then goto a04
$	   fsw1="/debug"
$	   mldbg="/debug"
$	   INQUIRE/NOP ANSWER "Without optimisation ? "
$	   if answer then fsw1=fsw1 + "/noopt"
$	   INQUIRE/NOP ANSWER "Check bounds and overflow ? "
$	   if answer then fsw1=fsw1 + "/check=(bounds,overflow)"
$	   INQUIRE/NOP ANSWER "With listings ? "
$	   if answer then fsw1=fsw1 + "/list"
$	   INQUIRE/NOP ANSWER "Keep FORtran sources with comments ? "
$	   if answer then kpcom="/co"
$ a04:
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all FORTRAN sources ? "
$	   if .not. everything then goto a05
$	   dtiedit="t"
$	   open_dti_file="t"
$	   scredt="t"
$	   printer="t"
$	   help="t"
$	   myscrn="t"
$	   myget="t"
$	   mysqr="t"
$	   putbl="t"
$	   puterr="t"
$	   mycur="t"
$	   autran="t"
$	   edits="t"
$	   dtiedit_commands="t"
$	   goto a11
$!
$ A05:     INQ/NOP DTIEDIT	     "Compile DTIEDIT                                   ?"
$ 	   INQ/NOP OPEN_DTI_FILE     "Compile OPEN_DTI_FILE                             ?"
$	   INQ/NOP EDITS             "Compile EDIT_AREA,EDIT_LINE,EDIT_POINT,SUBSTITUTE ?"
$ 	   INQ/NOP SCREDT            "Compile SCREDT                                    ?"
$	   INQ/NOP PRINTER           "Compile PRINTER                                   ?"
$ 	   INQ/NOP HELP              "Compile HELP                                      ?"
$ 	   INQ/NOP MYSCRN            "Compile MYSCRN                                    ?"
$ 	   INQ/NOP MYGET             "Compile MYGET                                     ?"
$	   INQ/NOP MYSQR             "Compile MYSQR                                     ?"
$	   INQ/NOP PUTBL             "Compile PUTBL                                     ?"
$	   INQ/NOP PUTERR            "Compile PUTERR                                    ?"
$	   INQ/NOP MYCUR             "Compile MYCUR                                     ?"
$	   INQ/NOP AUTRAN            "Compile AUTRAN                                    ?"
$	   INQ/NOP DTIEDIT_COMMANDS  "Compile DTIEDIT_COMMANDS (macro)                  ?"
!
$	   write sys$output " "
$!
$ a11:	   linkver="dtiedit"
$	   INQUIRE/NOP LNKIT "Link ? "
$	   if .not.lnkit then goto notkb
$	   INQUIRE/NOP ANSWER "Experimental version ? "
$	   if answer then linkver="dtieditx"
$!
$	   linkopts="/map"
$	   INQUIRE/NOP ANSWER "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   INQUIRE/NOP ANSWER "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$	   
$ notkb:
$!
$ fortonly:		
$	if .not. compile then goto lnkonly
$!
$ 	   if .not. dtiedit then goto a110
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc dtiedit''kpcom'=dtiedit"
$	   	wc "$ 		fort''fsw1' dtiedit"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dtiedit"
$		wc "$ 		purge/nolog dtiedit.obj"
$		if fsw1.eqs."" then -
			wc "$ 		delete dtiedit.for;*"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog dtiedit.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dtiedit.lis"
$		wc "$ 		delete adc.ide;*"
$!
$a110:
$ 	   if .not. edits then goto a120
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc edits''kpcom'=edit_area,edit_line,edit_point,substitute"
$	   	wc "$ 		fort''fsw1' edits"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv edits"
$		wc "$ 		purge/nolog edits.obj"
$		if fsw1.eqs."" then -
			wc "$ 		delete edits.for;*"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog edits.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog edits.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a120:	   if .not. open_dti_file then goto a130
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc open_dti_file''kpcom'=open_dti_file"
$	   	wc "$ 		fort''fsw1' open_dti_file"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv open_dti_file"
$		wc "$ 		purge/nolog open_dti_file.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog open_dti_file.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete open_dti_file.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog open_dti_file.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a130:	   if .not. scredt then goto a140
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc scredt''kpcom'=scredt"
$	   	wc "$ 		fort''fsw1' scredt"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv scredt"
$		wc "$ 		purge/nolog scredt.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog scredt.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete scredt.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog scredt.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a140:	   if .not. help then goto a150
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc help''kpcom'=help"
$	   	wc "$ 		fort''fsw1' help"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv help"
$		wc "$ 		purge/nolog help.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog help.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete help.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog help.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a150:	   if .not. printer then goto a160
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc printer''kpcom'=printer"
$	   	wc "$ 		fort''fsw1' printer"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv printer"
$		wc "$ 		purge/nolog printer.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog printer.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete printer.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog printer.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a160:	   if .not. myget then goto a170
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc myget''kpcom'=myget"
$	   	wc "$ 		fort''fsw1' myget"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv myget"
$		wc "$ 		purge/nolog myget.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog myget.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete myget.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog myget.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a170:	   if .not. mysqr then goto a180
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc mysqr''kpcom'=mysqr"
$	   	wc "$ 		fort''fsw1' mysqr"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv mysqr"
$		wc "$ 		purge/nolog mysqr.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog mysqr.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete mysqr.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog mysqr.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a180:	   if .not. myscrn then goto a190
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc myscrn''kpcom'=myscrn"
$	   	wc "$ 		fort''fsw1' myscrn"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv myscrn"
$		wc "$ 		purge/nolog myscrn.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog myscrn.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete myscrn.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog myscrn.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a190:	   
$!
$ a200:	   if .not. putbl then goto a210
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc putbl''kpcom'=putbl"
$	   	wc "$ 		fort''fsw1' putbl"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv putbl"
$		wc "$ 		purge/nolog putbl.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog putbl.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete putbl.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog putbl.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a210:	   if .not. puterr then goto a220
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc puterr''kpcom'=puterr"
$	   	wc "$ 		fort''fsw1' puterr"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv puterr"
$		wc "$ 		purge/nolog puterr.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog puterr.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete puterr.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog puterr.lis"
$		wc "$ 		delete adc.ide;*"
$ a220:	   if .not. mycur then goto a230
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc mycur''kpcom'=mycur"
$	   	wc "$ 		fort''fsw1' mycur"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv mycur"
$		wc "$ 		purge/nolog mycur.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog mycur.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete mycur.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog mycur.lis"
$		wc "$ 		delete adc.ide;*"
$ a230:	   if .not. autran then goto a240
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc autran''kpcom'=autran"
$	   	wc "$ 		fort''fsw1' autran"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv autran"
$		wc "$ 		purge/nolog autran.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog autran.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete autran.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 	purge/nolog autran.lis"
$		wc "$ 		delete adc.ide;*"
$ a240:	   if .not. dtiedit_commands then goto a250
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ macro dtiedit_commands+lsl$library:lslmaclib/lib
$		wc "$ purge/nolog dtiedit_commands.obj"
$ a250:
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ run lsl$exe:genver"
$		wc "$ adc version=version"
$		wc "$ fortran version"
$		wc "$ pvv version"
$		wc "$ purge/nolog version.*"
$		wc "$ delete version.for;,adc.ide;"
$!
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		link''linkopts'/exe=''linkver' dtiedit, -"
$		wc "		dtiedit_commands, -"
$	   	wc "		open_dti_file,edits,-"
$		wc "		scredt,help,-"
$	        wc "		printer,myget,-"
$               wc "		mysqr,myscrn,-"
$               wc "		putbl,puterr,-"
$	        wc "		mycur,autran,-"
$		wc "            version,-"
$		wc "		lsl$matrixsys:matrix/lib,-
$	   	wc "		lsl$library:dtishr/opt, -"
$		wc "		lsl$library:lslshr.opt/opt "
$!
$ NOLNK:
$		wc "$ 		dtieditex:"
$		wc "$ 		deass/group lsl$dtiedit_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto dtieditex
$	on control_y then goto dtieditex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$!
$	deass/group lsl$dtiedit_building
$	bat dtieditbat.com
$	goto dtieditx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto dtieditex
$	deass/group lsl$dtiedit_building
$	@dtieditbat.com
$	goto dtieditx2
$ dtieditex:
$	deass/group lsl$dtiedit_building
$ dtieditx2:
$	if ver then set verify
$!
