$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-01-10 13:08:54.000000000 +0000
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
$	set noverify$	on error     then goto exit_neatly$	on control_y then goto exit_neatly$!$! *****************************************************************************$! Copyright Laser Scan Laboratories Ltd., Cambridge, England, 1986$! Author Tony J Ibbs, 20 November 1986$!$! an example command file to build a DECODE function as a shareable image$! - for documentation of why we are doing this, refer to the comments in$!   the example file EXAMPLE.FOR or EXAMPLE.MAR$! *****************************************************************************$! find out which function is wanted$!$	if P1.eqs."" then inquire/nopunct P1 "Which decode routine ? "$	if P1.eqs."" then goto exit_only$!$	decode := 'P1$!$! work out exactly which file we mean$!$	for_file = f$parse(decode,".FOR")		! to be compiled$	ext      = f$parse(for_file,,,"TYPE")$	ver      = f$parse(for_file,,,"VERSION")$	nam_file = for_file-ext-ver			! to be linked$!$! and check that the file exists$!$	got_file = f$search(for_file)$	if got_file.nes."" then goto found_file$	   write sys$output "*** Cannot find file ""''for_file'"""$	   goto exit_only$! $found_file:$!$! Has file got a table prompt string, to be used when table is$! to be interrogated by programs (ie button not pressed)$!$	if P2.eqs."" then -	            inquire/nopunct P2 "Is there a prompt string ? "$!$! so let us compile and link it$!$! with debug?$	compiler = "fortran"$	if ext.eqs.".MAR" then compiler = "macro"$	dbgfor = ""$	dbglnk = ""$	inquire/nopunct dbg "With debug ? "$	if .not.dbg then goto nodbg$	dbgfor = "/DEBUG"$	if compiler.eqs."fortran" then dbgfor = dbgfor+"/noopt"$	dbglnk = "/DEBUG"$nodbg:	set verify$!$	'compiler''dbgfor'		'for_file'$!$	if P2 then goto link_with_prompt $	link/share'dbglnk	'nam_file',sys$input:/optUNIVERSAL=DECODE$	set noverify$	goto exit_neatly$!$ link_with_prompt:$	link/share'dbglnk	'nam_file',sys$input:/optUNIVERSAL=DECODE,GET_TABLE_PROMPT$	set noverify$!$! and that is that$!$exit_neatly:	delete/log 'nam_file'.OBJ;*$		purge/log  'nam_file'.EXE$exit_only:	exit