$	SET NOVER
$	IF P1 .NES. "" THEN GOTO GOTNAM
$	INQUIRE/NOP P1 "Program ? "
$	IF P1 .EQS. "" THEN EXIT
$ GOTNAM:
$	LEN=F$LEN(P1)
$	POS=F$LOC(".",P1)
$	IF POS .NE. LEN THEN P1=F$EXT(0,POS,P1)
$	FDEB:=""
$	LDEB:=/NOTRACE
$	INQUIRE/NOP DEB "Debug ? "
$	IF .NOT.DEB THEN GOTO NODEB
$	FDEB:=/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW)
$	LDEB:=/DEBUG
$ NODEB:
$	SET VER
$	ADC 'P1'/CO='P1'
$	FORT'FDEB' 'P1'
$	PVV 'P1'
$	DELETE ADC.IDE;*
$	ADC TRLGNM/CO=TRLGNM
$	FORT'FDEB' TRLGNM
$	PVV TRLGNM
$	LINK'LDEB' 'P1',TRLGNM
$	DELETE 'P1'.OBJ;*,TRLGNM.OBJ;*,ADC.IDE;*
$	PURGE/NOLOG TRLGNM.FOR,'P1'.FOR,.EXE
$	IF FDEB .EQS. "" THEN DELETE 'P1'.FOR;,TRLGNM.FOR;
$	SET NOVER