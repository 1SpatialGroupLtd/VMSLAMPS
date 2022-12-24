$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1982-12-03 18:00:14.000000000 +0000
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
$	INQUIRE COMPILE
$	IF .NOT.COMPILE THEN GOTO BUILD
$	SET VERIFY
$	F77 TEST=TEST.SRC
$BUILD:	SET VER		!'F$VERIFY(0)
$	TKB TEST/FP=TEST,LIOLIB/LB,SYS$LIBRARY:F77OTS/LB
$	PURGE TEST.OBJ,.EXE
$	V=F$VERIFY(0)
