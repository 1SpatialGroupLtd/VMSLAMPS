$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-11-18 15:41:28.000000000 +0000
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
$ MACRO LSLVEC
$ MACRO LSLGLOB
$ LINK/SHARE/EXE=LSLSHR/MAP=LSLSHR/FULL SYS$INPUT:/OPT
!
! Place the transfer vector first in its own cluster
cluster=TRANSFER,,,LSLVEC.OBJ
!
! Then a cluster into which public common blocks are collected
cluster=CMNPUB
collect=CMNPUB,LSL_CLD,LSL_CLDCHR,LSL_CMDCOM,LSL_EXCEPTION
collect=CMNPUB,LSL_EXPC,LSL_FNAM_LEN,LSL_FNAM_LOG
collect=CMNPUB,LSL_FNAM_STR,LSL_MTIVCM,LSL_MTOVCM,LSL_REPORT
collect=CMNPUB,LSL_STATUS,LSL_TXTC,LSL_WINDEF
!
! Make universal our symbols from LSLGLOB
universal=LSL_CLD,LSL_CLDCHR,LSL_CMDCOM,LSL_EXCEPTION,-
LSL_EXPC,LSL_FNAM_LEN,LSL_FNAM_LOG,-
LSL_FNAM_STR,LSL_MTIVCM,LSL_MTOVCM,LSL_REPORT,-
LSL_STATUS,LSL_TXTC,LSL_WINDEF
!
! Allow the rest to go into the default cluster
lslglob.obj
lsl$library:lsllib/lib
!
! Set the global section match parameters (major id., minor id.)
! If the major id. is incremented, then programs linked with the old
! version of LSLSHR will not be able to use the new version - this
! should be done if the new version is incompatible with the old.
! If the minor id. is incremented, then programs linked with the old
! version of LSLSHR will still be able to use the new version, but
! not vice-versa - this should be done if an upwards compatible change
! has been made, such as the addition of a new routine, or the addition
! of extra optional arguments to existing routines.
! For changes which are simply bug fixes, the parameters should not be
! changed.
gsmatch=lequal,1,5
!
! Set all the common blocks to be non-shareable
! The public ones are aligned long since Fortran started to default
! to quad, which caused them to move.
psect_attr=LSL_CLD,noshr,long
psect_attr=LSL_CLDCHR,noshr,long
psect_attr=LSL_CMDCOM,noshr,long
psect_attr=LSL_CMDCOM_PRIVATE,noshr
psect_attr=LSL_EXCEPTION,noshr,long
psect_attr=LSL_EXIT_HANDLER,noshr
psect_attr=LSL_EXPC,noshr,long
psect_attr=LSL_FNAM_LEN,noshr,long
psect_attr=LSL_FNAM_LOG,noshr,long
psect_attr=LSL_FNAM_STR,noshr,long
psect_attr=LSL_INEQUAL,noshr
psect_attr=LSL_MTIVCM,noshr,long
psect_attr=LSL_MTOVCM,noshr,long
psect_attr=LSL_REPORT,noshr,long
psect_attr=LSL_STATUS,noshr,long
psect_attr=LSL_TABLE_DEFINITION,noshr
psect_attr=LSL_TXTC,noshr,long
psect_attr=LSL_WINDEF,noshr,long
$ purge/log
$!
$! 'f$verify(ver)
