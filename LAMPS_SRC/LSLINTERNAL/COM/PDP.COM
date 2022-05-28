$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1986-07-31 16:40:04.000000000 +0100
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
$	ver='f$verify(0)'
$!
$!	Command file to access PDP 11/45 from VAX 11/780 terminals
$!	Authors: MD/WJJ		27-Feb-1986
$!
$!	Modified (RF, 8 July 1986) to permit pre-allocation of link line,
$!				   to use DEFINE rather than the "deprecated"
$!					ASSIGN DCL function,
$!				   to make more clear what's a string and 
$!					what's a numeric DCL symbol,
$!				   and to preserve verification state
$!
$	terminal_already_allocated=0
$	owner_1_name=""
$	owner_2_name=""
$	ON WARNING THEN EXIT
$	IF P1.EQS."" THEN GOTO LAB1
$	xxx=f$logical(p1)
$	IF XXX.EQS."" THEN XXX=P1
$	IF F$LOCATE(":",XXX).ge.F$LENGTH(XXX) THEN XXX=XXX+":"
$	IF F$LOCATE("_",XXX).ge.F$LENGTH(XXX) THEN XXX="_"+XXX
$	terminal_owner=f$getdvi(xxx,"pid")
$	if terminal_owner.eqs."" then goto lab3
$	terminal_already_allocated=1
$	if terminal_owner.eqs.f$getjpi(0,"pid") then goto lab3
$	WRITE SYS$OUTPUT "Serial line ", p1, -
			 " unavailable, attempting default link"
$LAB1:	XXX=F$LOGICAL("lsl$pdplink1")
$	IF XXX.EQS."" THEN GOTO LINK2
$	IF F$LOCATE(":",XXX).ge.F$LENGTH(XXX) THEN XXX=XXX+":"
$	IF F$LOCATE("_",XXX).ge.F$LENGTH(XXX) THEN XXX="_"+XXX
$	terminal_already_allocated=0
$	terminal_owner=f$getdvi(xxx,"pid")
$	if terminal_owner.eqs."" then goto lab3
$	owner_1_name=f$getjpi(terminal_owner,"prcnam")
$	terminal_already_allocated=1
$	if terminal_owner.eqs.f$getjpi(0,"pid") then goto lab3
$LINK2:	XXX=F$LOGICAL("lsl$pdplink2")
$	IF XXX.EQS."" THEN GOTO NOLINK
$	IF F$LOCATE(":",XXX).ge.F$LENGTH(XXX) THEN XXX=XXX+":"
$	IF F$LOCATE("_",XXX).ge.F$LENGTH(XXX) THEN XXX="_"+XXX
$	terminal_already_allocated=0
$	terminal_owner=f$getdvi(xxx,"pid")
$	if terminal_owner.eqs."" then goto lab3
$	owner_2_name=f$getjpi(terminal_owner,"prcnam")
$	terminal_already_allocated=1
$	if terminal_owner.eqs.f$getjpi(0,"pid") then goto lab3
$NOLINK: WRITE SYS$OUTPUT "No PDP link available -"
$	if owner_1_name.eqs."" .and. owner_2_name.eqs."" then -
		write sys$output "... none even defined!"
$	if owner_1_name.eqs."" .and. owner_2_name.eqs."" then goto exit
$	if owner_1_name.nes."" .and. owner_2_name.nes."" then write sys$output -
		"... ", owner_1_name, " has link 1, ",-
			owner_2_name, " has link 2"
$	if owner_1_name.nes."" .and. owner_2_name.nes."" then goto exit
$	if owner_1_name.nes."" then write sys$output -
		"... ", owner_1_name, " has link 1, there's no link 2"
$	if owner_2_name.nes."" then write sys$output -
		"... ", owner_2_name, " has link 2, there's no link 1"
$	GOTO EXIT
$LAB3:	ON WARNING THEN GOTO EXIT
$	if .not.terminal_already_allocated then allocate 'XXX'
$	SET TERM/TYPE 'XXX'
$	define/user SYS$INPUT	'f$logical("tt")'
$	define/user SYS$OUTPUT	'f$logical("tt")'
$	SET HOST/DTE 'XXX'
$!
$EXIT:	if .not.terminal_already_allocated then deallocate 'XXX'
$	if ver then set verify
