$	STATE:='F$VERIFY(0)'
$!
$! Command-file to rebuild the LIOLIB library.
$!
$!  Last edited				JHR	09-Jun-1982
$!  Written				JHR	04-May-1982
$!
$	SET NOON
$	MAC_EXIST:==
$	FTN_EXIST:==
$	WS:= WRITE SYS$OUTPUT
$!
$! see if total rebuild requested
$	IF P1 .NES. ""  THEN GOTO SINGLE
$	INQUIRE/NOP TOTAL " Total rebuild ? "
$	IF TOTAL  THEN GOTO ALL
$	INQUIRE P1 " Please enter module name "
$	IF P1 .EQS. "" THEN EXIT
$!
$! single module to re-build and insert, establish whether it's
$!  MACRO or FORTRAN.
$SINGLE:
$	DIR/BR/OUTPUT=NI:			'P1'.MAC ! MACRO ?
$	MAC_EXIST:='$STATUS'
$	IF MAC_EXIST  THEN GOTO SINGLE_OPEN
$	DIR/BR/OUTPUT=NI:			'P1'.SRC ! FORTRAN ?
$	FTN_EXIST:='$STATUS'
$	IF FTN_EXIST  THEN GOTO SINGLE_OPEN
$	WS  " No such module"		! nothing found, so quit
$	EXIT
$!
$! got a module, do as for total rebuild
$SINGLE_OPEN:
$	IF .NOT. MAC_EXIST  THEN GOTO OVER 
$	DIRECTORY/BR/COL=1/OUT=MACRO.FIL	'P1'.MAC; ! MACRO
$	OPEN/READ MAC_IN MACRO.FIL
$	GOTO TRIM_MAC
$OVER:
$	DIRECTORY/BR/COL=1/OUT=FORTRAN.FIL	'P1'.SRC; ! FORTRAN
$	OPEN/READ FTN_IN FORTRAN.FIL
$	GOTO TRIM_FTN
$!
$! total rebuild - get the modules to rebuild (latest versions only!)
$ALL:
$	MCR LBR LIOLIB/CR:30.:::OBJ		! create new library
$	DIRECTORY/BR/COL=1/OUT=MACRO.FIL	*.MAC;	! MACRO
$	DIRECTORY/BR/COL=1/OUT=FORTRAN.FIL	*.SRC;	! FORTRAN
$!
$! open files created via DIR
$	OPEN/READ MAC_IN MACRO.FIL
$	OPEN/READ FTN_IN FORTRAN.FIL
$!
$! trim off DIR's pretties
$TRIM_MAC:
$	READ/END_OF_FILE=ERROR MAC_IN LINE
$	READ/END_OF_FILE=ERROR MAC_IN LINE
$	READ/END_OF_FILE=ERROR MAC_IN LINE
$	IF MAC_EXIST  THEN GOTO MAC_LOOP
$TRIM_FTN:
$	READ/END_OF_FILE=ERROR FTN_IN LINE
$	READ/END_OF_FILE=ERROR FTN_IN LINE
$	READ/END_OF_FILE=ERROR FTN_IN LINE
$	IF FTN_EXIST  THEN GOTO FTN_LOOP
$!
$! here for the MACRO stuff
$MAC_LOOP:
$	READ/END_OF_FILE=ERROR MAC_IN LINE	! read a line
$	IF LINE .NES. ""    THEN GOTO MAC_MORE	! any more?
$	IF 	 MAC_EXIST  THEN GOTO FINI_MAC	! single module?
$	IF .NOT. MAC_EXIST  THEN GOTO FTN_LOOP	! total re-build?
$MAC_MORE:
$	POINT='F$LOC(".",LINE)'
$	FILE:='F$EXT(0,POINT,LINE)'
$	SET VER
$	MCR MAC 'FILE'='FILE'
$	MCR LBR LIOLIB/RP='FILE'
$	STATE:='F$VERIFY(0)'
$	DELETE 'FILE'.OBJ;*
$	GOTO MAC_LOOP
$!
$! here for the FORTRAN stuff
$FTN_LOOP:
$	READ/END_OF_FILE=ERROR FTN_IN LINE	! read a line
$	IF LINE .NES. ""    THEN GOTO FTN_MORE	! any more?
$	IF 	 FTN_EXIST  THEN GOTO FINI_FTN	! single module?
$	IF .NOT. FTN_EXIST  THEN GOTO FINI	! total re-build?
$FTN_MORE:
$	POINT='F$LOC(".",LINE)'
$	FILE:='F$EXT(0,POINT,LINE)'
$	SET VER
$	ADC 'FILE'=PDP.TRU/TR,'FILE'
$	F4P 'FILE'='FILE'.FOR
$	PVR 'FILE'
$	MCR LBR LIOLIB/RP='FILE'
$	STATE:='F$VERIFY(0)'
$	DELETE 'FILE'.FOR;*,'FILE'.OBJ;*,ADC.IDE;*
$	GOTO FTN_LOOP
$!
$! error while reading file
$ERROR:
$	WS  " Error on read - "
$	WS  "      from either MACRO or FORTRAN modules list "
$	GOTO FINI
$!
$! finish for single MACRO module
$FINI_MAC:
$	CLOSE MAC_IN
$	DELETE MACRO.FIL;*
$!
$! see if he/she wants more
$	INQUIRE P1 " Please enter module name "
$	IF P1 .NES. "" THEN GOTO SINGLE
$	GOTO CLOSE_DOWN
$!
$! finish for single FORTRAN module
$FINI_FTN:
$	CLOSE FTN_IN
$	DELETE FORTRAN.FIL;*
$!
$! see if he/she wants more
$	INQUIRE P1 " Please enter module name "
$	IF P1 .NES. "" THEN GOTO SINGLE
$	GOTO CLOSE_DOWN
$!
$! finish for total re-build
$FINI:
$	CLOSE MAC_IN
$	CLOSE FTN_IN
$	PIP LIOLIB.OLB/PU/NM
$	DELETE FORTRAN.FIL;*,MACRO.FIL;*
$CLOSE_DOWN:
$	WS  " *** finished ***"
$	EXIT
