$	set noverify
$!
$! command file: HLPBUILD - command file to create or update the MATRIX
$!			   standard help library
$!
$! Copyright (C) LaserScan Laboratories Ltd, Cambridge, England  1988
$!
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
$	inq	to_tree	"Copy to LSL$HELP ? "
$!
$!
$! *************************************************************************
$! if we are creating a library from scratch, then we shall insert modules
$! into it. If we are updating a library, then we shall replace modules in it
$! now do the actual work...
$!
$compilation:
$!
$	   create matrix_tmp.hlp
$	   append		matrix.hlp       matrix_tmp.hlp
$	   append		dti2text.hlp	 matrix_tmp.hlp
$	   append		dtiblend.hlp	 matrix_tmp.hlp
$	   append		dticombine.hlp	 matrix_tmp.hlp
$	   append		dtirotate.hlp	 matrix_tmp.hlp
$	   append		dtitile.hlp	 matrix_tmp.hlp
$	   append		dtiview.hlp	 matrix_tmp.hlp
$	   append		dtiedit.hlp	 matrix_tmp.hlp
$
$	librarian/help/create/log matrix.hlb matrix_tmp.hlp
$!
$ HELP/LIBRARY=LSL$DOC_ROOT:[MATRIX.HELP]MATRIX.HLB
$!
$! should we copy the library to LSL$HELP ?
$!
$	if .not.to_tree then goto dont_to_tree
$	   cop/log  matrix.hlb  lsl$public_root:[matrix.help]
$	   purge/log  lsl$public_root:[matrix.help]*.hlb
$dont_to_tree:
$!
$! *************************************************************************
$! come here for a tidy exit
$!
$tidy_exit:
$	set noverify
$	delete matrix_tmp.hlp;
$	exit
