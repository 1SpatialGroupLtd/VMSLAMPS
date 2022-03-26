$! CLITES2.COM - LITES2 recompile and replace in library
$	SAVVER='f$verify(0)
$	set noon
$	if P2.eqs."" then inquire P2 "Module"
$	if P2.eqs."" then goto ERRXT
$	P2:='P2'
$	if P2.eqs."BLKDAT" then P1="D"
$	ws="write sys$output"
$	LIB="LITES2"
$	if P3.nes."" then LIB=P3
$	SRCDIR=f$trnlnm("SRC")
$	IF P3.nes."" then SRCDIR=SRCDIR-"SRC]"+P3+"]"
$	EFILE=SRCDIR
$	IF P3.nes."" then EFILE=EFILE+P3+"_"
$	EFILE=EFILE+P2+".SRC"
$	FFILE=f$search(EFILE)
$	if FFILE.nes."" then goto ok
$	  WS "File ",EFILE," does not exist"
$	  exit
$ok:	DEBSW=""
$	DELCOM="DELETE"
$	PIPSW=";*"
$       keepcom = ""              	! temporary 	rwr 5/3/93
$	if P1.nes."D" then goto nod
$	DEBSW="/DEBUG/NOOPT/CHECK=(BOUNDS,OVERFLOW)"
$	DELCOM="PURGE/NOLOG"
$	PIPSW=""
$	keepcom = "/co"			! temporary 	rwr 5/3/93
$	if P2.eqs."BLKDAT" then keepcom = ""
$nod:$	SAVDIR=f$environment("DEFAULT")
$	set def OBJ:
$	assign EXE:LITES2TR.MAR TR
$	set verify
$	ADC X'P2''keepcom'/CD:CMN:=TR:/TR,'EFILE'
$	FORTRAN/NOLIST'DEBSW' X'P2'
$	IF .NOT.$STATUS THEN GOTO EXIT
$	'DELCOM' X'P2'.FOR'PIPSW'
$	PVV X'P2'
$	DELETE ADC.IDE;*
$	LIBR/REPLACE/LOG 'LIB' X'P2'
$	IF $STATUS THEN DELETE X'P2'.OBJ;*
$EXIT:
$!	'f$verify(0)
$	set def 'SAVDIR'
$ERRXT:	if savver then set verify
