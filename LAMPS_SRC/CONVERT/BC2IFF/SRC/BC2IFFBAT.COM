$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1991-01-14 17:37:24.000000000 +0000
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
$ 	SET NOVERIFY
$	ON CONTROL_Y THEN GOTO BC2IEX
$	IF "''F$LOGICAL("LSL$BC2I_BUILDING")'" -
		 .NES. "IN_PROGRESS" THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$!
$A0:	DEFINE/GROUP LSL$BC2I_BUILDING "IN_PROGRESS"
$	SET NOON
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$	NEWMSG/NUMBER=1613/PREFIX=BC2I__/PARAMETER=FORTRAN/RUNOFF/HL=2 BC2IFF.MES
$	PURGE BC2IFFMSG.RNO
$	@BC2IFF.TEMP_COM
$ 		ADC BC2IFF.TMP=BC2IFF_CLD.CLD
$ 		SET COMMAND/OBJECT=BC2IFF_CLD BC2IFF.TMP
$ 		OK=$STATUS
$ 		IF OK THEN PVV BC2IFF_CLD
$ 		IF OK THEN DELETE BC2IFF.TMP;*
$ 		IF OK THEN PURGE/NOLOG BC2IFF_CLD.OBJ
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		ADC BC2IFF=BC2IFF
$ 		FORT BC2IFF
$ 		OK=$STATUS
$ 		IF OK THEN PVV BC2IFF
$ 		PURGE/NOLOG BC2IFF.OBJ
$ 		PURGE/NOLOG BC2IFF.FOR
$ 		DELETE ADC.IDE;*
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		ADC UPDATE_RANGE=UPDATE_RANGE
$ 		FORT UPDATE_RANGE
$ 		OK=$STATUS
$ 		IF OK THEN PVV UPDATE_RANGE
$ 		PURGE/NOLOG UPDATE_RANGE.OBJ
$ 		PURGE/NOLOG UPDATE_RANGE.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC BC2CONV=BC2CONV
$ 		FORT BC2CONV
$ 		OK=$STATUS
$ 		IF OK THEN PVV BC2CONV
$ 		PURGE/NOLOG BC2CONV.OBJ
$ 		PURGE/NOLOG BC2CONV.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		LINK/MAP/CROSS/EXE=BC2IFF BC2IFF,-
		BC2IFF_CLD,BC2CONV,UPDATE_RANGE,-
		BC2IFF.PROMSG_OBJ,-
		LSL$LIBRARY:IFFSHR/OPT,LSLSHR/OPT
$ 		BC2IEX:
$ 		DEASS/GROUP LSL$BC2I_BUILDING
$ 		SET NOVER
