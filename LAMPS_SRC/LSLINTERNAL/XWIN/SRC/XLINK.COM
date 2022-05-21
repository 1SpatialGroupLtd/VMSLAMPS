$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1989-07-11 18:28:28.000000000 +0100
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
$!	'f$verify(0)
$	QUALS = " "
$ 	IF (P2.EQS."D") THEN QUALS = "/debug"
$!
$	set verify
$	link 'QUALS' 'P1',sys$input:/opt
sys$share:decw$dwtlibshr/share
sys$share:decw$xlibshr/share
sys$library:vaxcrtl/share
$!	'f$verify(0)
$	purge 'P1'.exe
$       purge 'P1'.obj
