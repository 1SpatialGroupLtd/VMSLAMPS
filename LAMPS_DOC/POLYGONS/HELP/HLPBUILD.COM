$	set noverify
$!
$! command file: HLPBUILD - command file to create or update the POLYGONS
$!			   standard help library
$!
$! Copyright (C) LaserScan Laboratories Ltd, Cambridge, England  1986
$!
$! Author 					Tim Hartnall, April 1987
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
$! *************************************************************************
$! if we are creating a library from scratch, then we shall insert modules
$! into it. If we are updating a library, then we shall replace modules in it
$! now do the actual work...
$!
$compilation:
$!
$	   create polygons_tmp.hlp
$	   append		polygons.hlp		 polygons_tmp.hlp
$	   append		polygons_init.hlp	 polygons_tmp.hlp
$	   append		ipolygon.hlp		 polygons_tmp.hlp
$	   append		istsel.hlp		 polygons_tmp.hlp
$	   append		polmerge.hlp		 polygons_tmp.hlp
$
$	librarian/help/create/log polygons.hlb polygons_tmp.hlp
$!
$! should we PUBLISH the library?
$!
$ LLL:
$	wsb
$	inq	to_tree	"PUBLISH the .HLB file? "
$!	if .not.to_tree then goto dont_to_tree
$	publish
$dont_to_tree:
$!
$! *************************************************************************
$! come here for a tidy exit
$!
$tidy_exit:
$	set noverify
$	delete polygons_tmp.hlp;
$	sd        start_directory
$	deassign  start_directory
$	exit
