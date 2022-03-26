$ inquire CSTUFF "Compile C stuff"
$ inquire SD2000 "Compile SD2000"
$ inquire COLORISS "Compile COLORISS"
$ inquire LSDSI "Link LEICASDSI"
$ if CSTUFF
$ then
$   cc si
$   pl si.obj
$   cc si_com
$   pl si_com.obj
$ endif
$ if SD2000
$ then
$   adc xsd2000 = sd2000
$   fortran xsd2000
$   pvv xsd2000
$   delete adc.ide;*
$   pl xsd2000.for
$   pl xsd2000.obj
$ endif
!
$ if COLORISS
$ then
$   adc xcoloriss = coloriss
$   fortran xcoloriss
$   pvv xcoloriss
$   delete adc.ide;*
$   pl xcoloriss.for
$   pl xcoloriss.obj
$ endif
$!
$ if LSDSI
$ then
$   link/share/exe=lites2leicasdsishr/map=lites2leicasdsishr/full -
	sys$input:/opt,-
	lsl$library:lslshr/opt
UNSUPPORTED=1
XSD2000,XCOLORISS
SI,SI_COM
	P2PUTI/LIB,-
	P2PLIB/LIB,-
	MLIB/LIB,-
	VT100/LIB
sys$library:vaxcrtl/share
!
universal = DSR_INQUIRE
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
!!!universal = KRISS_TEXT
!!!universal = KRISS_MENU
!
psect_attr=SD2000,noshr
psect_attr=COLORISS,noshr
!
psect_attr=BASE_OUT,noshr
psect_attr=BUTTON_CODE,noshr
psect_attr=GOT_ABSOLUTE_ORIENTATION,noshr
psect_attr=GROUND_TO_MODEL_MATRIX,noshr
psect_attr=GROUND_TO_MODEL_SHIFT,noshr
psect_attr=IO_PAGE,noshr
psect_attr=LEFT_FIDUCIAL_TO_MEASURING_MATR,noshr
psect_attr=LEFT_FIDUCIAL_TO_MODEL_MATRIX,noshr
psect_attr=LEFT_MEASURING_TO_FIDUCIAL_MATR,noshr
psect_attr=LEFT_PRINCIPAL_DISTANCE,noshr
psect_attr=LEFT_PROJECTION_CENTER,noshr
psect_attr=LOWER_STAGE_CALIBRATION_MATRIX,noshr
psect_attr=MODEL_TO_GROUND_MATRIX,noshr
psect_attr=MODEL_TO_GROUND_SHIFT,noshr
psect_attr=P2,noshr
psect_attr=P2_IO,noshr
psect_attr=P3_IO,noshr
psect_attr=P4_IO,noshr
psect_attr=PC_P2,noshr
psect_attr=RIGHT_FIDUCIAL_TO_MEASURING_MAT,noshr
psect_attr=RIGHT_FIDUCIAL_TO_MODEL_MATRIX,noshr
psect_attr=RIGHT_MEASURING_TO_FIDUCIAL_MAT,noshr
psect_attr=RIGHT_PRINCIPAL_DISTANCE,noshr
psect_attr=RIGHT_PROJECTION_CENTER,noshr
psect_attr=TT_IO,noshr
psect_attr=UPPER_STAGE_CALIBRATION_MATRIX,noshr
$   patch @leicasdsi.pat
$   delete lites2leicasdsishr.jnl;*
$   purge lites2leicasdsishr.exe,lites2leicasdsishr.map
$ endif
