$	set noverify
$!
$! command file: HLPBUILD - command file to create or update the DTMCREATE
$!			   standard help library
$!
$! Copyright (C) LaserScan Laboratories Ltd, Cambridge, England  1986
$!
$! Author 					Tim Hartnall, October 1986
$!
$! *************************************************************************
$! Modifications
$!
$!	27 October 1986 Tim Hartnall	
$!	- DTMCREATEINI added
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
$! if we are creating a library from scratch, then we shall insert modules
$! into it. If we are updating a library, then we shall replace modules in it
$! now do the actual work...
$!
$compilation:
$!
$	   create dtmcreate_tmp.hlp
$	   append		dtmcreate.hlp		 dtmcreate_tmp.hlp
$	   append		dtmcreate_init.hlp	 dtmcreate_tmp.hlp
$	   append		triang.hlp	 dtmcreate_tmp.hlp
$	   append		trider.hlp	 dtmcreate_tmp.hlp
$	   append		triedit.hlp	 dtmcreate_tmp.hlp
$	   append		trigrid.hlp	 dtmcreate_tmp.hlp
$
$	librarian/help/create/log dtmcreate.hlb dtmcreate_tmp.hlp
$	type sys$input


Now test this new DTMCREATE help library using:

   $ HELP/LIBRARY=HERE:DTMCREATE.HLB

When you are satisfied with the result, use PUBLISH to publish the new
library onto the Public Tree.

$!
$! *************************************************************************
$! come here for a tidy exit
$!
$tidy_exit:
$	set noverify
$	delete dtmcreate_tmp.hlp;*
$	sd        start_directory
$	deassign  start_directory
$	exit
