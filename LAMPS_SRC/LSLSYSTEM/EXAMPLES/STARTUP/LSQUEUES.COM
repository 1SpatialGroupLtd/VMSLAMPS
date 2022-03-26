$! LSQUEUES.COM - start LSL queues. Called from LSSTARTUP.COM
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$! Starts LSL-specific batch queues. Note that the queue manager, and any
$! system batch queues are assumed to be started using the facilities in
$! the DEC-supplied file SYS$MANAGER:SYSTARTUP_V5.COM.
$!
$! Uncomment any lines below which are relevant to your installation.
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$	WS "LSQUEUES.COM - starting queues"
$!
$! start a plotter batch queue, if needed
$!
$!!!	INIT/QUE/START/BATCH/JOB_LIM=1/BASE_PRIO=4/PROT=(G:D,W:RW) PLOTBATCH
$!!!	DEFINE/SYSTEM PLOTBATCH PLOTBATCH
$!
$! Search for package specific queueini's
$!
$Q_INI:
$	QUEUEINI=F$SEARCH("LSL$STARTUP:*QUEUEINI.COM",1)
$	IF QUEUEINI.EQS."" THEN GOTO EXIT
$	@'QUEUEINI
$	GOTO Q_INI
$!
$EXIT:	EXIT
