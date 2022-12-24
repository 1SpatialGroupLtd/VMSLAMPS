$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-02-16 18:08:10.000000000 +0000
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
$	WS="WRITE SYS$OUTPUT"
$	WS " "
$	WS "Laser-Scan MUART Workstation Program Loader (V5.0  23-Dec-1987)"
$	WS " "
$!
$! get our terminal line
$	VDUTERM=f$getdvi("TT","DEVNAM")-"_"-"_"
$! assume loading to ourself
$	TEKTERM=VDUTERM
$!
$! any parameters?
$	IF P1.EQS."" THEN GOTO GOTIT
$! line quoted, see what it is
$	TEKTERM=f$getdvi("''P1'","DEVNAM")-"_"-"_" ! 
$!
$! are we loading things beneath our feet ?
$GOTIT:	UNDERFEET=VDUTERM.EQS.TEKTERM
$!
$	ASS 'TEKTERM' LSL$LD	! in anticipation of more sensible name
$	ASS 'TEKTERM' LSL$TK
$!
$! what do we load (P2 can be a program name) ?
$!
$	WPROG:=LSL$EXE:WOSP.OBJ
$	IF P2.NES."" THEN WPROG:='P2
$	WS " "
$	WS WPROG," load starting to ",TEKTERM
$	IF .NOT.UNDERFEET THEN GOTO NOTHERE
$	WS "The terminal will go dead for a few moments."
$NOTHERE:
$!
$!
$! now load apropriate program into TMU
$!
$	MCR LSL$EXE:MLOAD 'WPROG'/ST/MUART 
$!
$! that is all folks
$! clear the screen
$	RUN LSL$EXE:TEKCLR
$!
$	WS " "
$	WS WPROG," loaded on LSL$TK (",TEKTERM,")"
$	WS " "
