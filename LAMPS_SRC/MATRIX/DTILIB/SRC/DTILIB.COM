$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-04-29 15:58:10.000000000 +0100
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
$! command file: MATRIX DTILIB - command file to create or update DTILIB
$!
$! Copyright (C) Laser-Scan Ltd, Cambridge, England  
$!
$! Author 				D R Catlow  -  09 October 1986
$!
$! *************************************************************************
$!
$	set noverify
$	define lsl$cmndti here
$!
$	on control_y then goto tidy_exit
$	on error     then goto tidy_exit
$!
$	ws	= "write sys$output"
$	wsb	= "write sys$output """""
$	inq	= "inquire"
$!
$! *********************************************************************
$! now, find out what we are meant to be doing...
$!
$	wsb
$	inq	new_library	"Make a new library     "
$	inq	with_debug	"With debug             "
$!
$! *************************************************************************
$! sort out subsidiary variables
$!
$	if with_debug then goto set_debug
$	   fdb     = ""
$	   mdb     = ""
$	   adcco   = ""
$	   cleanup = "delete"
$	   ver     = ";*"
$	   goto end_debug
$!
$set_debug:
$	   fdb     = "/lis/debug/noopt/check=all"
$	   mdb     = "/debug"
$	   adcco   = "/co"
$	   cleanup = "purge"
$	   ver     = ""
$!
$end_debug:
$!
$! *************************************************************************
$! if we are creating a library from scratch, then we shall insert modules
$! into it. If we are updating a library, then we shall replace modules in it
$!
$! now do the action
$!
$	libr = "library/replace/log  dtilib"
$	if .not.new_library then goto ask_what_to_replace
$!
$	library/create  dtilib
$	do_init 	= 1
$	do_file 	= 1
$	do_util 	= 1
$	do_read_header 	= 1
$	do_write_header = 1
$	do_read_data 	= 1
$	do_write_data 	= 1
$	do_copy_data 	= 1
$	do_init_data 	= 1
$	do_message 	= 1
$	goto compilation
$!
$! *************************************************************************
$ask_what_to_replace:
$!
$	wsb
$	ws "What to replace -"
$	wsb
$	inq	do_init		"INIT           - DTI_INIT,DTI_EXIT_HANDLER"
$	inq	do_file		"FILE           - DTI_OPEN file manipulation routines"
$	inq	do_util		"UTILITY        - DTI utility routines"
$	inq	do_read_header	"READ HEADER    - header reading routines"
$	inq	do_write_header	"WRITE HEADER   - header writing routines"
$	inq	do_read_data	"READ DATA      - data reading routines"
$	inq	do_write_data	"WRITE DATA     - data writing routines"
$	inq	do_copy_data	"COPY DATA      - data copying routines"
$	inq	do_init_data	"INIT DATA      - data setting routines"
$!
$	wsb
$	ws "Other, related items -"
$	wsb
$	inq	do_message	"MESSAGE        - message generation "
$	wsb
$!
$! *************************************************************************
$! now do the actual work...
$!
$compilation:	set verify
$!
$! always compile block data for IFFLIB
$!
$	adc 		md2 = lsl$cmniff:md2dat
$	fortran'fdb'	md2
$	pvv		md2
$	libr		md2
$	delete	md2*.obj;*, adc.ide;*
$	cleanup	md2.for'ver'				 
$!
$! we may have to generate the new message files
$!
$	if .not.do_message then goto no_message
$	   newmsg/runoff/number=1027/prefix=dti__/par=fort dtilib.mes
$	   @dtilib.temp_com
$	   libr		dtilib.promsg_obj
$	   delete	dtilib.promsg_obj;*
$	   purge	dtilibmsg.rno
$!
$no_message:
$!
$! and then the rest
$!
$	   if .not. do_init then goto no_init
$	   adc		initfor=dti_init
$	   adc		initfor/ap=dti_exit_handler
$	   fort'fdb'	initfor
$	   pvv		initfor
$	   libr		initfor
$	   delete	initfor*.obj;*, adc.ide;*
$	   cleanup	initfor.for'ver'
$!
$no_init:
$	   if .not. do_file then goto no_file
$	   adc		filefor=dti_open,dti_create
$          adc		filefor/ap=dti_extend_data,dti_extend_header
$	   adc		filefor/ap=dti_close
$	   fortran'fdb'	filefor
$	   pvv		filefor
$	   libr		filefor
$	   delete	filefor*.obj;*, adc.ide;*
$	   cleanup	filefor.for'ver'				 
$!
$no_file:
$	if .not. do_util then goto no_util
$	   adc		utilfor=dti_print_header
$	   adc		utilfor/ap=dti_print_projection
$	   adc		utilfor/ap=dti_next_lun
$	   adc		utilfor/ap=dti_minmax_data
$	   adc		utilfor/ap=dti_cvtang
$	   adc		utilfor/ap=dti_window_minmax
$	   adc		utilfor/ap=dti_units
$	   adc		utilfor/ap=dti_units_to_matrix
$	   adc		utilfor/ap=dti_win_units_to_matrix
$	   adc		utilfor/ap=dti_win_matrix_to_units
$	   adc		utilfor/ap=dti_matrix_to_units
$	   fortran'fdb'	utilfor
$	   pvv		utilfor
$	   libr		utilfor
$	   delete	util*.obj;*, adc.ide;*
$	   cleanup	utilfor.for'ver'
$!
$no_util:
$	if .not. do_read_header then goto no_read_header
$	   adc		readhfor=dti_read_header
$	   adc		readhfor/ap=dti_read_byte_header
$	   adc		readhfor/ap=dti_read_word_header
$	   adc		readhfor/ap=dti_read_long_header
$	   adc		readhfor/ap=dti_read_real_header
$	   adc		readhfor/ap=dti_read_real8_header
$	   adc		readhfor/ap=dti_read_proj_rec
$	   adc		readhfor/ap=dti_read_dsi
$	   adc		readhfor/ap=dti_read_uhl
$	   fortran'fdb'	readhfor
$	   pvv		readhfor
$	   libr		readhfor
$	   delete	readh*.obj;*, adc.ide;*
$	   cleanup	readhfor.for'ver'
$!
$no_read_header:
$	if .not. do_write_header then goto no_write_header
$	   adc		writehfor=dti_write_header
$	   adc		writehfor/ap=dti_write_byte_header
$	   adc		writehfor/ap=dti_write_word_header
$	   adc		writehfor/ap=dti_write_long_header
$	   adc		writehfor/ap=dti_write_real_header
$	   adc		writehfor/ap=dti_write_real8_header
$	   adc		writehfor/ap=dti_write_proj_rec
$	   adc		writehfor/ap=dti_write_dsi
$	   adc		writehfor/ap=dti_write_uhl
$	   fortran'fdb'	writehfor
$	   pvv		writehfor
$	   libr		writehfor
$	   delete	writeh*.obj;*, adc.ide;*
$	   cleanup	writehfor.for'ver'
$!
$no_write_header:
$	if  .not. do_read_data then goto no_read_data
$	   adc		readdfor=dti_read_data
$	   adc		readdfor/ap=dti_read_byte_data
$	   adc		readdfor/ap=dti_read_word_data
$	   adc		readdfor/ap=dti_read_long_data
$	   adc		readdfor/ap=dti_read_real_data
$	   adc		readdfor/ap=dti_read_bit_data
$	   fortran'fdb'	readdfor
$	   pvv		readdfor
$	   libr		readdfor
$	   delete	readd*.obj;*, adc.ide;*
$	   cleanup	readdfor.for'ver'
$!
$no_read_data:
$	if  .not. do_write_data then goto no_write_data
$	   adc		writedfor=dti_write_data
$	   adc		writedfor/ap=dti_write_byte_data
$	   adc		writedfor/ap=dti_write_word_data
$	   adc		writedfor/ap=dti_write_long_data
$	   adc		writedfor/ap=dti_write_real_data
$	   adc		writedfor/ap=dti_write_bit_data
$	   fortran'fdb'	writedfor
$	   pvv		writedfor
$	   libr		writedfor
$	   delete	writed*.obj;*, adc.ide;*
$	   cleanup	writedfor.for'ver'
$!
$no_write_data:
$	if  .not. do_copy_data then goto no_copy_data
$	   adc		copydfor=dti_copy_data
$	   adc		copydfor/ap=dti_copy_byte_data
$	   adc		copydfor/ap=dti_copy_word_data
$	   adc		copydfor/ap=dti_copy_long_data
$	   adc		copydfor/ap=dti_copy_real_data
$	   adc		copydfor/ap=dti_copy_bit_data
$	   adc		copydfor/ap=dti_copy_header
$	   adc		copydfor/ap=dti_copy_byte_header
$	   fortran'fdb'	copydfor
$	   pvv		copydfor
$	   libr		copydfor
$	   delete	copyd*.obj;*, adc.ide;*
$	   cleanup	copydfor.for'ver'
$!
$no_copy_data:
$	if  .not. do_init_data then goto no_init_data
$	   adc		initdfor=dti_init_data
$	   adc		initdfor/ap=dti_init_byte_data
$	   adc		initdfor/ap=dti_init_word_data
$	   adc		initdfor/ap=dti_init_long_data
$	   adc		initdfor/ap=dti_init_real_data
$	   adc		initdfor/ap=dti_init_bit_data
$	   fortran'fdb'	initdfor
$	   pvv		initdfor
$	   libr		initdfor
$	   delete	initd*.obj;*, adc.ide;*
$	   cleanup	initdfor.for'ver'
$!
$no_init_data:
$!
$! *************************************************************************
$! come here for a tidy exit
$!
$tidy_exit:
$	set noverify
$	deass lsl$cmndti:
$	exit
$!
