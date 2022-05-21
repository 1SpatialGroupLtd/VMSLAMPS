$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-09 19:07:26.000000000 +0100
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
$	on control_y then goto dxf2iex
$	if "''f$logical("lsl$dxf2i_building")'" -
		 .nes. "in_progress" then goto a0
$	write sys$output "sOMEONE ELSE IS BUILDING"
$	exit
$!
$a0:	define/group lsl$dxf2i_building "in_progress"
$	sd:=$lsl$sys:sd
$	set noon
$	assign lsl$source_root:[convert.dxfparlib] lsl$dxfpar:
$	assign lsl$source_root:[convert.dxfparlib] lsl$cmndxfpar:
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		set verify
$	newmsg dxf2i.mes/number=1615/runoff/hl=2
$	purge dxf2imsg.rno
$	@dxf2i.temp_com
$ 		adc dxf2i.tmp=dxf2i_cld.cld
$ 		set command/object=dxf2i_cld dxf2i.tmp
$ 		ok=$status
$ 		if ok then pvv dxf2i_cld
$ 		if ok then delete dxf2i.tmp;*
$ 		if ok then delete adc.ide;*
$ 		if ok then purge/nolog dxf2i_cld.obj
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$		set verify
$ 		adc dxf2i=dxf2i
$ 		fort dxf2i
$ 		ok=$status
$ 		if ok then pvv dxf2i
$ 		purge/nolog dxf2i.obj
$ 		purge/nolog dxf2i.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc getcmd=getcmd
$ 		fort getcmd
$ 		ok=$status
$ 		if ok then pvv getcmd
$ 		purge/nolog getcmd.obj
$ 		purge/nolog getcmd.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc read_blocks=read_blocks
$ 		fort read_blocks
$ 		ok=$status
$ 		if ok then pvv read_blocks
$ 		purge/nolog read_blocks.obj
$ 		purge/nolog read_blocks.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc scan_blocks=scan_blocks
$ 		fort scan_blocks
$ 		ok=$status
$ 		if ok then pvv scan_blocks
$ 		purge/nolog scan_blocks.obj
$ 		purge/nolog scan_blocks.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc read_tables=read_tables
$ 		fort read_tables
$ 		ok=$status
$ 		if ok then pvv read_tables
$ 		purge/nolog read_tables.obj
$ 		purge/nolog read_tables.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc scan_tables=scan_tables
$ 		fort scan_tables
$ 		ok=$status
$ 		if ok then pvv scan_tables
$ 		purge/nolog scan_tables.obj
$ 		purge/nolog scan_tables.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc read_entities=read_entities
$ 		fort read_entities
$ 		ok=$status
$ 		if ok then pvv read_entities
$ 		purge/nolog read_entities.obj
$ 		purge/nolog read_entities.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc read_header=read_header
$ 		fort read_header
$ 		ok=$status
$ 		if ok then pvv read_header
$ 		purge/nolog read_header.obj
$ 		purge/nolog read_header.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc scan_header=scan_header
$ 		fort scan_header
$ 		ok=$status
$ 		if ok then pvv scan_header
$ 		purge/nolog scan_header.obj
$ 		purge/nolog scan_header.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc write_header=write_header
$ 		fort write_header
$ 		ok=$status
$ 		if ok then pvv write_header
$ 		purge/nolog write_header.obj
$ 		purge/nolog write_header.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc read_file=read_file
$ 		fort read_file
$ 		ok=$status
$ 		if ok then pvv read_file
$ 		purge/nolog read_file.obj
$ 		purge/nolog read_file.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc dxf_arc=dxf_arc
$ 		fort dxf_arc
$ 		ok=$status
$ 		if ok then pvv dxf_arc
$ 		purge/nolog dxf_arc.obj
$ 		purge/nolog dxf_arc.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc dxf_circle=dxf_circle
$ 		fort dxf_circle
$ 		ok=$status
$ 		if ok then pvv dxf_circle
$ 		purge/nolog dxf_circle.obj
$ 		purge/nolog dxf_circle.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc dxf_insert=dxf_insert
$ 		fort dxf_insert
$ 		ok=$status
$ 		if ok then pvv dxf_insert
$ 		purge/nolog dxf_insert.obj
$ 		purge/nolog dxf_insert.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc dxf_line=dxf_line
$ 		fort dxf_line
$ 		ok=$status
$ 		if ok then pvv dxf_line
$ 		purge/nolog dxf_line.obj
$ 		purge/nolog dxf_line.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc dxf_point=dxf_point
$ 		fort dxf_point
$ 		ok=$status
$ 		if ok then pvv dxf_point
$ 		purge/nolog dxf_point.obj
$ 		purge/nolog dxf_point.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc dxf_polyline=dxf_polyline
$ 		fort dxf_polyline
$ 		ok=$status
$ 		if ok then pvv dxf_polyline
$ 		purge/nolog dxf_polyline.obj
$ 		purge/nolog dxf_polyline.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc dxf_solid=dxf_solid
$ 		fort dxf_solid
$ 		ok=$status
$ 		if ok then pvv dxf_solid
$ 		purge/nolog dxf_solid.obj
$ 		purge/nolog dxf_solid.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc dxf_text=dxf_text
$ 		fort dxf_text
$ 		ok=$status
$ 		if ok then pvv dxf_text
$ 		purge/nolog dxf_text.obj
$ 		purge/nolog dxf_text.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc dxf_trace=dxf_trace
$ 		fort dxf_trace
$ 		ok=$status
$ 		if ok then pvv dxf_trace
$ 		purge/nolog dxf_trace.obj
$ 		purge/nolog dxf_trace.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		adc check_range=check_range
$ 		fort check_range
$ 		ok=$status
$ 		if ok then pvv check_range
$ 		purge/nolog check_range.obj
$ 		purge/nolog check_range.for
$ 		delete adc.ide;*
$ set noverify
$ write sys$output "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ set verify
$ 		link/map/cross/exe=dxf2i dxf2i, -
		dxf2i_cld, getcmd, write_header, -
		read_blocks, scan_blocks, -
		read_tables, read_header, -
		scan_tables, scan_header, read_entities, -
		read_file, dxf_arc, dxf_circle, dxf_insert, -
		dxf_line, dxf_point, dxf_polyline, -
		dxf_solid, dxf_text, dxf_trace,check_range, -
		here:dxf2i.promsg_obj, -
		lsl$dxfpar:dxfpar.promsg_obj, -
		lsl$dxfpar:dxfparlib/lib, -
		lsl$library:lslfrtlib/lib, -
		lsl$library:iffshr/opt, lslshr/opt
$ 		dxf2iex:
$ 		deass/group lsl$dxf2i_building
$ 		set nover
