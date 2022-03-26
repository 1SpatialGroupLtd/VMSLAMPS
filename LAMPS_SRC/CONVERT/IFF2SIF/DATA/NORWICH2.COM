$!
$set ver
$	iff2sif
sdf HERE:NORWICH.SDF;
frt HERE:NORWICH.FRT;
dim 2
sheetscale 2500
uorunit 0.001
nomagtape
output HERE:norwich.sif
iff HERE:NORWICH.IFF;
