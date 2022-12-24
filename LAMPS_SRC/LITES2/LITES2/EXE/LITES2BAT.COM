$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 2001-11-13 09:04:52.000000000 +0000
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
$	ASSIGN EXE:LITES2TR.MAR TR
$	set def LSL$LITES2_ROOT:[OBJ]
$	assign/tran=(c,t) DNFS1:[000000.LITES2.LITES2.V5_1.] LSL$LITES2_ROOT
$	assign LSL$LITES2_ROOT:[OBJ] OBJ
$	assign LSL$LITES2_ROOT:[EXE] EXE
$	assign LSL$LITES2_ROOT:[SRC] SRC
$	assign LSL$LITES2_ROOT:[MAR] MAR
$	assign LSL$LITES2_ROOT:[CMN] CMN
$	assign LSL$LITES2_ROOT:[COM] COM
$	assign LSL$SOURCE_ROOT:[LITES2.GEN] GEN
$	set noon
$!  ++++++++++++++++++  Init   ++++++++++++++++++
$	ADC INIT/CD:CMN:=TR:/TR,SRC:INIT,WRTVER,EXCEPTION,LITES2_SCROLL
$	ADC INIT/AP/CD:CMN:=TR:/TR,SRC:TWOEXH,TWOPUT,CTRLCAST,HADCTRLC
$	ADC INIT/AP/CD:CMN:=TR:/TR,SRC:AUXACT,SERVAUX,STRTAUX,AUXOFF,QIOUP
$	ADC INIT/AP/CD:CMN:=TR:/TR,SRC:INIZONE,ABORTAST,HADBREAK,TSTENC
$	ADC INIT/AP/CD:CMN:=TR:/TR,SRC:GTDONG,TSTCPU,TSTFAC,LICENSED,VTSTAT
$	ADC INIT/AP/CD:CMN:=TR:/TR,SRC:TRNFLN,DOOSSE,GETROUTINE,GETVERSION
$	FORTRAN/NOLIST INIT
$	DELETE INIT.FOR;*
$	PVV INIT
$	DELETE ADC.IDE;*
$	PURGE INIT.OBJ
$	LIBR/REPLACE LITES2  INIT
$	DELETE INIT.OBJ;*
