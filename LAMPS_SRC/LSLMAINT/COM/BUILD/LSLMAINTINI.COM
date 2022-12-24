$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1995-01-30 16:42:50.000000000 +0000
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
$! LSLMAINTINI.COM
$! Command file to set up symbols for LSLMAINT
$!
$! set up logical names
$! (don't actually do this, since normally done at system startup)
$!!!	define	lsl$cmncoord	lsl$public_root:[lslmaint.common.coordlib]
$!!!	define	lsl$cmnvio	lsl$public_root:[lslmaint.common.violib]
$!!!	define	lsl$cmnosmh	lsl$public_root:[lslmaint.common.osmhlib]
$!
$! symbols that point to command files
$!
$	make		== "@lsl$com:make"	! 'make' utility
$	qlst		== "@lsl$com:qlst"	! queue listings
$!
$! Allow for differences for OpenVMS Alpha AXP
$!
$	suffix=""
$	if f$getsyi("ARCH_NAME").eqs."Alpha" then suffix="_tv"
$!
$! symbols for images
$!
$	adc		== "@lsl$com:adc_jacket"  ! file preprocessor jacket
$!
$	adcc		== "$lsl$exe:adcc"+suffix  ! file preprocessor
$	frl		== "$lsl$exe:frl"	! Fortran re-labeller
$	ibm		== "$lsl$exe:ibm"	! write IBM unlabelled magtapes
$	mapid		== "$lsl$exe:mapid"+suffix ! process a map file
$	pid		== "$lsl$exe:pid"	! patch an ID in a text file
$	pvv		== "$lsl$exe:pvv"+suffix   ! apply that ID to an object
$	say		== "$lsl$exe:say"	! say to another user
$	screen		== "$lsl$exe:screen"	! look at a .MEM file
$	tapecopy	== "$lsl$exe:tapecopy"	! tape to disk utility
$!
