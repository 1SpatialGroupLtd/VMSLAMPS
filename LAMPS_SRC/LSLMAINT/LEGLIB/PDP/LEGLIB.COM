$!
$	INQUIRE M Assemble
$	INQUIRE F Compile
$	LC:='F
$	IF LC THEN INQUIRE LC List /LEGEND/
$	INQUIRE L Build library
$	INQUIRE O One legenda option
$!
$	X:=".ONE"
$	IF .NOT.O THEN X:=".LOT"
$	OPEN/WRITE TR TR.SRC
$	WRITE TR "CODDAT = 1	; all code data of interest"
$	WRITE TR "WINLEG = 0	; not using SOL's window mechanism"
$	IF O THEN WRITE TR "ONELEG = 1	; only one legenda file"
$	IF .NOT.O THEN WRITE TR "ONELEG = 0	; lots of legenda files"
$	CLOSE TR
$	PIP TR.SRC/PU
$!
$	IF .NOT.M THEN GOTO 100
$	PIP *.OBJ;*/DE
$	MCR MAC ADDLEG = TR.SRC,LEGEND,ERRORS,ADDLEG
$	MCR MAC FINCOD = TR.SRC,LEGEND,ERRORS,FINCOD
$	MCR MAC FINLEG = TR.SRC,LEGEND,ERRORS,FINLEG
$	MCR MAC FLRWVB = TR.SRC,LEGEND,ERRORS,FLRWVB
$	MCR MAC INILEG = TR.SRC,LEGEND,ERRORS,INILEG
$	MCR MAC RDLEGS = TR.SRC,LEGEND,ERRORS,RDLEGS
$	PIP LEGLIB.OBM=*.OBJ
$	PIP *.OBJ;*/DE
$!
$100:	IF .NOT.F THEN GOTO 200
$	ADC LEGEND'X'/CO/LL:100=TR/TR,LEGEND.CMN
$	IF LC THEN LST LEGEND'X'
$	PIP LEGEND'X'/PU
$	ADC LEGLIB.FTN = TR/TR,DRLEGS,LEGWRD,RDLEG
$	MCR F4P LEGLIB.OBF = LEGLIB
$	PIP LEGLIB.FTN;*/DE
$!
$200:	IF .NOT.L THEN GOTO 900
$	MCR LBR LEGLIB'X'/CR:20=LEGLIB.OBF,LEGLIB.OBM
$!
$900:	PIP LEGLIB.*/PU