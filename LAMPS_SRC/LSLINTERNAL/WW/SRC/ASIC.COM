$	xxx:='f$verify(0)'
$	xxx=f$logical("ic$lib")
$	if xxx.nes."" then deassign ic$lib
$	if p1.nes."" then p1=";"+p1
$	ass lsl$disk:[devt]iclib.dat'p1' ic$lib
$	show logical ic$lib
