$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-06-30 11:44:14.000000000 +0100
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
$! initialisation file for Laser-Scan software package LSLSYSTEM
$!
$! recreated 						PGH	14-Aug-1987
$!
$! Allow for differences for OpenVMS Alpha AXP
$!
$	IF F$GETSYI("ARCH_NAME").EQS."Alpha"
$	THEN
$	  AS_TV="_TV"	! suffix for AXP translated images
$	  AS_NA="_AXP"	! suffix for AXP native images
$	ELSE
$	  AS_TV=""	! suffix for AXP translated images
$	  AS_NA=""	! suffix for AXP native images
$	ENDIF
$!
$! symbols that point to command files
$!
$	FREE		== "@LSL$COM:FREE"	! tell how much free space
$	MV		== "@LSL$COM:MV"	! directory multiple versions
$	NEWMESSAGE	== "@LSL$COM:NEWMESSAGE"! runs NEWMSG - obsolete
$	NV		== "@LSL$COM:NV"	! new version edit command
$	PROTECT		== "@LSL$COM:PROTECT"	! change file protection
$	REPEAT		== "@LSL$COM:REPEAT"	! repeat a DCL command
$	SLAVE		== "@LSL$COM:SLAVE"	! slave a serial line
$!
$! symbols for images
$!
$	CALC		== "$LSL$EXE:CALC"	! calculator program
$	CVT		== "$LSL$EXE:CVT"+AS_TV	! convert numbers
$	ERR*OR		== CVT+"/ERR"		! cvt with error messages
$	FLUSH		== "$LSL$EXE:FLUSH"	! purge typeahead
$	LST*VAX		== "$LSL$EXE:LSTVAX"	! print with line numbers etc
$	MLOAD		== "$LSL$EXE:MLOAD"	! microprocessor loader
$!!!	MTD		== "$LSL$EXE:MTD"	! obsolete magtape dump
$	MTD*UMP		== "$LSL$EXE:MTDUMP"	! new magtape dump utility
$	MUL*VAX		== "$LSL$EXE:MULVAX"	! multi-column print
$	NED		== "$LSL$EXE:NED"	! Cambridge editor
$	NEWMSG		== "$LSL$EXE:NEWMSG"	! message generation utility
$	QUO		== "$LSL$EXE:QUO"+AS_TV	! system display utility
$	SD		== "$LSL$EXE:SD"+AS_NA	! set/show default directory
$!!!	SDBUREAU	== "$LSL$EXE:SDBUREAU"	! combination of SD/SI
$	SI		== "$LSL$EXE:SI"+AS_NA	! set show LSL$IF:
