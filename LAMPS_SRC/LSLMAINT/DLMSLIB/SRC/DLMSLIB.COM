$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1983-11-08 11:29:34.000000000 +0000
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
$	ver='f$verify(0)'
$	set noon
$!
$	assign [common.violib]	cmnvio
$	assign [common.dlmslib] cmndlms
$	assign [common.dfad] cmndfad
$!
$	inquire DBG "With Debug"
$	if .not.DBG then DBG=""
$	if      DBG then MLDBG="/DEBUG"
$	inquire NEWL "New library"
$	  if      DBG then DBG="/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW)"
$!
$	  A1="F.ADDANG,ADDANG"
$	  A2="F.ADDDAT,ADDDAT"
$	  A3="F.APPANG,APPANG"
$	  A4="F.APPDAT,APPDAT"
$	  A5="F.BINTOD,BINTOD"
$	  A6="F.CHECK,CHECK"
$	  A7="F.CVTANG,CVTANG"
$	  A8="F.DTOBIN,DTOBIN"
$	  A9="F.NEGTIV,NEGTIV"
$	  A10="F.OUTANG,OUTANG"
$	  A11="F.OUTDAT,OUTDAT"
$	  A12="F.RDFANG,RDFANG"
$	  A13="F.RDTEXT,RDTEXT"
$	  A14="F.RDYYMM,RDYYMM"
$	  A15="F.SWAP,SWAP"
$!
$	  TIMES=15
$	  if NEWL then goto COMP
$	  COUNT=0
$ NXTASK:
$	  COUNT=COUNT+1
$	  OUT=f$extract(2,F$LOCATE(",",A'COUNT')-2,A'COUNT')
$	  FILES=f$extract(F$LOCATE(",",A'COUNT')+1,100,A'COUNT')
$	  inquire YES "''OUT' (''FILES')"
$	  if .NOT.YES then A'COUNT'=""
$	  if COUNT.lt.TIMES then goto NXTASK
$!
$ COMP:
$	ERROR=""
$	  COUNT=0
$	if .not.NEWL then goto NXTC
$	  set verify
$	libr/create=blocks:30 dlmslib 
$	pip dlmslib.olb/nm/pu			! 'f$verify(0)'
$ NXTC:
$	  COUNT=COUNT+1
$	    CMP=f$extract(0,1,A'COUNT')
$	    OUT=f$extract(2,f$locate(",",A'COUNT')-2,A'COUNT')
$	    FILES=f$extract(F$LOCATE(",",A'COUNT')+1,100,A'COUNT')
$	    if CMP.eqs."M" then goto MAC
$	    if CMP.nes."F" then goto SKIPC
$	      set verify
$	adc 'OUT'='FILES'
$	FORT/LIST'DBG' 'OUT'
$	      OK=$STATUS			!'f$verify(0)
$	      if .not.OK then ERROR=ERROR+" "+OUT
$	      set verify
$	if OK then pvv 'OUT'
$	if OK then DELETE 'OUT'.LIS;*
$	pip 'OUT'.OBJ/nm,.FOR/NM,.LIS/nm/pu
$	delete ADC.IDE;*
$	      goto REPL				!'f$verify(0)
$ MAC:
$	      set verify
$	macro'MLDBG'/OBJECT='OUT' 'FILES'
$	      OK=$STATUS			!'f$verify(0)
$	      if .not.OK then ERROR=ERROR+" "+OUT
$	      set verify
$	pip 'OUT'.OBJ/nm/pu
$ REPL:					!'f$verify(0)
$	  if OK then libr/repl/log dlmslib 'OUT'
$ SKIPC:
$	  if count.lt.times then goto NXTC
$!
$tidy:	! 'f$verify(0)'
$	if error.nes."" then write sys$output "Errors in ",error
$	if ver then set verify
