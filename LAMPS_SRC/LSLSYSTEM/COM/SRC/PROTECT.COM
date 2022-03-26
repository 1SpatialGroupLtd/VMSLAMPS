$	V='F$VERIFY(0)
$! Copyright Laser-Scan Laboratories Ltd, Cambridge, England
$! Author					AJW	1986
$!
$! procedure for setting file protections
$! Examples are $ PROT *.IFF DEF	! reset to default protection
$!		$ PROT FRED.DAT		! protect to Owner no delete
$!		$ PROT JIM.TXT "R,R,,"	! System and Owner read only
$!
$	SET ON
$	ON ERROR THEN GOTO EXIT
$	ON CONTROL THEN GOTO EXIT
$	IF P1 .NES. "" THEN GOTO DECODE
$	INQUIRE/NOP P1 "File name ? "
$	IF P1 .EQS. "" THEN EXIT
$	IF P2 .EQS. "" THEN INQUIRE/NOP P2 "Protection ? "
$ DECODE:
$	IF P2 .EQS. "" THEN P2 := "R,RWE,R,R"
$	IF P2 .EQS. "DEF" THEN P2 := "RWED,RWED,RWED,RE"
$	CURRENT_FILE:=='P1'
$	I = 3
$ LOOP:
$	LEN = 'F$LEN(P2)'
$	LOC = 'F$LOC(",",P2)' 
$	P'I' := 'F$EXT(0,LOC,P2)'
$	IF LOC .EQ. LEN THEN GOTO PROTECT
$	I = I+1
$	LOC = LOC+1
$	P2 := 'F$EXT(LOC,LEN,P2)'
$	GOTO LOOP
$ PROTECT:
$	IF P3 .NES. "" THEN P3 := ":''P3'"
$	IF P4 .NES. "" THEN P4 := ":''P4'"
$	IF P5 .NES. "" THEN P5 := ":''P5'"
$	IF P6 .NES. "" THEN P6 := ":''P6'"
$	SET PROTECTION 'P1' /PROTECTION=(S'P3',O'P4',G'P5',W'P6')
$ EXIT: IF V THEN SET VERIFY
