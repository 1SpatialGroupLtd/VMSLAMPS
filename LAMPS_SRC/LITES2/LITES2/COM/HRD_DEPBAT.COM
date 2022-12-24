$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-05 14:13:04.000000000 +0100
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
$	SAVDIR = f$environment("DEFAULT")
$	set def OBJ:
$	LIBR/CREATE HRD
$	PURGE/KEEP=2 HRD.OLB
$	set noon
$!  +++++  LSL hardware dependant routines  +++++
$	clites2 TABINIT HRD
$	clites2 BITINIT HRD
$	clites2 GTDGXY HRD
$	clites2 SCRINIT HRD
$	clites2 LCLSG HRD
$	clites2 LCRSG HRD
$	clites2 LDSG HRD
$	clites2 LSVIS HRD
$	clites2 LSALLV HRD
$	clites2 LSALLI HRD
$	clites2 LRSGWK HRD
$	clites2 LUWK HRD
$	clites2 STDINI HRD
$	clites2 HARCOP HRD
$	clites2 BALINIT HRD
$	clites2 NOT_SUPPORTED HRD
$	clites2 INTERACT HRD
$	clites2 RFDRAW HRD
$	clites2 TSTWK HRD
$	clites2 TSTSEG HRD
$	clites2 INIWK HRD
$	clites2 CLSWK HRD
$	clites2 LSCR HRD
$	clites2 BUTINIT HRD
$	clites2 PING HRD
$	clites2 BOXTXT HRD
$	clites2 RFBAND HRD
$	clites2 DSRINIT HRD
$	clites2 FOLLOW_COORD HRD
$	clites2 KRSINIT HRD
$!
$	MACRO/NOLIST LSL$LITES2_ROOT:[HRD]HRD_GETPCC
$	PURGE HRD_GETPCC.OBJ
$	LIBR/REPLACE HRD HRD_GETPCC
$	DELETE HRD_GETPCC.OBJ;*
$	MACRO/NOLIST MAR:OVERLAY_DUMMY
$	PURGE OVERLAY_DUMMY.OBJ
$	LIBR/REPLACE HRD  OVERLAY_DUMMY
$	DELETE OVERLAY_DUMMY.OBJ;*
$!
$	set def 'SAVDIR'
$	exit
