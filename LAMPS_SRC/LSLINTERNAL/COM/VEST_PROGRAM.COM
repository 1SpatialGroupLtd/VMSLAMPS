$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-07-05 15:56:58.000000000 +0100
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
$! VEST_PROGRAM.COM - procedure to VEST a specific program.
$! Called from specific package procedures, such as LSLSYSTEM_VEST.COM.
$! Arguments are:
$!	P1	Root (eg PUBLIC)
$!	P2	Package (eg LSLSYSTEM)
$!	P3	subdirectory of package (eg .EXE)
$!	P4	Name of program (eg QUO)
$!	[P5]	Extra arguments to VEST (eg /IIF=xxx)
$! eg @LSL$COM:VEST_PROGRAM PUBLIC LSLSYSTEM .EXE QUO 
$! Target directories are on LSL$AXP_TEST_ROOT:
$! If symbol LSL_VEST_CODE is defined, then produce code listing
$! If symbol LSL_VEST_DIAG is defined, then produce extra diagnostics
$! If symbol LSL_VEST_PERF is defined, then produce even more diagnostics
$! If symbol LSL_VEST_FLOW is defined, then produce call flowgraph
$! If symbol LSL_VEST_ERRF is defined, then produce error flowgraph
$!-----------------------------------------------------------------------
$	set noon
$	current_dir=f$environment("DEFAULT")
$	on control_Y then goto abort
$	ws="write sys$output"
$	myvest=="vest"+-
	"/incl=(sys$library:,lsl$library:,tie$feedback_directory:)"+-
	"/nofeedback"+-
	"/show=(message,statistic) "
$	if "''LSL_VEST_DIAG'".nes."" then myvest==myvest+-
	"/warn=(verbose=full,source=full,noperf)"
$	if "''LSL_VEST_PERF'".nes."" then myvest==myvest+-
	"/warn=(verbose=full,source=full,perf=full,message=novaxdfloat)"
$	if "''LSL_VEST_CODE'".nes."" then myvest==myvest+-
	"/show=(message,source,machine,statistic,entry) "
$	if "''LSL_VEST_FLOW'".nes."" then myvest==myvest+-
	"/FLOWGRAPH/VIEW=CALL"
$	if "''LSL_VEST_ERRF'".nes."" then myvest==myvest+-
	"/FLOWGRAPH"
$	source_dir:=LSL$'p1'_ROOT:['p2''p3']
$	dest_dir:=lsl$axp_test_root:['p2''p3']
$!
$!-----------------------------------------------------------------------
$!
$	set default 'dest_dir'
$!
$	ws "*** Starting translating ",p4," from ",source_dir
$	ws "*** ",myvest,p5
$	myvest 'source_dir''p4''p5'
$	purge/nolog 'dest_dir''p4'_TV.*
$	ws "*** Ended translation of ",p4," into ",dest_dir
$!
$	goto done
$!-----------------------------------------------------------------------
$abort:
$	write sys$output "Procedure aborted by Control-Y"
$	set default 'current_dir'
$	exit 44		! SS$_ABORT
$done:
$	set default 'current_dir'
$	exit
