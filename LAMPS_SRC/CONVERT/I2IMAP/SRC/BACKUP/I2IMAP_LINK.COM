$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-11-28 17:16:32.000000000 +0000
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
$! LINK I2IMAP
$!
$! Mod 1435 Use new frtshr			JB 28-Nov-1994
$!
$	set noverify
$	link_dir := "here:"
$	inquire DBG "link with debug           "
$	if DBG
$	then
$	  lbug  = "/debug"
$	  prog = "i2imap_debug"
$	else
$	  prog = "i2imap"
$	endif
$!
$	set verify
$	link'lbug'/map='link_dir'/exe='link_dir''prog' -
			i2imap,i2imap_cld,-
			get_command,rdpar,process,plottr,summary,-
			i2imap.promsg_obj,-
			lsl$library:frtshr/opt,-
			lsl$library:iffshr/opt,-
			lsl$library:lslshr/opt,-
			sti_libs:debuglib/incl=(rdbms_entry_points,set_addr),-
			sti_libs:gwsoff/opt,-
			sti_libs:stilib/include=(.main.),-
			sti_libs:stilib/lib,-
			sti_libs:dbmslib/lib,-
			sti_libs:usrlink/opt
$!
$	set noverify
$!
$!	purge			'link_dir'i2imap*.*
$end:
$!
