$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-11-23 13:00:16.000000000 +0000
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
$! Mod 1432 Use bew frtshr				JB 23-Nov-1994
$!
$! Command file for building TDST2I
$!
$	on error then goto tdst2iex
$	on control_y then exit
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$tdst2i_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$a0:	on control_y then goto tdst2iex
$	define/group lsl$tdst2i_building "in_progress"
$	open/write comfil tdst2ibat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc	"$	define lsl$cmndstpar lsl$source_root:[convert.dstparlib]"
$	wc	"$	define lsl$dstpar lsl$source_root:[convert.dstparlib]"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto tdst2iex"
$	wc	"$	if ""'","'f$logical(""lsl$tdst2i_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$a0:	define/group lsl$tdst2i_building ""in_progress"""
$	wc	"$	set noon"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop tdst2i_dbg "With debug ? "
$	if .not. tdst2i_dbg then goto a04
$	   fsw1="/debug"
$	   mldbg="/debug"
$	   inquire/nop answer "Without optimisation ? "
$	   if answer then fsw1=fsw1 + "/noopt"
$	   inquire/nop answer "Check bounds and overflow ? "
$	   if answer then fsw1=fsw1 + "/check=(bounds,overflow)"
$	   inquire/nop answer "With listings ? "
$	   if answer then fsw1=fsw1 + "/list"
$	   inquire/nop answer "Keep fortran sources with comments ? "
$	   if answer then kpcom="/co"
$ a04:
$	   inq/nop cld "Compile CLD modules ? "
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all fortran sources ? "
$	   if .not. everything then goto a05
$	   tdst2i	= "t"
$	   update_range = "t"
$	   dstconv	= "t"
$	   dstpoly	= "t"
$	   dstarc	= "t"
$	   dstarea	= "t"
$	   dstpoint	= "t"
$	   dstmultip	= "t"
$	   dsttext	= "t"
$	   dstobjec	= "t"
$	   objarc	= "t"
$	   objmul	= "t"
$	   objpoi	= "t"
$	   objtex	= "t"
$	   objvec	= "t"
$	   area_arc	= "t"
$	   area_vec	= "t"
$	   goto a11
$!
$ a05:	   inq/nop tdst2i	"Compile TDST2I?	"
$	   inq/nop update_range	"Compile UPDATE_RANGE? 	"
$	   inq/nop dstconv	"Compile DSTCONV? 	"
$	   inq/nop dstarc	"Compile DSTARC? 	"
$	   inq/nop dstarea	"Compile DSTAREA? 	"
$	   inq/nop dstpoly	"Compile DSTPOLY? 	"
$	   inq/nop dstpoint	"Compile DSTPOINT? 	"
$	   inq/nop dstmultip	"Compile DSTMULTIP? 	"
$	   inq/nop dsttext	"Compile DSTTEXT? 	"
$	   inq/nop dstobjec	"Compile DSTOBJEC? 	"
$	   inq/nop objarc	"Compile OBJARC? 	"
$	   inq/nop objmul	"Compile OBJMUL? 	"
$	   inq/nop objpoi	"Compile OBJPOI? 	"
$	   inq/nop objtex	"Compile OBJTEX? 	"
$	   inq/nop objvec	"Compile OBJVEC? 	"
$	   inq/nop area_arc	"Compile AREA_ARC? 	"
$	   inq/nop area_vec	"Compile AREA_VEC? 	"
$	   write sys$output " "
$ a11:	   inq/nop mes "Generate message definitions ? "
$	   inquire/nop lnkit "Link ? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   linkver="tdst2i"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="tdst2ix"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$	   
$ notkb:
$!
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		set verify"
$ 		if .not. mes then goto nomess
$		wc "$	newmsg/number=1613/prefix=dsti__/parameter=fortran/runoff/hl=2 tdst2i.mes"
$		wc "$	@tdst2i.temp_com"
$		wc "$	purge tdst2imsg.rno"
$!
$ nomess:	if .not. cld then goto fortonly
$		wc "$ 		adc tdst2i.tmp=tdst2i_cld.cld"
$		wc "$ 		set command/object=tdst2i_cld tdst2i.tmp"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv tdst2i_cld"
$		wc "$ 		if ok then delete tdst2i.tmp;*"
$		wc "$ 		if ok then purge/nolog tdst2i_cld.obj"
$	
$ fortonly:		
$	if .not. compile then goto lnkonly
$	   if .not. tdst2i then goto a100
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		adc tdst2i''kpcom'=tdst2i"
$	   	wc "$ 		fort''fsw1' tdst2i"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv tdst2i"
$		wc "$ 		purge/nolog tdst2i.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog tdst2i.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog tdst2i.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a100:	   if .not. update_range then goto a101
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		adc update_range''kpcom'=update_range"
$	   	wc "$ 		fort''fsw1' update_range"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv update_range"
$		wc "$ 		purge/nolog update_range.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog update_range.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog update_range.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a101:	   if .not. dstarc then goto a105
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		adc dstarc''kpcom'=dstarc"
$	   	wc "$ 		fort''fsw1' dstarc"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dstarc"
$		wc "$ 		purge/nolog dstarc.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog dstarc.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dstarc.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a105:	   if .not. dstarea then goto a110
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		adc dstarea''kpcom'=dstarea"
$	   	wc "$ 		fort''fsw1' dstarea"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dstarea"
$		wc "$ 		purge/nolog dstarea.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog dstarea.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dstarea.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a110:	   if .not. dstconv then goto a120
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc dstconv''kpcom'=dstconv"
$	   	wc "$ 		fort''fsw1' dstconv"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dstconv"
$		wc "$ 		purge/nolog dstconv.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog dstconv.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dstconv.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a120:	   if .not. dstpoint  then goto a125
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc dstpoint''kpcom'=dstpoint"
$	   	wc "$ 		fort''fsw1' dstpoint"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dstpoint"
$		wc "$ 		purge/nolog dstpoint.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog dstpoint.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dstpoint.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a125:	   if .not. dstmultip then goto a130
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc dstmultip''kpcom'=dstmultip"
$	   	wc "$ 		fort''fsw1' dstmultip"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dstmultip"
$		wc "$ 		purge/nolog dstmultip.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog dstmultip.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dstmultip.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a130:	   if .not. dstpoly  then goto a135
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc dstpoly''kpcom'=dstpoly"
$	   	wc "$ 		fort''fsw1' dstpoly"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dstpoly"
$		wc "$ 		purge/nolog dstpoly.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog dstpoly.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dstpoly.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a135:	   if .not. dstobjec then goto a140
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc dstobjec''kpcom'=dstobjec"
$	   	wc "$ 		fort''fsw1' dstobjec"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dstobjec"
$		wc "$ 		purge/nolog dstobjec.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog dstobjec.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dstobjec.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a140:	   if .not. objarc then goto a145
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc objarc''kpcom'=objarc"
$	   	wc "$ 		fort''fsw1' objarc"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv objarc"
$		wc "$ 		purge/nolog objarc.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog objarc.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog objarc.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a145:	   if .not. objmul then goto a150
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc objmul''kpcom'=objmul"
$	   	wc "$ 		fort''fsw1' objmul"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv objmul"
$		wc "$ 		purge/nolog objmul.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog objmul.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog objmul.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a150:	   if .not. objpoi then goto a155
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc objpoi''kpcom'=objpoi"
$	   	wc "$ 		fort''fsw1' objpoi"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv objpoi"
$		wc "$ 		purge/nolog objpoi.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog objpoi.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog objpoi.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a155:	   if .not. objtex then goto a160
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc objtex''kpcom'=objtex"
$	   	wc "$ 		fort''fsw1' objtex"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv objtex"
$		wc "$ 		purge/nolog objtex.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog objtex.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog objtex.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a160:	   if .not. objvec then goto a165
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc objvec''kpcom'=objvec"
$	   	wc "$ 		fort''fsw1' objvec"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv objvec"
$		wc "$ 		purge/nolog objvec.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog objvec.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog objvec.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a165:	   if .not. area_arc then goto a170
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc area_arc''kpcom'=area_arc"
$	   	wc "$ 		fort''fsw1' area_arc"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv area_arc"
$		wc "$ 		purge/nolog area_arc.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog area_arc.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog area_arc.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a170:	   if .not. area_vec then goto a175
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc area_vec''kpcom'=area_vec"
$	   	wc "$ 		fort''fsw1' area_vec"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv area_vec"
$		wc "$ 		purge/nolog area_vec.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog area_vec.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog area_vec.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a175:	   if .not. dsttext  then goto lnkonly
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc dsttext''kpcom'=dsttext"
$	   	wc "$ 		fort''fsw1' dsttext"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dsttext"
$		wc "$ 		purge/nolog dsttext.obj"
$		if fsw1.eqs."" then -
			wc "$ 		purge/nolog dsttext.for"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dsttext.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$ 		link''linkopts'/exe=''linkver' tdst2i,-"
$	   	wc "		tdst2i_cld,dstconv,update_range,-"
$		wc "		dstarc,dstarea,dstpoint,-"
$	   	wc "		dstmultip,dstpoly,dsttext,dstobjec,-"
$	   	wc "		objarc,objmul,objpoi,objtex,objvec,-"
$	   	wc "		area_arc,area_vec,-"
$		wc "		tdst2i.promsg_obj,-"
$		wc "		lsl$dstpar:dstpar.promsg_obj,-"
$		wc "		lsl$dstpar:dstparlib/lib,-"
$		wc "		lsl$library:frtshr/opt,-"
$	   	wc "		lsl$library:iffshr/opt,lslshr/opt"
$ nolnk:
$		wc "$ 		tdst2iex:"
$		wc "$ 		deass/group lsl$tdst2i_building"
$		wc "$ 		set nover"
$!
$ filclo:
$	set noverify
$	on error then goto tdst2iex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$tdst2i_building
$	bat tdst2ibat.com
$	goto tdst2ix2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto tdst2iex
$	deass/group lsl$tdst2i_building
$	@tdst2ibat.com
$	goto tdst2ix2
$ tdst2iex:
$	deass/group lsl$tdst2i_building
$ tdst2ix2:
$	if ver then set verify
$	pur tdst2ibat.com
$	pur *.for
$	pur *.obj
$!
