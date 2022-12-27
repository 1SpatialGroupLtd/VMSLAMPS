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
$	define/nolog	LSL$IFFSHR	LSL$LIBRARY:IFFSHR
$	define/nolog	LSL$LSLSHR	LSL$LIBRARY:LSLSHR
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
$	I2IMAP	== "$LSL$EXE:I2IMAP"		! IFF to IMAP convertor
$	IMAP2I	== "$LSL$EXE:IMAP2I"		! IMAP to IFF convertor
$!
$! module IFFNTF
$!
$	I2NTF	== "$LSL$EXE:I2NTF"		! IFF to NTF convertor
$	NTF2I	== "$LSL$EXE:NTF2I"		! NTF to IFF convertor
$!
$! module IFFOSTF
$!
$	I2OSTF	  == "$LSL$EXE:I2OSTF"		! IFF to OSTF convertor
$	OSTF2I	  == "$LSL$EXE:OSTF2I"		! OSTF to IFF convertor
$	OSTFINDEX == "$LSL$EXE:OSTFINDEX"	! Read the OSTF index
$!
$!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
$!
$	set control=y
$	if ver_status then set verify