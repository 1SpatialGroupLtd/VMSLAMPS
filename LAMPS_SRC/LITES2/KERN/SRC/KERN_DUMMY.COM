$ inquire DSR "Compile DSR"
$ inquire KRISS "Compile KRISS"
$ inquire LKRISS "Link KRISS"
$ sd obj
$ if DSR
$ then
$   open/write tr spot.tr
$   write tr "SPOT = 0"
$   close tr
$   adc xdsr_dummy=spot.tr/tr,lsl$source_root:[lites2.kern]dsr_dummy
$   fortran xdsr_dummy
$   pvv xdsr_dummy
$   delete spot.tr;*,adc.ide;*,xdsr_dummy.for;*
$   pl xdsr_dummy.obj
$ endif
$!
$ if KRISS
$ then
$   adc xkriss_dummy=lsl$source_root:[lites2.kern]kriss_dummy
$   fortran xkriss_dummy
$   pvv xkriss_dummy
$   delete adc.ide;*,xkriss_dummy.for;*
$   pl xkriss_dummy.obj
$ endif
$!
$ if LKRISS
$ then
$   sd obj:
$   link/share/exe=exe:lites2kriss_dummyshr/map=lites2kriss_dummyshr/full -
	sys$input:/opt, -
	lsl$library:lslshr/opt
UNSUPPORTED=1
XDSR_DUMMY,XKRISS_DUMMY
!
universal = DSR_INIT
universal = DSR_READ
universal = DSR_MOVE
universal = DSR_START
universal = DSR_TRN
universal = KRISS_INIT
universal = KRISS_DISMOD
universal = KRISS_GPL
universal = KRISS_UPDATE
universal = KRISS_REFRSH
universal = KRISS_RFSTOP
universal = KRISS_VISIBLE
universal = KRISS_VECT
universal = KRISS_RECT
universal = KRISS_TRACK
universal = KRISS_STOP
universal = KRISS_SIDE
universal = KRISS_SUSPEND
universal = KRISS_REGIST
!
$   sd exe:
$   purge lites2kriss_dummyshr.exe,obj:lites2kriss_dummyshr.map
$ endif
$!
