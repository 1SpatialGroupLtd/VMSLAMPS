$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-01-28 16:00:06.000000000 +0000
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
$! Define symbol to suggest queue split
$! Bug mend (symbol PASS)				RF  24-Oct-1990
$! Deal with deferred archive queue			RF  13-Jul-1990
$! Now handles LAVc device names			TJH 07-Jan-1987
$!
$! Command procedure to print out the contents of the SECURE archive
$! queue
$!
$! preferred split sizes
$	split_min =30000
$	split_max =36000
$!
$! check our vitals exist!
$	if f$type(ws).eqs."" then ws="write sys$output "
$!
$! deal with possible switch
$	if p1.eqs."" then p1="NOSIZE"
$	if p1.eqs."SIZE"
$	then
$	  do_size=1
$	  t_size=0
$	  if p2.eqs."SYMBOLS"
$	  then do_symbols=1
$	  else do_symbols=0
$	  endif
$	  split_suggested=0
$	else
$	  do_size=0
$	  if p1.nes."NOSIZE" then ws "*** Invalid P1 parameter ""''p1'"""
$	endif
$	ws ""
$!
$!
$! Test to see whether there is anything at all in the file!
$	OPEN/READ/share=write AQ LSL$SECURE:ARCHDIR.DAT
$	pass=0
$	ON CONTROL_Y THEN GOTO A4
$	READ/END=A1 AQ LINE
$	WS "Listing of current Secure Queue:"
$	CLOSE AQ
$	GOTO A2
$ A1:
$	WS "%SECURE-I-NOFILES, no files on current secure queue."
$	GOTO A4
$!
$! Extract the 3 records for each queued request and format on screen.
$ A2:	OPEN/READ/share=write AQ LSL$SECURE:ARCHDIR.DAT
$a2a:	REQNO=0
$	t_size=0
$ A3:	READ/END=A4 AQ LINE1
$	READ/END=A4 AQ LINE2
$	READ/END=A4 AQ LINE3
$	REQNO=REQNO+1
$	req_dev=F$EXTRACT(0,F$LOCATE(":",LINE1)+1,LINE1)
$	req_name=F$EXTRACT(0,F$LOCATE(" ",LINE3),LINE3)
$	WS ""
$	WS "REQUEST ''REQNO'"
$	WS "User:            ''F$EXTRACT(38,13,LINE1)'"
$	WS "Date of request: ''F$EXTRACT(58,22,LINE1)'"
$	WS "Device:          ''req_dev'"
$	WS "Directory:       ''LINE2'"
$	WS "File:            ''req_name'"
$	if do_size
$	then
$	  req_size=0
$	  s_name=req_dev+line2+req_name
$	  if f$locate("...",line2).lt.f$length(line2) .or. -
	     f$locate("*",req_name).lt.f$length(req_name) .or. -
	     f$locate("%",req_name).lt.f$length(req_name)
$	  then
$	    is_wild=1
$	  else
$	    is_wild=0
$	  endif
$next_f:  f=f$search(s_name)
$!
$! ss f
$!
$	  if f.nes.""
$	  then
$	    f_size=f$file(f,"EOF")
$!
$! ss f_size
$!
$	    req_size=req_size+f_size
$	    if is_wild then goto next_f
$	  endif
$	  t_size=t_size+req_size
$	  ws "Size of request: ", req_size, " (of ", t_size, " so far)"
$	  if t_size.gt.split_min
$	  then
$	    if t_size.lt.split_max
$	    then split_suggested=reqno+1
$	    else
$	      if split_suggested=0 then split_suggested=reqno
$	      if split_suggested=1 then split_suggested=-1
$	    endif
$	  endif
$	endif
$	GOTO A3
$!
$! Then close the queue file again
$ A4:	CLOSE AQ
$	if do_size
$	then
$	  ws ""
$	  ws "Total size archived: ", t_size
$	  ws ""
$	  if do_symbols then split_suggested==split_suggested
$	endif
$	if pass.eq.0
$	then
$	  if f$search("lsl$secure:deferred_archdir.dat").nes.""
$	  then
$	    pass=1
$	    split_suggested=0
$	    open/read/share=write aq lsl$secure:deferred_archdir.dat
$	    ws ""
$	    ws ""
$	    ws "Listing of current Deferred Archive Queue:"
$	    goto a2a
$	  endif
$	endif
