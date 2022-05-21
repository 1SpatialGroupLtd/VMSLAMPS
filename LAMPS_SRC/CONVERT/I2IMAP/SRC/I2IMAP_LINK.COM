$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1995-02-21 18:00:00.000000000 +0000
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
$! Mod 1463 Allow linking on AXP		ST 01-Feb-1995
$!
$	if F$GETSYI("ARCH_NAME").eqs."Alpha"
$	then
$	   define lsl$frtshr_tv lsl$library:frtshr_dummy_axp
$	   define lsl$lslshr_tv lsl$library:lslshr_dummy_axp
$	   define lsl$iffshr_tv lsl$library:iffshr_dummy_axp
$	   suffix = "_tv"
$	   axp = "/nonative_only"
$	   prog = "i2imap_axp"
$	   vaxonly = ""
$	else
$	   suffix = ""
$	   axp = ""
$	   prog = "i2imap"
$	   vaxonly = ",set_addr"
$	endif
$!
$	set noverify
$	link_dir := "here:"
$	inquire DBG "link with debug           "
$	if DBG
$	then
$	  lbug  = "/debug"
$	  prog = prog + "_debug"
$	else
$	  lbug = ""
$	endif
$!
$	set verify
$	link'lbug''axp'/map='link_dir''prog'/exe='link_dir''prog' -
			i2imap,i2imap_cld,-
			get_command,rdpar,process,plottr,summary,-
			i2imap.promsg_obj,-
			lsl$library:frtshr'suffix'/opt,-
			lsl$library:iffshr'suffix'/opt,-
			lsl$library:lslshr'suffix'/opt,-
			sti_libs:debuglib/incl=(rdbms_entry_points'vaxonly'),-
			sti_libs:gwsoff/opt,-
			!!!sti_libs:stilib/include=(.main.),-
			sti_libs:stilib/lib,-
			sti_libs:dbmslib/lib,-
			sti_libs:usrlink/opt
$!
$	set noverify
$!
$!	purge			'link_dir'i2imap*.*
$end:
$!
$	if F$GETSYI("ARCH_NAME").eqs."Alpha"
$	then
$	   deassign lsl$frtshr_tv
$	   deassign lsl$lslshr_tv
$	   deassign lsl$iffshr_tv
$	endif
