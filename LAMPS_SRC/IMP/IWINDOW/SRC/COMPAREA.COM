$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-05-30 12:13:42.000000000 +0100
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
$	ON CONTROL_Y THEN GOTO IWINDOWEX
$	IF "''F$LOGICAL("LSL$IWINDOW_BUILDING")'" -
		 .NES. "IN_PROGRESS" THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building IWINDOW"
$	EXIT
$!
$A0:	DEFINE/GROUP LSL$IWINDOW_BUILDING "IN_PROGRESS"
$	INTER =F$MODE() .EQS. "INTERACTIVE"
$	ASSIGN LSL$SOURCE_ROOT:[IMP.IWINDOW] LSL$CMNIWIN
$	SD:=$LSL$SYS:SD
$	SET NOON
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		SET VERIFY
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC CLIP_AREA=CLIP_AREA,IWIN_INSIDE
$ 		ADC CLIP_AREA/AP=IWIN_CLIPGFA
$ 		ADC CLIP_AREA/AP=IWIN_CLIPAREA
$ 		FORT CLIP_AREA
$ 		OK=$STATUS
$ 		IF OK THEN PVV CLIP_AREA
$ 		PURGE/NOLOG CLIP_AREA.OBJ
$ 		DELETE/NOLOG CLIP_AREA.FOR;*
$ 		IF .NOT.INTER THEN DELETE/NOLOG CLIP_AREA.LIS;*
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		LINK/MAP/DEBUG/EXE=IWINDOW -
		IWINDOW,IWINDOW_CLD,OBEY,CLIP_AREA, -
		CLIP_MAP,CLIP,GET_BOUNDS,COPYPT,LCM_POSN, -
		IWIN.PROMSG_OBJ, -
		LSL$LIBRARY:LSLFRTLIB/LIB, -
		LSL$LIBRARY:IFFSHR/OPT,LSLSHR/OPT
$ 		PURGE/NOLOG IWINDOW*.EXE
$ 		PURGE/NOLOG IWINDOW*.MAP
$ 		IWINDOWEX:
$ 		DEASS/GROUP LSL$IWINDOW_BUILDING
$ 		SET NOVER
