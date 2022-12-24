$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-12 15:14:14.000000000 +0100
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
$! 	command file to compile and link DTIPATCH
$!
$	def	lsl$matrixsys	lsl$source_root:[matrix.service]
$!
$	set verify
$	deb=""
$	inquire compile "compile"
$	inquire debug "debug"
$	inquire lnk  "link"
$!
$	if .not.debug then goto nodebug
$	if debug then deb = "/debug/noopt/check=(b,o)"
$	if debug then ibug = "/debug"
$!
$nodebug: if .not.compile then goto LINK
$!
$	adc dtipatch = dtipatch
$	fortran 'deb' dtipatch
$	pvv 'objprel' dtipatch
$	purge dtipatch.for
$!
$link: if .not.lnk then goto nolnk
$	run lsl$exe:genver
$	adc version=version
$	fortran version
$	pvv version
$	purge version.*
$	delete adc.ide;*
$!
$	link/map 'ibug'	dtipatch,-
			version,-
			lsl$matrixsys:matrix/lib,-
			lsl$library:dtilib/lib,-
			lsl$library:lslshr.opt/opt
$!	purge *.exe
$!
$nolnk:	set noverify
$!
