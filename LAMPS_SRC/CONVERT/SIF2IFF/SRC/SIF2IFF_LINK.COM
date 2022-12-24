$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-07-28 16:17:30.000000000 +0100
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
$! Command file to link SIF2IFF program
$!
$	set noverify
$	on control then goto end
$       on error  then goto end
$!  
$! Define some symbols
$!
$	ws    := "write sys$output "
$	wsb   := "write sys$output """""
$	dbg   :=
$ 	lbug  :=
$	link_dir := "lsl$SOURCE_ROOT:[CONVERT.SIF2IFF.SRC]"
$!
$	wsb
$	inquire LNK	"Link                    "
$	if .not. LNK then goto askdel
$	inquire DBG	"   with debug           "
$	if DBG then lbug  = "/debug"
$	goto doLNK
$!
$askdel:wsb
$	goto noLNK
$!
$doLNK:
$	wsb
$	set verify
$	link'lbug'/map='link_dir'/exe='link_dir' -
			SIF2IFF,SIF2IFF_CLD,-
			GET_COMMAND,RDPAR,CONDAT,CLOSE_IFF,-
			SIF2IFF.PROMSG_OBJ,-
			LSL$LIBRARY:IFFSHR/OPT,-
			LSL$LIBRARY:LSLSHR/OPT
$!
$	set noverify
$!
$! tidy the link directory
$!
$noLNK:	
$	purge/by=dba			'link_dir'SIF2IFF.*
$	if .not. LNK then dir/by=dba	'link_dir'SIF2IFF.*
$	wsb
$end:
