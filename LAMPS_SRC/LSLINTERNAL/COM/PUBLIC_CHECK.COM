$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1999-08-27 12:05:14.000000000 +0100
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
$! PUBLIC_CHECK.COM - Created PGH 5-Oct-1989, last modified PGH 27-Aug-1999
$! Compare LSL$PUBLIC_ROOT: and LSL$ISSUE_ROOT: and report differences
$!
$	set noon
$	xx=f$search("PUBLIC_CHECK.COM",1)	! reset context
$	xx=f$search("PUBLIC_CHECK.COM",2)	! reset context
$	current_package="***"			! no package yet
$	on control_Y then goto abort
$	write sys$output "--------------------------------------------------------------------------------"
$	write sys$output "Check of LSL$PUBLIC_ROOT: against LSL$ISSUE_ROOT:  at ",f$time()
$	write sys$output "--------------------------------------------------------------------------------"
$next:
$	this=f$search("lsl$public_root:[*...]*.*",1)
$	if this.eqs."" then goto done		! normal exit
$	this_dir=f$parse(this,,,"directory")
$	this_name=f$parse(this,,,"name")
$	this_type=f$parse(this,,,"type")
$	short_name=this_dir+this_name+this_type
$	pub_created==f$file_attributes(this,"CDT")
$	issue_spec="lsl$issue_root:"+short_name
$	exists=f$search(issue_spec,2)
$	if exists.nes."" then goto check
$	gosub test_new_package
$	write sys$output short_name,"  *** Not on ISSUE_ROOT  ",-
"(P ",pub_created,")"
$	goto next
$check:
$	if this_type.eqs.".DIR" then goto ok
$	issue_created==f$file_attributes(exists,"CDT")
$	if pub_created.eqs.issue_created then goto ok
$	pub_cvt=f$cvtime(pub_created)
$	issue_cvt=f$cvtime(issue_created)
$	if pub_cvt.gts.issue_cvt then goto later
$	gosub test_new_package
$	write sys$output short_name,"  *** ISSUE_ROOT more recent ",-
"(P ",pub_created,"  I ",issue_created,")"
$	goto next
$later:	
$	gosub test_new_package
$	write sys$output short_name,"  *** PUBLIC_ROOT more recent ",-
"(P ",pub_created,"  I ",issue_created,")"
$	goto next
$ok:	
$!!!	write sys$output short_name," is OK"
$	goto next
$abort:
$	write sys$error "PUBLIC_CHECK aborted by Control-Y"
$done:	exit
$!
$! ************************************************************************
$!
$! subroutine to indicate new package
$!
$test_new_package:
$	this_package=f$element(0,".",this_dir)-"["
$	if this_package.nes.current_package
$	then
$	   write sys$output ""
$	   write sys$output "Package ",this_package
$	   current_package=this_package
$	endif
$	return
$!
