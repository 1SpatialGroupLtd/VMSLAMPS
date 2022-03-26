$	set noverify
$!
$! command file: HLPBUILD - command file to create or update the STRUCTURE
$!			   standard help library
$!
$! Copyright (C) Laser-Scan Laboratories Ltd, Cambridge, England  1987
$!
$! Author 					Tim Hartnall, June 1987
$!
$! *************************************************************************
$! Modifications
$!
$!
$! *************************************************************************
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
$!
$! *************************************************************************
$! if we are creating a library from scratch, then we shall insert modules
$! into it. If we are updating a library, then we shall replace modules in it
$! now do the actual work...
$!
$compilation:
$!
$	   create structure_tmp.hlp
$	   append		STRUCTURE.hlp		 structure_tmp.hlp
$	   append		STRUCTURE_INIT.hlp	 structure_tmp.hlp
$	   append		ILINK.hlp		 structure_tmp.hlp
$	   append		RELHT.hlp		 structure_tmp.hlp
$
$	librarian/help/create/log structure.hlb structure_TMP.hlp
$!
$! should we PUBLISH the library?
$!
$	WS "Now use PUBLISH to publish the library"
$!
$! *************************************************************************
$! come here for a tidy exit
$!
$tidy_exit:
$	set noverify
$	delete STRUCTURE_tmp.hlp;
$	sd        start_directory
$	deassign  start_directory
$	exit
