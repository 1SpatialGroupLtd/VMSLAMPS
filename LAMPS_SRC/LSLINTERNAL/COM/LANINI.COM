$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1989-01-25 11:20:04.000000000 +0000
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
$! Labour analysis initialisation file
$!
$	lan	=="$lsl$exe:lan"
$	fur*anal =="$lsl$exe:furanal"
$	pra	=="@lsl$com:printacct"
$	recon*cile=="$lsl$lan_root:[progs]reconcile"
$!
$! directories to use
$!
$	root_address	= f$trnlnm("lsl$user_root","lnm$system_table")- -
							"]"+"lan.]"
$	define/tr=(c,t)	lsl$lan_root	 'root_address'
$!
$	bur*eau	==sd+" lsl$lan_root:bureau"
$	comm	==sd+" lsl$lan_root:comm"
$	devt	==sd+" lsl$lan_root:devt"
$	do	==sd+" lsl$lan_root:do"
$	npg	==sd+" lsl$lan_root:npg"
$	sales	==sd+" lsl$lan_root:salesup"
$	soft*ware ==sd+" lsl$lan_root:soft"
$!
