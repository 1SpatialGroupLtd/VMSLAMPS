$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1986-11-18 12:41:28.000000000 +0000
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
$! *************************************************************************
$!
$!	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
$!
$!	Created (cribbed from LSLLIB command file)	RJH	13-Nov-1986
$!
$!	COORDLIB - Print the sources
$!
$! *************************************************************************
$!
$start_doing_things:
$!
$	on control_y then goto tidy_exit
$	on error     then goto tidy_exit
$!
$! first define some symbols
$!
$	ws	= "write sys$output"
$	wsb	= "write sys$output """""
$	inq	= "inquire"
$!
$! *************************************************************************
$! now, find out what we are meant to be doing...
$!
$	wsb
$	inq	prt_all		"Print everything       "
$!
$! *************************************************************************
$! initialise the logicals
$!
$	   prt_filt	= 0
$	   prt_int	= 0
$	   prt_area	= 0
$!
$! now do the action
$!
$	if prt_all then goto do_print
$!
$! *************************************************************************
$!
$	wsb
$	ws "What to print -"
$	wsb
$	inq	prt_filt	"FILTER   - filtering         "
$	inq	prt_int		"INTRPL   - interpolation     "
$!**	inq	prt_area	"AREA     - area fill         "
$!
$! *************************************************************************
$! now do the actual printing...
$!
$do_print:
$!
$	cmn = "[lib.coordlib.common]"
$	if .not. prt_all .and. .not. prt_filt then goto no_filt
$	   src = "[lib.coordlib.filter]"
$	   set ver
$	   prt780 'src'bunch*.src,'cmn'params.par,-
			'cmn'blg.cmn,mpaux.cmn,mpep.cmn
$	   prt780 'src'dp*.src,reduce.src,lsl$cmncoord:*.par,'cmn'dp_control.cmn
$no_filt:							! 'f$verify(0)
$!
$	if .not. prt_all .and. .not. prt_int then goto no_int
$	   src = "[lib.coordlib.intrpl]"
$	   set ver
$	   prt780 'src'*.src,'cmn'int*.cmn
$no_int:							! 'f$verify(0)
$!
$!**	if .not. prt_all .and. .not. prt_area then goto no_area
$!**	   src = "[lib.coordlib.area]"
$!**	   set ver
$no_area:							! 'f$verify(0)
$!
$! *************************************************************************
$! come here for a tidy exit
$!
$tidy_exit:
$	set noverify
$	exit
