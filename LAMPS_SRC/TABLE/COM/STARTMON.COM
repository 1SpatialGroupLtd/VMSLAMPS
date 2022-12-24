$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1986-06-19 08:53:16.000000000 +0100
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
$! Procedure for starting a digitising table monitor detached process
$! First attempt			PGH	19-Jun-1986
$! Arguments are  <device>  <priority>  <group>  <named?>
$!
$	IF P1.EQS."" THEN P1="LSL$MONITOR_TABLE"
$	IF P2.EQS."" THEN P2="16"
$	IF P3.EQS."" THEN P3="100"
$	IF P4.EQS."" THEN P4="Y"
$	STARTMONX="$LSL$EXE:STARTMON"
$	STARTMONX 'P1' 'P2' 'P3' 'P4'
