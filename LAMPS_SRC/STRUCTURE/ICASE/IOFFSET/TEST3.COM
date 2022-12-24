$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-09-25 10:45:32.000000000 +0100
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
$	ilink/break/mintol=0.3	test3.iff test3.ifj
$	ilink/struct		test3.ifj test3.ifj
$	ilink/sortarms		test3.ifj test3.ifj
$!
$	icase   /par=lsl$source_root:[structure.icase]test3.par -
		test3.ifj -
		test3_cased.iff
$!
$	purge 	test3.*
$!
