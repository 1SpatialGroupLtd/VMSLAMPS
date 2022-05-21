$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-11-28 12:45:46.000000000 +0000
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
$!	set noverify
$	on error     then goto exit_neatly
$	on control_y then goto exit_neatly
$!
$! *************************************************************************
$! Command file: IFF2SIF - command file for building the IFF2SIF program
$!
$! Copyright (C) Laser-Scan Ltd, Cambridge, England  1986
$! Author of this amended version TJ Ibbs, 19 November 1986
$!
$! Amendments :
$! 19-Mar-1990 A J Verrill	Link with shared lib's IFFSHR, LSLSHR
$! 28-Jul-1993 S Townrow	Removed the specific build directory
$! 28-Nov-1994 J Barber		Mod 1435 Use new FRTSHR
$!
$! *************************************************************************
$! initialise our question asking mechanism
$!
$	call initq  "IFF2SIF"  "?"
$	if .not.$status then goto exit_neatly	! exit if error
$!
$! suppress any listings (/LIST is the default in batch)
$!
$	fortran = "fortran/nolist"
$	macro   = "macro/nolist"
$!
$! *************************************************************************
$! set various symbols
$!
$	debug :=
$	mdbg  :=
$	lbug  :=    
$	wsb    = "write sys$output "" """
$	if askq_repeat then wsb = "!"
$!
$! *************************************************************************
$! work out what we are doing in general
$!
$	call askq "with debug"
$	dbg = $status
$	   if dbg then debug = "/debug/noopt"
$	   if dbg then mdbg  = "/debug"
$	call askq "compile   "
$	cmp = $status
$	if .not.cmp then goto nocmp
$!
$	wsb
$	call askq cld "Command line definition "
$	CLD = $status
$! .........................................................................
$! are we doing the various oddments?
$!
$	wsb                                                         
$	call askq "create a new help library                     "
$	HELP = $status
$	call askq "messages                                      "
$	MOAN = $status
$	call askq "command tables                                "
$	CMDS = $status
$!
$! .........................................................................
$! and now the main routines
$!
$	call askq "IFF2SIF                                       "
$	MAIN = $status
$	call askq "check_scitex,jacket,getcmd,exp_handler        "
$	LICE = $status
$	call askq "get_next_file,obey,openfile,help,show         "
$	OBEY = $status
$	call askq "sifini,siffnd,findfc,rdfc,rdptsiz,rdcategory  "
$	SIFI = $status
$	call askq "startmt,pad,tapemk                            "
$	MAG1 = $status
$	call askq "sifout,outblk                                 "
$	MAG2 = $status
$	call askq "output,output_st,output_ef,check_text         "
$	IFF1 = $status
$	call askq "readra,usefs,usest,doef,repeat,catlevel       "
$	IFF2 = $status
$	call askq "st_to_zs,zs_to_st,read_string                 "
$	IFF3 = $status
$	call askq "start,unstart,force,drname                    "
$	STRT = $status
$	call askq "arc,cell,circle,curve,line,text               "
$	TOP1 = $status
$	call askq "sifarc,cir,cur,did,fnt,lac,lst                "
$	SIF1 = $status
$	call askq "sifmtx,ovr,sym,tlc,tx3,txt,txt3d              "
$	SIF2 = $status
$	call askq "sifbst,est,acz,ide,asv                        "
$	SIF3 = $status
$	call askq "points,circen,degree                          "
$	UTIL = $status
$	call askq "uor...,sifmult,mm_to_m,convert,complex_string "
$	UTI2 = $status
$	call askq "check_char,check_room,room_for                "
$	CHEK = $status
$	call askq "moan message routines                         "
$	LIBR = $status
$	wsb
$	if askq_haderror then goto exit_neatly
$!
$! .........................................................................
$!
$nocmp:	call askq  "link                    "
$	lnk = $status
$	call askq  "link with debug         "
$ 	dbg = $status
$	if dbg then lbug  = "/debug"
$!
$	call askq  "link with testing LSLLIB"
$	lib   = $status
$	lsllib = "lsl$library:lsllib"
$	if lib then lsllib = "lsl$disk:[lib.lsllib.test]lsllib"
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
$	   submit/que=fastbatch_m3b/log/noprin/notif  IFF2SIF.COM			! submit this command file
$	   goto exit_only			! and that's all
$do_it_now:
$!
$! *************************************************************************
$!
$	if .not.cmp then goto link_only
$	set verify
$! .........................................................................
$	if .not.HELP then goto nohelp
$	   library/help/create=(blocks:30)/log iff2sif iff2sif
$	   purge  iff2sif.hlb
$! .........................................................................
$nohelp:if .not.MOAN then goto nomoan
$	   newmsg  iff2sif.mes /number=1601 /prefix=msg__
$	   @iff2sif.temp_com
$! .........................................................................
$nomoan:if.not.cld then goto nocld
$	  adc IFF2SIF.TMP=IFF2SIF.CLD
$	  set command/object=IFF2SIF_CLD IFF2SIF.TMP
$	  pvv IFF2SIF_CLD
$	  purge IFF2SIF_CLD.OBJ
$	  delete ADC.IDE;*
$	  delete IFF2SIF.TMP;*
$! .........................................................................
$nocld:if .not.CMDS then goto nocmds
$	   macro sifcmds
$	   macro siftyp
$	   macro sdfcmds
$! .........................................................................
$nocmds:if .not.MAIN then goto nomain
$	   adc IFF2SIF/co=iff2sif
$	   fortran'debug' iff2sif
$	   pvv iff2sif
$	   delete adc.ide;*
$	   if .not.dbg then delete iff2sif.for;*
$! .........................................................................
$nomain:if .not.LICE then goto nolice
$	   adc CHECK_SCITEX/co=check_scitex,jacket,getcmd,exp_handler
$	   fortran'debug' CHECK_SCITEX
$	   pvv CHECK_SCITEX
$	   delete adc.ide;*
$	   if .not.dbg then delete CHECK_SCITEX.for;*
$! .........................................................................
$nolice:if .not.OBEY then goto noobey
$	   adc OBEY/co=get_next_file,obey,openfile,help,show
$	   fortran'debug' obey
$	   pvv obey
$	   delete adc.ide;*                            
$	   if .not.dbg then delete obey.for;*
$! .........................................................................
$noobey:if .not.SIFI then goto nosifi
$	   adc SIFINI/co=sifini,siffnd,findfc,rdfc,rdptsiz,rdcategory
$	   fortran'debug' sifini
$	   pvv sifini
$	   delete adc.ide;*
$	   if .not.dbg then delete sifini.for;*
$! .........................................................................
$nosifi:if .not.MAG1 then goto nomag1
$	   adc MAG1/co=startmt,pad,tapemk
$	   fortran'debug' mag1
$	   pvv mag1
$	   delete adc.ide;*
$	   if .not.dbg then delete mag1.for;*
$! .........................................................................
$nomag1:if .not.MAG2 then goto nomag2
$	   adc MAG2/co=sifout,outblk
$	   fortran'debug' mag2
$	   pvv mag2
$	   delete adc.ide;*
$	   if .not.dbg then delete mag2.for;*
$! .........................................................................
$nomag2:if .not.IFF1 then goto noiff1
$	   adc OUTPUT/co=output,output_st,output_ef,check_text
$	   fortran'debug' output
$	   pvv output
$	   delete adc.ide;*
$	   if .not.dbg then delete output.for;*
$! .........................................................................
$noiff1:if .not.IFF2 then goto noiff2
$	   adc IFFSUB/co=readra,usefs,usest,doef,repeat,catlevel
$	   fortran'debug' iffsub
$	   pvv iffsub
$	   delete adc.ide;*
$	   if .not.dbg then delete iffsub.for;*
$! .........................................................................
$noiff2:if .not.IFF3 then goto noiff3
$	   adc IFFSU2/co=st_to_zs,zs_to_st,read_string
$	   fortran'debug' iffsu2
$	   pvv iffsu2
$	   delete adc.ide;*
$	   if .not.dbg then delete iffsu2.for;*
$! .........................................................................
$noiff3:if .not.STRT then goto nostrt
$	   adc START/co=start,unstart,force,drname
$	   fortran'debug' start
$	   pvv start
$	   delete adc.ide;*
$	   if .not.dbg then delete start.for;*
$! .........................................................................
$nostrt:if .not.TOP1 then goto notop1
$	   adc TOP/co=arc,cell,circle,curve,line,text
$	   fortran'debug' top
$	   pvv top
$	   delete adc.ide;*
$	   if .not.dbg then delete top.for;*
$! .........................................................................
$notop1:if .not.SIF1 then goto nosif1
$	   adc SIF1/co=sifarc,sifcir,sifcur,sifdid,siffnt,siflac,siflst
$	   fortran'debug' sif1
$	   pvv sif1
$	   delete adc.ide;*
$	   if .not.dbg then delete sif1.for;*
$! .........................................................................
$nosif1:if .not.SIF2 then goto nosif2
$	   adc SIF2/co=sifmtx,sifovr,sifsym,siftlc,siftx3,siftxt,siftxt3d
$	   fortran/LIS/SH'debug' sif2
$	   pvv sif2
$	   delete adc.ide;*
$	   if .not.dbg then delete sif2.for;*
$! .........................................................................
$nosif2:if .not.SIF3 then goto nosif3
$	   adc SIF3/co=sifbst,sifest,sifacz,sifide,sifasv
$	   fortran'debug' sif3
$	   pvv sif3
$	   delete adc.ide;*
$	   if .not.dbg then delete sif3.for;*
$! .........................................................................
$nosif3:if .not.UTIL then goto noutil
$	   adc UTIL/co=points,circen,degree
$	   fortran'debug' util
$	   pvv util
$	   delete adc.ide;*
$	   if .not.dbg then delete util.for;*
$! .........................................................................
$noutil:if .not.UTI2 then goto nouti2
$	   adc UTIL2/co=uorall,uorx,uory,uorz,sifmult,mmtom,convert
$	   adc UTIL2/co/ap=complex_string
$	   fortran'debug' util2
$	   pvv util2
$	   delete adc.ide;*
$	   if .not.dbg then delete util2.for;*
$! .........................................................................
$nouti2:if .not.CHEK then goto nochek
$	   adc check/co=check,checkch,roomfor
$	   fortran'debug' check
$	   pvv check
$	   delete adc.ide;*
$	   if .not.dbg then delete check.for;*
$! .........................................................................
$nochek:if .not.LIBR then goto nolibr
$	   macro'mdbg' lsl$cmnlsl:expc+here:moaning/obj=here:librstuff
$nolibr:
$link_only:set verify
$! .........................................................................
$! generate a version identifier
$	   run lsl$exe:genver
$	   purge version.src
$	   adc version=version
$	   fortran version
$	   pvv version
$	   pur version.*
$	   delete version.for;*,adc.ide;*
$! .........................................................................
$	link'lbug'/map	IFF2SIF,iff2sif_cld,check_scitex,siftyp,sifcmds,-
			sdfcmds,obey,sifini,mag1,mag2,output,iffsub,iffsu2,-
			start,top,sif1,sif2,sif3,util,util2,check,-
			librstuff,version,-
			iff2sif.promsg_obj,-
			lsl$library:frtshr/opt,iffshr/opt,lslshr/opt
$!
$! .........................................................................
$exit_neatly:	set noverify
$		call exitq
$		purge *.*
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
