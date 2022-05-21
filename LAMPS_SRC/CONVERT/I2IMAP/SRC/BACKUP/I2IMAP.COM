$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-08-25 14:17:54.000000000 +0100
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
$! Command file to compile I2IMAP program
$!
$	set noverify
$	on control then goto end
$       on error  then goto end
$!
$	def cmn here:
$!  
$! Define some symbols
$!
$	ws    := "write sys$output "
$	wsb   := "write sys$output """""
$	dbg   :=
$	debug :=
$	mbug  :=
$	cmp   :=
$	lst   :=
$	list  :=
$	cmt   :=
$	rno   :=
$	runoff:=
$	tidy  := "delete/noconfirm"
$	ver   := ";*"
$ 	lbug  :=
$	link_dir := "here:"
$	prog := "I2IMAP"
$!
$	wsb
$	inquire CMP "Compile                 "
$	if CMP
$	then
$	  inquire DBG "   with debug           "
$	  if DBG
$	  then
$	     debug = "/debug/noopt/list/check=all"
$	     mbug  = "/debug"
$	     cmt   = "/co"
$	     tidy  = "purge"
$	     ver   = ""
$	  endif
$!
$	  wsb
$	  inquire CLD      "Command Line Decoding         "
$	  inquire MES      "Message Definitions           "
$	  if MES then runoff = "/runoff/hl=2"
$	  wsb
$	  inquire MAIN  "Main program: I2IMAP,BLKDAT,REPORT,CLOSE_IFF         "
$	  inquire CMD   "Commands: GET_COMMAND,UPCASE,STRTOBUF                "
$	  inquire DBS   "Database: PLOTTR, IMAP_SYSMSG, STAPRO, TIDYWT, NONGRA"
$	  inquire PAR   "Params  : RD*, READ_*, ADD_DTR, IS_ANNOTATION        "
$	  inquire PROC  "Process : PROCESS,COORD,OFFSET,FC_IND,ATTR_IND,ANNO.."
$	  inquire SUM	"Summary : SUMMARY, INVALID, INV_OUT                  "
$!
$	  wsb
$!
$	endif
$! 
$	wsb
$!
$	wsb
$!
$	if CMP
$	then
$	wsb
$	  set noverify
$!
$	  if CLD
$	  then
$	    adc CLD.tmp'cmt' = I2IMAP.CLD
$	    set ver
$	    set command/object = I2IMAP_CLD CLD.tmp
$	    set nover
$	    pvv I2IMAP_CLD
$	    purge I2IMAP_CLD.obj
$	    delete/noconf  adc.ide;*,CLD.tmp;*
$	  endif
$!
$	  if MES
$	  then
$	    set ver
$	    newmsg  I2IMAP/number=1609'runoff'
$	    @I2IMAP.temp_com
$	    set nover
$	    if RNO then purge I2IMAPMSG.rno
$	  endif
$!
$	  if MAIN
$	  then
$	    adc I2IMAP'cmt' = I2IMAP,BLKDAT,REPORT,CLOSE_IFF
$	    set ver
$	    fort'debug' I2IMAP
$	    set nover
$	    pvv I2IMAP
$	    purge I2IMAP.obj
$	    delete/noconf  adc.ide;*
$	    'tidy' I2IMAP.for'ver'
$	  endif
$!
$	  if CMD
$	  then
$	    adc GET_COMMAND'cmt' = GET_COMMAND,UPCASE,STRTOBUF
$	    set ver
$	    fort 'debug''list' GET_COMMAND
$	    set nover
$	    pvv GET_COMMAND
$	    purge GET_COMMAND.obj
$	    delete/noconf  adc.ide;*
$	    'tidy' GET_COMMAND.for'ver'
$	  endif
$!
$	  if DBS
$	  then
$	    adc PLOTTR'cmt' = PLOTTR,IMAP_SYSMSG,STAPRO,TIDYWT,NONGRA
$	    set ver
$	    fort 'debug''list' PLOTTR
$	    set nover
$	    pvv PLOTTR
$	    purge PLOTTR.obj
$	    delete/noconf  adc.ide;*
$	    'tidy' PLOTTR.for'ver'
$	  endif
$!
$	  if PAR 
$	  then
$	    adc RDPAR'cmt' = RDPAR,RDFDT,RDADT,RDTES,RDTEL,RDTET
$	    adc RDPAR'cmt'/ap = READ_NAM,UP_NAM,READ_DTR,ADD_DTR
$	    adc RDPAR'cmt'/ap = IS_ANNOTATION
$	    set ver
$	    fort 'debug''list' RDPAR
$	    set nover
$	    pvv RDPAR
$	    set ver
$	    macro'mbug''list' PARCMD
$	    macro'mbug''list' FLDCMD
$	    set nover
$	    append PARCMD.obj,FLDCMD.obj RDPAR.obj
$	    purge RDPAR.obj
$	    delete/noconf  adc.ide;*,PARCMD.obj;*,FLDCMD.obj;*
$	    'tidy' RDPAR.for'ver'
$	  endif
$!
$	  if PROC
$	  then
$	    adc PROCESS'cmt' = PROCESS,COORD,GET_OFFSET,FC_IND,ATTR_IND
$	    adc PROCESS'cmt'/ap = PROCESS_ANNOTATION
$	    set ver
$	    fort 'debug''list' PROCESS
$	    set nover
$	    pvv PROCESS
$	    purge PROCESS.obj
$	    delete/noconf  adc.ide;*
$	    'tidy' PROCESS.for'ver'
$	  endif
$!
$	  if SUM
$	  then
$	    adc SUMMARY'cmt' = SUMMARY,INVALID,INV_OUT
$	    set ver
$ 	    fort'debug''list' SUMMARY
$	    set nover
$	    pvv SUMMARY
$	    purge SUMMARY.obj
$	    delete/noconf  adc.ide;*
$	    'tidy' SUMMARY.for'ver'
$	  endif
$!
$	  set noverify
$	endif
$!
$	wsb
$	ws "***************************************************************"
$	ws "INFORMAP is installed on LSLV3A, 	LINK IT FROM THERE"
$	ws "Look in Sunils 1992 logbook, section I2IMAP to find out how"
$	ws "  to get Informap up and running, and other I2IMAP material"
$	ws "***************************************************************"
$	wsb
$!------------------------------------------------------------------------------
$!
$! tidy the link directory
$!
$	purge/by=dba			'link_dir'i2imap.*
$	wsb
$end:
$	set noverify
