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
