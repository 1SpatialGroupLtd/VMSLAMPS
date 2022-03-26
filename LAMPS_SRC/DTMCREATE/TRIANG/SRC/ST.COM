 
$triang
disable square
fileout st_out
maxpoint 70000
window 845000 800000 860000 824000  !whole window
!window 845000 800000 850950 810000  !south window
!window 845000 810000 852133 824000  !west window
!window 852323 812000 860000 824000  !east window
ena integer_height
zlimits 0 1000
filein  st
ena diag
ena graphics
disable constraint
show enable
go
$!
$!del *.dta;*
$!del *.nod;*
$!del *.der;*
