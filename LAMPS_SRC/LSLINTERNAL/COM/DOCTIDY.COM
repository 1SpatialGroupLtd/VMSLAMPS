$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-08-21 11:48:52.000000000 +0100
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
$! command file to tidy up [DOC...] directories
$! Author PGH 28-Apr-1988
$! TeX stuff added	PGH	27-Aug-1990
$!
$	TYPE SYS$INPUT:

***	This procedure will purge the complete [LSLDOC...] tree to 2 versions
***	excluding files created in previous 4 days, to 1 version excluding
***	files created in previous 2 months, and will delete all .LNI, .MEM, 
***	.RNT, .RNX, .BRN, .PS, , .DVI, .LIS, LN3 files older than 2 weeks.

$	IF P1.EQS."" THEN INQUIRE P1 "Go ahead and do it ?  "
$	IF .NOT.P1 THEN EXIT
$!
$	PURGE/LOG LSL$DOC_ROOT:[*...]/KEEP=2/BEF="TODAY-4-"
$!
$	PURGE/LOG LSL$DOC_ROOT:[*...]/KEEP=1/BEF="TODAY-60-"
$!
$	DELETE/LOG/EXCLUDE=*.DIR/BEFORE="TODAY-14-" -
   LSL$DOC_ROOT:[*...]*.LNI;*,*.MEM;*,*.RNT;*,*.RNX;*,*.BRN;*,-
   *.PS;*,*.DVI;*,*.LIS;*,*.LN3;*
$!
