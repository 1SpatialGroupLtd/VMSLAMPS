$! LSPROCESSES.COM - start LSL detached processes. Called from LSSTARTUP.COM
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$! Starts any LSL detached processes.
$!
$! Uncomment any lines below which are relevant to your installation.
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$!!!	WS "LSPROCESSES.COM - Starting detached processes"
$!
$! start the table monitor for the LITES2 Altek digitising tables
$!
$!!!	STARTMON="$LSL$EXE:STARTMON"
$!!!	STARTMON LSL$WS1_TABLE 16 100 Y
$!!!	STARTMON LSL$WS2_TABLE 16 100 Y
$!!!	STARTMON LSL$WS3_TABLE 16 100 Y
$!
$	EXIT
