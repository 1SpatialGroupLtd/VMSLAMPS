$!
$! Command procedure to run IFILTER to generate documentation diagrams
$! These sets use AKIMA interpolation
$!
$! First set with SEPARATION parameter being varied
$!  
$ sd lsl$source_root:[imp.ifilter]  
$ si here
$ impini q
$ ifilter/akima=(sep:2.000)/fc=74/nodp diag_2 diag_2_ak1
$ ifilter/akima=(sep:1.000)/fc=74/nodp diag_2 diag_2_ak2
$ ifilter/akima=(sep:0.500)/fc=74/nodp diag_2 diag_2_ak3
$ ifilter/akima=(sep:0.250)/fc=74/nodp diag_2 diag_2_ak4
$ ifilter/akima=(sep:0.125)/fc=74/nodp diag_2 diag_2_ak5
$!
$! Second set with CHORD parameter being varied
$!  
$ ifilter/akima=(cho:0.16)/fc=74/nodp diag_2 diag_2_ak6
$ ifilter/akima=(cho:0.08)/fc=74/nodp diag_2 diag_2_ak7
$ ifilter/akima=(cho:0.04)/fc=74/nodp diag_2 diag_2_ak8
$ ifilter/akima=(cho:0.02)/fc=74/nodp diag_2 diag_2_ak9
$ ifilter/akima=(cho:0.01)/fc=74/nodp diag_2 diag_2_ak10
$!
$! Third set with DEVIATION parameter being varied
$!  
$ ifilter/akima=(dev:0.8)/fc=74/nodp diag_2 diag_2_ak11
$ ifilter/akima=(dev:0.4)/fc=74/nodp diag_2 diag_2_ak12
$ ifilter/akima=(dev:0.2)/fc=74/nodp diag_2 diag_2_ak13
$ ifilter/akima=(dev:0.1)/fc=74/nodp diag_2 diag_2_ak14
$ ifilter/akima=(dev:0.05)/fc=74/nodp diag_2 diag_2_ak15
