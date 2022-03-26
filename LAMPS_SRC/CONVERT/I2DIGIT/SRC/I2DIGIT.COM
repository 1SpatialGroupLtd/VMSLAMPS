$	set noverify
!	
!
!	Copyright               Laser-Scan Ltd., Cambridge, England.
!
!	Created					ST	29-Nov-1990
!
! Description:
!
!	Command procedure to build I2DIGIT in CONVERT
!
!------------------------------------------------------------------------------
$!
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$	ws = "write sys$output"
$	wsb = "write sys$output """"
$	debug = "N"
$!
$	wsb
$	ws "Building I2DIGIT"
$	wsb
$	inquire/nopunct cmp    "Compile ?                     "
$	if .not.cmp then goto asklnk
$	inquire/nopunct debug  "with debug ?                  "
$	if debug.eqs."" then debug = "N"
$	wsb
$	inquire/nopunct cld    "Command language definition ? "
$	inquire/nopunct msg    "Messages ?                    "
$	wsb
$	inquire/nopunct addn   "ADD_NAME ?                    "
$	inquire/nopunct addw   "ADD_WORD ?                    "
$	inquire/nopunct chck   "CHECK_RANGE ?                 "
$	inquire/nopunct close  "CLOSE_FILES ?                 "
$	inquire/nopunct cmd    "CMDLINE ?                     "
$	inquire/nopunct find   "FIND_ENTRY ?                  "
$	inquire/nopunct flush  "FLUSH ?                       "
$	inquire/nopunct main   "I2DIGIT ?                     "
$	inquire/nopunct init   "INIT_TAPE ?                   "
$	inquire/nopunct int    "INT_RANGE ?                   "
$	inquire/nopunct num    "NUM_TO_CODES ?                "
$	inquire/nopunct opn    "OPEN_FILES ?                  "
$	inquire/nopunct pat    "PATCH_HEADER ?                "
$	inquire/nopunct proc   "PROCESS ?                     "
$	inquire/nopunct par    "RDPAR ?                       "
$	inquire/nopunct wrt1   "WRITE_DIGIT_TO_TAPE ?         "
$	inquire/nopunct wrt2   "WRITE_NEW_FEATURE ?           "
$	inquire/nopunct wrt3   "WRITE_SECTOR_HEADER ?         "
$	inquire/nopunct wrt4   "WRITE_PARTITION_HEADER ?      "
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
$	if lbg   then ldbg= "/debug/map/cross"
$	if debug then dbg = "/debug/noopt/check=(b,o)"
$	if debug then mbug = "/debug"
$	if debug then pd  = "purge"
$	if debug then ver = ""
$!
$!
$	set verify
$	if .not.cmp then goto do_link
$!
$	if .not.cld then goto no_cld
$	   set command/object =	I2DIGIT_CLD  I2DIGIT
$	   purge		I2DIGIT_CLD.OBJ
$no_cld:
$	if .not.msg then goto no_msg
$	   newmsg		I2DIGIT/NUMBER=1629/RUNOFF
$	   @I2DIGIT.TEMP_COM
$	   purge		I2DIGITMSG.*
$	   purge		I2DIGIT.PROMSG_OBJ
$no_msg:
$	if .not.addn then goto no_addn
$	   fortran/extend'dbg'	ADD_NAME.F
$	   purge		ADD_NAME.*
$no_addn:
$	if .not.addw then goto no_addw
$	   fortran/extend'dbg'	ADD_WORD.F
$	   purge		ADD_WORD.*
$no_addw:
$	if .not.chck then goto no_chck
$	   fortran/extend'dbg'	CHECK_RANGE.F
$	   purge		CHECK_RANGE.*
$no_chck:
$	if .not.close then goto no_close
$	   fortran/extend'dbg'	CLOSE_FILES.F
$	   purge		CLOSE_FILES.*
$no_close:
$	if .not.cmd then goto no_cmd
$	   fortran/extend'dbg'	CMDLINE.F
$	   purge		CMDLINE.*
$no_cmd:
$	if .not.find then goto no_find
$	   fortran/extend'dbg'	FIND_ENTRY.F
$	   purge		FIND_ENTRY.*
$no_find:
$	if .not.flush then goto no_flush
$	   fortran/extend'dbg'	FLUSH.F
$	   purge		FLUSH.*
$no_flush:
$	if .not.main then goto no_main
$	   fortran/extend'dbg'	I2DIGIT.F
$	   purge		I2DIGIT.*
$no_main:
$	if .not.init then goto no_init
$	   fortran/extend'dbg'	INIT_TAPE.F
$	   purge		INIT_TAPE.*
$no_init:
$	if .not.int then goto no_int
$	   fortran/extend'dbg'	INT_RANGE.F
$	   purge		INT_RANGE.*
$no_int:
$	if .not.num then goto no_num
$	   fortran/extend'dbg'	NUM_TO_CODES.F
$	   purge		NUM_TO_CODES.*
$no_num:
$	if .not.opn then goto no_opn
$	   fortran/extend'dbg'	OPEN_FILES.F
$	   purge		OPEN_FILES.*
$no_opn:
$	if .not.pat then goto no_pat
$	   fortran/extend'dbg'	PATCH_HEADER.F
$	   purge		PATCH_HEADER.*
$no_pat:
$	if .not.proc then goto no_proc
$	   fortran/extend'dbg'	PROCESS.F
$	   purge		PROCESS.*
$no_proc:
$	if .not.par then goto no_par
$	   fortran/extend'dbg'	RDPAR.F
$	   purge		RDPAR.*
$	   macro'mbug''list'	TABCMD
$	   append TABCMD.obj	RDPAR.obj
$	   purge		RDPAR.*
$	   delete/nocon		TABCMD.obj;*
$no_par:
$	if .not.wrt1 then goto no_wrt1
$	   fortran/extend'dbg'	WRITE_DIGIT_TO_TAPE.F
$	   purge		WRITE_DIGIT_TO_TAPE.*
$no_wrt1:
$	if .not.wrt2 then goto no_wrt2
$	   fortran/extend'dbg'	WRITE_NEW_FEATURE.F
$	   purge		WRITE_NEW_FEATURE.*
$no_wrt2:
$	if .not.wrt3 then goto no_wrt3
$	   fortran/extend'dbg'	WRITE_SECTOR_HEADER.F
$	   purge		WRITE_SECTOR_HEADER.*
$no_wrt3:
$	if .not.wrt4 then goto no_wrt4
$	   fortran/extend'dbg'	WRITE_PARTITION_HEADER.F
$	   purge		WRITE_PARTITION_HEADER.*
$no_wrt4:
$!
$do_link:
$	if .not.lnk then goto exit_neatly
$!
$	ws "Linking..."
$	ws "I2DIGIT"
$	link'ldbg'	I2DIGIT,-
			I2DIGIT_CLD,-
			ADD_NAME,ADD_WORD,CHECK_RANGE,CLOSE_FILES,CMDLINE,-
			FIND_ENTRY,FLUSH,INIT_TAPE,INT_RANGE,NUM_TO_CODES,-
			OPEN_FILES,PATCH_HEADER,PROCESS,RDPAR,-
			WRITE_DIGIT_TO_TAPE,WRITE_NEW_FEATURE,-
			WRITE_SECTOR_HEADER,WRITE_PARTITION_HEADER,-
			I2DIGIT.PROMSG_OBJ,-
			lsl$library:iffshr/opt,-
			lsl$library:lslshr/opt
$!
$!			lsl$library:ifflib/lib, -
$!			lsl$library:lsllib/lib
$	purge I2DIGIT.*
$exit_neatly:
$	set noverify
