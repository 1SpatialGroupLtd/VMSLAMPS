$!
$! Command file to link SIF2IFF program
$!
$	set noverify
$	on control then goto end
$       on error  then goto end
$!  
$! Define some symbols
$!
$	ws    := "write sys$output "
$	wsb   := "write sys$output """""
$	dbg   :=
$ 	lbug  :=
$	link_dir := "lsl$SOURCE_ROOT:[CONVERT.SIF2IFF.SRC]"
$!
$	wsb
$	inquire LNK	"Link                    "
$	if .not. LNK then goto askdel
$	inquire DBG	"   with debug           "
$	if DBG then lbug  = "/debug"
$	goto doLNK
$!
$askdel:wsb
$	goto noLNK
$!
$doLNK:
$	wsb
$	set verify
$	link'lbug'/map='link_dir'/exe='link_dir' -
			SIF2IFF,SIF2IFF_CLD,-
			GET_COMMAND,RDPAR,CONDAT,CLOSE_IFF,-
			SIF2IFF.PROMSG_OBJ,-
			LSL$LIBRARY:IFFSHR/OPT,-
			LSL$LIBRARY:LSLSHR/OPT
$!
$	set noverify
$!
$! tidy the link directory
$!
$noLNK:	
$	purge/by=dba			'link_dir'SIF2IFF.*
$	if .not. LNK then dir/by=dba	'link_dir'SIF2IFF.*
$	wsb
$end:
