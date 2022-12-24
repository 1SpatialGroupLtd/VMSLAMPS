$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-07-13 10:55:40.000000000 +0100
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
$!
$! Command procedure to run IFILTER to generate documentation diagrams
$! These sets use BEZIER interpolation
$!
$! First set with HUG parameter being varied
$!  
$ sd lsl$source_root:[imp.ifilter]  
$ si here
$ ifilterx=="$z2:ifilterx/bezier=(hug:0.000)/fc=74/nodp diag_2 diag_2_be1"
$ ifilterx
go
quit
$ ifilterx=="$z2:ifilterx/bezier=(hug:0.250)/fc=74/nodp diag_2 diag_2_be2"
$ ifilterx
go
quit
$ ifilterx=="$z2:ifilterx/bezier=(hug:0.500)/fc=74/nodp diag_2 diag_2_be3"
$ ifilterx
go
quit
$ ifilterx=="$z2:ifilterx/bezier=(hug:0.750)/fc=74/nodp diag_2 diag_2_be4"
$ ifilterx
go
quit
$ ifilterx=="$z2:ifilterx/bezier=(hug:1.000)/fc=74/nodp diag_2 diag_2_be5"
$ ifilterx
go
quit
$!
$! Second set with CHORD parameter being varied
$!  
$ ifilterx=="$z2:ifilterx/bezier=(cho:0.16)/fc=74/nodp diag_2 diag_2_be6"
$ ifilterx
go
quit
$ ifilterx=="$z2:ifilterx/bezier=(cho:0.08)/fc=74/nodp diag_2 diag_2_be7"
$ ifilterx
go
quit
$ ifilterx=="$z2:ifilterx/bezier=(cho:0.04)/fc=74/nodp diag_2 diag_2_be8"
$ ifilterx
go
quit
$ ifilterx=="$z2:ifilterx/bezier=(cho:0.02)/fc=74/nodp diag_2 diag_2_be9"
$ ifilterx
go
quit
$ ifilterx=="$z2:ifilterx/bezier=(cho:0.01)/fc=74/nodp diag_2 diag_2_be10"
$ ifilterx
go
quit
$! The End
