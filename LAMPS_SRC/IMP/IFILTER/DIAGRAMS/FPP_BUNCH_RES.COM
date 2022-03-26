frt ron
tri os
sri os
scale factor 10
enlarge 2.1
pos 0
OFFSET 40 400
iff diag
title fc text 1003
title move 50 410
title text 0 ORIGINAL
title move 150 420
title text 0 1 IFF unit
title fc line 75
title move 150 428
title line 150 432
title move 150 430
title line 160 430
title move 160 428
title line 160 432

offset 230 400 
iff diag_bu11
title fc text 1003
title move 240 410
title text 0 BUNCH=(MIN SEP:0.125,LAT:0.01,RES:0.125)/NODP
title move 340 420
title text 0 1 IFF unit
title fc line 75
title move 340 428
title line 340 432
title move 340 430
title line 350 430
title move 350 428
title line 350 432

offset 40 240 
iff diag_bu12
title fc text 1003
title move 50 250
title text 0 BUNCH=(MIN SEP:0.125,LAT:0.01,RES:0.25)/NODP
title move 150 260
title text 0 1 IFF unit
title fc line 75
title move 150 268
title line 150 272
title move 150 270
title line 160 270
title move 160 268
title line 160 272

offset 230 240 
iff diag_bu13
title fc text 1003
title move 240 250
title text 0 BUNCH=(MIN SEP:0.125,LAT:0.01,RES:0.5)/NODP
title move 340 260
title text 0 1 IFF unit
title fc line 75
title move 340 268
title line 340 272
title move 340 270
title line 350 270
title move 350 268
title line 350 272

offset 40 80 
iff diag_bu14
title fc text 1003
title move 50 90
title text 0 BUNCH=(MIN SEP:0.125,LAT:0.01,RES:1.0)/NODP
title move 150 100
title text 0 1 IFF unit
title fc line 75
title move 150 108
title line 150 112
title move 150 110
title line 160 110
title move 160 108
title line 160 112

offset 230 80
iff diag_bu15
title fc text 1003
title move 240 90
title text 0 BUNCH=(MIN SEP:0.125,LAT:0.01,RES:2.0)/NODP
title move 340 100
title text 0 1 IFF unit
title fc line 75
title move 340 108
title line 340 112
title move 340 110
title line 350 110
title move 350 108
title line 350 112
title fc text 1007
title move 20 20
title text 0 FIG. 8   BUNCH filter varying RESOLUTION.
