$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-09-17 12:40:12.000000000 +0100
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
$	set verify
$!
$	vti :== $lsl$source_root:[dfad.valtab]valtab2index
$	ass lsl$source_root:[dfad.fadtcmn] lsl$fadtcmn
$!
$	fort valtab2index.src
$	fort display_rule.src
$	fort open_files.src
$	fort close_files.src
$	fort read_rule.src
$	fort write_rule.src
$!
$	link -
	 	valtab2index,-
		display_rule,-
		open_files,-
		close_files,-
		read_rule,-
		write_rule,-
		lsl$library:lslshr/opt
$	set noverify
