$!
$! command file to build the circular buffer test image
$!
$	set noverify
$!
$	on control then goto end
$	on error then goto end
$!
$! assume we don't want debug
$	dbug   = ""
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
$	   lbug = "/debug"
$	   inquire retfor "retain fortran sources  "
$nod:	write sys$output " "
$	inquire CMDS  "command tables         "
$	inquire TEST  "BUFFER - test program  "
$	inquire EVRY  "everything else        "
$	write sys$output " "
$!
$asklnk:inquire newLIB "Build  new library"
$!
$start:	set verify
$	if .not.CMP then goto dolib
$	if .not.CMDS then goto nocmds
$!
$	   macro'lbug' bufcmd
$!
$nocmds:if .not.TEST then goto notest
$!
$	   adc buffer/co    = buffer
$	   fort'dbug' buffer
$	   pvv buffer
$	   delete adc.ide;*
$	   if .not.RETFOR then delete buffer.for;*
$!
$notest:if .not.EVRY then goto noevry
$!
$	   adc routines/co    = read,write,get,put,init
$	   adc routines/ap/co = gotroom,gotchar,display
$	   fort'dbug' routines
$	   pvv routines
$	   delete adc.ide;*
$	   if .not.RETFOR then delete routines.for;*
$!
$noevry:if .not.TEST .and. .not.CMDS then goto dolib
$!
$	   link/map'lbug'  buffer,bufcmd,routines,-
			   lsl$library:cmdlib/lib,-
			   lsl$library:violib/lib
$!
$dolib:	if .not.newLIB then goto end
$!
$	library/create	BUFLIB
$	library/insert	BUFLIB routines
$!
$ end:	purge/log
$	set noverify
$!
