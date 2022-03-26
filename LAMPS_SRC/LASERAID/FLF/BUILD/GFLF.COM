$!
$! Command file to create truth and parameter files for Laseraid
$!
$!	Last edited				 DM	25-Jun-1986
$!	Created						19-Aug-1980
$!
$	IF F$LOGICAL("LSL$LAJMAKING").EQS."" THEN GOTO A1
$	WRITE SYS$OUTPUT "Someone else is MAKing"
$	EXIT
$ A1:	IF F$LOGICAL("LSL$LAJBATTING").EQS."" THEN GOTO A2
$	WRITE SYS$OUTPUT "Someone else is BATting"
$	EXIT
$ A2:	ON CONTROL THEN GOTO CONTROL
$!
$	MAKE 'P1' 'P2' 'P3' 'P4' 'P5' 'P6' 'P7'
$	MAKFIL EXE:PARAMS.COM
$	TRUTH  EXE:PARAMS.MAR
$	ASSIGN EXE:PARAMS.MAR TR
$	VAX=1
$	AREA==0
$	RASTER==0
$	MAKINQ NORMAL "Converged Laseraid (LAJ)"
$	IF NORMAL THEN GOTO A3
$	MAKINQ AREA   "Area-scan Laseraid (LAA)"
$	IF   AREA THEN GOTO A3
$	MAKINQ RASTER "Oxford raster scan (LAR)"
$ A3:
$!
$	WT "	.LIBRARY	/LSL$LIBRARY:LSLMACLIB/"
$	WT "VAX    = 1 ; VAX version"
$	IF	AREA   THEN WT "AREA   = 1 ; Area-scan Laseraid (LAA)"
$	IF .NOT.AREA   THEN WT "AREA   = 0 ; Not LAA"
$	IF	RASTER THEN WT "RASTER = 1 ; Oxford raster scan (LAR)"
$	IF .NOT.RASTER THEN WT "RASTER = 0 ; Not LAR"
$	MAKSET VAX
$	MAKSET AREA
$	MAKSET RASTER
$	WC "$	TRFILE==""",TRFILE,""""
$!
$	MAKCLO
$	EDIT/EDT/NOCOMM EXE:PARAMS.COM
DEL ALL "CHARGE"
EXIT
$	GOTO PUR
$ CONTROL:
$	CLOSE DATA
$	CLOSE TRUTH
$ PUR:
$	PURGE EXE:PARAMS.MAR,EXE:PARAMS.COM
