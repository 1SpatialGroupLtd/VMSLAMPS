$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1989-05-10 16:04:16.000000000 +0100
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
$! Copyright Laser-Scan Laboratories Ltd, Cambridge, England
$! Author					WJJ	1980
$! Add $$77 definition to make RSX access work	WJJ	16-Nov-1988
$!
$! Example procedure for setting up a microprocessor load line
$!
$	IF P1 .EQS. "" THEN INQUIRE P1 "Which line"
$	IF P1 .EQS. "" THEN EXIT
$	XXX:='F$LOGICAL(P1)'	! remove spaces and blanks
$	IF XXX.EQS."" THEN XXX:='P1
$	IF F$LOCATE(":",XXX).EQS.F$LENGTH(XXX) THEN XXX=XXX+":"
$	IF F$LOCATE("_",XXX).EQS.F$LENGTH(XXX) THEN XXX="_"+XXX
$	AAA=F$GETDVI(XXX,"TRM")
$	IF .NOT.$STATUS THEN EXIT
$	IF .NOT.AAA THEN EXIT %X144
$	ALLOCATE 'XXX' LD0
$	ASSIGN 'XXX' LD
$	ASSIGN 'XXX' LSL$LD	! for the modern naming conventions
$	ASSIGN 'XXX' FZ
$	ASSIGN 'XXX' SS
$	ASSIGN 'XXX' RL0
$	ASSIGN 'XXX' $$77	! for RSX access
$	SET TERMINAL/PASSALL/EIGHT_BIT/NOECHO/NOTTSYNC/NOBROADCAST/TYPEAHEAD/HOSTSYNC 'XXX'
$	TALK=="$LSL$EXE:TALK"
$	MUTTER=="$LSL$EXE:MUTTER"
