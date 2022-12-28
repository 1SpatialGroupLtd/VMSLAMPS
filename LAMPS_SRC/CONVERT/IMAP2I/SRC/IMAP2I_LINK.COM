$!
$! Command file to link IMAP2I program
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
$	link_dir := "here:"
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
			IMAP2I,IMAP2I_CLD,-
			GET_COMMAND,RDPAR,GET_LIST,CONDAT,WRITE_IFF,-
			IMAP2I.PROMSG_OBJ,-
			LSL$LIBRARY:LSLFRTLIB/LIB, -
			LSL$LIBRARY:IFFSHR/OPT,-
			LSL$LIBRARY:LSLSHR/OPT,-
			STI_LIBS:DEBUGLIB/INCL=(RDBMS_ENTRY_POINTS,SET_ADDR),-
			STI_LIBS:GWSOFF/OPT,-
			STI_LIBS:STILIB/INCLUDE=(.MAIN.),-
			STI_LIBS:STILIB/LIB,-
			STI_LIBS:DBMSLIB/LIB,-
			STI_LIBS:USRLINK/OPT
$!
$	set noverify
$!
$! tidy the link directory
$!
$noLNK:	
$	purge			'link_dir'imap2i*.*
$	if .not. LNK then dir	'link_dir'imap2i*.*
$	wsb
$end:
