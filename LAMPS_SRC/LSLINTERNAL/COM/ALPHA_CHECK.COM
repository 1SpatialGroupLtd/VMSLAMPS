$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1999-08-27 13:05:38.000000000 +0100
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
$! ALPHA_CHECK.COM - Created PGH 5-Oct-1989, last modified PGH 27-Aug-1999
$! Compare LSL$ALPHA_ROOT: and LSL$PUBLIC_ROOT: and report differences
$!
$	set noon
$	xx=f$search("alphacheck.com",1)	! reset context
$	xx=f$search("alphacheck.com",2)	! reset context
$	current_package="***"		! no package yet
$	on control_Y then goto abort
$	write sys$output "--------------------------------------------------------------------------------"
$	write sys$output "Check of LSL$ALPHA_ROOT: against LSL$PUBLIC_ROOT:  at ",f$time()
$	write sys$output "--------------------------------------------------------------------------------"
$next:
$	this=f$search("lsl$alpha_root:[*...]*.*",1)
$	if this.eqs."" then goto done		! normal exit
$	this_dir=f$parse(this,,,"directory")
$	this_name=f$parse(this,,,"name")
$	this_type=f$parse(this,,,"type")
$	if this_type.eqs.".DIR" then goto next
$	short_name=this_dir+this_name+this_type
$	alpha_created==f$file_attributes(this,"CDT")
$	public_spec="lsl$public_root:"+short_name
$	exists=f$search(public_spec,2)
$	if exists.nes."" then goto check
$	gosub test_new_package
$	write sys$output short_name,"  *** Not on PUBLIC_ROOT  ",-
"(A ",alpha_created,")"
$	goto next
$check:
$	public_created==f$file_attributes(exists,"CDT")
$	if alpha_created.eqs.public_created then goto ok
$	alpha_cvt=f$cvtime(alpha_created)
$	public_cvt=f$cvtime(public_created)
$	if alpha_cvt.gts.public_cvt then goto later
$	gosub test_new_package
$	write sys$output short_name,"  *** PUBLIC_ROOT more recent ",-
"(A ",alpha_created,"  P ",public_created,")"
$	goto next
$later:	
$	gosub test_new_package
$	write sys$output short_name,"  *** ALPHA_ROOT more recent ",-
"(A ",alpha_created,"  P ",public_created,")"
$	goto next
$ok:	
$	gosub test_new_package
$	write sys$output short_name,"  *** Same date on PUBLIC_ROOT ",-
"(A ",alpha_created,")"
$	goto next
$abort:
$	write sys$error "ALPHACHECK aborted by Control-Y"
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
