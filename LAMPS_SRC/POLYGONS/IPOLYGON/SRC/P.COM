$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-05-12 16:40:46.000000000 +0100
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
$	ws="write sys$output"
$	set noverify
$	on control_y then goto ipolygonex
$	is_build = f$logical("lsl$ipolygon_building")
$	if "''is_build'".eqs."in_progress"
$	then
$	  ws "Someone else is building"
$	  exit
$	endif
$!
$	define/group lsl$ipolygon_building "in_progress"
$ assign lsl$source_root:[newpolygons.service.src] lsl$cmnpolygons
$ assign lsl$source_root:[newpolygons.service.lib] lsl$cmnpolygonsl
$ assign lsl$source_root:[newpolygons.ipolygon.src] lsl$cmnipolygon
$	set noon
$	emsg=""
$	linkit="T"
$	set noverify

$	ws "----------------------compiling SIDE_TAB -------"
$	ws ""
$	adc SIDE_TAB=SIDE_TAB
$	set verify
$	fort/list SIDE_TAB
$	ok=$status
$	set noverify
$	purge/nolog SIDE_TAB.for
$	delete adc.ide;*
$	if ok
$	then
$	  delete/nolog SIDE_TAB.lis;*
$	endif
$!
$	if ok
$	then
$	  pvv SIDE_TAB
$	  purge/nolog SIDE_TAB.obj
$	else
$	  emsg=emsg+" SIDE_TAB"
$	  goto err
$	endif
$err:	set noverify
$	if emsg.nes.""
$	then
$	  ws "----------------------"
$	  ws "Compilation errors in:"
$	  ws emsg
$	  ws ""
$	  linkit = "F"
$	endif
$	ipolygonex:
$	deass/group lsl$ipolygon_building
$	set nover
