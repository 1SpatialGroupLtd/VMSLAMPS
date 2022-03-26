$!
$! command file to build the TABLE_MONITOR test image for the library
$! routines
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
$	lbug   = ""
$	retfor = ""
$!
$	ws = "write sys$output"
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
$nod:	ws " "
$	inquire CMDS  "command tables         "
$	inquire TEST  "TEST                   "
$	ws " "
$!
$asklnk:inquire LNK  "link                    "
$	inquire TST  "use testing library     "
$	if      TST then lib_to_use := "lsl$disk:[tves.table.lib]tablib"
$	if .not.TST then lib_to_use := "lsl$library:tablib"
$!
$start:	set verify
$	if .not.CMP then goto dolnk
$	if .not.CMDS then goto nocmds
$	   macro'lbug' testcmd
$nocmds:if .not.TEST then goto notest
$	   adc test/co = test
$	   fort'dbug' test
$	   pvv test
$	   delete adc.ide;*
$	   if .not.RETFOR then delete test.for;*
$notest:
$dolnk:	if .not.LNK then goto end
$	   link/map'lbug'  test,testcmd,-
			   'lib_to_use'/lib,-
			   lsl$library:cmdlib/lib,-
			   lsl$library:violib/lib
$ end:	purge/log
$	set noverify
$!
$	ws " "
$	ws "Don't forget to rename TEST.EXE into [-.EXE]"
$	ws " "
$!
