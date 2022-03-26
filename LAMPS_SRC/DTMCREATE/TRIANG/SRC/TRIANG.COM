
$!
$! Command file to build DTMCREATE utility TRIANG
$!
$! Copyright Laser-Scan Limited, Cambridge, England.
$!
$!	Created						TJH 12-Jan-1987
$!mod	No longer uses LITES2 specific graphics libraries.
$!	Now uses LSLSHR					TJH 03-Jan-1989
$!
$!mod1431 Use new FRTSHR				 JB 21-Nov-1994
$!
$	ver=f$verify(0)
$!
$	on error then goto triangex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$triang_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto triangex
$	define/group lsl$triang_building "in_progress"
$	open/write comfil triangbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto triangex"
$	wc "$	if ""'","'f$logical(""lsl$triang_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$triang_building ""in_progress"""
$	wc "$	assign lsl$source_root:[dtmcreate.triang.src] lsl$cmntriang"
$	wc "$	assign lsl$source_root:[dtmcreate.service.src] lsl$dtmcreatesys"
$	wc "$	sd:=$lsl$sys:sd"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$! check for AXP version
$!
$	arch_name=f$getsyi("ARCH_NAME")
$	if arch_name.eqs."Alpha" 
$	then 
$	   tvs="_tv"
$	   axps="_axp"
$	   fswa="/extend/tie/float=d"
$	else
$	   tvs=""
$	   axps=""
$	   fswa=""
$	endif
$!
$	everything=""
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	triang_dbg=""
$	macbuild=""
$	mes=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop triang_dbg "With Debug ? "
$	if .not. triang_dbg then goto a04
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
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all sources ? "
$	   if .not. everything then goto a05
$	   afiles="t"
$	   bfiles="t"
$	   cfiles="t"
$	   dfiles="t"
$	   efiles="t"
$	   ffiles="t"
$	   gfiles="t"
$	   hfiles="t"
$	   ifiles="t"
$	   lfiles="t"
$	   mfiles="t"
$	   nfiles="t"
$	   ofiles="t"
$	   pfiles="t"
$	   rfiles="t"
$	   sfiles="t"
$	   tfiles="t"
$	   ufiles="t"
$	   wfiles="t"
$	   xfiles="t"
$	   zfiles="t"
$!
$!
$	   macbuild="t"
$	   goto a11
$!
$ a05:	   
$	ws " "
$	ws ".............................MACRO32 stuff"
$	   inq/nop macbuild	"Compile command table? "
$	ws " " 
	ws ".............................FORTRAN sources"
$	inq/nop afiles "a*.src?  "
$	inq/nop bfiles "b*.src?  "
$	inq/nop cfiles "c*.src?  "
$	inq/nop dfiles "d*.src?  "
$	inq/nop efiles "e*.src?  "
$	inq/nop ffiles "f*.src?  "
$	inq/nop gfiles "g*.src?  "
$	inq/nop hfiles "h*.src?  "
$	inq/nop ifiles "i*.src?  "
$	inq/nop lfiles "l*.src?  "
$	inq/nop mfiles "m*.src?  "
$	inq/nop nfiles "n*.src?  "
$	inq/nop ofiles "o*.src?  "
$	inq/nop pfiles "p*.src?  "
$	inq/nop rfiles "r*.src?  "
$	inq/nop sfiles "s*.src?  "
$	inq/nop tfiles "t*.src?  "
$	inq/nop ufiles "u*.src?  "
$	inq/nop wfiles "w*.src?  "
$	inq/nop xfiles "x*.src?  "
$	inq/nop zfiles "z*.src?  "
$!
$ a11:
$	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map/full"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   if arch_name.eqs."Alpha" 
$	   then 
$	      linkopts=linkopts + "/nonative_only"
$	   endif
$!
$	   linkver = "triang"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver=linkver+"x"
$	   linkver = linkver + axps
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!
$ notkb:
$		wc "$ 	set noverify"
$!
$	   if .not.everything then goto oldlib
$	        wc "$	library/create  triang_fortran_sources"
$	   	wc "$	libr = ""library/insert/log  triang_fortran_sources"""
$	   goto do_mess
$ oldlib:
$	   	wc "$	libr = ""library/replace/log  triang_fortran_sources"""
$!
$ do_mess:	wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 	set verify"
$ 		if .not.mes then goto cmponly
$		wc "$	newmsg/dti/number=1636/name=triang/prefix=triang__/parameter=for/runoff triang.mes"
$		wc "$ @triang.temp_com"
$!	
$ cmponly:		
$	   if .not. compile then goto lnkonly
$	mdeb=""
$	if triang_dbg then mdeb = "/Enable=debug"
$	if .not. macbuild then goto for2
$		wc "$	MACRO''mdeb' TRIANG_CMDTAB"
$ for2: if .not. compile then goto lnkonly
$	if afiles then call compiler addlft
$	if afiles then call compiler addrgt
$	if afiles then call compiler angle
$	if afiles then call compiler assign_cmd
$	if bfiles then call compiler bitmatch
$	if cfiles then call compiler cannon
$	if cfiles then call compiler chkpat
$	if cfiles then call compiler clifln
$	if cfiles then call compiler collec
$	if cfiles then call compiler cp_check
$	if cfiles then call compiler cross
$	if dfiles then call compiler datum_cmd
$	if dfiles then call compiler deassign_cmd
$	if dfiles then call compiler define_frame
$	if dfiles then call compiler delcon
$	if dfiles then call compiler deselect_cmd
$	if dfiles then call compiler disable_cmd
$	if dfiles then call compiler displbtmp
$	if dfiles then call compiler distan
$	if dfiles then call compiler dtibdy
$	if dfiles then call compiler dti_limits
$	if dfiles then call compiler dufnod
$	if efiles then call compiler enable_cmd
$	if efiles then call compiler end_input
$	if efiles then call compiler entpos
$	if efiles then call compiler euclid
$	if ffiles then call compiler feature_checks
$	if ffiles then call compiler feature_type
$	if ffiles then call compiler filclo
$	if ffiles then call compiler filein_cmd
$	if ffiles then call compiler fileout_cmd
$	if ffiles then call compiler fillit
$	if ffiles then call compiler finnod
$	if ffiles then call compiler finpos
$	if ffiles then call compiler finrgt
$	if ffiles then call compiler fixclf
$	if ffiles then call compiler format_cmd
$	if ffiles then call compiler framed_mes
$	if gfiles then call compiler getfrt_cmd
$	if gfiles then call compiler getnay
$	if gfiles then call compiler gtfrth
$	if gfiles then call compiler gtlink
$	if hfiles then call compiler help_cmd
$	if ifiles then call compiler iffbdy
$	if ifiles then call compiler initialise
$	if ifiles then call compiler injoin
$	if ifiles then call compiler insert_string
$	if ifiles then call compiler instst
$	if ifiles then call compiler intonl
$	if ifiles then call compiler intsec
$	if ifiles then call compiler inword
$	if lfiles then call compiler limit
$	if lfiles then call compiler lineqn
$	if lfiles then call compiler lnknod
$	if mfiles then call compiler masser
$	if mfiles then call compiler maxpoints_cmd
$	if mfiles then call compiler muckup
$!	if mfiles then call compiler myprint   !debug only
$	if nfiles then call compiler nearly
$	if nfiles then call compiler nodecoords
$	if ofiles then call compiler opndti
$	if ofiles then call compiler otplstrg
$	if ofiles then call compiler onedge
$	if ofiles then call compiler onvrtx
$	if pfiles then call compiler patchp
$	if pfiles then call compiler pchoos
$	if pfiles then call compiler perpen
$	if pfiles then call compiler picsqu
$	if pfiles then call compiler ptinp
$	if pfiles then call compiler ptrecn
$	if pfiles then call compiler putnay
$	if rfiles then call compiler rd_fc_asn
$	if rfiles then call compiler rd_ly_asn
$	if rfiles then call compiler rdlay
$	if rfiles then call compiler rdsel
$	if rfiles then call compiler readin
$	if rfiles then call compiler reassm
$	if rfiles then call compiler reconn
$	if rfiles then call compiler rednod
$	if rfiles then call compiler rejoin
$	if rfiles then call compiler remnod
$	if rfiles then call compiler reslin
$	if sfiles then call compiler search
$	if sfiles then call compiler select_cmd
$	if sfiles then call compiler setup
$	if sfiles then call compiler show_cmd
$	if sfiles then call compiler show_window
$	if sfiles then call compiler stack
$	if tfiles then call compiler trans
$	if .not.tfiles then goto wfi
$		wc "$ 	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc triang''kpcom'=triang"
$	   	wc "$	fort''fsw1' ''fswa' triang"
$	      	wc "$ 	ok=$severity.eq.1 .or. $severity.eq.0"	
$		wc "$ 	if ok then pvv triang"
$		wc "$ 	purge/nolog triang.obj"
$		if fsw1.eqs."" then -
		wc "$ 	delete/nolog triang.for;*"
$		if fsw1.nes.""  then -
		wc "$ 	purge/nolog triang.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
		wc "$ 	if ok then delete/nolog triang.lis;*"
$		wc "$	if .not.ok then emsg=emsg+"" triang"""
$		wc "$ 	delete adc.ide;*"
$		wc "$	set noverify"
$ wfi:
$	if ufiles then call compiler units_cmd
$	if wfiles then call compiler window_cmd
$	if wfiles then call compiler windup
$	if wfiles then call compiler wrtnod
$	if wfiles then call compiler write_nodes
$	if zfiles then call compiler zlimits_cmd
$	if zfiles then call compiler zone
$	   goto lnkonly
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ compiler: subroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$		wc "$ 	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc ''p1'''kpcom'=''p1'"
$	   	wc "$	fort''fsw1' ''fswa' ''p1'"
$	      	wc "$ 	ok=$severity.eq.1 .or. $severity.eq.0"	
$		wc "$ 	if ok then pvv ''p1'"
$		wc "$ 	purge/nolog ''p1'.obj"
$		if fsw1.eqs."" then -
		wc "$ 	delete/nolog ''p1'.for;*"
$		if fsw1.nes.""  then -
		wc "$ 	purge/nolog ''p1'.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
		wc "$ 	if ok then delete/nolog ''p1'.lis;*"
$		wc "$ 	if ok then libr ''p1'"
$		wc "$ 	delete/nolog ''p1'.obj;*"
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
$	wc "$ 	run lsl$exe:genver"+tvs
$	wc "$ 	adc version''kpcom'=version"
$   	wc "$	fort''fsw1' ''fswa' version"
$	wc "$ 	ok=$severity.eq.1 .or. $severity.eq.0"	
$	wc "$ 	if ok then pvv version"
$	wc "$ 	purge/nolog version.obj"
$	if fsw1.eqs."" then -
		wc "$ 	delete/nolog version.for;*"
$	if fsw1.nes.""  then -
		wc "$ 	purge/nolog version.for"
$	if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
	wc "$ 	if ok then delete/nolog version.lis;*"
$	wc "$	if .not.ok then emsg=emsg+"" version"""
$	wc "$ 	delete adc.ide;*"
$	wc "$ 	purge/nolog version.src"
$	wc "$   set verify"
$!
$! don't move these DEFINE/USERs away from LINK
$	wc "$   define/user lsl$dtm_gksshr lsl$exe:dtm_gksnullshr''tvs'"
$	wc "$	define/user lsl$iffshr_tv lsl$library:iffshr_dummy_axp"
$	wc "$	define/user lsl$lslshr_tv lsl$library:lslshr_dummy_axp"
$	wc "$	define/user lsl$frtshr_tv lsl$library:frtshr_dummy_axp"
$	wc "$	define/user lsl$dtishr_tv lsl$library:dtishr_dummy_axp"
$	wc "$   link''linkopts'/exe=''linkver' triang''axps'/opt,-"
$	wc "		lsl$library:iffshr''tvs'/opt,-"
$	wc "		lsl$library:lslshr''tvs'/opt,-"
$	wc "		lsl$library:frtshr''tvs'/opt,-"
$	wc "		lsl$library:dtishr''tvs'/opt"
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	triangex:"
$		wc "$ 	deass/group lsl$triang_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto triangex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$triang_building
$	bat triangbat.com
$	goto triangx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto triangex
$	deass/group lsl$triang_building
$	@triangbat.com
$	goto triangx2
$!
$ triangex:
$	deass/group lsl$triang_building
$!
$ triangx2:
$	if ver then set verify
$!
