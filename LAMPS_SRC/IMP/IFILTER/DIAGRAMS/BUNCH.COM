$!
$! Command procedure to run IFILTER to generate documentation diagrams
$! These sets use BUNCH filter
$!
$! First set with MIN_SEP parameter being varied
$!  
$ sd lsl$source_root:[imp.ifilter]  
$ si here
$ impini q
$ ifilter/bunch=(min_sep:0.01,lat:0.01)/fc=74/nodp diag diag_bu1
$ ifilter/bunch=(min_sep:0.02,lat:0.01)/fc=74/nodp diag diag_bu2
$ ifilter/bunch=(min_sep:0.04,lat:0.01)/fc=74/nodp diag diag_bu3
$ ifilter/bunch=(min_sep:0.08,lat:0.01)/fc=74/nodp diag diag_bu4
$ ifilter/bunch=(min_sep:0.16,lat:0.01)/fc=74/nodp diag diag_bu5
$!
$! Second set with LATITUDE parameter being varied
$!  
$! ifilter/bunch=(min_sep:0.0625,lat:0.0625)/fc=74/nodp diag diag_bu6
$! ifilter/bunch=(min_sep:0.125,lat:0.125)/fc=74/nodp diag diag_bu7
$! ifilter/bunch=(min_sep:0.25,lat:0.25)/fc=74/nodp diag diag_bu8
$! ifilter/bunch=(min_sep:0.5,lat:0.5)/fc=74/nodp diag diag_bu9
$! ifilter/bunch=(min_sep:1.0,lat:1.0)/fc=74/nodp diag diag_bu10
$!
$! Third set with RESOLUTION parameter being varied
$!  
$! ifilter/bunch=(min_sep:0.125,lat:0.01,res:0.125)/fc=74/nodp diag diag_bu11
$! ifilter/bunch=(min_sep:0.125,lat:0.01,res:0.25)/fc=74/nodp diag diag_bu12
$! ifilter/bunch=(min_sep:0.125,lat:0.01,res:0.5)/fc=74/nodp diag diag_bu13
$! ifilter/bunch=(min_sep:0.125,lat:0.01,res:1.0)/fc=74/nodp diag diag_bu14
$! ifilter/bunch=(min_sep:0.125,lat:0.01,res:2.0)/fc=74/nodp diag diag_bu15
