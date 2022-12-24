$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1984-10-24 14:53:24.000000000 +0100
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
$	ver:='f$verify(0)'
$	forupold:='forup'.old 
$	type sys$input:
This file tests FORUP against its old version in FORUP.OLD

A successful test will produce no errors from the DIFF command
$
$	open/write tf xxx.src
$	write tf "	provram zloty"
$	write tf "c"
$	write tf "c this Program tests FORUP"
$	write tf "C splot"
$	write tf "c"
$	write tf "	here we are again"
$	write tf "	happy ! as can be"
$	write tf "	'all' good friends"
$	write tf "	'AND' jolly good"
$	write tf "	company ! COMPANY"
$	write tf "c"
$	write tf "	end"
$	close tf
$	set verify
$	copy xxx.src yyy.src
$	forup xxx
$	forupold yyy
$	diff xxx.src yyy.src
$	xxx:='f$verify(0)'
$	inquire/nop maybe "Delete testing files ? "
$	if maybe then delete/log xxx.src;*,yyy;*
$	if ver then set verify
