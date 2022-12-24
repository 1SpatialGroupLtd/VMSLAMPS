$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1992-02-20 11:54:46.000000000 +0000
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
 
$triang
disable square
fileout st_out
maxpoint 70000
window 845000 800000 860000 824000  !whole window
!window 845000 800000 850950 810000  !south window
!window 845000 810000 852133 824000  !west window
!window 852323 812000 860000 824000  !east window
ena integer_height
zlimits 0 1000
filein  st
ena diag
ena graphics
disable constraint
show enable
go
$!
$!del *.dta;*
$!del *.nod;*
$!del *.der;*
