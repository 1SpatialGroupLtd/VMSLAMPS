$!
$! Command procedure to run IFILTER to generate documentation diagrams
$! These sets use BEZIER interpolation
$!
$! First set with HUG parameter being varied
$!  
$ sd lsl$source_root:[imp.ifilter]  
$ si here
$ ifilterx=="$z2:ifilterx/bezier=(hug:0.000)/fc=74/nodp diag_2 diag_2_be1"
$ ifilterx
go
quit
$ ifilterx=="$z2:ifilterx/bezier=(hug:0.250)/fc=74/nodp diag_2 diag_2_be2"
$ ifilterx
go
quit
$ ifilterx=="$z2:ifilterx/bezier=(hug:0.500)/fc=74/nodp diag_2 diag_2_be3"
$ ifilterx
go
quit
$ ifilterx=="$z2:ifilterx/bezier=(hug:0.750)/fc=74/nodp diag_2 diag_2_be4"
$ ifilterx
go
quit
$ ifilterx=="$z2:ifilterx/bezier=(hug:1.000)/fc=74/nodp diag_2 diag_2_be5"
$ ifilterx
go
quit
$!
$! Second set with CHORD parameter being varied
$!  
$ ifilterx=="$z2:ifilterx/bezier=(cho:0.16)/fc=74/nodp diag_2 diag_2_be6"
$ ifilterx
go
quit
$ ifilterx=="$z2:ifilterx/bezier=(cho:0.08)/fc=74/nodp diag_2 diag_2_be7"
$ ifilterx
go
quit
$ ifilterx=="$z2:ifilterx/bezier=(cho:0.04)/fc=74/nodp diag_2 diag_2_be8"
$ ifilterx
go
quit
$ ifilterx=="$z2:ifilterx/bezier=(cho:0.02)/fc=74/nodp diag_2 diag_2_be9"
$ ifilterx
go
quit
$ ifilterx=="$z2:ifilterx/bezier=(cho:0.01)/fc=74/nodp diag_2 diag_2_be10"
$ ifilterx
go
quit
$! The End
