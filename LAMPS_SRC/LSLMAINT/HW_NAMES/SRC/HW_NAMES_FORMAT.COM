$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-12-06 14:59:08.000000000 +0000
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
$! Diddy procedure to reformat hardware names list.
$! Creates a lookup program, plus two listings.
$! Created					PGH	5-Dec-1994
$	if f$getsyi("arch_name").eqs."Alpha"
$	then
$	  hw_names="$here:hw_names_axp.exe"
$	else
$	  hw_names="$here:hw_names.exe"
$	endif
$	write sys$output "...Extracting information"
$	if f$search("hw_names.dat").nes."" then delete/nolog/noconf hw_names.dat;*
$	define/user sys$output hw_names.dat
$	hw_names
$	write sys$output "...Reformating information"
$	open in hw_names.dat
$	open/write out hw_model_to_name.src
$	open/write list hw_model_number.lis
$	count=0
$	write out "	SUBROUTINE HW_MODEL_TO_NAME(HW_MODEL,HW_NAME,HW_NAME_LENGTH)"
$	write out "C"
$	write out "***	MODULE	HW_MODEL_TO_NAME
$	write out "***	IDENT	06DE94"
$	write out "C"
$	write out "C This subroutine is automatically generated by HW_NAMES_FORMAT.COM"
$	write out "C Look in LSL$SOURCE_ROOT:[LSLMAINT.HW_NAMES] for details."
$	write out "C"
$	write out "C This version generated from VMS ''f$getsyi("version")' at ''f$time()'"
$	write out "C"
$	write out "	INTEGER		HW_MODEL"
$	write out "	CHARACTER*(*)	HW_NAME"
$	write out "	INTEGER		HW_NAME_LENGTH"
$	write out "C"
$	write out "	IF (HW_MODEL.LT.1024) THEN"
$	write out "	   HW_NAME ='Unknown VAX'"
$	write out "	   HW_NAME_LENGTH =11
$	write out "	ELSE"
$	write out "	   HW_NAME ='Unknown Alpha AXP'"
$	write out "	   HW_NAME_LENGTH =17
$	write out "	   GOTO 1024
$	write out "	ENDIF"
$	write out "C"
$	write out "C First check all the VAXes"
$	write out "C"
$	write sys$output " Model   Name
$	write list " Model   Name
$	found_axp=0
$loop:
$	read/end=done in line
$	line=f$edit(line,"TRIM,COMPRESS")
$	if line.eqs."" then goto loop
$	linlen=f$len(line)
$	char=f$extract(0,1,line)
$	if char.nes."0" then goto loop
$       name=f$extract(7,100,line)
$	if "''f$extract(0,4,name)".eqs."Unkn" then goto loop
$	if "''f$extract(0,4,name)".eqs."unkn" then goto loop
$	hexnumber=f$extract(0,4,line)
$	decnumber=%x'hexnumber'
$	line=f$fao("!6UL  !AS",decnumber,name)
$	write sys$output line
$	if (decnumber.ge.1024).and.(.not.found_axp)
$	then
$	   write out "C"
$	   write out "C Now check all the AXPs"
$	   write out "C"
$	   write out "1024	CONTINUE"
$	   found_axp=1
$	endif
$	write list line
$	write out "	IF (HW_MODEL.EQ.",decnumber,") THEN"
$	write out "	   HW_NAME ='",name,"'"
$	write out "	   HW_NAME_LENGTH=",f$len(name)
$	write out "	   GOTO 999"
$	write out "	ENDIF"
$	count=count+1
$	goto loop
$done:
$	close in
$	write sys$output count," records written."
$	write out "C"
$	write out "999	RETURN"
$	write out "	END"
$	write out "C"
$	close out
$	close list
$	write sys$output "...Sorting listing (ignore length warnings)"
$	sort/key=(pos=8,size=40)/stable hw_model_number.lis hw_model_names.lis
$	write sys$output "...Done"
$	exit
