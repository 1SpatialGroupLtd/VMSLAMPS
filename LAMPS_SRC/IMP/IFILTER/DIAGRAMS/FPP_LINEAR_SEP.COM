frt ron
tri os
sri os
scale factor 10
enlarge 2
pos 0
OFFSET 40 400
iff diag_2
title fc text 1005
title move 50 410
title text 0 ORIGINAL
title move 140 420
title text 0 1 IFF unit
title fc line 75
title move 150 428
title line 150 432
title move 150 430
title line 160 430
title move 160 428
title line 160 432

offset 230 400 
iff diag_2_li1
title fc text 1005
title move 240 410
title text 0 LINEAR=(SEPARATION:2.0)/NODP
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
iff diag_2_li2
title fc text 1005
title move 50 250
title text 0 LINEAR=(SEPARATION:1.0)/NODP
title move 140 260
title text 0 1 IFF unit
title fc line 75
title move 150 268
title line 150 272
title move 150 270
title line 160 270
title move 160 268
title line 160 272

offset 230 240 
iff diag_2_li3
title fc text 1005
title move 240 250
title text 0 LINEAR=(SEPARATION:0.5)/NODP
title move 330 260
title text 0 1 IFF unit
title fc line 75
title move 340 268
title line 340 272
title move 340 270
title line 350 270
title move 350 268
title line 350 272

offset 40 80 
iff diag_2_li4
title fc text 1005
title move 50 90
title text 0 LINEAR=(SEPARATION:0.25)/NODP
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
iff diag_2_li5
title fc text 1005
title move 240 90
title text 0 LINEAR=(SEPARATION:0.125)/NODP
title move 330 100
title text 0 1 IFF unit
title fc line 75
title move 340 108
title line 340 112
title move 340 110
title line 350 110
title move 350 108
title line 350 112
