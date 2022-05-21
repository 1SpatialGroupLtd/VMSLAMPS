$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-03-22 14:21:08.000000000 +0000
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
$! AXPCHK.COM - procedure to compare dates of AXP files against VAX ones.
$	set noon
$	on control_Y then goto abort
$	if p1 .eqs. "" then -
		inquire P1 "AXP root [LSL$AXP_PUBLIC_ROOT:] "
$	if p1 .eqs. "" then p1="LSL$AXP_PUBLIC_ROOT:"
$	if p2 .eqs. "" then -
		inquire P2 "VAX root [LSL$PUBLIC_ROOT:] "
$	if p2 .eqs. "" then p2="LSL$PUBLIC_ROOT:"
$	if p3 .eqs. "" then -
		inquire P3 "Directory specification [[*...]] "
$	if p3 .eqs. "" then p3="[*...]"
$	root2=p2
$	root1=p1
$	reversing=0
$	write sys$output "---------------------------------------------------------------------------------------------------------"
$	write sys$output "AXPCHK of ''p1'''p3' against ''p2' at ",f$time()
$	write sys$output "---------------------------------------------------------------------------------------------------------"
$!-----------------------------------------------------------------------
$repeat:
$	xx=f$search("xxx.yyy",1)	! reset context
$	xx=f$search("xxx.yyy",2)	! reset context
$next:
$	first_spec=root1+p3+"*.*"
$	this=f$search(first_spec,1)
$	if this.eqs."" then goto done		! normal exit
$	this_dir=f$parse(this,,,"directory")
$	this_name=f$parse(this,,,"name")
$	this_type=f$parse(this,,,"type")
$	if this_type.eqs.".DIR" then goto next
$	short_name=this_dir+this_name+this_type
$	name_len=f$len(this_name)
$	if f$locate("_TV",this_name).eq.name_len-3
$	then
$	   vax_name=f$extract(0,name_len-3,this_name)
$	   goto check_vax
$	endif
$	if f$locate("_AXP",this_name).eq.name_len-4
$	then
$	   vax_name=f$extract(0,name_len-4,this_name)
$	   goto check_vax
$	endif
$	write sys$output short_name,"  *** Not _TV or _AXP ***"
$	goto next
$check_vax:
$!!!	short_name=this_dir+vax_name+this_type
$	second_spec="''root2'"+this_dir+vax_name+this_type
$	exists=f$search(second_spec,2)
$	if exists.nes."" then goto check
$	write sys$output short_name,"  *** Not on ''root2' ***"
$	goto next
$check:
$	if this_type.eqs.".DIR" then goto ok
$	first_created==f$file_attributes(this,"CDT")
$	second_created==f$file_attributes(exists,"CDT")
$	if first_created.eqs.second_created then goto same
$	first_cvt=f$cvtime(first_created)
$	second_cvt=f$cvtime(second_created)
$	if first_cvt.gts.second_cvt then goto later
$	write sys$output short_name,"  *** ''root2' more recent ","(AXP ",first_created,"  VAX ",second_created,")"
$	goto next
$later:	
$!!!	write sys$output short_name,"  *** ''root1 more recent ","(F ",first_created,"  S ",second_created,")"
$	goto next
$same:	
$	write sys$output short_name,"  *** Same date ","(AXP ",first_created,"  VAX ",second_created,")"
$	goto next
$ok:	
$!!!	write sys$output short_name," is OK"
$	goto next
$!-----------------------------------------------------------------------
$abort:
$	write sys$output "AXPCHK aborted by Control-Y"
$done:
