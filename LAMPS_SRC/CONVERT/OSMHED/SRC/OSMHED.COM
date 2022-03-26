$	set noverify
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$! command file: OSMHED - a command file to build the OSMHED program
$!
$! Copyright (C) LaserScan Laboratories Ltd, Cambridge, England
$!
$! Author R J Hulme, 28-Jul-1987
$!
$! *************************************************************************
$!
$	define  cmn  'f$logical("HERE")
$!
$	wsb = "write sys$output """""
$!
$	if P1.eqs."" then -
	  inquire P1 "Compile with debug                    "
$	if P1.eqs."" then P1 = "N"
$!
$	debug = P1
$!
$	wsb
$	inquire cld  "Command line definition               "
$	inquire msg  "Messages                              "
$	wsb
$	inquire main "Main routine  - OSMHED                "
$	inquire cmd  "Command line  - GET_COMMAND           "
$	inquire inq  "Inquire       - MHINQ                 "
$	inquire prt  "Print MH      - PRTDMB,HALF,QUART     "
$	inquire name "Sheet name    - OSNAME                "
$	inquire bin  "Binary dates  - FROM_BINDAY,TO_BINDAY "
$	inquire icl  "ASCII/ICL     - ASC,ASC_FLGS,ICL      "
$	wsb
$	inquire lnk  "Link                                  "
$	inquire lbg  "Link with debug                       "
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
$	   adc   OSMHED.TMP=OSMHED.CLD
$	   set command/object=OSMHED_cld  OSMHED.TMP
$	   pvv   OSMHED_cld
$	   purge OSMHED_cld.OBJ
$	   delete ADC.IDE;*
$	   delete OSMHED.TMP;*
$no_cld:
$	if .not.msg then goto no_msg
$	   newmsg  OSMHED/number=1604/runoff/hl=2
$	   @osmhed.temp_com
$	   purge OSMHEDMSG.rno
$no_msg:
$	if .not.main then goto no_main
$	   adc   OSMHED/co=OSMHED
$	   fortran/extend'dbg' OSMHED
$	   pvv   OSMHED
$	   purge OSMHED.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' OSMHED.FOR'ver'
$no_main:
$	if .not.cmd then goto no_cmd
$	   adc   GET_COMMAND/co=GET_COMMAND
$	   fortran/extend'dbg' GET_COMMAND
$	   pvv   GET_COMMAND
$	   purge GET_COMMAND.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' GET_COMMAND.FOR'ver'
$no_cmd:
$	if .not.inq then goto no_inq
$      	   adc   MHINQ/co=MHINQ
$	   fortran/extend'dbg' MHINQ
$	   pvv   MHINQ
$	   purge MHINQ.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' MHINQ.FOR'ver'
$no_inq:
$	if .not.prt then goto no_prt
$	   adc   PRTDMB/co=PRTDMB,HALF,QUART
$	   fortran/extend'dbg' PRTDMB
$	   pvv   PRTDMB
$	   purge PRTDMB.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' PRTDMB.FOR'ver'
$no_prt:
$	if .not.name then goto no_name
$	   adc   OSNAME/co=OSNAME
$	   fortran/extend'dbg' OSNAME
$	   pvv   OSNAME
$	   purge OSNAME.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' OSNAME.FOR'ver'
$no_name:
$	if .not.bin then goto no_bin
$	   adc   BINDAY/co=FROM_BINDAY,TO_BINDAY
$	   fortran/extend'dbg' BINDAY
$	   pvv   BINDAY
$	   purge BINDAY.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' BINDAY.FOR'ver'
$no_bin:
$	if .not.icl then goto no_icl
$	   adc   ASCICL/co=ASC,ASC_FLGS,ICL
$	   fortran/extend'dbg' ASCICL
$	   pvv   ASCICL
$	   purge ASCICL.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' ASCICL.FOR'ver'
$no_icl:
$do_link:
$	if .not.lnk then goto exit_neatly
$!
$	link'ldbg'	OSMHED,GET_COMMAND,MHINQ,PRTDMB,OSNAME,BINDAY,ASCICL, -
			OSMHED_cld, -
			OSMHED.promsg_obj, -
			lsl$library:iffshr/opt, -
			lsl$library:osmhlib/lib, -
			lsl$library:lslshr/opt
$	purge OSMHED.*
$exit_neatly:
$	set noverify
