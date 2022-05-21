$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-27 16:10:34.000000000 +0100
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
$! Command file to build IMP utility ISELAC
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!MOD	Changed the build directory for CMS		ST  27-Jul-1993
$!MOD	Now uses NEWMSG					TJH 10-Apr-1990
$!MOD	Changed to use shared library images		JMB 30-Nov-1987
$!MOD	Newmessage F(ortran) option added		ATT 14-Jan-1987
$!MOD	COPENT added					TJH 16-Dec-1986
$!	Created						ATT 30-Sep-1986
$!
$	ver=f$verify(0)
$!
$	on error then goto iselacex
$!
$!!!!	sd lsl$source_root:[imp.iselac]
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$iselac_building")'" .nes. "in_progress" -
	  then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto iselacex
$	define/group lsl$iselac_building "in_progress"
$	open/write comfil iselacbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc "$ 	set noverify"
$	wc "$	on control_y then goto iselacex"
$	wc "$	if ""'","'f$logical(""lsl$iselac_building"")'"" -"
$	wc "		 .nes. ""in_progress"" then goto a0"
$	wc "$	write sys$output ""Someone else is building"""
$	wc "$	exit"
$	wc "$!"
$	wc "$a0:  define/group lsl$iselac_building ""in_progress"""
$	wc "$	assign lsl$source_root:[imp.iselac.src] lsl$cmniselac"
$	wc "$	sd:=$lsl$sys:sd"
$	wc "$	set noon"
$!
$	renmes=""
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	   inq/nop compile "Compile ? "
$	if .not.compile then goto a04
$	   inq/nop iselac_dbg "With Debug ? "
$	if .not. iselac_dbg then goto a04
$	   fsw1="/debug"
$	   mldbg="/debug"
$	      inq/nop answer "Without optimisation ? "
$	   if answer then fsw1=fsw1 + "/noopt"
$	      inq/nop answer "Check bounds and overflow ? "
$	   if answer then fsw1=fsw1 + "/check=(bounds,overflow)"
$	      inq/nop answer "With listings ? "
$	   if answer then fsw1=fsw1 + "/list"
$	      inq/nop answer "Keep FORtran sources with comments ? "
$	   if answer then kpcom="/co"
$ a04:
$	   inq/nop cmd "Build Command tables "
$!
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all FORTRAN sources ? "
$	   if .not. everything then goto a05
$	   iselac="t"
$	   getcmd="t"
$	   acskrd="t"
$          copent="t"
$          setup="t"
$	   seldec="t"
$	   opnfil="t"
$	   skelrd="t"
$          prompt="t"
$	   actest="t"
$	   reject="t"
$	   help="t"
$	   show="t"
$	   read_prompt="t"
$	   copy_string="t"
$	   reset="t"
$	   goto a11
$!
$ a05:	   
$ 	   inq/nop iselac	"Compile ISELAC ?"
$          inq/nop acskrd 	"Compile ACSKRD ?"
$ 	   inq/nop copent	"Compile COPENT ?"
$ 	   inq/nop getcmd 	"Compile GETCMD ?"
$          inq/nop setup 	"Compile SETUP ?"
$	   inq/nop seldec 	"Compile SELDEC ?"
$	   inq/nop opnfil 	"Compile OPNFIL ?"
$	   inq/nop skelrd 	"Compile SKELRD ?"
$          inq/nop prompt 	"Compile PROMPT ?"
$	   inq/nop actest 	"Compile ACTEST ?"
$	   inq/nop reject 	"Compile REJECT ?"
$	   inq/nop help 	"Compile HELP ?"
$	   inq/nop show 	"Compile SHOW ?"
$	   inq/nop read_prompt	"Compile READ_PROMPT ?"
$	   inq/nop copy_string	"Compile COPY_STRING ?"
$	   inq/nop reset	"Compile RESET ?"
$	   write sys$output " "
$ a11:	   inq/nop mes "Generate message definitions ? "
$	   inq/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkver="iselac"
$	      inq/nop answer "Experimental version ? "
$	   if answer then linkver="iselacx"
$!
$	   linkopts="/map"
$	      inq/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	      inq/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$!
$	   
$ notkb:
$!
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		set verify"
$ 		if .not. mes then goto perhaps_cmd
$		wc "$	newmsg/number=1206/name=iselac/prefix=iselac__/parameter=for iselac.mes"
$		wc "$ @iselac.temp_com"
$ perhaps_cmd:
$	   if .not. cmd then goto fortonly
$		wc "$	macro  selcmd+lsl$library:lslmaclib/lib"
$		wc "$! "
$!	
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. iselac then goto a110
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc iselac''kpcom'=iselac"
$	   	wc "$ 		fort''fsw1' iselac"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv iselac"
$		wc "$ 		purge/nolog iselac.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog iselac.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog iselac.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog iselac.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a110:	   if .not. copent then goto a115
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc copent''kpcom'=copent"
$	   	wc "$ 		fort''fsw1' copent"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv copent"
$		wc "$ 		purge/nolog copent.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog copent.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog copent.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog copent.lis"
$		wc "$ 		delete adc.ide;*"
$!
$!
$ a115:	   if .not. getcmd then goto a120
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
$ 	   if .not. acskrd then goto a130
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc acskrd''kpcom'=acskrd"
$	   	wc "$ 		fort''fsw1' acskrd"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv acskrd"
$		wc "$ 		purge/nolog acskrd.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog acskrd.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog acskrd.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog acskrd.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a130:
$ 	   if .not. setup then goto a140
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc setup ''kpcom'=setup "
$	   	wc "$ 		fort''fsw1' setup "
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv setup "
$		wc "$ 		purge/nolog setup.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog setup.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog setup.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog setup.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a140:
$ 	   if .not. seldec then goto a150
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc seldec  ''kpcom'=seldec  "
$	   	wc "$ 		fort''fsw1' seldec  "
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv seldec  "
$		wc "$ 		purge/nolog seldec.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog seldec.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog seldec.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog seldec.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a150:	   
$!
$ 	   if .not. opnfil then goto a160
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 	adc opnfil''kpcom'=opnfil"
$	   	wc "$ 	fort''fsw1' opnfil   "
$	      	wc "$ 	ok=$status"	
$		wc "$ 	if ok then pvv opnfil   "
$		wc "$ 	purge/nolog opnfil.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog opnfil.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog opnfil.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog opnfil.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a160:
$ 	   if .not. skelrd then goto a170
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc skelrd''kpcom'=skelrd"
$	   	wc "$ 		fort''fsw1' skelrd   "
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv skelrd   "
$		wc "$ 		purge/nolog skelrd.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog skelrd.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog skelrd.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog skelrd.lis"
$		wc "$ 		delete adc.ide;*"
$ a170:
$ 	   if .not. prompt then goto a180
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc prompt ''kpcom'=prompt "
$	   	wc "$ 		fort''fsw1' prompt    "
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv prompt    "
$		wc "$ 		purge/nolog prompt.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog prompt.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog prompt.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog prompt.lis"
$		wc "$ 		delete adc.ide;*"
$ a180:
$ 	   if .not. actest  then goto a190
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc actest ''kpcom'=actest "
$	   	wc "$ 		fort''fsw1' actest    "
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv actest    "
$		wc "$ 		purge/nolog actest.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog actest.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog actest.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog actest.lis"
$		wc "$ 		delete adc.ide;*"
$ a190:
$ 	   if .not. reject  then goto a200
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc reject ''kpcom'=reject "
$	   	wc "$ 		fort''fsw1' reject    "
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv reject    "
$		wc "$ 		purge/nolog reject.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog reject.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog reject.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog reject.lis"
$		wc "$ 		delete adc.ide;*"
$ a200:
$ 	   if .not. help then goto a210
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc help  ''kpcom'=help  "
$	   	wc "$ 		fort''fsw1' help     "
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv help     "
$		wc "$ 		purge/nolog help.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog help.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog help.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog help.lis"
$		wc "$ 		delete adc.ide;*"
$ a210:
$ 	   if .not. show then goto a220
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc show  ''kpcom'=show  "
$	   	wc "$ 		fort''fsw1' show     "
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv show     "
$		wc "$ 		purge/nolog show.obj"
$		if fsw1.nes."" then -
			wc "$ 		purge/nolog show.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog show.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog show.lis"
$		wc "$ 		delete adc.ide;*"
$ a220:
$ 	   if .not. read_prompt   then goto a230
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc read_prompt  ''kpcom'=read_prompt  "
$	   	wc "$ 		fort''fsw1' read_prompt"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv read_prompt     "
$		wc "$ 		purge/nolog read_prompt.obj"
$		if fsw1.nes."" then -
			wc "$ 	purge/nolog read_prompt.for"
$		if fsw1.eqs."" then -
			wc "$ 	delete/nolog read_prompt.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog read_prompt.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a230:
$ 	   if .not. copy_string   then goto a240
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc copy_string  ''kpcom'=copy_string  "
$	   	wc "$ 		fort''fsw1' copy_string"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv copy_string     "
$		wc "$ 		purge/nolog copy_string.obj"
$		if fsw1.nes."" then -
			wc "$ 	purge/nolog copy_string.for"
$		if fsw1.eqs."" then -
			wc "$ 	delete/nolog copy_string.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog copy_string.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a240:
$ 	   if .not. reset then goto lnkonly
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc reset ''kpcom'=reset  "
$	   	wc "$ 		fort''fsw1' reset"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv reset     "
$		wc "$ 		purge/nolog reset.obj"
$		if fsw1.nes."" then -
			wc "$ 	purge/nolog reset.for"
$		if fsw1.eqs."" then -
			wc "$ 	delete/nolog reset.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
			wc "$ 		purge/nolog reset.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ link''linkopts'/exe=''linkver' iselac,-"
$	   	wc " selcmd, getcmd, acskrd, setup, copent, -"
$	   	wc " seldec , help, opnfil, skelrd, prompt, -'
$	   	wc " actest, reject, show, read_prompt, copy_string,-'
$		wc " reset, iselac.promsg_obj, -"
$!
$	   	wc "		lsl$library:iffshr/opt,lslshr/opt"
$!
$ nolnk:
$		wc "$ 		iselacex:"
$		wc "$ 		deass/group lsl$iselac_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto iselacex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$iselac_building
$	bat iselacbat.com
$	goto iselacx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto iselacex
$	deass/group lsl$iselac_building
$	@iselacbat.com
$	goto iselacx2
$ iselacex:
$	deass/group lsl$iselac_building
$ iselacx2:
$	if ver then set verify
