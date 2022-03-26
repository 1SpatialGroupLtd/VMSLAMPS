$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$! command file: TVES - command file to create or update TVES_SERVICE
$!
$! Copyright (C) Laser-Scan Ltd, Cambridge, England  
$!
$! Author  For DTILIB				D R Catlow  -  09 October 1986
$! Mod1264 Modified for tves_service		J Barber    -  09 August  1993
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	set noverify
$	define lsl$tvessys 	here
$	define lsl$dtmcreatesys here
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
$	libr = "library/replace/log  TVES_SERVICE"
$	if .not.new_library then goto ask_what_to_replace
$!
$	library/create  TVES_SERVICE
$	dtmjpi		= 1
$	hlp_erret	= 1
$	spawn_cmd	= 1
$	pause_cmd	= 1
$	wait_cmd	= 1
$	longin		= 1
$	realin		= 1
$!
$	goto compilation
$!
$! *************************************************************************
$ask_what_to_replace:
$!
$	wsb
$	ws "What to replace -"
$	wsb
$	inq	dtmjpi		"dtmjpi"
$	inq	hlp_erret	"hlp_erret"
$	inq	pause_cmd	"pause_cmd"
$	inq	spawn_cmd	"spawn_cmd"
$	inq	wait_cmd	"wait_cmd"
$	inq	longin		"longin"
$	inq	realin		"realin"
$!
$	wsb
$!
$! *************************************************************************
$! now do the actual work...
$!
$compilation:	set verify
$!
$! and then the rest
$!
$	   if .not.dtmjpi then goto no_dtm
$	   adc		dtmjpi = dtmjpi
$	   fort'fdb'	dtmjpi
$	   pvv		dtmjpi
$	   libr		dtmjpi
$	   delete	dtmjpi.obj;*, adc.ide;*
$	   cleanup	dtmjpi.for'ver'
$no_dtm:
$	   if .not. hlp_erret then goto no_hlp
$	   adc		hlp_erret = hlp_erret
$	   fortran'fdb'	hlp_erret
$	   pvv		hlp_erret
$	   libr		hlp_erret
$	   delete	hlp_erret.obj;*,adc.ide;*
$	   cleanup	hlp_erret.for'ver'				 
$no_hlp:
$	if  .not.pause_cmd then goto no_pause
$	   adc		pause_cmd = pause_cmd 
$	   fortran'fdb'	pause_cmd
$	   pvv		pause_cmd
$	   libr		pause_cmd
$	   delete	pause_cmd.obj;*,adc.ide;*
$	   cleanup	pause_cmd.for'ver'
$no_pause:
$	if  .not.spawn_cmd then goto no_spawn
$	   adc		spawn_cmd = spawn_cmd
$	   fortran'fdb'	spawn_cmd
$	   pvv		spawn_cmd
$	   libr		spawn_cmd
$	   delete	spawn_cmd.obj;*,adc.ide;*
$	   cleanup	spawn_cmd.for'ver'
$no_spawn:
$	if  .not.wait_cmd then goto no_wait
$	   adc		wait_cmd = wait_cmd
$	   fortran'fdb'	wait_cmd
$	   pvv		wait_cmd
$	   libr		wait_cmd
$	   delete	wait_cmd.obj;*,adc.ide;*
$	   cleanup	wait_cmd.for'ver'
$no_wait:
$	if  .not.longin then goto no_long
$	   adc		longin = longin
$	   fortran'fdb'	longin
$	   pvv		longin
$	   libr		longin
$	   delete	longin.obj;*,adc.ide;*
$	   cleanup	longin.for'ver'
$no_long:
$	if  .not.realin then goto no_real
$	   adc		realin = realin
$	   fortran'fdb'	realin
$	   pvv		realin
$	   libr		realin
$	   delete	realin.obj;*,adc.ide;*
$	   cleanup	realin.for'ver'
$no_real:
$! *************************************************************************
$! come here for a tidy exit
$!
$tidy_exit:
$	set noverify
$	exit
$!
