$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 2002-09-23 16:32:58.000000000 +0100
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
$ MACRO DPSDUMVEC
$ LINK/SHARE/EXE=DPSDUMMYSHR/MAP=DPSDUMMYSHR/FULL SYS$INPUT:/OPT
!
! Place the transfer vector first in its own cluster
cluster=TRANSFER,,,DPSDUMVEC.OBJ
!
! Set the global section match parameters (major id., minor id.)
gsmatch=lequal,2,9
!
$ purge/log
$!
$! 'f$verify(ver)
