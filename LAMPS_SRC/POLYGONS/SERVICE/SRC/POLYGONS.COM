$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-27 18:43:42.000000000 +0100
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
$! Command file to build the polygons package service routines
$!
$! Copyright Laser-Scan Limited, Cambridge, England.
$!
$!CMOD	minor modifications			SG	28/04/92
$!
$	ver=f$verify(0)
$	ws="WRITE sys$output"
$!
$	on error then goto polygonsex
$!
$	disk:='f$logical("sys$disk")'
$!
$	is_build = f$logical("lsl$newpolygons_building")
$	if "''is_build'" .eqs. "in_progress"
$	then
$	   ws "Someone else is building"
$	   inq/nop regardless "  carry on regardless? "
$	   if .not.regardless then exit
$	endif
$!
$	on control_y then goto polygonsex
$	define/group lsl$newpolygons_building "in_progress"
$!
$	open/write comfil polygonsbat.com
$	on control_y then goto filclo
$	on error then goto filclo
$!
$	wc="write comfil"
$!
$	wc "$	ws=""write sys$output"""
$	wc "$	set noverify"
$	wc "$	on control_y then goto polygonsex"
$	wc "$!"
$	wc "$	is_build = f$logical(""lsl$newpolygons_building"")"
$	wc "$	if ""'","'is_build'"" .eqs. ""in_progress"""
$	wc "$	then"
$	wc "$	  ws ""Someone else is building"""
$	wc "$	  exit"
$	wc "$	endif"
$	wc "$!"
$	wc "$	define/group lsl$newpolygons_building ""in_progress"""
$	wc "$	assign lsl$source_root:[polygons.service.src] lsl$cmnpolygons"
$	wc "$	set noon"
$	wc "$	emsg="""""
$!
$	mldbg=""
$	fsw1=""
$	kpcom=""
$	mdeb=""
$	polygons_dbg=""
$	mes=""
$	insert = ""
$!
$	ws ""
$	inquire/nop compile "Compile ? "
$	if compile
$	then
$	   inquire/nop polygons_dbg "  With Debug ? "
$	   if polygons_dbg
$	   then
$		fsw1	= "/debug/noopt/check=(bounds,overflow)/list"
$		kpcom	= "/co"
$		mldbg	= "/debug"
$		mdeb	= "/Enable=debug"
$	   endif
$	else
$	  ws ""
$	  inquire /nop insert "Insert precompiled things into Library ? "
$	endif
$!
$	if insert.or.compile
$	then
$	   ws ""
$	   inq/nop everything "  all sources ? "
$	   if everything
$	   then
$		abort_poly		="t"
$		addnod			="t"
$		add_quotes		="t"
$		area			="t"
$		binsea			="t"
$		bitmap			="t"
$		box_init		="t"
$		box_poly		="t"
$		calc_boxes		="t"
$		calc_range		="t"
$		check_junction		="t"
$		clear_trans		="t"
$		copy_string		="t"
$		duplicates		="t"
$		duff_poly		="t"
$		extract_loops		="t"
$		first_nest		="t"
$		find_current_arm	="t"
$		find_poly		="t"
$		flush_poly		="t"
$		form_polygons		="t"
$		formation_summary	="t"
$		gen_pnt_in_poly		="t"
$		get_bounding		="t"
$		get_logical		="t"
$		get_polpnt		="t"
$		get_poly		="t"
$		get_coord		="t"
$		get_st_addresses	="t"
$		get_stack_poly		="t"
$		get_tree		="t"
$		get_boundary_boxes	="t"
$		get_line_boxes		="t"
$		get_all_trans		="t"
$		get_biggest_trans	="t"
$		get_inter		="t"
$		get_pnt_on_seg		="t"
$		grab_mem		="t"
$		half_trans		="t"
$		init_limits		="t"
$		init_poly		="t"
$		isolations		="t"
$		length			="t"
$		lites_err		="t"
$		locate_trees		="t"
$		mes_out			="t"
$		nested_trees		="t"
$		nests			="t"
$		nxtarm			="t"
$		pnt_in_poly		="t"
$		pntpol			="t"
$		poly_complete		="t"
$		poly_extend		="t"
$		polygons_init		="t"
$		read_next_junct		="t"
$		reverse			="t"
$		segdir			="t"
$		set_lrused		="t"
$		side_tab		="t"
$		start_lites2		="t"
$		store_trans		="t"
$		tab_build		="t"
$	   else
$		inq/nop abort_poly		"   abort_poly ? "
$		inq/nop addnod			"   addnod ? "
$		inq/nop add_quotes		"   add_quotes ? "
$		inq/nop area			"   area ? "
$		inq/nop binsea			"   binsea ? "
$		inq/nop bitmap			"   bitmap ? "
$		inq/nop box_init		"   box_init ? "
$		inq/nop box_poly		"   box_poly ? "
$		inq/nop calc_boxes		"   calc_boxes ? "
$		inq/nop calc_range		"   calc_range ? "
$		inq/nop check_junction		"   check_junction ? "
$		inq/nop clear_trans		"   clear_trans ? "
$		inq/nop copy_string		"   copy_string ? "
$		inq/nop duff_poly		"   duff_poly ? "
$		inq/nop duplicates		"   duplicates ? "
$		inq/nop extract_loops		"   extract_loops ? "
$		inq/nop find_current_arm	"   find_current_arm ? "
$		inq/nop find_poly		"   find_poly ? "
$		inq/nop first_nest		"   first_nest ? "
$		inq/nop flush_poly		"   flush_poly ? "
$		inq/nop formation_summary	"   formation_summary ? "
$		inq/nop form_polygons		"   form_polygons ? "
$		inq/nop gen_pnt_in_poly		"   gen_pnt_in_poly ? "
$		inq/nop get_all_trans		"   get_all_trans ? "
$		inq/nop get_biggest_trans	"   get_biggest_trans ? "
$		inq/nop get_boundary_boxes	"   get_boundary_boxes ? "
$		inq/nop get_bounding		"   get_bounding ? "
$		inq/nop get_coord		"   get_coord ? "
$		inq/nop get_logical		"   get_logical ? "
$		inq/nop get_inter		"   get_inter ? "
$		inq/nop get_line_boxes		"   get_line_boxes ? "
$		inq/nop get_pnt_on_seg		"   get_pnt_on_seg ?"
$		inq/nop get_polpnt		"   get_polpnt ? "
$		inq/nop get_poly		"   get_poly ? "
$		inq/nop get_st_addresses	"   get_st_addresses ? "
$		inq/nop get_stack_poly		"   get_stack_poly ? "
$		inq/nop get_tree		"   get_tree ? "
$		inq/nop grab_mem		"   grab_mem ? "
$		inq/nop half_trans		"   half_trans ? "
$		inq/nop init_limits		"   init_limits ? "
$		inq/nop init_poly		"   init_poly ? "
$		inq/nop isolations		"   isolations ? "
$		inq/nop length			"   length ? "
$		inq/nop lites_err		"   lites_err ? "
$		inq/nop locate_trees		"   locate_trees ? "
$		inq/nop mes_out			"   mes_out ? "
$		inq/nop nested_trees		"   nested_trees ? "
$		inq/nop nests			"   nests ? "
$		inq/nop nxtarm			"   nxtarm ? "
$		inq/nop pnt_in_poly		"   pnt_in_poly ? "
$		inq/nop pntpol			"   pntpol ? "
$		inq/nop poly_complete		"   poly_complete ? "
$		inq/nop poly_extend		"   poly_extend ? "
$		inq/nop polygons_init		"   polygons_init ? "
$		inq/nop read_next_junct		"   read_next_junct ? "
$		inq/nop reverse			"   reverse ? "
$		inq/nop segdir			"   segdir ? "
$		inq/nop set_lrused		"   set_lrused ? "
$		inq/nop side_tab		"   side_tab ? "
$		inq/nop start_lites2		"   start_lites2 ? "
$		inq/nop store_trans		"   store_trans ? "
$		inq/nop tab_build		"   tab_build ? "
$	   endif
$	   ws ""
$	   inq/nop mes "  Generate message definitions ? " 
$	endif
$!
$	ws ""
$	inq/nop newlib "Create new polygons library ? "
$	if newlib
$	then
$	   wc "$	ws """""
$	   wc "$	ws ""-----------------------------Creating library..."""
$	   wc "$	library/create  [polygons.lib]polygons"
$	   wc "$	libr = ""library/insert/log  [polygons.lib]polygons"""
$	else
$	   ws "%SYS-I-UNFRNDLYMSG replacing entries in current library"
$	   wc "$	libr = ""library/replace/log  [polygons.lib]polygons"""
$	endif
$!
$	inq/nop remove_ins "  Delete object files after insertion in library ? "
$!  
$	if compile.or.insert
$	then
$	  ws ""
$	  ws "generating instructions for compiler......"
$	  if mes
$	  then
$	    wc "$ set noverify" 
$	    wc "$ ws """""
$	    wc "$ ws ""---------------------Creating message definitions....."""
$	    wc "$ newmsg/num=1246/nam=poly/pref=poly__/par=for/run polygons.mes"
$	    wc "$ @polygons.temp_com"
$	    wc "$ if $status then libr polygons.promsg_obj"
$	    wc "$ ws """""
$	  endif
$	  if abort_poly		then	call compiler abort_poly
$	  if addnod		then	call compiler addnod
$	  if add_quotes		then	call compiler add_quotes
$	  if area		then	call compiler area
$	  if binsea		then	call compiler binsea
$	  if  bitmap
$	  then
$	    wc "$	ws """""
$	    wc "$	ws ""----------Compiling BITMAP (that macro thing)..."""
$	    wc "$	MACRO''mdeb' BITMAP"
$	    wc "$	if $status then libr bitmap.obj"
$	  endif
$	  if box_init		then	call compiler box_init
$	  if box_poly 		then	call compiler box_poly
$	  if calc_boxes 	then	call compiler calc_boxes
$	  if calc_range		then	call compiler calc_range
$	  if check_junction	then	call compiler check_junction
$	  if clear_trans	then	call compiler clear_trans
$	  if copy_string	then	call compiler copy_string
$	  if duff_poly		then	call compiler duff_poly
$	  if duplicates		then	call compiler duplicates
$	  if extract_loops	then	call compiler extract_loops
$	  if find_current_arm	then	call compiler find_current_arm
$	  if find_poly		then	call compiler find_poly
$	  if first_nest		then	call compiler first_nest
$	  if flush_poly		then	call compiler flush_poly
$	  if form_polygons	then	call compiler form_polygons
$	  if formation_summary	then	call compiler formation_summary
$	  if gen_pnt_in_poly	then	call compiler gen_pnt_in_poly
$	  if get_boundary_boxes	then	call compiler get_boundary_boxes
$	  if get_line_boxes	then	call compiler get_line_boxes
$	  if get_all_trans 	then	call compiler get_all_trans
$	  if get_biggest_trans	then	call compiler get_biggest_trans
$	  if get_bounding	then	call compiler get_bounding
$	  if get_inter		then	call compiler get_inter
$	  if get_pnt_on_seg	then	call compiler get_pnt_on_seg
$	  if nested_trees	then	call compiler nested_trees 
$	  if get_polpnt		then	call compiler get_polpnt
$	  if get_coord		then	call compiler get_coord
$	  if get_tree		then	call compiler get_tree
$	  if get_poly		then	call compiler get_poly
$	  if get_st_addresses	then	call compiler get_st_addresses
$	  if get_stack_poly	then	call compiler get_stack_poly
$	  if half_trans		then	call compiler half_trans
$	  if init_poly		then	call compiler init_poly
$	  if polygons_init	then	call compiler polygons_init
$	  if init_limits	then	call compiler init_limits
$	  if grab_mem		then	call compiler grab_mem
$	  if get_logical	then	call compiler get_logical
$	  if isolations		then	call compiler isolations
$	  if locate_trees	then	call compiler locate_trees
$	  if length		then	call compiler length
$	  if lites_err		then	call compiler lites_err
$	  if mes_out		then	call compiler mes_out
$	  if nests		then	call compiler nests
$	  if nxtarm		then	call compiler nxtarm
$	  if pnt_in_poly	then	call compiler pnt_in_poly
$	  if pntpol		then	call compiler pntpol
$	  if poly_complete	then	call compiler poly_complete
$	  if poly_extend	then	call compiler poly_extend
$	  if reverse		then	call compiler reverse
$	  if read_next_junct	then	call compiler read_next_junct
$	  if set_lrused		then	call compiler set_lrused
$	  if start_lites2	then	call compiler start_lites2
$	  if segdir		then	call compiler segdir
$	  if store_trans	then	call compiler store_trans
$	  if tab_build		then	call compiler tab_build
$	endif
$!
$	wc "$err:	set noverify"
$	wc "$	if emsg.nes."""" "
$	wc "$	then"
$	wc "$	  ws """""
$	wc "$	  ws ""-----ERROR--------ERROR--------ERROR--------ERROR-----"""
$	wc "$	  ws ""Compilation errors in:"""
$	wc "$	  ws emsg"
$	wc "$	  ws """""
$	wc "$	  ws ""------------------------------------------------------"""
$	wc "$	  ws """""
$	wc "$	endif"
$!
$	wc "$polygonsex:"
$	wc "$	deass/group lsl$newpolygons_building"
$	wc "$	set nover"
$!
$filclo:
$	set noverify
$	on error then goto polygonsex
$!
$	close comfil
$	ok=$status
$	deass/group lsl$newpolygons_building
$!
$	ws ""
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if answer_bat
$	then
$	  bat polygonsbat.com
$	else
$	  if ok then inq/nop answer "  Interactive ? "
$	  if answer
$	  then
$set ver
$	     @polygonsbat.com
$	  else
$	     ws "    ************* I didnt have anything to do! **************"
$	  endif
$	endif
$!
$polygonsex:
$	if ver then set verify
$	exit
$!
$!
$compiler: subroutine
$	on control_y then exit 4
$	on control_c then exit 4
$	on error then exit 3
$!
$	if compile
$	then
$	  wc "$	set noverify"
$	  wc "$	on control_y then goto err"
$	  wc "$	on control_c then goto err"
$	  wc "$	on error then goto err"
$	  wc "$	ws """""
$	  wc "$	ws ""------------------------------------COMPILING ''p1'....."""
$	  wc "$	adc ''p1'''kpcom'=''p1'"
$	  wc "$	fort''fsw1' ''p1'"
$	  wc "$	ok=$status"	
$	  wc "$	if ok then pvv ''p1'"
$	  wc "$	delete /nolog adc.ide;"
$	  wc "$	purge/nolog ''p1'.obj,''p1'.for"
$	  if fsw1.eqs."" then wc "$	delete/nolog ''p1'.for;*"
$	  if (f$locate("list",fsw1).ne.f$length(fsw1)).and. f$length(fsw1).ne.0
$	  then
$		wc "$	if ok then delete/nolog ''p1'.lis;*"
$	  endif
$	endif
$!
$	  wc "$	if ok"
$	  wc "$	then"
$	  wc "$	  ws """""
$	  wc "$	  libr ''p1'"
$	  if  remove_ins
$	  then
$	    wc "$	delete ''p1'.obj;*"
$	  else
$	    wc "$	purge/nolog ''p1'.obj"
$	  endif
$	  wc "$	else"
$	  wc "$	  delete ''p1'.obj;*"
$	  wc "$	endif"
$!
$	return
$endsubroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
