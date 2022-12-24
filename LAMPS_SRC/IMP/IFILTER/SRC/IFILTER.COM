$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1995-02-28 10:25:06.000000000 +0000
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
$!	Copyright Laser-Scan Ltd., Cambridge, England.
$!
$!	Created						RJH 09-Oct-1986
$!
$!MOD	Newmessage F(ortran) option added		ATT 14-Jan-1987
$!MOD	BRIDGE and ERR$ROUT routines added, together with
$!	conditional compilation for debug		TJH 23-Aug-1989
$!MOD	Build directory changed for CMS			ST  27-Jul-1993
$!MOD1432 Use new frtshr				JB  22-Nov-1994
$!MOD	Added new routine SHUFFLE_POINTS		ST  28-Feb-1995
$!
$!	IMP IFILTER Program - Command file for building it
$!
$	on error then goto ifilterex
$	on control_y then exit
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$ifilter_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building IFILTER"
$	exit
$!
$a0:	on control_y then goto ifilterex
$	define/group lsl$ifilter_building "in_progress"
$	open/write comfil ifilterbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto ifilterex"
$	wc	"$	if ""'","'f$logical(""lsl$ifilter_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building IFILTER"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$a0:	define/group lsl$ifilter_building ""in_progress"""
$	wc	"$	inter =f$mode() .eqs. ""interactive"""
$	wc	"$	assign here: lsl$cmnifilt"
$	wc	"$	sd:=$lsl$sys:sd"
$	wc	"$	set noon"
$!
$	renmes =""
$	mldbg  =""
$	fsw1   =""
$	kpcom  =""
$	lis    =""
$!
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$!
$	inquire/nop ifilt_dbg "With Debug ? "
$	if .not. ifilt_dbg then goto a04
$!
$	   fsw1="/debug"
$	   mldbg="/debug"
$	   inquire/nop answer "Without optimisation ? "
$	   if answer then fsw1=fsw1 + "/noopt"
$!
$	   inquire/nop answer "Check bounds and overflow ? "
$	   if answer then fsw1=fsw1 + "/check=(bounds,overflow)"
$!
$	   inquire/nop answer "With listings ? "
$	   if answer then lis = "y"
$	   if answer then fsw1=fsw1 + "/list"
$!
$	   inquire/nop answer "Keep FORtran sources with comments ? "
$	   if answer then kpcom="/co"
$ a04:
$	   inq/nop cld "Compile CLD modules ? "
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all FORTRAN sources ? "
$	   if .not. everything then goto a05
$	   ifilt ="t"
$	   obey  ="t"
$	   iff   ="t"
$	   int   ="t"
$	   fil   ="t"
$	   except="t"
$	   goto a11
$!
$ A05:	   INQ/NOP IFILT	"Main program ?		"
$	   INQ/NOP OBEY		"Get command ?		"
$	   INQ/NOP IFF		"Process IFF file ?	"
$	   INQ/NOP INT		"Interpolation ?	"
$	   INQ/NOP FIL		"Filtering ?		"
$	   INQ/NOP EXCEPT	"Exception handler ?	"
$	   write sys$output " "
$ a11:	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   linkver="ifilter"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="ifilterx"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$	   
$ notkb:
$!
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		set verify"
$ 	if .not. mes then goto nomes
$  	        wc "$ newmsg/number=1202 ifilt.mes"
$  		wc "$ @ifilt.temp_com "
$
$nomes:	if .not. cld then goto fortonly
$		wc "$ 		adc ifilter.tmp=ifilter.cld"
$		wc "$ 		set command/object=ifilter_cld ifilter.tmp"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv ifilter_cld"
$		wc "$ 		if ok then delete ifilter.tmp;*"
$		wc "$ 		if ok then purge/nolog ifilter_cld.obj"
$	
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. ifilt then goto a110
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc ifilter''kpcom'=ifilter"
$	   	wc "$ 		fort''fsw1' ifilter"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv ifilter"
$		wc "$ 		purge/nolog ifilter.obj"
$		if fsw1.eqs."" then goto a102
$ 		wc "$ 		purge/nolog ifilter.for"
$		goto a104
$ a102:		wc "$ 		delete/nolog ifilter.for;*"
$ a104:		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then goto a106
$ 		wc "$ 		if .not.inter.and.lis then delete/nolog ifilter.lis;*"
$		goto a108
$ a106:		wc "$ 		purge/nolog ifilter.lis"
$ a108:		wc "$ 		delete adc.ide;*"
$!
$ a110:	   if .not. obey then goto a120
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc get_command''kpcom'=get_command"
$	   	wc "$ 		fort''fsw1' get_command"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv get_command"
$		wc "$ 		purge/nolog get_command.obj"
$		if fsw1.eqs."" then goto a112
$ 		wc "$ 		purge/nolog get_command.for"
$		goto a114
$ a112:		wc "$ 		delete/nolog get_command.for;*"
$ a114:		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then goto a116
$ 		wc "$ 		if .not.inter.and.lis then delete/nolog get_command.lis;*"
$		goto a118
$ a116:		wc "$ 		purge/nolog get_command.lis"
$ a118:		wc "$ 		delete adc.ide;*"
$!
$ a120:	   if .not. iff then goto a130
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc process''kpcom'=process,process_line"
$		wc "$ 		adc process''kpcom'/ap=transfer_pts,flush_line"
$		wc "$ 		adc process''kpcom'/ap=st_out,set_up"
$		wc "$ 		adc process''kpcom'/ap=open_iff,close_iff"
$		wc "$ 		adc process''kpcom'/ap=addnod,shuffle_points"
$	   	wc "$ 		fort''fsw1' process"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv process"
$		wc "$ 		purge/nolog process.obj"
$		if fsw1.eqs."" then goto a122
$ 		wc "$ 		purge/nolog process.for"
$		goto a124
$ a122:		wc "$ 		delete/nolog process.for;*"
$ a124:		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then goto a126
$ 		wc "$ 		if .not.inter.and.lis then delete/nolog process.lis;*"
$		goto a128
$ a126:		wc "$ 		purge/nolog process.lis"
$ a128:		wc "$ 		delete adc.ide;*"
$!
$ a130:	   if .not. int then goto a140
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc smooth_line''kpcom'=smooth_line,addpts"
$	   	wc "$ 		fort''fsw1' smooth_line"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv smooth_line"
$		wc "$ 		purge/nolog smooth_line.obj"
$		if fsw1.eqs."" then goto a132
$ 		wc "$ 		purge/nolog smooth_line.for"
$		goto a134
$ a132:		wc "$ 		delete/nolog smooth_line.for;*"
$ a134:		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then goto a136
$ 		wc "$ 		if .not.inter.and.lis then delete/nolog smooth_line.lis;*"
$		goto a138
$ a136:		wc "$ 		purge/nolog smooth_line.lis"
$ a138:		wc "$ 		delete adc.ide;*"
$!
$ a140:	   if .not. fil then goto a150
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc filter_line''kpcom'=filter_line"
$	   	wc "$ 		fort''fsw1' filter_line"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv filter_line"
$		wc "$ 		purge/nolog filter_line.obj"
$		if fsw1.eqs."" then goto a142
$ 		wc "$ 		purge/nolog filter_line.for"
$		goto a144
$ a142:		wc "$ 		delete/nolog filter_line.for;*"
$ a144:		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then goto a146
$ 		wc "$ 		if .not.inter.and.lis then delete/nolog filter_line.lis;*"
$		goto a148
$ a146:		wc "$ 		purge/nolog filter_line.lis"
$ a148:		wc "$ 		delete adc.ide;*"
$!
$ a150:	   if .not. except then goto lnkonly
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$!
$		if ifilt_dbg
$		then
$		   wc "$adc except''kpcom'=ifilter_debug.tru/tr,bridge.src,err$rout.src"
$		else
$		   wc "$adc except''kpcom'=ifilter_nodebug.tru/tr,bridge.src,err$rout.src"
$		endif
$!
$   		wc "$ 		fort''fsw1' except"
$      		wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv except"
$		wc "$ 		purge/nolog except.obj"
$		if fsw1.eqs."" then goto a152
$ 		wc "$ 		purge/nolog except.for"
$		goto a154
$ a152:		wc "$ 		delete/nolog except.for;*"
$ a154:		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then goto a156
$ 		wc "$ 		if .not.inter.and.lis then delete/nolog except.lis;*"
$		goto a158
$ a156:		wc "$ 		purge/nolog except.lis"
$ a158:		wc "$ 		delete adc.ide;*"
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$		link''linkopts'/exe=''linkver'  -"
$	   	wc "		ifilter,ifilter_cld,filter_line, -"
$	   	wc "		get_command,except,process, -"
$		wc "		smooth_line,ifilt.promsg_obj, -"
$		wc "		lsl$library:coordlib/lib, -"
$!		wc "LSL$SOURCE_ROOT:[LSLMAINT.COORDLIB.TEST]coordlib/lib, -"
$		wc "		lsl$library:frtshr/opt,-"
$		wc "		lsl$library:iffshr/opt,-"
$		wc "		lsl$library:lslshr/opt"
$	   	wc "$		purge/nolog ifilter*.exe"
$	   	wc "$		purge/nolog ifilter*.map"
$!
$ nolnk:
$		wc "$		ifilterex:"
$		wc "$		deass/group lsl$ifilter_building"
$		wc "$		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto ifilterex
$	on control_y then goto ifilterex
$	close comfil
$	purge/nolog/keep=3 ifilterbat.com
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$ifilter_building
$	bat ifilterbat.com
$	goto ifilterx2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto ifilterex
$	deass/group lsl$ifilter_building
$	@ifilterbat.com
$	goto ifilterx2
$!
$ ifilterex:
$	deass/group lsl$ifilter_building
$!
$ ifilterx2:
$	if ver then set verify
$!
