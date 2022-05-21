$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1995-02-13 17:41:58.000000000 +0000
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
$	ver_status=f$verify(0)
$	set nocontrol_y
$	on error then continue
$!
$! LSLIMI_LSLINI.COM - a command file to initialise a limited LSL environment
$!		       for the DEC/British Gas INFORMAP system
$!
$! Copyright (C) Laser-Scan Laboratories Ltd, Cambridge, England
$! Author TJ Ibbs, October 1987
$!
$! Modifications
$! ............................................................................
$! 06-Oct-1988	R J Hulme (Laser-Scan Labs)
$! tidied, more logicals added
$! ............................................................................
$! 24-Oct-1988	R J Hulme (Laser-Scan Labs)
$! renamed from LSLINI.COM, 
$! LSL$IMENU_INITIALISE now points to LSLIMI_MENU_INI.COM
$! ............................................................................
$! 13-Feb-1995	Steve Townrow (Laser-Scan Ltd.)
$! Updated to cope with the AXP platfrom. Mod 1468.
$! ............................................................................
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Announce ourselves
$!
$	ws = "write sys$output"
$!
$	if P1.eqs."Q" .or. P1.eqs."q" then goto do_it_quietly
$	   ws ""
$	   ws "	     Defining the LSL INFORMAP translation environment"
$	   ws ""
$do_it_quietly:
$!
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! See what platform we are running on
$!
$	ARCH_NAME=F$GETSYI("ARCH_NAME")
$	SUFFIX=""
$	AXP_SUFFIX=""
$	IF ARCH_NAME.EQS."Alpha" THEN SUFFIX="_TV"
$	IF ARCH_NAME.EQS."Alpha" THEN AXP_SUFFIX="_AXP"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Define the logical names that we require
$!
$! - first some standard LAMPS logical names which we must define here as
$!   they're not defined in the normal login sequence
$!
$	define/nolog	LSL$COM		STI_ROOT:[LSL.COM]
$	define/nolog	LSL$EXE		STI_ROOT:[LSL.EXE]
$	define/nolog	LSL$LIBRARY	STI_ROOT:[LSL.LIB]
$	define/nolog	LSL$LOOKUP	STI_ROOT:[LSL.LOOKUP]
$!
$	define/nolog	LSL$IFFSHR'SUFFIX'	LSL$LIBRARY:IFFSHR'SUFFIX'
$	define/nolog	LSL$LSLSHR'SUFFIX'	LSL$LIBRARY:LSLSHR'SUFFIX'
$	define/nolog	LSL$FRTSHR'SUFFIX'	LSL$LIBRARY:FRTSHR'SUFFIX'
$!
$! - now those specific to the menu system
$!
$	define/nolog	LSL$DATA	STI_ROOT:[LSL.DATA]
$	define/nolog	LSL$IMENU_INITIALISE -
				'f$logical("LSL$COM")'LSLIMI_MENU_INI.COM
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Ensure that the tape is not unloaded when it is dismounted
$!
$	dismount = "dismount/nounload"
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$! Set up symbols for the CONVERT package executables
$!
$! module IFFIMAP
$!
$	I2IMAP	== "$LSL$EXE:I2IMAP''AXP_SUFFIX'"	! IFF to IMAP convertor
$	IMAP2I	== "$LSL$EXE:IMAP2I''AXP_SUFFIX'"	! IMAP to IFF convertor
$!
$! module IFFNTF
$!
$	I2NTF	== "$LSL$EXE:I2NTF''SUFFIX'"		! IFF to NTF convertor
$	NTF2I	== "$LSL$EXE:NTF2I''SUFFIX'"		! NTF to IFF convertor
$!
$! module IFFOSTF
$!
$	I2OSTF	  == "$LSL$EXE:I2OSTF''SUFFIX'"		! IFF to OSTF convertor
$	OSTF2I	  == "$LSL$EXE:OSTF2I''SUFFIX'"		! OSTF to IFF convertor
$	OSTFINDEX == "$LSL$EXE:OSTFINDEX''SUFFIX'"	! Read the OSTF index
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	set control=y
$	if ver_status then set verify
