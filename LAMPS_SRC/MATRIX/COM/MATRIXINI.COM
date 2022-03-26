$!
$	ver_status=f$verify(0)
$	on error then continue
$!
$! Command file to initialise Laser-Scan IFF Manipulation Package MATRIX
$! Add DTIFROMTEXT for version 1.1 			JB 17-Sep-1993
$!
$! Allow for differences for OpenVMS Alpha AXP
$!
$	ARCH_NAME=F$GETSYI("ARCH_NAME")
$	ARCH_SUFFIX=""
$	IF ARCH_NAME.EQS."Alpha" THEN ARCH_SUFFIX="_TV"
$!
$! If MATRIXINI ? Q then they want Quiet, so we will also
$! skip the informational bit
$!
$	if p2.eqs."Q" then goto define_symbols
$!
$! And lastly if they are on a non VT100 type terminal the reverse video
$! etc. may cause problems. Skip the informational bit.
$	if (.not.f$getdvi("TT:","TT_AVO")) then goto define_symbols
$!
$	ws="write sys$output"
$!
$!*****************************************************************
$!
$! Introduce the package with any relevant warnings of changes etc.
$!
$ ws " "
$ ws "[0m[1m=========  Initialising Laser-Scan package 'MATRIX' Version 1.1 =========="
$ ws " "
$!
$ ws "[0m[7m"
$ WS " The MATRIX modules are:                                                  "
$ ws "                                                                          "
$ ws " DTI2TEXT       DTIBLEND       DTICOMBINE      DTICONVERT        DTIEDIT  "
$ ws "                                                                          "
$ ws " DTIPATCH       DTIROTATE      DTITILE         DTITRANS          DTIVIEW  "
$ ws "                                                                          "
$ ws " DTIFROMTEXT                                                              "
$ ws "                                                                          "
$ ws "[0m"
$!
$!
$ define_symbols:
$!
$ if p1.eqs."A"
$ then
$    ver = "TEK_ARGS"
$ endif
$!
$ if p1.eqs."S"
$ then
$    ver = "SIG6000"
$ endif
$!
$ if p1.nes."A" .and. p1.nes."S"
$ then
$    if f$trnlnm("DECW$DISPLAY").nes.""
$    then
$       ver = "MOTIF"
$    else
$       ver = "UIS"
$    endif
$ endif
$!
$	DTIBLEND	:== $LSL$EXE:DTIBLEND'ARCH_SUFFIX'
$	DTIEDIT		:== $LSL$EXE:DTIEDIT'ARCH_SUFFIX'
$	DTICOMBINE	:== $LSL$EXE:DTICOMBINE'ARCH_SUFFIX'
$	DTICONVERT	:== $LSL$EXE:DTICONVERT'ARCH_SUFFIX'
$	DTIPATCH	:== $LSL$EXE:DTIPATCH'ARCH_SUFFIX'
$	DTIROTATE	:== $LSL$EXE:DTIROTATE'ARCH_SUFFIX'
$	DTITILE		:== $LSL$EXE:DTITILE'ARCH_SUFFIX'
$	DTI2TEXT	:== $LSL$EXE:DTI2TEXT'ARCH_SUFFIX'
$	DTITRANS	:== $LSL$EXE:DTITRANS'ARCH_SUFFIX'
$	DTIVIEW		:== $LSL$EXE:DTIVIEW'ver''ARCH_SUFFIX'
$	DTIFROMTEXT	:== $LSL$EXE:DTIFROMTEXT'ARCH_SUFFIX'
$!
$	if ver_status then set verify
$!
