$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1996-01-22 16:44:14.000000000 +0000
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
$	on control_y then goto polygonsex
$!
$	is_build = f$logical("lsl$newpolygons_building")
$	if "''is_build'" .eqs. "in_progress"
$	then
$	  ws "Someone else is building"
$	  exit
$	endif
$!
$	define/group lsl$newpolygons_building "in_progress"
$	assign lsl$source_root:[polygons.service.src] lsl$cmnpolygons
$	set noon
$	emsg=""
$	ws ""
$	ws "-----------------------------Creating library..."
$	library/create  [polygons.lib]polygons
$	libr = "library/insert/log  [polygons.lib]polygons"
$ set noverify
$ ws ""
$ ws "---------------------Creating message definitions....."
$ newmsg/num=1246/nam=poly/pref=poly__/par=for/run polygons.mes
$ @polygons.temp_com
$ if $status then libr polygons.promsg_obj
$ ws ""
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING ABORT_POLY....."
$	adc ABORT_POLY=ABORT_POLY
$	fort ABORT_POLY
$	ok=$status
$	if ok then pvv ABORT_POLY
$	delete /nolog adc.ide;
$	purge/nolog ABORT_POLY.obj,ABORT_POLY.for
$	delete/nolog ABORT_POLY.for;*
$	if ok
$	then
$	  ws ""
$	  libr ABORT_POLY
$	delete ABORT_POLY.obj;*
$	else
$	  delete ABORT_POLY.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING ADDNOD....."
$	adc ADDNOD=ADDNOD
$	fort ADDNOD
$	ok=$status
$	if ok then pvv ADDNOD
$	delete /nolog adc.ide;
$	purge/nolog ADDNOD.obj,ADDNOD.for
$	delete/nolog ADDNOD.for;*
$	if ok
$	then
$	  ws ""
$	  libr ADDNOD
$	delete ADDNOD.obj;*
$	else
$	  delete ADDNOD.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING ADD_QUOTES....."
$	adc ADD_QUOTES=ADD_QUOTES
$	fort ADD_QUOTES
$	ok=$status
$	if ok then pvv ADD_QUOTES
$	delete /nolog adc.ide;
$	purge/nolog ADD_QUOTES.obj,ADD_QUOTES.for
$	delete/nolog ADD_QUOTES.for;*
$	if ok
$	then
$	  ws ""
$	  libr ADD_QUOTES
$	delete ADD_QUOTES.obj;*
$	else
$	  delete ADD_QUOTES.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING AREA....."
$	adc AREA=AREA
$	fort AREA
$	ok=$status
$	if ok then pvv AREA
$	delete /nolog adc.ide;
$	purge/nolog AREA.obj,AREA.for
$	delete/nolog AREA.for;*
$	if ok
$	then
$	  ws ""
$	  libr AREA
$	delete AREA.obj;*
$	else
$	  delete AREA.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING BINSEA....."
$	adc BINSEA=BINSEA
$	fort BINSEA
$	ok=$status
$	if ok then pvv BINSEA
$	delete /nolog adc.ide;
$	purge/nolog BINSEA.obj,BINSEA.for
$	delete/nolog BINSEA.for;*
$	if ok
$	then
$	  ws ""
$	  libr BINSEA
$	delete BINSEA.obj;*
$	else
$	  delete BINSEA.obj;*
$	endif
$	ws ""
$	ws "----------Compiling BITMAP (that macro thing)..."
$	MACRO BITMAP
$	if $status then libr bitmap.obj
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING BOX_INIT....."
$	adc BOX_INIT=BOX_INIT
$	fort BOX_INIT
$	ok=$status
$	if ok then pvv BOX_INIT
$	delete /nolog adc.ide;
$	purge/nolog BOX_INIT.obj,BOX_INIT.for
$	delete/nolog BOX_INIT.for;*
$	if ok
$	then
$	  ws ""
$	  libr BOX_INIT
$	delete BOX_INIT.obj;*
$	else
$	  delete BOX_INIT.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING BOX_POLY....."
$	adc BOX_POLY=BOX_POLY
$	fort BOX_POLY
$	ok=$status
$	if ok then pvv BOX_POLY
$	delete /nolog adc.ide;
$	purge/nolog BOX_POLY.obj,BOX_POLY.for
$	delete/nolog BOX_POLY.for;*
$	if ok
$	then
$	  ws ""
$	  libr BOX_POLY
$	delete BOX_POLY.obj;*
$	else
$	  delete BOX_POLY.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING CALC_BOXES....."
$	adc CALC_BOXES=CALC_BOXES
$	fort CALC_BOXES
$	ok=$status
$	if ok then pvv CALC_BOXES
$	delete /nolog adc.ide;
$	purge/nolog CALC_BOXES.obj,CALC_BOXES.for
$	delete/nolog CALC_BOXES.for;*
$	if ok
$	then
$	  ws ""
$	  libr CALC_BOXES
$	delete CALC_BOXES.obj;*
$	else
$	  delete CALC_BOXES.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING CALC_RANGE....."
$	adc CALC_RANGE=CALC_RANGE
$	fort CALC_RANGE
$	ok=$status
$	if ok then pvv CALC_RANGE
$	delete /nolog adc.ide;
$	purge/nolog CALC_RANGE.obj,CALC_RANGE.for
$	delete/nolog CALC_RANGE.for;*
$	if ok
$	then
$	  ws ""
$	  libr CALC_RANGE
$	delete CALC_RANGE.obj;*
$	else
$	  delete CALC_RANGE.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING CHECK_JUNCTION....."
$	adc CHECK_JUNCTION=CHECK_JUNCTION
$	fort CHECK_JUNCTION
$	ok=$status
$	if ok then pvv CHECK_JUNCTION
$	delete /nolog adc.ide;
$	purge/nolog CHECK_JUNCTION.obj,CHECK_JUNCTION.for
$	delete/nolog CHECK_JUNCTION.for;*
$	if ok
$	then
$	  ws ""
$	  libr CHECK_JUNCTION
$	delete CHECK_JUNCTION.obj;*
$	else
$	  delete CHECK_JUNCTION.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING CLEAR_TRANS....."
$	adc CLEAR_TRANS=CLEAR_TRANS
$	fort CLEAR_TRANS
$	ok=$status
$	if ok then pvv CLEAR_TRANS
$	delete /nolog adc.ide;
$	purge/nolog CLEAR_TRANS.obj,CLEAR_TRANS.for
$	delete/nolog CLEAR_TRANS.for;*
$	if ok
$	then
$	  ws ""
$	  libr CLEAR_TRANS
$	delete CLEAR_TRANS.obj;*
$	else
$	  delete CLEAR_TRANS.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING COPY_STRING....."
$	adc COPY_STRING=COPY_STRING
$	fort COPY_STRING
$	ok=$status
$	if ok then pvv COPY_STRING
$	delete /nolog adc.ide;
$	purge/nolog COPY_STRING.obj,COPY_STRING.for
$	delete/nolog COPY_STRING.for;*
$	if ok
$	then
$	  ws ""
$	  libr COPY_STRING
$	delete COPY_STRING.obj;*
$	else
$	  delete COPY_STRING.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING DUFF_POLY....."
$	adc DUFF_POLY=DUFF_POLY
$	fort DUFF_POLY
$	ok=$status
$	if ok then pvv DUFF_POLY
$	delete /nolog adc.ide;
$	purge/nolog DUFF_POLY.obj,DUFF_POLY.for
$	delete/nolog DUFF_POLY.for;*
$	if ok
$	then
$	  ws ""
$	  libr DUFF_POLY
$	delete DUFF_POLY.obj;*
$	else
$	  delete DUFF_POLY.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING DUPLICATES....."
$	adc DUPLICATES=DUPLICATES
$	fort DUPLICATES
$	ok=$status
$	if ok then pvv DUPLICATES
$	delete /nolog adc.ide;
$	purge/nolog DUPLICATES.obj,DUPLICATES.for
$	delete/nolog DUPLICATES.for;*
$	if ok
$	then
$	  ws ""
$	  libr DUPLICATES
$	delete DUPLICATES.obj;*
$	else
$	  delete DUPLICATES.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING EXTRACT_LOOPS....."
$	adc EXTRACT_LOOPS=EXTRACT_LOOPS
$	fort EXTRACT_LOOPS
$	ok=$status
$	if ok then pvv EXTRACT_LOOPS
$	delete /nolog adc.ide;
$	purge/nolog EXTRACT_LOOPS.obj,EXTRACT_LOOPS.for
$	delete/nolog EXTRACT_LOOPS.for;*
$	if ok
$	then
$	  ws ""
$	  libr EXTRACT_LOOPS
$	delete EXTRACT_LOOPS.obj;*
$	else
$	  delete EXTRACT_LOOPS.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING FIND_CURRENT_ARM....."
$	adc FIND_CURRENT_ARM=FIND_CURRENT_ARM
$	fort FIND_CURRENT_ARM
$	ok=$status
$	if ok then pvv FIND_CURRENT_ARM
$	delete /nolog adc.ide;
$	purge/nolog FIND_CURRENT_ARM.obj,FIND_CURRENT_ARM.for
$	delete/nolog FIND_CURRENT_ARM.for;*
$	if ok
$	then
$	  ws ""
$	  libr FIND_CURRENT_ARM
$	delete FIND_CURRENT_ARM.obj;*
$	else
$	  delete FIND_CURRENT_ARM.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING FIND_POLY....."
$	adc FIND_POLY=FIND_POLY
$	fort FIND_POLY
$	ok=$status
$	if ok then pvv FIND_POLY
$	delete /nolog adc.ide;
$	purge/nolog FIND_POLY.obj,FIND_POLY.for
$	delete/nolog FIND_POLY.for;*
$	if ok
$	then
$	  ws ""
$	  libr FIND_POLY
$	delete FIND_POLY.obj;*
$	else
$	  delete FIND_POLY.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING FIRST_NEST....."
$	adc FIRST_NEST=FIRST_NEST
$	fort FIRST_NEST
$	ok=$status
$	if ok then pvv FIRST_NEST
$	delete /nolog adc.ide;
$	purge/nolog FIRST_NEST.obj,FIRST_NEST.for
$	delete/nolog FIRST_NEST.for;*
$	if ok
$	then
$	  ws ""
$	  libr FIRST_NEST
$	delete FIRST_NEST.obj;*
$	else
$	  delete FIRST_NEST.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING FLUSH_POLY....."
$	adc FLUSH_POLY=FLUSH_POLY
$	fort FLUSH_POLY
$	ok=$status
$	if ok then pvv FLUSH_POLY
$	delete /nolog adc.ide;
$	purge/nolog FLUSH_POLY.obj,FLUSH_POLY.for
$	delete/nolog FLUSH_POLY.for;*
$	if ok
$	then
$	  ws ""
$	  libr FLUSH_POLY
$	delete FLUSH_POLY.obj;*
$	else
$	  delete FLUSH_POLY.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING FORM_POLYGONS....."
$	adc FORM_POLYGONS=FORM_POLYGONS
$	fort FORM_POLYGONS
$	ok=$status
$	if ok then pvv FORM_POLYGONS
$	delete /nolog adc.ide;
$	purge/nolog FORM_POLYGONS.obj,FORM_POLYGONS.for
$	delete/nolog FORM_POLYGONS.for;*
$	if ok
$	then
$	  ws ""
$	  libr FORM_POLYGONS
$	delete FORM_POLYGONS.obj;*
$	else
$	  delete FORM_POLYGONS.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING FORMATION_SUMMARY....."
$	adc FORMATION_SUMMARY=FORMATION_SUMMARY
$	fort FORMATION_SUMMARY
$	ok=$status
$	if ok then pvv FORMATION_SUMMARY
$	delete /nolog adc.ide;
$	purge/nolog FORMATION_SUMMARY.obj,FORMATION_SUMMARY.for
$	delete/nolog FORMATION_SUMMARY.for;*
$	if ok
$	then
$	  ws ""
$	  libr FORMATION_SUMMARY
$	delete FORMATION_SUMMARY.obj;*
$	else
$	  delete FORMATION_SUMMARY.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING GEN_PNT_IN_POLY....."
$	adc GEN_PNT_IN_POLY=GEN_PNT_IN_POLY
$	fort GEN_PNT_IN_POLY
$	ok=$status
$	if ok then pvv GEN_PNT_IN_POLY
$	delete /nolog adc.ide;
$	purge/nolog GEN_PNT_IN_POLY.obj,GEN_PNT_IN_POLY.for
$	delete/nolog GEN_PNT_IN_POLY.for;*
$	if ok
$	then
$	  ws ""
$	  libr GEN_PNT_IN_POLY
$	delete GEN_PNT_IN_POLY.obj;*
$	else
$	  delete GEN_PNT_IN_POLY.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING GET_BOUNDARY_BOXES....."
$	adc GET_BOUNDARY_BOXES=GET_BOUNDARY_BOXES
$	fort GET_BOUNDARY_BOXES
$	ok=$status
$	if ok then pvv GET_BOUNDARY_BOXES
$	delete /nolog adc.ide;
$	purge/nolog GET_BOUNDARY_BOXES.obj,GET_BOUNDARY_BOXES.for
$	delete/nolog GET_BOUNDARY_BOXES.for;*
$	if ok
$	then
$	  ws ""
$	  libr GET_BOUNDARY_BOXES
$	delete GET_BOUNDARY_BOXES.obj;*
$	else
$	  delete GET_BOUNDARY_BOXES.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING GET_LINE_BOXES....."
$	adc GET_LINE_BOXES=GET_LINE_BOXES
$	fort GET_LINE_BOXES
$	ok=$status
$	if ok then pvv GET_LINE_BOXES
$	delete /nolog adc.ide;
$	purge/nolog GET_LINE_BOXES.obj,GET_LINE_BOXES.for
$	delete/nolog GET_LINE_BOXES.for;*
$	if ok
$	then
$	  ws ""
$	  libr GET_LINE_BOXES
$	delete GET_LINE_BOXES.obj;*
$	else
$	  delete GET_LINE_BOXES.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING GET_ALL_TRANS....."
$	adc GET_ALL_TRANS=GET_ALL_TRANS
$	fort GET_ALL_TRANS
$	ok=$status
$	if ok then pvv GET_ALL_TRANS
$	delete /nolog adc.ide;
$	purge/nolog GET_ALL_TRANS.obj,GET_ALL_TRANS.for
$	delete/nolog GET_ALL_TRANS.for;*
$	if ok
$	then
$	  ws ""
$	  libr GET_ALL_TRANS
$	delete GET_ALL_TRANS.obj;*
$	else
$	  delete GET_ALL_TRANS.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING GET_BIGGEST_TRANS....."
$	adc GET_BIGGEST_TRANS=GET_BIGGEST_TRANS
$	fort GET_BIGGEST_TRANS
$	ok=$status
$	if ok then pvv GET_BIGGEST_TRANS
$	delete /nolog adc.ide;
$	purge/nolog GET_BIGGEST_TRANS.obj,GET_BIGGEST_TRANS.for
$	delete/nolog GET_BIGGEST_TRANS.for;*
$	if ok
$	then
$	  ws ""
$	  libr GET_BIGGEST_TRANS
$	delete GET_BIGGEST_TRANS.obj;*
$	else
$	  delete GET_BIGGEST_TRANS.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING GET_BOUNDING....."
$	adc GET_BOUNDING=GET_BOUNDING
$	fort GET_BOUNDING
$	ok=$status
$	if ok then pvv GET_BOUNDING
$	delete /nolog adc.ide;
$	purge/nolog GET_BOUNDING.obj,GET_BOUNDING.for
$	delete/nolog GET_BOUNDING.for;*
$	if ok
$	then
$	  ws ""
$	  libr GET_BOUNDING
$	delete GET_BOUNDING.obj;*
$	else
$	  delete GET_BOUNDING.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING GET_INTER....."
$	adc GET_INTER=GET_INTER
$	fort GET_INTER
$	ok=$status
$	if ok then pvv GET_INTER
$	delete /nolog adc.ide;
$	purge/nolog GET_INTER.obj,GET_INTER.for
$	delete/nolog GET_INTER.for;*
$	if ok
$	then
$	  ws ""
$	  libr GET_INTER
$	delete GET_INTER.obj;*
$	else
$	  delete GET_INTER.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING GET_PNT_ON_SEG....."
$	adc GET_PNT_ON_SEG=GET_PNT_ON_SEG
$	fort GET_PNT_ON_SEG
$	ok=$status
$	if ok then pvv GET_PNT_ON_SEG
$	delete /nolog adc.ide;
$	purge/nolog GET_PNT_ON_SEG.obj,GET_PNT_ON_SEG.for
$	delete/nolog GET_PNT_ON_SEG.for;*
$	if ok
$	then
$	  ws ""
$	  libr GET_PNT_ON_SEG
$	delete GET_PNT_ON_SEG.obj;*
$	else
$	  delete GET_PNT_ON_SEG.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING NESTED_TREES....."
$	adc NESTED_TREES=NESTED_TREES
$	fort NESTED_TREES
$	ok=$status
$	if ok then pvv NESTED_TREES
$	delete /nolog adc.ide;
$	purge/nolog NESTED_TREES.obj,NESTED_TREES.for
$	delete/nolog NESTED_TREES.for;*
$	if ok
$	then
$	  ws ""
$	  libr NESTED_TREES
$	delete NESTED_TREES.obj;*
$	else
$	  delete NESTED_TREES.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING GET_POLPNT....."
$	adc GET_POLPNT=GET_POLPNT
$	fort GET_POLPNT
$	ok=$status
$	if ok then pvv GET_POLPNT
$	delete /nolog adc.ide;
$	purge/nolog GET_POLPNT.obj,GET_POLPNT.for
$	delete/nolog GET_POLPNT.for;*
$	if ok
$	then
$	  ws ""
$	  libr GET_POLPNT
$	delete GET_POLPNT.obj;*
$	else
$	  delete GET_POLPNT.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING GET_COORD....."
$	adc GET_COORD=GET_COORD
$	fort GET_COORD
$	ok=$status
$	if ok then pvv GET_COORD
$	delete /nolog adc.ide;
$	purge/nolog GET_COORD.obj,GET_COORD.for
$	delete/nolog GET_COORD.for;*
$	if ok
$	then
$	  ws ""
$	  libr GET_COORD
$	delete GET_COORD.obj;*
$	else
$	  delete GET_COORD.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING GET_TREE....."
$	adc GET_TREE=GET_TREE
$	fort GET_TREE
$	ok=$status
$	if ok then pvv GET_TREE
$	delete /nolog adc.ide;
$	purge/nolog GET_TREE.obj,GET_TREE.for
$	delete/nolog GET_TREE.for;*
$	if ok
$	then
$	  ws ""
$	  libr GET_TREE
$	delete GET_TREE.obj;*
$	else
$	  delete GET_TREE.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING GET_POLY....."
$	adc GET_POLY=GET_POLY
$	fort GET_POLY
$	ok=$status
$	if ok then pvv GET_POLY
$	delete /nolog adc.ide;
$	purge/nolog GET_POLY.obj,GET_POLY.for
$	delete/nolog GET_POLY.for;*
$	if ok
$	then
$	  ws ""
$	  libr GET_POLY
$	delete GET_POLY.obj;*
$	else
$	  delete GET_POLY.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING GET_ST_ADDRESSES....."
$	adc GET_ST_ADDRESSES=GET_ST_ADDRESSES
$	fort GET_ST_ADDRESSES
$	ok=$status
$	if ok then pvv GET_ST_ADDRESSES
$	delete /nolog adc.ide;
$	purge/nolog GET_ST_ADDRESSES.obj,GET_ST_ADDRESSES.for
$	delete/nolog GET_ST_ADDRESSES.for;*
$	if ok
$	then
$	  ws ""
$	  libr GET_ST_ADDRESSES
$	delete GET_ST_ADDRESSES.obj;*
$	else
$	  delete GET_ST_ADDRESSES.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING GET_STACK_POLY....."
$	adc GET_STACK_POLY=GET_STACK_POLY
$	fort GET_STACK_POLY
$	ok=$status
$	if ok then pvv GET_STACK_POLY
$	delete /nolog adc.ide;
$	purge/nolog GET_STACK_POLY.obj,GET_STACK_POLY.for
$	delete/nolog GET_STACK_POLY.for;*
$	if ok
$	then
$	  ws ""
$	  libr GET_STACK_POLY
$	delete GET_STACK_POLY.obj;*
$	else
$	  delete GET_STACK_POLY.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING HALF_TRANS....."
$	adc HALF_TRANS=HALF_TRANS
$	fort HALF_TRANS
$	ok=$status
$	if ok then pvv HALF_TRANS
$	delete /nolog adc.ide;
$	purge/nolog HALF_TRANS.obj,HALF_TRANS.for
$	delete/nolog HALF_TRANS.for;*
$	if ok
$	then
$	  ws ""
$	  libr HALF_TRANS
$	delete HALF_TRANS.obj;*
$	else
$	  delete HALF_TRANS.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING INIT_POLY....."
$	adc INIT_POLY=INIT_POLY
$	fort INIT_POLY
$	ok=$status
$	if ok then pvv INIT_POLY
$	delete /nolog adc.ide;
$	purge/nolog INIT_POLY.obj,INIT_POLY.for
$	delete/nolog INIT_POLY.for;*
$	if ok
$	then
$	  ws ""
$	  libr INIT_POLY
$	delete INIT_POLY.obj;*
$	else
$	  delete INIT_POLY.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING POLYGONS_INIT....."
$	adc POLYGONS_INIT=POLYGONS_INIT
$	fort POLYGONS_INIT
$	ok=$status
$	if ok then pvv POLYGONS_INIT
$	delete /nolog adc.ide;
$	purge/nolog POLYGONS_INIT.obj,POLYGONS_INIT.for
$	delete/nolog POLYGONS_INIT.for;*
$	if ok
$	then
$	  ws ""
$	  libr POLYGONS_INIT
$	delete POLYGONS_INIT.obj;*
$	else
$	  delete POLYGONS_INIT.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING INIT_LIMITS....."
$	adc INIT_LIMITS=INIT_LIMITS
$	fort INIT_LIMITS
$	ok=$status
$	if ok then pvv INIT_LIMITS
$	delete /nolog adc.ide;
$	purge/nolog INIT_LIMITS.obj,INIT_LIMITS.for
$	delete/nolog INIT_LIMITS.for;*
$	if ok
$	then
$	  ws ""
$	  libr INIT_LIMITS
$	delete INIT_LIMITS.obj;*
$	else
$	  delete INIT_LIMITS.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING GRAB_MEM....."
$	adc GRAB_MEM=GRAB_MEM
$	fort GRAB_MEM
$	ok=$status
$	if ok then pvv GRAB_MEM
$	delete /nolog adc.ide;
$	purge/nolog GRAB_MEM.obj,GRAB_MEM.for
$	delete/nolog GRAB_MEM.for;*
$	if ok
$	then
$	  ws ""
$	  libr GRAB_MEM
$	delete GRAB_MEM.obj;*
$	else
$	  delete GRAB_MEM.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING GET_LOGICAL....."
$	adc GET_LOGICAL=GET_LOGICAL
$	fort GET_LOGICAL
$	ok=$status
$	if ok then pvv GET_LOGICAL
$	delete /nolog adc.ide;
$	purge/nolog GET_LOGICAL.obj,GET_LOGICAL.for
$	delete/nolog GET_LOGICAL.for;*
$	if ok
$	then
$	  ws ""
$	  libr GET_LOGICAL
$	delete GET_LOGICAL.obj;*
$	else
$	  delete GET_LOGICAL.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING ISOLATIONS....."
$	adc ISOLATIONS=ISOLATIONS
$	fort ISOLATIONS
$	ok=$status
$	if ok then pvv ISOLATIONS
$	delete /nolog adc.ide;
$	purge/nolog ISOLATIONS.obj,ISOLATIONS.for
$	delete/nolog ISOLATIONS.for;*
$	if ok
$	then
$	  ws ""
$	  libr ISOLATIONS
$	delete ISOLATIONS.obj;*
$	else
$	  delete ISOLATIONS.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING LOCATE_TREES....."
$	adc LOCATE_TREES=LOCATE_TREES
$	fort LOCATE_TREES
$	ok=$status
$	if ok then pvv LOCATE_TREES
$	delete /nolog adc.ide;
$	purge/nolog LOCATE_TREES.obj,LOCATE_TREES.for
$	delete/nolog LOCATE_TREES.for;*
$	if ok
$	then
$	  ws ""
$	  libr LOCATE_TREES
$	delete LOCATE_TREES.obj;*
$	else
$	  delete LOCATE_TREES.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING LENGTH....."
$	adc LENGTH=LENGTH
$	fort LENGTH
$	ok=$status
$	if ok then pvv LENGTH
$	delete /nolog adc.ide;
$	purge/nolog LENGTH.obj,LENGTH.for
$	delete/nolog LENGTH.for;*
$	if ok
$	then
$	  ws ""
$	  libr LENGTH
$	delete LENGTH.obj;*
$	else
$	  delete LENGTH.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING LITES_ERR....."
$	adc LITES_ERR=LITES_ERR
$	fort LITES_ERR
$	ok=$status
$	if ok then pvv LITES_ERR
$	delete /nolog adc.ide;
$	purge/nolog LITES_ERR.obj,LITES_ERR.for
$	delete/nolog LITES_ERR.for;*
$	if ok
$	then
$	  ws ""
$	  libr LITES_ERR
$	delete LITES_ERR.obj;*
$	else
$	  delete LITES_ERR.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING MES_OUT....."
$	adc MES_OUT=MES_OUT
$	fort MES_OUT
$	ok=$status
$	if ok then pvv MES_OUT
$	delete /nolog adc.ide;
$	purge/nolog MES_OUT.obj,MES_OUT.for
$	delete/nolog MES_OUT.for;*
$	if ok
$	then
$	  ws ""
$	  libr MES_OUT
$	delete MES_OUT.obj;*
$	else
$	  delete MES_OUT.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING NESTS....."
$	adc NESTS=NESTS
$	fort NESTS
$	ok=$status
$	if ok then pvv NESTS
$	delete /nolog adc.ide;
$	purge/nolog NESTS.obj,NESTS.for
$	delete/nolog NESTS.for;*
$	if ok
$	then
$	  ws ""
$	  libr NESTS
$	delete NESTS.obj;*
$	else
$	  delete NESTS.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING NXTARM....."
$	adc NXTARM=NXTARM
$	fort NXTARM
$	ok=$status
$	if ok then pvv NXTARM
$	delete /nolog adc.ide;
$	purge/nolog NXTARM.obj,NXTARM.for
$	delete/nolog NXTARM.for;*
$	if ok
$	then
$	  ws ""
$	  libr NXTARM
$	delete NXTARM.obj;*
$	else
$	  delete NXTARM.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING PNT_IN_POLY....."
$	adc PNT_IN_POLY=PNT_IN_POLY
$	fort PNT_IN_POLY
$	ok=$status
$	if ok then pvv PNT_IN_POLY
$	delete /nolog adc.ide;
$	purge/nolog PNT_IN_POLY.obj,PNT_IN_POLY.for
$	delete/nolog PNT_IN_POLY.for;*
$	if ok
$	then
$	  ws ""
$	  libr PNT_IN_POLY
$	delete PNT_IN_POLY.obj;*
$	else
$	  delete PNT_IN_POLY.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING PNTPOL....."
$	adc PNTPOL=PNTPOL
$	fort PNTPOL
$	ok=$status
$	if ok then pvv PNTPOL
$	delete /nolog adc.ide;
$	purge/nolog PNTPOL.obj,PNTPOL.for
$	delete/nolog PNTPOL.for;*
$	if ok
$	then
$	  ws ""
$	  libr PNTPOL
$	delete PNTPOL.obj;*
$	else
$	  delete PNTPOL.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING POLY_COMPLETE....."
$	adc POLY_COMPLETE=POLY_COMPLETE
$	fort POLY_COMPLETE
$	ok=$status
$	if ok then pvv POLY_COMPLETE
$	delete /nolog adc.ide;
$	purge/nolog POLY_COMPLETE.obj,POLY_COMPLETE.for
$	delete/nolog POLY_COMPLETE.for;*
$	if ok
$	then
$	  ws ""
$	  libr POLY_COMPLETE
$	delete POLY_COMPLETE.obj;*
$	else
$	  delete POLY_COMPLETE.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING POLY_EXTEND....."
$	adc POLY_EXTEND=POLY_EXTEND
$	fort POLY_EXTEND
$	ok=$status
$	if ok then pvv POLY_EXTEND
$	delete /nolog adc.ide;
$	purge/nolog POLY_EXTEND.obj,POLY_EXTEND.for
$	delete/nolog POLY_EXTEND.for;*
$	if ok
$	then
$	  ws ""
$	  libr POLY_EXTEND
$	delete POLY_EXTEND.obj;*
$	else
$	  delete POLY_EXTEND.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING REVERSE....."
$	adc REVERSE=REVERSE
$	fort REVERSE
$	ok=$status
$	if ok then pvv REVERSE
$	delete /nolog adc.ide;
$	purge/nolog REVERSE.obj,REVERSE.for
$	delete/nolog REVERSE.for;*
$	if ok
$	then
$	  ws ""
$	  libr REVERSE
$	delete REVERSE.obj;*
$	else
$	  delete REVERSE.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING READ_NEXT_JUNCT....."
$	adc READ_NEXT_JUNCT=READ_NEXT_JUNCT
$	fort READ_NEXT_JUNCT
$	ok=$status
$	if ok then pvv READ_NEXT_JUNCT
$	delete /nolog adc.ide;
$	purge/nolog READ_NEXT_JUNCT.obj,READ_NEXT_JUNCT.for
$	delete/nolog READ_NEXT_JUNCT.for;*
$	if ok
$	then
$	  ws ""
$	  libr READ_NEXT_JUNCT
$	delete READ_NEXT_JUNCT.obj;*
$	else
$	  delete READ_NEXT_JUNCT.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING SET_LRUSED....."
$	adc SET_LRUSED=SET_LRUSED
$	fort SET_LRUSED
$	ok=$status
$	if ok then pvv SET_LRUSED
$	delete /nolog adc.ide;
$	purge/nolog SET_LRUSED.obj,SET_LRUSED.for
$	delete/nolog SET_LRUSED.for;*
$	if ok
$	then
$	  ws ""
$	  libr SET_LRUSED
$	delete SET_LRUSED.obj;*
$	else
$	  delete SET_LRUSED.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING START_LITES2....."
$	adc START_LITES2=START_LITES2
$	fort START_LITES2
$	ok=$status
$	if ok then pvv START_LITES2
$	delete /nolog adc.ide;
$	purge/nolog START_LITES2.obj,START_LITES2.for
$	delete/nolog START_LITES2.for;*
$	if ok
$	then
$	  ws ""
$	  libr START_LITES2
$	delete START_LITES2.obj;*
$	else
$	  delete START_LITES2.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING SEGDIR....."
$	adc SEGDIR=SEGDIR
$	fort SEGDIR
$	ok=$status
$	if ok then pvv SEGDIR
$	delete /nolog adc.ide;
$	purge/nolog SEGDIR.obj,SEGDIR.for
$	delete/nolog SEGDIR.for;*
$	if ok
$	then
$	  ws ""
$	  libr SEGDIR
$	delete SEGDIR.obj;*
$	else
$	  delete SEGDIR.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING STORE_TRANS....."
$	adc STORE_TRANS=STORE_TRANS
$	fort STORE_TRANS
$	ok=$status
$	if ok then pvv STORE_TRANS
$	delete /nolog adc.ide;
$	purge/nolog STORE_TRANS.obj,STORE_TRANS.for
$	delete/nolog STORE_TRANS.for;*
$	if ok
$	then
$	  ws ""
$	  libr STORE_TRANS
$	delete STORE_TRANS.obj;*
$	else
$	  delete STORE_TRANS.obj;*
$	endif
$	set noverify
$	on control_y then goto err
$	on control_c then goto err
$	on error then goto err
$	ws ""
$	ws "------------------------------------COMPILING TAB_BUILD....."
$	adc TAB_BUILD=TAB_BUILD
$	fort TAB_BUILD
$	ok=$status
$	if ok then pvv TAB_BUILD
$	delete /nolog adc.ide;
$	purge/nolog TAB_BUILD.obj,TAB_BUILD.for
$	delete/nolog TAB_BUILD.for;*
$	if ok
$	then
$	  ws ""
$	  libr TAB_BUILD
$	delete TAB_BUILD.obj;*
$	else
$	  delete TAB_BUILD.obj;*
$	endif
$err:	set noverify
$	if emsg.nes."" 
$	then
$	  ws ""
$	  ws "-----ERROR--------ERROR--------ERROR--------ERROR-----"
$	  ws "Compilation errors in:"
$	  ws emsg
$	  ws ""
$	  ws "------------------------------------------------------"
$	  ws ""
$	endif
$polygonsex:
$	deass/group lsl$newpolygons_building
$	set nover
