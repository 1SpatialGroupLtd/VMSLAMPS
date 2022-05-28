$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-09-12 15:41:24.000000000 +0100
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
$	ver:='f$verify(0)'
$	if "''rf_test'".eqs."1" then set verify
$	if p1 .nes. "?" then goto not_queer
$	type sys$input:
Command file arguments are:

 p1 - number of file to be processed
 p2 - number of copies to print
 p3 - title of category file (default here:category.lan)
$	goto tidy_ver
$not_queer: direct=f$directory()
$	dirdot=f$locate(".",direct)-1
$	if dirdot.eq.f$length(direct)-1 then dirdot=f$locate("]",direct)-1
$	dir=f$extract(1,dirdot,direct)
$	if p1 .eqs. "" then inquire p1 "File version to work on"
$	if p2 .eqs. "" then inquire p2 "How many copies to print"
$	if p3 .eqs. "" then goto no_p3
$	if f$locate("/",p3) .ge. f$length(p3) then p3="/c="+p3
$no_p3:! inkjet_printer_present=f$getdvi("lta500:","spl")
$!	use_inkjet=""
$!	if inkjet_printer_present then inquire inkjet_printer_present -
 $!		" Do you want output on the inkjet printer ? "
$!	if inkjet_printer_present then -
 $!		use_inkjet="/queue=ledl_print"
$	pdot=f$locate(".",p1)+1
$	plen=f$length(p1)
$	if pdot .ge. plen then goto nodot
$	plen=plen-pdot
$	p1=f$extract(pdot,plen,p1)
$nodot:	if f$length(p1) .lt. 3 then p1=f$extract(0,3-f$length(p1),"000")+p1
$	zot=f$search("fur''dir'.''p1'")
$	define/user sys$input 'f$logical("tt")'
$	define/user dbg$input 'f$logical("tt")'
$	fur 'p1''p3'/reprint
$	goto copies_via_symbiont
$!
$! code to generate multiple copies within Agfa printer
$	if (.not.led_printer_present) .or. (p2.eq.1) .or. -
	   (p2.eqs."") then goto copies_via_symbiont
$	control_a[0,7]=1
$	open/read original fur'dir'.'p1'
$	open/write nc fur'dir'.'p1'
$	read/end=no_first_line original first_line
$	write nc control_a,"nc",p2,";",first_line
$main_copy_loop: read/end=end_copying original subsequent_line
$	write nc subsequent_line
$	goto main_copy_loop
$!
$no_first_line: write sys$output: "*** No ""first line"" of analysed output!"
$	goto tidy_ver
$!
$end_copying: zot="<zot>" ! forces purge later
$	close original
$	close nc
$	p2="" ! forces no "/copies="
$!
$copies_via_symbiont: if p2.nes."" then p2="/copies="+p2
$	if zot.nes."" then purge/log fur'dir'.'p1'
$	print/delete/head'p2''use_inkjet' fur'dir'.'p1'
$tidy_ver: if ver then set verify
