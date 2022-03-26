$!
$	set noverify
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$! command file: OSPIF - a command file to build the OSPIF program
$!
$! Copyright (C) Laser-Scan Ltd, Cambridge, England
$!
$! Author R J Hulme, 03-Aug-1987
$!
$! Mod 1435 Use new frtshr				JB 23-Nov-1994
$!
$! *************************************************************************
$!
$	define  cmn  'f$logical("HERE")
$!
$	wsb = "write sys$output """""
$!
$	if P1.eqs."" then -
	  inquire P1 "Compile with debug                      "
$	if P1.eqs."" then P1 = "N"
$!
$	debug = P1
$!
$	wsb
$	inquire cld  "Command line definition                 "
$	inquire msg  "Messages                                "
$	wsb
$	inquire main "Main routine - OSPIF,OPEN_OUT,CLOSE_OUT "
$	inquire cmd  "Command line - GET_COMMAND              "
$	inquire prt  "Print        - PRTIFF,PRTCOD            "
$	inquire read "Read codes   - RDCODE                   "
$	inquire name "Sheet name   - OSNAME                   "
$	wsb
$	inquire lnk  "Link                                    "
$	inquire lbg  "Link with debug                         "
$	wsb
$!
$	ldbg="/notraceback/map"
$	dbg = ""
$	pd  = "delete"
$	ver = ";*"
$	if lbg   then ldbg= "/debug"
$	if debug then dbg = "/debug/check=all/noopt"
$	if debug then pd  = "purge"
$	if debug then ver = ""
$!
$	set verify
$	if .not.cld then goto no_cld
$	   adc   OSPIF.TMP=OSPIF.CLD
$	   set command/object=OSPIF_cld  OSPIF.TMP
$	   pvv   OSPIF_cld
$	   purge OSPIF_cld.OBJ
$	   delete ADC.IDE;*
$	   delete OSPIF.TMP;*
$no_cld:
$	if .not.msg then goto no_msg
$	   newmsg  OSPIF/number=1605/runoff/hl=2
$	   @OSPIF.temp_com
$	   purge OSPIFMSG.rno
$no_msg:
$	if .not.main then goto no_main
$	   adc   OSPIF/co=OSPIF,OPEN_OUT,CLOSE_OUT
$	   fortran/extend'dbg' OSPIF
$	   pvv   OSPIF
$	   purge OSPIF.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' OSPIF.FOR'ver'
$no_main:
$	if .not.cmd then goto no_cmd
$	   adc   GET_COMMAND/co=GET_COMMAND
$	   fortran/extend'dbg' GET_COMMAND
$	   pvv   GET_COMMAND
$	   purge GET_COMMAND.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' GET_COMMAND.FOR'ver'
$no_cmd:
$	if .not.prt then goto no_prt
$	   adc   PRTIFF/co=PRTIFF,PRTCOD
$	   fortran/extend'dbg' PRTIFF
$	   pvv   PRTIFF
$	   purge PRTIFF.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' PRTIFF.FOR'ver'
$no_prt:
$	if .not.read then goto no_read
$	   adc   RDCODE/co=RDCODE
$	   fortran/extend'dbg' RDCODE
$	   pvv   RDCODE
$	   purge RDCODE.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' RDCODE.FOR'ver'
$no_read:
$	if .not.name then goto no_name
$	   adc   OSNAME/co=OSNAME
$	   fortran/extend'dbg' OSNAME
$	   pvv   OSNAME
$	   purge OSNAME.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' OSNAME.FOR'ver'
$no_name:
$do_link:
$	if .not.lnk then goto exit_neatly
$!
$	link'ldbg'	ospif,get_command,prtiff,rdcode,osname, -
			ospif_cld, -
			ospif.promsg_obj, -
			lsl$library:osmhlib/lib, -
			lsl$library:iffshr/opt, -
			lsl$library:lslshr/opt, -
			lsl$library:frtshr/opt
$	purge OSPIF.*
$!
$exit_neatly:
$	set noverify
$!
