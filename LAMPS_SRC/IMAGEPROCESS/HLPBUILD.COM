$	set noverify
$!
$! command file: HLPBUILD - command file to create or update the 
$!			    IMAGEPROCESS standard help library
$!
$! Copyright (C) LaserScan Laboratories Ltd, Cambridge, England  1986
$!
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
$	   create imageprocess_tmp.hlp
$	   append	imageprocess.hlp	 imageprocess_tmp.hlp
$!	   append	imageprocess_init.hlp	 imageprocess_tmp.hlp
$	   append	readcct.hlp		 imageprocess_tmp.hlp
$!	   append	dtifilter.hlp		 imageprocess_tmp.hlp
$
$	librarian/help/create/log imageprocess.hlb imageprocess_tmp.hlp
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
$	delete imageprocess_tmp.hlp;
$	sd        start_directory
$	deassign  start_directory
$	exit
