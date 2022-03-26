$! HELP.COM - command file to rebuild LITES2 help library
$	SAVVER='f$verify(0)
$	set noon
$	set verify
$	LIBR/HELP/CRE=(BL:100,key:24) HLP:LITES2 HLP:LITES2 
$	PURGE/LOG  HLP:LITES2.HLB
$!	'f$verify(0)
$	if savver then set verify
