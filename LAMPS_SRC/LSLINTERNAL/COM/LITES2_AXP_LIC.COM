$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-11-14 13:46:14.000000000 +0000
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
$! LITES2_AXP_LIC.COM - procedure to VEST licences for package LITES2.$! call as @LSL$COM:LITES2_AXP_LIC FRED to convert FRED.LIC into FRED_TV.LIC$!Created							PGH  22-Jul-1993$!Mod	Source and target are LITES2.FAC (after AXP root merge)	PGH  14-Nov-1994$!$!-----------------------------------------------------------------------$	set noon$	@lsl$com:vest_setup 'p3'	! define symbols etc$	if p1.eqs."" then inquire/nopunc p1 "Name ?  "$	if p1.eqs."" then exit$	if p2.eqs."" then p2="SOURCE"$	licsubdir=".EXE"$	if p2.eqs."SOURCE" then licsubdir=".FAC"$!-----------------------------------------------------------------------$!$	current_dir=f$environment("DEFAULT")$	on control_Y then goto abort$	ws="write sys$output"$	myvest=="vest"+-	"/incl=(sys$library:,lsl$library:,tie$feedback_directory:)"+-	"/show=(message,statistic) "$	source_dir:=LSL$'p2'_ROOT:[LITES2'licsubdir']$	work_dir:=lsl$axp_test_root:[LITES2.EXE]$	dest_dir:=lsl$source_root:[LITES2.FAC]$	source_file:='source_dir''p1'.lic$	if f$search(source_file).eqs.""$	then$	   ws "*** ",source_file," not found"$	   goto exit$	endif$!$!-----------------------------------------------------------------------$!$	set default 'work_dir'$!$	ws "*** Starting translating ",p1,".LIC from ",source_dir$	myvest 'source_dir''p1'.LIC/executable='work_dir''p1'_TV.LIC$	purge/nolog 'work_dir''p1'*.*$	ws "*** Ended translation into ",work_dir,p1,"_TV.LIC"$	ws "*** Starting copy of  ",p1,"_TV.LIC from ",work_dir$	backup 'work_dir''p1'_TV.LIC 'dest_dir'.new$	rename 'dest_dir''p1'_TV.NEW 'dest_dir'.LIC$	purge/nolog 'dest_dir''p1'*.*$	ws "*** Ended copying of  ",p1,"_TV.LIC into ",dest_dir$!$	goto done$!-----------------------------------------------------------------------$abort:$	write sys$output "Procedure aborted by Control-Y"$	set default 'current_dir'$	exit 44		! SS$_ABORT$done:$	set default 'current_dir'$	exit$!-----------------------------------------------------------------------$exit:	exit