$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 2000-01-13 15:59:04.000000000 +0000
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
$	set noverify
$	on error     then goto getout
$	on control_y then goto getout
$!
$! command file: NTF2I - a command file to build the NTF2I program
$!
$! Copyright (C) Laser-Scan Ltd, Cambridge, England  1985
$!
$! Author TJ Ibbs, 12 October 1987
$!
$! Mod 1435 Use new frtshr			JB 23-Nov-1994
$!
$! *************************************************************************
$!
$	wsb = "write sys$output """""
$!
$	cld   = "N"
$	msg   = "N"
$	main  = "N"
$	cmd   = "N"
$	fils  = "N"
$	vol1  = "N"
$	vol2  = "N"
$	sec   = "N"
$	ftr1  = "N"
$	ftr2  = "N"
$	iff   = "N"
$	att1  = "N"
$	att2  = "N"
$	att3  = "N"
$	mis1  = "N"
$	mis2  = "N"
$  	mis3  = "N"
$  	mis4  = "N"
$  	mis5  = "N"
$  	chai  = "N"
$  	citf1 = "N"
$  	citf2 = "N"
$  	citf3 = "N"
$  	citf4 = "N"
$  	citf5 = "N"
$	rec   = "N"
$	conv  = "N"
$	cmp   = "N"
$	ext   = "N"
$	debug = "N"
$	lbg   = "N"
$	idx   = "N"
$	hed   = "N"
$	sect  = "N"
$	cmplx = "N"
$	feat  = "N"
$	comm  = "N"
$	oscar = "N"
$	lut1  = "N"
$	lut2  = "N"
$!
$	inquire compile "compile ?"
$	if compile .eqs."Y"
$	then
$	  inquire debug "Compile with debug"
$	  if debug.eqs."" then debug = "N"
$!
$	  inquire cld  "Command line definition"
$	  inquire msg  "Messages"
$!
$	  inquire all "compile all fortran sources"
$	  if all.eqs."Y"
$	  then
$		main = "Y"
$		cmd  = "Y"
$		fils = "Y"
$		vol1 = "Y"
$		vol2 = "Y"
$		sec  = "Y"
$		ftr1 = "Y"
$		ftr2 = "Y"
$		iff  = "Y"
$		att1 = "Y"
$		att2 = "Y"
$		att3 = "Y"
$		mis1 = "Y"
$		mis2 = "Y"
$  		mis3 = "Y"
$  		mis4 = "Y"
$  		mis5 = "Y"
$  		chai = "Y"
$  		citf1 = "Y"
$  		citf2 = "Y"
$  		citf3 = "Y"
$  		citf4 = "Y"
$  		citf5 = "Y"
$		rec  = "Y"
$		conv = "Y"
$		cmp = "Y"
$		ext = "Y"
$		idx = "Y"
$		hed = "Y"
$		sect = "Y"
$		cmplx = "Y"
$		feat = "Y"
$		comm = "Y"
$		oscar = "Y"
$		lut1  = "Y"
$		lut2  = "Y"
$	  else
$	    wsb
$	    inquire main  "   NTF2I    - ntf2i"
$	    inquire att1  "Attr 1  - read_attdesc/attrec,rdatt,attcom"
$	    inquire att2  "Attr 2  - read_command,get:_next_attr,_attrib"
$	    inquire att3  "Attr 3  - set_default_atts"
$  	    inquire chai  "Chain   - read_chain"
$  	    inquire citf1 "Citf 1  - citf_setup,check_citf_atts,calc_symb_point"
$  	    inquire citf2 "Citf 2  - write_line_to_mh4,write_citf_coords"
$  	    inquire citf3 "Citf 3  - read_citf_/linear/geometry/acrdrec/coordatts"
$	    inquire citf4 "Citf 4  - read_next_citf_geom/citf_attribs/citf_attrec"
$  	    inquire citf5 "Citf 5  - read_citf_/text/namerec,acrdrec_superset"
$	    inquire cmd   "Command - cmdlin"
$	    inquire comm  "Comment - _i2ntf_ read..info, process..comment,MATCH"
$	    inquire cmplx "Complex - read_/process_ collect, cpoly"
$	    inquire conv  "Conversion - convert,x/y/z/htconvert"
$	    inquire ext   "Extra   - (newstart,gttxtlnth) process_seed_point"
$	    inquire feat  "Feature-code - get_fc"
$	    inquire fils  "Files   - open_ntf/log,close_ntf/log/temp_files"
$	    inquire hed   "Header  - read_/process_ ntf_header"
$	    inquire iff   "IFF     - create/update/close _iff_file"
$	    inquire idx   "Indexed - open/close, read_ntf_chunk, get_id, assoc_fsn"
$	    inquire ftr1  "Line    - read_linear,geometry,line_attribs"
$	    inquire lut1  "Lookup1 - rdlookup, lookupcmd, add_lut_entry, sort_lut, lut_ntf_cf, lut_swap"
$	    inquire lut2  "Lookup2 - fc_trans"
$	    inquire mis1  "Misc 1  - reverse/write_coords,deduce_iff_name"
$	    inquire mis2  "Misc 2  - read_NTF_record,read_continue"
$  	    inquire mis3  "Misc 3  - read_osmh,read_osmh_v2,comment,geometry"
$  	    inquire mis4  "Misc 4  - is_contin., check_warned, recognised,
$	    inquire mis5  "Misc 5  - store,exit_handler"
$	    inquire oscar "Oscar - find_geom_in_noderecs,find_geom"
$	    inquire rec   "Record    - need_recid store_recid  read_record"
$	    inquire sec   "Section(1)- read_/string/sechrec/secqual"
$	    inquire sect  "Section(2)- read_ntf_sections read_section" 
$	    inquire ftr2  "Text    - read_text,nampostn,namerec,textv2,textpos"
$	    inquire vol1  "Volume  - process_ntf,volhdrec,volterm,mount_tape"
$	    inquire vol2  "Volume(database) - read_dbqual,dbhrec,featclass"
$	  endif
$	endif
$	wsb
$	inquire lnk  "Link"
$	if lnk.eqs."Y"
$	then
$	  inquire lbg  "Link with debug"
$	endif
$	wsb
$!
$	ldbg="/map"
$	dbg = ""
$	pd  = "delete"
$	ver = ";*"
$	if lbg   then ldbg= ldbg+"/debug"
$	if debug then dbg = "/debug/noopt/check=(b,o)"
$	if debug then pd  = "purge"
$	if debug then ver = ""
$!
$! check for AXP version
$!
$	arch_name=f$getsyi("ARCH_NAME")
$	if arch_name.eqs."Alpha" 
$	then 
$	   tvs="_tv"
$	   axps="_axp"
$	   dbg=dbg+"/tie/float=d/separate"
$	   ldbg=ldbg+"/nonative_only"
$	else
$	   tvs=""
$	   axps=""
$	endif
$!
$	set verify
$	if cld
$	then
$	   adc   ntf2i_cld.TMP=ntf2i_cld.CLD
$	   set command/object=ntf2i_cld  ntf2i_cld.TMP
$	   pvv   ntf2i_cld
$	   purge ntf2i_cld.OBJ
$	   delete ADC.IDE;*
$	   delete ntf2i_cld.TMP;*
$	endif
$!
$	if msg 
$	then
$	   newmsg  NTF2I/number=1608/runoff/hl=2
$	   @NTF2I.temp_com
$	   purge NTF2IMSG.*
$	endif
$!
$compile_it: subroutine
$  on error then exit 4
$  on control_y then exit 4
$  set ver
$  adc 'p1'/co='p2'
$  fortran/extend'dbg' 'p1'
$  pvv 'p1'
$  purge 'p1'.OBJ
$  delete adc.IDE;*
$  'pd' 'p1'.FOR'ver'
$  set nover
$endsubroutine
$!
$ set nover
$ if main then call compile_it "ntf2i" -
	"ntf2i"
$!
$ if att1  then call compile_it "attrib1" -
	 "read_attdesc,read_attrec,rdatt,read_attcom"
$!
$ if att2 then call compile_it "attrib2" -
	 "get_attrib,get_next_attr,read_command"
$!
$ if att3 then call compile_it "attrib3" -
	 "set_default_atts"
$!
$ if chai then call compile_it "chain" -
	 "read_chain"
$!
$ if citf1 then call compile_it "citf1" -
	 "citf_setup,check_citf_atts,calc_symb_point"
$!
$ if citf2 then call compile_it "citf2" -
	 "write_line_to_mh4,write_citf_coords"
$!
$ if citf3 then call compile_it "citf3" -
	 "read_citf_linear,read_citf_geometry,read_citf_acrdrec,read_next_citf_geom,read_citf_coordatts"
$!
$ if citf4 then call compile_it "citf4" -
	 "read_citf_attribs,read_citf_attrec"
$!
$ if citf5 then call compile_it "citf5" -
	 "read_citf_text,read_citf_namerec,acrdrec_superset"
$!
$ if cmd then call compile_it "cmdlin" -
	"cmdlin"
$!
$ if cmplx then call compile_it "complex" -
	"process_cpoly, process_collect, write_poly, read_collect, read_cpoly" 
$!
$ if comm then call compile_it "do_comment"-
	"read_i2ntf_info, process_i2ntf_comment, match_name, LSL$CMNIFF:MD2DAT"
$!
$ if conv then call compile_it "convrt" -
	"convert,xconvert,yconvert,zconvert,htconvert"
$!
$ if ext then call compile_it "ext" -
	"newstart, gttxtlnth, process_seed_point"
$!
$ if feat then call compile_it "feat_code" -
	"get_fc"
$!
$ if fils then call compile_it "files" -
	"open_ntf,open_log,close_ntf,close_log,temp_files
$!
$ if ftr1 then call compile_it "linear" -
	 "read_linear,read_geometry,read_line_attribs"
$!
$ if ftr2 then call compile_it "text" -
	 "read_text,read_nampostn,read_namerec,read_text_v2,read_textpos"
$!
$ if hed then call compile_it "header" -
	"read_ntf_header, process_ntf_header"
$!
$ if idx then call compile_it "indexed"-
	"open_files, close_files, read_ntf_chunk, get_id_lun, associate_fsn"
$!
$ if iff then call compile_it "IFF" -
	 "create_iff_file,update_iff_file,close_iff_file"
$!
$ if mis1  then call compile_it "misc1" -
	 "reverse_coords,write_coords,deduce_iff_name"
$!
$ if mis2  then call compile_it "misc2" -
	 "read_ntf_record,read_continue"
$!
$ if mis3 then call compile_it "misc3" -
	 "read_osmh,read_osmh_v2,read_comment"
$!
$ if mis4 then call compile_it "misc4" -
	 "is_continuation,check_if_warned,recognised"
$!
$ if mis5 then call compile_it "misc5" -
	 "store,exit_handler"
$!
$ if oscar then call compile_it "oscar" -
	 "find_geom_in_noderecs,find_geom"
$!
$ if rec then call compile_it "recid" -
	 "read_record, need_recid,store_recid"
$!
$ if sec then call compile_it "section" -
	 "read_string,read_sechrec,read_secqual"
$!
$ if sect then call compile_it "section2" -
	"read_ntf_sections, read_section"
$!
$ if vol1 then call compile_it "volume1" -
	 "process_ntf,read_volhdrec,read_volterm,mount_tape"
$!
$ if vol2 then call compile_it "volume2" -
	 "read_dbqual,read_dbhrec,read_featclass"
$!
$ if lut1
$	then
$	call compile_it "lookup1" -
	    "rdlookup,add_lut_entry,sort_lut,lut_ntf_cf,lut_swap"
$	macro'mbug''list' lookupcmd
$	append lookupcmd.obj lookup1.obj
$	purge lookup1.obj
$	delete/nocon lookupcmd.obj;*
$ endif
$!
$ if lut2 then call compile_it "lookup2" -
	 "fc_trans"
$!
$	if lnk
$	then
$! don't move these DEFINE/USERs away from LINK
$	set ver
$	  define/user lsl$iffshr_tv lsl$library:iffshr_dummy_axp"
$	  define/user lsl$lslshr_tv lsl$library:lslshr_dummy_axp"
$	  define/user lsl$frtshr_tv lsl$library:frtshr_dummy_axp"
$	  link'ldbg'/exe=ntf2i'axps' -
			ntf2i, cmdlin, -
			files,volume1,volume2,section,linear,text,iff,misc1,-
			misc2,misc3,misc4,misc5,chain,citf1,citf2,citf3,citf4,-
			citf5,ntf2i_cld,convrt,do_comment,ext,attrib1,attrib2,-
			attrib3,recid,indexed,header,section2,complex,-
			lookup1,lookup2,-
			feat_code,oscar, ntf2i.promsg_obj, -
			lsl$library:osmhlib'axps'/lib, -
			lsl$library:frtshr'tvs'/opt, -
			lsl$library:lslshr'tvs'/opt,iffshr'tvs'/opt, -
                        here:ntf2i'axps'/opt
$	  purge ntf2i.*
$	endif
$!
$ getout:
$	set noverify
$!
