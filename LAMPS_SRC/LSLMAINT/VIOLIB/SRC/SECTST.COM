$	IF P1.EQS."" THEN -	!'F$VERIFY(1)
$	FORTRAN/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW) SECTST.SRC
$	LINK/DEBUG SECTST,FILSEC,VIOLIB/LIB
$	V='F$VERIFY(0)
$	IF F$SEARCH("SECTST.OBJ;-1")+F$SEARCH("SECTST.EXE;-1").NES."" THEN -
$	PURGE SECTST.OBJ,.EXE