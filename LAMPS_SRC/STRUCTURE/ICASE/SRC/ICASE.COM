$!
$!	Copyright Laser-Scan Ltd., Cambridge, England.
$!
$!	Created					ST	29-Nov-1990
$!
$!	Command procedure to build ICASE in STRUCTURE
$!
$!	Mod1426 to build with frtshr		JB	16-Nov-1994
$!
$!-------------------------------------------------------------------------------
$!
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$	define/nolog lsl$icase here
$!
$	ws = "write sys$output"
$	wsb = "write sys$output """"
$	debug = "n"
$!
$	wsb
$	ws "Building ICASE"
$	wsb
$	inquire/nopunct cmp    "Compile ?                     "
$	if .not.cmp then goto asklnk
$	inquire/nopunct debug  "with debug ?                  "
$	if debug.eqs."" then debug = "n"
$	wsb
$	inquire/nopunct cld    "Command language definition ? "
$	inquire/nopunct msg    "Messages ?                    "
$	wsb
$	inquire/nopunct arm    "ADJACENT_ARM ?               "
$	inquire/nopunct chk    "CHECK_GT ?                   "
$	inquire/nopunct chk2   "CHECK_RANGE ?                "
$	inquire/nopunct clo    "CLOSE_FILES ?                "
$	inquire/nopunct case   "CREATE_CASINGS ?             "
$	inquire/nopunct fills  "CREATE_FILLS ?               "
$	inquire/nopunct cmd    "GET_COMMAND ?                "
$	inquire/nopunct fc     "GET_FC ?                     "
$	inquire/nopunct ftrs   "GET_FTR ?                    "
$	inquire/nopunct wid    "GET_WIDTH ?                  "
$	inquire/nopunct pass   "FIRST_PASS ?                 "
$	inquire/nopunct main   "ICASE ?                      "
$	inquire/nopunct off    "OFFSET ?                     "
$	inquire/nopunct open   "OPEN_FILES ?                 "
$	inquire/nopunct proc   "PROCESS ?                    "
$	inquire/nopunct putf   "PUT_FTR ?                    "
$	inquire/nopunct rdpar  "RDPAR ?                      "
$	inquire/nopunct scan   "SCAN_IFF ?                   "
$	wsb
$asklnk:
$	inquire/nopunct lnk    "Link ?                        "
$	inquire/nopunct lbg    "with debug ?                  "
$	wsb
$!
$	ldbg="/map/cross"
$	dbg = ""
$	mbug = ""
$	pd  = "delete/nocon"
$	ver = ";*"
$!
$	if lbg   then ldbg = ldbg + "/debug"
$	if debug then dbg  = "/debug/noopt/check"
$	if debug then mbug = "/debug"
$	if debug then pd   = "purge"
$	if debug then ver  = ""
$!
$	set verify
$	if .not.cmp then goto do_link
$!
$	if .not.cld then goto no_cld
$	   set command/object =	ICASE_CLD  ICASE
$	   purge		ICASE_CLD.OBJ
$no_cld:
$	if .not.msg then goto no_msg
$	   newmsg		ICASE/number=1252/runoff
$	   @ICASE.TEMP_COM
$	   purge		ICASEMSG.*
$	   purge		ICASE.PROMSG_OBJ
$no_msg:
$	if .not.arm then goto no_arm
$	   fortran/extend'dbg'	ADJACENT_ARM.F
$	   purge		ADJACENT_ARM.*
$no_arm:
$	if .not.chk then goto no_chk
$	   fortran/extend'dbg'	CHECK_GT.F
$	   purge		CHECK_GT.*
$no_chk:
$	if .not.chk2 then goto no_chk2
$	   fortran/extend'dbg'	CHECK_RANGE.F
$	   purge		CHECK_RANGE.*
$no_chk2:
$	if .not.clo then goto no_clo
$	   fortran/extend'dbg'	CLOSE_FILES.F
$	   purge		CLOSE_FILES.*
$no_clo:
$	if .not.case then goto no_case
$	   fortran/extend'dbg'	CREATE_CASINGS.F
$	   purge		CREATE_CASINGS.*
$no_case:
$	if .not.fills then goto no_fills
$	   fortran/extend'dbg'	CREATE_FILLS.F
$	   purge		CREATE_FILLS.*
$no_fills:
$	if .not.cmd then goto no_cmd
$	   fortran/extend'dbg'	GET_COMMAND.F
$	   purge		GET_COMMAND.*
$no_cmd:
$	if .not.fc then goto no_fc
$	   fortran/extend'dbg'	GET_FC.F
$	   purge		GET_FC.*
$no_fc:
$	if .not.ftrs then goto no_ftrs
$	   fortran/extend'dbg'	GET_FTR.F
$	   purge		GET_FTR.*
$no_ftrs:
$	if .not.wid then goto no_wid
$	   fortran/extend'dbg'	GET_WIDTH.F
$	   purge		GET_WIDTH.*
$no_wid:
$	if .not.pass then goto no_pass
$	   fortran/extend'dbg'	FIRST_PASS.F
$	   purge		FIRST_PASS.*
$no_pass:
$	if .not.main then goto no_main
$	   fortran/extend'dbg'	ICASE.F
$	   purge		ICASE.*
$no_main:
$	if .not.off then goto no_off
$	   fortran/extend'dbg'	OFFSET.F
$	   purge		OFFSET.*
$no_off:
$	if .not.open then goto no_open
$	   fortran/extend'dbg'	OPEN_FILES.F
$	   purge		OPEN_FILES.*
$no_open:
$	if .not.proc then goto no_proc
$	   fortran/extend'dbg'	PROCESS.F
$	   purge		PROCESS.*
$no_proc:
$	if .not.putf then goto no_putf
$	   fortran/extend'dbg'	PUT_FTR.F
$	   purge		PUT_FTR.*
$no_putf:
$	if .not.rdpar then goto no_rdpar
$	   fortran/extend'dbg'	RDPAR.F
$	   purge		RDPAR.*
$	   macro'mbug''list'	TABCMD
$	   append TABCMD.obj	RDPAR.obj
$	   purge		RDPAR.obj
$	   delete/nocon		TABCMD.obj;*
$no_rdpar:
$	if .not.scan then goto no_scan
$	   fortran/extend'dbg'	SCAN_IFF.F
$	   purge		SCAN_IFF.*
$no_scan:
$!
$do_link:
$	if .not.lnk then goto exit_neatly
$!
$	ws "Linking..."
$	ws "ICASE"
$	link'ldbg'	icase,-
			icase_cld,-
			adjacent_arm,check_gt,check_range,-
			close_files,create_fills,create_casings,-
			get_command,get_fc,get_ftr,get_width,-
			first_pass,offset,open_files,process,put_ftr,-
			rdpar,scan_iff,-
			icase.promsg_obj,-
			lsl$library:frtshr/opt,-
			lsl$library:iffshr/opt,-
			lsl$library:lslshr/opt
$!
$!			lsl$library:lslfrtlib/lib, -
$!			lsl$library:ifflib/lib, -
$!			lsl$library:lsllib/lib
$!
$	purge icase.*
$!
$exit_neatly:
$	set noverify
$!
