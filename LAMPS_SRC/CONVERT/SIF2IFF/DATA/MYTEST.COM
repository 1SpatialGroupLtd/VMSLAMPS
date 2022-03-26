$ set nover
$ convertini q
$ define sys$input sys$command
$ sif2iff == "$lsl$source_root:[convert.sif2iff]sif2iff"
$ set ver
!$ sif2iff /debug/log/par=sif.fdf here:sifoutput.sif here:
!$ sif2iff /log/par=here:sif.fdf here:tji_test.sif here:tji_test
$ sif2iff /log/par=here:sif.fdf here:siftest2.sif here:sifoutput
$set nover
$pur
