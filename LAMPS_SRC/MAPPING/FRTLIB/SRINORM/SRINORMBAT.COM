$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-05-07 14:42:14.000000000 +0100
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
$	ws = "write sys$output"
$	SET noverify
$	on control_Y then goto srinormEX
$	if "''F$LOGICAL("LSL$srinorm_BUILDING")'" -
		 .nes. "IN_PROGRESS" then goto A0
$	ws "Someone else is building"
$	exit
$!
$A0:	DEFINE/GROUP LSL$srinorm_BUILDING "IN_PROGRESS"
$	ASSIGN LSL$SOURCE_ROOT:[MAPPING.FRTLIB.srinorm] LSL$CMNsrinorm
$	SET NOon
$	SET verify
$	NEWMSG srinorm/number=1186
$	@srinorm.TEMP_COM
$	ADC srinorm.TMP=srinorm.CLD
$	SET COMMAND/OBJECT=srinorm_cld srinorm.TMP
$	OK=$STATUS
$	if OK then PVV srinorm_cld
$	DELETE srinorm.TMP;*
$	PURGE/NOLOG srinorm_cld.OBJ
$	OK=$STATUS
$	SET noverify
$	ws "-----------------COMPILE--------"
$	SET verify
$	ADC srinorm=srinorm
$	FORT srinorm
$	OK=$STATUS
$	if OK then PVV srinorm
$	PURGE/NOLOG srinorm.OBJ
$	DELETE srinorm.FOR;*
$	DELETE ADC.IDE;*
$	SET noverify
$	ws "---------------LINK........."
$	SET verify
$	link/MAP/CROSS/exe=srinorm srinorm,-
 srinorm_cld,srinorm.PROMSG_OBJ, -
 LSL$LIBRARY:IFFSHR/OPT,LSLSHR/OPT
$	srinormEX:
$	DEASS/GROUP LSL$srinorm_BUILDING
$	SET NOVER
