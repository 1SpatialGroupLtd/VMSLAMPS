$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-07-16 16:59:14.000000000 +0100
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
$! small file to show all Hershey fonts	PGH 8-May-1992
$	DEFINE/USER LSL$FRT_FONTMAX 12
$	DEFINE/USER LSL$FRT_TRIMAX 50000
$	DEFINE/USER SYS$INPUT SYS$COMMAND:
$	LITES2 FRT HERSHEY_EXAMPLE#SRI LSL$FRT:OS#TRI HERSHEY#IFF HERSHEY_EXAMPLE
$	EXIT

