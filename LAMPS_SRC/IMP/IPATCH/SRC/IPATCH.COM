$!
$	set noverify
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$! command file: IPATCH - a command file to build the IPATCH program
$!
$! Copyright (C) Laser-Scan Ltd, Cambridge, England  1986
$!
$! 	Author 					TJ Ibbs, 22 July 1986
$!
$!	Mod1432 Use new frtshr			      JB 23-Nov-1994
$!
$! *************************************************************************
$! move to the appropriate directory
$!
$!	sd lsl$source_root:[imp.ipatch]
$!
$! initialise our question asking mechanism
$!
$	call initq  "IPATCH"  "?"
$	if .not.$status then goto exit_neatly	! exit if error
$!
$! set up some symbols
$!
$	inq = "call askq"
$	wsb = "!"
$ 	if .not.askq_repeat then wsb = "write sys$output """""
$	debug = 0
$!
$! prevent the production of listings during batch processing
$!
$	fortran = "fortran/nolist"
$	macro   = "macro/nolist"
$!
$! *************************************************************************
$! and ask our questions
$!                                                                       
$	wsb	! <<<<<<<<<< output a blank line >>>>>>>>>>
$ 	inq  "compile                                             "
$	comp  = $status
$	if .not.comp then goto ask_link
$!
$	inq  "compile with debug                                  "
$	 debug   = $status
$	wsb	! <<<<<<<<<< output a blank line >>>>>>>>>>
$	if askq_haderror then goto exit_neatly		! check for ^Y,etc
$	inq  "command line definition                             "
$	cld   = $status
$	inq  "messages                                            "
$	msg   = $status
$	inq  "commands                                            "
$	cmd   = $status
$	wsb	! <<<<<<<<<< output a blank line >>>>>>>>>>
$	if askq_haderror then goto exit_neatly		! check for ^Y,etc
$	inq  "main routine    (ipatch)                            "
$	main  = $status
$	inq  "cmdline         (cmdline)                           "
$	cmdl  = $status
$	inq  "report          (status,etc,set_display,help)       "
$	repo  = $status
$	inq  "scan_file       (scan_file)                         "
$	scan  = $status
$	inq  "process         (process,obey)                      "
$	proc  = $status
$	inq  "next            (next_,previous_,this_entry)        "
$	next  = $status
$	inq  "get_feature     (get_feature,binary_chop)           "
$	getf  = $status
$	inq  "find            (find_position,move_to_address)     "
$	find  = $status
$	inq  "filends         (rewind_file,goto_eof,at_bof,eof)   "
$	ends  = $status
$	inq  "mark entry      (mark_entry,goto_mark)              "
$	mark  = $status
$	wsb	! <<<<<<<<<< output a blank line >>>>>>>>>>
$	if askq_haderror then goto exit_neatly		! check for ^Y,etc
$	inq  "print1          (print_entry,ac,cc,cp,cs)           "
$	prt1  = $status
$	inq  "print2          (print_hi,md,mh,nf,no)              "
$	prt2  = $status
$	inq  "print3          (print_ra,ro,ssl,th,vo,xx)          "
$	prt3  = $status
$	inq  "print4          (print_string,cb,text,sh,jb,jp,end) "
$	prt4  = $status
$	inq  "printfs         (print_fs,fs_word2,fs_word3)        "
$	prtf  = $status
$	inq  "printts         (print_ts,ts_word3)                 "
$	prtt  = $status
$	inq  "display entry   (display_entry)                     "
$	disp  = $status
$	wsb	! <<<<<<<<<< output a blank line >>>>>>>>>>
$	if askq_haderror then goto exit_neatly		! check for ^Y,etc
$	inq  "type1           (entry,string,cb,mh,md,hex,ascii)   "
$	typ1  = $status
$	inq  "type2           (type_sh,jb,jp)                     "
$	typ2  = $status
$	inq  "type3           (list_entry)                        "
$	typ3  = $status
$	wsb	! <<<<<<<<<< output a blank line >>>>>>>>>>
$	if askq_haderror then goto exit_neatly		! check for ^Y,etc
$	inq  "read1           (read_entry,ac,cc,cp,cs)            "
$	red1  = $status
$	inq  "read2           (read_fs,ts,md,mh,nf,no,ra)         "
$	red2  = $status
$	inq  "read3           (read_int2,real,string,cb,text)     "
$	red3  = $status
$	wsb	! <<<<<<<<<< output a blank line >>>>>>>>>>
$	if askq_haderror then goto exit_neatly		! check for ^Y,etc
$	inq  "search1         (search_entry,simple,text)          "
$	sea1  = $status
$	inq  "search2         (search_intarg,realar)              "
$	sea2  = $status
$	inq  "search3         (search_fs,ts,ac,no,nf,cs,string,cb)"
$	sea3  = $status
$	inq  "search4         (match_fs_bits)                     "
$	sea4  = $status
$	wsb	! <<<<<<<<<< output a blank line >>>>>>>>>>
$	if askq_haderror then goto exit_neatly		! check for ^Y,etc
$	inq  "delete          (delete_entry,etc,compress_nf)      "
$	dele  = $status
$	wsb	! <<<<<<<<<< output a blank line >>>>>>>>>>
$	inq  "edit1           (edit_entry,nf,fs,ts,ac,no,cs)      "
$	edt1  = $status
$	inq  "edit2           (edit_string,edit_cb,etc.)          "
$	edt2  = $status
$	inq  "edit3           (edit_cc,ra,ro,th,text,mh,ssl)      "
$	edt3  = $status
$	inq  "edit4           (edit_cp,edit_cp_xxx,rotate_cp)     "
$	edt4  = $status
$	wsb	! <<<<<<<<<< output a blank line >>>>>>>>>>
$	if askq_haderror then goto exit_neatly		! check for ^Y,etc
$	inq  "journal/command (open/read/write_journal,command)   "
$	jour  = $status
$	inq  "prompts         (prompt_xxx)                        "
$	prm1  = $status
$	inq  "read values     (read_prompt,wild_xxx)              "
$	prm2  = $status
$	inq  "miscellaneous                                       "
$	misc  = $status
$ask_link:
$	wsb	! <<<<<<<<<< output a blank line >>>>>>>>>>
$	if askq_haderror then goto exit_neatly		! check for ^Y,etc
$	inq  "link                                                "
$	lnk   = $status
$!
$	lbg = ""
$	if .not.lnk then goto no_link_questions
$!
$	inq  "link with debug                                     "
$	lbg   = $status
$!
$no_link_questions:
$	wsb	! <<<<<<<<<< output a blank line >>>>>>>>>>
$	if askq_haderror then goto exit_neatly		! check for ^Y,etc
$!
$! *************************************************************************
$! are we doing it now, or submitting ourselves?
$!
$	call submitq
$	if askq_haderror then goto exit_neatly
$	if .not.$status then goto do_it_now
$	   call exitq				! close the file, etc
$	   submit  ipatch.com			! submit this command file
$	   goto exit_only			! and that's all
$do_it_now:
$!
$! *************************************************************************
$! so obey the commands now - sort out our flags first
$!
$	ldbg= ""
$	dbg = ""
$	pd  = "delete"
$	ver = ";*"
$	if lbg   then ldbg= "/debug"
$	if debug then dbg = "/debug/noopt"
$	if debug then pd  = "purge"
$	if debug then ver = ""
$!
$! *************************************************************************
$!
$	set verify
$	if .not.comp then goto do_link
$	if .not.cld  then goto no_cld
$	   adc   ipatch.TMP=ipatch.CLD
$	   set command/object=ipatch_cld  ipatch.TMP
$	   pvv   ipatch_cld
$	   purge ipatch_cld.OBJ
$	   delete ADC.IDE;*
$	   delete ipatch.TMP;*
$no_cld:
$	if .not.msg  then goto no_msg
$	   newmsg ipatch/number=1210
$	   @ipatch.temp_com
$no_msg:
$	if .not.cmd  then goto no_cmd
$	   macro  ipatch.mar/object=ipatch_cmd
$	   purge  ipatch_cmd.obj
$no_cmd:
$	if .not.main then goto nomain                  
$	   adc  ipatch/co = IPATCH
$	   fortran/extend'dbg' ipatch
$	   pvv   ipatch
$	   purge ipatch.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' ipatch.FOR'ver'
$nomain:
$	if .not.cmdl then goto nocmdl
$	   adc  cmdline/co = CMDLINE
$	   fortran/extend'dbg' cmdline
$	   pvv   cmdline
$	   purge cmdline.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' cmdline.FOR'ver'
$nocmdl:
$	if .not.repo then goto norepo
$	   adc  report/co = SHOW,SET_DISPLAY,STATUS,HELP
$	   adc  report/co/ap = STATUS_ON,STATUS_OFF,NEW_STATUS,SETUP_SCREEN
$	   adc  report/co/ap = AUTO_STATUS,IS_TERM_ANSI
$	   fortran/extend'dbg' report
$	   pvv   report
$	   purge report.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' report.FOR'ver'
$	   macro binout
$	   purge binout.OBJ
$norepo:
$	if .not.scan then goto noscan
$	   adc  scan_file/co = SCAN_FILE
$	   fortran/extend'dbg' scan_file
$	   pvv   scan_file
$	   purge scan_file.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' scan_file.FOR'ver'
$noscan:
$	if .not.proc then goto noproc
$	   adc  process/co = PROCESS,OBEY
$	   fortran/extend'dbg' process
$	   pvv   process
$	   purge process.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' process.FOR'ver'
$noproc:
$	if .not.next then goto nonext
$	   adc  next/co = PRINT_NEXT_ENTRY,NEXT_ENTRY,PREVIOUS_ENTRY,THIS_ENTRY
$	   fortran/extend'dbg' next
$	   pvv   next
$	   purge next.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' next.FOR'ver'
$nonext:
$	if .not.getf then goto nogetf
$	   adc  get_feature/co = GET_FEATURE,BINARY_CHOP
$	   fortran/extend'dbg' get_feature
$	   pvv   get_feature
$	   purge get_feature.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' get_feature.FOR'ver'
$nogetf:
$	if .not.find then goto nofind
$	   adc  find/co = FIND_POSITION,MOVE_TO_ADDRESS
$	   fortran/extend'dbg' find
$	   pvv   find
$	   purge find.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' find.FOR'ver'
$nofind:
$	if .not.ends then goto noends
$	   adc  filends/co = REWIND_FILE,GOTO_EOF,AT_BOF,AT_EOF
$	   fortran/extend'dbg' filends
$	   pvv   filends
$	   purge filends.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' filends.FOR'ver'
$noends:
$	if .not.mark then goto nomark
$	   adc  mark/co = MARK_ENTRY,GOTO_MARK
$	   fortran/extend'dbg' mark
$	   pvv   mark
$	   purge mark.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' mark.FOR'ver'
$nomark:
$	if .not.prt1 then goto noprt1
$	   adc   print1/co = PRINT_ENTRY,PRINT_AC,PRINT_CC,PRINT_CP,PRINT_CS
$	   fortran/extend'dbg' print1
$	   pvv   print1
$	   purge print1.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' print1.FOR'ver'
$noprt1:
$	if .not.prt2 then goto noprt2
$	   adc   print2/co = PRINT_HI,PRINT_MD,PRINT_MH,PRINT_NF,PRINT_NO
$	   fortran/extend'dbg' print2
$	   pvv   print2
$	   purge print2.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' print2.FOR'ver'
$noprt2:
$	if .not.prt3 then goto noprt3
$	   adc   print3/co = PRINT_RA,PRINT_RO,PRINT_SSL
$	   adc   print3/co/ap = PRINT_TH,PRINT_VO,PRINT_XX
$      	   fortran/extend'dbg' print3
$	   pvv   print3
$	   purge print3.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' print3.FOR'ver'
$noprt3:
$	if .not.prt4 then goto noprt4
$	   adc   print4/co = PRINT_STRING,PRINT_CB,PRINT_TEXT,PRINT_ENDING
$	   adc   print4/co/ap = PRINT_SH,PRINT_JB,PRINT_JP
$	   fortran/extend'dbg' print4
$	   pvv   print4
$	   purge print4.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' print4.FOR'ver'
$noprt4:
$	if .not.prtf then goto noprtf
$	   adc   printfs/co = PRINT_FS,PRINT_FS_WORD2,PRINT_FS_WORD3
$	   fortran/extend'dbg' printfs
$	   pvv   printfs
$	   purge printfs.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' printfs.FOR'ver'
$noprtf:
$	if .not.prtt then goto noprtt
$	   adc   printts/co = PRINT_TS,PRINT_TS_WORD3
$	   fortran/extend'dbg' printts
$	   pvv   printts
$	   purge printts.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' printts.FOR'ver'
$noprtt:
$	if .not.disp then goto nodisp
$	   adc   display/co = DISPLAY_ENTRY
$	   fortran/extend'dbg' display
$	   pvv   display
$	   purge display.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' display.FOR'ver'
$nodisp:
$	if .not.typ1 then goto notyp1
$	   adc   type/co = TYPE_NEXT_ENTRY
$	   adc   type/co/ap = TYPE_ENTRY,TYPE_STRING,TYPE_CB,TYPE_MH,TYPE_MD,TYPE_HEX,TYPE_ASCII
$	   fortran/extend'dbg' type
$	   pvv   type
$	   purge type.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' type.FOR'ver'
$notyp1:
$	if .not.typ2 then goto notyp2
$	   adc   type2/co = TYPE_SH,TYPE_JB,TYPE_JP
$	   fortran/extend'dbg' type2
$	   pvv   type2
$	   purge type2.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' type2.FOR'ver'
$notyp2:
$	if .not.typ3 then goto notyp3
$	   adc   type3/co = LIST_ENTRY
$	   fortran/extend'dbg' type3
$	   pvv   type3
$	   purge type3.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' type3.FOR'ver'
$notyp3:
$	if .not.red1 then goto nored1
$	   adc   read1/co = READ_ENTRY,READ_AC,READ_CC,READ_CP,READ_CS
$	   fortran/extend'dbg' read1
$	   pvv   read1
$	   purge read1.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' read1.FOR'ver'
$nored1:
$	if .not.red2 then goto nored2
$	   adc   read2/co = READ_FS,READ_TS,READ_MD,READ_MH
$	   adc   read2/co/ap = READ_NF,READ_NO,READ_RA
$	   fortran/extend'dbg' read2
$	   pvv   read2
$	   purge read2.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' read2.FOR'ver'
$nored2:
$	if .not.red3 then goto nored3
$	   adc   read3/co = READ_INT2,READ_REAL,READ_STRING,READ_CB,READ_TEXT
$	   fortran/extend'dbg' read3
$	   pvv   read3
$	   purge read3.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' read3.FOR'ver'
$nored3:
$	if .not.sea1 then goto nosea1
$	   adc   search1/co = SEARCH_ENTRY,SEARCH_SIMPLE,SEARCH_TEXT
$	   fortran/extend'dbg' search1
$	   pvv   search1
$	   purge search1.OBJ
$	   delete ADC.IDE;*    
$ 	   'pd' search1.FOR'ver'
$nosea1:
$	if .not.sea2 then goto nosea2
$	   adc   search2/co = SEARCH_INTARG,SEARCH_REALAR
$	   fortran/extend'dbg' search2
$	   pvv   search2
$	   purge search2.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' search2.FOR'ver'
$nosea2:
$	if .not.sea3 then goto nosea3
$	   adc   search3/co = SEARCH_FS,SEARCH_TS,SEARCH_AC,SEARCH_NO,SEARCH_NF
$	   adc   search3/co/ap = SEARCH_CS,SEARCH_STRING,SEARCH_CB
$	   fortran/extend'dbg' search3
$	   pvv   search3
$	   purge search3.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' search3.FOR'ver'
$nosea3:
$	if .not.sea4 then goto nosea4      
$	   adc   search4/co = MATCH_FS_BITS
$	   fortran/extend'dbg' search4
$	   pvv   search4
$	   purge search4.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' search4.FOR'ver'
$nosea4:
$	if .not.dele then goto nodele
$      	   adc   delete/co = DELETE_ENTRY,DELETE_SINGLE,DELETE_MARK,COMPRESS_NF
$	   fortran/extend'dbg' delete
$	   pvv   delete
$	   purge delete.OBJ                                               
$	   delete ADC.IDE;*
$ 	   'pd' delete.FOR'ver'
$nodele:
$	if .not.edt1 then goto noedt1
$	   adc   edit1/co = EDIT_ENTRY,EDIT_NF,EDIT_NF_CMD,EDIT_NO,EDIT_NO_CMD
$	   adc   edit1/co/ap = EDIT_FS,EDIT_FS_CMD,EDIT_TS,EDIT_TS_CMD
$	   adc   edit1/co/ap = EDIT_AC,EDIT_AC_CMD,EDIT_CS
$	   fortran/extend'dbg' edit1
$	   pvv   edit1
$	   purge edit1.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' edit1.FOR'ver'
$noedt1:
$	if .not.edt2 then goto noedt2
$	   adc   edit2/co = EDIT_STRING,REPLACE_STRING
$	   adc   edit2/co/ap = EDIT_ST_CHANGE,EDIT_ST_DELETE
$	   adc   edit2/co/ap = EDIT_CB,EDIT_CB_CHANGE,EDIT_CB_ATT
$	   fortran/extend'dbg' edit2
$	   pvv   edit2
$	   purge edit2.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' edit2.FOR'ver'
$noedt2:
$	if .not.edt3 then goto noedt3
$	   adc   edit3/co = EDIT_CC,EDIT_CC_CMD,EDIT_RA,EDIT_RA_CMD
$	   adc   edit3/co/ap = EDIT_RO,EDIT_RO_CMD,EDIT_TH,EDIT_TH_CMD
$	   adc   edit3/co/ap = EDIT_TEXT,EDIT_TEXT_CMD,EDIT_MH,EDIT_SSL
$	   fortran/extend'dbg' edit3
$	   pvv   edit3
$	   purge edit3.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' edit3.FOR'ver'
$noedt3:
$	if .not.edt4 then goto noedt4
$	   adc   edit4/co = EDIT_CP,EDIT_CP_TARGET,EDIT_CP_BOTH
$	   adc   edit4/co/ap = EDIT_CP_ROTATE,EDIT_CP_REPEAT,ROTATE_CP
$	   fortran/extend'dbg' edit4
$	   pvv   edit4
$	   purge edit4.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' edit4.FOR'ver'
$noedt4:
$	if .not.jour then goto nojour
$	   adc   journal/co = OPEN_JOURNAL,WRITE_JOURNAL
$	   adc   journal/co/ap = OPEN_COMMAND,READ_COMMAND
$	   fortran/extend'dbg' journal
$	   pvv   journal
$	   purge journal.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' journal.FOR'ver'
$nojour:
$	if .not.prm1 then goto noprm1
$	   adc   prompt1/co = PROMPT_INT2,PROMPT_INT4
$	   adc   prompt1/co/ap = PROMPT_HEX2,PROMPT_HEX4,PROMPT_REAL
$      	   adc   prompt1/co/ap = PROMPT_TEXT,PROMPT_STRING,PROMPT_CP
$      	   adc   prompt1/co/ap = PROMPT_CB
$	   fortran/extend'dbg' prompt1
$	   pvv   prompt1
$	   purge prompt1.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' prompt1.FOR'ver'
$noprm1:
$	if .not.prm2 then goto noprm2
$	   adc   prompt2/co = READ_PROMPT
$	   adc   prompt2/co/ap = READ_WILD_INT2,READ_WILD_INT4
$	   adc   prompt2/co/ap = READ_WILD_HEX2,READ_WILD_HEX4,READ_WILD_REAL
$	   adc   prompt2/co/ap = READ_WILD_ACTYPE,READ_WILD_ACVAL
$	   fortran/extend'dbg' prompt2
$	   pvv   prompt2
$	   purge prompt2.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' prompt2.FOR'ver'
$noprm2:                 
$	if .not.misc then goto nomisc
$	   adc   misc/co = SUB_STRING,COPY_STRING,CONVERT,CHECK_EOL
$	   adc   misc/co/ap = TOO_MANY_ENTRIES,CHECK_ACD_RANGE
$	   fortran/extend'dbg' misc
$	   pvv   misc
$	   purge misc.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' misc.FOR'ver'
$nomisc:
$do_link:
$	if .not.lnk then goto exit_neatly
$!
$	adc   blkdat/co = LSL$CMNIFF:MD2DAT
$	fortran/extend  blkdat
$	pvv   blkdat
$	purge blkdat.obj
$	delete ADC.IDE;*
$	'pd' blkdat.FOR'ver'
$!
$	link/map'ldbg'	ipatch,blkdat,cmdline, -
			report,binout, -
			scan_file,process,next,get_feature, -
			find,filends,mark, -
	   	       	print1,print2,print3,print4,printfs,printts, -
			display,type,type2,type3, -
			read1,read2,read3, -
       		      	search1,search2,search3,search4, -
			delete, -
		     	edit1,edit2,edit3,edit4, -
			journal,prompt1,prompt2, -
			misc, -
			ipatch_cld, -
			ipatch_cmd, -
			ipatch.promsg_obj, -
			lsl$library:frtshr/opt, -
			lsl$library:iffshr/opt, -
			lsl$library:lslshr/opt
$   	purge ipatch.*
$!
$exit_neatly:	set noverify
$		call exitq
$exit_only:	exit
$!
$! *************************************************************************
$! -------------------------------------------------------------------------
$! INITQ  P1  P2  P3
$!
$! initialise the ASKQ subroutine environment
$! - opens 'P1'.BATCH appropriately
$! - sets the ASKQ environment up
$! - sets a group logical called 'P1'_IS_BUILDING
$! (note that if 'P1'_IS_BUILDING already exits, then it exits with error)
$!
$!	P1	- required, name to be used for the .BATCH command file
$!
$!	P2	- optional, Y => repeat previous answers
$!			    N => get new answers
$!			    ? => ask for Y/N
$!		       absent => as for N
$!
$!	P3	- optional, extra switches to use on INQUIREs, eg "/NOPUNCT"
$! -------------------------------------------------------------------------
$initq:	SUBROUTINE
$!
$! we have not had control-Y, nor have we opened the file
$!
$	askq_haderror    == 0
$	askq_opened_file == 0
$!
$! is there anything extra to add as a switch to our INQUIREs?
$!
$	askq_inqsw :== "''P3'"
$!
$! and what is our name?
$!
$	askq_logical_name == "''P1'_IS_BUILDING"
$!
$! is anyone already trying to use the .BATCH file?
$!
$	if f$trnlnm(askq_logical_name).eqs."" then goto initq_not_building
$	   write sys$output ""
$	   write sys$output "*** Someone else is building ''P1' ***"
$	   write sys$output ""
$	   goto initq_error_exit
$!
$initq_not_building:
$	   define/group  'askq_logical_name'  TRUE
$!
$! determine whether we are writing the .BATCH file, or reading from it
$! - if we are not interactive, then we must read from it
$! - if our argument is present and true, then we must read from it
$! - if our argument is present and "?", then we must ask the user - but
$!   obviously only if we're not in batch mode
$! - otherwise we must write it
$!
$	askq_batch = f$mode().nes."INTERACTIVE"
$!
$	if .not.askq_batch.and.P2.eqs."?" then -
	inquire/nopunct P2 "Use the last set of answers again ? "
$!
$	if P2.eqs.""  then P2 = "N"
$!
$	askq_repeat == askq_batch .or. P2
$!
$! and work out the filename (without a version number)
$!
$	askq_file1 = f$parse("HERE:''P1'.BATCH")
$	askq_file2 = f$parse(askq_file1,,,"VERSION")
$!
$	askq_filename == askq_file1 - askq_file2
$!
$! and open it appropriately
$!
$ 	if askq_repeat then goto initq_setrepeat
$	   open/write askq_file 'askq_filename
$	   askq_opened_file == 1
$	   goto end_initq
$!
$initq_setrepeat:
$	   askq_gotfile = f$search(askq_filename)
$	   if askq_gotfile.eqs."" then goto initq_notgotfile
$	      open/read askq_file 'askq_filename
$	      askq_opened_file == 1
$	      goto end_initq
$!
$initq_notgotfile:
$	   write sys$output ""
$	   write sys$output "*** Cannot find ''askq_filename' ***"
$	   write sys$output ""
$!
$initq_error_exit:
$	   askq_haderror == 1		! fake an error
$	   exit %x10000000		! and exit with an error
$!
$end_initq:
$	exit %x10000001			! exit with success
$	ENDSUBROUTINE			! initq
$!
$! -------------------------------------------------------------------------
$! ASKQ  P1
$!
$! 1) ask the user a question, record the answer in our .BATCH file
$! 2) get the appropriate answer from our .BATCH file
$!
$!	P1	- the prompt string
$!
$! returns $STATUS as true if the answer was YES, and as false if the
$! answer was NO (using normal INQUIRE conventions)
$! -------------------------------------------------------------------------
$askq:	SUBROUTINE
$!
$	if askq_haderror then exit %x10000000	! bluff NO
$	on control_y then goto askq_had_controly
$!
$	if askq_repeat then goto askq_repeat_question
$!
$	   inquire'askq_inqsw'  askq_answ  "''P1'"	! ask the question
$	   write askq_file askq_answ			! write it to the file
$ 	   goto end_askq
$!
$askq_repeat_question:
$	   read/end=askq_repeat_eof askq_file askq_answ	! get answer from file
$	   goto end_askq
$!
$askq_repeat_eof:
$	   askq_answ = "N"		! if eof found, assume NO
$	   goto end_askq
$!
$askq_had_controly:
$	   askq_haderror == 1
$	   exit
$!
$end_askq:
$	if      askq_answ then exit %x10000001		! YES
$	if .not.askq_answ then exit %x10000000		! NO
$	ENDSUBROUTINE	! askq
$!
$! -------------------------------------------------------------------------
$! SUBMITQ
$!
$! If we are repeating the previous answers, then returns $STATUS as false,
$! otherwise asks the user whether to submit for batch. If they answer Yes,
$! then returns $STATUS as true, otherwise as false. The intention is that
$! if the return is false, then the compiling, linking, etc should be done,
$! and if the answer is true, then the calling command file should submit
$! ITSELF to batch...
$! -------------------------------------------------------------------------
$submitq:	SUBROUTINE
$!
$	if .not.askq_repeat then goto askq_ask_submit
$	   askq_notnow = 0				! we want to do it
$	   goto end_submitq
$!
$askq_ask_submit:
$	inquire/nopunct askq_notnow "Submit for batch ? "
$!
$end_submitq:
$	if      askq_notnow then exit %x10000001	! don't do it now
$	if .not.askq_notnow then exit %x10000000	! do it now
$      	ENDSUBROUTINE	! submitq
$!
$! -------------------------------------------------------------------------
$! EXITQ
$!
$! Called to close the .BATCH file (and purge it), and to lose the various
$! symbols that ASKQ uses. This routine should ALWAYS be called to tidy up,
$! and should be called BEFORE the calling command file is submitted, so
$! that there is no conflict of ownership for the .BATCH file, nor on the
$! logical name that stops someone else playing with it
$! -------------------------------------------------------------------------
$exitq:	SUBROUTINE
$	if askq_opened_file then close askq_file
$	if askq_opened_file then purge 'askq_filename
$	deassign/group 'askq_logical_name
$	delete/symbol/global askq_haderror
$	delete/symbol/global askq_opened_file
$	delete/symbol/global askq_filename
$	delete/symbol/global askq_logical_name
$	delete/symbol/global askq_repeat
$	delete/symbol/global askq_inqsw
$	exit
$	ENDSUBROUTINE	! exitq
$!
