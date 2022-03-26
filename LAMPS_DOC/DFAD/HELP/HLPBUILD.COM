$	set noverify
$!
$! command file: HLPBUILD - command file to create or update the DFAD
$!			   standard help library
$!
$! Copyright (C) LaserScan Laboratories Ltd, Cambridge, England  1988
$!
$! Author 				D R Catlow       24-June-1988
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
$!	wsb
$!
$! now, find out what we are meant to be doing...
$!
$!	wsb
$!	inq	to_tree	"Copy to LSL$HELP ? "
$!
$!
$! *************************************************************************
$! if we are creating a library from scratch, then we shall insert modules
$! into it. If we are updating a library, then we shall replace modules in it
$! now do the actual work...
$!
$compilation:
$!
$	   create dfad_tmp.hlp
$	   append		dfad.hlp	 dfad_tmp.hlp
$	   append		mcehed.hlp	 dfad_tmp.hlp
$	   append		i2dfad.hlp	 dfad_tmp.hlp
$	   append		dfad2i.hlp	 dfad_tmp.hlp
$	   append		dfadval.hlp	 dfad_tmp.hlp
$	   append		fadtinput.hlp	 dfad_tmp.hlp
$	   append		fadtmerge.hlp	 dfad_tmp.hlp
$
$	librarian/help/create/log dfad.hlb dfad_tmp.hlp
$	type sys$input


Now test this new IMP help library using:

$ HELP/LIBRARY=HERE:DFAD.HLB

When you are satisfied with the result, use PUBLISH to publish the new
library onto the Public Tree.

$!
$! should we copy the library to LSL$HELP ?
$!
$!	if .not.to_tree then goto dont_to_tree
$!	   cop/log  imp.hlb  lsl$public_root:[imp.help]
$!	   purge/log  lsl$public_root:[imp.help]*.hlb
$dont_to_tree:
$!
$! *************************************************************************
$! come here for a tidy exit
$!
$tidy_exit:
$	set noverify
$	delete DFAD_tmp.hlp;
$	sd        start_directory
$	deassign  start_directory
$	exit
