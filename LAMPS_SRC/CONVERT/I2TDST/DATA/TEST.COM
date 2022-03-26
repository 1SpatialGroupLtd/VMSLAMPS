$! Andrew Verrill, 7 Jun 90
$! Test real version of istdst.
$!
$ i2*tdst==	"$lsl$source_root:[convert.i2tdst]i2tdst"
$ i2	lsl$data_root:[lsl.dst]malaysia.ilf-
 	lsl$data_root:[lsl.dst]malaysia.dst-
 /frt=	lsl$data_root:[lsl.dst]laserscan_plot.frt-
 /bnt=	lsl$data_root:[lsl.dst]malay.bnt
