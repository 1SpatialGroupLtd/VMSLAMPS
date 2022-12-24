$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-03-10 16:55:08.000000000 +0000
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
$! VAXAXPCHK.COM - procedure to compare dates of AXP files against VAX ones.
$	set noon
$	on control_Y then goto abort
$	if p1 .eqs. "" then -
		inquire P1 "VAX root [LSL$PUBLIC_ROOT:] "
$	if p1 .eqs. "" then p1="LSL$PUBLIC_ROOT:"
$	if p2 .eqs. "" then -
		inquire P2 "AXP root [LSL$AXP_PUBLIC_ROOT:] "
$	if p2 .eqs. "" then p2="LSL$AXP_PUBLIC_ROOT:"
$	if p3 .eqs. "" then -
		inquire P3 "Directory specification [[*...]] "
$	if p3 .eqs. "" then p3="[*...]"
$	root2=p2
$	root1=p1
$	reversing=0
$	write sys$output "---------------------------------------------------------------------------------------------------------"
$	write sys$output "VAXAXPCHK of ''p1'''p3' against ''p2' at ",f$time()
$	write sys$output "---------------------------------------------------------------------------------------------------------"
$!-----------------------------------------------------------------------
$repeat:
$	xx=f$search("xxx.yyy",1)	! reset context
$	xx=f$search("xxx.yyy",2)	! reset context
$	prev_package="***"
$	skipping=0
$next:
$	first_spec=root1+p3+"*.*"
$	this=f$search(first_spec,1)
$	if this.eqs."" then goto done		! normal exit
$	this_type=f$parse(this,,,"type")
$	if this_type.nes.".EXE" then goto next
$	this_dir=f$parse(this,,,"directory")
$	package=f$element(0,".",this_dir)-"["
$	if prev_package.nes.package
$	then
$	   skipping=0
$	   if package.eqs."ACE" then skipping=1
$	   if package.eqs."AIDU" then skipping=1
$	   if package.eqs."ARGS" then skipping=1
$	   if package.eqs."DAMP" then skipping=1
$	   if package.eqs."DASHEX" then skipping=1
$	   if package.eqs."DECCA1" then skipping=1
$	   if package.eqs."DIGSYS" then skipping=1
$	   if package.eqs."DTMPROCESS" then skipping=1
$	   if package.eqs."EGDS" then skipping=1
$	   if package.eqs."GSIJAPAN" then skipping=1
$	   if package.eqs."HIACC" then skipping=1
$	   if package.eqs."HRD" then skipping=1
$	   if package.eqs."HYDRO" then skipping=1
$	   if package.eqs."OBSOLETE" then skipping=1
$	   if package.eqs."INTERPRET" then skipping=1
$	   if package.eqs."LASERAID" then skipping=1
$	   if package.eqs."LASERPLOT" then skipping=1
$	   if package.eqs."LITES1" then skipping=1
$	   if package.eqs."LSD" then skipping=1
$	   if package.eqs."LSD_NEW" then skipping=1
$	   if package.eqs."LSLINFORMAP" then skipping=1
$	   if package.eqs."MCE" then skipping=1
$	   if package.eqs."MPLOT" then skipping=1
$	   if package.eqs."MSDSAUDI" then skipping=1
$	   if package.eqs."MUART" then skipping=1
$	   if package.eqs."NOTAM" then skipping=1
$	   if package.eqs."OLIC" then skipping=1
$	   if package.eqs."OS" then skipping=1
$	   if package.eqs."POSTPROCESS" then skipping=1
$	   if package.eqs."TERAS" then skipping=1
$	   if package.eqs."USBUR" then skipping=1
$	   if package.eqs."USGS" then skipping=1
$	   if package.eqs."VTRAK" then skipping=1
$	   if f$extract(0,1,package).eqs."$" then skipping=1
$	   skip_message=" "
$	   if skipping then skip_message=" is being skipped"
$	   write sys$output " "
$	   write sys$output "Package ",package,skip_message
$	endif
$	prev_package=package
$	if skipping then goto next
$	first_created==f$file_attributes(this,"CDT")
$	this_name=f$parse(this,,,"name")
$	short_name=this_dir+this_name+this_type
$	axp_name=this_name+"_TV"
$	second_spec="''root2'"+this_dir+axp_name+this_type
$	exists=f$search(second_spec,2)
$	if exists.nes."" then goto found_tv
$	axp_name=this_name+"_AXP"
$	second_spec="''root2'"+this_dir+axp_name+this_type
$	exists=f$search(second_spec,2)
$	if exists.nes."" then goto found_axp
$	write sys$output short_name,"  (",first_created,")   ***  No AXP equivalent  ***"
$	goto next
$found_axp:
$found_tv:
$	second_created==f$file_attributes(exists,"CDT")
$	write sys$output short_name,"  (",first_created,")  ->  ",axp_name," (",second_created,")"
$	goto next
$!-----------------------------------------------------------------------
$abort:
$	write sys$output "VAXAXPCHK aborted by Control-Y"
$done:
