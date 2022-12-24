$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-09 13:57:12.000000000 +0100
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
$	SAVVER:='F$VERIFY(0)
$	CMDLINE=P1+P2+P3-"/CO"
$	OUT=F$ELEMENT(0,"=",CMDLINE)
$	IN=F$ELEMENT(1,"=",CMDLINE)
$	IF F$LOCATE(".",IN).EQ.F$LEN(IN) THEN IN=IN+".SRC"
$	IF F$LOCATE(".",OUT).EQ.F$LEN(OUT) THEN OUT=OUT+".FOR"
$	EDIT/EDT/OUT='OUT' 'IN'/COMMAND=SYS$INPUT:
DEL ALL '***'
EXIT
$	CREATE ADC.IDE
$	IF SAVVER THEN SET VERIFY
