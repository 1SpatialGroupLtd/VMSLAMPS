$!
$	ver=f$verify(0)
$!
$! Copyright Laser-Scan Limited, Cambridge, England.
$! Build file for I2TDST
$!
$! Mod 1435 New frtshr				JB 28-Nov-1994
$!
$! Command file for building I2TDST
$!
$	on error then goto i2tdstex
$	on control_y then exit
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$i2tdst_building")'" .nes. "in_progress" -
	   then goto a0
$	WRITE SYS$OUTPUT "Someone else is building"
$	exit
$a0:	on control_y then goto i2tdstex
$	define/group lsl$i2tdst_building "in_progress"
$	open/write comfil i2tdstbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto i2tdstex"
$	wc	"$	if ""'","'f$logical(""lsl$i2tdst_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	WC	"$	WRITE SYS$OUTPUT ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$a0:	define/group lsl$i2tdst_building ""in_progress"""
$	wc	"$	sd:=$lsl$sys:sd"
$	wc	"$	set noon"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	INQUIRE/NOP COMPILE "Compile ? "
$	if .not.compile then goto a04
$	INQUIRE/NOP I2TDST_DBG "With Debug ? "
$	if .not. i2tdst_dbg then goto a04
$	   fsw1="/debug"
$	   mldbg="/debug"
$	   INQUIRE/NOP ANSWER "Without optimisation ? "
$	   if answer then fsw1=fsw1 + "/noopt"
$	   INQUIRE/NOP ANSWER "Check bounds and overflow ? "
$	   if answer then fsw1=fsw1 + "/check=(bounds,overflow)"
$	   INQUIRE/NOP ANSWER "With listings ? "
$	   if answer then fsw1=fsw1 + "/list"
$	   INQUIRE/NOP ANSWER "Keep fortran sources with comments ? "
$	   if answer then kpcom="/co"
$ a04:
$	   INQ/NOP CLD "Compile CLD modules ? "
$	   if .not.compile then goto a11
$!
$	   INQ/NOP EVERYTHING "Compile all FORTRAN sources ? "
$	   if .not. everything then goto a05
$	   i2tdst="t"
$	   doconv="t"
$	   crepol="t"
$	   crearc="t"
$	   crepoi="t"
$	   cretex_tx="t"
$	   cretex_ts="t"
$	   gencir="t"
$	   goto a11
$!
$ A05:	   INQ/NOP I2TDST	"Compile I2TDST?	"
$	   INQ/NOP DOCONV	"Compile DOCONV? 	"
$	   INQ/NOP CREARC	"Compile CREARC? 	"
$	   INQ/NOP CREPOL	"Compile CREPOL? 	"
$	   INQ/NOP CREPOI	"Compile CREPOI? 	"
$	   INQ/NOP CRETEX_TX	"Compile CRETEX_TX? 	"
$	   INQ/NOP CRETEX_TS	"Compile CRETEX_TS? 	"
$	   INQ/NOP GENCIR	"Compile GENCIR?	"
$	   write sys$output " "
$ A11:	   INQ/NOP MES "Generate message definitions ? "
$	   INQUIRE/NOP LNKIT "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map"
$	   INQUIRE/NOP ANSWER "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   linkver="i2tdst"
$	   INQUIRE/NOP ANSWER "Experimental version ? "
$	   if answer then linkver="i2tdstx"
$!
$	   INQUIRE/NOP ANSWER "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$	   
$ notkb:
$!
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		set verify"
$ 		if .not. mes then goto nomess
$		wc "$	newmsg/number=1614/prefix=idst__/parameter=fortran/runoff/hl=2 i2tdst.mes"
$		wc "$	purge/nolog i2tdstmsg.rno"
$		wc "$	@i2tdst.temp_com"
$!
$ nomess:	if .not. cld then goto fortonly
$		wc "$ 		adc i2tdst.tmp=i2tdst_cld.cld"
$		wc "$ 		set command/object=i2tdst_cld i2tdst.tmp"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv i2tdst_cld"
$		wc "$ 		if ok then delete i2tdst.tmp;*"
$		wc "$ 		if ok then delete adc.ide;*"
$		wc "$ 		if ok then purge/nolog i2tdst_cld.obj"
$	
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. i2tdst then goto a100
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		adc i2tdst''kpcom'=i2tdst"
$	   	wc "$ 		fort''fsw1' i2tdst"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv i2tdst"
$		wc "$ 		purge/nolog i2tdst.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog i2tdst.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog i2tdst.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a100:	   if .not. crearc then goto a110
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		adc crearc''kpcom'=crearc"
$	   	wc "$ 		fort''fsw1' crearc"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv crearc"
$		wc "$ 		purge/nolog crearc.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog crearc.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog crearc.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a110:	   if .not. doconv then goto a120
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc doconv''kpcom'=doconv"
$	   	wc "$ 		fort''fsw1' doconv"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv doconv"
$		wc "$ 		purge/nolog doconv.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog doconv.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog doconv.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a120:	   if .not. crepoi  then goto a130
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc crepoi''kpcom'=crepoi"
$	   	wc "$ 		fort''fsw1' crepoi"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv crepoi"
$		wc "$ 		purge/nolog crepoi.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog crepoi.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog crepoi.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a130:	   if .not. crepol  then goto a140
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc crepol''kpcom'=crepol"
$	   	wc "$ 		fort''fsw1' crepol"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv crepol"
$		wc "$ 		purge/nolog crepol.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog crepol.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog crepol.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a140:	   if .not. cretex_tx  then goto a145
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc cretex_tx''kpcom'=cretex_tx"
$	   	wc "$ 		fort''fsw1' cretex_tx"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv cretex_tx"
$		wc "$ 		purge/nolog cretex_tx.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog cretex_tx.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog cretex_tx.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a145:	   if .not. cretex_ts  then goto a150
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc cretex_ts''kpcom'=cretex_ts"
$	   	wc "$ 		fort''fsw1' cretex_ts"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv cretex_ts"
$		wc "$ 		purge/nolog cretex_ts.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog cretex_ts.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog cretex_ts.lis"
$		wc "$ 		delete adc.ide;*"
$!
$a150:	   if .not. gencir then goto lnkonly
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		adc gencir''kpcom'=gencir"
$	   	wc "$ 		fort''fsw1' gencir"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv gencir"
$		wc "$ 		purge/nolog gencir.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog gencir.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog gencir.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		link''linkopts'/exe=''linkver' i2tdst,-"
$	   	wc "		i2tdst_cld, doconv, crepoi, crepol,-"
$		wc "		cretex_tx,cretex_ts,crearc,gencir,-"
$		wc "		i2tdst.promsg_obj, -"
$	   	wc "		lsl$library:frtshr/opt, -"
$		wc "		iffshr/opt, lslshr/opt"
$!
$ nolnk:
$		wc "$ 		i2tdstex:"
$		wc "$ 		deass/group lsl$i2tdst_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto i2tdstex
$	close comfil
$	purge i2tdstbat.com
$	ok=$status
$	IF OK THEN INQ/NOP ANSWER_BAT "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$i2tdst_building
$	bat i2tdstbat.com
$	goto i2tdstx2
$ int:	
$	IF OK THEN INQ/NOP ANSWER "Interactive ? "
$	if .not.answer then goto i2tdstex
$	deass/group lsl$i2tdst_building
$	@i2tdstbat.com
$	goto i2tdstx2
$!
$ i2tdstex:
$	deass/group lsl$i2tdst_building
$!
$ i2tdstx2:
$	if ver then set verify
$!
