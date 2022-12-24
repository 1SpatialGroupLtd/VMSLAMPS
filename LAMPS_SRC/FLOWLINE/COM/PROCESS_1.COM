$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-06-08 16:24:06.000000000 +0100
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
$!	ELEMENT_1.com
$!
$!	Copyright Laser-Scan Laboratories Ltd, Cambridge, England.
$!	Author : MWSR	28-May-1988
$!
$!	ACCEPT  flowline Element command procedure dummy:
$!
$	ws = "write SYS$OUTPUT"
$!
$!	
$	ws "                 PROCESS_1 command file" 
$	ws " "
$	ws "Symbol 1 = ''job_symbol1'"
$	ws "Symbol 2 = ''job_symbol2'"
$	ws "Symbol 3 = ''job_symbol3'"
$	ws " "
$	ws " "
$	inq/nop/loca RESP "   Press <RETURN> when you are ready to continue "
$	FLN_OUTCOME == "1"
$	FLN_RESULT == "complete" 
$!
$! Exit
$!
$ finish:
$!
