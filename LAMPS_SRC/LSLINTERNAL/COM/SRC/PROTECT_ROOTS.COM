$! command file to set appropriate protections and ACLs on public roots.
$! Created							PGH 30-Jun-1995
$!MOD Set dir dates in past, to avoid BACKUP 6.2 problem	PGH 15-Aug-1996
$!
$ SET NOON
$ WS="WRITE SYS$OUTPUT"
$ HADSYSPRV=F$PRIV("SYSPRV")
$ SET PROCESS/PRIV=SYSP
$ HADSYSPRV=F$PRIV("SYSPRV")
$ IF .NOT.HADSYSPRV THEN WS "SYSPRV is needed for this procedure"
$ IF .NOT.HADSYSPRV THEN EXIT
$!
$! set up DECUS FILE utility to allow date change
$!
$ ARCH_NAME=F$GETSYI("ARCH_NAME")
$ ARCH_SUFFIX=""
$ IF ARCH_NAME.EQS."Alpha" THEN ARCH_SUFFIX="_TV"
$ FILE="$LSL$EXE:FILE"+ARCH_SUFFIX
$!
$! protect all the main roots
$!
$ ROOT="ISSUE"
$ GOSUB PROTECT_ROOT
$ ROOT="LAST_ISSUE"
$ GOSUB PROTECT_ROOT
$ ROOT="PUBLIC"
$ GOSUB PROTECT_ROOT
$!
$! all done
$!
$ IF .NOT.HADSYSPRV THEN SET PROCESS/PRIV=NOSYSP
$ WS "All done"
$ EXIT
$!
$!
$! subroutine to protect a particular root
$!
$PROTECT_ROOT:
$ DEV=F$PARSE(F$TRNLNM("LSL$''ROOT'_ROOT"),,,"DEVICE")
$ DIRNAME=ROOT-"_"
$ WS " "
$ WS "Processing LSL$''ROOT'_ROOT:"
$ WS " "
$ WS "Protecting root directory ''DEV'[000000]LSL''DIRNAME'.DIR"
$ WS " "
$ SET FILE 'DEV'[000000]LSL'DIRNAME'.DIR -
	/OWNER=LSLSOFT -
	/PROT=(S:RWE,O:RWE,G:RE,W:E) -
	/ACL=(IDENTIFIER=LSLPUBLISH,ACCESS=READ+WRITE+CONTROL)
$ WS "Setting directory modification dates to avoid BACKUP V6.2 problems"
$ FILE 'DEV'[000000]LSL'DIRNAME'.DIR -
	/CREATION_DATE="1-Jan-1990 00:00:00.00" -
	/NOREVISION_DATE
$ WS " "
$ DI/ACL/OWN/DATE=(CRE,MOD) 'DEV'[000000]LSL'DIRNAME'.DIR
$ WS " "
$ WS "Protecting subdirectories LSL$''ROOT'_ROOT:[*...]*.DIR"
$ WS " "
$ SET FILE LSL$'ROOT'_ROOT:[*...]*.DIR/LOG -
	/OWNER=LSLSOFT -
	/PROT=(S:RWE,O:RWE,G:RE,W:E) -
	/ACL=(IDENTIFIER=LSLPUBLISH,ACCESS=READ+WRITE+CONTROL)
$ WS "Setting directory modification dates to avoid BACKUP V6.2 problems"
$ FILE LSL$'ROOT'_ROOT:[*...]*.DIR -
	/CREATION_DATE="1-Jan-1990 00:00:00.00" -
	/NOREVISION_DATE
$ RETURN
$!
