$ 	SET NOVERIFY
$	ON CONTROL_Y THEN GOTO IMERGEEX
$	IF "''F$LOGICAL("LSL$IMERGE_BUILDING")'" -
		 .NES. "IN_PROGRESS" THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$!
$A0:	DEFINE/GROUP LSL$IMERGE_BUILDING "IN_PROGRESS"
$	ASSIGN LSL$SOURCE_ROOT:[IMP.IMERGE] LSL$CMNIMERGE
$	SD:=$LSL$SYS:SD
$	SET NOON
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		SET VERIFY
$	NEWMSG/NUMBER=1201/PREFIX=IMERGE__/PARAMETER=FORTRAN IMERGE.MES
$	@IMERGE.TEMP_COM
$ 		ADC IMERGE.TMP=IMERGE.CLD
$ 		SET COMMAND/OBJECT=IMERGE_CLD IMERGE.TMP
$ 		OK=$STATUS
$ 		IF OK THEN PVV IMERGE_CLD
$ 		IF OK THEN DELETE IMERGE.TMP;*
$ 		IF OK THEN PURGE/NOLOG IMERGE_CLD.OBJ
$ 		ADC IMERGE.TMP2=IMERGEPAR.CLD
$ 		SET COMMAND/OBJECT=IMERGEPAR_CLD IMERGE.TMP2
$ 		OK=$STATUS
$ 		IF OK THEN PVV IMERGEPAR_CLD
$ 		IF OK THEN DELETE IMERGE.TMP2;*
$ 		IF OK THEN PURGE/NOLOG IMERGEPAR_CLD.OBJ
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		ADC ADDOV_REST=ADDOV_REST
$ 		FORT ADDOV_REST
$ 		OK=$STATUS
$ 		IF OK THEN PVV ADDOV_REST
$ 		PURGE/NOLOG ADDOV_REST.OBJ
$ 		PURGE/NOLOG ADDOV_REST.FOR
$ 		DELETE ADC.IDE;*
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ 		ADC ADDOV_SEL=ADDOV_SEL
$ 		FORT ADDOV_SEL
$ 		OK=$STATUS
$ 		IF OK THEN PVV ADDOV_SEL
$ 		PURGE/NOLOG ADDOV_SEL.OBJ
$ 		PURGE/NOLOG ADDOV_SEL.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC CMDLIN=CMDLIN
$ 		FORT CMDLIN
$ 		OK=$STATUS
$ 		IF OK THEN PVV CMDLIN
$ 		PURGE/NOLOG CMDLIN.OBJ
$ 		PURGE/NOLOG CMDLIN.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC DESCHK=DESCHK
$ 		FORT DESCHK
$ 		OK=$STATUS
$ 		IF OK THEN PVV DESCHK
$ 		PURGE/NOLOG DESCHK.OBJ
$ 		PURGE/NOLOG DESCHK.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC CML_ERRET=CML_ERRET
$ 		FORT CML_ERRET
$ 		OK=$STATUS
$ 		IF OK THEN PVV CML_ERRET
$ 		PURGE/NOLOG CML_ERRET.OBJ
$ 		PURGE/NOLOG CML_ERRET.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC COMMA=COMMA
$ 		FORT COMMA
$ 		OK=$STATUS
$ 		IF OK THEN PVV COMMA
$ 		PURGE/NOLOG COMMA.OBJ
$ 		PURGE/NOLOG COMMA.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC DUPFIL=DUPFIL
$ 		FORT DUPFIL
$ 		OK=$STATUS
$ 		IF OK THEN PVV DUPFIL
$ 		PURGE/NOLOG DUPFIL.OBJ
$ 		PURGE/NOLOG DUPFIL.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC IFFLYR=IFFLYR
$ 		FORT IFFLYR
$ 		OK=$STATUS
$ 		IF OK THEN PVV IFFLYR
$ 		PURGE/NOLOG IFFLYR.OBJ
$ 		PURGE/NOLOG IFFLYR.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC IFFMER=IFFMER
$ 		FORT IFFMER
$ 		OK=$STATUS
$ 		IF OK THEN PVV IFFMER
$ 		PURGE/NOLOG IFFMER.OBJ
$ 		PURGE/NOLOG IFFMER.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC IFF_START=IFF_START
$ 		FORT IFF_START
$ 		OK=$STATUS
$ 		IF OK THEN PVV IFF_START
$ 		PURGE/NOLOG IFF_START.OBJ
$ 		PURGE/NOLOG IFF_START.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC IMERGE=IMERGE
$ 		FORT IMERGE
$ 		OK=$STATUS
$ 		IF OK THEN PVV IMERGE
$ 		PURGE/NOLOG IMERGE.OBJ
$ 		PURGE/NOLOG IMERGE.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC INICP=INICP
$ 		FORT INICP
$ 		OK=$STATUS
$ 		IF OK THEN PVV INICP
$ 		PURGE/NOLOG INICP.OBJ
$ 		PURGE/NOLOG INICP.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC MERCPX=MERCPX
$ 		FORT MERCPX
$ 		OK=$STATUS
$ 		IF OK THEN PVV MERCPX
$ 		PURGE/NOLOG MERCPX.OBJ
$ 		PURGE/NOLOG MERCPX.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC NXT_REST_OV=NXT_REST_OV
$ 		FORT NXT_REST_OV
$ 		OK=$STATUS
$ 		IF OK THEN PVV NXT_REST_OV
$ 		PURGE/NOLOG NXT_REST_OV.OBJ
$ 		PURGE/NOLOG NXT_REST_OV.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC NXT_SEL_OV=NXT_SEL_OV
$ 		FORT NXT_SEL_OV
$ 		OK=$STATUS
$ 		IF OK THEN PVV NXT_SEL_OV
$ 		PURGE/NOLOG NXT_SEL_OV.OBJ
$ 		PURGE/NOLOG NXT_SEL_OV.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC PARSE2=PARSE2
$ 		FORT PARSE2
$ 		OK=$STATUS
$ 		IF OK THEN PVV PARSE2
$ 		PURGE/NOLOG PARSE2.OBJ
$ 		PURGE/NOLOG PARSE2.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC PRINCP=PRINCP
$ 		FORT PRINCP
$ 		OK=$STATUS
$ 		IF OK THEN PVV PRINCP
$ 		PURGE/NOLOG PRINCP.OBJ
$ 		PURGE/NOLOG PRINCP.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC RELOFF=RELOFF
$ 		FORT RELOFF
$ 		OK=$STATUS
$ 		IF OK THEN PVV RELOFF
$ 		PURGE/NOLOG RELOFF.OBJ
$ 		PURGE/NOLOG RELOFF.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC RESTMER=RESTMER
$ 		FORT RESTMER
$ 		OK=$STATUS
$ 		IF OK THEN PVV RESTMER
$ 		PURGE/NOLOG RESTMER.OBJ
$ 		PURGE/NOLOG RESTMER.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC SELMER=SELMER
$ 		FORT SELMER
$ 		OK=$STATUS
$ 		IF OK THEN PVV SELMER
$ 		PURGE/NOLOG SELMER.OBJ
$ 		PURGE/NOLOG SELMER.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC SKPOVR=SKPOVR
$ 		FORT SKPOVR
$ 		OK=$STATUS
$ 		IF OK THEN PVV SKPOVR
$ 		PURGE/NOLOG SKPOVR.OBJ
$ 		PURGE/NOLOG SKPOVR.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC WRTCMD=WRTCMD
$ 		FORT WRTCMD
$ 		OK=$STATUS
$ 		IF OK THEN PVV WRTCMD
$ 		PURGE/NOLOG WRTCMD.OBJ
$ 		PURGE/NOLOG WRTCMD.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ 		ADC XFER_QUAL=XFER_QUAL
$ 		FORT XFER_QUAL
$ 		OK=$STATUS
$ 		IF OK THEN PVV XFER_QUAL
$ 		PURGE/NOLOG XFER_QUAL.OBJ
$ 		PURGE/NOLOG XFER_QUAL.FOR
$ 		DELETE ADC.IDE;*
$ SET NOVERIFY
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$		ADC LNK = LSL$CMNIFF:MD2DAT
$		FORT/DEBUG/NOOPT LNK
$		PVV LNK
$		DELETE	ADC.IDE;*
$		DELETE  LNK.FOR;*
$ 		LINK/MAP/CROSS/EXE=IMERGE IMERGE,IMERGE_CLD, -
		IMERGEPAR_CLD,CMDLIN,PARSE2, -
		CML_ERRET,COMMA,ADDOV_REST,ADDOV_SEL, -
		IFF_START,DUPFIL,IFFLYR,INICP, LNK, -
		MERCPX,SKPOVR,XFER_QUAL,IFFMER,NXT_REST_OV, -
		NXT_SEL_OV,PRINCP,WRTCMD,RELOFF,DESCHK, -
		RESTMER,SELMER, -
		IMERGE.PROMSG_OBJ, -
		LSL$LIBRARY:IFFSHR/OPT,-
		LSL$LIBRARY:LSLSHR/OPT
$ 		IMERGEEX:
$ 		DEASS/GROUP LSL$IMERGE_BUILDING
$ 		SET NOVER
