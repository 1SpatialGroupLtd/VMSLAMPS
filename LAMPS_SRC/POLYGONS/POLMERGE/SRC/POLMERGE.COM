$!
$! Command file to build POLYGONS utility polmerge
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!	Created						TJH 12-Jan-1987
$!
$	ver=f$verify(0)
$!
$	on error then goto polmergeex
$!
$	disk:='f$logical("sys$disk")'
$!
$	is_build = f$logical("lsl$polmerge_building")
$	if "''is_build'" .eqs. "in_progress" 
$	then
$	  ws "Someone else is building"
$	  inquire goon "   Carry on regardless? "
$	  if .not.goon then exit
$	endif
$!
$	on control_y then goto polmergeex
$	define/group lsl$polmerge_building "in_progress"
$!
$	open/write comfil polmergebat.com
$!
$	on control_y then goto filclo
$	on error then goto filclo
$!
$	ws= "write sys$output"
$	wc= "write comfil"
$!
$	wc "$	ws= ""write sys$output"""
$	wc "$	set noverify"
$	wc "$	on control_y then goto polmergeex"
$	wc "$!"
$	wc "$	is_build = f$logical(""lsl$polmerge_building"")"
$	wc "$	if ""'","'is_build'"" .eqs. ""in_progress""" 
$	wc "$	then"
$	wc "$	  ws ""Someone else is building"""
$	wc "$	  exit"
$	wc "$	endif"
$	wc "$!"
$	wc "$	define/group lsl$polmerge_building ""in_progress"""
$	wc "$ assign lsl$source_root:[polygons.polmerge.src] lsl$cmnpolmerge"
$	wc "$ assign lsl$source_root:[polygons.service.src] lsl$cmnpolygons"
$	wc "$ assign lsl$source_root:[polygons.lib] lsl$cmnpolygonsl"
$	wc "$	sd:=$lsl$sys:sd"
$	wc "$	set noon"
$	wc "$	emsg= """""
$!
$	mldbg= ""
$	fsw1= "/ext"
$	kpcom= ""
$	trnall= ""
$	polmerge_dbg= ""
$	macbuild= ""
$	cld= ""
$	mes= ""
$	inquire/nop compile "Compile ? "
$	if compile
$	then
$	   addnod			= "f"
$	   amalgamate			= "f"
$	   adjacent			= "f"
$	   area				= "f"
$	   binsea			= "f"
$	   box_init			= "f"
$	   box_poly			= "f"
$	   box_reset			= "f"
$	   calc_areas_ratios		= "f"
$	   calc_boxes			= "f"
$	   check_node_neigh		= "f"
$	   check_ac_text		= "f"
$	   read_ac_text			= "f"
$	   check_segac_label		= "f"
$	   check_numeric_label		= "f"
$	   duplicates			= "f"
$	   duff_poly			= "f"
$	   neighbours			= "f"
$	   get_by_text			= "f"
$	   find_others			= "f"
$	   eliminate			= "f"
$	   exterminate			= "f"
$	   merge_for_elim		= "f"
$	   merge_by_lookup		= "f"
$	   merge_by_lower		= "f"
$	   merge_by_higher		= "f"
$	   eliminate_by_lookup		= "f"
$	   eliminate_by_lower		= "f"
$	   eliminate_by_higher		= "f"
$	   find_largest			= "f"
$	   find_smallest		= "f"
$	   framed_mes			= "f"
$	   skip_layer			= "f"
$	   get_neigh			= "f"
$	   find_common			= "f"
$	   complex			= "f"
$	   complex_phan			= "f"
$	   check_isol			= "f"
$	   get_mother			= "f"
$	   update_range			= "f"
$	   get_polygon			= "f"
$	   nests			= "f"
$	   nxtarm			= "f"
$	   set_lrused			= "f"
$	   calc_range			= "f"
$	   close_files			= "f"
$	   cmdlin			= "f"
$	   first_nest			= "f"
$	   form_boxes			= "f"
$	   form_polygons		= "f"
$	   get_actxt			= "f"
$	   get_bounding			= "f"
$	   get_polpnt			= "f"
$	   get_poly			= "f"
$	   iff_header			= "f"
$	   isol_poly			= "f"
$	   merge			= "f"
$	   outifj			= "f"
$	   polmerge			= "f"
$	   flag_isolations		= "F"
$	   mes_out			= "f"
$	   open_file			= "f"
$	   writpol			= "f"
$	   check_same			= "f"
$	   get_second			= "F"
$	   flush_out			= "f"
$	   flush_line			= "f"
$	   st_out			= "f"
$	   check_ac			= "f"
$	   pntpol			= "f"
$	   read_lookup			= "f"
$	   remove_ds			= "f"
$	   reverse			= "f"
$	   identify_seed		= "f"
$	   test_primary_poly_label	= "f"
$	   test_second_poly_label	= "f"
$	   update_segments		= "f"
$	   update_segments_complex	= "f"
$!
$	   inquire/nop polmerge_dbg "   With Debug ? "
$	   if polmerge_dbg
$	   then
$		mldbg= "/debug"
$		fsw1= "/ext/debug/noopt/check=(bounds,overflow)/list/co"
$	   endif
$!
$!
$	   ws ""
$	   inq/nop everything "   Compile all sources ? "
$	   if  everything
$	   then
$		amalgamate		= "t"
$		adjacent		= "t"
$		calc_areas_ratios	= "t"
$		check_node_neigh	= "t"
$		check_ac_text		= "t"
$		read_ac_text		= "t"
$		check_segac_label	= "t"
$		check_numeric_label	= "t"
$		neighbours		= "t"
$		get_by_text		= "t"
$		find_others		= "t"
$		merge_for_elim		= "t"
$		eliminate		= "t"
$		exterminate		= "t"
$		merge_by_lookup		= "t"
$		merge_by_lower		= "t"
$		merge_by_higher		= "t"
$		eliminate_by_lookup	= "t"
$		eliminate_by_lower	= "t"
$		eliminate_by_higher	= "t"
$		find_largest		= "t"
$		find_smallest		= "t"
$		framed_mes		= "t"
$		skip_layer		= "t"
$		get_neigh		= "t"
$		find_common		= "t"
$		complex			= "t"
$		complex_phan		= "t"
$		check_isol		= "t"
$		get_mother		= "t"
$		update_range		= "t"
$		get_polygon		= "t"
$		close_files		= "t"
$		cmdlin			= "t"
$		form_boxes		= "t"
$		get_actxt		= "t"
$		get_bounding		= "t"
$		iff_header		= "t"
$		isol_poly		= "t"
$		merge			= "t"
$		outifj			= "t"
$		polmerge		= "t"
$		flag_isolations		= "T"
$		open_file		= "t"
$		writpol			= "t"
$		check_same		= "t"
$		get_second		= "T"
$		flush_out		= "t"
$		flush_line		= "t"
$		st_out			= "t"
$		check_ac		= "t"
$		read_lookup		= "t"
$		remove_ds		= "t"
$		identify_seed		= "t"
$		test_primary_poly_label	= "t"
$		test_second_poly_label	= "t"
$		update_segments		= "t"
$		update_segments_complex	= "t"
$	   else
$!
$	     ws " "
$	     inq/nop polmerge	"polmerge ? "
$!
$	     ws " "
$	     ws " "
$	     ws ">> READ_LOOKUP, REMOVE_DOUBLE_SPACES, TEST_PRIMARY_POLY_LABEL"
$	     ws ">> TEST_SECONDARY_POLY_LABEL, CHECK_NUMERIC_LABEL"
$	     ws " "
$	     inq/nop next_lot	"Lookup Table and Label Stuff ?"
$	     if next_lot
$	     then
$		inq/nop check_numeric_label	"  CHECK_NUMERIC_LABEL ? "
$	  	inq/nop read_lookup		"  READ_LOOKUP ? "
$		inq/nop remove_ds		"  REMOVE_DOUBLE_SPACES ? "
$		inq/nop test_primary_poly_label	"  TEST_PRIMARY_POLY_LABEL ? "
$		inq/nop test_second_poly_label	"  TEST_SECONDARY_POLY_LABEL ? "
$	     endif
$!
$	     ws " "
$	     ws ">> CLOSE_FILES, CMDLIN, OPEN_FILE, OP_SPECS"
$	     ws " "
$	     inq/nop next_lot	"Command Line Decoding and File Routines ?"
$	     if next_lot
$	     then
$		inq/nop close_files		"  CLOSE_FILES ? "
$		inq/nop cmdlin			"  CMDLIN ? "
$		inq/nop open_file		"  OPEN_FILE ? "
$		inq/nop op_specs		"  OP_SPECS ? "
$	     endif
$!
$	     ws " "
$	     ws ">> IDENTIFY SEED"
$	     ws " "
$	     inq/nop next_lot	"Lookup Table Construction ?"
$	     if next_lot
$	     then
$		inq/nop isentify_seed		"  IDENTIFY_SEED ? "
$	     endif
$!
$	     ws " "
$	     ws ">> SKIP LAYER, FRAMED_MES, CHECK_AC_TEXT, READ_AC_TEXT"
$	     WS ">> GET_SEGAC_LABEL"
$	     ws " "
$	     inq/nop next_lot	"Checks and Messages ?"
$	     if next_lot
$	     then
$		inq/nop check_ac_text		"  CHECK_AC_TEXT? "
$		inq/nop framed_mes		"  FRAMED_MES ? "
$		inq/nop get_segac_label		"  GET_SEGAC_LABEL? "
$		inq/nop read_ac_text		"  READ_AC_TEXT? "
$		inq/nop skip_layer		"  SKIP_LAYER ? "
$	     endif
$!
$	     ws " "
$	     ws ">> ISOL_POLYGON, GET_POLYGON, FLAG_ISOLATIONS, CALC_AREAS_RA.."
$	     ws " "
$	     inq/nop next_lot	"Polygon Formation/Manipulation ?"
$	     if next_lot
$	     then
$		inq/nop calc_areas_ratios	"  CALC_AREAS_RATIOS ? "
$		inq/nop FLAG_ISOLATIONS		"  FLAG_ISOLATIONS ? "
$		inq/nop get_polygon		"  GET_POLYGON ? "
$		inq/nop isol_poly		"  ISOL_POLY ? "
$	     endif
$!
$	     ws " "
$	     ws ">> FORM BOXES"
$	     ws " "
$	     inq/nop next_lot	" Box Structure ?"
$	     if next_lot
$	     then
$		inq/nop form_boxes		"  FORM_BOXES ? "
$	     endif
$!
$	     ws " "
$	     ws ">> OUTIFJ, IFF HEADER, WRITPOL, CHECK_SAME, GET_SECOND, 
$	     ws ">> FLUSH_OUT, ST_OUT, FLUSH_LINE, CHECK_AC, GET_AC_TEXT"
$	     ws ">> "
$	     ws " "
$	     inq/nop next_lot	"File Output Routines ?"
$	     if next_lot
$	     then
$		inq/nop check_ac	"  CHECK_AC ? "
$		inq/nop check_same	"  CHECK_SAME ? "
$		inq/nop flush_line	"  FLUSH_LINE ? "
$		inq/nop flush_out	"  FLUSH_OUT ? "
$		inq/nop get_actxt	"  GET_ACTXT ? "
$		inq/nop GET_SECOND	"  GET_SECOND ? "
$		inq/nop	IFF_HEADER	"  IFF_HEADER ? "
$		inq/nop outifj		"  OUTIFJ ? "
$		inq/nop st_out		"  ST_OUT ? "
$		inq/nop	writpol		"  WRITPOL ? "
$	     endif
$!
$	     ws " "
$	     ws ">> THE REST "
$	     ws " "
$	     inq/nop next_lot	"Polygon Merging ?"
$	     if next_lot
$	     then
$		inq/nop adjacent		"  ADJACENT? "
$		inq/nop amalgamate		"  AMALGAMATE ? "
$		inq/nop check_isol		"  CHECK_ISOL?"
$		inq/nop check_node_neigh	"  CHECK_NODE_NEIGH ? "
$		inq/nop complex			"  COMPLEX? "
$		inq/nop complex_phan		"  COMPLEX_PHAN? "
$		inq/nop eliminate		"  ELIMINATE ? "
$		inq/nop eliminate_by_higher	"  ELIMINATE_BY_HIGHER ? "
$		inq/nop eliminate_by_lookup	"  ELIMINATE_BY_LOOKUP ? "
$		inq/nop eliminate_by_lower	"  ELIMINATE_BY_LOWER ? "
$		inq/nop exterminate		"  EXTERMINATE ? "
$		inq/nop find_common		"  FIND_COMMON? "
$		inq/nop find_largest		"  FIND_LARGEST ? "
$		inq/nop find_others		"  FIND_OTHERS ? "
$		inq/nop find_smallest		"  FIND_SMALLEST ? "
$		inq/nop get_mother		"  GET_MOTHER ?"
$		inq/nop get_neigh		"  GET_NEIGH ? "
$		inq/nop GET_BY_TEXT		"  GET_BY_TEXT ? "
$		inq/nop merge			"  MERGE ? "
$		inq/nop merge_by_higher		"  MERGE_BY_HIGHER ? "
$		inq/nop merge_by_lookup		"  MERGE_BY_LOOKUP ? "
$		inq/nop merge_by_lower		"  MERGE_BY_LOWER ? "
$		inq/nop merge_for_elim		"  MERGE_FOR_ELIM ? "
$		inq/nop neighbours		"  NEIGHBOURS ? "
$		inq/nop update_range		"  UPDATE_RANGE ?"
$		inq/nop update_segments		"  UPDATE_SEGMENTS ? "
$		inq/nop update_segments_complex	"  UPDATE_SEGMENTS_COMPLEX ? "
$	     endif
$!
$	   endif					!everything
$!
$	endif				!compile
$	ws ""
$	inq/nop cld "Compile CLD module ? "
$	if cld
$	then
$		wc "$	ws """""
$		wc "$	ws ""------------------------------------------------"""
$		wc "$	ws ""                  CLD MODULE""" 
$		wc "$	ws ""------------------------------------------------"""
$		wc "$	adc polmerge.tmp=polmerge_cld.cld"
$		wc "$	set command/object=polmerge_cld polmerge.TMP"
$		wc "$	ok=$status"	
$		wc "$	if ok then pvv polmerge_cld"
$		wc "$	ok=$status"	
$		wc "$! "
$	endif
$!
$	ws ""
$	inq/nop mes "Generate message definitions ? "
$	if mes
$	then
$		wc "$	ws """""
$		wc "$	ws ""------------------------------------------------"""
$		wc "$	ws ""                  MESSAGE"""
$		wc "$	ws ""------------------------------------------------"""
$		wc "$	newmsg/num=1247/nam=polmerge/pre=pmerge__/par=for/run polmerge.mes"
$		wc "$	@polmerge.temp_com"
$	endif
$!
$!
$	ws ""
$	ws ""
$	ws "------------------.   (0)    _    .-. /"
$	ws "                  |         | \   | |/"
$	ws "                  |    |    |  \  | |\"
$	ws "                  `----^----'   `-' | `._-----------"
$	ws ""
$	inquire/nop lnkit "Link ? "
$	if lnkit
$	then
$	  linkver= "polmerge"
$	  linkopts= "/map"
$	  inquire/nop answer "  Link with debug ? "
$	  if answer
$	  then
$	    linkopts=linkopts+"/debug/cross"
$	  else
$	    inquire/nop answer "  Link with profiler ? "
$	    if answer then linkopts= linkopts+"/debug=SYS$LIBRARY:PCA$OBJ.OBJ"
$	  endif
$	endif
$!
$	if compile
$	then
$	   ws ""
$	   ws "-----------------------------generating compiler instructions"
$	   wc "$	ws """""
$	   wc "$	ws ""------------------------------------------------"""
$	   wc "$	ws ""                  COMPILING"""
$	   wc "$	ws ""------------------------------------------------"""
$	   on error then goto polmergeex
$	   if adjacent then call 		compiler adjacent
$	   if amalgamate then call 		compiler amalgamate
$	   if calc_areas_ratios then call	compiler calc_areas_ratios
$	   if check_node_neigh then call 	compiler check_node_neigh
$	   if check_numeric_label then call 	compiler check_numeric_label
$	   if close_files then call 		compiler close_files
$	   if cmdlin then call 			compiler cmdlin
$	   if neighbours then call 		compiler neighbours
$	   if GET_BY_TEXT then call 		compiler GET_BY_TEXT
$	   if find_others then call 		compiler find_others
$	   if eliminate then call 		compiler eliminate
$	   if merge_for_elim then call 		compiler merge_for_elim
$	   if exterminate then call 		compiler exterminate
$	   if merge_by_lookup then call 	compiler merge_by_lookup
$	   if merge_by_higher then call 	compiler merge_by_higher
$	   if merge_by_lower then call 		compiler merge_by_lower
$	   if eliminate_by_lookup then call 	compiler eliminate_by_lookup
$	   if eliminate_by_higher then call 	compiler eliminate_by_higher
$	   if eliminate_by_lower then call 	compiler eliminate_by_lower
$	   if find_largest then call 		compiler find_largest
$	   if find_smallest then call 		compiler find_smallest
$	   if form_boxes then call 		compiler form_boxes
$	   if framed_mes then call 		compiler framed_mes
$	   if skip_layer then call 		compiler skip_layer
$	   if check_ac_text then call 		compiler check_ac_text
$	   if read_ac_text then call 		compiler read_ac_text
$	   if check_segac_label then call 	compiler check_segac_label
$	   if get_actxt then call 		compiler get_actxt
$	   if get_neigh then call 		compiler get_neigh
$	   if get_polygon then call 		compiler get_polygon
$	   if complex_phan then call 		compiler complex_phan
$	   if check_isol then call 		compiler check_isol
$	   if get_mother then call 		compiler get_mother
$	   if update_range then call 		compiler update_range
$	   if complex then call 		compiler complex
$	   if find_common then call 		compiler find_common
$	   if polmerge then call 		compiler polmerge 
$	   if iff_header then call 		compiler iff_header
$	   if isol_poly then call 		compiler isol_poly
$	   if FLAG_ISOLATIONS then call 	compiler FLAG_ISOLATIONS
$	   if merge then call 			compiler merge
$	   if open_file then call 		compiler open_file
$	   if outifj then call 			compiler outifj
$	   if read_lookup then call 		compiler read_lookup
$	   if remove_ds then call 		compiler remove_double_spaces
$	   if identify_seed then call 		compiler identify_seed
$	   if test_primary_poly_label then call	compiler test_primary_poly_labl
$	   if test_second_poly_label then call 	compiler test_second_poly_label
$	   if update_segments then call 	compiler update_segments
$	   if update_segments_complex then call	compiler update_complex
$	   if check_same then call 		compiler check_same
$	   if GET_SECOND then call 		compiler GET_SECOND
$	   if flush_out then call 		compiler flush_out
$	   if flush_line then call 		compiler flush_line
$	   if st_out then call 			compiler st_out
$	   if writpol then call 		compiler writpol
$	   if check_ac then call 		compiler check_ac
$	endif
$!
$	wc "$	set noverify"
$	wc "$errs:
$	wc "$	if emsg.eqs.""""
$	wc "$	then
$	wc "$	  ws ""Hurrah!...there were no compilation errors"""
$	wc "$	else
$	wc "$	  ws """""
$	wc "$	  ws ""+-----------------------------------------------------"""
$	wc "$	  ws ""|               Compilation errors in:"""
$	wc "$	  ws emsg"
$	wc "$	  ws ""+-----------------------------------------------------"""
$	wc "$	  ws """""
$	wc "$	  goto polmergeex"
$	wc "$	endif
$!
$	if lnkit
$	then
$	  wc "$	set noverify"
$	  wc "$	ws """""
$	  wc "$	ws ""------------------------------------------------"""
$	  wc "$	ws ""                  VERSION"""
$	  wc "$	ws ""------------------------------------------------"""
$	  wc "$	run lsl$exe:genver"
$	  wc "$	purge/nolog version.src"
$	  call compiler version
$!
$	  wc "$	ws """""
$	  wc "$	ws ""------------------------------------------------"""
$	  wc "$	ws ""                  LINKING"""
$	  wc "$	ws ""------------------------------------------------"""
$	  wc "$ set verify"
$	  wc "$	link''linkopts'/exe=''linkver' POLMERGE,-"
$	  wc "		polmerge_cld,cmdlin,open_file,close_files, -"
$	  wc "		identify_seed,skip_layer,framed_mes,-"
$	  wc "		form_boxes,check_segac_label,check_ac_text,  -"
$	  wc "		read_ac_text,calc_areas_ratios,FLAG_ISOLATIONS, -"
$	  wc "		amalgamate, merge, -"
$	  wc "		get_neigh,  find_largest, -"
$	  wc "		update_segments, isol_poly, outifj,iff_header, -" 
$	  wc "		writpol,find_smallest,get_actxt, -" 
$	  wc "		check_same,flush_line,flush_out,st_out,GET_SECOND, -" 
$	  wc "		get_polygon,complex,find_common,adjacent, -" 
$	  wc "		update_complex,exterminate,eliminate, -" 
$	  wc "		GET_BY_TEXT,neighbours,merge_for_elim,-"
$	  wc "		find_others,read_lookup,remove_double_spaces,-"
$	  wc "		test_second_poly_label,test_primary_poly_labl,-"
$	  wc "		merge_by_lookup,eliminate_by_lookup,- "
$	  wc "		eliminate_by_higher,eliminate_by_lower,-
$	  wc "		merge_by_lower,merge_by_higher,check_numeric_label,-
$	  wc "		check_node_neigh,check_ac,check_isol,complex_phan, - "
$	  wc "		update_range,get_mother,-
$	  wc "		version, -"
$	  wc "		polmerge.promsg_obj, -"
$	  wc "		lsl$library:pmeclock.obj, -"
$	  wc "		lsl$cmnpolygonsl:polygons/lib/include=polygons, -"
$	  wc "		LSL$LIBRARY:IFFSHR.OPT/OPT,-"
$	  wc "		LSL$LIBRARY:LSLSHR.OPT/OPT"
$	endif
$!
$	wc "$	polmergeex:"
$	wc "$	deass/group lsl$polmerge_building"
$	wc "$	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto polmergeex
$	close comfil
$	ok=$status
$!
$	deass/group lsl$polmerge_building
$	ws ""
$	ws ""
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if answer_bat
$	then
$	  bat polmergebat.com
$	else 
$	  if ok then inq/nop answer "  Interactive ? "
$	  if answer
$	  then
$	    @polmergebat.com
$	  else
$	    ws "    -------------------------------"
$	    ws "    NO COMPILING OR LINKING DONE !!"
$	    ws "    -------------------------------"
$	  endif
$	endif
$!
$polmergeex:
$	is_build = f$logical("lsl$polmerge_building")
$	if is_build.nes."" then deass/group lsl$polmerge_building
$	if ver then set verify
$	exit
$!
$!.............................................................................
$!
$ compiler: subroutine
$!
$	on error then exit 3
$	on control_y then exit 3
$	on control_c then exit 3
$!
$	set noverify
$	wc "$	ws """""
$	wc "$	ws """""
$	wc "$	ws ""COMPILING    ''p1'......"""
$	wc "$	adc ''p1'''kpcom'=''p1'"
$	wc "$	set verify"
$	wc "$	fort''fsw1' ''p1'"
$	wc "$	ok=$status"	
$	wc "$	set noverify"
$	wc "$	if ok then pvv ''p1'"
$	wc "$	purge/nolog ''p1'.obj"
$!
$	if fsw1.eqs.""
$	then 
$	  wc "$	delete/nolog ''p1'.for;*"
$	else
$	  wc "$	purge/nolog ''p1'.for"
$	endif
$!
$	if (f$locate("list",fsw1).ne.f$length(fsw1)).and.f$length(fsw1).ne.0
$	then
$		wc "$	if ok then delete/nolog ''p1'.lis;*"
$	endif
$!
$	wc "$	if .not.ok"
$	wc "$	then"
$	wc "$	  delete adc.ide;*"
$	wc "$	  emsg=emsg+"" ''p1'"""
$	wc "$	  goto errs"
$	wc "$	endif
$	return
$ endsubroutine
