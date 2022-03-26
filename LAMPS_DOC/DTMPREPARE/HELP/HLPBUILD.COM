$!	set noverify
$!
$! command file: HLPBUILD - command file to create or update the DTMPREPARE
$!			   standard help library
$!
$! Copyright (C) LaserScan Laboratories Ltd, Cambridge, England  1988
$!
$! MOD Invitation to copy .HLB directly to LSL$HELP removed! TJH 21-May-1990
$! Author 					Adrian Bennetton June 1988
$!
$!
$	assign  'f$logical("HERE")  start_directory
$!
$	on control_y then goto tidy_exit
$	on error     then goto tidy_exit
$!
$	ws	= "write sys$output"
$	wsb	= "write sys$output """""
$	inq	= "inquire"
$!
$! *************************************************************************
$!
$	wsb
$!
$	wsb
$!
$!
$! *************************************************************************
$! if we are creating a library from scratch, then we shall insert modules
$! into it. If we are updating a library, then we shall replace modules in it
$! now do the actual work...
$!
$compilation:
$!
$	   create dtmprepare_tmp.hlp
$	   append		dtmprepare.hlp  dtmprepare_tmp.hlp
$	   append		itcheck.hlp	dtmprepare_tmp.hlp
$	   append		i3d.hlp	 	dtmprepare_tmp.hlp
$
$	librarian/help/create/log dtmprepare.hlb dtmprepare_tmp.hlp
$!
$ ASSIGN/USER TT: SYS$INPUT
$ HELP/LIBRARY=LSL$DOC_ROOT:[DTMPREPARE.HELP]DTMPREPARE.HLB
$!
$! should we copy the library to LSL$HELP ?
$
$!
$! *************************************************************************
$! come here for a tidy exit
$!
$ tidy_exit:
$	set noverify
$	delete dtmprepare_tmp.hlp;
$	exit
