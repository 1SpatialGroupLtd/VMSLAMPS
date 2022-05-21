$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1999-08-25 13:02:46.000000000 +0100
$! *
$! * This program is free software: you can redistribute it and/or modify
$! * it under the terms of the GNU General Public License as published by
$! * the Free Software Foundation, version 3.
$! *
$! * This program is distributed in the hope that it will be useful, but
$! * WITHOUT ANY WARRANTY; without even the implied warranty of
$! * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
$! * General Public License for more details.
$! *
$! * You should have received a copy of the GNU General Public License
$! * along with this program. If not, see http://www.gnu.org/licenses/.
$!
$!
$	ver=f$verify(0)
$!
$! Command file to build DTMCREATE utility TRIEDIT
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!
$!MOD	Changed logical for build directory for CMS	ST  28-Jul-1993
$!MOD	No longer uses LITES2 specific graphics libraries.
$!							TJH 03-Jan-1989
$!	Created						TJH 12-Jan-1987
$!
$!
$	on error then goto trieditex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$triedit_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto trieditex
$	define/group lsl$triedit_building "in_progress"
$	open/write comfil trieditbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto trieditex"
$	wc "$	if ""'","'f$logical(""lsl$triedit_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$triedit_building ""in_progress"""
$	wc "$	assign lsl$source_root:[dtmcreate.triedit.src] lsl$cmntriedit"
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
$	everything =""
$	mldbg	=""
$	fsw1	=""
$	lis 	=""
$	kpcom	=""
$	triedit_dbg=""
$	macbuild=""
$	mes	=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a11
$	inquire/nop triedit_dbg "With Debug ? "
$	if .not. triedit_dbg then goto a04
$	   fsw1="/debug"
$	   mldbg="/debug"
$	   inquire/nop answer "Without optimisation ? "
$	   if answer then fsw1=fsw1 + "/NOOPT"
$	   inquire/nop answer "Check bounds and overflow ? "
$	   if answer then fsw1=fsw1 + "/CHECK=(BOUNDS,OVERFLOW)"
$	   inquire/nop answer "With listings ? "
$	   if answer then lis = "y"
$	   if answer then fsw1=fsw1 + "/LIST"
$	   inquire/nop answer "Keep FORtran sources with comments ? "
$	   if answer then kpcom="/CO"
$ a04:
$!
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
$	   jfiles="t"
$	   kfiles="t"
$	   lfiles="t"
$	   mfiles="t"
$	   nfiles="t"
$	   ofiles="t"
$	   pfiles="t"
$	   qfiles="t"
$	   rfiles="t"
$	   sfiles="t"
$	   tfiles="t"
$	   ufiles="t"
$	   vfiles="t"
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
$	inq/nop jfiles "j*.src?  "
$	inq/nop kfiles "k*.src?  "
$	inq/nop lfiles "l*.src?  "
$	inq/nop mfiles "m*.src?  "
$	inq/nop nfiles "n*.src?  "
$	inq/nop ofiles "o*.src?  "
$	inq/nop pfiles "p*.src?  "
$	inq/nop qfiles "q*.src?  "
$	inq/nop rfiles "r*.src?  "
$	inq/nop sfiles "s*.src?  "
$	inq/nop tfiles "t*.src?  "
$	inq/nop ufiles "u*.src?  "
$	inq/nop vfiles "v*.src?  "
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
$	   linkver = "triedit"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver=linkver+"x"
$	   linkver = linkver + axps
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!	   
$	   if .not. compile then goto lnkonly
$!
$ notkb:
$		wc "$ 	set noverify"
$	   if .not.everything then goto oldlib
$	        wc "$	library/create  triedit_fortran_sources"
$	   	wc "$	libr = ""library/insert/log  triedit_fortran_sources"""
$	   goto do_mess
$ oldlib:
$	   	wc "$	libr = ""library/replace/log  triedit_fortran_sources"""
$!
$ do_mess:	wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 	set verify"
$ 		if .not.mes then goto cmponly
$		wc "$	newmsg/number=1639/name=triedit/prefix=triedit__/parameter=for/runoff triedit.mes"
$		wc "$ @triedit.temp_com"
$!	
$ cmponly:		
$	mdeb=""
$	if triedit_dbg then mdeb = "/Enable=debug"
$	if .not. macbuild then goto for2
$		wc "$	MACRO''mdeb' triedit_cmdtab"
$	if arch_name.eqs."Alpha" 
$	then 
$		wc "$	MACRO''mdeb' ttemulate"
$	else
$		wc "$	MACRO''mdeb'/obj=ttemulate vax+ttemulate"
$	endif
$		wc "$	MACRO''mdeb' binout"
$		wc "$	MACRO''mdeb' bitmap"
$ for2: if .not. compile then goto lnkonly
$	if afiles then call compiler addpnt
$	if afiles then call compiler alarms
$	if afiles then call compiler assign_cmd
$	if bfiles then call compiler balinit
$	if bfiles then call compiler bar
$	if bfiles then call compiler bell
$	if .not. bfiles then goto try_c
$!
$! Conditional compilation of the exception handler if /DEBUG
$		wc "$	set verify"
$		if f$search(fsw1,"debug").ne.f$length(fsw1) -
						then goto with_deb
$		wc "$ 	adc bridge''kpcom'=triedit_nodebug.tru/tr,bridge.src"
$	        goto fortit
$with_deb:
$		wc "$ 	adc bridge''kpcom'=triedit_debug.tru/tr,bridge.src"
$fortit:	wc "$	fort''fsw1' ''fswa' bridge"
$	      	wc "$ 	ok=$severity.eq.1 .or. $severity.eq.0"	
$		wc "$ 	if ok then pvv bridge"
$		wc "$ 	if ok then libr bridge"
$		wc "$ 	purge/nolog bridge.obj"
$		if fsw1.eqs."" then -
		wc "$ 	delete/nolog bridge.for;*"
$		if fsw1.nes.""  then -
		wc "$ 	purge/nolog bridge.for"
$		if lis then -
		wc "$ 	if ok then delete/nolog bridge.lis;*"
$		wc "$	if .not.ok then emsg=emsg+"" BRIDGE"""
$		wc "$ 	delete adc.ide;*"
$		wc "$	set noverify"
$try_c:
$	if cfiles then call compiler change_cmd
$	if cfiles then call compiler check_gin
$	if cfiles then call compiler circum
$	if cfiles then call compiler clip
$	if cfiles then call compiler cliffpt
$	if cfiles then call compiler compar
$	if cfiles then call compiler concat
$	if cfiles then call compiler config
$	if cfiles then call compiler conpos
$	if cfiles then call compiler contour_cmd
$	if cfiles then call compiler contur
$	if cfiles then call compiler conver
$	if cfiles then call compiler copy_string
$	if cfiles then call compiler cords
$	if cfiles then call compiler ctintg
$	if cfiles then call compiler ctreal
$	if cfiles then call compiler ctrlcast
$	if dfiles then call compiler delcon
$	if dfiles then call compiler datain
$	if dfiles then call compiler datum_cmd
$	if afiles then call compiler deassign_cmd
$	if dfiles then call compiler dcupdate_cmd
$	if dfiles then call compiler delete_cmd
$	if dfiles then call compiler delpnt
$	if dfiles then call compiler deltra
$	if dfiles then call compiler deselect_cmd
$	if dfiles then call compiler digtab
$	if dfiles then call compiler displbtmp
$	if dfiles then call compiler disable_cmd
$	if dfiles then call compiler dlupdate_cmd
$	if dfiles then call compiler dm4pt2
$	if dfiles then call compiler dnupdate_cmd
$	if dfiles then call compiler dpoint
$	if dfiles then call compiler drwlnk
$	if dfiles then call compiler draw_cmd
$	if dfiles then call compiler dtmjpi
$	if dfiles then call compiler dtupdate_cmd
$	if dfiles then call compiler dump_cmd
$	if efiles then call compiler endit
$	if efiles then call compiler enable_cmd
$	if efiles then call compiler ena_hardware
$	if efiles then call compiler entbox
$	if efiles then call compiler euclid
$	if efiles then call compiler exit_cmd
$	if efiles then call compiler exthan
$	if .not. ffiles then goto try_g
$		wc "$ 	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc figs''kpcom'=figs"
$	   	wc "$	fort''fsw1' ''fswa' figs"
$	      	wc "$ 	ok=$severity.eq.1 .or. $severity.eq.0"	
$		wc "$ 	if ok then pvv figs"
$		wc "$ 	purge/nolog figs.obj"
$		if fsw1.eqs."" then -
		wc "$ 	delete/nolog figs.for;*"
$		if fsw1.nes.""  then -
		wc "$ 	purge/nolog figs.for"
$		if lis then -
		wc "$ 	if ok then delete/nolog figs.lis;*"
$		wc "$	if .not.ok then emsg=emsg+"" FIGS"""
$		wc "$ 	delete adc.ide;*"
$		wc "$	set noverify"
$	if ffiles then call compiler facet
$	if ffiles then call compiler facet_cmd
$	if ffiles then call compiler feature_checks
$	if ffiles then call compiler feature_type
$	if ffiles then call compiler filein_cmd
$	if ffiles then call compiler figplt
$	if ffiles then call compiler frame
$try_g:
$	if gfiles then call compiler garbag
$	if gfiles then call compiler geniff
$	if gfiles then call compiler getfrt_cmd
$	if gfiles then call compiler get_fc
$	if gfiles then call compiler get_layer
$	if gfiles then call compiler getnay
$	if gfiles then call compiler gettry
$	if gfiles then call compiler ginput
$	if gfiles then call compiler gintol
$	if gfiles then call compiler grafof
$	if gfiles then call compiler grafon
$	if gfiles then call compiler gtfrth
$	if gfiles then call compiler gtstrg
$	if gfiles then call compiler gtword
$	if hfiles then call compiler hadctrlc
$	if hfiles then call compiler height_cmd
$	if hfiles then call compiler helfor
$	if hfiles then call compiler help_cmd
$	if hfiles then call compiler helpag
$	if ifiles then call compiler iand
$	if ifiles then call compiler icinwft
$	if ifiles then call compiler icistor
$	if ifiles then call compiler icode
$	if ifiles then call compiler ifadpt
$	if ifiles then call compiler ifclos
$	if ifiles then call compiler iffbdy
$	if ifiles then call compiler ifinit
$	if ifiles then call compiler iff_cmd
$	if ifiles then call compiler iff_value
$	if ifiles then call compiler iff_windup
$	if ifiles then call compiler iflush
$	if ifiles then call compiler ifnwft
$	if ifiles then call compiler inidig
$	if ifiles then call compiler injoin
$	if ifiles then call compiler insrtp
$	if ifiles then call compiler insert_cmd
$	if ifiles then call compiler insert_string
$	if ifiles then call compiler instst
$	if ifiles then call compiler intact
$!	if ifiles then call compiler intact     !why was this done again??
$	if ifiles then call compiler intonl
$	if ifiles then call compiler intryg
$	if ifiles then call compiler intsec
$	if ifiles then call compiler invalu
$	if ifiles then call compiler inword
$	if .not. jfiles then goto try_k
$		wc "$ 	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc JOSEPH''kpcom'=JOSEPH"
$	   	wc "$	fort''fsw1' ''fswa' JOSEPH"
$	      	wc "$ 	ok=$severity.eq.1 .or. $severity.eq.0"	
$		wc "$ 	if ok then pvv JOSEPH"
$		wc "$ 	purge/nolog JOSEPH.obj"
$		if fsw1.eqs."" then -
		wc "$ 	delete/nolog JOSEPH.for;*"
$		if fsw1.nes.""  then -
		wc "$ 	purge/nolog JOSEPH.for"
$		if lis then -
		wc "$ 	if ok then delete/nolog JOSEPH.lis;*"
$		wc "$	if .not.ok then emsg=emsg+"" JOSEPH"""
$		wc "$ 	delete adc.ide;*"
$		wc "$	set noverify"
$ try_k:
$	if kfiles then call compiler kbell
$	if kfiles then call compiler kclear
$	if kfiles then call compiler kistr
$	if kfiles then call compiler kqtxex
$	if kfiles then call compiler kschht
$	if kfiles then call compiler kspen
$	if kfiles then call compiler kspenr
$	if kfiles then call compiler ktext
$	if lfiles then call compiler label_cmd
$	if lfiles then call compiler lacclp
$	if lfiles then call compiler lacwin
$	if lfiles then call compiler lefval
$	if lfiles then call compiler length
$	if lfiles then call compiler limit
$	if lfiles then call compiler lineqn
$	if mfiles then call compiler modifp
$	if mfiles then call compiler mousein
$	if nfiles then call compiler naycon
$	if nfiles then call compiler nearly
$	if nfiles then call compiler newfil
$	if nfiles then call compiler newobj
$	if nfiles then call compiler note
$	if ofiles then call compiler onedge
$	if ofiles then call compiler onvrtx
$	if ofiles then call compiler optsea
$	if ofiles then call compiler otplstrg
$	if ofiles then call compiler outbuf
$	if ofiles then call compiler outopt
$	if ofiles then call compiler outtxt
$	if pfiles then call compiler panerret
$	if pfiles then call compiler pdispl
$	if pfiles then call compiler perpen
$	if pfiles then call compiler picsqu
$	if pfiles then call compiler plotq
$	if pfiles then call compiler plsymb
$	if pfiles then call compiler pltryc
$	if pfiles then call compiler points
$	if pfiles then call compiler poscon
$	if pfiles then call compiler position_cmd
$	if pfiles then call compiler post
$	if pfiles then call compiler postvl
$	if pfiles then call compiler prompt
$	if pfiles then call compiler ptinp
$	if pfiles then call compiler ptrecn
$	if pfiles then call compiler putnay
$	if qfiles then call compiler query
$	if rfiles then call compiler rdcpfl
$	if rfiles then call compiler rd_fc_asn
$	if rfiles then call compiler rd_ly_asn
$	if rfiles then call compiler rdlay
$	if rfiles then call compiler rdsel
$	if rfiles then call compiler reconn
$	if rfiles then call compiler rednod
$	if rfiles then call compiler remnod
$	if rfiles then call compiler rhsinp
$	if rfiles then call compiler ripple
$	if rfiles then call compiler ritval
$	if rfiles then call compiler rplwnd
$	if sfiles then call compiler scnclr
$	if sfiles then call compiler select_cmd
$	if sfiles then call compiler set_cmd
$	if sfiles then call compiler setup
$	if sfiles then call compiler setwindow
$	if sfiles then call compiler show_cmd
$	if sfiles then call compiler show_window
$	if sfiles then call compiler sigpad
$	if sfiles then call compiler spawn_cmd
$	if sfiles then call compiler start
$	if sfiles then call compiler swap
$	if .not. tfiles then goto try_u
$		wc "$ 	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc triedit''kpcom'=triedit"
$		wc "$	fort''fsw1' ''fswa' triedit"
$	      	wc "$ 	ok=$severity.eq.1 .or. $severity.eq.0"	
$		wc "$ 	if ok then pvv triedit"
$		wc "$ 	purge/nolog triedit.obj"
$		if fsw1.eqs."" then -
		wc "$ 	delete/nolog triedit.for;*"
$		if fsw1.nes.""  then -
		wc "$ 	purge/nolog triedit.for"
$		if lis then -
		wc "$ 	if ok then delete/nolog triedit.lis;*"
$		wc "$	if .not.ok then emsg=emsg+"" TRIEDIT"""
$		wc "$ 	delete adc.ide;*"
$		wc "$	set noverify"
$	if tfiles then call compiler tek4xxx
$	if tfiles then call compiler texpos
$	if tfiles then call compiler textin
$	if tfiles then call compiler textot
$	if tfiles then call compiler triclp
$	if tfiles then call compiler trac_cmd
$	if tfiles then call compiler trkbal
$ try_u:
$	if ufiles then call compiler update
$	if ufiles then call compiler units_cmd
$	if ufiles then call compiler uwait
$	if vfiles then call compiler value
$	if vfiles then call compiler vt100
$	if wfiles then call compiler wait_cmd
$	if wfiles then call compiler wind
$	if wfiles then call compiler window
$	if wfiles then call compiler window_cmd
$	if wfiles then call compiler windup
$	if wfiles then call compiler wrtnod
$	if xfiles then call compiler xhair
$	if zfiles then call compiler zoom_cmd
$	if zfiles then call compiler zoomar
$	if zfiles then call compiler zoomln
$	if zfiles then call compiler ztrash
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
$		if fsw1.eqs."" then -
		wc "$ 	delete/nolog ''p1'.for;*"
$		if fsw1.nes.""  then -
		wc "$ 	purge/nolog ''p1'.for"
$		wc "$ 	if ok then libr ''p1'"
$		wc "$ 	delete/nolog ''p1'.obj;*"
$		if lis then -
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
$	wc "$ 	run lsl$exe:genver"+tvs
$		wc "$ 	set noverify"
$		wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$	set verify"
$		wc "$ 	adc version''kpcom'=version"
$	   	wc "$	fort''fsw1' ''fswa' version"
$	      	wc "$ 	ok=$severity.eq.1 .or. $severity.eq.0"	
$		wc "$ 	if ok then pvv version"
$		wc "$ 	purge/nolog version.obj"
$		if fsw1.eqs."" then -
		wc "$ 	delete/nolog version.for;*"
$		if fsw1.nes.""  then -
		wc "$ 	purge/nolog version.for"
$		if lis then -
		wc "$ 	if ok then delete/nolog version.lis;*"
$		wc "$	if .not.ok then emsg=emsg+"" version"""
$		wc "$ 	delete adc.ide;*"
$		wc "$	set noverify"
$		wc "$ 	purge/nolog version.src"
$		wc "$   set verify"
$!
$! don't move these DEFINE/USERs away from LINK
$		wc "$   define/user lsl$dtm_gksshr lsl$exe:dtm_gksnullshr''tvs'"
$		wc "$	define/user lsl$iffshr_tv lsl$library:iffshr_dummy_axp"
$		wc "$	define/user lsl$lslshr_tv lsl$library:lslshr_dummy_axp"
$		wc "$	define/user lsl$frtshr_tv lsl$library:frtshr_dummy_axp"
$		wc "$	define/user lsl$dtishr_tv lsl$library:dtishr_dummy_axp"
$		wc "$ 	link''linkopts'/exe=''linkver' triedit''axps'/opt,-"
$		wc "		lsl$library:iffshr''tvs'/opt,-"
$		wc "		lsl$library:lslshr''tvs'/opt,-"
$		wc "		lsl$library:frtshr''tvs'/opt,-"
$		wc "		lsl$library:dtishr''tvs'/opt"
$ nolnk:
$		wc "$ 	nolnk:"
$		wc "$ 	trieditex:"
$		wc "$ 	deass/group lsl$triedit_building"
$		wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto trieditex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$triedit_building
$	bat trieditbat.com
$	goto trieditx2
$!
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto trieditex
$	deass/group lsl$triedit_building
$	@trieditbat.com
$	goto trieditx2
$!
$ trieditex:
$	deass/group lsl$triedit_building
$!
$ trieditx2:
$!!!	if ver then set verify
$!
