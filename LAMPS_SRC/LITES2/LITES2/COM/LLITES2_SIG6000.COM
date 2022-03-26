$! LLITES2.COM - LITES2 relink
$	savver='f$verify(0)
$	set noon
$	VER="LITES2"+P2
$	IF P2.EQS."" then VER = "LITES2SIG6000"
$	DEBSW=""
$	D=""
$	if P1.eqs."D" then DEBSW="/DEBUG"
$	if P1.eqs."D" then D="D"
$	ws="write sys$output"
$	sd obj:
$	assign EXE:LITES2TR.MAR TR
$	set verify
$!  ++++++++++++++++++++  Options  ++++++++++++++++++++
$	if P4.eqs."n" .or. P4.eqs."N" then goto no_new_date
$	RUN LSL$EXE:GENVER
$	ADC VERSION/CD:CMN:=TR:/TR,OBJ:VERSION
$	FORTRAN/NOLIST VERSION
$	PVV VERSION
$	DELETE VERSION.SRC;*,VERSION.FOR;*,ADC.IDE;*
$	PURGE/NOLOG VERSION.OBJ
$no_new_date:
$	ADC 'VER'.OPT=TR:/TR,COM:'VER'.LNK
$	PURGE/NOLOG 'VER'.OPT
$!
$	adc gctp = lsl$cmniff:md2dat
$	fort/nolist/debug/noopt gctp
$	pvv gctp
$	delete	adc.ide;*
$	delete gctp.for;*
$	purge/nolog obj:gctp.obj
$!
$	LIBR/REM=ABANDN LITES2
$	LIBR/REM=SUBVAR LITES2
$!  ++++++++++++++++++++  Linking  ++++++++++++++++++++
$	LINK'DEBSW'/NOMAP'P3'/EXE=EXE:'VER''D'  -
	SYS$INPUT:/OPT,-
	LSL$LIBRARY:FRTSHR/OPT,-
	LSL$LIBRARY:IFFSHR/OPT,-
	LSL$LIBRARY:LSLSHR/OPT,-
	LSL$LIBRARY:DTISHR/OPT,-
	OBJ:GCTP,-
	OBJ:'VER'/OPTIONS
 CLUSTER=SIG6000,,,-
	OBJ:SIG6000/INCLUDE=(TRITXT)
$	PURGE/NOLOG EXE:'VER''D'.EXE,OBJ:'VER'.MAP
$!	'f$verify(0)
$	sd .
$	if savver then set verify
