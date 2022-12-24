$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-07-02 14:25:28.000000000 +0100
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
$	verify:='f$verify(0)'
$	write sys$output "*** The INFO command has been withdrawn"
$	write sys$output "*** You can still mail notices to INFO, but to ",-
				"read them you must now use NEWS"
$	if f$search("sys$login:newsrc.").eqs.""
$	then
$	  copy/nolog lsl$info:proto_newsrc. sys$login:newsrc.
$	  write sys$output "*** You have been `set up' to use NEWS to read INFO"
$	endif
$	if verify then set verify
