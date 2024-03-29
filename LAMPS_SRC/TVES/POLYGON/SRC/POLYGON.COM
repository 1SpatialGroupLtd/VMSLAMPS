$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1984-10-17 17:30:48.000000000 +0100
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
$! command file to build the polygon fill test program
$!
$	set noverify
$!
$	on control then goto end
$	on error then goto end
$!
$! assume we don't want debug
$	dbug   = ""
$	mbug   = ""
$	lbug   = ""
$	retfor = ""
$!
$! now find out what we wish to do...
$!
$	inquire CMP  "compile                 "
$	inquire DBG  "debug                   "
$	if .not.CMP then goto asklnk
$	if .not.DBG then goto nod
$	   dbug = "/debug/noop"
$	   mbug = "/debug"
$	   inquire retfor "retain fortran sources  "
$nod:	write sys$output " "
$	inquire MAIN  "POLY                   "
$	inquire FILL  "polyfill               "
$	inquire SCAN  "scan                   "
$	inquire PLOT  "plot,first/nextplot    "
$	inquire CIRC  "circular buffering     "
$	inquire MISC  "rdyes,height           "
$	write sys$output " "
$!
$asklnk:inquire LNK  "link                    "
$!
$! if we are linking and have compiled with debug, then check to
$! see if we wish to link with debug...
$!
$	if .not.LNK .or. .not.DBG then goto start
$	inquire DBG "link with debug         "
$	if DBG then lbug:="/debug"
$!
$start:	set verify
$	if .not.CMP then goto dolnk
$	if .not.MAIN then goto nomain
$	   adc polygon/co = poly
$	   fort'dbug' polygon
$	   pvv polygon
$	   delete adc.ide;*
$	   if .not.RETFOR then delete polygon.for;*
$nomain:if .not.FILL then goto nofill
$	   adc polyfill/co = polyfill
$	   fort'dbug' polyfill
$	   pvv polyfill
$	   delete adc.ide;*
$	   if .not.RETFOR then delete polyfill.for;*
$nofill:if .not.SCAN then goto noscan
$	   adc scan/co = scan
$	   fort'dbug' scan
$	   pvv scan
$	   delete adc.ide;*
$	   if .not.RETFOR then delete scan.for;*
$noscan:if .not.PLOT then goto noplot
$	   adc plot/co = plot,nextplot,firstplot
$	   fort'dbug' plot
$	   pvv plot
$	   delete adc.ide;*
$	   if .not.RETFOR then delete plot.for;*
$noplot:if .not.CIRC then goto nocirc
$	   adc circ/co = initcirc,nextptr,prevptr,thisptr,reset,change
$	   fort'dbug' circ
$	   pvv circ
$	   delete adc.ide;*
$	   if .not.RETFOR then delete circ.for;*
$nocirc:if .not.MISC then goto nomisc
$	   adc misc/co = rdyes,height
$	   fort'dbug' misc
$	   pvv misc
$	   delete adc.ide;*
$	   if .not.RETFOR then delete misc.for;*
$nomisc:
$dolnk:	if .not.LNK then goto end
	link'lbug'/cross/map polygon,polyfill,scan,plot,circ,misc,-
			lsl$library:vslib/lib,-
			lsl$library:ifflib/lib,-
			lsl$library:cmdlib/lib,-
			lsl$library:violib/lib
$	purge/log
$ end:	set noverify
$!
