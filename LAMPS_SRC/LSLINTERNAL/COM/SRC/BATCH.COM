$	SAVVER='F$VERIFY(0)
$!
$! Central LSL batch job submit procedure, called by BATCH command.
$! also called indirectly by PBATCH,FBATCH commands having first set up
$! options in symbols of the form BAT$thing, eg BAT$QUEUE.
$!
$! first argument is the command file to be executed, if null then
$! it will prompt for a single command line.
$!
$! before executing commands in file it will transfer from the current
$! environment the default directory and the account to be charged to.
$!
$!MOD Don't use CHARGE, as withdrawn now		PGH	11-Nov-1991
$!MOD Don't redefine SD in case on AXP			PGH	 8-Oct-1993
$!
$	BAT$COM:=""
$	IF P1 .NES. "" THEN GOTO OK
$	INQUIRE/NOP BAT$COM "Command line ? "
$	IF BAT$COM .EQS. "" THEN EXIT
$	BAT$FILE:=BATTMP
$	GOTO GOTNAME
$OK:
$	BAT$TP1=F$PARSE(P1,".COM",,,"NO_CONCEAL") - "]["
$	IF BAT$TP1.EQS."" THEN GOTO NPARSE
$	IF F$SEARCH(BAT$TP1).EQS."" THEN GOTO NOSUCH
$	BAT$FILE:='F$PARSE(P1,,,"NAME")'
$GOTNAME:
$! preserve the current default directory and account
$	HERE:='F$LOG("SYS$DISK")''F$DIR()
$	HERE=F$PARSE(HERE,,,,"NO_CONCEAL") - "][" - ".;"
$	OPEN/WRITE BATFILE 'BAT$FILE'.BAT
$!!!	WRITE BATFILE "$	CHARGE ''SYS$ACCOUNT'"
$!!!	WRITE BATFILE "$	SD:=$LSL$EXE:SD"
$	WRITE BATFILE "$	SD ",HERE
$	IF P1 .EQS."" THEN GOTO NOP1
$! call the given command file
$	WRITE BATFILE "$	@",BAT$TP1," ",P2," ",P3,-
		" ",P4," ",P5," ",P6," ",P7," ",P8
$	BAT$DELETE:='BAT$DELETE'
$	IF BAT$DELETE .NES. "" THEN WRITE BATFILE "$	DELETE/LOG ",BAT$TP1
$NOP1:	IF BAT$COM .NES. "" THEN WRITE BATFILE "$ ",BAT$COM
$	WRITE BATFILE "$	SET NOVERIFY"
$	WRITE BATFILE "$	COST"
$	CLOSE BATFILE
$! assume default queue unless BAT$QUEUE is set up
$	BAT$QUEUE:='BAT$QUEUE'
$	IF BAT$QUEUE.EQS."FAST" THEN BAT$QUEUE:=FASTBATCH
$	IF BAT$QUEUE.NES."" THEN BAT$QUEUE:=/QUEUE='BAT$QUEUE'
$! assume no log file to be kept unless BAT$LOG is set up
$	BAT$LOG:='BAT$LOG'
$	IF BAT$LOG.NES."" THEN BAT$LOG:=/LOG='BAT$LOG'/NOPRINT
$!
$! actually do the submit now
$	SUBMIT/NOTIFY/DELETE'BAT$QUEUE''BAT$LOG''BAT$OPTION' 'BAT$FILE'.BAT
$	GOTO END
$NPARSE:WRITE SYS$OUTPUT "Bad filespec ",P1
$	GOTO END
$NOSUCH:WRITE SYS$OUTPUT "No such file as ",BAT$TP1
$END:	IF SAVVER THEN SET VERIFY
