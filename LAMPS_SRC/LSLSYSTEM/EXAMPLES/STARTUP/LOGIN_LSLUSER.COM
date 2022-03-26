$! LSLUSER's LOGIN.COM
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$	SAVVER='F$VERIFY(0)'
$	SET NOON
$	SET NOCONTROL_Y
$!
$! call LAMPS central login definitions file (usually done from SYS$SYLOGIN)
$!
$!!!	@SYS$MANAGER:LSLOGIN
$!
$! set up symbol definitions in alphabetic order
$!
$	DI	=="DIRECTORY"		! shorthand
$	DIR	=="DIRECTORY/DATE/SIZE=ALL/OWNER/WID=(OWNER:19)" ! shorthand
$!
$! tidy up and exit
$!
$	SET CONTROL_Y
$	SET CONTROL=T
$	IF SAVVER THEN SET VERIFY
