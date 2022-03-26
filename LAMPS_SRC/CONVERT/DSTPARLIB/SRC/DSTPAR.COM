$!
$! command file: DSTPARLIB - a command file to compile the DSTPARLIB routines
$!
$! Copyright (C) LaserScan Ltd, Cambridge, England
$!
$! Author 			P Pan 	 23 March 1990
$! Ripped off for TDST2I	J Barber 21 March 1991
$!
$! *************************************************************************
$!
$	set noverify            
$	on control_y then goto end
$	on error     then goto end
$!
$	assign lsl$source_root:[convert.dstparlib] lsl$cmndstpar
$!
$	wsb = "write sys$output """""
$!
$	inquire crelib "Create a new library               "
$!
$  	inquire debug  "Compile with debug                 "
$!
$	wsb
$	inquire do_a   "compile DSTPARLIB routines         "
$	inquire do_mes "compile messages                   "
$!
$	if .not. do_mes then goto job_cre
$	inquire do_rno "runoff messages                    "
$	if do_rno then runoff = "/runoff/hl=2"
$	wsb
$!
$ job_cre:
$	if      crelib then libc = "library/insert  DSTPARLIB"
$	if .not.crelib then libc = "library/replace DSTPARLIB"
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
$	if crelib then library/create DSTPARLIB
$!
$	if .not. do_mes then goto nomes
$	set verify
$	newmsg  dstpar/number=1628/prefix=dstpar__/param=for'runoff'
$	@DSTPAR.temp_com
$	if do_rno then purge DSTPARMSG.rno
$!
$ nomes:
$	if .not.do_a then goto end
$	set verify
$	adc RDPAR'cmt' = RDPAR
$	fort 'dbg' RDPAR
$	pvv RDPAR
$	macro'mbug' DSTPAR
$	append DSTPAR.obj RDPAR.obj
$	purge RDPAR.obj
$	delete adc.ide;*
$	pd DSTPAR.obj'ver'
$	pd RDPAR.for'ver'
$	'libc' RDPAR
$!
$end:
$	set noverify
$ exit
$!
