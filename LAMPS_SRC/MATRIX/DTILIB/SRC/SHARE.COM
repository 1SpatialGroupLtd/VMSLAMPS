$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1997-04-25 12:17:14.000000000 +0100
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
$ ver = f$verify(0)
$ set verify
$ MACRO DTIVEC
$ MACRO DTIGLOB
$ LINK/SHARE/EXE=DTISHR/MAP=DTISHR/FULL SYS$INPUT:/OPT,-
					LSL$LIBRARY:LSLSHR/OPT
!
! Place the transfer vector first in its own cluster
cluster=TRANSFER,,,DTIVEC.OBJ
!
! Then a cluster into which public common blocks are collected
cluster=CMNPUB
collect=CMNPUB,DTIHDR,DTIPROJ
universal=DTIHDR
universal=DTIPROJ
!universal=MD2NAM
!universal=MD2NAMC
!
! Allow the rest to go into the default cluster
DTIGLOB.OBJ
LSL$LIBRARY:DTILIB/lib
!
! Set the global section match parameters (major id., minor id.)
! If the major id. is incremented, then programs linked with the old
! version of DTISHR will not be able to use the new version - this
! should be done if the new version is incompatible with the old.
! If the minor id. is incremented, then programs linked with the old
! version of DTISHR will still be able to use the new version, but
! not vice-versa - this should be done if an upwards compatible change
! has been made, such as the addition of a new routine, or the addition
! of extra optional arguments to existing routines.
! For changes which are simply bug fixes, the parameters should not be
! changed.
!
gsmatch=lequal,1,1
!
! Set all the common blocks to be non-shareable
!
psect_attr=DTIHDR,noshr
psect_attr=DTIPROJ,noshr
psect_attr=MD2NAM,noshr,lcl
psect_attr=MD2NAMC,noshr,lcl
!
$ purge/log
$!
$! 'f$verify(ver)
