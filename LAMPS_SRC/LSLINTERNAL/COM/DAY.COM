$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1984-01-13 13:03:28.000000000 +0000
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
$	IF P1.EQS."" THEN P1=F$TIME()
$	AAA  =F$CVTIME(P1)
$	IF .NOT.$STATUS THEN EXIT
$	YEAR =F$INTEGER(F$EXTRACT(0,4,AAA))
$	MONTH=F$INTEGER(F$EXTRACT(5,2,AAA))
$	DAY  =F$INTEGER(F$EXTRACT(8,2,AAA))
$	A=MONTH+10
$	B=YEAR+(MONTH-14)/12
$	C=(13*(A-(A/13)*12)-1)/5+DAY+77+-
	  5*(B-(B/100)*100)/4+B/400-(B/100)*2
$	C=C-(C/7)*7
$	A0="Sunday"
$	A1="Monday"
$	A2="Tuesday"
$	A3="Wednesday"
$	A4="Thursday"
$	A5="Friday"
$	A6="Saturday"
$	IF P2.EQS."" THEN GOTO 10
$	  B="''P2'"
$	  'B'==A'C'
$	  GOTO 20
$ 10:	WRITE SYS$OUTPUT A'C'
$ 20:
