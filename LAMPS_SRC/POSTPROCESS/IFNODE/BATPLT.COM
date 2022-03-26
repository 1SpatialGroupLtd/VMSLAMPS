$	VER=F$VERIFY(0)
$	ON ERROR THEN GOTO EXIT
$! Who is this user?
$	NAME=F$GETJPI("","USERNAME")
$! What is the time and date?
	DATE=F$EXTRACT(0,17,F$TIME())
$! Which file does he want to plot?
$	IF P1 .EQS. "" THEN GOTO ASK
$	IFFFILE=P1
$	GOTO OK
$ASK:	INQUIRE IFFFILE "IFF filename"
$	IF IFFFILE.EQS."" THEN GOTO ASK
$OK:	TMPFILE:='F$SEARCH(IFFFILE)
$	IF TMPFILE.NES."" THEN IFFFILE=TMPFILE
$! Form the header string to be output by the plot.
$	IDENT=IFFFILE+"  USER="+NAME+"  "+DATE
$!
$! Work out the name for the temporary command file to be 
$! passed to the plotter batch queue (which later deletes it).
$! Extract the required part of the filename.
$	CMDFILE=F$PARSE(IFFFILE,,,"NAME")+".COM"
$!
$! Write out the command file.
$	OPEN/WRITE CMDFIL 'CMDFILE'
$	WC:="WRITE CMDFIL"
$ WC "$ ALL TTD1"
$ WC "$ RUN BUR$EXE:PLOTID"
$ WC "''IDENT'"
$ WC "$	BURPLOT:==$BUR$EXE:BURPLOT"
$ WC "$ SI HERE"
$ WC "$ BURPLOT @LSL$DISK:[IFF.IFNODE]BENPAR"
$ WC "IFF ''IFFFILE'"
$ WC "ALL"
$ WC "GO"
$ WC "$ WAIT 0:0:20"
$ WC "$ DEALL TTD1"
$	CLOSE CMDFIL
$!
$! Now submit the command file to the plotter batch queue.
$	BAT$DELETE=1
$	BAT$OPTION="/LOG"
$	PBAT 'CMDFILE'
$!
$EXIT:	IF VER.EQ.1 THEN SET VERIFY
