$	ON CONTROL_Y THEN GOTO DCLEX
$	IF "''F$LOGICAL("LSL$DCL_BUILDING")'" -
		 .NES. "IN_PROGRESS" THEN GOTO A0
$	WRITE SYS$OUTPUT "Someone else is building"
$	EXIT
$!
$A0:	DEFINE/GROUP LSL$DCL_BUILDING "IN_PROGRESS"
$	SD:=$LSL$SYS:SD
$	SET NOON
$ 	SET NOVERIFY
$	ERROR="
$ WRITE SYS$OUTPUT "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
$ SET VERIFY
$ ADC DCL_FILE/CO = DCL_FILE		
$ FORT/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW) DCL_FILE
$ OK=$STATUS
$ IF .NOT. OK THEN ERROR=ERROR+" DCL_FILE"
$ IF OK THEN PVV DCL_FILE
$ PURGE/NOLOG DCL_FILE.OBJ
$ DELETE ADC.IDE;*
$ SET NOVER
$ IF ERROR.NES."" THEN WRITE SYS$OUTPUT "Errors in"+ERROR
$ DCLEX:
$	DEASS/GROUP LSL$DCL_BUILDING