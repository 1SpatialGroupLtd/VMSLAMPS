$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-12-20 12:04:26.000000000 +0000
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
$ 	set noverify
$	ws = "write sys$output"
$	on control_y then goto abort1
$	buildingname = "lsl$dtifilter_building"
$	buildingwarning = "''f$logical(buildingname)'"
$	if "''buildingwarning'" .eqs. "" then goto xx20
$	ws "''buildingwarning'"
$	exit
$!
$xx20:
$	define/group lsl$dtifilter_building "in_progress"
$	sd:=$lsl$sys:sd
$	set noon
$	emsg=""
$	assign lsl$source_root:[imageprocess.dtifilter] lsl$cmndtifilter
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$	newmsg dtifilter.mes/number=1269/prefix=dtifil__/parameter=fortran/runoff
$	@dtifilter.temp_com
$	purge dtifiltermsg.rno
$	set noverify
$!
$	set noverify
$	ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	set verify
$	macro/object=dtifilter_mar dfilcmd
$ 	ok=$status
$	purge/nolog dtifilter_mar.obj
$	if .not.ok then emsg=emsg + " dtifilter_mar"
$	set noverify
$! 
$	set noverify
$	if emsg.eqs."" then goto noerr
$	ws "&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"
$	ws "Compilation errors in:"
$	ws emsg
$	ws "&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"
$	goto xx250
$	noerr:
$ ws "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 	link/map/full/map=dtifilter/exe=dtifilter -
	dtifilter/opt,lsl$library:lslshr/opt
$   purge/nolog *.exe,*.map
$xx250:
$abort1:
$ 	deass/group lsl$dtifilter_building
$ 	set noverify
