$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1988-07-12 12:09:18.000000000 +0100
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
OFFSET 40 400
iff diag_2
title fc text 1005
title move 140 480
title text 0 ORIGINAL
title fc text 1003
title move 140 420
title text 0 1 IFF unit
title fc line 75
title move 150 428
title line 150 432
title move 150 430
title line 160 430
title move 160 428
title line 160 432

offset 320 400 
iff diag_2_ak1
title fc text 1005
title move 330 480
title text 0 AKIMA
title fc text 1003
title move 330 460
title text 0 SEPARATION : 2.0
title move 330 455
title text 0 CHORD      : 0.0
title move 330 450
title text 0 DEVIATION  : 0.0
title move 330 420
title text 0 1 IFF unit
title fc line 75
title move 340 428
title line 340 432
title move 340 430
title line 350 430
title move 350 428
title line 350 432

offset 40 240 
iff diag_2_ak2
title fc text 1005
title move 140 320
title text 0 AKIMA
title fc text 1003
title move 140 310
title text 0 SEPARATION : 1.0
title move 140 305
title text 0 CHORD      : 0.0
title move 140 300
title text 0 DEVIATION  : 0.0
title move 140 270
title text 0 1 IFF unit
title fc line 75
title move 150 278
title line 150 282
title move 150 280
title line 160 280
title move 160 278
title line 160 282

offset 230 240 
iff diag_2_ak3
title fc text 1005
title move 330 320
title text 0 AKIMA
title fc text 1003
title move 330 310
title text 0 SEPARATION : 0.5
title move 330 305
title text 0 CHORD      : 0.0
title move 330 300
title text 0 DEVIATION  : 0.0
title move 330 270
title text 0 1 IFF unit
title fc line 75
title move 340 278
title line 340 282
title move 340 280
title line 350 280
title move 350 278
title line 350 282

offset 40 80 
iff diag_2_ak4
title fc text 1005
title move 140 160
title text 0 AKIMA
title fc text 1003
title move 140 140
title text 0 SEPARATION : 0.5
title move 140 135
title text 0 CHORD      : 0.0
title move 140 130
title text 0 DEVIATION  : 0.0
title move 140 100
title text 0 1 IFF unit
title fc line 75
title move 150 108
title line 150 112
title move 150 110
title line 160 110
title move 160 108
title line 160 112

offset 230 80
iff diag_2_ak5
title fc text 1005
title move 330 160
title text 0 AKIMA
title fc text 1003
title move 330 140
title text 0 SEPARATION : 0.5
title move 330 135
title text 0 CHORD      : 0.0
title move 330 130
title text 0 DEVIATION  : 0.0
title move 330 100
title text 0 1 IFF unit
title fc line 75
title move 340 108
title line 340 112
title move 340 110
title line 350 110
title move 350 108
title line 350 112
