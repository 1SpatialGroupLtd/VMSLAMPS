$!
$! command file to fortran the fill area functions
$!
$	set noverify
$!
$	on control then goto end
$	on error then goto end
$!
$	assign lsl$disk:[tves.sort] sortdir
$!
$! assume we don't want debug
$	dbug   = ""
$	lbug   = ""
$	retfor = ""
$	dlines = ""
$!
$! now find out what we wish to do...
$!
$	inquire DBG  "debug                   "
$	if .not.DBG then goto nod
$	   dbug = "/debug/noop"
$	   lbug = "/debug"
$	   inquire retfor "retain fortran sources  "
$	   inquire incds  "include D lines         "
$	   if incds then dlines="/d_lines"
$nod:	write sys$output " "
$	inquire HATC "Hatch, rotate       "
$	inquire FILL "Fill_area           "
$	inquire SIDE "Fill_side           "
$	inquire SORT "Heapsort, etc       "
$	inquire TEST "Test program - poly "
$	write sys$output " "
$!
$start:	set verify
$	if .not.HATC then goto nohatc
$	   adc hatch/co = hatch,rotate
$	   fort'dbug''dlines' hatch
$	   pvv hatch
$	   delete adc.ide;*
$	   if .not.RETFOR then delete hatch.for;*
$nohatc:if .not.FILL then goto nofill
$	   adc fillarea/co = fillarea
$	   fort'dbug''dlines' fillarea
$	   pvv fillarea
$	   delete adc.ide;*
$	   if .not.RETFOR then delete fillarea.for;*
$nofill:if .not.SIDE then goto noside
$	   adc fillside/co = fillside
$	   fort'dbug''dlines' fillside
$	   pvv fillside
$	   delete adc.ide;*
$	   if .not.RETFOR then delete fillside.for;*
$noside:if .not.SORT then goto nosort
$	   adc here:sort/co = sortdir:heapsort
$	   adc sort/ap = cfreal,cfside,copyreal,copyside
$	   fort'dbug' sort
$	   pvv sort
$	   delete adc.ide;*
$	   if .not.RETFOR then delete sort.for;*
$nosort:if .not.TEST then goto notest
$	   adc poly/co = poly,nrdyes
$	   fort'dbug' poly
$	   pvv poly
$	   delete adc.ide;
$	   if .not.RETFOR then delete poly.for;*
$notest:   link/map'lbug'  poly,sort,hatch, -
			   fillarea,fillside, -
			   lsl$disk:[lib.gksldlib.new2]gksldlib2/lib, -
			   lsl$library:wosplib/lib, -
			   lsl$library:vslib/lib,  -
			   lsl$library:ifflib/lib, -
			   lsl$library:violib/lib
$	purge/log
$end:	set noverify
$!
