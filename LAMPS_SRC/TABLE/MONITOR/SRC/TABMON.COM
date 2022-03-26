$!
$! command file to build the TABLE_MONITOR program (TABMON)
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
$	lbug   = ""
$	retfor = ""
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
$	inquire MAIN  "TABMON                 "
$	inquire LOCK  "wrtlock,unlock         "
$	inquire POKE  "locktab,poketab        "
$	inquire SECT  "newsec                 "
$	inquire WRIT  "wrtpuck,wrtstrm,wrterr "
$	inquire WRT2  "outpuck,poppuck        "
$	inquire MACR  "table,  maksec, trnall "
$	inquire LOOP  "dotable                "
$	inquire INQU  "asktab,exp_hand_fims   "
$	inquire TAB1  "gettab, reltab, waitab "
$	inquire TAB2  "digtis,digtrn          "
$	inquire ERRS  "abandon,error          "
$	inquire SHAR  "getlock,ascefc         "
$	inquire COPY  "cpybyt,cpylng,cpytxt   "
$	inquire NMES  "get_names,sigchs       "
$	write sys$output " "
$!
$asklnk:inquire LNK  "link                    "
$!
$! if we are linking and have compiled with debug, then check to
$! see if we wish to link with debug...
$!
$	if .not.LNK .or. .not.DBG then goto start
$	inquire DBG "link with debug         "
$	if DBG then lbug:="/debug"
$!
$start:	set verify
$	if .not.CMP then goto dolnk
$	if .not.MAIN then goto nomain
$	   adc tabmon/co = tabmon
$	   fort'dbug' tabmon
$	   pvv tabmon
$	   delete adc.ide;*
$	   if .not.RETFOR then delete tabmon.for;*
$nomain:if .not.LOCK then goto nolock
$	   adc lock/co = wrtlock,unlock
$	   fort'dbug' lock
$	   pvv lock
$	   delete adc.ide;*
$	   if .not.RETFOR then delete lock.for;*
$nolock:if .not.POKE then goto nopoke
$	   adc poke/co = locktab,poketab
$	   fort'dbug' poke
$	   pvv poke
$	   delete adc.ide;*
$	   if .not.RETFOR then delete poke.for;*
$nopoke:if .not.SECT then goto nosect
$	   adc section/co = newsec
$	   fort'dbug' section
$	   pvv section
$	   delete adc.ide;*
$	   if .not.RETFOR then delete section.for;
$nosect:if .not.WRIT then goto nowrit
$	   adc write/co = wrtpuck,wrtstr,wrterr
$	   fort'dbug' write
$	   pvv write
$	   delete adc.ide;*
$	   if .not.RETFOR then delete write.for;
$nowrit:if .not.WRT2 then goto nowrt2
$	   adc write2/co = outpuck,poppuck
$	   fort'dbug' write2
$	   pvv write2
$	   delete adc.ide;*
$	   if .not.RETFOR then delete write2.for;
$nowrt2:if .not.MACR then goto nomacr
$	   macro'mbug' maksec
$	   macro'mbug' tabifc+table/object=table
$	   macro'mbug' cmn:trnall
$nomacr:if .not.LOOP then goto noloop
$	   adc loop/co = dotable
$	   fort'dbug' loop
$	   pvv loop
$	   delete adc.ide;*
$	   if .not.RETFOR then delete loop.for;
$noloop:if .not.INQU then goto noinqu
$	   adc inqu/co = asktab,exp_hand_fims
$	   fort'dbug' inqu
$	   pvv inqu
$	   delete adc.ide;*
$	   if .not.RETFOR then delete inqu.for;
$noinqu:if .not.TAB1 then goto notab1
$	   adc tab1/co = gettab,waitab,reltab
$	   fort'dbug' tab1
$	   pvv tab1
$	   delete adc.ide;*
$	   if .not.RETFOR then delete tab1.for;
$notab1:if .not.TAB2 then goto notab2
$	   adc tab2/co = digtis,digtrn
$	   fort'dbug' tab2
$	   pvv tab2
$	   delete adc.ide;*
$	   if .not.RETFOR then delete tab2.for;
$notab2:if .not.ERRS then goto noerrs
$	   adc error/co = abandon,error
$	   fort'dbug' error
$	   pvv error
$	   delete adc.ide;*
$	   if .not.RETFOR then delete error.for;
$noerrs:if .not.SHAR then goto noshar
$	   adc share/co = cmn:getlock,ascefc
$	   fort'dbug' share
$	   pvv share
$	   delete adc.ide;*
$	   if .not.RETFOR then delete share.for;
$noshar:if .not.COPY then goto nocopy
$	   adc copy/co = cmn:cpytxt,cpylng,cpybyt
$	   fort'dbug' copy
$	   pvv copy
$	   delete adc.ide;*
$	   if .not.RETFOR then delete copy.for;
$nocopy:   if .not.NMES then goto nonmes
$	   adc nmes/co = cmn:get_names,sigchs
$	   fort'dbug' nmes
$	   pvv nmes
$	   delete adc.ide;*
$	   if .not.RETFOR then delete nmes.for;
$nonmes:
$dolnk:	if .not.LNK then goto end
	link'lbug'/cross/map TABMON,lock,poke,section,write,write2,-
			maksec,table,trnall,-
			loop,inqu,tab1,tab2,error,share,copy,nmes,-
			lsl$source_root:[table.buffer]buflib/lib,-
			lsl$library:cmdlib/lib,-
			lsl$library:violib/lib
$	purge/log
$ end:	set noverify
$
