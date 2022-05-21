$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-04 14:24:28.000000000 +0100
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
$	LIBR/CREATE TEK4100
$	PURGE/KEEP=2 TEK4100.OLB
$	set noon
$!  +++++  LSL hardware dependant routines  +++++
$	clites2 TABINIT TEK4100
$	clites2 BITINIT TEK4100
$	clites2 GTDGXY TEK4100
$	clites2 SCRINIT TEK4100
$	clites2 LCLSG TEK4100
$	clites2 LCRSG TEK4100
$	clites2 LDSG TEK4100
$	clites2 LSVIS TEK4100
$	clites2 SCREEN TEK4100
$	clites2 LSALLV TEK4100
$	clites2 LSALLI TEK4100
$	clites2 LRSGWK TEK4100
$	clites2 LUWK TEK4100
$	clites2 STDINI TEK4100
$	clites2 HARCOP TEK4100
$	clites2 BALINIT TEK4100
$	clites2 DSRINIT TEK4100
$	clites2 INTERACT TEK4100
$	clites2 RFDRAW TEK4100
$	clites2 TSTWK TEK4100
$	clites2 TSTSEG TEK4100
$	clites2 INIWK TEK4100
$	clites2 CLSWK TEK4100
$	clites2 LSCR TEK4100
$	clites2 BUTINIT TEK4100
$	clites2 NOT_SUPPORTED TEK4100
$	clites2 PING TEK4100
$	clites2 BOXTXT TEK4100
$	clites2 RFBAND TEK4100
$	clites2 RFMOVE TEK4100
$	clites2 WESTWARD TEK4100
$	clites2 FOLLOW_COORD TEK4100
$	clites2 KRSINIT TEK4100
$!
$	MACRO/NOLIST MAR:OVERLAY_DUMMY
$	PURGE OVERLAY_DUMMY.OBJ
$	LIBR/REPLACE TEK4100  OVERLAY_DUMMY
$	DELETE OVERLAY_DUMMY.OBJ;*
$!
$	set def 'SAVDIR'
$	exit
