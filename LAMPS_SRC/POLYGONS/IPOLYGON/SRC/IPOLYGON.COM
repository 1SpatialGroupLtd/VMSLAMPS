$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-28 11:01:32.000000000 +0100
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
$! Command file to build POLYGONS utility ipolygon
$!
$! Copyright Laser-Scan Laboratories Limited, Cambridge, England.
$!
$!	Created						TJH 12-Jan-1987
$!MOD	minor modifications				SG  15-Apr-1992
$!
	ver=f$verify(0)
$!
$	on error then goto ipolygonex
$!
$	disk		:= 'f$logical("sys$disk")'
$!
$	is_build = f$logical("lsl$ipolygon_building")
$	if "''is_build'".eqs."in_progress"
$	then
$	  ws "Someone else is building"
$	  inquire ignore "  Carry on regardless? "
$	  if .not.ignore then exit
$	endif
$!
$	on control_y then goto ipolygonex
$	on error then goto ipolygonex
$!
$	define/group lsl$ipolygon_building "in_progress"
$	open/write comfil ipolygonbat.com
$!
$	on control_y then goto filclo
$	on error then goto filclo
$	ws="write sys$output"
$	wc="write comfil"
$!
$	wc "$	ws=""write sys$output"""
$	wc "$	set noverify"
$	wc "$	on control_y then goto ipolygonex"
$	wc "$	is_build = f$logical(""lsl$ipolygon_building"")"
$	wc "$	if ""'","'is_build'"".eqs.""in_progress"""
$	wc "$	then"
$	wc "$	  ws ""Someone else is building"""
$	wc "$	  exit"
$	wc "$	endif"
$	wc "$!"
$	wc "$	define/group lsl$ipolygon_building ""in_progress"""
$	wc "$ assign lsl$source_root:[polygons.ipolygon.src] lsl$cmnipolygon"
$	wc "$ assign lsl$source_root:[polygons.service.src] lsl$cmnpolygons"
$	wc "$ assign lsl$source_root:[polygons.lib] lsl$cmnpolygonsl"
$	wc "$	set noon"
$	wc "$	emsg="""""
$	wc "$	linkit=""T"""
$!
$	mldbg=""
$	fsw1="/list"
$	kpcom=""
$	ipolygon_dbg=""
$	macbuild=""
$	cld=""
$	mes=""
$!
$	ws ""
$	inquire/nop compile "Compile ? "
$	if compile
$	then
$	  inquire/nop ipolygon_dbg "  With Debug ? "
$	  if ipolygon_dbg
$	  then
$		fsw1="/debug/noopt/check=(bounds,overflow)/list"
$		mldbg="/debug"
$		kpcom="/co"
$	  endif
$!
$	  inq/nop everything "  all sources ? "
$	  if everything
$	  then
$		 abs_qual		= "t"
$		 ascii_qual		= "t"
$		 assign_fail		= "t"
$		 assign_lrcode		= "t"
$		 assign_seed		= "t"
$		 box_seed		= "t"
$		 check_for_symbol	= "t"
$		 check_iff_out		= "t"
$		 check_junction		= "t"
$		 check_lrcode_label	= "t"
$		 chk_seed_range		= "t"
$		 close_files		= "t"
$		 cmdlin			= "t"
$		 coverages		= "t"
$		 delete_iff_out		= "t"
$		 finished		= "t"
$		 framed_mes		= "t"
$		 fill_tab		= "t"
$		 form_boxes		= "t"
$		 get_lrcode_label	= "t"
$		 get_paired_fc		= "t"
$		 get_poly_ident		= "t"
$		 get_poly_label		= "t"
$		 get_seed_address	= "t"
$		 get_seed_fsn		= "t"
$		 get_seed_label		= "t"
$		 get_st_addresses	= "t"
$		 identify_seed		= "t"
$		 iff_header		= "t"
$		 ipolygon		= "t"
$		 list_qual		= "t"
$		 lites2_qual		= "t"
$		 lrcode_qual		= "t"
$		 log_qual		= "t"
$		 nest_finished		= "t"
$		 onearm_qual		= "t"
$		 options_qual		= "t"
$		 open_input		= "t"
$		 open_output		= "t"
$		 outopt			= "t"
$		 output_acs		= "t"
$		 output_ascii		= "t"
$		 output_seg		= "t"
$		 output_pol		= "t"
$		 output_pip		= "t"
$		 pip_qual		= "t"
$		 pme_qual		= "t"
$		 polygons_qual		= "t"
$		 printer_qual		= "t"
$		 read_ac_text		= "t"
$		 read_pair_file		= "t"
$		 seed_check		= "t"
$		 seed_qual		= "t"
$		 segments_qual		= "t"
$		 side_tab		= "t"
$		 skip_layer		= "t"
$	  else
$		ws " "
$!
$		ws "..First the main module"
$		inq/nop ipolygon		"  IPOLYGON ? "
$		ws " "
$		inq/nop coverages		"  Polygon overlay stuff ? "
$		ws " "
$!
$		ws "..Command line decoding and file open/close"
$		inq/nop abs_qual		"  ABS_QUAL ? "
$		inq/nop ascii_qual		"  ASCII_QUAL ? "
$		inq/nop check_iff_out		"  CHECK_IFF_OUT ? "
$		inq/nop close_files		"  CLOSE_FILES ? "
$		inq/nop cmdlin			"  CMDLIN ? "
$		inq/nop delete_iff_out		"  DELETE_IFF_OUT ? "
$		inq/nop list_qual		"  LIST_QUAL ? "
$		inq/nop lites2_qual		"  LITES2_QUAL ? "
$		inq/nop lrcode_qual		"  LRCODE_QUAL ? "
$		inq/nop log_qual		"  LOG_QUAL ? "
$		inq/nop onearm_qual		"  ONEARM_QUAL ? "
$		inq/nop open_input		"  OPEN_INPUT ? "
$		inq/nop open_output		"  OPEN_OUTPUT ? "
$		inq/nop options_qual		"  OPTIONS_QUAL ? "
$		inq/nop pip_qual		"  PIP_QUAL ? "
$		inq/nop pme_qual		"  PME_QUAL ? "
$		inq/nop polygons_qual		"  POLYGONS_QUAL ? "
$		inq/nop printer_qual		"  PRINTER_QUAL ? "
$		inq/nop read_pair_file		"  READ_PAIR_FILE? "
$		inq/nop segments_qual		"  SEGMENTS_QUAL? "
$		inq/nop seed_qual		"  SEED_QUAL? "
$		ws " "
$!
$		ws "..Lookup table construction"
$		inq/nop skip_layer		"  SKIP_LAYER ? "
$		ws " "
$!	
$		ws "..Checks and messages"
$		inq/nop chk_seed_range		"  CHK_SEED_RANGE ? "
$		inq/nop framed_mes		"  FRAMED_MES ? "
$		inq/nop identify_seed		"  IDENTIFY_SEED ? "
$		inq/nop seed_check		"  SEED_CHECK ? "
$!
$		ws " "
$		ws "..Box structure"
$		inq/nop box_seed		"  BOX_SEED ?"
$		inq/nop form_boxes		"  FORM_BOXES ? "
$!
$		ws " "
$		ws "..Nesting/seed point determination"
$		inq/nop assign_fail		"  ASSIGN_FAIL ? "
$		inq/nop assign_seed		"  ASSIGN_SEED ? "
$		inq/nop assign_lrcode		"  ASSIGN_LRCODE ? "
$		inq/nop finished		"  FINISHED ? "
$		inq/nop get_seed_address	"  GET_SEED_ADDRESS ? "
$		inq/nop nest_finished		"  NEST_FINISHED ? "
$!
$		ws " "
$		ws "..File output routines"
$		inq/nop check_for_symbol	"  CHECK_FOR_SYMBOL ? "
$		inq/nop check_lrcode_label	"  CHECK_LRCODE_LABEL ? "
$		inq/nop fill_tab		"  FILL_TAB ?"
$		inq/nop get_lrcode_label	"  GET_LRCODE_LABEL ? "
$		inq/nop get_poly_ident		"  GET_POLY_IDENT ? "
$		inq/nop get_poly_label		"  GET_POLY_LABEL ? "
$		inq/nop get_seed_fsn		"  GET_SEED_FSN ? "
$		inq/nop get_seed_label		"  GET_SEED_LABEL ? "
$		inq/nop iff_header		"  IFF_HEADER ? "
$		inq/nop outopt			"  OUTOPT ? "
$		inq/nop output_acs		"  OUTPUT_ACS ? "
$		inq/nop output_ascii		"  OUTPUT_ASCII ? "
$		inq/nop output_seg		"  OUTPUT_SEG ? "
$		inq/nop output_pip		"  OUTPUT_PIP ? "
$		inq/nop output_pol		"  OUTPUT_POL ? "
$		inq/nop get_paired_fc		"  GET_PAIRED_FC ? "
$		inq/nop read_ac_text		"  READ_AC_TEXT ? "
$		inq/nop side_tab		"  SIDE_TAB ? "
$		ws " "
$	  endif		! everything
$	
$	  ws ""
$	  inq/nop cld "Compile CLD module ? "
$	  if cld
$	  then
$		wc "$!"
$		wc "$	ws ""   CLD MODULE   """
$		wc "$	adc ipolygon.tmp=ipolygon_cld.cld"
$		wc "$	set command/object=ipolygon_cld ipolygon.TMP"
$		wc "$	ok=$status"	
$		wc "$	if ok then pvv ipolygon_cld"
$		wc "$	ok=$status"	
$		wc "$! "
$	  endif
$!
$	  ws ""
$	  inq/nop mes "Generate message definitions ? "
$	  if mes
$	  then
$	    wc "$	ws ""   -------   MESSAGES   -------   """
$	    wc "$	set verify"
$	    wc "$	newmsg/num=1245/nam=ipolygon/pre=ipol__/par=for/run ipolygon.mes"
$	    wc "$	@ipolygon.temp_com"
$	    wc "$	set noverify"
$	  endif
$	endif		! compile
$!
$!
$	ws ""
$	inquire/nop lnkit "Link ? "
$	if lnkit
$	then
$	  linkver="ipolygon"
$	  linkopts="/map/cross"
$	  inquire/nop answer "  Link with debug ? "
$	  if answer
$	  then
$	    linkopts=linkopts+"/debug"
$	  else
$	    inquire/nop pca "  Link with Profiler ? "
$	    if pca  then linkopts = linkopts+"/debug=SYS$LIBRARY:PCA$OBJ.OBJ"
$	  endif
$	endif
$!
$!	
$	if compile
$	then
$	   ws ""
$	   ws "Generating instructions for compilation....."
$	   ws ""
$	   if coverages then		call compiler index_segments
$	   if coverages then		call compiler propagate_cover
$	   if coverages then		call compiler assign_cover
$	   if coverages then		call compiler check_cover_label
$	   if coverages then		call compiler get_cover_label
$	   if coverages then		call compiler propagate_qual
$	   if coverages then		call compiler read_cov_file
$	   if coverages then		call compiler process_ac_text
$	   if coverages then		call compiler read_fcs
$!
$	   if abs_qual then		call compiler abs_qual
$	   if ascii_qual then		call compiler ascii_qual
$	   if check_iff_out then	call compiler check_iff_out
$	   if close_files then		call compiler close_files
$	   if cmdlin then		call compiler cmdlin
$	   if delete_iff_out then	call compiler delete_iff_out
$	   if list_qual then		call compiler list_qual
$	   if lites2_qual then		call compiler lites2_qual
$	   if lrcode_qual then		call compiler lrcode_qual
$	   if log_qual then		call compiler log_qual
$	   if onearm_qual then		call compiler onearm_qual
$	   if open_input then		call compiler open_input
$	   if open_output then		call compiler open_output
$	   if options_qual then		call compiler options_qual
$	   if pip_qual then		call compiler pip_qual
$	   if pme_qual then		call compiler pme_qual
$	   if polygons_qual then	call compiler polygons_qual
$	   if printer_qual then		call compiler printer_qual
$	   if read_pair_file then	call compiler read_pair_file
$	   if segments_qual then	call compiler segments_qual
$	   if seed_qual then		call compiler seed_qual
$!
$	   if skip_layer then		call compiler skip_layer
$!
$	   if chk_seed_range then	call compiler chk_seed_range
$	   if framed_mes then		call compiler framed_mes
$	   if identify_seed then	call compiler identify_seed
$	   if seed_check then		call compiler seed_check
$!
$	   if box_seed then		call compiler box_seed
$	   if form_boxes then		call compiler form_boxes
$!
$	   if assign_fail then		call compiler assign_fail
$	   if assign_seed then		call compiler assign_seed
$	   if assign_lrcode then	call compiler assign_lrcode
$	   if finished then		call compiler finished
$	   if get_seed_address then	call compiler get_seed_address 
$	   if nest_finished then	call compiler nest_finished
$!
$	   if check_for_symbol then	call compiler check_for_symbol
$	   if check_lrcode_label then	call compiler check_lrcode_label
$	   if fill_tab then		call compiler fill_tab
$	   if get_lrcode_label then	call compiler get_lrcode_label
$	   if get_poly_ident then	call compiler get_poly_ident
$	   if get_poly_label then	call compiler get_poly_label
$	   if get_seed_fsn then		call compiler get_seed_fsn 
$	   if get_seed_label then	call compiler get_seed_label 
$	   if iff_header then		call compiler iff_header
$	   if ipolygon then		call compiler ipolygon 
$	   if outopt then		call compiler outopt
$	   if output_acs then		call compiler output_acs
$	   if output_ascii then		call compiler output_ascii
$	   if output_seg then		call compiler output_seg
$	   if output_pip then		call compiler output_pip
$	   if output_pol then		call compiler output_pol
$	   if get_paired_fc then	call compiler get_paired_fc
$	   if read_ac_text then		call compiler read_ac_text
$	   if side_tab then		call compiler side_tab
$!
$
$	   wc "$err:	set noverify"
$	   wc "$	if emsg.nes."""""
$	   wc "$	then"
$	   wc "$	  ws ""----------------------"""
$	   wc "$	  ws ""Compilation errors in:"""
$	   wc "$	  ws emsg"
$	   wc "$	  ws """""
$	   wc "$	  linkit = ""F"""
$	   wc "$	endif"
$	endif
$!
$	if lnkit
$	then
$	   ws ""
$	   wc "$	set noverify"
$	   wc "$	ws """""
$	   wc "$	ws ""-------------------VERSION----------------"""
$	   wc "$	run lsl$exe:genver"
$	   wc "$	purge/nolog version.src"
$	   call compiler version	
$!
$	   wc "$	set noverify"
$	   wc "$	if linkit"
$	   wc "$	then"
$	   wc "$	  ws """""
$	   wc "$	  ws ""-------------------LINKING----------------"""
$	   wc "$	  set verify"
$	   wc "$	  link''linkopts'/exe=''linkver' ipolygon,-"
$	   wc "	  ipolygon_cld,abs_qual,ascii_qual,cmdlin, -"
$	   wc "	  assign_fail,assign_lrcode,assign_seed, -"
$	   wc "	  box_seed,chk_seed_range,check_for_symbol,close_files, - "
$	   wc "	  delete_iff_out,check_iff_out,check_lrcode_label, - "
$	   wc "	  fill_tab,finished,form_boxes,framed_mes, -"
$	   wc "	  get_lrcode_label,get_paired_fc,get_poly_ident, -"
$	   wc "	  get_poly_label, -"
$	   wc "	  get_seed_address,get_seed_fsn,get_seed_label, -"
$	   wc "	  identify_seed,iff_header, -"
$	   wc "	  lrcode_qual,list_qual,lites2_qual,log_qual,- "
$	   wc "	  nest_finished, -"
$	   wc "	  onearm_qual,options_qual,open_input,open_output,-"
$	   wc "	  outopt,output_acs,-"
$	   wc "	  output_ascii,output_seg,output_pol,output_pip, -"
$	   wc "	  pip_qual,pme_qual,polygons_qual, -"
$	   wc "	  printer_qual,read_ac_text,read_pair_file,segments_qual, -"
$	   wc "	  seed_check,seed_qual,skip_layer,side_tab, -"
$	   wc "	  index_segments,propagate_cover,assign_cover,-"
$	   wc "	  check_cover_label,get_cover_label, -"
$	   wc "	  propagate_qual,read_cov_file,read_fcs,process_ac_text, -"
$	   wc "	  version, -"
$	   wc "	  ipolygon.promsg_obj, -"
$	   wc "	  lsl$library:pmeclock.obj, -"
$	   wc "	  lsl$cmnpolygonsl:polygons/lib/incl=polygons, -"
$	   wc "   lsl$library:iffshr/opt,lslshr/opt"
$	   wc "$	endif"

!!!!!!
$!!!!!!		--------------------------------------------------------------
$!!!!!!		wc "	  lsl$library:ifflib/lib,lsllib/lib"
$!!!!!!	
$!!!!!!		the above was used as POLYGONS used START_LCM which is a LSLLIB
$!!!!!!		internal rather than a later external LCM_OPEN.
$!!!!!!
$!!!!!!		NB. START_LCM replaced with START_LITES2 in POLYGONS.SERVICE
$!!!!!!		routines. NOte that this used another internal PREP_INFO which 
$!!!!!!		has also vanished
$!!!!!!	
$!!!!!!		--------------------------------------------------------------
$!!!!!!
$	endif
$!
$	wc "$	ipolygonex:"
$	wc "$	deass/group lsl$ipolygon_building"
$	wc "$	set nover"
$!
$ filclo:
$	set noverify
$	on error then goto ipolygonex
$	close comfil
$	ok=$status
$!
$	ws ""
$	if ok then inq/nop answer_bat "Submit for batch ? "
$	if answer_bat
$	then
$	   deass/group lsl$ipolygon_building
$	   bat ipolygonbat.com
$	else
$	   if ok then inq/nop answer "Interactive ? "
$	   if answer
$	   then
$		deass/group lsl$ipolygon_building
$		@ipolygonbat.com
$	   else
$		ws "no compiling or linking done"
$		deass/group lsl$ipolygon_building
$	   endif
$	endif
$!
$	if ver then set verify
$	exit
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! only get here if there was an error
$!
$ipolygonex:
$	deass/group lsl$ipolygon_building
$	close comfil
$!	exit
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$compiler: subroutine
$	wc "$	set noverify"
$	wc "$	ws """""
$	wc "$	ws """""
$	wc "$	ws ""----------------------compiling ''p1' -------"""
$	wc "$	ws """""
$	wc "$	adc ''p1'''kpcom'=''p1'"
$	wc "$	set verify"
$	wc "$	fort''fsw1' ''p1'"
$	wc "$	ok=$status"	
$	wc "$	set noverify"
$!
$	if fsw1.eqs.""
$	then
$		wc "$	if ok then delete/nolog ''p1'.for;*"
$	else
$		wc "$	purge/nolog ''p1'.for"
$	endif
$	wc "$	delete adc.ide;*"
$!
$	wc "$	if ok"
$	wc "$	then"
$	wc "$	  delete/nolog ''p1'.lis;*"
$	wc "$	endif"
$	wc "$!"
$	wc "$	if ok"
$	wc "$	then"
$	wc "$	  pvv ''p1'"
$	wc "$	  purge/nolog ''p1'.obj"
$	wc "$	else"
$	wc "$	  emsg=emsg+"" ''p1'"""
$	wc "$	  goto err"
$	wc "$	endif
$!
$	return
$ endsubroutine
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
