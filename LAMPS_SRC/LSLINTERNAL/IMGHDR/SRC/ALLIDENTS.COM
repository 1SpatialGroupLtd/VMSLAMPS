$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-11-09 17:34:58.000000000 +0000
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
$! command file to get IDENTs for all executables on the issue tree
$! to keep BAe happy for Saudi
$! Written 					PGH	09-Nov-1990
$!
$ last_dir=""
$ imghdr_read=="$lsl$source_root:[lslinternal.imghdr]imghdr_read"
$ write sys$output "Ident list for LSL$ISSUE_ROOT:[*.EXE]*.EXE on ",f$time()
$ set noon
$ loop:
$ nextfile=f$search("LSL$ISSUE_ROOT:[*.EXE]*.EXE")
$ if nextfile.eqs."" then goto exit
$ this_dir=f$parse(nextfile,,,"directory")-"["-".EXE]"
$ if this_dir.nes.last_dir
$ then
$    write sys$output ""
$    write sys$output "Package ",this_dir
$    write sys$output ""
$    last_dir=this_dir
$ endif
$ imghdr_read 'nextfile'
$ goto loop
$exit:
