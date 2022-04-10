$! LSDISKS_MOUNT.COM - mount LSL disks. Called from LSSTARTUP.COM
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$! Mount any LSL-specific disks.
$! It is now more usual to mount system-wide disks from SYSTARTUP_V5.COM.
$!
$!
$! Uncomment and modify any lines below which are relevant to your installation.
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$	WS "LSDISKS_MOUNT.COM - Mounting LSL disks"
$!
$!!!	MOUNT/SYSTEM/NOASSIST	DUB0:		USERDISK1
$!!!	MOUNT/SYSTEM/NOASSIST	DUA1:		USERDISK2
$!
$	EXIT
