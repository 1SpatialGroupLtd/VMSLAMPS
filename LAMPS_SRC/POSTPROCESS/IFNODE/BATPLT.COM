$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1984-03-06 19:20:34.000000000 +0000
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
$	VER=F$VERIFY(0)
$	ON ERROR THEN GOTO EXIT
$! Who is this user?
$	NAME=F$GETJPI("","USERNAME")
$! What is the time and date?
	DATE=F$EXTRACT(0,17,F$TIME())
$! Which file does he want to plot?
$	IF P1 .EQS. "" THEN GOTO ASK
$	IFFFILE=P1
$	GOTO OK
$ASK:	INQUIRE IFFFILE "IFF filename"
$	IF IFFFILE.EQS."" THEN GOTO ASK
$OK:	TMPFILE:='F$SEARCH(IFFFILE)
$	IF TMPFILE.NES."" THEN IFFFILE=TMPFILE
$! Form the header string to be output by the plot.
$	IDENT=IFFFILE+"  USER="+NAME+"  "+DATE
$!
$! Work out the name for the temporary command file to be 
$! passed to the plotter batch queue (which later deletes it).
$! Extract the required part of the filename.
$	CMDFILE=F$PARSE(IFFFILE,,,"NAME")+".COM"
$!
$! Write out the command file.
$	OPEN/WRITE CMDFIL 'CMDFILE'
$	WC:="WRITE CMDFIL"
$ WC "$ ALL TTD1"
$ WC "$ RUN BUR$EXE:PLOTID"
$ WC "''IDENT'"
$ WC "$	BURPLOT:==$BUR$EXE:BURPLOT"
$ WC "$ SI HERE"
$ WC "$ BURPLOT @LSL$DISK:[IFF.IFNODE]BENPAR"
$ WC "IFF ''IFFFILE'"
$ WC "ALL"
$ WC "GO"
$ WC "$ WAIT 0:0:20"
$ WC "$ DEALL TTD1"
$	CLOSE CMDFIL
$!
$! Now submit the command file to the plotter batch queue.
$	BAT$DELETE=1
$	BAT$OPTION="/LOG"
$	PBAT 'CMDFILE'
$!
$EXIT:	IF VER.EQ.1 THEN SET VERIFY
