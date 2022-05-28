$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1985-06-04 12:55:14.000000000 +0100
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
$! command file to set up the BCPL 'world'
$! - define where we expect to find things
$!
$	ass  'f$logical("LSL$PUBLIC")  bcpl$disk
$	ass  'f$logical("BCPL$DISK")  bcpl$disc
$!
$	disc		:= 'f$logical("BCPL$DISK")
$!
$	bcpldir		:= lsl$public_root:[lslinternal.bcpl]
$!
$! and set up the relevant commands
$!
$	bcpl		:== $'bcpldir'bcpl	! the compiler itself
$	vax		:== $'bcpldir'vax	! the codegenerator
$	alpha		:== $'bcpldir'alpha	! ocode => text
$!
$! alias for getting at the help library
$!
$	helb*cpl	:== help/library=lsl$help:bcpl
$!
$! define our header file, and our run-time system
$!
$	define	libhdr	'bcpldir'dlib.hdr
$	define	bcplrts	'bcpldir'rts.obj
$!
$! define the directory for outside use
$!
$	define	bcpldir     'bcpldir'
$!
