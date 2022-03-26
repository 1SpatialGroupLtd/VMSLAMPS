$	ver_status=f$verify(0)
$	set noon
$	on control_y then continue
$!
$! Command file to initialise Laser-Scan Package 'DOCUMENT'
$!
$! if we are not interactive, then don't output the explanation of what
$! DOCUMENT is and does
$!
$	if f$mode().nes."INTERACTIVE" then goto no_explanation
$!
$! and if they have used DOCINI Q then they want Quiet, so we will also
$! skip the informational bit
$!                                
$	if p1.eqs."Q" then goto no_explanation
$!
$! and lastly if they are on a non VT100 type terminal the reverse video
$! etc. may cause problems. Skip the informational bit.
$!
$	if (.not.f$getdvi("TT:","TT_AVO")) then goto no_explanation
$!
$	ws="write sys$output"
$!
$! Introduce the package with any relevant warnings of changes etc.
$!
$ ws "[0m[1m"+ -
"====  Initialising standard documentation package 'DOCUMENT' Version 1.0  ===="
$!
$ ws "[0m[7m"
$ ws "The DOCUMENT package contains:                                                  "
$ ws "                                                                                "
$ ws "Procedure               Function                                                "
$ ws "                                                                                "
$ ws "DOCUMENT                The documentation environment - uses all the following  "
$ ws "DOCRNO                  Runoff simple .RNO files                                "
$ ws "STANDARD_RNO            Runoff standard (chapter oriented) documentation        "
$ ws "STANDARD_CREATE         Create a new standard document                          "
$ ws "                                                                                "
$ ws "OLD_DOCUMENT            The old documentation environment                       "
$ ws "                                                                                "
$ ws "Logical names:          LSL$DOC_TEMPLATE                                        "
$ ws "                        LSL$DOC_RESOURCES                                       "
$ ws "                        LSL$DOC_COMMAND                                         "
$ ws "[0m"
$!
$! Define symbols and ( logical names now done in LSDEFNS)
$!
$no_explanation:
$!
$!!!	define  LSL$DOC_TEMPLATE  lsl$doc_root:[document.template]
$!!!	define  LSL$DOC_RESOURCES  lsl$doc_root:[document.resources]
$!!!	define  LSL$DOC_COMMAND   lsl$doc_root:[document.command]
$!
$	old_doc*ument   == "@lsl$dochdr:document"
$!
$     	doc*ument	== "@lsl$doc_command:document"
$	docrno		== "@lsl$doc_command:docrno"
$	standard_rno	== "@lsl$doc_command:standard_rno"
$	standard_create	== "@lsl$doc_command:standard_create"
$!
$	if ver_status then set verify
