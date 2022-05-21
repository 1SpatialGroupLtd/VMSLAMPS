$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1993-10-25 13:45:30.000000000 +0000
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
$! fetch all LITES2 sources from the CMS
$! (except the obj group, which only contains MAPIDs)
$! P1 (optional) = CMS class to fetch
$ ws = "write sys$output"
$ sd lsl$lites2_root:[000000]
$ if p1.nes."" then p1 = "/generation="+p1
$ groups = "cmn,com,exe,hlp,mar,src,hrd,motif,sig6000,tek4100,tek_args,uis"
$ n = 0
$ next:
$   group = f$element(n,",",groups)
$   if group.eqs."," then goto exit
$   call fetch 'group' 'p1'
$   n = n+1
$   goto next
$!
$ exit: exit
$!
$fetch: subroutine
$ ws "Fetching group ",p1,p2
$ CMS fetch/nolog 'p1''p2' /output=['p1'] ""
$ return
$ endsubroutine
