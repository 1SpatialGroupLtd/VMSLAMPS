$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-11-02 16:51:26.000000000 +0000
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
$	set noverify
$!
$!MOD	Add pca						 JB  2-Nov-1993
$!MOD	Add new module CTRL_FILE.SRC			CAB 21-Aug-1990
$!MOD   Line up questions				RWR  1-Mar-1990
$!MOD   Purge .FOR and .MAP files			RWR 15-Jun-1989
$!MOD   use DISPANG from LSLLIB				RWR  5-Aug-1988
$!MOD	implement /DATUM_SHIFT
$!	allow @filename when inputing points with /POINT
$!	use NEWMSG
$!	allow plane transformations without getting MDs
$!	implement /PROJECTIVE
$!							RWR    May-1988
$!MOD	Take RWR2pt from TRANLIB.OLB			RWR 11-Jan-1988
$!MOD	Link with shareable IFFLIB and LSLLIB
$!      and implement CB handling			RWR 20-Nov-1987
$!MOD	Newmessage F(ortran) option added		ATT 14-Jan-1987
$!MOD	LINK/MAP/EXE=ITRANS added			TJH 16-Dec-1986
$!MOD	WRTCMD added					TJH 09-Dec-1986
$!MOD	Option to link with experimental LSLLIB		TJH 06-Nov-1986
$!MOD	And now it doesn't!				TJH 06-Nov-1986
$!MOD	Now optionally renames general message object
$!	to LSL$GENMSG					TJH 02-Sep-1986
$!
$	on control then goto end
$	on error then goto end
$!
$	ppp=p1+p2+p3+p4+p5+p6+p7+p8
$	len=f$length(ppp)
$	if len .eq. 0 then goto ask
$	main=0
$	blk=0
$	oby=0
$	inqa=0
$	inqb=0
$	inqc=0
$	out=0
$	fpt=0
$	pts=0
$	trn=0
$	wrt=0
$	cld=0
$	lnk=0
$	lst=0
$	dbg=0
$	mes=0
$	xpl=0
$	gctpdbg = 0
$!
$	if f$locate("DEB",ppp) 	.lt.	len then dbg=1
$	if f$locate("DBG",ppp)  .lt.    len then dbg=1
$	if f$locate("LIST",ppp) .lt.    len then lst=1
$	if f$locate("LST",ppp)  .lt.    len then lst=1
$	if f$locate("MAIN",ppp) .lt.	len then main=1
$	if f$locate("BLK",ppp)  .lt.	len then blk =1
$	if f$locate("OBY",ppp)  .lt.	len then oby=1
$	if f$locate("FPT",ppp)  .lt.	len then fpt=1
$	if f$locate("OUT",ppp)  .lt.	len then out=1
$	if f$locate("INQA",ppp)	.lt.	len then inqa =1
$	if f$locate("INQB",ppp)	.lt.	len then inqb =1
$	if f$locate("INQC",ppp)	.lt.	len then inqc =1
$	if f$locate("PTS",ppp)  .lt.	len then pts=1
$	if f$locate("TRN",ppp)  .lt.	len then trn =1
$	if f$locate("WRT",ppp)  .lt.	len then wrt =1
$	if f$locate("CLD",PPP)  .lt.    len then cld =1
$	if f$locate("LINK",ppp) .lt.	len then lnk =1
$	if f$locate("LNK",ppp)  .lt.	len then lnk =1
$	if f$locate("XPL",ppp)  .lt.	len then xpl =1
$	if f$locate("MES",ppp)  .lt.	len then mes =1
$	if f$locate("MSG",ppp)  .lt.	len then mes =1
$	if f$locate("ALL",ppp)  .eq.	len then goto process
$!
$	main=1
$	blk=1
$	oby=1
$	inqa=1
$	inqb=1
$	inqc=1
$	out=1
$	fpt=1
$	pts=1
$	trn=1
$	wrt=1
$	cld=1
$	lnk=1
$	mes=1
$	lst=0				! don't need listings
$	dbg=0				! no debug
$	goto process
$!
$ ask:
$	inquire dbg  "debug                                           "
$	inquire lst  "listings                                        "
$	inquire mes  "compile: messages                               "
$	inquire main "       : itrans, itranscexcp                    "
$	inquire blk  "       : blkdat                                 "
$	inquire oby  "       : obey,init,clsfil,ctrl_file             "
$	inquire inqa "       : askmd,askpar,askorg,askflp,initpj      "
$	inquire inqb "       : asksep,askshift                        "
$	inquire inqc "       : rdang,angqu,dmsqu,dblqu,spshlp         "
$	inquire out  "       : outmd,outshift,outcpts                 "
$	inquire fpt  "       : ask4pt,outang,outdbl                   "
$	inquire pts  "       : prcpts,eqrad,parinit,tsttrans          "
$	inquire trn  "       : trnsfrm,trans,trnuse,trnuser           "
$	inquire wrt  "       : wrtcmd,wrtmd                           "
$	inquire cld  "       : cld                                    "
$	inquire lnk  "link   "
$	inquire pca  "link with pca  "
$	inquire xpl  "experimental LSLLIB    "
$	inquire gctpdbg "debug gctplib   "
$!
$ process:
$	explsl = "lsl$library:lslshr/opt"
$	if xpl then explsl="lsl$disk:[lib.lsllib.test]lsllib/lib"
$	dbug:=
$	cdbug:=
$	list:=
$	gctp:="lsl$library:gctplib"
$	if dbg then cdbug:="/debug/noopt/check=all"
$	if dbg then dbug:="/debug"
$	if pca then dbug:="/debug=sys$library:pca$obj.obj"
$	if gctpdbg then gctp:="lsl$library:gctpdlib
$	if lst then list:="/list"
$!
$	set verify
$!
$	if .not.mes then goto nomes
$!!!!	newmessage itrans.mes itrans 1203 itrans__ n n f
$	newmsg itrans.mes/number=1203/name=itrans/prefix=ITRANS__-
	                 /param=(fortran)
$	@itrans.temp_com
$!
$nomes:	if .not.main then goto nomain
$	adc main = itrans,itransexcp
$	fort'cdbug''list' main
$	pvv main
$	delete	adc.ide;*
$	if .not.dbg then delete  main.for;*
$!
$nomain:if .not.blk then goto noblk
$	adc blkdat = blkdat
$	fort/debug/noopt blkdat
$	pvv blkdat
$	delete	adc.ide;*
$	delete  blkdat.for;*
$!
$noblk:	if .not.oby then goto nooby
$	adc obey = obey,init,clsfil,ctrl_file
$	fort'cdbug''list' obey
$	pvv obey
$	delete	adc.ide;*
$	if .not.dbg then delete  obey.for;*
$!
$nooby:	if .not.inqa then goto noinqa
$	adc inquirea = askmd,askpar,askorg,askflp,initpj
$	fort'cdbug''list' inquirea
$	pvv inquirea
$	delete	adc.ide;*
$	if .not.dbg then delete  inquirea.for;*
$!
$noinqa:if .not.inqb then goto noinqb
$	adc inquireb = asksep,askshift
$	fort'cdbug''list' inquireb
$	pvv inquireb
$	delete	adc.ide;*
$	if .not.dbg then delete  inquireb.for;*
$!
$noinqb:if .not.inqc then goto noinqc
$	adc inquirec = rdang,angqu,dmsqu,dblqu,spshlp
$	fort'cdbug''list' inquirec
$	pvv inquirec
$	delete	adc.ide;*
$	if .not.dbg then delete  inquirec.for;*
$!
$noinqc:if .not.out then goto noout
$	adc out = outmd,outshift,outcpts
$	fort'cdbug''list' out
$	pvv out
$	delete	adc.ide;*
$	if .not. dbg then delete out.for;*
$!
$noout:if .not.fpt then goto nofpt
$	adc fourpt = ask4pt,outang,outdbl
$	fort'cdbug''list' fourpt
$	pvv fourpt
$	delete	adc.ide;*
$	if .not. dbg then delete fourpt.for;*
$!
$nofpt:	if .not.pts then goto nopts
$	adc prcpts = prcpts,eqrad,parinit,tsttrans
$	fort'cdbug''list' prcpts
$	pvv prcpts
$	delete	adc.ide;*
$	if .not. dbg then delete prcpts.for;*
$!
$nopts:	if .not.trn then goto notrn
$	adc transform = trnsfrm,trans,trnuse,trnuser
$	fort'cdbug''list' transform
$	pvv transform
$	delete	adc.ide;*
$	if .not.dbg then delete transform.for;*
$!
$notrn:	if .not.wrt then goto nowrt
$	adc write = wrtcmd,wrtmd
$	fort'cdbug''list' write
$	pvv write
$	delete	adc.ide;*
$	if .not.dbg then delete write.for;*
$!
$nowrt:	if .not.cld then goto nocld
$	adc cld.tmp = itrans.cld
$	set command/object cld.tmp
$	delete adc.ide;*
$	delete cld.tmp;*
$!
$nocld:	if .not.lnk then goto prg
$!
$lnk:	adc lnk = lsl$cmniff:md2dat
$	fort/debug/noopt lnk
$	pvv lnk
$	delete	adc.ide;*
$	delete lnk.for;*
$	link'dbug'/map=itrans/exe=itrans main,blkdat,-
		obey,inquirea,inquireb,inquirec,out,prcpts,-
		transform,write,fourpt,cld,lnk,-
		itrans.promsg_obj,-
		lsl$library:lsllib.olb/include=(lsl_rddble_cmpt,lsl_rdsign),-
		'gctp'/lib,-
		lsl$library:iffshr/opt,-
		'explsl',-
		lsl$library:tranlib/lib
$!	purge/log itrans.exe
$!
$prg:	pur/log *.*obj,*.*for,*.*map
$	if lst then pur/log *.lis
$ end:	set noverify
$!
