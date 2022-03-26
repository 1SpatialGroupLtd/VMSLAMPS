$! LSDISKS.COM - define [and mount] LSL disks. Called from LSSTARTUP.COM
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$! Defines disk logical names, and possibly mounts any LSL-specific disks.
$! It is more usual to mount system-wide disks from SYSTARTUP_V5.COM.
$!
$! Uncomment any lines below which are relevant to your installation.
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$	WS "LSDISKS.COM - set up LSL disks"
$!
$! Mount all disks known to cluster (if not done in SYSTARTUP_V5).
$!
$!!!	@LSL$STARTUP:LSDISKS_MOUNT
$!
$! Assign logical names to them
$!
$	@LSL$STARTUP:LSDISKS_LOGICALS
$!
$	EXIT
