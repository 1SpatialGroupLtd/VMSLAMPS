$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1996-09-23 12:11:02.000000000 +0100
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
$	ver_status=f$verify(0)
$	on control then continue
$	on error then continue
$!
$! Initialization file for UILMENUS
$!
$! Created				CCB 09-Jan-1990
$! Motif version			PGH 04-Jun-1990
$! TV for Alpha AXP			CCB 17-Oct-1994
$! Motif 1.2 and _AXP version		CCB 23-Sep-1996
$!
$! Allow for differences for OpenVMS Alpha AXP
$!
$	ARCH_NAME=F$GETSYI("ARCH_NAME")
$	TVS=""
$	AXPS=""
$	IF ARCH_NAME.EQS."Alpha" 
$	THEN 
$	   TVS="_TV"
$	   AXPS="_AXP"
$	ENDIF
$!
$! Assume LSL$UIL is assigned already
$!
$	UILGEN:==$LSL$EXE:UILGENMOTIF'TVS'
$!
$! Run version depending on whether Motif 1.2 installed
$!
$	IF F$SEARCH("SYS$SHARE:DECW$XMLIBSHR12.EXE").NES.""
$	THEN
$	   UILMENUS:==$LSL$EXE:UILMENUSMOTIF12'AXPS'
$	ELSE
$	   UILMENUS:==$LSL$EXE:UILMENUSMOTIF'TVS'
$	ENDIF
$!
$	if ver_status then set verify
