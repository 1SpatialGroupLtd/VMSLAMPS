$	set noverify
!	
!
!	Copyright               Laser-Scan Ltd., Cambridge, England.
!
!	Created					ST	22-Apr-1991
!
! Description:
!
!	Command procedure to build jiffy i2GEN
!
!-------------------------------------------------------------------------------
$!
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$	ws = "write sys$output"
$	wsb = "write sys$output """"
$	debug = "N"
$!
$	wsb
$	ws "Building ARC2I"
$	wsb
$	inquire/nopunct cmp    "Compile ?                     "
$	if .not.cmp then goto asklnk
$	inquire/nopunct debug  "with debug ?                  "
$	if debug.eqs."" then debug = "N"
$	wsb
$	inquire/nopunct cld    "Command language definition ? "
$	wsb
$	inquire/nopunct main   "MOSS2TXT ?                    "
$	inquire/nopunct cmd    "CMDLIN ?                      "
$	inquire/nopunct get    "GET_FILES ?                   "
$	inquire/nopunct gr     "PROCESS_GR ?                  "
$	inquire/nopunct os     "PROCESS_OS ?                  "
$	inquire/nopunct pr     "PROCESS_PR ?                  "
$	wsb
$asklnk:
$	inquire/nopunct lnk    "Link ?                        "
$	inquire/nopunct lbg    "with debug ?                  "
$	wsb
$!
$	ldbg="/map"
$	dbg = ""
$	mbug = ""
$	pd  = "delete/nocon"
$	ver = ";*"
$	if lbg   then ldbg= "/debug"
$	if debug then dbg = "/debug/noopt/check=(b,o)/lis/co"
$	if debug then mbug = "/debug"
$	if debug then pd  = "purge"
$	if debug then ver = ""
$!
$!
$	set verify
$	if .not.cmp then goto do_link
$!
$	if .not.cld then goto no_cld
$	   set command/object =	MOSS2TXT_CLD  MOSS2TXT
$	   purge		MOSS2TXT_CLD.OBJ
$no_cld:
$	if .not.main then goto no_main
$	   fortran/extend'dbg'	MOSS2TXT.F
$	   purge		MOSS2TXT.*
$no_main:
$	if .not.cmd then goto no_cmd
$	   fortran/extend'dbg'	CMDLIN.F
$	   purge		CMDLIN.*
$no_cmd:
$	if .not.get then goto no_get
$	   fortran/extend'dbg'	GET_FILES.F
$	   purge		GET_FILES.*
$no_get:
$	if .not.gr then goto no_gr
$	   fortran/extend'dbg'	PROCESS_GR.F
$	   purge		PROCESS_GR.*
$no_gr:
$	if .not.os then goto no_os
$	   fortran/extend'dbg'	PROCESS_OS.F
$	   purge		PROCESS_OS.*
$no_os:
$	if .not.pr then goto no_pr
$	   fortran/extend'dbg'	PROCESS_PR.F
$	   purge		PROCESS_PR.*
$no_pr:
$do_link:
$	if .not.lnk then goto exit_neatly
$!
$	ws "Linking..."
$	ws "MOSS2TXT"
$	link'ldbg'	MOSS2TXT,-
			MOSS2TXT_CLD,-
			CMDLIN,GET_FILES,-
			PROCESS_GR,-
			PROCESS_OS,-
			PROCESS_PR,-
			lsl$library:lslshr/opt
$	purge MOSS2TXT.*
$exit_neatly:
$	set noverify
