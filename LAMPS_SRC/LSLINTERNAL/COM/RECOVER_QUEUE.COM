$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1986-03-14 11:32:46.000000000 +0000
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
$! Command procedure to print out the contents of the SECURE recover
$! queue
$       WS " "
$! Test to see whether there is anything at all in the file!
$	OPEN/READ RQ LSL$SECURE:RESTDIR.DAT
$	READ/END=A1 RQ LINE
$	WS "Listing of current Recover Queue:"
$	CLOSE RQ
$	GOTO A2
$!
$ A1:
$	WS "%SECURE-I-NOFILES, no files on current recover queue."
$	GOTO  A4
$!
$! Extract the 2 records for each queued request and format on screen.
$ A2:	
$	OPEN/READ RQ LSL$SECURE:RESTDIR.DAT
$	REQNO=0
$ A3:	READ/END=A4 RQ LINE1
$	READ/END=A4 RQ LINE2
$	READ/END=A4 RQ LINE3
$	REQNO=REQNO+1
$	WS " "
$	WS "REQUEST ''REQNO'"
$	WS "User:             ''F$EXTRACT(94,13,LINE1)'"
$	WS "Date of request:  ''F$EXTRACT(108,22,LINE1)'"
$	WS "Target device:    ''F$EXTRACT(0,F$LOCATE(":",LINE2)+1,LINE2)'"
$	WS "Target directory: ''F$EXTRACT(F$LOCATE(":",LINE2)+1,F$LENGTH(LINE2),LINE2)'"
$	TMPLIN=F$EXTRACT(8,85,LINE1)
$	WS "BACKUP saveset:   ''F$EXTRACT(0,F$LOCATE(" ",TMPLIN),TMPLIN)'"
$	SELECTIONS=F$EXT(0,F$LOCATE(" ",LINE3),LINE3)
$	IF F$LENGTH(SELECTIONS).EQ.0 THEN SELECTIONS="None."
$	WS "Select options:   ''SELECTIONS'"
$	WS "Secure tape:      ''F$EXTRACT(0,F$LOCATE(" ",LINE1),LINE1)'"
$	GOTO A3
$!
$! Then close the queue file again
$ A4:	CLOSE RQ
