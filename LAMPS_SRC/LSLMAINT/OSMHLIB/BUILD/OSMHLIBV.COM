$	set noverify
$	on control_y then goto tidy_exit
$	on error     then goto tidy_exit
$!  
$! *************************************************************************
$!
$!	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
$!
$!	OSMHLIBV - Create or update the library
$!
$! *************************************************************************
$!
$! Description
$!
$!	Command file which creates or updates OSMHLIBV, the VIOLIB
$!	version of the OS map header manipulation library. This version
$!	of the library is only used for DIGSYS, so only those routines
$!	needed are included.
$!
$!	OSMHLIBV has it own copies of the OSMH_NEW_xxx routines, named 
$!	OSMH_VIO_xxx, but utilises the following parameter files and 
$!	common blocks from the main library:
$!
$!		CMN:OSMHLIBMSG.PAR
$!		LSL$CMNOSMH:OSMH_NEW.PAR
$!
$!		CMN:OSMH_NEW_FILES.CMN
$!		CMN:OSMH_NEW_TAB.CMN
$!		LSL$CMNOSMH:OSMH_NEW_MH.CMN
$!
$!	It also has a common block of its own:
$!
$!		CMNV:OSMH_VIO_MSG.CMN
$!
$!	In order to maintain compatibility with OSMHLIB, OSMHLIBV has 
$!	its own versions of LSL_PUTMSG and LSL_ADDMSG which call 
$!	OSMH_VIO_OUTMSG. The library also has its own copies of the 
$!	LSLLIB routines SAVE_EXPC and TRNALL.
$!
$!	The OSMHLIB routine OSMH_PUTCHAR (for type 2 headers) is also
$!	included in OSMHLIBV.
$!
$! *************************************************************************
$!
$start_doing_things:
$!
$! define some logical names
$!
$	define/nolog cmn  lsl$source_root:[lslmaint.osmhlib.common]
$	define/nolog cmnv lsl$source_root:[lslmaint.osmhlib.osmh_vio]
$	assign  'f$logical("HERE")  start_directory
$!
$! and some symbols
$!
$	ws	= "write sys$output"
$	wsb	= "write sys$output """""
$	inq	= "inquire"
$!
$! *************************************************************************
$!
$!!!	inquire testing_version "Is this a testing version "
$!
$! we need to specify where the finished library will be put
$!
$!!!	if   testing_version -
$!!!	then assign  lsl$source_root:[lslmaint.osmhlib.test]  osmhlib_destination
$!!!	if   .not.testing_version -
$	assign  lsl$source_root:[lslmaint.osmhlib]  osmhlib_destination
$!
$! and ensure that we are in the correct directory
$!
$!!!	wsb
$!!!	sd  osmhlib_destination
$!
$! *************************************************************************
$! now, find out what we are meant to be doing...
$!
$	wsb
$	inq	new_library	"Make a new library     "
$!
$	with_debug = 0
$!!!	if testing_version then -
$	inq	with_debug	"With debug             "
$!
$! *************************************************************************
$! sort out subsidiary variables
$!
$	not_all = .not.new_library
$	if with_debug then goto set_debug
$!
$	dbg     = ""
$	mdb     = ""
$	cleanup = "delete/noconfirm"
$	ver     = ";*"
$	if .not.with_debug then goto no_debug
$!
$set_debug:
$	dbg	= "/debug/noopt/check=all"
$	mdb     = "/debug"
$	cleanup	= "purge"
$	ver	= ""
$no_debug:
$!
$! *************************************************************************
$! if we are creating a library from scratch, then we shall insert modules
$! into it. If we are updating a library, then we shall replace modules in it
$!
$! first initialise the symbols
$!
$	   do_ini	= 0
$	   do_inq	= 0
$	   do_getfld	= 0
$	   do_putint	= 0
$	   do_putflg	= 0
$	   do_msg	= 0
$	   do_putchar	= 0
$!
$! now do the action
$!
$	if .not.new_library then goto ask_what_to_replace
$!
$	library/create  osmhlib_destination:osmhlibv
$	libr = "library/insert/log osmhlib_destination:osmhlibv"
$	goto compilation
$!
$! *************************************************************************
$ask_what_to_replace:
$!
$	libr = "library/replace/log  osmhlib_destination:osmhlibv"
$!
$	wsb
$	ws "What to replace -"
$	wsb
$	inq	do_inq	   "OSMH_VIO_INQTABLE - table inquire      "
$	inq	do_ini	   "OSMH_VIO_INI      - initialisation     "
$	inq	do_getfld  "OSMH_VIO_GETFLD   - get header field   "
$	inq	do_putint  "OSMH_VIO_PUTINT   - put integer field  "
$	inq	do_putflg  "OSMH_VIO_PUTFLG   - put OSTF flag      "
$	inq	do_msg     "OSMH_VIO_OUTMSG   - messages           "
$	inq	do_putchar "OSMH_PUTCHAR - put characters (type 2) "
$!
$! *************************************************************************
$! now do the actual work...
$!
$compilation:
$	   from  = "[lslmaint.osmhlib.osmh_vio]"
$	   from2 = "[lslmaint.osmhlib.osmh]"
$	   set verify
$!
$	   if not_all .and. .not. do_inq then goto no_inq
$	   adc 			OSMH_VIO_INQTABLE/co = 'from'OSMH_VIO_INQTABLE
$	   fort/extend'dbg'	OSMH_VIO_INQTABLE
$	   pvv			OSMH_VIO_INQTABLE
$	   libr			OSMH_VIO_INQTABLE
$	   macro'mdb'		'from'TRNALL
$	   libr 		TRNALL
$	   delete/noconfirm	ADC.IDE;*,OSMH_VIO_INQTABLE.obj;*,TRNALL.obj;*
$	   cleanup		OSMH_VIO_INQTABLE.for'ver'
$!
$no_inq:
$	   if not_all .and. .not. do_ini then goto no_ini
$	   adc 			OSMH_VIO_INI/co = 'from'OSMH_VIO_INI
$	   fort/extend'dbg'	OSMH_VIO_INI
$	   pvv			OSMH_VIO_INI
$	   libr			OSMH_VIO_INI
$	   macro'mdb'		CMN:OSMH_NEW
$	   libr 		OSMH_NEW
$	   delete/noconfirm	ADC.IDE;*,OSMH_VIO_INI.obj;*,OSMH_NEW.obj;*
$	   cleanup		OSMH_VIO_INI.for'ver'
$!
$no_ini:
$	   if not_all .and. .not. do_getfld then goto no_getfld
$	   adc			OSMH_VIO_GETFLD/co = 'from'OSMH_VIO_GETFLD
$	   fort/extend'dbg'	OSMH_VIO_GETFLD
$	   pvv			OSMH_VIO_GETFLD
$	   libr 		OSMH_VIO_GETFLD
$	   delete/noconfirm	ADC.IDE;*,OSMH_VIO_GETFLD.obj;*
$	   cleanup		OSMH_VIO_GETFLD.for'ver'
$!
$no_getfld:
$	   if not_all .and. .not. do_putint then goto no_putint
$	   adc			OSMH_VIO_PUTINT/co    = 'from'OSMH_VIO_PUTINT
$	   adc			OSMH_VIO_PUTINT/ap/co = 'from'SAVE_EXPC
$	   fort/extend'dbg'	OSMH_VIO_PUTINT
$	   pvv			OSMH_VIO_PUTINT
$	   libr 		OSMH_VIO_PUTINT
$	   delete/noconfirm	ADC.IDE;*,OSMH_VIO_PUTINT.obj;*
$	   cleanup		OSMH_VIO_PUTINT.for'ver'
$!
$no_putint:
$	   if not_all .and. .not. do_putflg then goto no_putflg
$	   adc			OSMH_VIO_PUTFLG/co    = 'from'OSMH_VIO_PUTFLG
$	   fort/extend'dbg'	OSMH_VIO_PUTFLG
$	   pvv			OSMH_VIO_PUTFLG
$	   libr 		OSMH_VIO_PUTFLG
$	   delete/noconfirm	ADC.IDE;*,OSMH_VIO_PUTFLG.obj;*
$	   cleanup		OSMH_VIO_PUTFLG.for'ver'
$!
$no_putflg:
$	   if not_all .and. .not. do_msg then goto no_msg
$	   adc			OSMH_VIO_OUTMSG/co = 'from'OSMH_VIO_OUTMSG
$	   adc			OSMH_VIO_OUTMSG/ap/co = 'from'LSL_PUTMSG
$	   adc			OSMH_VIO_OUTMSG/ap/co = 'from'LSL_ADDMSG
$	   fort/extend'dbg'	OSMH_VIO_OUTMSG
$	   pvv			OSMH_VIO_OUTMSG
$	   libr 		OSMH_VIO_OUTMSG
$	   delete/noconfirm	ADC.IDE;*,OSMH_VIO_OUTMSG.obj;*
$	   cleanup		OSMH_VIO_OUTMSG.for'ver'
$!
$no_msg:
$	   if not_all .and. .not. do_putchar then goto no_putchar
$	   adc			OSMH_PUTCHAR/co = 'from2'OSMH_PUTCHAR
$	   fort/extend'dbg'	OSMH_PUTCHAR
$	   pvv			OSMH_PUTCHAR
$	   libr 		OSMH_PUTCHAR
$	   delete/noconfirm	ADC.IDE;*,OSMH_PUTCHAR.obj;*
$	   cleanup		OSMH_PUTCHAR.for'ver'
$!
$no_putchar:   ! 'f$verify(0)
$	   purge/nolog osmhlib_destination:osmhlibv.olb
$!
$! *************************************************************************
$! come here for a tidy exit
$!
$tidy_exit:
$	deassign  start_directory
$	exit
$!
