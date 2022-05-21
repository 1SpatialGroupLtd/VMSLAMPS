$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-03 12:14:22.000000000 +0100
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
$! Command file to generate a licencing function for LITES2
$!
$	SAVVER='f$verify(0)
$	CURDIR=f$environment("DEFAULT")
$	set on
$	on WARNING then goto  ERR_EXIT	! stop for anything
$!
$	set default LSL$SOURCE_ROOT:[LITES2.LIC]
$!
$! get name of installation
$!
$	if P1 .nes. "" then goto GOT_NAME
$	write SYS$OUTPUT ""
$	inquire P1 "Installation name"
$	if P1 .eqs. "" then goto ERR_EXIT	! premature exit
$! 
$! run INSTGEN as a foreign image, to create the file COM:CUSTDAT.SRC
$!
$ GOT_NAME:
$	instgen := $SYS$DISK:[]instgen
$	define/user_mode SYS$INPUT SYS$COMMAND	! get input from terminal
$	if f$search(CURDIR+P1+".FAC") .nes. "" then-
	   define/user_mode SYS$INPUT 'CURDIR''P1'.FAC
$	instgen 'P1'
$!
$! now compile and build a licencing subroutine using this data
$!
$	write SYS$OUTPUT ""
$	write SYS$OUTPUT "Creating licence file"
$	LICFILE:='CURDIR''P1'.LIC
$	adc LOCKFU=LOCKFU
$	fort LOCKFU
$	pvv LOCKFU
$	delete ADC.IDE;*
$	link/share/exe='LICFILE' SYS$INPUT:/OPT
LOCKFU
UNIVERSAL=LOCKFU
$	set noon				! file created now
$	delete LOCKFU.FOR;*,LOCKFU.OBJ;*
$	purge 'LICFILE'
$	purge CUSTDAT.SRC
$	write SYS$OUTPUT ""
$	write SYS$OUTPUT "Licence file ''LICFILE' created"
$	GOTO EXIT
$!
$ ERR_EXIT:
$	write SYS$OUTPUT ""
$	write SYS$OUTPUT "No licence file created"
$ EXIT:
$	write SYS$OUTPUT ""
$	set default 'CURDIR'
$	if SAVVER then set noverify
