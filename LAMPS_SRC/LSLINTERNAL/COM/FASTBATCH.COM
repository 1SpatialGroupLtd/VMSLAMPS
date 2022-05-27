$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-02-04 11:06:36.000000000 +0000
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
$! fast batch queue submit procedure$! Called from FBATCH command.$! sets up options and calls central BATCH procedure$	BAT$QUEUE="''F$TRNLNM("FASTBATCH")'"$	IF BAT$QUEUE .EQS. "" THEN BAT$QUEUE="FASTBATCH"$	@LSL$COM:BATCH 'P1' 'P2' 'P3' 'P4' 'P5' 'P6' 'P7' 'P8'