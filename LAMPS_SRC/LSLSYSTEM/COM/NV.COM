$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1989-10-03 11:42:28.000000000 +0100
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
$	V='f$verify(0)'
$! Copyright Laser-Scan Laboratories Ltd, Cambridge, England
$! Author					RF	1979
$! Rehashed for explicit version numbers	PGH/JMB	16-Dec-1988
$!
$! Procedure for edit, then set date, then purge
$! Example is   $ NV FRED.SRC
$! 		$ NV FRED.SRC R		! Recover edits
$!
$	if P1.eqs."" then inquire P1 "File"
$	if P1.eqs."" then goto tidy_ver
$	initial_file=f$search(p1)
$	if initial_file.nes."" then goto A10
$	  write sys$output p1," does not exist"
$	  goto tidy_ver
$A10:	no_version=f$element(0,";",initial_file)
$	highest_version=f$search(no_version)
$	if highest_version.eqs."" then write sys$output "NV internal errror"
$	initial_vn=f$parse(highest_version,,,"VERSION")
$	RECSW=""
$	if P2 .eqs. "R" then RECSW="/REC"
$	define/user	sys$input	sys$command:
$	ced'recsw' 'p1'
$	final_file=f$search(no_version)
$	if initial_vn.eqs.f$parse(final_file,,,"version") then goto tidy_ver
$	if P2 .nes. "" .and. P2 .nes. "R" then PURGE/KEEP='P2' ''no_version'
$	if P2 .eqs. "" then PURGE 'no_version'
$	extn=f$parse(p1,,,"TYPE")
$	if extn.eqs.".MAC" .or. extn.eqs.".MAR" .or. -
	   extn.eqs.".SRC" .or. extn.eqs.".PAS" .or. -
	   extn.eqs.".C"   .or. extn.eqs.".CLD" .or. -
	   extn.eqs.".FOR" .or. extn.eqs.".F"   then pid 'no_version'
$tidy_ver: if v then set verify
