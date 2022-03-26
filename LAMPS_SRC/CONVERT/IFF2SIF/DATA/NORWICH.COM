$!
$set ver
$	iff2sif/scitex
sdf HERE:NORWICH.SDF;
frt HERE:NORWICH.FRT;
dim 2
sheetscale 2500
uorunit 0.001
nomagtape
output HERE:NORWICH.sif
iff HERE:NORWICH.IFF;
