$	SET NOVERIFY
$	ON CONTROL_Y THEN GOTO ITOTEXTEX
$	IF "''F$LOGICAL("LSL$ITOTEXT_BUILDING")'" -
		 .NES. "IN_PROGRESS" THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$!
$ A0:	DEFINE/GROUP LSL$ITOTEXT_BUILDING "IN_PROGRESS"
$	ASSIGN LSL$SOURCE_ROOT:[IMP.ITOTEXT] LSL$CMNITOTEXT
$	SD:=$LSL$SYS:SD
$	SET NOON
$	EMSG=""
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	SET VERIFY
$	newmsg/number=1216/name=itotext/prefix=itotext__/parameter=for itotext.mes
$ @itotext.temp_com
$ 	ADC ITOTEXT.TMP=ITOTEXT.CLD
$ 	SET COMMAND/OBJECT=ITOTEXT_CLD ITOTEXT.TMP
$ 	OK=$STATUS
$ 	IF OK THEN PVV ITOTEXT_CLD
$ 	IF OK THEN DELETE ITOTEXT.TMP;*
$ 	IF OK THEN PURGE/NOLOG ITOTEXT_CLD.OBJ
$	MACRO'MACDBG'/OBJECT=I2TCMD I2TCMD
$	OK=$STATUS
$	PUR/NOLOG I2TCMD.OBJ
$	IF .NOT.OK THEN EMSG=EMSG+" Macro-I2TCMD"
$	WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	SET VERIFY
$ 	ADC ITOTEXT=ITOTEXT
$	FORT ITOTEXT
$ 	OK=$STATUS
$ 	IF OK THEN PVV ITOTEXT
$ 	PURGE/NOLOG ITOTEXT.OBJ
$ 	DELETE/NOLOG ITOTEXT.FOR;*
$	IF .NOT.OK THEN EMSG=EMSG+" ITOTEXT"
$ 	DELETE ADC.IDE;*
$	SET NOVERIFY
$	WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	SET VERIFY
$ 	ADC APPANG=APPANG
$	FORT APPANG
$ 	OK=$STATUS
$ 	IF OK THEN PVV APPANG
$ 	PURGE/NOLOG APPANG.OBJ
$ 	DELETE/NOLOG APPANG.FOR;*
$	IF .NOT.OK THEN EMSG=EMSG+" APPANG"
$ 	DELETE ADC.IDE;*
$	SET NOVERIFY
$	WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	SET VERIFY
$ 	ADC APPDAT=APPDAT
$	FORT APPDAT
$ 	OK=$STATUS
$ 	IF OK THEN PVV APPDAT
$ 	PURGE/NOLOG APPDAT.OBJ
$ 	DELETE/NOLOG APPDAT.FOR;*
$	IF .NOT.OK THEN EMSG=EMSG+" APPDAT"
$ 	DELETE ADC.IDE;*
$	SET NOVERIFY
$	WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	SET VERIFY
$ 	ADC APPFLT=APPFLT
$	FORT APPFLT
$ 	OK=$STATUS
$ 	IF OK THEN PVV APPFLT
$ 	PURGE/NOLOG APPFLT.OBJ
$ 	DELETE/NOLOG APPFLT.FOR;*
$	IF .NOT.OK THEN EMSG=EMSG+" APPFLT"
$ 	DELETE ADC.IDE;*
$	SET NOVERIFY
$	WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	SET VERIFY
$ 	ADC BINTOD=BINTOD
$	FORT BINTOD
$ 	OK=$STATUS
$ 	IF OK THEN PVV BINTOD
$ 	PURGE/NOLOG BINTOD.OBJ
$ 	DELETE/NOLOG BINTOD.FOR;*
$	IF .NOT.OK THEN EMSG=EMSG+" BINTOD"
$ 	DELETE ADC.IDE;*
$	SET NOVERIFY
$	WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	SET VERIFY
$ 	ADC CVTANG=CVTANG
$	FORT CVTANG
$ 	OK=$STATUS
$ 	IF OK THEN PVV CVTANG
$ 	PURGE/NOLOG CVTANG.OBJ
$ 	DELETE/NOLOG CVTANG.FOR;*
$	IF .NOT.OK THEN EMSG=EMSG+" CVTANG"
$ 	DELETE ADC.IDE;*
$	SET NOVERIFY
$	WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	SET VERIFY
$ 	ADC EXPFL8=EXPFL8
$	FORT EXPFL8
$ 	OK=$STATUS
$ 	IF OK THEN PVV EXPFL8
$ 	PURGE/NOLOG EXPFL8.OBJ
$ 	DELETE/NOLOG EXPFL8.FOR;*
$	IF .NOT.OK THEN EMSG=EMSG+" EXPFL8"
$ 	DELETE ADC.IDE;*
$	SET NOVERIFY
$	WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	SET VERIFY
$ 	ADC EXPFLT=EXPFLT
$	FORT EXPFLT
$ 	OK=$STATUS
$ 	IF OK THEN PVV EXPFLT
$ 	PURGE/NOLOG EXPFLT.OBJ
$ 	DELETE/NOLOG EXPFLT.FOR;*
$	IF .NOT.OK THEN EMSG=EMSG+" EXPFLT"
$ 	DELETE ADC.IDE;*
$	SET NOVERIFY
$	WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	SET VERIFY
$ 	ADC FLTEXP=FLTEXP
$	FORT FLTEXP
$ 	OK=$STATUS
$ 	IF OK THEN PVV FLTEXP
$ 	PURGE/NOLOG FLTEXP.OBJ
$ 	DELETE/NOLOG FLTEXP.FOR;*
$	IF .NOT.OK THEN EMSG=EMSG+" FLTEXP"
$ 	DELETE ADC.IDE;*
$	SET NOVERIFY
$	WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	SET VERIFY
$ 	ADC I2TASC=I2TASC
$	FORT I2TASC
$ 	OK=$STATUS
$ 	IF OK THEN PVV I2TASC
$ 	PURGE/NOLOG I2TASC.OBJ
$ 	DELETE/NOLOG I2TASC.FOR;*
$	IF .NOT.OK THEN EMSG=EMSG+" I2TASC"
$ 	DELETE ADC.IDE;*
$	SET NOVERIFY
$	WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	SET VERIFY
$ 	ADC I2TCOM=I2TCOM
$	FORT I2TCOM
$ 	OK=$STATUS
$ 	IF OK THEN PVV I2TCOM
$ 	PURGE/NOLOG I2TCOM.OBJ
$ 	DELETE/NOLOG I2TCOM.FOR;*
$	IF .NOT.OK THEN EMSG=EMSG+" I2TCOM"
$ 	DELETE ADC.IDE;*
$	SET NOVERIFY
$	WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	SET VERIFY
$ 	ADC I2TCB=I2TCB
$	FORT I2TCB
$ 	OK=$STATUS
$ 	IF OK THEN PVV I2TCB
$ 	PURGE/NOLOG I2TCB.OBJ
$ 	DELETE/NOLOG I2TCB.FOR;*
$	IF .NOT.OK THEN EMSG=EMSG+" I2TCB"
$ 	DELETE ADC.IDE;*
$	SET NOVERIFY
$	WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	SET VERIFY
$ 	ADC I2TENT=I2TENT
$	FORT I2TENT
$ 	OK=$STATUS
$ 	IF OK THEN PVV I2TENT
$ 	PURGE/NOLOG I2TENT.OBJ
$ 	DELETE/NOLOG I2TENT.FOR;*
$	IF .NOT.OK THEN EMSG=EMSG+" I2TENT"
$ 	DELETE ADC.IDE;*
$	SET NOVERIFY
$	WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	SET VERIFY
$ 	ADC I2TLI8=I2TLI8
$	FORT I2TLI8
$ 	OK=$STATUS
$ 	IF OK THEN PVV I2TLI8
$ 	PURGE/NOLOG I2TLI8.OBJ
$ 	DELETE/NOLOG I2TLI8.FOR;*
$	IF .NOT.OK THEN EMSG=EMSG+" I2TLI8"
$ 	DELETE ADC.IDE;*
$	SET NOVERIFY
$	WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	SET VERIFY
$ 	ADC I2TLIN=I2TLIN
$	FORT I2TLIN
$ 	OK=$STATUS
$ 	IF OK THEN PVV I2TLIN
$ 	PURGE/NOLOG I2TLIN.OBJ
$ 	DELETE/NOLOG I2TLIN.FOR;*
$	IF .NOT.OK THEN EMSG=EMSG+" I2TLIN"
$ 	DELETE ADC.IDE;*
$	SET NOVERIFY
$	WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	SET VERIFY
$ 	ADC I2TMHT=I2TMHT
$	FORT I2TMHT
$ 	OK=$STATUS
$ 	IF OK THEN PVV I2TMHT
$ 	PURGE/NOLOG I2TMHT.OBJ
$ 	DELETE/NOLOG I2TMHT.FOR;*
$	IF .NOT.OK THEN EMSG=EMSG+" I2TMHT"
$ 	DELETE ADC.IDE;*
$	SET NOVERIFY
$	WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	SET VERIFY
$ 	ADC WRTANG=WRTANG
$	FORT WRTANG
$ 	OK=$STATUS
$ 	IF OK THEN PVV WRTANG
$ 	PURGE/NOLOG WRTANG.OBJ
$ 	DELETE/NOLOG WRTANG.FOR;*
$	IF .NOT.OK THEN EMSG=EMSG+" WRTANG"
$ 	DELETE ADC.IDE;*
$	SET NOVERIFY
$	WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$	SET VERIFY
$ 	ADC WRTDAT=WRTDAT
$	FORT WRTDAT
$ 	OK=$STATUS
$ 	IF OK THEN PVV WRTDAT
$ 	PURGE/NOLOG WRTDAT.OBJ
$ 	DELETE/NOLOG WRTDAT.FOR;*
$	IF .NOT.OK THEN EMSG=EMSG+" WRTDAT"
$ 	DELETE ADC.IDE;*
$	SET NOVERIFY
$	SET NOVERIFY
$	IF EMSG.EQS."" THEN GOTO NOERR
$	WRITE SYS$OUTPUT "&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"
$	WRITE SYS$OUTPUT " Compilation errors in:"
$	WRITE SYS$OUTPUT EMSG
$	WRITE SYS$OUTPUT "&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*"
$	NOERR: SET VERIFY
$	LINK/MAP/CROSS/EXE=ITOTEXT -
	ITOTEXT,ITOTEXT_CLD, -
	I2TCMD,APPANG,APPDAT,APPFLT,BINTOD,CVTANG,-
	EXPFL8,EXPFLT,FLTEXP,I2TASC,I2TCOM,I2TENT,I2TLI8,-
	I2TLIN,I2TMHT,WRTANG,WRTDAT,I2TCB,-
	ITOTEXT.PROMSG_OBJ,-
    LSL$LIBRARY:LSLFRTLIB/LIB,-
    LSL$LIBRARY:IFFSHR/OPT,-
    LSL$LIBRARY:LSLSHR/OPT
$	ITOTEXTEX:
$ 	DEASS/GROUP LSL$ITOTEXT_BUILDING
$ 	SET NOVER
