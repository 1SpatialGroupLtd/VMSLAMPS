$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-11-15 15:57:28.000000000 +0000
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
$! Command file to build IMP utility IFIXAREA
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!MOD	New routine, GET_LOGICAL, added. Mod 1317.	ST  15-Nov-1993
$!MOD	Build directory changed for CMS			ST  27-Jul-1993
$!MOD	Get rid of test LSLLIB stuff			CCB  4-Jan-1988
$!MOD   Now uses LSLLIB/IFFLIB shareable libraries     MWSR    Nov-1987
$!MOD	Newmessage F(ortran) option added		ATT 14-Jan-1987
$!MOD	test LSLLIB question.				ATT 10-Nov-1986
$!MOD	test LSLLIB used.				ATT 03-Nov-1986
$!MOD	Renamed to IFIXAREA, no longer renames general
$!	message object module				TJH 29-Oct-1986
$!MOD	Now optionally renames general message object
$!	to LSL$GENMSG					TJH 02-Sep-1986
$!	Created						ATT 19-Aug-1986
$!
$	ver=f$verify(0)
$!
$	on error then goto ifixex
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$ifix_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto ifixex
$	define/group lsl$ifix_building "in_progress"
$	open/write comfil ifixbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto ifixex"
$	wc "$	if ""'","'f$logical(""lsl$ifix_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:	define/group lsl$ifix_building ""in_progress"""
$	wc "$	assign lsl$source_root:[imp.ifixarea.src] lsl$cmnifixarea"
$	wc "$	sd:=$lsl$sys:sd"
$	wc "$	set noon"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop ifix_dbg "With Debug ? "
$	if .not. ifix_dbg then goto a04
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
$	   inq/nop cmd "Build Command tables (dfdcmd)"
$!
$	   inq/nop cld "Compile CLD module ? "
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all FORTRAN sources ? "
$	   if .not. everything then goto a05
$	   ifix="t"
$	   getcmd="t"
$	   getfil="t"
$	   get_logical="t"
$	   chkqual="t"
$	   fixit="t"
$	   clofil="t"
$	   fixinfo="t"
$	   goto a11
$!
$ a05:	   
$ 	   inq/nop ifix		"Compile IFIXAREA ?"
$ 	   inq/nop getcmd 	"Compile GETCMD ?"
$ 	   inq/nop getfil	"Compile GETFIL ?"
$ 	   inq/nop get_logical	"Compile GET_LOGICAL ?"
$	   inq/nop chkqual	"Compile CHKQUAL ?"
$	   inq/nop fixit	"Compile FIXIT etc. ?"
$	   inq/nop clofil	"Compile CLOFIL ?"
$	   inq/nop fixinfo	"Compile FIXINFO ?"
$	   write sys$output " "
$ a11:
$	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkver="ifixarea"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="ifixareax"
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!	   
$ notkb:
$!
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		set verify"
$ 		if .not.mes then goto nomess
$		wc "$		newmsg ifix.mes/number=1206/name=ifix/prefix=ifix__/param=(fortran)"
$		wc "$		@ifix.temp_com"
$		wc "$		delete *.genmsg;*"
$		wc "$		delete ifixmsg.mar;*"
$ nomess:	   if .not. cld then goto perhaps_cmd
$		wc "$ 		adc ifix.tmp=ifix_cld.cld"
$		wc "$ 		set command/object=ifix_cld ifix.TMP"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv ifix_cld"
$	      	wc "$ 		ok=$status"	
$ perhaps_cmd:
$	   if .not. cmd then goto fortonly
$		wc "$	   	macro dfdcmd"
$		wc "$! "
$!	
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. ifix then goto a110
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc ifixarea''kpcom'=ifixarea"
$	   	wc "$ 		fort''fsw1' ifixarea"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv ifixarea"
$		wc "$ 		purge/nolog ifixarea.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog ifixarea.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog ifixarea.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog ifixarea.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a110:	   if .not. getcmd then goto a120
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc getcmd''kpcom'=getcmd"
$	   	wc "$ 		fort''fsw1' getcmd"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv getcmd"
$		wc "$ 		purge/nolog getcmd.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog getcmd.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog getcmd.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog getcmd.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a120:	   
$ 	   if .not. getfil then goto a130
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc getfil''kpcom'=getfil"
$	   	wc "$ 		fort''fsw1' getfil"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv getfil"
$		wc "$ 		purge/nolog getfil.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog getfil.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog getfil.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog getfil.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a130:
$ 	   if .not. get_logical then goto a135
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc get_logical''kpcom'=get_logical"
$	   	wc "$ 		fort''fsw1' get_logical"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv get_logical"
$		wc "$ 		purge/nolog get_logical.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog get_logical.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog get_logical.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog get_logical.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a135:
$ 	   if .not. chkqual then goto a140
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc chkqual ''kpcom'=chkqual "
$	   	wc "$ 		fort''fsw1' chkqual "
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv chkqual "
$		wc "$ 		purge/nolog chkqual.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog chkqual.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog chkqual.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog chkqual.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a140:
$ 	   if .not. clofil then goto a150
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc clofil  ''kpcom'=clofil  "
$	   	wc "$ 		fort''fsw1' clofil  "
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv clofil  "
$		wc "$ 		purge/nolog clofil.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog clofil.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog clofil.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog clofil.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a150:	   
$!
$ 	   if .not. fixit then goto a160
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc fixit''kpcom'=fixit,rev,clmin,clock"
$	   	wc "$ 		fort''fsw1' fixit   "
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv fixit   "
$		wc "$ 		purge/nolog fixit.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog fixit.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog fixit.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog fixit.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a160:
$ 	   if .not. fixinfo then goto lnkonly
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc fixinfo''kpcom'=fixinfo"
$	   	wc "$ 		fort''fsw1' fixinfo   "
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv fixinfo   "
$		wc "$ 		purge/nolog fixinfo.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog fixinfo.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog fixinfo.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog fixinfo.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 	link''linkopts'/exe=''linkver' ifixarea, -"
$	   	wc "	ifix_cld, getcmd, getfil, get_logical, chkqual, -"
$	   	wc "	clofil , fixit, dfdcmd, fixinfo, -'
$		wc "	ifix.promsg_obj, -"
$	        WC "    LSL$LIBRARY:IFFSHR/OPT,-"
$	        WC "    LSL$LIBRARY:LSLSHR/OPT"
$!
$ nolnk:
$		wc "$ 		ifixex:"
$		wc "$ 		deass/group lsl$ifix_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto ifixex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$ifix_building
$	bat ifixbat.com
$	goto ifixx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto ifixex
$	deass/group lsl$ifix_building
$	@ifixbat.com
$	goto ifixx2
$ ifixex:
$	deass/group lsl$ifix_building
$ ifixx2:
$	if ver then set verify
