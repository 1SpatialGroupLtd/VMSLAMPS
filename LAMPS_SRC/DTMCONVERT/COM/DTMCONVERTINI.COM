$!
$	ver_status=f$verify(0)
$	on error then goto finish
$	on control_y then goto finish
$!
$! Command file to initialise Laser-Scan DTM Manipulation Package 'DTMCONVERT'
$!
$! Allow for differences for OpenVMS Alpha AXP
$!
$	ARCH_NAME=F$GETSYI("ARCH_NAME")
$	ARCH_SUFFIX=""
$	IF ARCH_NAME.EQS."Alpha" THEN ARCH_SUFFIX="_TV"
$!
$! If we are not interactive, then don't output the explanation of what
$! DTMCONVERT is and does
$!
$	if f$mode().nes."INTERACTIVE" then goto no_explanation
$!
$! And if they have used DTMCONVERTINI Q then they want Quiet, so we will also
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
"=======  Initialising DTM conversion package 'DTMCONVERT' Version 1.8  ========"
$ ws " "
$!
$ ws "[0m[7m"
$ ws "The DTMCONVERT modules are  :                                                   "
$ ws "                                                                                "
$ ws "     DTED2DTI               DTI2DTED                 DTEDIFF                    "
$ ws "     IIS2DTI                DTI2IIS                                             "
$ ws "     DEM2DTI                DTI2DEM                                             "
$ ws "     NTF2DTI                DTI2NTF                                             "
$ ws "     MNT2DTI                                                                    "
$ ws "                                                                                "
$ ws "[0m"
$!
$! Define symbols for image activation, and logical names
$!
$no_explanation:
$!
$! Define symbols for image activation
$!
$ define_symbols:
$	DTED2DTI	:==	$LSL$EXE:DTED2DTI'ARCH_SUFFIX'
$	DTI2DTED	:==	$LSL$EXE:DTI2DTED'ARCH_SUFFIX'
$	DTEDIFF		:==	$LSL$EXE:DTEDIFF'ARCH_SUFFIX'
$	IIS2DTI		:==	$LSL$EXE:IIS2DTI'ARCH_SUFFIX'
$	DTI2IIS		:==	$LSL$EXE:DTI2IIS'ARCH_SUFFIX'
$	DEM2DTI		:==	$LSL$EXE:DEM2DTI'ARCH_SUFFIX'
$	DTI2DEM		:==	$LSL$EXE:DTI2DEM'ARCH_SUFFIX'
$	NTF2DTI		:==	$LSL$EXE:NTF2DTI'ARCH_SUFFIX'
$	DTI2NTF		:==	$LSL$EXE:DTI2NTF'ARCH_SUFFIX'
$	MNT2DTI		:==	$LSL$EXE:MNT2DTI'ARCH_SUFFIX'
$!
$ finish:
$	exit
$!
