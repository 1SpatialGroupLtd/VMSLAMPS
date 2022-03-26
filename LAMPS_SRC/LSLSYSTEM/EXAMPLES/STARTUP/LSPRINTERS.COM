$! LSPRINTERS.COM - start LSL printers. Called from LSSTARTUP.COM
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$! Starts LSL-specific printer queues. Note that the queue manager, and any
$! system printer queues are assumed to be started using the facilities in
$! the DEC-supplied file SYS$MANAGER:SYSTARTUP_V5.COM.
$!
$! Uncomment any lines below which are relevant to your installation.
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$	WS "LSPRINTERS.COM - setting up printers"
$!
$! set up forms
$!
$!!!	DEFINE/FORM A4	     4	/WIDT=80/MARGIN=(BOTTOM=4)/STOCK=DEFAULT -
$!!!				/NOTRUNCATE/DESCR="A4 paper"
$!
$!
$! Set up local characteristics for the applications devices.
$!
$! Letter quality laser printer (LN03))
$!!!	SET TERMINAL /PERM /DEV=VT200 /SPEED=4800 /WIDTH=80  /PAGE=66 -
$!!!		/INTER /NOBROADCAST /NOWRAP /NOTAB /FORM /EIGHT LSL$LNP:
$!
$! Set the protection on the devices so that anyone can allocate
$!
$!!!	SET PROTECTION=(W:RWLP)/DEVICE	LSL$LNP:
$!
$! Set the devices spooled.
$!
$!!!	SET DEVICE LSL$LNP: /SPOOLED=(LN03_PRINT,SYS$SYSDEVICE:)
$!
$! Initialize the remote printer queues.
$! The following assumes that the queue manager has been started.
$!
$!!!	INITIALIZE/QUEUE /START /PROCESSOR=LATSYM /SCHED=NOSIZE	/PROT=(G:RD) -
$!!!		/SEPARATE=(FLAG)/RECORD_BLOCKING LN03_PRINT /ON=LSL$LNP:
$!
$	EXIT 
