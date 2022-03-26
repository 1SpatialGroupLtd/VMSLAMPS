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
