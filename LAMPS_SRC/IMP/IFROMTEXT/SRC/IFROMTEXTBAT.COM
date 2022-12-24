$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-12-16 11:02:02.000000000 +0000
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
$	set noverify
$	on control_y then goto ifromtextex
$	if "''f$logical("lsl$ifromtext_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "Someone else is building"
$	exit
$!
$ a0:	define/group lsl$ifromtext_building "in_progress"
$	assign lsl$source_root:[imp.ifromtext] lsl$cmnifromtext
$	sd:=$lsl$sys:sd
$	set noon
$	emsg=""
$ 	set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 	set verify
$	newmsg/number=1217/name=ifrom/prefix=ifrom__/parameter=for ifromtext.mes
$	@ifromtext.temp_com
$	rename ifromtextmsg.par ifrommsg.par
$ 	adc ifromtext.tmp=ifromtext.cld
$ 	set command/object=ifromtext_cld ifromtext.tmp
$ 	ok=$status
$ 	if ok then pvv ifromtext_cld
$ 	if ok then delete ifromtext.tmp;*
$ 	if ok then purge/nolog ifromtext_cld.obj
$	macro'macdbg'/object=t2iecd t2iecd
$	ok=$status
$	pur/nolog t2iecd.obj
$	if .not.ok then emsg=emsg+" mACRO-t2iecd"
$	macro'macdbg'/object=t2imcd t2imcd
$	ok=$status
$	pur/nolog t2imcd.obj
$	if .not.ok then emsg=emsg+" mACRO-t2imcd"
$	macro'macdbg'/object=t2icbc t2icbc
$	ok=$status
$	pur/nolog t2icbc.obj
$	if .not.ok then emsg=emsg+" mACRO-t2icbc"
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc IFROMTEXT=IFROMTEXT
$	fort IFROMTEXT
$ 	ok=$status
$ 	if ok then pvv IFROMTEXT
$ 	purge/nolog IFROMTEXT.obj
$ 	delete/nolog IFROMTEXT.for;*
$	if .not.ok then emsg=emsg+" IFROMTEXT"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2ICOM=T2ICOM
$	fort T2ICOM
$ 	ok=$status
$ 	if ok then pvv T2ICOM
$ 	purge/nolog T2ICOM.obj
$ 	delete/nolog T2ICOM.for;*
$	if .not.ok then emsg=emsg+" T2ICOM"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2ICON=T2ICON
$	fort T2ICON
$ 	ok=$status
$ 	if ok then pvv T2ICON
$ 	purge/nolog T2ICON.obj
$ 	delete/nolog T2ICON.for;*
$	if .not.ok then emsg=emsg+" T2ICON"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2ICOR=T2ICOR
$	fort T2ICOR
$ 	ok=$status
$ 	if ok then pvv T2ICOR
$ 	purge/nolog T2ICOR.obj
$ 	delete/nolog T2ICOR.for;*
$	if .not.ok then emsg=emsg+" T2ICOR"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2IFEA=T2IFEA
$	fort T2IFEA
$ 	ok=$status
$ 	if ok then pvv T2IFEA
$ 	purge/nolog T2IFEA.obj
$ 	delete/nolog T2IFEA.for;*
$	if .not.ok then emsg=emsg+" T2IFEA"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2IFIL=T2IFIL
$	fort T2IFIL
$ 	ok=$status
$ 	if ok then pvv T2IFIL
$ 	purge/nolog T2IFIL.obj
$ 	delete/nolog T2IFIL.for;*
$	if .not.ok then emsg=emsg+" T2IFIL"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2IIGN=T2IIGN
$	fort T2IIGN
$ 	ok=$status
$ 	if ok then pvv T2IIGN
$ 	purge/nolog T2IIGN.obj
$ 	delete/nolog T2IIGN.for;*
$	if .not.ok then emsg=emsg+" T2IIGN"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2IINF=T2IINF
$	fort T2IINF
$ 	ok=$status
$ 	if ok then pvv T2IINF
$ 	purge/nolog T2IINF.obj
$ 	delete/nolog T2IINF.for;*
$	if .not.ok then emsg=emsg+" T2IINF"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2IINT=T2IINT
$	fort T2IINT
$ 	ok=$status
$ 	if ok then pvv T2IINT
$ 	purge/nolog T2IINT.obj
$ 	delete/nolog T2IINT.for;*
$	if .not.ok then emsg=emsg+" T2IINT"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2ILIN=T2ILIN
$	fort T2ILIN
$ 	ok=$status
$ 	if ok then pvv T2ILIN
$ 	purge/nolog T2ILIN.obj
$ 	delete/nolog T2ILIN.for;*
$	if .not.ok then emsg=emsg+" T2ILIN"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2ILNF=T2ILNF
$	fort T2ILNF
$ 	ok=$status
$ 	if ok then pvv T2ILNF
$ 	purge/nolog T2ILNF.obj
$ 	delete/nolog T2ILNF.for;*
$	if .not.ok then emsg=emsg+" T2ILNF"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2ILON=T2ILON
$	fort T2ILON
$ 	ok=$status
$ 	if ok then pvv T2ILON
$ 	purge/nolog T2ILON.obj
$ 	delete/nolog T2ILON.for;*
$	if .not.ok then emsg=emsg+" T2ILON"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2IMAP=T2IMAP
$	fort T2IMAP
$ 	ok=$status
$ 	if ok then pvv T2IMAP
$ 	purge/nolog T2IMAP.obj
$ 	delete/nolog T2IMAP.for;*
$	if .not.ok then emsg=emsg+" T2IMAP"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2IMDN=T2IMDN
$	fort T2IMDN
$ 	ok=$status
$ 	if ok then pvv T2IMDN
$ 	purge/nolog T2IMDN.obj
$ 	delete/nolog T2IMDN.for;*
$	if .not.ok then emsg=emsg+" T2IMDN"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2IMH3=T2IMH3
$	fort T2IMH3
$ 	ok=$status
$ 	if ok then pvv T2IMH3
$ 	purge/nolog T2IMH3.obj
$ 	delete/nolog T2IMH3.for;*
$	if .not.ok then emsg=emsg+" T2IMH3"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2IMHT=T2IMHT
$	fort T2IMHT
$ 	ok=$status
$ 	if ok then pvv T2IMHT
$ 	purge/nolog T2IMHT.obj
$ 	delete/nolog T2IMHT.for;*
$	if .not.ok then emsg=emsg+" T2IMHT"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2INXT=T2INXT
$	fort T2INXT
$ 	ok=$status
$ 	if ok then pvv T2INXT
$ 	purge/nolog T2INXT.obj
$ 	delete/nolog T2INXT.for;*
$	if .not.ok then emsg=emsg+" T2INXT"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2IOVE=T2IOVE
$	fort T2IOVE
$ 	ok=$status
$ 	if ok then pvv T2IOVE
$ 	purge/nolog T2IOVE.obj
$ 	delete/nolog T2IOVE.for;*
$	if .not.ok then emsg=emsg+" T2IOVE"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2IREA=T2IREA
$	fort T2IREA
$ 	ok=$status
$ 	if ok then pvv T2IREA
$ 	purge/nolog T2IREA.obj
$ 	delete/nolog T2IREA.for;*
$	if .not.ok then emsg=emsg+" T2IREA"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2IDATE=T2IDATE
$	fort T2IDATE
$ 	ok=$status
$ 	if ok then pvv T2IDATE
$ 	purge/nolog T2IDATE.obj
$ 	delete/nolog T2IDATE.for;*
$	if .not.ok then emsg=emsg+" T2IDATE"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2ITIME=T2ITIME
$	fort T2ITIME
$ 	ok=$status
$ 	if ok then pvv T2ITIME
$ 	purge/nolog T2ITIME.obj
$ 	delete/nolog T2ITIME.for;*
$	if .not.ok then emsg=emsg+" T2ITIME"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2ICHAR=T2ICHAR
$	fort T2ICHAR
$ 	ok=$status
$ 	if ok then pvv T2ICHAR
$ 	purge/nolog T2ICHAR.obj
$ 	delete/nolog T2ICHAR.for;*
$	if .not.ok then emsg=emsg+" T2ICHAR"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2IREAL8=T2IREAL8
$	fort T2IREAL8
$ 	ok=$status
$ 	if ok then pvv T2IREAL8
$ 	purge/nolog T2IREAL8.obj
$ 	delete/nolog T2IREAL8.for;*
$	if .not.ok then emsg=emsg+" T2IREAL8"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2ISEC=T2ISEC
$	fort T2ISEC
$ 	ok=$status
$ 	if ok then pvv T2ISEC
$ 	purge/nolog T2ISEC.obj
$ 	delete/nolog T2ISEC.for;*
$	if .not.ok then emsg=emsg+" T2ISEC"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2ISEP=T2ISEP
$	fort T2ISEP
$ 	ok=$status
$ 	if ok then pvv T2ISEP
$ 	purge/nolog T2ISEP.obj
$ 	delete/nolog T2ISEP.for;*
$	if .not.ok then emsg=emsg+" T2ISEP"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2ISKP=T2ISKP
$	fort T2ISKP
$ 	ok=$status
$ 	if ok then pvv T2ISKP
$ 	purge/nolog T2ISKP.obj
$ 	delete/nolog T2ISKP.for;*
$	if .not.ok then emsg=emsg+" T2ISKP"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2ISTR=T2ISTR
$	fort T2ISTR
$ 	ok=$status
$ 	if ok then pvv T2ISTR
$ 	purge/nolog T2ISTR.obj
$ 	delete/nolog T2ISTR.for;*
$	if .not.ok then emsg=emsg+" T2ISTR"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2ITST=T2ITST
$	fort T2ITST
$ 	ok=$status
$ 	if ok then pvv T2ITST
$ 	purge/nolog T2ITST.obj
$ 	delete/nolog T2ITST.for;*
$	if .not.ok then emsg=emsg+" T2ITST"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2ICB=T2ICB
$	fort T2ICB
$ 	ok=$status
$ 	if ok then pvv T2ICB
$ 	purge/nolog T2ICB.obj
$ 	delete/nolog T2ICB.for;*
$	if .not.ok then emsg=emsg+" T2ICB"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2IACD=T2IACD
$	fort T2IACD
$ 	ok=$status
$ 	if ok then pvv T2IACD
$ 	purge/nolog T2IACD.obj
$ 	delete/nolog T2IACD.for;*
$	if .not.ok then emsg=emsg+" T2IACD"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2ILONACD=T2ILONACD
$	fort T2ILONACD
$ 	ok=$status
$ 	if ok then pvv T2ILONACD
$ 	purge/nolog T2ILONACD.obj
$ 	delete/nolog T2ILONACD.for;*
$	if .not.ok then emsg=emsg+" T2ILONACD"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2ICB_OUTPUT=T2ICB_OUTPUT
$	fort T2ICB_OUTPUT
$ 	ok=$status
$ 	if ok then pvv T2ICB_OUTPUT
$ 	purge/nolog T2ICB_OUTPUT.obj
$ 	delete/nolog T2ICB_OUTPUT.for;*
$	if .not.ok then emsg=emsg+" T2ICB_OUTPUT"
$ 	delete adc.ide;*
$	set noverify
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$ 	adc T2ICB_MISSING=T2ICB_MISSING
$	fort T2ICB_MISSING
$ 	ok=$status
$ 	if ok then pvv T2ICB_MISSING
$ 	purge/nolog T2ICB_MISSING.obj
$ 	delete/nolog T2ICB_MISSING.for;*
$	if .not.ok then emsg=emsg+" T2ICB_MISSING"
$ 	delete adc.ide;*
$	set noverify
$	set noverify
$	if emsg.eqs."" then goto noerr
$	write sys$output "&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"
$	write sys$output "Compilation errors in:"
$	write sys$output emsg
$	write sys$output "&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"
$	goto nolnk
$	noerr:
$	write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$	link/map/cross/exe=ifromtext -
	ifromtext,ifromtext_cld, -
	t2iecd,t2imcd,t2icbc,t2icb_output,t2icb_missing,-
	t2icom,t2icon,t2icor,t2ifea,-
	t2ifil,t2iign,t2iinf,t2iint,t2ilin,-
	t2ilnf,t2ilon,t2imap,t2imdn,t2imh3,t2imht,t2ilonacd,-
	t2inxt,t2iove,t2irea,t2ireal8,t2isec,t2isep,t2iacd,-
	t2iskp,t2istr,t2itst,t2icb,t2idate,t2itime,t2ichar,-
	ifromtext.promsg_obj,-
    lsl$library:osmhlib/lib,-
    lsl$library:lslfrtlib/lib,-
    lsl$library:iffshr/opt,-
    lsl$library:lslshr/opt
$	ifromtextex:
$ 	deass/group lsl$ifromtext_building
$ 	set nover
