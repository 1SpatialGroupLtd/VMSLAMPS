$! Copyright Laser-Scan Laboratories Ltd, Cambridge, England
$! Author					WJJ	1980
$! Add $$77 definition to make RSX access work	WJJ	16-Nov-1988
$!
$! Example procedure for setting up a microprocessor load line
$!
$	IF P1 .EQS. "" THEN INQUIRE P1 "Which line"
$	IF P1 .EQS. "" THEN EXIT
$	XXX:='F$LOGICAL(P1)'	! remove spaces and blanks
$	IF XXX.EQS."" THEN XXX:='P1
$	IF F$LOCATE(":",XXX).EQS.F$LENGTH(XXX) THEN XXX=XXX+":"
$	IF F$LOCATE("_",XXX).EQS.F$LENGTH(XXX) THEN XXX="_"+XXX
$	AAA=F$GETDVI(XXX,"TRM")
$	IF .NOT.$STATUS THEN EXIT
$	IF .NOT.AAA THEN EXIT %X144
$	ALLOCATE 'XXX' LD0
$	ASSIGN 'XXX' LD
$	ASSIGN 'XXX' LSL$LD	! for the modern naming conventions
$	ASSIGN 'XXX' FZ
$	ASSIGN 'XXX' SS
$	ASSIGN 'XXX' RL0
$	ASSIGN 'XXX' $$77	! for RSX access
$	SET TERMINAL/PASSALL/EIGHT_BIT/NOECHO/NOTTSYNC/NOBROADCAST/TYPEAHEAD/HOSTSYNC 'XXX'
$	TALK=="$LSL$EXE:TALK"
$	MUTTER=="$LSL$EXE:MUTTER"
