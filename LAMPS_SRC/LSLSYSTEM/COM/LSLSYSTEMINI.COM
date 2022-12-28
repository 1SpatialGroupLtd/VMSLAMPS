$!
$! initialisation file for Laser-Scan software package LSLSYSTEM
$!
$! recreated 						PGH	14-Aug-1987
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
$	CVT		== "$LSL$EXE:CVT"	! convert numbers
$	ERR*OR		== "$LSL$EXE:CVT/ERR"	! cvt with error messages
$	FLUSH		== "$LSL$EXE:FLUSH"	! purge typeahead
$	LST*VAX		== "$LSL$EXE:LSTVAX"	! print with line numbers etc
$	MLOAD		== "$LSL$EXE:MLOAD"	! microprocessor loader
$!!!	MTD		== "$LSL$EXE:MTD"	! obsolete magtape dump
$	MTD*UMP		== "$LSL$EXE:MTDUMP"	! new magtape dump utility
$	MUL*VAX		== "$LSL$EXE:MULVAX"	! multi-column print
$	NED		== "$LSL$EXE:NED"	! Cambridge editor
$	NEWMSG		== "$LSL$EXE:NEWMSG"	! message generation utility
$	QUO		== "$LSL$EXE:QUO"	! system display utility
$	SD		== "$LSL$EXE:SD"	! set/show default directory
$!!!	SDBUREAU	== "$LSL$EXE:SDBUREAU"	! combination of SD/SI
$	SI		== "$LSL$EXE:SI"	! set show LSL$IF:
