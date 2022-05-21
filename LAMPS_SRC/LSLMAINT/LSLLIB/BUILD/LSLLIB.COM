$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-10-14 17:11:42.000000000 +0100
$! *
$! * This program is free software: you can redistribute it and/or modify
$! * it under the terms of the GNU General Public License as published by
$! * the Free Software Foundation, version 3.
$! *
$! * This program is distributed in the hope that it will be useful, but
$! * WITHOUT ANY WARRANTY; without even the implied warranty of
$! * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
$! * General Public License for more details.
$! *
$! * You should have received a copy of the GNU General Public License
$! * along with this program. If not, see http://www.gnu.org/licenses/.
$!
$	set noverify
$	goto start_doing_things
$!
$! command file: LSLLIB - command file to create or update the LSL
$!			  standard I/O library
$!
$! Copyright (C) LaserScan Laboratories Ltd, Cambridge, England  1986
$!
$! Completed		TJH/RJH, 29-Jan-1986
$! Author 		TJ Ibbs,    Sep-1985
$!
$! *************************************************************************
$!
$!		"TEMPORARY" VERSION FOR ADC BUG !!!!
$! -------------------------------------------------------------------------
$!MOD	14 Oct 1993	Clarke Brunt	WI/CC 1305
$!	- for CMS, make work in specific version directory
$! -------------------------------------------------------------------------
$!MOD	25 Aug 1988	Ron Russell
$!	- new routine LSL_COUNT_CMD_BYTES added
$! -------------------------------------------------------------------------
$!MOD	25 Aug 1988	Ron Russell
$!	- new routines READANG added to "numbers" and DISPANG added to
$!        "expc"
$! -------------------------------------------------------------------------
$!MOD	Jul 1988	Clarke Brunt
$!	- general amendments to cope with new disk organisations
$!	  (renames don't work, etc)
$! -------------------------------------------------------------------------
$!MOD	10 Dec 1987	Tony J Ibbs
$!	- use the new NEWMSG to generate messages
$!	- LSLLIBMSG parameter files get renamed to LSL$CMNLSL:
$!	- do all of the compiling, etc, in a working directory
$!	  (ie in [LSLMAINT.LSLLIB.WORK])
$!	- remove mods from pre-1987
$! -------------------------------------------------------------------------
$!MOD	20 Nov 1987	Jamie Hulme
$!	- new routines CVT_DMY_DAY.SRC, CVT_DAY_DMY.SRC
$! -------------------------------------------------------------------------
$!MOD	19 Oct 1987	Ron Russell
$!	- new routines CVT_DATE.SRC, CVT_DAY_STR.SRC, CVT_TIME_STR
$! -------------------------------------------------------------------------
$!MOD	11 Oct 1987	Ron Russell
$!	- new routine SIGCHS
$! -------------------------------------------------------------------------
$!MOD2/516	11 Oct 1987	Ron Russell
$!	- new routine FIND_CMDNAME
$! -------------------------------------------------------------------------
$!MOD	10 Sep 1987	Clarke Brunt
$!	- macro RDCH to replace RDCH,RDCHS,RDAUXC.SRC
$!	- new routine REMCMD
$! -------------------------------------------------------------------------
$!MOD	 7 Jul 1987	Clarke Brunt
$!	- new routine SET_OUTBAND_AST added to SYSTEM routines
$! -------------------------------------------------------------------------
$!MOD	09-Jun-1987	Tim Hartnall
$!	- TRNALL added to system routines
$! -------------------------------------------------------------------------
$!MOD	16 Apr 1987	Tim Hartnall
$!	- new routines LOG_OPEN and LCM_OPEN added to DCL routines
$! -------------------------------------------------------------------------
$!MOD	15 Apr 1987	Tim Hartnall
$!	- new routines START_LOG and START_LCM added to DCL routines
$! -------------------------------------------------------------------------
$!MOD	23 Mar 1987	Tony J Ibbs
$!	- the library is now in LSL$SOURCE_ROOT:[LSLMAINT.LSLLIB...],
$!	  so change things appropriately
$! -------------------------------------------------------------------------
$!MOD	16 Mar 1987	Tony J Ibbs
$!	- place the question about generating messages befoe the others,
$!	  so that the questions are actually in the order they'll be used in
$! -------------------------------------------------------------------------
$!MOD	16 Mar 1987	Tony J Ibbs	mod 2/429
$!	- new routines SAVE_EXPMAX and SAVE_TXTLIM added to EXPC and TXTC
$!	- add the FM argument to NEWMESSAGE
$! -------------------------------------------------------------------------
$!              MODS FROM 1986 AND EARLIER NOW REMOVED
$! -------------------------------------------------------------------------
$! *************************************************************************
$!
$start_doing_things:
$!
$! remember where we have come from
$!
$	define  start_directory  'f$trnlnm("HERE")
$!
$	on control_y then goto tidy_exit
$	on error     then goto tidy_exit
$!
$	ws	= "write sys$output"
$	wsb	= "write sys$output """""
$	inq	= "inquire"
$getver:if p1.eqs.""
$	then
$	  inq p1 "Which LSLLIB version directory are you using "
$	  goto getver
$	endif
$!
$! *************************************************************************
$!
$	   type sys$input:

	The old LSLLIB will be copied to a working directory, and modifications
	made to that. When complete, the new version is renamed into
	LSL$SOURCE_ROOT:[LSLMAINT.LSLLIB.'version'.TEST]LSLLIB.OLB for testing,
	or publication.
	If you answer YES to "Is this a texting version ?", then the old
	LSLLIB will be taken from the [.TEST] directory, otherwise it
	will be taken from LSL$LIBRARY:.

$	inq testing_version "Is this a testing version "
$!
$! we need to specify where to get the old library from
$!
$! - if testing library, then it will come from [LSLMAINT.LSLLIB.'version'.TEST]
$! - if it is the 'real' library, then it will come from LSL$LIBRARY itself
$!
$	define  lsllib_destination  lsl$source_root:[lslmaint.lsllib.'p1'.test]
$	if   testing_version -
	then define  lsllib_source  lsl$source_root:[lslmaint.lsllib.'p1'.test]
$	if   .not.testing_version -
	then define  lsllib_source  lsl$library:
$!
$! and ensure that we are in the correct directory
$! for doing all of our work
$!
$	wsb
$	sd  lsl$source_root:[lslmaint.lsllib.'p1'.work]
$!
$! *************************************************************************
$! now, find out what we are meant to be doing...
$!
$	wsb
$	inq	new_library	"Make a new library     "
$	inq	with_debug	"With debug             "
$!
$! *************************************************************************
$! sort out subsidiary variables
$!
$	not_all = .not.new_library
$	if with_debug then goto set_debug
$	   fdb     = ""
$	   mdb     = ""
$	   adcco   = ""
$	   cleanup = "delete"
$	   ver     = ";*"
$	   goto end_debug
$!
$set_debug:
$	   fdb     = "/debug/noopt/check=all"
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
$! first initialise the logicals
$!
$	   do_message	= 0
$	   do_lsldcl	= 0
$	   do_init	= 0
$	   do_expc	= 0
$	   do_txtc	= 0
$	   do_filename	= 0
$	   do_string	= 0
$	   do_numbers	= 0
$	   do_commands	= 0
$	   do_errors	= 0
$	   do_io	= 0
$	   do_magtape	= 0
$	   do_iff	= 0
$	   do_system	= 0
$	   do_sort	= 0
$!
$! now do the action
$!
$	if .not.new_library then goto ask_what_to_replace
$!
$	   type sys$input:

	A new library called LSLLIB_TMP will be created,
	and renamed to LSLLIB in the [.TEST] directory
	when it has been completed.

$!
$	   library/create  lsllib_tmp
$	   libr = "library/insert/log  lsllib_tmp"
$	   goto compilation
$!
$! *************************************************************************
$ask_what_to_replace:
$	   type sys$input:

	LSLLIB will be copied to LSLLIB_TMP and the replacements
	made in that. It will be renamed to LSLLIB in the [.TEST]
	directory when completed.

$!
$	   copy/log lsllib_source:lsllib.olb  here:lsllib_tmp
$	   libr = "library/replace/log  lsllib_tmp"
$!
$	wsb
$	ws "What to replace -"
$	wsb
$	inq	do_message	"MESSAGE  - message files     "
$	wsb
$	inq	do_lsldcl	"LSLDCL   - DCL commands      "
$	inq	do_init		"INIT     - initialisation    "
$	inq	do_expc		"EXPC     - output buffer     "
$	inq	do_txtc		"TXTC     - input buffer      "
$	inq	do_filename	"FILENAME - filename reading  "
$	inq	do_string	"STRING   - string reading    "
$	inq	do_numbers	"NUMBERS  - number reading    "
$	inq	do_commands	"COMMANDS - command decoding  "
$	inq	do_errors	"ERRORS   - error reporting   "
$	inq	do_io		"IO       - input/output      "
$	inq	do_magtape	"MAGTAPE  - magnetic tape     "
$	inq	do_iff		"IFF      - IFF open routines "
$	inq	do_system	"SYSTEM   - system interface  "
$	inq	do_sort		"SORT     - sort routines     "
$	wsb
$!
$! *************************************************************************
$! now do the actual work...
$!
$compilation:	set verify
$!..........................................................................
$	if not_all .and. .not.do_message  then goto no_message
$	   newmsg lsl$cmnlsl:lsllib.mes /number=1025    -
					/prefix=LSL__   -
					/param=(F,M,C)
$	   @lsllib.temp_com
$	   if .not.$status then goto tidy_exit
$!
$	   libr		lsllib.promsg_obj
$	   delete	lsllib.promsg_obj;*
$	   set noverify
$	   type sys$input:

	New message header files (lsllibmsg.*) have been created
	in the [.WORK] directory.
	If they have changed, you may want to publish them to LSL$CMNLSL:

$	   set verify
$!
$no_message:
$!..........................................................................
$	if not_all .and. .not.do_lsldcl   then goto no_lsldcl
$	   from = "lsl$source_root:[lslmaint.lsllib.''p1'.lsldcl]"
$	   adc		dclfor'adcco'='from'dcl_erret,dcl_comma,dcl_str
$	   adc		dclfor/ap'adcco'='from'dcl_startup,dcl_qual,dcl_int
$	   adc		dclfor/ap'adcco'='from'dcl_cml,dcl_real,dcl_dbl
$	   adc		dclfor/ap'adcco'='from'dcl_file,dcl_parse,dcl_sign
$	   adc		dclfor/ap'adcco'='from'start_log,start_lcm,prep_info
$	   adc		dclfor/ap'adcco'='from'lcm_open,log_open
$	   fortran'fdb'	dclfor
$	   pvv		dclfor
$	   libr		dclfor
$	   delete	dclfor*.obj;*,adc.ide;*
$	   cleanup	dclfor.for'ver'				 
$no_lsldcl:
$!..........................................................................
$	if not_all .and. .not.do_init     then goto no_init
$	   from = "lsl$source_root:[lslmaint.lsllib.''p1'.init]"
$	   adc		initfor'adcco'='from'lsl_init,lsl_exit,check_init
$	   fortran'fdb'	initfor
$	   pvv		initfor
$	   libr		initfor
$	   delete	init*.obj;*,adc.ide;*
$	   cleanup	initfor.for'ver'
$no_init:
$!..........................................................................
$	if not_all .and. .not.do_expc     then goto no_expc
$	   from = "lsl$source_root:[lslmaint.lsllib.''p1'.expc]"
$	   macro'mdb'	lsl$cmnlsl:expc+'from'expand/object=expcmar
$	   adc		expcfor'adcco'='from'restore_expc,save_expc,set_expmax
$	   adc		expcfor/ap'adcco'='from'save_expmax,dispang
$	   fortran'fdb'	expcfor
$	   pvv		expcfor
$	   libr		expcmar,expcfor
$	   delete	expc*.obj;*,adc.ide;*
$	   cleanup	expcfor.for'ver'
$no_expc:
$!..........................................................................
$	if not_all .and. .not.do_txtc     then goto no_txtc
$	   from = "lsl$source_root:[lslmaint.lsllib.''p1'.txtc]"
$	   macro'mdb'	lsl$cmnlsl:txtc+windef+'from'rdch/object=txtcmar
$	   adc		txtcfor'adcco'='from'bsch,bsln,dcpsav,dcpset
$	   adc		txtcfor/ap'adcco'='from'restore_txtc
$	   adc		txtcfor/ap'adcco'='from'save_txtc,set_txtlim,setaux
$	   adc		txtcfor/ap'adcco'='from'setwin,save_txtlim
$	   fortran'fdb'	txtcfor
$	   pvv		txtcfor
$	   libr		txtcfor,txtcmar
$	   delete	txtc*.obj;*,adc.ide;*
$	   cleanup	txtcfor.for'ver'
$no_txtc:
$!..........................................................................
$	if not_all .and. .not.do_filename then goto no_filename
$	   from = "lsl$source_root:[lslmaint.lsllib.''p1'.filename]
$	   macro'mdb'	lsl$cmnlsl:expc+'from'file_parse/object=filemar
$	   adc		filefor'adcco'='from'expfln,getfilnam,parfiln,putfln
$	   fortran'fdb'	filefor
$	   pvv		filefor
$	   libr		filemar,filefor
$	   delete	file*.obj;*,adc.ide;*
$	   cleanup	filefor.for'ver'
$no_filename:
$!..........................................................................
$	if not_all .and. .not.do_string   then goto no_string
$	   from = "lsl$source_root:[lslmaint.lsllib.''p1'.string]"
$	   adc		strfor'adcco'='from'rdyes,readstr,sigchs
$	   fortran'fdb'	strfor
$	   pvv		strfor
$	   libr		strfor
$	   delete	str*.obj;*,adc.ide;*
$	   cleanup	strfor.for'ver'
$no_string:
$!..........................................................................
$	if not_all .and. .not.do_numbers  then goto no_numbers
$	   from = "lsl$source_root:[lslmaint.lsllib.''p1'.numbers]"
$	   adc		numfor'adcco'='from'lsl_rddble_cmpt,lsl_rddble_whole
$	   adc		numfor/ap'adcco'='from'lsl_rdnum_ab,lsl_rdreal_whole
$	   adc		numfor/ap'adcco'='from'lsl_rdsign,rddble,rdhex,rdint
$	   adc		numfor/ap'adcco'='from'rdlhex,rdloct,rdlong,rdnum,rdoct
$	   adc		numfor/ap'adcco'='from'rdreal,readang
$	   fortran'fdb'	numfor
$	   pvv		numfor
$	   libr		numfor
$	   delete	num*.obj;*,adc.ide;*
$	   cleanup	numfor.for'ver'
$no_numbers:
$!..........................................................................
$	if not_all .and. .not.do_commands then goto no_commands
$	   from = "lsl$source_root:[lslmaint.lsllib.''p1'.commands]"
$	   macro'mdb'	lsl$cmnlsl:cmdcom+'from'lsl_find_cmd/obj=cmdmar,-
			'from'lsl_inequal/obj=tmp1,-
			'from'lsl_sortab/obj=tmp2
$	   append	tmp1.obj,tmp2.obj cmdmar.obj
$ copy -
'from'addnam.src,argspc,cmdprt,initab,-
lsl_count_cmd_bytes,-
lsl_copy_cmd_bytes,-
lsl_copy_table_longs,-
lsl_copy_table_words,-
rdcomm,remcmd,savtab,seltab,find_cmdname,rdineq,-
lsl_cmderr			temp.src
$ adc			cmdfor'adcco'=temp
$	   fortran'fdb'	cmdfor
$	   pvv		cmdfor
$	   libr		cmdmar,cmdfor
$	   delete	cmd*.obj;*,tmp*.obj;*,adc.ide;*
$	   cleanup	cmdfor.for'ver'
$ delete temp.src;*
$no_commands:
$!..........................................................................
$	if not_all .and. .not.do_errors   then goto no_errors
$	   from = "lsl$source_root:[lslmaint.lsllib.''p1'.errors]"
$ 	   macro'mdb' 	lsl$cmnlsl:lsllibmsg+status+expc+ -
				'from'lsl_signal/obj=lsl_err 
$ 	   macro'mdb' 	lsl$cmnlsl:lsllibmsg+status+expc+ -
				'from'lsl_putmsg/obj=tmp1
$ 	   macro'mdb' 	lsl$cmnlsl:lsllibmsg+txtc+ -
				'from'lsl_addxxx/obj=tmp2
$ 	   macro'mdb' 	lsl$cmnlsl:lsllibmsg+ -
			      	'from'lsl_getformat/obj=tmp3
$ 	   macro'mdb' 	lsl$cmnlsl:lsllibmsg+ -
				'from'lsl_getmsg/obj=tmp4
$ 	   macro'mdb' 	lsl$cmnlsl:lsllibmsg+txtc+ -
				'from'mark_posn/obj=tmp5
$ 	   append tmp1.obj,tmp2,tmp3,tmp4,tmp5 lsl_err.obj
$	   libr		lsl_err
$	   delete	tmp*.obj;*,lsl_err.obj;*
$no_errors:
$!..........................................................................
$	if not_all .and. .not.do_io       then goto no_io
$	   from = "lsl$source_root:[lslmaint.lsllib.''p1'.io]"
$	   macro'mdb'	lsl$cmnlsl:lsllibmsg+txtc+expc+'from'fileio/obj=iomar,-
			'from'vio$get_input/obj=tmp1,-
			'from'vio$put_output/obj=tmp2,-
			lsl$cmnlsl:lsllibmsg+txtc+'from'viottr/obj=tmp3,-
			lsl$cmnlsl:lsllibmsg+expc+'from'viottw/obj=tmp4,-
			'from'writef/object=tmp5
$	   append	tmp1.obj,tmp2.obj,tmp3.obj,tmp4.obj,tmp5.obj iomar.obj
$	   libr		iomar
$	   delete	io*.obj;*,tmp*.obj;*
$no_io:
$!..........................................................................
$	if not_all .and. .not.do_magtape  then goto no_magtape
$	   from = "lsl$source_root:[lslmaint.lsllib.''p1'.magtape]"
$	   macro'mdb'	lsl$cmnlsl:mtivcm+'from'mtiv/object=magimar
$	   macro'mdb'	lsl$cmnlsl:mtovcm+'from'mtov/object=magomar
$	   libr		magimar
$	   libr		magomar
$	   delete	mag*.obj;*
$no_magtape:
$!..........................................................................
$	if not_all .and. .not.do_iff   then goto no_iff
$	   from = "lsl$source_root:[lslmaint.lsllib.''p1'.iff]"
$	   macro'mdb'	'from'iffmodify/obj=iffmar1,-
			'from'iffcreate/obj=iffmar2
$ 	   adc		ifffor'adcco'='from'iffopen,iffcreate_sub,iffmodify_sub
$ 	   adc		ifffor/ap'adcco'='from'lsl_iffparse,lsl_iffrep
$	   fortran'fdb'	ifffor
$	   pvv		ifffor
$	   libr		iffmar1,iffmar2,ifffor
$	   delete	iff*.obj;*,adc.ide;*
$	   cleanup	ifffor.for'ver'
$no_iff:
$!..........................................................................
$	if not_all .and. .not.do_system   then goto no_system
$	   from = "lsl$source_root:[lslmaint.lsllib.''p1'.system]"
$	   macro'mdb'	'from'have_i_an_arg/obj=sysmar,-
			'from'set_ctrlc_ast/obj=tmp1,-
			'from'set_outband_ast/obj=tmp2,-
			'from'trnall/obj=tmp3,-
			'from'vioarg/obj=tmp4,-
			'from'vioclr/obj=tmp5
$	   macro'mdb'	'from'viomv3/obj=tmp6,-
			'from'viosec/obj=tmp7,-
			'from'wait/obj=tmp8,-
			'from'wflor/obj=tmp9
$	   append	tmp*.obj sysmar.obj
$ 	   adc		sysfor'adcco'='from'getid,jpinfo,lsl_num_chand
$	   adc		sysfor/ap'adcco'='from'lsl_tmrexh,lsl_tmrini,lsl_tmrcan
$	   adc		sysfor/ap'adcco'='from'test_foreign,test_term
$	   adc		sysfor/ap'adcco'='from'cvt_date,cvt_day_str,cvt_time_str
$	   adc		sysfor/ap'adcco'='from'cvt_dmy_day,cvt_day_dmy
$	   fortran'fdb'	sysfor
$	   pvv		sysfor
$	   libr		sysmar,sysfor
$	   delete	sys*.obj;*,tmp*.obj;*,adc.ide;*
$	   cleanup	sysfor.for'ver'
$no_system:
$!..........................................................................
$	if not_all .and. .not.do_sort     then goto no_sort
$	   from = "lsl$source_root:[lslmaint.lsllib.''p1'.sort]"
$	   adc		sorfor'adcco'='from'heap_sort,quick_sort,shell_sort
$	   fortran'fdb'	sorfor
$	   pvv		sorfor
$	   libr		sorfor
$	   delete	sor*.obj;*,adc.ide;*
$	   cleanup	sorfor.for'ver'
$no_sort:
$	set noverify
$!
$! if we come here, then the library is neatly made and all finished,
$! so we can rename it to be the main library
$!
$	wsb
$	ws "Renaming LSLLIB_TMP to be the new LSLLIB"
$	wsb
$	library/comp	lsllib_tmp
$	set file/trunc	lsllib_tmp.olb
$	purge/log       lsllib_tmp.olb
$	rename/log here:lsllib_tmp.olb  lsllib_destination:lsllib
$	purge/keep=2/log                lsllib_destination:lsllib.olb
$!
$	   type sys$input:

	If you want a new shareable image (LSLSHR), then first test
	your new .OLB, and place it in LSL$LIBRARY:.
	Set default into the [.SHARE] directory.
	If necessary, amend the transfer vector (LSLVEC.MAR), and
	the GSMATCH parameters (SHARE.COM).
	Invoke the SHARE command procedure.
	Test the new LSLSHR.EXE by defining LSL$LSLSHR as it and running
	programs which use it. When OK, the place in LSL$LIBRARY: and
	publish as required.

$!
$! *************************************************************************
$! come here for a tidy exit
$!
$tidy_exit:
$	set noverify
$	wsb
$	sd        start_directory
$	deassign  start_directory
$	deassign  lsllib_destination
$	deassign  lsllib_source
$	exit
