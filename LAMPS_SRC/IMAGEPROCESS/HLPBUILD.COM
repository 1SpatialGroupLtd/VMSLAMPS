$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-01-21 17:17:52.000000000 +0000
$! *
$! * This program is free software: you can redistribute it and/or modify
$! * it under the terms of the GNU General Public License as published by
$! * the Free Software Foundation, version 3.
$! *
$! * This program is distributed in the hope that it will be useful, but
$! * WITHOUT ANY WARRANTY; without even the implied warranty of
$! * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
$! * General Public License for more details.
$! *
$! * You should have received a copy of the GNU General Public License
$! * along with this program. If not, see http://www.gnu.org/licenses/.
$!
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
