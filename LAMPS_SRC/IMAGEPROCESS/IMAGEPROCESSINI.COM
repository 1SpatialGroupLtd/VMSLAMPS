$!
$! Created 10AU87   by DRC.
$! Mod     20DE90   by J Barber for ver 1.1
$!
$	ver_status=f$verify(0)
$	on control then continue
$	on error then continue
$!
$! Command file to initialise Laser-Scan Image Processing Package 
$! 'IMAGEPROCESS'
$!
$! if we are not interactive, then don't output the explanation of what
$! IMAGEPROCESS is and does
$!
$	if f$mode().nes."INTERACTIVE" then goto define_symbols
$!
$! and if they have used IMAGEPROCESSINI Q then they want Quiet, so we will also
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
$ ws "[0m[1m====== Initialising Image Processing Package ====="
$ ws "[0m[1m======       IMAGEPROCESS Version 1.1        ====="
$ ws " "
$!
$ ws "[0m[7m"
$ WS "The IMAGEPROCESS modules are:                                                   "
$ ws "                                                                                "
$ WS "READCCT     DTIFILTER     SRP2DTI     RCPEDT     TRANSP                         "
$ ws "                                                                                "
$ ws "[0m"
$!
$! Define symbols for image activation
$!
$ define_symbols:
$	READCCT   :==$LSL$EXE:READCCT
$	DTIFILTER :==$LSL$EXE:DTIFILTER
$	SRP2DTI   :==$LSL$EXE:SRP2DTI
$	RCPEDT    :==$LSL$EXE:RCPEDT
$	TRANSP    :==$LSL$EXE:TRANSP
$!
$	if ver_status then set verify
$!
