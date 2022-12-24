$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1987-02-24 18:41:08.000000000 +0000
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
$	VER='F$VERIFY(0)
$	WS="WRITE SYS$OUTPUT"
$	ON CONTROL THEN GOTO A200
$	ON WARNING THEN GOTO A200
$	TOTAL=0
$	OPEN/ERR=A10 IN  LASERAID.ERR
$	GOTO A30
$!
$ A10:	IF F$LOGICAL("IN").NES."" THEN CLOSE IN
$	IF VER THEN SET VERIFY
$	EXIT F$INTEGER($STATUS)-%X10000000
$!
$ A22:	WS "Bad identification line read - ",LINE1
$	IF VER THEN SET VERIFY
$	EXIT
$!
$ A30:
$	READ/ERR=A10/END=A100 IN LINE1
$	IF F$EXTRACT(0,10,LINE1).NES."Laseraid [" THEN GOTO A22
$	READ/ERR=A10/END=A100 IN LINE2
$	COUNT=1
$ A40:
$	IF COUNT.GT.TOTAL THEN GOTO A50
$	IF ERR2'COUNT' .EQS. LINE2 THEN GOTO A45
$	COUNT=COUNT+1
$	GOTO A40
$!
$ A45:
$	ERR3'COUNT'=ERR3'COUNT'+1
$	GOTO A30
$!
$ A50:
$	TOTAL=TOTAL+1
$	ERR1'TOTAL'=LINE1
$	ERR2'TOTAL'=LINE2
$	ERR3'TOTAL'=1
$	GOTO A30
$!
$ A100:
$	OPEN/WRITE/ERR=A10 OUT LASERAID.ERR
$	COUNT=0
$ A110:
$	COUNT=COUNT+1
$	IF (COUNT.GT.TOTAL) THEN GOTO A120
$	IF ERR3'COUNT'.NE.1 THEN -
	   ERR1'COUNT'=ERR1'COUNT' + " [x" + F$STRING(ERR3'COUNT') + "]"
$	WRITE OUT ERR1'COUNT'
$	WRITE OUT ERR2'COUNT'
$	GOTO A110
$ A120:
$	CLOSE OUT
$	CONVERT/FDL=SYS$INPUT LASERAID.ERR LASERAID.ERR
RECORD CARRIAGE
$	DELETE LASERAID.ERR;-1
$ A200:
$	IF F$LOGICAL("IN" ).NES."" THEN CLOSE IN
$	IF F$LOGICAL("OUT").NES."" THEN CLOSE OUT
$	IF VER THEN SET VERIFY
