$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-12-20 18:00:18.000000000 +0000
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
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!	Created DRC 19NO86
$!
$! Command file for building READCCT
$!
$	set noverify
$	on error then goto readcctex
$	on control_y then exit
$!
$	disk:='f$logical("sys$disk")'
$a0:	on control_y then goto readcctex
$!	open/write comfil readcctbat.com
$	on control_y then goto filclo
$ 	on error then goto filclo
$!	wc="write comfil"
$!
$	on control_y then goto readcctex
$	assign lsl$disk:[alvey.readcct] lsl$cmnreadcct
$	sd:=$lsl$sys:sd
$	set noon
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	INQUIRE/NOP COMPILE "Compile ? "
$	IF .NOT.COMPILE THEN GOTO A04
$	INQUIRE/NOP READCCT_DBG "With Debug ? "
$	IF .NOT. READCCT_DBG THEN GOTO A04
$	   FSW1="/DEBUG"
$	   MLDBG="/DEBUG"
$	   INQUIRE/NOP ANSWER "Without optimisation ? "
$	   IF ANSWER THEN FSW1=FSW1 + "/NOOPT"
$	   INQUIRE/NOP ANSWER "Check bounds and overflow ? "
$	   IF ANSWER THEN FSW1=FSW1 + "/CHECK=(BOUNDS,OVERFLOW)"
$	   INQUIRE/NOP ANSWER "With listings ? "
$	   IF ANSWER THEN FSW1=FSW1 + "/LIST"
$	   INQUIRE/NOP ANSWER "Keep FORtran sources with comments ? "
$	   IF ANSWER THEN KPCOM="/CO"
$ A04:
$	   INQ/NOP CLD "Compile CLD modules ? "
$	   IF .NOT.COMPILE THEN GOTO A11
$!
$	   INQ/NOP EVERYTHING "Compile all FORTRAN sources ? "
$	   if .not. everything then goto a05
$	   readcct="t"
$	   files="t"
$	   cmdlin="t"
$	   tape1="t"
$	   tape2="t"
$	   tape3="t"
$	   nrsc="t"
$	   goto a11
$!
$A05:      INQ/NOP READCCT	"Compile READCCT ? 	"
$ 	   INQ/NOP FILES	"Compile FILES routines	"
$	   INQ/NOP CMDLIN	"Compile CMDLIN? 	"
$	   INQ/NOP TAPE1	"Compile Tape1 Routines?"
$	   INQ/NOP TAPE2	"Compile Tape2 Routines?"
$	   INQ/NOP TAPE3	"Compile Tape3 Routines?"
$	   INQ/NOP NRSC         "Compile NRSC Routines? "
$	   WRITE SYS$OUTPUT " "
$ A11:	   INQ/NOP MES "Generate message definitions ? "
$	   INQUIRE/NOP LNKIT "Link ? "
$	   IF .NOT. LNKIT THEN GOTO NOTKB
$!
$	   LINKVER="READCCT"
$	   INQUIRE/NOP ANSWER "Experimental version ? "
$	   IF ANSWER THEN LINKVER="READCCTX"
$!
$	   linkopts="/map"
$	   inquire/nop answer "link with debug ? "
$	   if answer then linkopts=linkopts+"/debug"
$!
$	   inquire/nop answer "cross reference map ? "
$	   if answer then linkopts=linkopts+"/cross"
$
$ notkb:
$!
$ if .not.mes then goto nomes
$!
$	set verify
$	newmsg/runoff/number=1901/par=for/prefix=readcct__ readcct.mes
$	@readcct.temp_com
$	purge readcctmsg.rno
$	set noverify
$!
$ nomes:
$  if .not. cld then goto fortonly
$  set verify
$  adc readcct.tmp=readcct.cld
$  set command/object=readcct_cld readcct.tmp
$  ok=$status
$  if ok then pvv readcct_cld
$  if ok then delete readcct.tmp;*
$  if ok then delete adc.ide;*
$  if ok then purge readcct_cld.obj
$  set noverify
$
$ fortonly:		
$  if .not. compile then goto lnkonly
$  if .not. files then goto a100
$  set verify
$  adc files 'kpcom'=close_files,open_files
$  fort'fsw1' files
$  ok=$status
$  if ok then pvv files
$  purge files.*
$  delete adc.ide;*
$  set noverify
$!
$ a100:	   if .not. cmdlin then goto a110
$  set verify
$  adc cmdlin 'kpcom'=cmdlin
$  fort'fsw1' cmdlin
$  ok=$status
$  if ok then pvv cmdlin
$  purge cmdlin.*
$  delete adc.ide;*
$  set noverify
$!
$ a110:	   if .not. readcct then goto a120
$  set verify
$  adc readcct 'kpcom'=readcct,form_word,form_longword,form_time,form_date
$  adc readcct/ap     =form_spot_real4,form_spot_real8
$  fort'fsw1' readcct
$  ok=$status
$  if ok then pvv readcct
$  purge readcct.*
$  delete adc.ide;*
$  set noverify
$!
$ a120:	   if .not. tape1 then goto tape2
$  set verify
$  adc tape1 'kpcom'=read_tape,read_volume,read_pointer,read_descr,read_trailer
$  fort'fsw1' tape1
$  ok=$status
$  if ok then pvv tape1
$  purge tape1.*
$  delete adc.ide;*
$  set noverify
$!
$tape2:	   if .not. tape2 then goto tape3
$  set verify
$  adc tape2 'kpcom'= read_image,read_text,print_summary
$  fort'fsw1' tape2
$  ok=$status
$  if ok then pvv tape2
$  purge tape2.*
$  delete adc.ide;*
$  set noverify
$!
$tape3:	   if .not. tape3 then goto nrsc
$  set verify
$  adc tape3 'kpcom'= read_calibration,read_histogram,read_projection
$  adc tape3/ap    = read_ephemeris,read_header,read_gcp
$  fort'fsw1' tape3
$  ok=$status
$  if ok then pvv tape3
$  purge tape3.*
$  delete adc.ide;*
$  set noverify
$!
$nrsc:	   if .not. nrsc then goto lnkonly
$  set verify
$  adc nrsc 'kpcom'= read_nrsc_tape,read_nrsc_vol,read_nrsc_hdr
$  adc nrsc/ap     = read_nrsc_imhead,read_nrsc_image
$  adc nrsc/ap     = read_nrsc_eof,read_nrsc_eov
$  adc nrsc/ap     = print_nrsc_summary
$  fort'fsw1' nrsc
$  ok=$status
$  if ok then pvv nrsc
$  purge nrsc.*
$  delete adc.ide;*
$  set noverify
$!
$ lnkonly:
$ 	if .not. lnkit then goto nolnk
$	set verify
$	link'linkopts'/exe='linkver' readcct,-
	readcct_cld,cmdlin,files,-
	tape1,tape2,tape3,nrsc,-
	readcct.promsg_obj,-
	lsl$library:dtilib/lib,-
	lsl$library:lslshr/opt
$!	lsl$library:lsllib/lib
$	set noverify
$!
$ purge *.map
$! purge *.exe
$ nolnk:
$
