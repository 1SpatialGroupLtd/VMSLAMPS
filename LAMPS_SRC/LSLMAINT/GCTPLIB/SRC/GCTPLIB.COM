$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1996-10-11 14:16:56.000000000 +0100
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
$! Build GCTPLIB.OLB
$!
$! Modified: Add modules PJ31$0 and PJ31$1 (WI/CC 1500)         TJM 22-Jun-1995
$!
$	ver='f$verify(0)
$	nover=0
$	maxcount = 20			! 21 and 22 are not part of gctplib
$	on error then goto end
$!
$	gctpl="here:gctplib"
$	debf =""			! not debug files
$	inquire debug "Debug"
$	if .not.debug then debug=""
$	if      debug then debug="/debug"
$	if	debug.nes.""  then gctpl ="here:gctpdlib"
$	if	debug.nes.""  then debf="d"
$	optim=1
$	if debug .nes. "" then inquire optim "Without optimisation"
$	if optim then debug=debug + "/noopt"
$	checks = 0
$	if debug .nes. "" then inquire checks "Checks"
$	if checks then debug=debug + "/check=(bounds,overflow)"
$
$	inquire new	"Create new library"
$	rep=0
$	if .not.new then inquire rep	"Replace in library"
$	if .not.new then goto nonew
$	  set verify
$	  library 'gctpl'/create=(blocks:20)
$	  if ver.ne.1 then set noverify
$nonew:
$!
$	mod0="gctpex,darsincos,gtrnerr,sphd$0"
$	mod1="gtrn$0,gtp$0,gtpblk,gctp_cf_proj"
$	mod2="dmsp$0,pakd$0,pakr$0,paks$0,radd$0"
$	mod3="adjl$0,mlfn$0,msfn$0,qsfn$0,tsfn$0,untf$0"
$	mod4="e0fn$0,e1fn$0,e2fn$0,e3fn$0"
$	mod5="phi1$0,phi2$0,phi3$0,phi4$0"
$	mod6="al01$0,al29$0"
$!
$	mod7="pj1a$0,pj01$0,pj02$0,pj03$0"
$	mod8="pj04$0,pj05$0,pj06$0,pj07$0,pj08$0,pj09$0"
$	mod9="pj10$0,pj11$0,pj12$0,pj13$0,pj14$0,pj15$0"
$	mod10="pj16$0,pj17$0,pj18$0,pj19$0,pj20$0,pj21$0"
$	mod11="pj22$0,pj23$0,pj24$0,pj25$0,pj26$0,pj27$0"
$	mod12="pj28$0,pj29$0,pj30$0,pj31$0"
$!
$	mod13="pj1a$1,pj01$1,pj02$1,pj03$1"
$	mod14="pj04$1,pj05$1,pj06$1,pj07$1,pj08$1,pj09$1"
$	mod15="pj10$1,pj11$1,pj12$1,pj13$1,pj14$1,pj15$1"
$	mod16="pj16$1,pj17$1,pj18$1,pj19$1,pj20$1,pj21$1"
$	mod17="pj22$1,pj23$1,pj24$1,pj25$1,pj26$1,pj27$1"
$	mod18="pj28$1,pj29$1,pj30$1,pj31$1"
$!
$	mod19="datum_shift,rho,nu,newton2d,congeog,geogcon"
$	mod20="gctp_print,gctp_parinit,gctp_eqrad,gctp_trans"
$!
$	mod21="acca$0,accn$0,eigh$0,proj$0"
$	mod22="rgnt$0,tnfm$0,tnsp$0"
$	count=0
$ a:
$	ans'count'=1
$	count=count+1
$	if count.le.maxcount then goto a
$!
$	inquire  all	"Compile all modules"
$	if all then goto compile
$!
$	count=0
$ aa:	
$	ans'count'=0
$	count=count+1
$	if count.le.maxcount then goto aa
$!
$	count=0
$	on control_y then goto compile
$ nxtmod:
$	xxx=mod'count'
$	if count.gt.0 then goto notxt
$	inquire/nop  ans'count' "Compile: ''xxx'  ? "
$	goto nxtone
$ notxt:
$	inquire/nop ans'count'  "         ''xxx'  ? "
$ nxtone:
$	count=count+1
$	if count.le.maxcount then goto nxtmod
$!
$ compile:
$	on control_y then goto end
$	count=0
$ aaa:
$	if .not.ans'count' then goto nxtc
$	  xxx=mod'count'
$	  yyy:=file'debf''count'
$	  set verify
$	  adc 'yyy'='xxx'
$	  fort'debug' 'yyy'
$!	  pvv 'yyy'
$	  if rep.or.new then library 'gctpl'/rep/log 'yyy'
$	  if "''debug'".eqs."" then delete/log 'yyy'.for;*
$	  if "''debug'".nes."" then if f$search("*.for;-1").nes."" then -
	  purge/log 'yyy'.for
$	  if ver.ne.1 then set noverify
$	  if f$search("adc.ide").nes."" then delete adc.ide;*
$ nxtc:
$	count=count+1
$	if count.le.maxcount then goto aaa
$!
$	purge/log *.obj
$	if f$search("'gtcpl'").nes."" then purge/log 'gtcpl'.olb
$	if new.or.rep then delete/log *.obj;*
$end:
$	if ver.eq.1 then set verify
$!
