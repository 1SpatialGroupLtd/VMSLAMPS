$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1984-10-24 15:57:20.000000000 +0100
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
$	marupold:='marup'.old 
$	type sys$input:
This file tests MARUP against its old version in MARUP.OLD

A successful test will produce no errors from the DIFF command
$
$	open/write tf xxx.mar
$	write tf "	.title	zloty"
$	write tf ";"
$	write tf "; this Program tests marup"
$	write tf "; splot"
$	write tf "	here we are again"
$	write tf "	happy ; as can be"
$	write tf "	'all' good friends"
$	write tf "	'AND' jolly good"
$	write tf "	company ; COMPANY"
$	write tf ";"
$	write tf "	.end"
$	close tf
$	set verify
$	copy xxx.mar yyy.mar
$	marup xxx
$	marupold yyy
$	diff xxx.mar yyy.mar
$	xxx:='f$verify(0)'
$	inquire/nop maybe "Delete testing files ? "
$	if maybe then delete/log xxx.mar;*,yyy;*
$	if ver then set verify
