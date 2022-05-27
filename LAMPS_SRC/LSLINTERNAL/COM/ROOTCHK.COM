$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-06-19 13:22:42.000000000 +0100
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
$! ROOTCHK.COM - procedure to compare dates of files on two directory trees.
$	set noon
$	on control_Y then goto abort
$	if p1 .eqs. "" then -
		inquire P1 "First root [lsl$alpha_root:] "
$	if p1 .eqs. "" then p1="lsl$alpha_root:"
$	if p2 .eqs. "" then -
		inquire P2 "Second root [lsl$public_root:] "
$	if p2 .eqs. "" then p2="lsl$public_root:"
$	if p3 .eqs. "" then -
		inquire P3 "Directory specification [[*...]] "
$	if p3 .eqs. "" then p3="[*...]"
$	if p4 .eqs. "" then -
		inquire P4 "Do reverse search as well [N] "
$	root2=p2
$	root1=p1
$	reversing=0
$	write sys$output "---------------------------------------------------------------------------------------------------------"
$	write sys$output "ROOTCHK of ''p1'''p3' against ''p2' at ",f$time()
$	write sys$output "---------------------------------------------------------------------------------------------------------"
$!-----------------------------------------------------------------------
$repeat:
$	xx=f$search("xxx.yyy",1)	! reset context
$	xx=f$search("xxx.yyy",2)	! reset context
$next:
$	first_spec=root1+p3+"*.*"
$	this=f$search(first_spec,1)
$	if this.eqs."" then goto done1		! normal exit
$	this_dir=f$parse(this,,,"directory")
$	this_name=f$parse(this,,,"name")
$	this_type=f$parse(this,,,"type")
$	short_name=this_dir+this_name+this_type
$	second_spec="''root2'"+short_name
$	exists=f$search(second_spec,2)
$	if exists.nes."" then goto check
$	write sys$output short_name,"  *** Not on ''root2' ***"
$	goto next
$check:
$	if this_type.eqs.".DIR" then goto ok
$	first_created==f$file_attributes(this,"CDT")
$	second_created==f$file_attributes(exists,"CDT")
$	if first_created.eqs.second_created then goto ok
$	first_cvt=f$cvtime(first_created)
$	second_cvt=f$cvtime(second_created)
$	if first_cvt.gts.second_cvt then goto later
$	if reversing then goto next
$	write sys$output short_name,"  *** ''root2' more recent ",-
"(F ",first_created,"  S ",second_created,")"
$	goto next
$later:	
$	write sys$output short_name,"  *** ''root1 more recent ",-
"(F ",first_created,"  S ",second_created,")"
$	goto next
$ok:	
$!!!	write sys$output short_name," is OK"
$	goto next
$!-----------------------------------------------------------------------
$! here at end of first pass, to do reverse try
$done1:
$	if reversing then goto done
$	if .not.p4 then goto done
$	reversing=1
$	temp=root1
$	root1=root2
$	root2=temp
$	write sys$output "---------------------------------------------------------------------------------------------------------"
$	write sys$output "Starting reverse check"
$	write sys$output "---------------------------------------------------------------------------------------------------------"
$	goto repeat
$!-----------------------------------------------------------------------
$abort:
$	write sys$output "ROOTCHK aborted by Control-Y"
$done:
