$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1985-09-24 15:31:36.000000000 +0100
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
$!
$!		LASERPLOT bug logger.
$!		--------------------
$!
$!
$! Author:	J.H.Rees
$! Created:	20 Sep 85
$! Last edited:	24 Sep 85
$!
$	WS :="WRITE SYS$OUTPUT"
$	WS ""
$	WS " BUG LOGGER FOR THE LASERPLOT"
$	WS ""
$AGAIN:
$	INQUIRE/NOP WHOM " Please enter your name  "
$	IF WHOM .EQS. ""  THEN GOTO AGAIN
$	OPEN/APPEND OUT DRA1:[LASERPLOT.ERROR_LOG]BUG.LOG
$	WRITE OUT -
 "*****************************************************************************"
$	WRITE OUT ""
$	WRITE OUT WHOM
$	WRITE OUT F$USER()
$	WRITE OUT F$EXT(0,17,F$TIME())
$	WRITE OUT ""
$	CLOSE OUT
$	WS ""
$	WS ""
$	WS " Please type-in your findings stating "
$	WS "  - the nature of the bug,"
$	WS "  - the machine on which you where working,"
$	WS "  - the mode in which you were using the software,"
$	WS "    i.e. 900 format (online, offline), 960 format etc."
$	WS ""
$	WS "  to terminate your message enter CONTROL Z"
$	WS ""
$	ASSIGN/USER TT SYS$INPUT
$	APPEND TT: DRA1:[LASERPLOT.ERROR_LOG]BUG.LOG
$	OPEN/APPEND OUT DRA1:[LASERPLOT.ERROR_LOG]BUG.LOG
$	WRITE OUT ""
$	WRITE OUT -
 "*****************************************************************************"
$	CLOSE OUT
$	WS ""
$	WS " ...your complaint has been logged, thank-you!"
$	MAIL DRA1:[LASERPLOT.ERROR_LOG]ERROR JOHN
