$! command file to build shared image for SSPI stereoplotter input to LITES2
$! VIAK version					PGH	14-May-1990
$!
$ Set verify
$!
$! first compile and link the shared image
$!
$ Fort DSR_SSPI.F
$ Purge DSR_SSPI.*
$!
$ Link/share/exe=LITES2SSPISHR/map=LITES2SSPISHR/full -
	sys$input:/opt
unsupported=1	! force demand_zero compression of shared images
DSR_SSPI
!
universal = DSR_INIT
universal = DSR_READ
universal = DSR_MOVE
universal = DSR_START
universal = DSR_TRN
$!
$ Purge LITES2SSPISHR.EXE,LITES2SSPISHR.MAP
$!
$! and now the test program
$!
$ Fort TEST_SSPI.F
$ Link TEST_SSPI,DSR_SSPI
$ Purge TEST_SSPI.*
$!
$ Set noverify
$!
