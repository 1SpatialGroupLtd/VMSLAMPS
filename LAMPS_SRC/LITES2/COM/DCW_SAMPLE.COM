$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-17 17:45:18.000000000 +0100
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
$! LITES2 command procedure to display sample DCW dataset
$! Supplied as part of LAMPS V4.2	TAA	16-Aug-1993
$!
$DEFINE/JOB LSL$FILL_CUTSMAX 10000
$DEFINE/JOB LSL$FILL_POINTSMAX 20000
$IF "''LITES2'".EQS."" THEN @LSL$COM:LITES2INI
$DEFINE/USER SYS$INPUT SYS$COMMAND
$LITES2 @LSL$PUBLIC_ROOT:[LITES2.CMD]DCW_SAMPLE.LCM
