$	set noverify
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$! *************************************************************************
$! I2ARC.COM
$!
$! Copyright (C) LaserScan Laboratories Ltd, Cambridge, England  1988
$! Author 					TJ Ibbs,  4-Oct-1988
$! Modified for I2ARC				J Barber 15-May-1989
$! Modified to link in shared libraries         AJ Verrill 19-Mar-1990
$! *************************************************************************
$! and ask our questions
$!
$	debug = 0
$	comp  = 1
$!
$	inquire debug "with debug                          "
$!
$	write sys$output ""
$!
$	inquire  mes "messages                            "
$	inquire  cld "commands                            "
$!
$	write sys$output ""
$!
$	inquire  i2arc  "i2arc                               "
$	inquire  getfrt "getfrt                              "
$	inquire  cmd    "command line                        "
$!
$	write sys$output ""
$!
$	inquire  lnk "link                                "
$!
$	write sys$output ""
$!
$! *************************************************************************
$! so obey the commands now - sort out our flags first
$!
$	complib = 0
$	dbg  = ""
$	mdbg = ""
$	pd   = "delete"
$	ver  = ";*"
$	sfx  = ""
$	sf2  = ""
$	if debug then dbg  = "/debug/noopt"
$	if debug then mdbg = "/debug"
$	if debug then pd   = "purge"
$	if debug then ver  = ""
$!
$	set verify
$! .........................................................................
$	if .not.mes then goto nomes
$	   newmsg  i2arc.mes  /number=1620/param=c/runoff
$	   @i2arc.temp_com
$	   purge   i2arcmsg.h,.rno
$nomes:
$! .........................................................................
$	if .not.cld  then goto no_cld
$	   adc   i2arc.TMP=i2arc.CLD
$	   set command/object=i2arc_cld  i2arc.TMP
$	   pvv   i2arc_cld
$	   purge i2arc_cld.OBJ
$	   delete ADC.IDE;*
$	   delete i2arc.TMP;*
$no_cld:
$! .........................................................................
$	if i2arc then cc'dbg' i2arc
$	if getfrt then cc'dbg' getfrt
$	if cmd then cc'dbg' cmdline
$! .........................................................................
$	if .not.lnk then goto nolink
$	   link/map'mdbg' i2arc, getfrt, cmdline, -
			i2arc_cld, -
			i2arc.promsg_obj, -
!			lsl$library:lslfrtlib/lib, -
			lsl$library:cjacket/lib, -
			lsl$library:lslshr/opt, -
			lsl$library:iffshr/opt, -
			sys$input:/opt
sys$library:vaxcrtl/share
$!	   purge i2arc.*
$	   purge *.*obj
$	   purge *.map
$!	   purge *.*exe
$nolink:
$! .........................................................................
$!
$exit_neatly:	set noverify
$!
