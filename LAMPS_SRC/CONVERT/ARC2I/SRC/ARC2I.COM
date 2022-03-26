$!
$	set noverify
$!
$!	Copyright               Laser-Scan Ltd., Cambridge, England.
$!
$!	Created						ST 29-Nov-1990
$!
$!	Mod 1435 Use new frtshr				JB  1-Dec-1994
$!
$!	Command procedure to build ARC2I in CONVERT
$!
$!-----------------------------------------------------------------------------
$!
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$	ws = "write sys$output"
$	wsb = "write sys$output """"
$	debug = "n"
$!
$	wsb
$	ws "Building ARC2I"
$	wsb
$	inquire/nopunct cmp    "Compile ?                     "
$	if .not.cmp then goto asklnk
$	inquire/nopunct debug  "with debug ?                  "
$	if debug.eqs."" then debug = "n"
$	wsb
$	inquire/nopunct cld    "Command language definition ? "
$	inquire/nopunct msg    "Messages ?                    "
$	wsb
$	inquire/nopunct main   "ARC2I ?                       "
$	inquire/nopunct chck   "CHECK_RANGE ?                 "
$	inquire/nopunct clo    "CLOSE_FILES ?                 "
$	inquire/nopunct cmd    "CMDLINE ?                     "
$	inquire/nopunct iff    "CREATE_IFF ?                  "
$	inquire/nopunct crea   "CREATE_FILES ?                "
$	inquire/nopunct find   "FIND_TAB_POSN ?               "
$	inquire/nopunct acs    "GET_ACS ?                     "
$	inquire/nopunct geta   "GET_ARCS ?                    "
$	inquire/nopunct getc   "GET_CP ?                      "
$	inquire/nopunct eline  "GET_EXP_LINE ?                "
$	inquire/nopunct name   "GET_FILENAME ?                "
$	inquire/nopunct getp   "GET_PTS ?                     "
$	inquire/nopunct tline  "GET_TMP_LINE ?                "
$	inquire/nopunct txt    "GET_TXT ?                     "
$	inquire/nopunct tx6    "GET_TXTSIX ?                  "
$	inquire/nopunct init   "INIT_TAPE ?                   "
$	inquire/nopunct next   "NEXT_EXPORT ?                 "
$	inquire/nopunct proc   "PROCESS ?                     "
$	inquire/nopunct rdadt  "RDADT ?                       "
$	inquire/nopunct rdtab  "RDADTTAB ?                    "
$	inquire/nopunct rdanno "RDANNO ?                      "
$	inquire/nopunct rdnam  "RDNAM ?                       "
$	inquire/nopunct rdpar  "RDPAR ?                       "
$	inquire/nopunct rdblk  "READBLK ?                     "
$	inquire/nopunct rew    "REWIND_FILE ?                 "
$	inquire/nopunct tfc    "TEXT_FCODE ?                  "
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
$	if lbg   then ldbg= "/debug"
$	if debug then dbg = "/debug/noopt/check"
$	if debug then mbug = "/debug"
$	if debug then pd  = "purge"
$	if debug then ver = ""
$!
$!
$	set verify
$	if .not.cmp then goto do_link
$!
$	if .not.cld then goto no_cld
$	   set command/object =	ARC2I_CLD  ARC2I
$	   purge		ARC2I_CLD.OBJ
$no_cld:
$	if .not.msg then goto no_msg
$	   newmsg		ARC2I/number=1626/runoff
$	   @ARC2I.TEMP_COM
$	   purge		ARC2IMSG.*
$	   purge		ARC2I.PROMSG_OBJ
$no_msg:
$	if .not.main then goto no_main
$	   fortran/extend'dbg'	ARC2I.F
$	   purge		ARC2I.*
$no_main:
$	if .not.chck then goto no_chck
$	   fortran/extend'dbg'	CHECK_RANGE.F
$	   purge		CHECK_RANGE.*
$no_chck:
$	if .not.clo then goto no_clo
$	   fortran/extend'dbg'	CLOSE_FILES.F
$	   purge		CLOSE_FILES.*
$no_clo:
$	if .not.cmd then goto no_cmd
$	   fortran/extend'dbg'	CMDLINE.F
$	   purge		CMDLINE.*
$no_cmd:
$	if .not.iff then goto no_iff
$	   fortran/extend'dbg'	CREATE_IFF.F
$	   purge		CREATE_IFF.*
$no_iff:
$	if .not.crea then goto no_crea
$	   fortran/extend'dbg'	CREATE_FILES.F
$	   purge		CREATE_FILES.*
$no_crea:
$	if .not.find then goto no_find
$	   fortran/extend'dbg'	FIND_TAB_POSN.F
$	   purge		FIND_TAB_POSN.*
$no_find:
$	if .not.acs then goto no_acs
$	   fortran/extend'dbg'	GET_ACS.F
$	   purge		GET_ACS.*
$no_acs:
$	if .not.geta then goto no_geta
$	   fortran/extend'dbg'	GET_ARCS.F
$	   purge		GET_ARCS.*
$no_geta:
$	if .not.getc then goto no_getc
$	   fortran/extend'dbg'	GET_CP.F
$	   purge		GET_CP.*
$no_getc:
$	if .not.eline then goto no_eline
$	   fortran/extend'dbg'	GET_EXP_LINE.F
$	   purge		GET_EXP_LINE.*
$no_eline:
$	if .not.name then goto no_name
$	   fortran/extend'dbg'	GET_FILENAME.F
$	   purge		GET_FILENAME.*
$no_name:
$	if .not.getp then goto no_getp
$	   fortran/extend'dbg'	GET_PTS.F
$	   purge		GET_PTS.*
$no_getp:
$	if .not.tline then goto no_tline
$	   fortran/extend'dbg'	GET_TMP_LINE.F
$	   purge		GET_TMP_LINE.*
$no_tline:
$	if .not.txt then goto no_txt
$	   fortran/extend'dbg'	GET_TXT.F
$	   purge		GET_TXT.*
$no_txt:
$	if .not.tx6 then goto no_tx6
$	   fortran/extend'dbg'	GET_TXTSIX.F
$	   purge		GET_TXTSIX.*
$no_tx6:
$	if .not.init then goto no_init
$	   fortran/extend'dbg'	INIT_TAPE.F
$	   purge		INIT_TAPE.*
$no_init:
$	if .not.next then goto no_next
$	   fortran/extend'dbg'	NEXT_EXPORT.F
$	   purge		NEXT_EXPORT.*
$no_next:
$	if .not.proc then goto no_proc
$	   fortran/extend'dbg'	PROCESS.F
$	   purge		PROCESS.*
$no_proc:
$	if .not.rdadt then goto no_rdadt
$	   fortran/extend'dbg'	RDADT.F
$	   purge		RDADT.*
$	   macro'mbug''list' 	FLDCMD
$	   append FLDCMD.obj 	RDADT.obj
$	   purge 		RDADT.obj
$	   delete/nocon 	FLDCMD.obj;*
$no_rdadt:
$	if .not.rdtab then goto no_rdtab
$	   fortran/extend'dbg'	RDADTTAB.F
$	   purge		RDADTTAB.*
$	   macro'mbug''list' 	TABCMD
$	   append TABCMD.obj 	RDADTTAB.obj
$	   purge 		RDADTTAB.obj
$	   delete/nocon 	TABCMD.obj;*
$no_rdtab:
$	if .not.rdanno then goto no_rdanno
$	   fortran/extend'dbg'	RDANNO.F
$	   purge		RDANNO.*
$	   macro'mbug''list' 	LEVSYMCMD
$	   append LEVSYMCMD.obj RDANNO.obj
$	   purge 		RDANNO.obj
$	   delete/nocon 	LEVSYMCMD.obj;*
$no_rdanno:
$	if .not.rdnam then goto no_rdnam
$	   fortran/extend'dbg'	RDNAM.F
$	   purge		RDNAM.*
$no_rdnam:
$	if .not.rdpar then goto no_rdpar
$	   fortran/extend'dbg'	RDPAR.F
$	   purge		RDPAR.*
$	   macro'mbug''list'	PARCMD
$	   append PARCMD.obj	RDPAR.obj
$	   purge		RDPAR.obj
$	   delete/nocon		PARCMD.obj;*
$no_rdpar:
$	if .not.rdblk then goto no_rdblk
$	   fortran/extend'dbg'	READBLK.F
$	   purge		READBLK.*
$no_rdblk:
$	if .not.rew then goto no_rew
$	   fortran/extend'dbg'	REWIND_FILE.F
$	   purge		REWIND_FILE.*
$no_rew:
$	if .not.tfc then goto no_tfc
$	   fortran/extend'dbg'	TEXT_FCODE.F
$	   purge		TEXT_FCODE.*
$no_tfc:
$!
$do_link:
$	if .not.lnk then goto exit_neatly
$!
$	ws "Linking..."
$	ws "ARC2I"
$	link'ldbg'	arc2i,-
			arc2i_cld,-
			check_range,close_files,cmdline,create_iff,-
			create_files,find_tab_posn,get_acs,get_arcs,get_cp,-
			get_exp_line,get_filename,get_pts,get_tmp_line,-
			get_txt,get_txtsix,init_tape,next_export,process,-
			rdadt,rdadttab,rdanno,rdnam,rdpar,readblk,rewind_file,-
			text_fcode,arc2i.promsg_obj,-
			lsl$library:frtshr/opt,-
			lsl$library:iffshr/opt,-
			lsl$library:lslshr/opt
$!
$!			lsl$library:ifflib/lib, -
$!			lsl$library:lsllib/lib
$	purge arc2i.*
$!
$exit_neatly:
$	set noverify
$!
