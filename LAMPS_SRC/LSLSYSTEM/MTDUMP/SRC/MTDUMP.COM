$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-05-27 11:31:14.000000000 +0100
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
$!	set up the exit route for error and cntl Y
$!
$ 	on control_y then goto COEXIT
$	on error then goto COEXIT
$!
$	inquire mes "Messages"
$	inquire cld "CLD file"
$	inquire for "Fortran"
$	inquire lnk "Link"
$	inquire deb "With debug"
$!
$	set verify
$	if mes then newmsg MTDUMP/number=1272
$	if mes then @MTDUMP.TEMP_COM
$!
$	if .not.cld then goto nocld
$		adc MTDUMP.TMP=MTDUMP.CLD
$	   	set command/object=MTDUMP_CLD MTDUMP.TMP
$		pvv MTDUMP_CLD
$		delete ADC.IDE;*,MTDUMP.TMP;*
$		
$!
$nocld:	if .not.for then goto nofor
$	opt1=""
$	if deb then opt1="/deb/noopt/check=all"
$		adc MTDUMP/co=MTDUMP,OBEY,MTI,ICLASC
$		fort'OPT1' MTDUMP
$		pvv	MTDUMP
$		if .not.deb then delete MTDUMP.FOR;*
$		delete ADC.IDE;*
$!
$nofor:	if .not.lnk then goto COEXIT
$	lpt1=""
$	if deb then lpt1="/deb"
$		link/map'LPT1'  MTDUMP,-
			    MTDUMP_CLD,-
			    MTDUMP.PROMSG_OBJ,-
			    LSL$LIBRARY:LSLSHR/OPT
$!
$COEXIT:
$	pur/nolog *.FOR,*.OBJ,MTDUMP.*
$	set noverify
$	exit
