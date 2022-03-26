$! LSLSOFT's LOGIN.COM
$	SAVVER='F$VERIFY(0)'
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$!
$! call LAMPS central login definitions file (usually done from SYS$SYLOGIN)
$!
$!!!	@SYS$MANAGER:LSLOGIN
$!
$	IF F$MODE().EQS."NETWORK" THEN GOTO NETJOB	! speed up FAL
$!
$! set up symbol definitions in alphabetic order
$!
$	DI	=="DIRECTORY"		! shorthand
$	DIR	=="DIRECTORY/DATE/SIZE=ALL/OWNER/WID=(OWNER:19)" ! shorthand
$	EDT	=="EDIT/EDT"		! normal editor
$	CED	==EDT			! must come after EDT
$	CVT	=="$LSL$EXE:CVT"	! number conversion
$	ERR*OR	==CVT+"/ERROR"		! convert number to system error msg
$	NV	=="@LSL$COM:NV"		! New Version - EDT,PID,PURGE
$	PID	=="$LSL$EXE:PID"	! patch identification field
$	PL	=="PURGE/LOG"		! shorthand
$	PRO*TECT=="@LSL$SYS:PROTECT"	! file protection
$	SL	=="SHOW LOGICAL"	! shorthand
$	SQB	=="SHOW QUEUE/BATCH/ALL"! shorthand
$	SQP	=="SHOW QUEUE/DEVICE/ALL"	! Show devices (printers)
$	SS	=="SHOW SYMBOL"		! shorthand
$	V	==EDT+"/READONLY/NOCREATE"	! look at file without changing
$!
$! network jobs join here
$NETJOB:
$EXIT:
$!
$! tidy up and exit
$!
$	SET CONTROL_Y
$	SET CONTROL=T
$	IF SAVVER THEN SET VERIFY
