$	V='F$VERIFY(0)
$! Copyright Laser-Scan Laboratories Ltd, Cambridge, England
$! Author					DM	1984
$!
$! Procedure for reporting multiple versions of files.
$! Example is $ MV [DOC...]
$!
$	SET ON
$	ON ERROR THEN GOTO EXIT
$	ON CONTROL THEN GOTO EXIT
$	WS="WRITE SYS$OUTPUT"
$	P2=F$PARSE(P1,"*.*;-1")
$	IF P2 .NES. "" THEN GOTO OK
$	P2=F$SEARCH(P1)
$	GOTO EXIT				! report error & exit
$ OK:	IF P1 .EQS. "" THEN GOTO PAR
$	IF F$TRNLNM(P1,,,,,"MAX_INDEX") .EQ. 0 THEN GOTO PAR
$	P2=P1 - ":" + ":*.*;-1"
$ PAR:	DEV=F$PARSE(P2,,,"DEVICE")		! only 1 device per run
$ 	NFILES=0
$	TOTFIL=0
$	NDIRS=0
$	OLDDIR=""
$	TOTASZ=0
$	TOTESZ=0
$	GTOTAS=0
$	GTOTES=0
$ !
$ REC:	ON ERROR THEN GOTO CHECK
$ AGAIN:
$	GENFIL=F$SEARCH(P2,1)
$	IF GENFIL .EQS. "" THEN GOTO END
$	DIRE=F$PARSE(GENFIL,,,"DIRECTORY")	! got a general filename
$	IF DIRE .EQS. OLDDIR THEN GOTO SAMDIR
$	NDIRS=NDIRS + 1				! new directory
$	IF NDIRS .EQ. 1 THEN GOTO DIR1		! is it the first ?
$	IF NFILES .EQ. 0 THEN GOTO DIR1
$	WS ""
$	WS "''F$FAO("Total of !SL file!%S, !SL/!SL block!%S.", -
			NFILES,		TOTESZ,TOTASZ)'"
$	TOTFIL=TOTFIL + NFILES
$	GTOTAS=GTOTAS + TOTASZ
$	TOTASZ=0
$	GTOTES=GTOTES + TOTESZ
$	TOTESZ=0
$	NFILES=0
$ DIR1:	OLDDIR=DIRE
$	WS ""
$	WS "Directory ",DEV,DIRE
$	WS ""
$ SAMDIR:	
$	LOC=F$LOC(";",GENFIL)
$	GENFIL=F$EXT(0,LOC,GENFIL)+";*"
$ LOOP:
$	FILNAM=F$SEARCH(GENFIL,2)
$	IF FILNAM .EQS. "" THEN GOTO AGAIN
$	NFILES=NFILES + 1			! got a specific file
$	FILE=FILNAM - DIRE - DEV
$	ASIZE=F$FILE(FILNAM,"ALQ")
$	IF .NOT. $STATUS THEN GOTO LOOP		! give up if error
$	ESIZE=F$FILE(FILNAM,"EOF")
$	RDATE=F$FILE(FILNAM,"RDT")
$	OWNER=F$FILE(FILNAM,"UIC")
$	PROT =F$FILE(FILNAM,"PRO") - "SYSTEM" - "=" - 
		- " OWNER" - "=" - " GROUP" - "=" - " WORLD" - "="
$	IF F$LENGTH(FILE) .GT. 19 THEN GOTO TWOL
$	WS "''F$FAO("!19AS !5UW/!5<!UW!> !17AS !AS (!AS)",-
	  FILE,ESIZE,ASIZE,RDATE,OWNER,PROT)'"
$	GOTO SUM
$ TWOL:
$	WS "''F$FAO("!AS",FILE)'"
$	WS "''F$FAO("!20* !5UW/!5<!UW!> !17AS !AS (!AS)",-
	  ESIZE,ASIZE,RDATE,OWNER,PROT)'"
$ SUM:
$	TOTASZ=TOTASZ + ASIZE
$	TOTESZ=TOTESZ + ESIZE
$	GOTO LOOP
$ !
$ CHECK:IF $STATUS .EQS. "%X00000024" THEN GOTO	REC   ! priv violation ?
$ END:	IF NDIRS .EQ. 0 THEN GOTO NONE
$	WS ""
$	WS "''F$FAO("Total of !SL file!%S, !SL/!SL block!%S.", -
			NFILES,		TOTESZ,TOTASZ)'"
$	IF NDIRS .EQ. 1 THEN GOTO EXIT
$	TOTFIL=TOTFIL + NFILES
$	GTOTAS=GTOTAS + TOTASZ
$	GTOTES=GTOTES + TOTESZ
$	WS ""
$	WS "''F$FAO( -
	"Grand total of !SL directories, !SL file!%S, !SL/!SL block!%S.", -
			NDIRS,		TOTFIL, 	GTOTES,GTOTAS)'"
$	GOTO EXIT
$ NONE: WS "  No multiple versions."
$ EXIT:	IF V THEN SET VERIFY
