$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-02-19 12:21:40.000000000 +0000
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
$! command file to tidy up [LSLOLD*...] directories
$! Author PGH 04-Apr-1989
$!
$	TYPE SYS$INPUT:

***	This procedure will delete all files older than 2 weeks on the two
***	'old' trees of LSL$OLD_PUBLIC_ROOT:, and LSL$OLD_ISSUE_ROOT:.

$	INQUIRE YES "Go ahead and do it ?  "
$	IF .NOT.YES THEN EXIT
$!
$	DELETE/LOG/EXCLUDE=*.DIR/MOD/BEFORE="TODAY-14-" LSL$OLD_PUBLIC_ROOT:[*...]*.*;*
$!
$	DELETE/LOG/EXCLUDE=*.DIR/MOD/BEFORE="TODAY-14-" LSL$OLD_ISSUE_ROOT:[*...]*.*;*
$!
