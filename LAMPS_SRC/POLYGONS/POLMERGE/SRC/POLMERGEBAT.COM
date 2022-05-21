$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-09 13:42:12.000000000 +0100
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
$	ws= "write sys$output"
$	set noverify
$	on control_y then goto polmergeex
$!
$	is_build = f$logical("lsl$polmerge_building")
$	if "''is_build'" .eqs. "in_progress"
$	then
$	  ws "Someone else is building"
$	  exit
$	endif
$!
$	define/group lsl$polmerge_building "in_progress"
$ assign lsl$source_root:[polygons.polmerge] lsl$cmnpolmerge
$ assign lsl$source_root:[polygons.service] lsl$cmnpolygons
$ assign lsl$source_root:[polygons.lib] lsl$cmnpolygonsl
$	sd:=$lsl$sys:sd
$	set noon
$	emsg= ""
$	set noverify
$errs:
$	if emsg.eqs.""
$	then
$	  ws "Hurrah!...there were no compilation errors"
$	else
$	  ws ""
$	  ws "+-----------------------------------------------------"
$	  ws "|               Compilation errors in:"
$	  ws emsg
$	  ws "+-----------------------------------------------------"
$	  ws ""
$	  goto polmergeex
$	endif
$	set noverify
$	ws ""
$	ws "------------------------------------------------"
$	ws "                  VERSION"
$	ws "------------------------------------------------"
$	run lsl$exe:genver
$	purge/nolog version.src
$	ws ""
$	ws ""
$	ws "COMPILING    VERSION......"
$	adc VERSION=VERSION
$	set verify
$	fort/ext VERSION
$	ok=$status
$	set noverify
$	if ok then pvv VERSION
$	purge/nolog VERSION.obj
$	purge/nolog VERSION.for
$	if .not.ok
$	then
$	  delete adc.ide;*
$	  emsg=emsg+" VERSION"
$	  goto errs
$	endif
$	ws ""
$	ws "------------------------------------------------"
$	ws "                  LINKING"
$	ws "------------------------------------------------"
$ set verify
$	link/map/exe=polmerge POLMERGE,-
		polmerge_cld,cmdlin,open_file,close_files, -
		identify_seed,skip_layer,framed_mes,-
		form_boxes,check_segac_label,check_ac_text,  -
		read_ac_text,calc_areas_ratios,FLAG_ISOLATIONS, -
		amalgamate, merge, -
		get_neigh,  find_largest, -
		update_segments, isol_poly, outifj,iff_header, -
		writpol,find_smallest,get_actxt, -
		check_same,flush_line,flush_out,st_out,GET_SECOND, -
		get_polygon,complex,find_common,adjacent, -
		update_complex,exterminate,eliminate, -
		GET_BY_TEXT,neighbours,merge_for_elim,-
		find_others,read_lookup,remove_double_spaces,-
		test_second_poly_label,test_primary_poly_labl,-
		merge_by_lookup,eliminate_by_lookup,- 
		eliminate_by_higher,eliminate_by_lower,-
		merge_by_lower,merge_by_higher,check_numeric_label,-
		check_node_neigh,check_ac,check_isol,complex_phan, - 
		update_range,get_mother,-
		version, -
		polmerge.promsg_obj, -
		lsl$library:pmeclock.obj, -
		lsl$cmnpolygonsl:polygons/lib/include=polygons, -
		LSL$LIBRARY:IFFSHR.OPT/OPT,-
		LSL$LIBRARY:LSLSHR.OPT/OPT
$	polmergeex:
$	deass/group lsl$polmerge_building
$	set nover
