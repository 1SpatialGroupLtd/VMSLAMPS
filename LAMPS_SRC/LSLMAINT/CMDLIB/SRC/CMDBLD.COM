$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-06-16 08:57:44.000000000 +0100
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
$	xxx:='f$verify(0)'
$	if p1 .nes. "?" then goto nohlp
$	type sys$input:
Switches, given in P1, are:

 D - Compile/assemble with DEBUG
 N - generate a new library
     (doesn't then bother to ask which bits to do, and ignores P2...)
 T - use LSLMACLIB out of [LIB.LSLMACLIB] not that out of LSL$LIBRARY

P2... are sub-parts to compile (mac, dec, num or dyn); if none are present,
the procedure asks for which you want.
$	exit
$nohlp:	fdeb:=
$	mdeb:=
$	delfor:=
$	lll=f$length(p1)
$	if f$locate("D",p1) .lt. lll then fdeb:="/deb"
$	if fdeb .nes. "" then mdeb:="/en=(deb)"
$	if fdeb .eqs. "" then delfor:=",.for;*"
$	new=0
$	if f$locate("N",p1) .lt. lll then new=1
$	test_mac=0
$	if f$locate("T",p1) .lt. lll then test_mac=1
$	xxx=f$logical("macro_library")
$	if xxx.nes."" then deassign macro_library
$	if test_mac then assign lsl$source_root:[lib.lslmaclib] -
					macro_library
$	if .not.test_mac then assign 'f$logical("lsl$library")' macro_library
$	if .not.new then goto may_need_to_ask
$	domac = 1
$	dodec = 1
$	donum = 1
$	dodyn = 1
$	goto asked
$may_need_to_ask: if p2 .eqs. "" then goto ask
$	domac = 0
$	dodec = 0
$	donum = 0
$	dodyn = 0
$	do'p2' = 1
$	if p3.nes."" then do'p3' = 1
$	if p4.nes."" then do'p4' = 1
$	if p5.nes."" then do'p5' = 1
$	if p6.nes."" then do'p6' = 1
$	if p7.nes."" then do'p7' = 1
$	goto asked
$ask:	inquire domac "Macro stuff"
$	inquire dodec "Basic decode and RDCOMM"
$	inquire donum "Number-read stuff"
$	inquire dodyn "Dynamic table stuff"
$asked:	on error then goto grut
$	if new then write sys$output "$	lib/create cmdlib"
$	if new then lib/create cmdlib
$	lr:=lib/rep/log cmdlib
$	if new then lr:=lib/ins/log cmdlib
$	set verify
$	if .not.domac then goto nomac
$	mac'mdeb' cmdcom+fincmd/obj=fincmd
$	lr fincmd
$	mac'mdeb' sortab
$	lr sortab
$	mac cmdieq
$	lr cmdieq
$nomac:	if .not.dodec then goto nodec
$	adc cmddec=bsch,bsln,cmderr,chand,dcpsav,dcpset
$	adc cmddec/ap=rdauxc,rdch,rdchs,rdcomm,rdname
$	adc cmddec/ap=rdstr,rdsign,setaux,setwin,shellsort
$	for'fdeb' cmddec
$	pvv cmddec
$	lr cmddec
$	del cmddec.obj;*'delfor',adc.ide;*
$nodec:	if .not.donum then goto nonum
$	adc cmdnum=rddble,rdhex,rdint,rdlhex,rdloct,rdlong
$	adc cmdnum/ap=rdnum,rdnume,rdoct,rdrcmp,rdreal
$	for'fdeb' cmdnum
$	pvv cmdnum
$	lr cmdnum
$	del cmdnum.obj;*'delfor',adc.ide;*
$nonum:	if .not.dodyn then goto nodyn
$	adc cmddyn=addnam,argspc,cmdprt,cpycby,cpytlw,cpytwd
$	adc cmddyn/ap=initab,savtab,seltab
$	for'fdeb' cmddyn
$	pvv cmddyn
$	lr cmddyn
$	del cmddyn.obj;*'delfor',adc.ide;*
$nodyn:	xxx:='f$verify(0)'
$grut:	set verify
$	purge/log
$	xxx:='f$verify(0)'
