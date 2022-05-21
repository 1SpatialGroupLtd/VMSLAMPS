$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-07-12 12:05:58.000000000 +0100
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
frt ron
tri os
sri os
scale factor 10
enlarge 2
pos 0
OFFSET 0 240
iff diag_2
title fc text 1005
title move 110 270
title text 0 Original input

offset 170 240 
iff diag_2_ak1
title move 280 270
title text 0 AKIMA interpolation
title fc text 1003
title move 280 260
title text 0 SEPARATION : 2.0
title move 280 255
title text 0 CHORD      : 0.0
title move 280 250
title text 0 DEVIATION  : 0.0

offset 0 0
iff diag_2_ak4
title move 10 20
title text 0 Diag 2 ak4
