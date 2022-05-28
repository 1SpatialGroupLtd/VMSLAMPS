$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1989-02-15 10:13:56.000000000 +0000
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
$	ver_status=f$verify(0)
$	on control then continue
$	on error then continue
$!
$! Command file to initialise Laser-Scan Package 'LASERAID'
$!
$	define		LSL$ERR		LSL$SITE_ROOT:[LASERAID.LOG]
$	define		LSL$GU		LSL$IF
$	define		LSL$LK		LSL$SITE_ROOT:[LASERAID.PATCH]
$	define		LSL$FLFHLP	LSL$HELP:LASERAID
$!
$	LAJ		== "$LSL$EXE:LAJ"
$!
$	if ver_status then set verify
