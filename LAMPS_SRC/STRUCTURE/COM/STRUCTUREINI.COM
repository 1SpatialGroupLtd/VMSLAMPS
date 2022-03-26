$!
$! STRUCTUREINI.COM - Command file to set up STRUCTURE package commands
$!
$! Allow for differences for OpenVMS Alpha AXP
$!
$	ARCH_NAME=F$GETSYI("ARCH_NAME")
$	ARCH_SUFFIX=""
$	IF ARCH_NAME.EQS."Alpha" THEN ARCH_SUFFIX="_TV"
$!
$! now the symbols
$!
$	ILINK	:== $LSL$EXE:ILINK'ARCH_SUFFIX'		! structure generator
$	RELHT	:== $LSL$EXE:RELHT'ARCH_SUFFIX'		! relative heighting
$	ICASE	:== $LSL$EXE:ICASE'ARCH_SUFFIX'		! road casing generator
$!
