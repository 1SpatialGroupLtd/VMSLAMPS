$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 2002-10-17 10:35:22.000000000 +0100
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
$! Setup file for dummy Display PostScript libraries
$! Author Paul Hardy, September 2002	PGH	23-Sep-2002
$! Modified				PGH	17-Oct-2002
$!
$! Only for use of VMS 7.3 or later, without Display PostScript support
$!
$! Invoke from LSDEFNS.COM, or remove /System and call at login time.
$!
$ Define/System XDPS$DPSBINDINGSSHR LSL$LIBRARY:DPSDUMMYSHR
$ Define/System XDPS$DPSBINDINGSSHR_TV LSL$LIBRARY:DPSDUMMYSHR_TV
$ Define/System XDPS$DPSCLIENTSHR LSL$LIBRARY:DPSDUMMYSHR
$ Define/System XDPS$DPSCLIENTSHR_TV LSL$LIBRARY:DPSDUMMYSHR_TV
$ Define/System XDPS$DPSLIBSHR LSL$LIBRARY:DPSDUMMYSHR
$ Define/System XDPS$DPSLIBSHR_TV LSL$LIBRARY:DPSDUMMYSHR_TV
$!
