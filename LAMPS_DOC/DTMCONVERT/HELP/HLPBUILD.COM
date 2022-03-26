$	set noverify
$!
$! command file: HLPBUILD - command file to create or update the DTMCONVERT
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
$!	03 June 1988 F J Brown
$!      - amended for DTMCONVERT package
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
$	   create dtmconvert_tmp.hlp
$	   append		dtmconvert.hlp		 dtmconvert_tmp.hlp
$	   append		dtmconvert_init.hlp	 dtmconvert_tmp.hlp
$	   append		dti2dted.hlp	 dtmconvert_tmp.hlp
$	   append		dted2dti.hlp	 dtmconvert_tmp.hlp
$!	   append		ntf2dti.hlp	 dtmconvert_tmp.hlp
$	   append		dtediff.hlp	 dtmconvert_tmp.hlp
$	   append		mnt2dti.hlp	 dtmconvert_tmp.hlp
$
$	librarian/help/create/log dtmconvert.hlb dtmconvert_tmp.hlp
$	type sys$input


Now test this new DTMCONVERT help library using:

   $ HELP/LIBRARY=HERE:DTMCONVERT.HLB

When you are satisfied with the result, use PUBLISH to publish the new
library onto the Public Tree.

$!
$! *************************************************************************
$! come here for a tidy exit
$!
$tidy_exit:
$	set noverify
$	delete dtmconvert_tmp.hlp;*
$	sd        start_directory
$	deassign  start_directory
$	exit
