$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-12-01 11:22:06.000000000 +0000
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
$!	Created						DRC 14-Mar-1988
$!
$!	Beware of using new frtshr, iffshr or lslshr,
$!	because of redefinition of RDCH(S) etc.		 JB 29-Nov-1994
$!
$! Command file for building CEDD2I
$!
$	on error then goto cedd2iex
$	on control_y then exit
$!
$	disk:='f$logical("sys$disk")'
$	if "''f$logical("lsl$cedd2i_building")'" .nes. "in_progress" -
	   then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$ a0:	on control_y then goto cedd2iex
$	define/group lsl$cedd2i_building "in_progress"
$	open/write comfil cedd2ibat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$	wc="write comfil"
$!
$	wc 	"$ 	set noverify"
$	wc	"$	on control_y then goto cedd2iex"
$	wc	"$	if ""'","'f$logical(""lsl$cedd2i_building"")'"" -"
$	wc	"		 .nes. ""in_progress"" then goto a0"
$	wc	"$	write sys$output ""Someone else is building"""
$	wc	"$	exit"
$	wc	"$!"
$	wc	"$ a0:	define/group lsl$cedd2i_building ""in_progress"""
$	wc	"$	set noon"
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	inquire/nop compile "Compile ? "
$	if .not.compile then goto a04
$	inquire/nop cedd2i_dbg "With Debug ? "
$	if .not. cedd2i_dbg then goto a04
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
$	   inq/nop cld "Compile CLD modules ? "
$	   if .not.compile then goto a11
$!
$	   inq/nop everything "Compile all FORTRAN sources ? "
$	   if .not. everything then goto a05
$!
$          rdch="t"
$	   cedd2i="t"
$	   getcomlin="t"
$	   rddsi="t"
$	   strtif="t"
$          endiff="t"
$          rdreg="t"
$          dsi_read_long="t"
$          dsi_read_real="t"
$          dsi_read_string="t"
$	   rddmsh="t"
$          outhdr="t"
$	   featur="t"
$	   segmnt="t"
$          segcpy="t"
$	   goto a11
$!
$ a05:
$	   INQ/NOP RDCH "Compile RDCH,RDCHS,RDAUXC? "
$	   INQ/NOP CEDD2I "Compile CEDD2I,RDMAG? "
$	   INQ/NOP GETCOMLIN "Compile GETCOMLIN,RDLALO? "
$	   INQ/NOP RDDSI "Compile RDDSI,RDTXT? "
$	   INQ/NOP RDREG "Compile RDREG,RDACC? "
$          INQ/NOP DSI_READ_LONG   "Compile DSI_READ_LONG? "
$          INQ/NOP DSI_READ_REAL   "Compile DSI_READ_REAL? "
$          INQ/NOP DSI_READ_STRING "Compile DSI_READ_STRING? "
$          INQ/NOP RDDMSH "Compile RDDMSH,CVTDAY? "
$	   INQ/NOP STRTIF "Compile STRTIF,STDUMP? "
$	   INQ/NOP ENDIFF "Compile ENDIFF,ENDLAY? "
$	   INQ/NOP OUTHDR "Compile OUTHDR,LAYER0,OUTLAY? "
$	   INQ/NOP FEATUR "Compile FEATUR,FTRHDR,LAYER1? "
$	   INQ/NOP SEGMNT "Compile SEGMNT,MERGER? "
$          INQ/NOP SEGCPY "Compile SEGCPY,SEG_MERGE? "
$!
$	   goto a11
$!
$ a11:	   inq/nop mes "Generate message definitions? "
$!
$	   inquire/nop lnkit "Link? "
$	   if .not. lnkit then goto notkb
$!
$	   linkopts="/map=cedd2i.map"
$	   inquire/nop answer "Link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   linkver="cedd2i"
$	   inquire/nop answer "Experimental version ? "
$	   if answer then linkver="cedd2ix"
$!
$	   inquire/nop answer "Cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$
$ notkb:
$!
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		set verify"
$ 		if .not. mes then goto nomessing
$		wc "$	newmsg cedd2i.mes/num=1612/name=cedd2i/pre=cedd2i__/par=for/runoff"
$		wc "$	@cedd2i.temp_com"
$ nomessing:
$	   if .not. cld then goto fortonly
$		wc "$ 		adc cedd2i.tmp=cedd2i.cld"
$		wc "$ 		set command/object=cedd2i_cld cedd2i.tmp"
$		wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv cedd2i_cld"
$		wc "$ 		if ok then delete cedd2i.tmp;*"
$		wc "$ 		if ok then purge/nolog cedd2i_cld.obj"
$	
$ fortonly:		
$	if .not. compile then goto lnkonly
$ 	   if .not. rdch then goto a105
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		adc rdch''kpcom'=rdch,rdchs,rdauxc"
$		wc "$ 		fort''fsw1' rdch"
$		wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv rdch"
$		wc "$ 		purge/nolog rdch.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog rdch.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog rdch.for;*"
$		wc "$ 		delete adc.ide;*"
$!
$ a105:    if .not. cedd2i then goto a110
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ 		adc cedd2i''kpcom'=cedd2i,rdmag"
$		wc "$ 		fort''fsw1' cedd2i"
$		wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv cedd2i"
$		wc "$ 		purge/nolog cedd2i.obj"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog cedd2i.for;*"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog cedd2i.for"
$		wc "$ 		delete adc.ide;*"
$!
$ a110:	   if .not. getcomlin then goto a115
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$		wc "$ 		adc getcomlin''kpcom'=getcomlin,rdlalo"
$		wc "$ 		fort''fsw1' getcomlin"
$		wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv getcomlin"
$		wc "$ 		purge/nolog getcomlin.obj"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog getcomlin.for;*"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog getcomlin.for"
$		wc "$ 		delete adc.ide;*"
$!
$ a115:	   if .not. rddsi then goto a120
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc rddsi''kpcom'=rddsi,rdtxt"
$		wc "$ 		fort''fsw1' rddsi"
$		wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv rddsi"
$		wc "$ 		purge/nolog rddsi.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog rddsi.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog rddsi.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog rddsi.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a120:	   if .not. rdreg then goto a125
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc rdreg''kpcom'=rdreg,rdacc"
$	   	wc "$ 		fort''fsw1' rdreg"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv rdreg"
$		wc "$ 		purge/nolog rdreg.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog rdreg.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog rdreg.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog rdreg.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a125:	   if .not. dsi_read_long then goto a130
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc dsi_read_long''kpcom'=dsi_read_long"
$	   	wc "$ 		fort''fsw1' dsi_read_long"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dsi_read_long"
$		wc "$ 		purge/nolog dsi_read_long.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog dsi_read_long.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog dsi_read_long.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dsi_read_long.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a130:	   if .not. dsi_read_real then goto a132
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc dsi_read_real''kpcom'=dsi_read_real"
$	   	wc "$ 		fort''fsw1' dsi_read_real"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dsi_read_real"
$		wc "$ 		purge/nolog dsi_read_real.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog dsi_read_real.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog dsi_read_real.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dsi_read_real.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a132:	   if .not. dsi_read_string then goto a135
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc dsi_read_string''kpcom'=dsi_read_string"
$	   	wc "$ 		fort''fsw1' dsi_read_string"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv dsi_read_string"
$		wc "$ 		purge/nolog dsi_read_string.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog dsi_read_string.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog dsi_read_string.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog dsi_read_string.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a135:	   if .not. rddmsh then goto a140
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc rddmsh''kpcom'=rddmsh,cvtday"
$	   	wc "$ 		fort''fsw1' rddmsh"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv rddmsh"
$		wc "$ 		purge/nolog rddmsh.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog rddmsh.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog rddmsh.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog rddmsh.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a140:	   if .not. outhdr then goto a145
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc outhdr''kpcom'=outhdr,layer0,outlay"
$	   	wc "$ 		fort''fsw1' outhdr"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv outhdr"
$		wc "$ 		purge/nolog outhdr.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog outhdr.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog outhdr.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog outhdr.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a145:	   if .not. featur then goto a150
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc featur''kpcom'=featur,ftrhdr,layer1"
$	   	wc "$ 		fort''fsw1' featur"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv featur"
$		wc "$ 		purge/nolog featur.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog featur.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog featur.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog featur.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a150:	   if .not. segmnt then goto a155
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc segmnt''kpcom'=segmnt,merger"
$	   	wc "$ 		fort''fsw1' segmnt"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv segmnt"
$		wc "$ 		purge/nolog segmnt.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog segmnt.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog segmnt.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog segmnt.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a155:	   if .not. segcpy then goto a158
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc segcpy''kpcom'=segcpy,seg_merge"
$	   	wc "$ 		fort''fsw1' segcpy"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv segcpy"
$		wc "$ 		purge/nolog segcpy.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog segcpy.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog segcpy.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog segcpy.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a158:	   if .not. strtif then goto a160
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc strtif''kpcom'=strtif,stdump"
$	   	wc "$ 		fort''fsw1' strtif"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv strtif"
$		wc "$ 		purge/nolog strtif.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog strtif.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog strtif.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog strtif.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a160:	   if .not. endiff then goto a180
$ 		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$ 		wc "$ set verify"
$		wc "$ 		adc endiff''kpcom'=endiff,endlay"
$	   	wc "$ 		fort''fsw1' endiff"
$	      	wc "$ 		ok=$status"	
$		wc "$ 		if ok then pvv endiff"
$		wc "$ 		purge/nolog endiff.obj"
$		if fsw1.nes.""  then -
			wc "$ 		purge/nolog endiff.for"
$		if fsw1.eqs."" then -
			wc "$ 		delete/nolog endiff.for;*"
$		if (f$locate("list",fsw1).ne.f$length(fsw1)).and. -
			f$length(fsw1).ne.0 then -
				wc "$ 		purge/nolog endiff.lis"
$		wc "$ 		delete adc.ide;*"
$!
$ a180:
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$		wc "$ set noverify"
$		wc "$ write sys$output ""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
$		wc "$ set verify"
$	   	wc "$	link''linkopts'/exe=''linkver' -"
$               wc "    rdch,-"
$		wc "    cedd2i,cedd2i_cld,-"
$               wc "    getcomlin,rddsi,-"
$               wc "    rdreg,rddmsh,outhdr,-"
$               wc "    dsi_read_long,-"
$               wc "    dsi_read_real,-"
$               wc "    dsi_read_string,-"
$               wc "    featur,strtif,-"
$               wc "    segmnt,segcpy,endiff,-"
$	        wc "    cedd2i.promsg_obj,-"
$               wc "    lsl$library:lslfrtlib/lib,-"
$!
$!               wc "    lsl$library:frtshr.opt/opt,-"
$!               wc "    lsl$library:iffshr.opt/opt,-"
$!               wc "    lsl$library:lslshr.opt/opt,-"
$!
$              wc "    lsl$library:ifflib/lib,-"
$              wc "    lsl$library:lsllib/lib"
$!
$ nolnk:
$		wc "$ 		cedd2iex:"
$		wc "$ 		deass/group lsl$cedd2i_building"
$		wc "$ 		set nover"
$               wc "$           pur"
$!
$ filclo:
$	set noverify
$	on error then goto cedd2iex
$	close comfil
$	ok=$status
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if .not. answer_bat then goto int
$	deass/group lsl$cedd2i_building
$	bat cedd2ibat.com
$	goto cedd2ix2
$ int:	
$	if ok then inq/nop answer "Interactive ? "
$	if .not.answer then goto cedd2iex
$	deass/group lsl$cedd2i_building
$	@cedd2ibat.com
$	goto cedd2ix2
$!
$ cedd2iex:
$	deass/group lsl$cedd2i_building
$!
$ cedd2ix2:
$	if ver then set verify
$!
