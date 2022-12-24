$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-02-01 12:17:12.000000000 +0000
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
$!MOD	/MAP added to LINK statement				TJH 17-Oct-1989
$!
$	set noverify
$	on control_y then goto endlab
$	on error then goto errorlab
$	if "''f$logical("lsl$uismenus_building")'" -
			.nes. "in_progress" then goto lab10
$	write sys$output	"Someone else is building"
$	exit
$!
$lab10:	
$	define/group	lsl$uismenus_building "in_progress"
$!
$	inquire/nop deb_flag "                Debug ? "
$	if (.not.deb_flag) then QUALS="/nodeb"
$	if (     deb_flag) then QUALS="/deb"
$!
$	set verify
$	link/map 'QUALS' uismenus, -
			cld_init, -
			do_monitor, -
			main_loop, -
			mbx_setup, -
			respond, -
			setup_comm, -
			set_toggles, -
			set_groups, -
			uismenus_cld, -
			uismenus.promsg_obj, -
			gpx_lib:wsuilib/lib, -
			gpx_lib:wsiolib/lib, -
			gpx_lib:mbxlib/lib, -
			gpx_lib:odds/lib, -
			lsl$library:lslshr/opt, -
			sys$input:/opt
sys$library:vaxcrtl/share
$	set noverify
$!
$errorlab:
$!
$endlab:
$	deassign/group lsl$uismenus_building
$	set noverify
