$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-09-20 17:38:08.000000000 +0100
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
$! command file: DXFPARLIB - a command file to compile the DXFPARLIB routines
$!
$! Copyright (C) LaserScan Ltd, Cambridge, England
$!
$! Author P Pan, 23 March 1990
$!
$! MOD 1413 Add RDTEXT for text size in parameter file    JB 20-Sep-1994
$!
$! *************************************************************************
$!
$	set noverify            
$	on control_y then goto end
$	on error     then goto end
$!
$!	assign lsl$source_root:[convert.dxfparlib] lsl$cmndxfpar
$	assign lsl$source_root:[convert.dxfparlib.src] lsl$cmndxfpar
$!
$	wsb = "write sys$output """""
$!
$	inquire crelib "Create a new library               "
$!
$  	inquire debug  "Compile with debug                 "
$!
$	wsb
$	inquire do_a   "compile DXFPARLIB routines         "
$	inquire do_mes "compile messages                   "
$!
$	if .not. do_mes then goto job_cre
$	inquire do_rno "runoff messages                    "
$	if do_rno then runoff = "/runoff/hl=2"
$	wsb
$!
$ job_cre:
$	if      crelib then libc = "library/insert  DXFPARLIB"
$	if .not.crelib then libc = "library/replace DXFPARLIB"
$!
$	dbg = ""
$	pd  = "delete"
$	ver = ";*"
$	if debug then dbg  = "/debug/noopt/check=(b,o)"
$	if debug then mbug = "/debug"
$	if debug then cmt  = "/co   "
$	if debug then pd   = "purge"
$	if debug then ver  = ""
$!
$	if crelib then library/create DXFPARLIB
$!
$	if .not. do_mes then goto nomes
$	set verify
$	newmsg  DXFPAR/number=1623'runoff'
$	@DXFPAR.temp_com
$	if do_rno then purge DXFPARMSG.rno
$!
$ nomes:
$	if .not.do_a then goto end
$	set verify
$	adc RDPAR'cmt' = RDPAR,RDLAYER,RDENTITY,RDTEXT
$	adc RDPAR'cmt'/ap = READ_NAME,READ_FRT 
$	fort 'dbg' RDPAR
$	pvv RDPAR
$	macro'mbug' DXFPAR
$	append DXFPAR.obj RDPAR.obj
$	purge RDPAR.obj
$	delete adc.ide;*
$	pd DXFPAR.obj'ver'
$	pd RDPAR.for'ver'
$	'libc' RDPAR
$!
$end:
$	set noverify
$ exit
$!
