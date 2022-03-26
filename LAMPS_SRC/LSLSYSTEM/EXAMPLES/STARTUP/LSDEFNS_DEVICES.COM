$! LSDEFNS_DEVICES.COM - define LSL device logical names.
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$! Sets up logical names for any devices used by LSL software.
$!
$! Uncomment and modify any lines below which are relevant to your installation.
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$!
$	Define/System	LSL$TK		TKA0:	! Tektronix emulator
$!!!	Define/System	SCANNER		XAA0:	! Joyce-Loebl scanner
$!

