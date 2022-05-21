$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-12-08 17:10:06.000000000 +0000
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
$!
$	set noverify
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$! *************************************************************************
$! Command file: IDIFFERENCE - a command file to build the IMP program
$!			       IDIFFERENCE
$!
$! Copyright (C) Laser-Scan Ltd, Cambridge, England  1986
$! Author TJ Ibbs, 9 December 1987	(from an earlier version)
$!
$! Mod1432 use new frtshr			JB 23-Nov-1994
$!
$! *************************************************************************
$! move to the appropriate directory
$!
$!!! no longer since CMS
$!	sd lsl$source_root:[imp.idifference]
$!
$! initialise our question asking mechanism
$!
$	call initq  "IDIFFERENCE"  "?"
$	if .not.$status then goto exit_neatly	! exit if error
$!
$! suppress any listings (/LIST is the default in batch)
$!
$	fortran = "fortran/nolist"
$	macro   = "macro/nolist"
$!
$! *************************************************************************
$! and ask our questions
$!
$	debug = 0
$!
$ 	call askq  "compile                                              "
$	comp  = $status
$	if .not.comp then goto ask_link
$!
$	call askq  "compile with debug                                   "
$	debug   = $status
$!
$! support items, and miscellaneous
$!
$	call askq  "command line definition                              "
$	cld   = $status
$	call askq  "messages                                             "
$	msg   = $status
$!
$! actual program modules
$!
$	call askq  "main routine   - idifference                         "
$	main = $status
$	call askq  "command line   - obey,get_2nd_file                   "
$	cmdl = $status
$	call askq  "open files     - open_files                          "
$	opfl = $status
$	call askq  "header entries - diffstart,prehdr                    "
$	hdr1 = $status
$	call askq  "header entries - compra,get_range,compmd/md1/md2     "
$	hdr2 = $status
$	call askq  "header entries - comphi/mh/ns/cc/cp                  "
$	hdr3 = $status
$	call askq  "layers         - noscan,getnov,check_layer           "
$	layr = $status
$	call askq  "features       - readin,diffnf,getef,compar          "
$	ftrs = $status
$	call askq  "entries        - compfs,compac,sameac,comprest       "
$	ent1 = $status
$	call askq  "entries        - scansub,scants,compts               "
$	ent2 = $status
$	call askq  "entries        - compth/ro/tx,chekcb                 "
$	ent3 = $status
$	call askq  "CB checking    - scancb,scancols,readcb              "
$	CB_1 = $status
$	call askq  "CB checking    - getnxt/arr,left,reset2,compcb,same  "
$	CB_2 = $status
$	call askq  "headers        - messag,fsnhdr,cbhdr,filehdr         "
$	fhdr = $status
$	call askq  "output         - prtcbs,summary                      "
$	fout = $status
$	call askq  "exceptions     - lost,fatal                          "
$	lost = $status
$	call askq  "plot files     - wrpini,wrpclo,wrpdel,wrplot         "
$	plot = $status
$	call askq  "misc FC        - getcod,fswhat                       "
$	msFC = $status
$	call askq  "misc           - copyrow,cf,copy,swap                "
$	misc = $status
$	call askq  "misc IFF       - iff_format_..,right_just            "
$	xxxx = $status
$!
$ask_link:
$	call askq  "link                                                 "
$	lnk   = $status
$!
$	lbg = ""
$	if .not.lnk then goto no_link_questions
$!
$	call askq  "link with debug                                      "
$	lbg   = $status
$!
$no_link_questions:
$!
$! check for an error in the ASKQ routines
$!
$	if askq_haderror then goto exit_neatly
$!
$! *************************************************************************
$! are we doing it now, or submitting ourselves?
$!
$	call submitq
$	if askq_haderror then goto exit_neatly
$	if .not.$status then goto do_it_now
$	   call exitq				! close the file, etc
$	   submit  IDIFFERENCE.COM		! submit this command file
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
$! .........................................................................
$	if .not.cld  then goto no_cld
$	   adc   idifference.TMP=idifference.CLD
$	   set command/object=idifference_cld  idifference.TMP
$	   pvv   idifference_cld
$	   purge idifference_cld.OBJ
$	   delete ADC.IDE;*
$	   delete idifference.TMP;*
$! .........................................................................
$no_cld:
$	if .not.msg  then goto no_msg
$	   newmsg  idiff.mes /number=1215
$	   @idiff.temp_com
$! .........................................................................
$no_msg:
$	if .not.main then goto nomain
$	   adc  idifference/co = IDIFFERENCE
$	   fortran/extend'dbg' idifference
$	   pvv   idifference
$	   purge idifference.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' idifference.FOR'ver'
$! .........................................................................
$nomain:
$	if .not.cmdl then goto nocmdl
$	   adc  cmdline/co = obey,get_2nd_file
$	   fortran/extend'dbg' cmdline
$	   pvv   cmdline
$	   purge cmdline.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' cmdline.FOR'ver'
$! .........................................................................
$nocmdl:
$	if .not.opfl then goto noopfl
$	   adc  open_files/co = open_files
$	   fortran/extend'dbg' open_files
$	   pvv   open_files
$	   purge open_files.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' open_files.FOR'ver'
$! .........................................................................
$noopfl:
$	if .not.hdr1 then goto nohdr1
$	   adc  header1/co = diffstart,prehdr
$	   fortran/extend'dbg' header1
$	   pvv   header1
$	   purge header1.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' header1.FOR'ver'
$! .........................................................................
$nohdr1:
$	if .not.hdr2 then goto nohdr2
$	   adc  header2/co = compra,get_range,compmd,compmd1,compmd2
$	   fortran/extend'dbg' header2
$	   pvv   header2
$	   purge header2.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' header2.FOR'ver'
$! .........................................................................
$nohdr2:
$	if .not.hdr3 then goto nohdr3
$	   adc  header3/co = comphi,compmh,compns,compcc,compcp
$	   fortran/extend'dbg' header3
$	   pvv   header3
$	   purge header3.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' header3.FOR'ver'
$! .........................................................................
$nohdr3:
$	if .not.layr then goto nolayr
$	   adc  layers/co = noscan,getnov,check_layer
$	   fortran/extend'dbg' layers
$	   pvv   layers
$	   purge layers.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' layers.FOR'ver'
$! .........................................................................
$nolayr:
$	if .not.ftrs then goto noftrs
$	   adc  features/co = readin,diffnf,getef,compar
$	   fortran/extend'dbg' features
$	   pvv   features
$	   purge features.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' features.FOR'ver'
$! .........................................................................
$noftrs:
$	if .not.ent1 then goto noent1
$	   adc  entries1/co = compfs,compac,sameac,comprest
$	   fortran/extend'dbg' entries1
$	   pvv   entries1
$	   purge entries1.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' entries1.FOR'ver'
$! .........................................................................
$noent1:
$	if .not.ent2 then goto noent2
$	   adc  entries2/co = scansub,scants,compts
$	   fortran/extend'dbg' entries2
$	   pvv   entries2
$	   purge entries2.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' entries2.FOR'ver'
$! .........................................................................
$noent2:
$	if .not.ent3 then goto noent3
$	   adc  entries3/co = compth,compro,comptx,chekcb
$	   fortran/extend'dbg' entries3
$	   pvv   entries3
$	   purge entries3.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' entries3.FOR'ver'
$! .........................................................................
$noent3:
$	if .not.cb_1 then goto nocb_1
$	   adc  cbcheck1/co = scancb,scancols,readcb
$	   fortran/extend'dbg' cbcheck1
$	   pvv   cbcheck1
$	   purge cbcheck1.obj
$	   delete adc.ide;*
$ 	   'pd' cbcheck1.for'ver'
$! .........................................................................
$noCB_1:
$	if .not.cb_2 then goto nocb_2
$	   adc  cbcheck2/co = getnxt,getarr,left,reset2,compcb,same
$	   fortran/extend'dbg' cbcheck2
$	   pvv   cbcheck2
$	   purge cbcheck2.obj
$	   delete adc.ide;*
$ 	   'pd' cbcheck2.for'ver'
$! .........................................................................
$noCB_2:
$	if .not.fhdr then goto nofhdr
$	   adc  fheaders/co = messag,fsnhdr,cbhdr,filehdr
$	   fortran/extend'dbg' fheaders
$	   pvv   fheaders
$	   purge fheaders.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' fheaders.FOR'ver'
$! .........................................................................
$nofhdr:
$	if .not.fout then goto nofout
$	   adc  output/co = prtcbs,summary
$	   fortran/extend'dbg' output
$	   pvv   output
$	   purge output.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' output.FOR'ver'
$! .........................................................................
$nofout:
$	if .not.lost then goto nolost
$	   adc  lost/co = lost,fatal
$	   fortran/extend'dbg' lost
$	   pvv   lost
$	   purge lost.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' lost.FOR'ver'
$! .........................................................................
$nolost:
$	if .not.plot then goto noplot
$	   adc  plot/co = wrpini,wrpclo,wrpdel,wrplot
$	   fortran/extend'dbg' plot
$	   pvv   plot
$	   purge plot.OBJ
$	   delete ADC.IDE;*
$ 	   'pd' plot.FOR'ver'
$! .........................................................................
$noplot:
$	if .not.msfc then goto nomsfc
$	   adc  miscfc/co = getcod,fswhat
$	   fortran/extend'dbg' miscfc
$	   pvv   miscfc
$	   purge miscfc.obj
$	   delete ADC.IDE;*
$ 	   'pd' miscfc.for'ver'
$! .........................................................................
$nomsFC:
$	if .not.misc then goto nomisc
$	   adc  misc/co = copyrow,cf,copy,swap
$	   fortran/extend'dbg' misc
$	   pvv   misc
$	   purge misc.obj
$	   delete adc.ide;*
$ 	   'pd' misc.for'ver'
$! .........................................................................
$nomisc:
$	if .not.xxxx then goto noxxxx
$	   adc  things/co = iff_format_row,iff_format_rowhead,-
			    iff_format_acd,right_justify
$	   fortran/extend'dbg' things
$	   pvv   things
$	   purge things.OBJ
$	   delete adc.ide;*
$ 	   'pd' things.for'ver'
$! .........................................................................
$noxxxx:
$do_link:
$	if .not.lnk then goto exit_neatly
$!
$	adc   blkdat/co = lsl$cmniff:md2dat
$	fortran/extend  blkdat
$	pvv   blkdat
$	purge blkdat.obj
$	delete adc.ide;*
$	'pd' blkdat.for'ver'
$!
$	link/map'ldbg'	idifference,blkdat,idifference_cld, -
			cmdline,open_files,header1,header2,header3, -
			layers,features,entries1,entries2,entries3, -
			cbcheck1,cbcheck2,fheaders,output,lost,plot, -
			miscfc,misc,things,idiff.promsg_obj, -
			lsl$library:frtshr/opt, -
			lsl$library:iffshr/opt, -
			lsl$library:lslshr/opt
$!
$	purge idifference.*
$	t$idiff*erence == "$''f$trnlnm(""here"")'idifference"
$!
$! .........................................................................
$exit_neatly:	set noverify
$		call exitq
$!
$exit_only:	exit
$!
$! *************************************************************************
$!			S U B R O U T I N E S
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
$	inquire/nopunct askq_notnow "Submit for batch ?                        "
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
$!
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
