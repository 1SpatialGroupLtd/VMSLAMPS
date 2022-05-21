$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-02-27 17:00:38.000000000 +0000
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
$	set noverify
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$! command file: MSDS2I - a command file to build the MSDS2I program
$!
$! Copyright (C) LaserScan Laboratories Ltd, Cambridge, England  1985
$!
$! Author TJ Ibbs, 8 February 1988
$!
$! *************************************************************************
$!
$	wsb = "write sys$output """""
$!
$	inquire debug -
		     "Compile with debug                                      "
$	if debug.eqs."" then debug = "N"
$!
$	wsb
$	inquire cld  "Command line definition                                 "
$	inquire msg  "Messages                                                "
$	wsb
$	inquire main "Main routines    - msds2i,read_msds,get_space           "
$	inquire cmd  "Command line     - cmdline                              "
$	inquire filo "Open files       - open_msds,create_iff                 "
$	inquire filc "Close files      - close_msds/iff                       "
$	inquire hdr  "Headers          - read_header,read_count               "
$	inquire ftr1 "Features         - read_complex_feature                 "
$	inquire ftr2 "Features         - read_simple_area/line/point          "
$	inquire ftr3 "Low level        - read_face/edge/node                  "
$	inquire ron  "FC translation   - read_f.._table,translate_f.._name    "
$	inquire bit1 "Read             - read_attributes,relations            "
$	inquire bit2 "Read             - read_[theme_]pointers,coords         "
$	inquire bit3 "Read (edges)     - read_pos/neg_edge                    "
$	inquire bit4 "Read             - read_record,integer,string,comma     "
$	inquire bit5 "Read (ignore)    - ignore_bounds,pointers,relations     "
$	inquire wrt1 "Write            - write_areas,lines,points             "
$	inquire wrt2 "Write areas      - lookup_edges,sort,discard_interior   "
$	inquire wrt3 "Write lines      - lookup_edges                         "
$	inquire wrt4 "Write points     - write_nodes                          "
$	inquire wrt5 "Write (misc)     - order_edges,write_edges,attrs,coords "
$	inquire wrt6 "Write (flush)    - flush_zs                             "
$	inquire wrt7 "Write (sort)     - cf_edges,swap_edges                  "
$	wsb
$	inquire lnk  "Link                                                    "
$	inquire lbg  "Link with debug                                         "
$	wsb
$!
$	ldbg="/map"
$	dbg = ""
$	pd  = "delete"
$	ver = ";*"
$	if lbg   then ldbg= "/debug"
$	if debug then dbg = "/debug/noopt/check=all"
$	if debug then pd  = "purge"
$	if debug then ver = ""
$!
$	set verify
$! ............................................................................
$	if .not.cld then goto no_cld
$	   adc   msds2i_cld.TMP=msds2i.CLD
$	   set command/object=msds2i_cld  msds2i_cld.TMP
$	   pvv   msds2i_cld
$	   purge msds2i_cld.OBJ
$	   delete ADC.IDE;*
$	   delete msds2i_cld.TMP;*
$no_cld:
$! ............................................................................
$	if .not.msg then goto no_msg
$	   newmsg  MSDS2I/number=1608/runoff/hl=2
$	   @MSDS2I.temp_com
$	   purge MSDS2IMSG.*
$no_msg:
$! ............................................................................
$	if .not.main then goto no_main
$	   adc   msds2i/co=msds2i,read_msds,get_space
$	   fortran/extend'dbg' msds2i
$	   pvv   msds2i
$	   purge msds2i.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' msds2i.FOR'ver'
$no_main:
$! ............................................................................
$	if .not.cmd then goto no_cmd
$	   adc   cmdline/co=cmdline
$	   fortran/extend'dbg' cmdline
$	   pvv   cmdline
$	   purge cmdline.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' cmdline.FOR'ver'
$no_cmd:
$! ............................................................................
$	if .not.filo then goto no_filo
$	   adc   open_files/co=open_msds,create_iff
$	   fortran/extend'dbg' open_files
$	   pvv   open_files
$	   purge open_files.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' open_files.FOR'ver'
$no_filo:
$! ............................................................................
$	if .not.filc then goto no_filc
$	   adc   close_files/co=close_msds,close_iff
$	   fortran/extend'dbg' close_files
$	   pvv   close_files
$	   purge close_files.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' close_files.FOR'ver'
$no_filc:
$! ............................................................................
$	if .not.hdr then goto no_hdr
$	   adc   header/co=read_header,read_count
$	   fortran/extend'dbg' header
$	   pvv   header
$	   purge header.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' header.FOR'ver'
$no_hdr:
$! ............................................................................
$	if .not.ftr1 then goto no_ftr1
$	   adc feature1/co=read_complex_feature
$	   fortran/extend'dbg' feature1
$	   pvv   feature1
$	   purge feature1.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' feature1.FOR'ver'
$no_ftr1:
$! ............................................................................
$	if .not.ftr2 then goto no_ftr2
$	   adc feature2/co=read_simple_area,read_simple_line,read_simple_point
$	   fortran/extend'dbg' feature2
$	   pvv   feature2
$	   purge feature2.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' feature2.FOR'ver'
$no_ftr2:
$! ............................................................................
$	if .not.ftr3 then goto no_ftr3
$	   adc feature3/co=read_face,read_edge,read_node
$	   fortran/extend'dbg' feature3
$	   pvv   feature3
$	   purge feature3.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' feature3.FOR'ver'
$no_ftr3:
$! ............................................................................
$	if .not.bit1 then goto no_bit1
$	   adc   bit1/co=read_attributes,read_relations
$	   fortran/extend'dbg' bit1
$	   pvv   bit1
$	   purge bit1.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' bit1.FOR'ver'
$no_bit1:
$! ............................................................................
$	if .not.ron then goto no_ron
$	   adc   trans/co=read_feature_table,translate_feature_name,-
	                  read_trans_entry,lookup_feature_name,-
	                  add_ignored,write_ignored
$	   fortran/extend'dbg' trans
$	   pvv   trans
$	   purge trans.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' trans.FOR'ver'
$no_ron:
$! ............................................................................
$	if .not.bit2 then goto no_bit2
$	   adc   bit2/co=read_pointers,read_theme_pointers,read_coords
$	   fortran/extend'dbg' bit2
$	   pvv   bit2
$	   purge bit2.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' bit2.FOR'ver'
$no_bit2:
$! ............................................................................
$	if .not.bit3 then goto no_bit3
$	   adc   bit3/co=read_pos_edge,read_neg_edge
$	   fortran/extend'dbg' bit3
$	   pvv   bit3
$	   purge bit3.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' bit3.FOR'ver'
$no_bit3:
$! ............................................................................
$	if .not.bit4 then goto no_bit4
$	   adc  bit4/co=read_record,read_integer,read_string,-
	                        read_comma,read_dynamic_string,-
				inidsc,ini1dsc
$	   fortran/extend'dbg' bit4
$	   pvv   bit4
$	   purge bit4.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' bit4.FOR'ver'
$no_bit4:
$! ............................................................................
$	if .not.bit5 then goto no_bit5
$	   adc   bit5/co=ignore_bounds,ignore_pointers,ignore_relations
$	   fortran/extend'dbg' bit5
$	   pvv   bit5
$	   purge bit5.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' bit5.FOR'ver'
$no_bit5:
$! ............................................................................
$	if .not.wrt1 then goto no_wrt1
$	   adc   write1/co=write_areas,write_lines,write_points
$	   fortran/extend'dbg' write1
$	   pvv   write1
$	   purge write1.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' write1.FOR'ver'
$no_wrt1:
$! ............................................................................
$	if .not.wrt2 then goto no_wrt2
$	   adc   write2/co=lookup_edges_by_face,sort_edges,discard_interior_edges
$	   fortran/extend'dbg' write2
$	   pvv   write2
$	   purge write2.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' write2.FOR'ver'
$no_wrt2:
$! ............................................................................
$	if .not.wrt3 then goto no_wrt3
$	   adc   write3/co=lookup_edges_in_line
$	   fortran/extend'dbg' write3
$	   pvv   write3
$	   purge write3.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' write3.FOR'ver'
$no_wrt3:
$! ............................................................................
$	if .not.wrt4 then goto no_wrt4
$	   adc   write4/co=write_nodes
$	   fortran/extend'dbg' write4
$	   pvv   write4
$	   purge write4.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' write4.FOR'ver'
$no_wrt4:
$! ............................................................................
$	if .not.wrt5 then goto no_wrt5
$	   adc   write5/co=order_edges,write_coords,write_edges,write_attributes
$	   fortran/extend'dbg' write5
$	   pvv   write5
$	   purge write5.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' write5.FOR'ver'
$no_wrt5:
$! ............................................................................
$	if .not.wrt6 then goto no_wrt6
$	   adc   write6/co=flush_zs
$	   fortran/extend'dbg' write6
$	   pvv   write6
$	   purge write6.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' write6.FOR'ver'
$no_wrt6:
$! ............................................................................
$	if .not.wrt7 then goto no_wrt7
$	   adc   write7/co=cf_edges,swap_edges
$	   fortran/extend'dbg' write7
$	   pvv   write7
$	   purge write7.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' write7.FOR'ver'
$no_wrt7:
$! ............................................................................
$do_link:
$	if .not.lnk then goto exit_neatly
$!
$	link/map'ldbg'	msds2i,cmdline, -
			open_files,close_files,header, -
			feature1,feature2,feature3, -
			bit1,bit2,bit3,bit4,bit5, -
			trans, -
			write1,write2,write3,write4,write5,write6, -
			write7,-
			msds2i_cld, -
			msds2i.promsg_obj, -
			lsl$library:iffshr/opt, -
			lsl$library:lslshr/opt
$	purge msds2i.*
$exit_neatly:
$	set noverify
