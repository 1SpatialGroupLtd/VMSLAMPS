$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1990-08-08 12:30:00.000000000 +0100
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
$	V='F$VERIFY(0)
$	ON CONTROL_Y THEN GOTO TIDY
$	ON ERROR THEN GOTO TIDY
$	INQUIRE/NOP COMP1 "Compile LAPROCESS ? "
$	INQUIRE/NOP COMP2 "Compile DM4PT ? "
$	IF .NOT. COMP1 .AND. .NOT. COMP2 THEN GOTO ACLD
$	INQUIRE/NOP CDBG "With DEBUG ? "
$	FDEB=""
$	IF CDBG THEN FDEB="/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW)"
$ ACLD:	INQUIRE/NOP CLD "Build CLD module ? "
$	INQUIRE/NOP MSG "Assemble messages ? "
$	INQUIRE/NOP LNK "Link ? " 
$	IF .NOT. LNK THEN GOTO BEGIN
$	INQUIRE/NOP LDBG "With DEBUG ? "
$	LDEB=""
$	IF LDBG THEN LDEB="/DEBUG"
$!
$ BEGIN:IF .NOT. MSG THEN GOTO CMP
$	SET VERIFY
$!
$	@LSL$COM:NEWMESSAGE LAPROCESS.MES LAPROCESS 1152 LAPROC__ NO F
$	PURGE LAPROCESS.*MSG_OBJ
$! 'F$VERIFY(0)
$!
$ CMP:	IF .NOT. COMP1 THEN GOTO CMP2
$	ASSIGN LSL$SOURCE_ROOT:[POSTPROCESS.LAPROCESS] LSL$CMNLAPROCESS
$	SET VERIFY
$!
$	ADC LAPROCESS/CO=LAPROCESS.SRC
$	FORTRAN'FDEB' LAPROCESS
$	PVV LAPROCESS
$	DELETE ADC.IDE;*
$	PURGE LAPROCESS.FOR,.OBJ
$! 'F$VERIFY(0)
$	IF CDBG THEN GOTO CMP2
$	SET VERIFY
$	DELETE LAPROCESS.FOR;
$! 'F$VERIFY(0)
$!
$ CMP2:	IF .NOT. COMP2 THEN GOTO CMD
$	SET VERIFY
$!
$	ADC DM4PT/CO=LSL$SOURCE_ROOT:[VTRAK.DIGITISER.SRC]DM4PT.SRC
$	FORTRAN'FDEB' DM4PT
$	PVV DM4PT
$	DELETE ADC.IDE;*
$	PURGE DM4PT.FOR,.OBJ
$! 'F$VERIFY(0)
$	IF CDBG THEN GOTO CMD
$	SET VERIFY
$	DELETE DM4PT.FOR;
$! 'F$VERIFY(0)
$!
$ CMD:	IF .NOT. CLD THEN GOTO LNK
$	SET VERIFY
$!
$	ADC LAPROCESS.TMP=LAPROCESS.CLD
$	SET COMMAND/OBJECT=LAPROCESS_CLD LAPROCESS.TMP
$	PVV LAPROCESS_CLD
$	DELETE ADC.IDE;*
$	DELETE LAPROCESS.TMP;*
$	PURGE LAPROCESS_CLD.OBJ
$! 'F$VERIFY(0)
$!
$ LNK:	IF .NOT. LNK THEN GOTO TIDY
$	SET VERIFY
$!
$	LINK/MAP'LDEB' -
		LAPROCESS,LAPROCESS_CLD,DM4PT,LAPROCESS.PROMSG_OBJ, -
		LSL$LIBRARY:IFFLIB/LIB,LSLLIB/LIB,TRANLIB/LIB
$	PURGE LAPROCESS.EXE,.MAP
$ TIDY:	! 'F$VERIFY(V)'
