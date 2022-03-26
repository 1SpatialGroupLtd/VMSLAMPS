$	set noverify
$!
$! command file: HLPBUILD - command file to create or update the IMP
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
$!	- IMPINI added
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
$	   create imp_tmp.hlp
$	   append		imp.hlp		 imp_tmp.hlp
$	   append		imp_init.hlp	 imp_tmp.hlp
$	   append		icheck.hlp	 imp_tmp.hlp
$	   append		icut.hlp	 imp_tmp.hlp
$	   append		idifference.hlp	 imp_tmp.hlp
$	   append		ifilter.hlp	 imp_tmp.hlp
$	   append		ifixarea.hlp	 imp_tmp.hlp
$	   append		ifromtext.hlp	 imp_tmp.hlp
$	   append		iinfo.hlp	 imp_tmp.hlp
$	   append		ilayfc.hlp	 imp_tmp.hlp
$	   append		imend.hlp	 imp_tmp.hlp
$	   append		imerge.hlp	 imp_tmp.hlp
$	   append		ipatch.hlp	 imp_tmp.hlp
$	   append		irecode.hlp	 imp_tmp.hlp
$	   append		irenumber.hlp	 imp_tmp.hlp
$	   append		ireport.hlp	 imp_tmp.hlp
$	   append		iselac.hlp	 imp_tmp.hlp
$	   append		iselect.hlp	 imp_tmp.hlp
$	   append		isort.hlp	 imp_tmp.hlp
$	   append		istart.hlp	 imp_tmp.hlp
$	   append		itotext.hlp	 imp_tmp.hlp
$	   append		itrans.hlp	 imp_tmp.hlp
$	   append		iwindow.hlp	 imp_tmp.hlp
$
$	librarian/help/create/log imp.hlb imp_tmp.hlp
$	type sys$input


Now test this new IMP help library using:

 $ HELP/LIBRARY=HERE:IMP.HLB

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
$	delete imp_tmp.hlp;
$	sd        start_directory
$	deassign  start_directory
$	exit
