$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-09-18 15:27:12.000000000 +0100
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
$!
$	ilink=="$lsl$alpha_root:[structure.exe]ilink"
$!	@lsl$com:structureini
$!
$	icase=="$lsl$source_root:[structure.icase]icase"
$!
$	si lsl$source_root:[structure.icase]
$!
$	ilink/break	test1.iff test1.ifj
$	ilink/struct	test1.ifj test1.ifj
$	ilink/sortarms	test1.ifj test1.ifj
$!
$	icase   /par=lsl$source_root:[structure.icase]test1.par -
		test1.ifj -
		test1_cased.iff
$!
$	purge 	test1.*
$!
