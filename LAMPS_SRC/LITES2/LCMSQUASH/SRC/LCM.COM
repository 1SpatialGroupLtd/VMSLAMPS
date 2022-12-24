$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-05-26 11:14:32.000000000 +0100
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
$	set nover
$
$	on error     then goto getout
$	on control_y then goto getout
$	prog_name = """lcmsquash"""
$!
$! command file: 
$!
$! Copyright (C) LaserScan Ltd, Cambridge, England  1985
$!
$!
$! *************************************************************************
$!
$	wsb = "write sys$output """""
$	ws = "write sys$output"
$!
$! basic stuff
$!
$	cld  = "N"
$	msg  = "N"
$	main = "N"
$!
$!link and debug options
$!
$	lbg = "N"
$	debug = "N"
$!
$!functions local to the utility
$!
$	chec = "N"
$	comm = "N"
$	fils = "N"
$	main = "N"
$	name = "N"
$	outp = "N"
$	proc = "N"
$	rout = "N"
$	str_ = "N"
$	tree = "N"
$	txtc = "N"
$	warn = "N"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$
$	inquire compile "compile ?"
$	if compile .eqs."Y"
$	then
$	  inquire debug "   with debug"
$	  if debug.eqs."" then debug = "N"
$!
$	  wsb
$	  inquire cld  "  Command line definition"
$	  wsb
$	  inquire msg  "  Messages"
$!
$	  if msg 
$	  then
$	    all = "Y"
$	  else
$	    wsb
$	    inquire all "  compile all sources"
$	  endif
$!
$	  if all
$	  then
$	    chec = "Y"
$	    comm = "Y"
$	    fils = "Y"
$	    main = "Y"
$	    name = "Y"
$	    outp = "Y"
$	    proc = "Y"
$	    rout = "Y"
$	    str_ = "y"
$	    tree = "y"
$	    txtc = "Y"
$	    warn = "y"
$	    wsb
$	  else
$	    wsb
$!
$!	    ---------------ask which ones to compile -------------------
$!
$	    inquire main "    Main          - lcmsquash, cmdlin"
$	    wsb
$	    inquire chec "    Check         - check_rest"
$	    inquire comm "    Command stuff - get_cmd, process_cmd"
$	    inquire fils "    Files         - open_files, close_files"
$	    inquire name "    Names         - check_,add_,list_,f77_list_item"
$	    inquire outp "    Output        - generate_output,encrypt"
$	    inquire proc "    Processing    - process_input, process_buffer"
$	    inquire rout "    Routines      - do_ LITES,LCMRE.."
$	    inquire str_ "    Str_desc      - str_desc.c"
$	    inquire tree "    Tree library  - tree.c, my_tree.c"
$	    inquire txtc "    TXTC routines - read_line,rdnchrs,......"
$	    inquire warn "    Warning       - lcmwarn"
$!
$!	    ------------------------------------------------------------
$!
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
$	fdbg = ""
$	cdbg = ""
$!
$	if lbg   then ldbg= ldbg+"/debug"
$!
$	if debug
$	then
$	  fdbg = "/debug/noopt/check=(b,o)"
$	  cdbg = "/debug/noopt"
$	endif
$!
$	if cld
$	then
$	   set ver
$	   adc   lcmsquash.TMP=lcmsquash.CLD
$	   set command/object=lcmsquash_CLD  lcmsquash.TMP
$	   pvv   lcmsquash_CLD
$	   purge lcmsquash_CLD.OBJ
$	   delete/noconf ADC.IDE;*
$	   delete/noconf lcmsquash.TMP;*
$	   set nover
$	endif
$!
$	if msg 
$	then
$	   set ver
$	   newmsg  lcm/number=1608/runoff/hl=2
$	   @lcm.temp_com
$	   purge lcmMSG.*
$	   set nover
$	endif
$!
$!
$!	--------------------COMPILE IT NOW---------------------
$!
$	set nover
$	if main then call compile_it "main" -
		"lcmsquash.f + cmdlin.f"
$!
$	if chec then call compile_it "checks" -
		"check_rest.f"
$!
$	if comm then call compile_it "command_stuff" -
		"get_cmd.f + process_cmd.f"
$!
$	if fils then call compile_it "files" -
		"open_files.f + close_files.f"
$!
$	if name	then call compile_it "names"-
		"check_name.f + add_name.f + list_names.f + f77_list_item.f"
$!
$	if outp then call compile_it "output" -
		"generate_output.f + encrypt.f"
$!
$	if proc then call compile_it "processing" -
		"process_input.f + process_buffer.f"
$!
$	if rout then call compile_it "routines" -
   "do_LITES2.f+do_LCMREF.f+do_CMDSUBS.f+do_LABEL.f+do_MACRO.f"
$!
$	if tree
$	then
$		call compile_c "tree" "tree.c"
$		call compile_c "my_tree" "my_tree.c"
$	endif
$!
$	if str_ then call compile_c "strdesc" -
		"str_desc.c"
$!
$	if txtc then call compile_it "TXTC_routines" -
		"my_txtc_stuff.f"
$!
$	if warn then call compile_it "warning" -
		"lcmwarn.f"
$!
$!-------------------------------------LINK IT NOW-----------------------------
$!
$	if lnk
$	then
$	ws "-------------------------------------------------------"
$	set ver
$	  link'ldbg' /exe=lcmsquash/map=lcmsquash -
		main, files , TXTC_routines, processing, -
		command_stuff, output, routines, tree, my_tree, warning, -
		names, checks, strdesc, -
		lcmsquash_cld.obj, -
		lcm.promsg_obj, -
		lsl$library:lslshr/opt, -
		sys$input:/opt
sys$library:vaxcrtl/share
$	  set nover
$	  purge 
$	endif
$!
$ getout:
$	set noverify
$!
$	exit
$!
$!------------------------------------------------------------------------------
$!------------------------------------------------------------------------------
$!------------------------------------------------------------------------------
$compile_it: subroutine
$  on error then exit 4
$  on control_y then exit 4
$  ws "-------------------------------------------------------"
$  set ver
$  fortran 'fdbg'/extend/obj='p1' 'p2'
$  purge 'p1'.*
$  set nover
$endsubroutine
$!
$compile_c: subroutine
$  on error then exit 4
$  on control_y then exit 4
$  ws "-------------------------------------------------------"
$  set ver
$  cc 'cdbg' /obj='p1' 'p2'
$  purge 'p1'.OBJ
$  set nover
$endsubroutine
