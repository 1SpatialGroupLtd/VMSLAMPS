$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-11-30 10:51:08.000000000 +0000
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
FILEIN matrix_accept
ENABLE SYM
ENABLE GRAPHICS
FRT BATTLE
SRI BATTLE
SYMBOL FC 1 1
SYMBOL FC 2 2
SYMBOL FC 3 3
SYMBOL FC 4 4
SYMBOL FC 5 5
SYMBOL FC 6 6
SYMBOL FC 7 9
SYMBOL FC 8 11
SYMBOL FC 9 12
!SET SYM 1500 
!ENABLE FISHNET
ENABLE DIVIDE
ENABLE FOG
HEIGHT 1000
iso
SYMBOL POS 1 10 10
SYMBOL POS 2 20 20
SYMBOL POS 3 30 30
SYMBOL POS 4 40 40
RETURN
