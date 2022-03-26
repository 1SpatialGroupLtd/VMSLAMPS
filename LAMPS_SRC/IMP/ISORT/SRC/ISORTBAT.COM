$ 	SET NOVERIFY
$	ON CONTROL_Y THEN GOTO ISORTEX
$	IF "''F$LOGICAL("LSL$ISORT_BUILDING")'" -
		 .NES. "IN_PROGRESS" THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$!
$A0:	DEFINE/GROUP LSL$ISORT_BUILDING "IN_PROGRESS"
$	ASSIGN LSL$SOURCE_ROOT:[IMP.ISORT] LSL$CMNISORT
$	SD:=$LSL$SYS:SD
$	SET NOON
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		SET VERIFY
$ 		ADC ISORT.TMP=ISORT_CLD.CLD
$ 		SET COMMAND/OBJECT=ISORT_CLD ISORT.TMP
$ 		OK=$STATUS
$ 		IF OK THEN PVV ISORT_CLD
$ 		DELETE ISORT.TMP;*
$		PURGE/NOLOG ISORT_CLD.OBJ
$ 		OK=$STATUS
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC CLOSEF=CLOSEF
$ 		FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW) CLOSEF
$ 		OK=$STATUS
$ 		IF OK THEN PVV CLOSEF
$ 		PURGE/NOLOG CLOSEF.OBJ
$ 		PURGE/NOLOG CLOSEF.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC GETF=GETF
$ 		FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW) GETF
$ 		OK=$STATUS
$ 		IF OK THEN PVV GETF
$ 		PURGE/NOLOG GETF.OBJ
$ 		PURGE/NOLOG GETF.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC ISORT=ISORT
$ 		FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW) ISORT
$ 		OK=$STATUS
$ 		IF OK THEN PVV ISORT
$ 		PURGE/NOLOG ISORT.OBJ
$ 		PURGE/NOLOG ISORT.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC OBEY'KPCOM'=OBEY
$ 		FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW) OBEY
$ 		OK=$STATUS
$ 		IF OK THEN PVV OBEY
$ 		PURGE/NOLOG OBEY.OBJ
$ 		PURGE/NOLOG OBEY.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC SORTF=SORTF
$ 		FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW) SORTF
$ 		OK=$STATUS
$ 		IF OK THEN PVV SORTF
$ 		PURGE/NOLOG SORTF.OBJ
$ 		PURGE/NOLOG SORTF.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC SRTINFO=SRTINFO
$ 		FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW) SRTINFO
$ 		OK=$STATUS
$ 		IF OK THEN PVV SRTINFO
$ 		PURGE/NOLOG SRTINFO.OBJ
$ 		PURGE/NOLOG SRTINFO.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		LINK/MAP/DEBUG/EXE=ISORT ISORT, -
		ISORT_CLD, CLOSEF, -
		GETF, OBEY, SORTF, SRTINFO, -
		ISORT.PROMSG_OBJ, -
		lsl$library:iffshr/opt,lslshr/opt
$ 		ISORTEX:
$ 		DEASS/GROUP LSL$ISORT_BUILDING
$ 		SET NOVER
