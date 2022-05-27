$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1986-03-17 14:57:38.000000000 +0000
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
$	OPEN/WRITE MA2 ME:MARCHIVE.DAT$	OPEN/READ MA LSL$SECURE:MARCHIVE.DAT$	LOOP=0$ A1:	LOOP=LOOP+1$	IF (LOOP/500)*500.EQ.LOOP THEN WS LOOP$	READ/END=EOF MA LINE$       LABEL=F$EXTRACT(0,7,LINE)$       SAVNAME=F$EXTRACT(8,13,LINE)$	FDIRECTORY=F$EXTRACT(22,20,LINE)$	ORIGFILE=F$EXTRACT(43,13,LINE)$	TOTFILE=F$EXTRACT(0,F$LOC(" ",FDIRECTORY),FDIRECTORY)+ORIGFILE$       USERNAME=F$EXTRACT(58,10,LINE)$	QDATE=F$EXTRACT(69,11,LINE)$	OPERATOR="UNKNOWN"$	$	FIELD="                                                                                                                                      "$       FIELD[0,7]:='LABEL'			! SECURE tape label$       FIELD[8,13]:='USERNAME'			! username$	FIELD[22,11]:='QDATE'			! date of queue request$       FIELD[34,13]:='OPERATOR'		! operator name$       FIELD[48,85]:='SAVNAME'			! saveset name$	WRITE MA2 FIELD,TOTFILE$	GOTO a1$ EOF:$	CLOSE MA$	CLOSE MA2