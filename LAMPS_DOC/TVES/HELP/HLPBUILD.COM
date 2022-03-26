$	set noverify
$!
$! command file: HLPBUILD - command file to create the TVES help library
$!
$! Copyright (C) LaserScan Laboratories Ltd, Cambridge, England  1988
$!
$! Author 					Adrian Bennetton June 1988
$! Modified for tves				MWSR	17-Jan-1989
$! modified not to copy to LSL$HELP:		PGH	22-Mar-1990
$!
$!
$	on control_y then goto tidy_exit
$	on error     then goto tidy_exit
$!
$	ws	= "write sys$output"
$!
$! *************************************************************************
$! We are creating a library from scratch, so we shall create a single .HLP
$! file from the various bits, and then convert it to a .HLB. 
$!
$compilation:
$!
$	ws "Creating temporary .HLP file"
$	create tves_tmp.hlp
$	append		tves.hlp         tves_tmp.hlp
$	append		cover.hlp	 tves_tmp.hlp
$	append		i2grid.hlp	 tves_tmp.hlp
$	append		dticontour.hlp	 tves_tmp.hlp
$	append		dticheck.hlp	 tves_tmp.hlp
$	append		profile.hlp	 tves_tmp.hlp
$	append		rover.hlp	 tves_tmp.hlp
$	append		slopes.hlp	 tves_tmp.hlp
$	append		vectorise.hlp	 tves_tmp.hlp
$
$	ws "Creating .HLB file"
$	librarian/help/create/log tves.hlb tves_tmp.hlp
$!
$	ws ""
$	ws "Now try it and see if it works"
$	ws ""
$	define/user sys$input sys$command:
$	help/library=lsl$doc_root:[tves.help]tves.hlb TVES
$!
$	ws ""
$	ws "Now use the PUBLISH procedure to put this library in use"
$	ws ""
$!
$! *************************************************************************
$! come here for a tidy exit
$!
$tidy_exit:
$	set noverify
$	purge  tves.hlb
$	delete tves_tmp.hlp;*
$	exit
