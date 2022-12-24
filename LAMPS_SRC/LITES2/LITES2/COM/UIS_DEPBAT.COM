$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-08-04 13:24:24.000000000 +0100
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
$	LIBR/CREATE UIS
$	PURGE/KEEP=2 UIS.OLB
$	set noon
$!  +++++  LSL hardware dependant routines  +++++
$	clites2 TABINIT UIS
$	clites2 BITINIT UIS
$	clites2 GTDGXY UIS
$	clites2 MENU UIS
$	clites2 LCLSG UIS
$	clites2 LCRSG UIS
$	clites2 LDSG UIS
$	clites2 LSVIS UIS
$	clites2 SCRINIT UIS
$	clites2 LSALLV UIS
$	clites2 LSALLI UIS
$	clites2 LRSGWK UIS
$	clites2 CLSWK UIS
$	clites2 DSRINIT UIS
$	clites2 KRSINIT UIS
$	clites2 SAVDIS UIS
$	clites2 SAVLUT UIS
$	clites2 FOLLOW_COORD UIS
$	clites2 DISPLAY UIS
$	clites2 VIEW UIS
$	clites2 STDINI UIS
$	clites2 HARCOP UIS
$	clites2 BALINIT UIS
$	clites2 MOUSE UIS
$	clites2 BUTINIT UIS
$	clites2 BUTTONS UIS
$	clites2 LUWK UIS
$	clites2 LITSRI UIS
$	clites2 INTERACT UIS
$	clites2 RFDRAW UIS
$	clites2 TSTWK UIS
$	clites2 TSTSEG UIS
$	clites2 PICT UIS
$	clites2 NOT_SUPPORTED UIS
$	clites2 BOXTXT UIS
$	clites2 INIWK UIS
$	clites2 PING UIS
$	clites2 LSCR UIS
$	clites2 RFMOVE UIS
$!
$	MACRO/NOLIST LSL$LITES2_ROOT:[UIS]UIS_DUMMY
$	PURGE UIS_DUMMY.OBJ
$	LIBR/REPLACE UIS  UIS_DUMMY
$	DELETE UIS_DUMMY.OBJ;*
$!
$	set def 'SAVDIR'
$	exit
