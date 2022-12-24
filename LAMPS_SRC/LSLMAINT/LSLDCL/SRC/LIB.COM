$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1986-01-10 17:51:12.000000000 +0000
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

$ LIB/REPLACE/LOG LSL$LIBRARY:LSLDCLLIB DCL_CML.OBJ;,DCL_COMMA.OBJ;,DCL_DBL.OBJ;,DCL_ERRET.OBJ;,DCL_FILE.OBJ;,DCL_INT.OBJ;,DCL_QUAL.OBJ;,DCL_REAL.OBJ;,DCL_STARTUP.OBJ;,DCL_STR.OBJ;

