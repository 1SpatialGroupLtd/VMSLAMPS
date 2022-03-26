$!
$! Command procedure to run IFILTER to generate documentation diagrams
$! These sets use LINEAR interpolation
$!
$! First set with SEPARATION parameter being varied
$!  
$ sd lsl$source_root:[imp.ifilter]  
$ si here
$ impini q
$ ifilter/linear=(sep:2.000)/fc=74/nodp diag_2 diag_2_li1
$ ifilter/linear=(sep:1.000)/fc=74/nodp diag_2 diag_2_li2
$ ifilter/linear=(sep:0.500)/fc=74/nodp diag_2 diag_2_li3
$ ifilter/linear=(sep:0.250)/fc=74/nodp diag_2 diag_2_li4
$ ifilter/linear=(sep:0.125)/fc=74/nodp diag_2 diag_2_li5
