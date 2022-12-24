$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-04 13:24:26.000000000 +0100
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
$	LIBR/CREATE TEK_ARGS
$	PURGE/KEEP=2 TEK_ARGS.OLB
$	set noon
$!  +++++  LSL hardware dependant routines  +++++
$	clites2 TABINIT TEK_ARGS
$	clites2 BITINIT TEK_ARGS
$	clites2 GTDGXY TEK_ARGS
$	clites2 RFMOVE TEK_ARGS
$	clites2 LCLSG TEK_ARGS
$	clites2 LCRSG TEK_ARGS
$	clites2 LDSG TEK_ARGS
$	clites2 LSVIS TEK_ARGS
$	clites2 SCRINIT TEK_ARGS
$	clites2 BUTINIT TEK_ARGS
$	clites2 LUWK TEK_ARGS
$	clites2 DSRINIT TEK_ARGS
$	clites2 KRSINIT TEK_ARGS
$	clites2 FOLLOW_COORD TEK_ARGS
$	clites2 NOT_SUPPORTED TEK_ARGS
$	clites2 LSALLV TEK_ARGS
$	clites2 LSALLI TEK_ARGS
$	clites2 LRSGWK TEK_ARGS
$	clites2 CLSWK TEK_ARGS
$	clites2 STDINI TEK_ARGS
$	clites2 HARCOP TEK_ARGS
$	clites2 BALINIT TEK_ARGS
$	clites2 LSCR TEK_ARGS
$	clites2 INTERACT TEK_ARGS
$	clites2 RFDRAW TEK_ARGS
$	clites2 TSTWK TEK_ARGS
$	clites2 TSTSEG TEK_ARGS
$	clites2 BOXTXT TEK_ARGS
$	clites2 RFBAND TEK_ARGS
$	clites2 INIWK TEK_ARGS
$	clites2 PING TEK_ARGS
$!                                    
$	MACRO/NOLIST LSL$LITES2_ROOT:[TEK_ARGS]TEK_ARGS_DUMMY
$	PURGE TEK_ARGS_DUMMY.OBJ
$	LIBR/REPLACE TEK_ARGS  TEK_ARGS_DUMMY
$	DELETE TEK_ARGS_DUMMY.OBJ;*
$!
$	set def 'SAVDIR'
$	exit
!
