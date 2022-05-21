$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1989-12-16 13:49:38.000000000 +0000
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
$! command file to build the TABLE_MONITOR library routines (TABLIB)
$!
$	set noverify
$!
$! set up where we keep our common files
$!
$	assign	lsl$source_root:[table.shared]  cmn
$!
$	on control then goto end
$	on error then goto end
$!
$! assume we don't want debug
$	dbug   = ""
$	mbug   = ""
$	retfor = ""
$!
$	oldLIB = 0
$	newLIB = 0
$!
$! now find out what we wish to do...
$!
$	inquire CMP  "compile                 "
$	inquire DBG  "debug                   "
$	if .not.CMP then goto asklnk
$	if .not.DBG then goto nod
$	   dbug = "/debug/noop"
$	   mbug = "/debug"
$	   inquire retfor "retain fortran sources  "
$nod:	write sys$output " "
$	inquire INIT  "init,stop,resume,close "
$	inquire READ  "rdstr,rdpuck,rderr     "
$	inquire PROB  "rdtable,asktab         "
$	inquire LOCK  "unlock,rdlock,wrtlock  "
$	inquire SETE  "haderr,hadpuck,hadstr  "
$	inquire WAIT  "wait for tab,puck,str  "
$	inquire CPTS  "hadcpts,wrtcpts,rdcpts "
$	inquire STAT  "check,locktab,relocktab"
$	inquire MISC  "retefn                 "
$	inquire MACR  "havarg,trnall          "
$	inquire SYMB  "symbols for check      "
$	inquire STUF  "stuff from SHARED      "
$	write sys$output " "
$!
$asklnk:inquire newLIB  "make a new library      "
$	if .not.newLIB then inquire oldLIB "replace in library      "
$!
$start:	set verify
$	if .not.CMP then goto dolib
$	if .not.INIT then goto noinit
$	   adc tabini/co = initab,stoptab,restab,clotab
$	   fort'dbug' tabini
$	   pvv tabini
$	   delete adc.ide;*
$	   if .not.RETFOR then delete tabini.for;*
$	   if oldLIB then library tablib/replace tabini
$noinit:if .not.READ then goto noread
$	   adc read/co = rdstr,rdpuck,rderr
$	   fort'dbug' read
$	   pvv read
$	   delete adc.ide;*
$	   if .not.RETFOR then delete read.for;*
$	   if oldLIB then library tablib/replace read
$noread:if .not.PROB then goto noprob
$	   adc prob/co = asktab,rdtable
$	   fort'dbug' prob
$	   pvv prob
$	   delete adc.ide;*
$	   if .not.RETFOR then delete prob.for;*
$	   if oldLIB then library tablib/replace prob
$noprob:if .not.LOCK then goto nolock
$	   adc lock/co = unlock,rdlock,wrtlock
$	   fort'dbug' lock
$	   pvv lock
$	   delete adc.ide;*
$	   if .not.RETFOR then delete lock.for;*
$	   if oldLIB then library tablib/replace lock
$nolock:if .not.SETE then goto nosete
$	   adc sete/co = haderr,hadpuck,hadstr
$	   fort'dbug' sete
$	   pvv sete
$	   delete adc.ide;*
$	   if .not.RETFOR then delete sete.for;*
$	   if oldLIB then library tablib/replace sete
$nosete:if .not.WAIT then goto nowait
$	   adc wait/co = waittab,waitpuck,waitstr
$	   fort'dbug' wait
$	   pvv wait
$	   delete adc.ide;*
$	   if .not.RETFOR then delete wait.for;*
$	   if oldLIB then library tablib/replace wait
$nowait:if .not.CPTS then goto nocpts
$	   adc cpts/co = hadcpts,rdcpts,wrtcpts
$	   fort'dbug' cpts
$	   pvv cpts
$	   delete adc.ide;*
$	   if .not.RETFOR then delete cpts.for;*
$	   if oldLIB then library tablib/replace cpts
$nocpts:if .not.STAT then goto nostat
$	   adc state/co = check,locktab,relocktab
$	   fort'dbug' state
$	   pvv state
$	   delete adc.ide;*
$	   if .not.RETFOR then delete state.for;*
$	   if oldLIB then library tablib/replace state
$nostat:if .not.MISC then goto nomisc
$	   adc misc/co = retefn
$	   fort'dbug' misc
$	   pvv misc
$	   delete adc.ide;*
$	   if .not.RETFOR then delete misc.for;*
$	   if oldLIB then library tablib/replace wait
$nomisc:if .not.MACR then goto nomacr
$	   macro'mbug' havarg
$	   if oldLIB then library tablib/replace havarg
$	   macro'mbug' cmn:trnall
$	   if oldLIB then library tablib/replace trnall
$nomacr:if .not.SYMB then goto nosymb
$	   macro'mbug' checksym
$	   if oldLIB then library tablib/replace checksym/selective_search
$nosymb:if .not.STUF then goto nostuf
$	   adc stuff/co = cmn:ascefc,getlock,cpytxt,cpylng,cpybyt,-
				get_names,sigchs
$	   fort'dbug' stuff
$	   pvv stuff
$	   delete adc.ide;*
$	   if .not.RETFOR then delete stuff.for;
$	   if oldLIB then library tablib/replace stuff
$nostuf:
$dolib:	if .not.newLIB then goto end
$	   library tablib/create
$	   library tablib/insert tabini,read,lock,wait,cpts,state
$	   library tablib/insert misc,havarg,trnall,sete,stuff,prob
$	   library tablib/insert checksym/selective_search
$end:	purge/log
$	set noverify
$!
