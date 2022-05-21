$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-04-27 17:29:50.000000000 +0100
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
$! Command procedure to create .OLB for use with PLOTR program
$!
$  Lib/create PLOTR
$
$  Lib/ins PLOTR -
           PLOTR_002,-
           PLOTR_011,-
           PLOTR_11A,-
           PLOTR_012,-
           PLOTR_016,-
           PLOTR_101,-
           PLOTR_110,-
           PLOTR_130,-
           PLOTR_200,-
           PLOTR_201,-
           PLOTR_203,-
           PLOTR_204,-
           PLOTR_240,-
           PLOTR_241,-
           PLOTR_242,-
           PLOTR_243
$
$  Del/noconf PLOTR_*.OBJ;*/excl=PLOTR_000.OBJ
