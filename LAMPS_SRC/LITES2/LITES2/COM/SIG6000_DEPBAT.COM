$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-04 14:24:26.000000000 +0100
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
$	LIBR/CREATE SIG6000
$	PURGE/KEEP=2 SIG6000.OLB
$	set noon
$!  +++++  LSL hardware dependant routines  +++++
$	clites2 TABINIT SIG6000
$	clites2 BITINIT SIG6000
$	clites2 GTDGXY SIG6000
$	clites2 SCRINIT SIG6000
$	clites2 LCLSG SIG6000
$	clites2 LCRSG SIG6000
$	clites2 LDSG SIG6000
$	clites2 LSVIS SIG6000
$	clites2 LSALLV SIG6000
$	clites2 LSALLI SIG6000
$	clites2 LRSGWK SIG6000
$	clites2 LUWK SIG6000
$	clites2 STDINI SIG6000
$	clites2 HARCOP SIG6000
$	clites2 BALINIT SIG6000
$	clites2 NOT_SUPPORTED SIG6000
$	clites2 BUTINIT SIG6000
$	clites2 SCREEN SIG6000
$	clites2 DSRINIT SIG6000
$	clites2 INTERACT SIG6000
$	clites2 RFDRAW SIG6000
$	clites2 TSTWK SIG6000
$	clites2 TSTSEG SIG6000
$	clites2 INIWK SIG6000
$	clites2 CLSWK SIG6000
$	clites2 LSCR SIG6000
$	clites2 FLOAD SIG6000
$	clites2 KRSINIT SIG6000
$	clites2 PING SIG6000
$	clites2 BOXTXT SIG6000
$	clites2 RFBAND SIG6000
$	clites2 RFMOVE SIG6000
$	clites2 TEXT SIG6000
$	clites2 SETLIN_SIGMEX SIG6000
$	clites2 FOLLOW_COORD SIG6000
$!
$	MACRO/NOLIST LSL$LITES2_ROOT:[SIG6000]SIG6000_OVERLAY_DUMMY
$	PURGE SIG6000_OVERLAY_DUMMY.OBJ
$	LIBR/REPLACE SIG6000  SIG6000_OVERLAY_DUMMY
$	DELETE SIG6000_OVERLAY_DUMMY.OBJ;*
$!
$	set def 'SAVDIR'
$	exit
