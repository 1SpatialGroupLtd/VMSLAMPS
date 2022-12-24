$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-08-04 10:52:30.000000000 +0100
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
$! command file to fortran the fill area functions for GKSLDLIB
$!
$	set noverify
$!
$	on control then goto end
$	on error then goto end
$!
$!!!	assign lsl$source_root:[tves.sort] sortdir
$	assign 'f$logical("HERE") CMN
$!
$! assume we don't want debug
$	dbug   = ""
$	lbug   = ""
$	retfor = ""
$	dlines = ""
$!
$! now find out what we wish to do...
$!
$	inquire DBG  "debug                   "
$	if .not.DBG then goto nod
$	   dbug = "/debug/noop"
$	   lbug = "/debug"
$	   inquire retfor "retain fortran sources  "
$	   inquire incds  "include D lines         "
$	   if incds then dlines="/d_lines"
$nod:	write sys$output " "
$	inquire SIDE "Fill_side,etc        "
$	inquire CLIP "Polygon clipping     "
$	write sys$output " "
$!
$! create the truth file
$!
$	open/write SYM sym.tru
$	write SYM "SYMBOL=0"
$	close SYM
$!
$start:	set verify
$	if .not.SIDE then goto noside
$	   adc fillside/co = sym.tru/tr,fillside,fill_rotate
$	   adc fillside/ap = sym.tru/tr,cfreal,cfside,copyreal,copyside
$	   adc fillside/ap = sym.tru/tr,swapreal,swapside
$!!!
$!!! assume that sorting routine will come from LSLLIB
$!!! CCB 26-Mar-1992
$!!!	   adc fillside/ap = sortdir:heapsort
$	   fort'dbug''dlines' fillside
$	   pvv fillside
$	   delete adc.ide;*
$	   if .not.RETFOR then delete fillside.for;*
$!
$	   adc fillsideq/co = sym.tru/tr,fillsideq
$	   fort'dbug''dlines' fillsideq
$	   pvv fillsideq
$	   delete adc.ide;*
$	   if .not.RETFOR then delete fillsideq.for;*
$noside:
$	if .not.CLIP then goto noclip
$	   adc gks_clip_poly/co = gks_clip_poly
$	   fort'dbug''dlines' gks_clip_poly
$	   pvv gks_clip_poly
$	   delete adc.ide;*
$	   if .not.RETFOR then delete gks_clip_poly.for;*
$!
$	   adc gks_clip_poly2/co = gks_clip_poly2
$	   fort'dbug''dlines' gks_clip_poly2
$	   pvv gks_clip_poly2
$	   delete adc.ide;*
$	   if .not.RETFOR then delete gks_clip_poly2.for;*
$noclip:
	delete sym.tru;*
$	purge/log
$end:	set noverify
$!
