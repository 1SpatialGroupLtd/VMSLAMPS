$!
$! Command procedure to run IFILTER to generate documentation diagrams
$! These sets use DP filter
$!
$ sd lsl$source_root:[imp.ifilter]  
$ si here
$ impini q
$!
$! LATITUDE parameter being varied
$!  
$ ifilter/dp=(lat:0.0625)/fc=74 diag diag_dp1
$ ifilter/dp=(lat:0.125)/fc=74 diag diag_dp2
$ ifilter/dp=(lat:0.25)/fc=74 diag diag_dp3
$ ifilter/dp=(lat:0.5)/fc=74 diag diag_dp4
$ ifilter/dp=(lat:1.0)/fc=74 diag diag_dp5
