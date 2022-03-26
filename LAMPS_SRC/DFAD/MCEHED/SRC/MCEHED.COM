$	set noverify
$!
$	on control then goto end
$	on error then goto end
$!
$! assume we don't want debug
$!
$	dbug:=
$	lbug:=
$!
$! but check this assumption...
$!
$	inquire DBG "debug"
$	if DBG then dbug:="/debug/noopt"
$!
$! now find out what we wish to do...
$!
$	inquire CMP  "Compile"
$	if .not.CMP then goto asklnk
$	inquire CMD  "command table"
$	inquire CLD  "command defns"
$	inquire MHD  "main routine      (MCEHED)"
$	inquire STRT "startup           (start,help)"
$	inquire OBY  "command line      (next,prompt,cmderr)"
$	inquire INF  "print things      (show)"
$	inquire CHNG "change things     (edit)  "
$	inquire EXTT "extract from user (ext...)"
$	inquire GETT "get via prompt    (get...)"
$	inquire MSC1 "misc1             (putstr,chk...)"
$!
$asklnk:inquire LNK  "link"
$!
$! if we are linking and have compiled with debug, then check to
$! see if we wish to link with debug...
$!
$	if .not.LNK .or. .not.DBG then goto start
$	inquire DBG "link with debug"
$	if DBG then lbug:="/debug"
$!
$start:	if .not.CMP then goto dolnk
$	set verify
$	if .not.CMD then goto nocmd
$	macro mhcmd
$!
$nocmd:	if.not.CLD then goto nocld
$	adc mcehed.tmp = mcehed_cld.cld
$	set command/object = mcehed_cld mcehed.tmp
$	pvv mcehed_cld
$	delete mcehed.tmp;*
$	delete adc.ide;*
$	purge mcehed_cld.obj
$!
$nocld:	if .not.MHD then goto nomhd
$	   adc mcehed/co = mcehed
$	   fort'dbug' mcehed
$	   pvv mcehed
$	   delete adc.ide;*
$!
$nomhd: if .not.STRT then goto nostrt
$	   adc start/co = start,help
$	   fort'dbug' start
$	   pvv start
$	   delete adc.ide;*
$!
$nostrt:if .not.OBY then goto nooby
$	   adc next/co = next,prompt,cmderr
$	   fort'dbug' next
$	   pvv next
$	   delete adc.ide;*
$!
$nooby: if .not.INF then goto noinf
$	   adc show/co = show
$	   fort'dbug' show
$	   pvv show
$	   delete adc.ide;*
$!
$noinf:	if .not.CHNG then goto nochng
$	   adc edit/co = edit
$	   fort'dbug' edit
$	   pvv edit
$	   delete adc.ide;*
$!
$nochng:if .not.EXTT then goto noext
$	   adc ext/co = extint,extstr,extang,extdat,extacc
$	   fort'dbug' ext
$	   pvv ext
$	   delete adc.ide;*
$!
$noext:	if .not.GETT then goto noget
$	   adc get/co = getint,getstr,getang,getdat,unset,getacc
$	   fort'dbug' get
$	   pvv get
$	   delete adc.ide;*
$!
$noget:	if .not.MSC1 then goto nomsc1
$	   adc msc1/co=	chkint,chkstr,chkang,putstr,rdorig,strcpy,-
			dtobin,bintod,cvtang,outang,outdat,appang,-
			appdat
$	   fort'dbug' msc1
$	   pvv msc1
$	   delete adc.ide;*
$!
$nomsc1: if .not.LNK then goto end
$!
$dolnk:	link'lbug'/cross/map mcehed,mhcmd,start,next,show,-
			edit,ext,get,msc1,mcehed_cld,-
			lsl$library:dlmslib/lib,-
			lsl$library:iffshr/opt,-
			lsl$library:lslshr/opt
$	purge/log
$ end:
$	set noverify
