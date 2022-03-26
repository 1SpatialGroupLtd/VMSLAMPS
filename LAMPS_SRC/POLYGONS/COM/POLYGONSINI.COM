$	ver_status=f$verify(0)
$	on control then continue
$	on error then continue
$!
$! Command file to initialise Laser-Scan IFF Polygons Package 'POLYGONS'
$!
$! Allow for differences for OpenVMS Alpha AXP
$!
$	ARCH_NAME=F$GETSYI("ARCH_NAME")
$	ARCH_SUFFIX=""
$	IF ARCH_NAME.EQS."Alpha" THEN ARCH_SUFFIX="_TV"
$!
$! If we are not interactive, then don't output the explanation of what
$! POLYGONS is and does
$!
$	if f$mode().nes."INTERACTIVE" then goto define_symbols
$!
$! and if they have used POLYGONSINI Q then they want Quiet, so we will also
$! skip the informational bit
$!
$	if p1.eqs."Q" then goto define_symbols
$! and lastly if they are on a non VT100 type terminal the reverse video
$! etc. may cause problems. Skip the informational bit.
$	if (.not.f$getdvi("TT:","TT_AVO")) then goto define_symbols
$!
$	ws="write sys$output"
$!
$! Introduce the package with any relevant warnings of changes etc.
$!
$ ws "[0m[1m=========  Initialising IFF polygons package 'POLYGONS' Version 2.0 ========"
$ ws " "
$!
$ ws "[0m[7m"
$ WS "The POLYGONS modules are:                                                       "
$ ws "                                                                                "
$ ws "IPOLYGON       ISTSEL       POLMERGE                                            "
$ ws "                                                                                "
$ ws "[0m"
$!
$! Define symbols for image activation
$!
$ define_symbols:
$	IPOL*YGON:==$LSL$EXE:IPOLYGON'ARCH_SUFFIX'
$	ISTSEL:==$LSL$EXE:ISTSEL'ARCH_SUFFIX'
$	POLMERGE:==$LSL$EXE:POLMERGE'ARCH_SUFFIX'
$!
$	if ver_status then set verify
