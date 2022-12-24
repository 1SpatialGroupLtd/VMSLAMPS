$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-11-22 18:00:00.000000000 +0000
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
$! Copyright Laser-Scan Limited, Cambridge, England.
$!
$!	Created					 	TJH 05-Nov-1986
$!MOD	Newmessage F(ortran) option added		ATT 14-Jan-1987
$!MOD	New routines for CB entry and shareable libs   MWSR    Nov-1987
$!MOD1432 Use new frtshr				 JB 22-Nov-1994
$!
$! Command file for building IFROMTEXT
$!
$	on error then goto ifromtextex
$	on control_y then exit
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$ifromtext_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$ a0:	on control_y then goto ifromtextex
$	define/group lsl$ifromtext_building "in_progress"
$	open/write comfil ifromtextbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$	set noverify"
$	wc	"$	on control_y then goto ifromtextex"
$	wc	"$	if ""'","'f$logical(""lsl$ifromtext_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$ a0:	define/group lsl$ifromtext_building ""in_progress"""
$	wc	"$	assign lsl$source_root:[imp.ifromtext.src] lsl$cmnifromtext"
$	wc	"$	sd:=$lsl$sys:sd"
$	wc	"$	set noon"
$	wc	"$	emsg="""""
$!
$	fortdeb =""
$	macdeb  =""
$	fsw1    =""
$	kpcom   =""
$!
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$!
$	inquire/nop ifromtext_dbg "With Debug ? "
$	if .not. ifromtext_dbg then goto a04
$!
$	   fsw1   ="/debug"
$	   fortdeb="/debug"
$	   macdbg ="/enable=dbg"
$!
$	   inquire/nop answer "Without optimisation ? "
$	   if answer then fsw1=fsw1 + "/noopt"
$!
$	   inquire/nop answer "Check bounds and overflow ? "
$	   if answer then fsw1=fsw1 + "/check=(bounds,overflow)"
$!
$	   inquire/nop answer "With listings ? "
$	   if answer then fsw1=fsw1 + "/list"
$!
$	   inquire/nop answer "Keep FORtran sources with comments ? "
$	   if answer then kpcom="/co"
$ a04:
$	   inq/nop cld "Compile CLD modules ? "
$	   if .not.compile then goto a11
$!
$	   inq/nop macbld  "Compile Macro sources ? "
$!
$	   inq/nop everything "Compile all FORTRAN sources ? "
$	   if .not. everything then goto a05
$!
$	   ifromtext = "t"
$	   t2icom = "t"
$	   t2icon = "t"
$	   t2icor = "t"
$	   t2ifea = "t"
$	   t2ifil = "t"
$	   t2iign = "t"
$	   t2iinf = "t"
$	   t2iint = "t"
$	   t2ilin = "t"
$	   t2ilnf = "t"
$	   t2ilon = "t"
$	   t2imap = "t"
$	   t2imdn = "t"
$	   t2imh3 = "t"
$	   t2imht = "t"
$	   t2inxt = "t"
$	   t2iove = "t"
$	   t2irea = "t"
$	   t2idate= "t"
$	   t2itime= "t"
$	   t2ichar= "t"
$	   t2ireal8 = "t"
$	   t2isec = "t"
$	   t2isep = "t"
$	   t2iskp = "t"
$	   t2istr = "t"
$	   t2itst = "t"
$	   t2icb  = "t"
$	   t2iacd  = "t"
$	   t2ilonacd  = "t"
$	   t2icb_output  = "t"
$	   t2icb_missing = "t"
$!
$	   macbld = "t"
$	   goto a11
$!
$ a05:
$	   inq/nop ifromtext 	"Compile IFROMTEXT? "
$	   inq/nop t2iacd    	"Compile T2IACD? "
$	   inq/nop t2ilonacd 	"Compile T2ILONACD? "
$	   inq/nop t2icb  	"Compile T2ICB? "
$	   inq/nop t2icb_missing "Compile T2ICB_MISSING? "
$	   inq/nop t2icb_output  "Compile T2ICB_OUTPUT? "
$	   inq/nop t2ichar 	"Compile T2ICHAR"
$	   inq/nop t2icom 	"Compile T2ICOM? "
$	   inq/nop t2icon 	"Compile T2ICON? "
$	   inq/nop t2icor 	"Compile T2ICOR? "
$	   inq/nop t2idate 	"Compile T2IDATE? "
$	   inq/nop t2ifea 	"Compile T2IFEA? "
$	   inq/nop t2ifil 	"Compile T2IFIL? "
$	   inq/nop t2iign 	"Compile T2IIGN? "
$	   inq/nop t2iinf 	"Compile T2IINF? "
$	   inq/nop t2iint 	"Compile T2IINT? "
$	   inq/nop t2ilin 	"Compile T2ILIN? "
$	   inq/nop t2ilnf 	"Compile T2ILNF? "
$	   inq/nop t2ilon 	"Compile T2ILON? "
$	   inq/nop t2imap 	"Compile T2IMAP? "
$	   inq/nop t2imdn 	"Compile T2IMDN? "
$	   inq/nop t2imh3 	"Compile T2IMH3? "
$	   inq/nop t2imht 	"Compile T2IMHT? "
$	   inq/nop t2inxt 	"Compile T2INXT? "
$	   inq/nop t2iove 	"Compile T2IOVE? "
$	   inq/nop t2irea 	"Compile T2IREA? "
$	   inq/nop t2ireal8 	"Compile T2IREAL8? "
$	   inq/nop t2isec 	"Compile T2ISEC? "
$	   inq/nop t2isep 	"Compile T2ISEP? "
$	   inq/nop t2iskp 	"Compile T2ISKP? "
$	   inq/nop t2istr 	"Compile T2ISTR? "
$	   inq/nop t2itime 	"Compile T2ITIME? "
$	   inq/nop t2itst 	"Compile T2ITST? "
$!
$ a11:	   inq/nop mes "Generate message definitions? "
$!
$	   inquire/nop lnkit "Link? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   linkver="ifromtext"
$	   inquire/nop answer "Experimental version? "
$	   if answer then linkver="ifromtextx"
$!
$	   inquire/nop answer "Cross reference map? "
$	   if answer then linkopts=linkopts+"/cross"
$
$ notkb:
$!
$	wc "$ 	set noverify"
$!
$	wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$ 	set verify"
$	if .not.mes then goto docld
$!
$	wc "$	newmsg/number=1217/name=ifrom/prefix=ifrom__/runoff/hl=2/par=for ifromtext.mes"
$	wc "$	@ifromtext.temp_com"
$	wc "$	rename ifromtextmsg.par ifrommsg.par"
$!
$ docld:   if .not. cld then goto fortonly
$	wc "$ 	adc ifromtext.tmp=ifromtext.cld"
$	wc "$ 	set command/object=ifromtext_cld ifromtext.tmp"
$      	wc "$ 	ok=$status"	
$	wc "$ 	if ok then pvv ifromtext_cld"
$	wc "$ 	if ok then delete ifromtext.tmp;*"
$	wc "$ 	if ok then purge/nolog ifromtext_cld.obj"
$	
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. macbld then goto fort_cmds
$		wc "$	macro'macdbg'/object=t2iecd t2iecd"
$		wc "$	ok=$status"
$		wc "$	pur/nolog t2iecd.obj"
$		wc "$	if .not.ok then emsg=emsg+"" macro-t2iecd"""
$		wc "$	macro'macdbg'/object=t2imcd t2imcd"
$		wc "$	ok=$status"
$		wc "$	pur/nolog t2imcd.obj"
$		wc "$	if .not.ok then emsg=emsg+"" macro-t2imcd"""
$		wc "$	macro'macdbg'/object=t2icbc t2icbc"
$		wc "$	ok=$status"
$		wc "$	pur/nolog t2icbc.obj"
$		wc "$	if .not.ok then emsg=emsg+"" macro-t2icbc"""
$!
$ fort_cmds:
$	   if ifromtext then call compiler  ifromtext
$	   if t2icom 	then call compiler  t2icom 
$	   if t2icon 	then call compiler  t2icon
$	   if t2icor 	then call compiler  t2icor 
$	   if t2ifea 	then call compiler  t2ifea 
$	   if t2ifil 	then call compiler  t2ifil 
$	   if t2iign 	then call compiler  t2iign 
$	   if t2iinf 	then call compiler  t2iinf 
$	   if t2iint 	then call compiler  t2iint 
$	   if t2ilin 	then call compiler  t2ilin 
$	   if t2ilnf 	then call compiler  t2ilnf 
$	   if t2ilon 	then call compiler  t2ilon 
$	   if t2imap 	then call compiler  t2imap 
$	   if t2imdn 	then call compiler  t2imdn 
$	   if t2imh3 	then call compiler  t2imh3
$	   if t2imht 	then call compiler  t2imht 
$	   if t2inxt 	then call compiler  t2inxt 
$	   if t2iove 	then call compiler  t2iove 
$	   if t2irea 	then call compiler  t2irea 
$	   if t2idate 	then call compiler  t2idate
$	   if t2itime 	then call compiler  t2itime
$	   if t2ichar 	then call compiler  t2ichar
$	   if t2ireal8 	then call compiler  t2ireal8
$	   if t2isec 	then call compiler  t2isec 
$	   if t2isep 	then call compiler  t2isep 
$	   if t2iskp 	then call compiler  t2iskp 
$	   if t2istr 	then call compiler  t2istr 
$	   if t2itst 	then call compiler  t2itst 
$	   if t2icb  	then call compiler  t2icb 
$	   if t2iacd  	then call compiler  t2iacd 
$	   if t2ilonacd then call compiler  t2ilonacd 
$	   if t2icb_output  then call compiler  t2icb_output 
$	   if t2icb_missing then call compiler  t2icb_missing
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$ compiler: subroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$!
$lnkonly:
$ 	if .not. lnkit then goto nolnk
$	wc "$	set noverify"
$	wc "$	if emsg.eqs."""" then goto noerr"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	write sys$output ""Compilation errors in:"""
$	wc "$	write sys$output emsg"
$	wc "$	write sys$output ""&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"""
$	wc "$	goto nolnk"
$	wc "$	noerr:"
$	wc "$	write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$	wc "$	set verify"
$	wc "$	link''linkopts'/exe=''linkver' -"
$	wc "	ifromtext,ifromtext_cld, -"
$	wc "	t2iecd,t2imcd,t2icbc,t2icb_output,t2icb_missing,-"
$	wc "	t2icom,t2icon,t2icor,t2ifea,-"
$	wc "	t2ifil,t2iign,t2iinf,t2iint,t2ilin,-"
$	wc "	t2ilnf,t2ilon,t2imap,t2imdn,t2imh3,t2imht,t2ilonacd,-"
$	wc "	t2inxt,t2iove,t2irea,t2ireal8,t2isec,t2isep,t2iacd,-"
$	wc "	t2iskp,t2istr,t2itst,t2icb,t2idate,t2itime,t2ichar,-"
$	wc "	ifromtext.promsg_obj,-"
$	wc "    lsl$library:osmhlib/lib,-"
$	wc "    lsl$library:frtshr/opt,-"
$	wc "    lsl$library:iffshr/opt,-"
$	wc "    lsl$library:lslshr/opt"
$!
$ nolnk:
$	wc "$	ifromtextex:"
$	wc "$ 	deass/group lsl$ifromtext_building"
$	wc "$ 	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto ifromtextex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch? "
$	if .not. answer_bat then goto int
$	deass/group lsl$ifromtext_building
$	bat ifromtextbat.com
$	goto ifromtextx2
$ int:	
$	if ok then inq/nop answer "Interactive? "
$	if .not.answer then goto ifromtextex
$	deass/group lsl$ifromtext_building
$	@ifromtextbat.com
$	goto ifromtextx2
$!
$ ifromtextex:
$	deass/group lsl$ifromtext_building
$!
$ ifromtextx2:
$	if ver then set verify
$	pur ifromtextbat.com
$	pur ifrommsg.par
$	pur ifromtext.map
$!
