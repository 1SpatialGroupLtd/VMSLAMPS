$! LSSYSTARTUP.COM - VMS System startup file for Laser-Scan Mapping/GIS. 
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL, after DM			PGH	11-Jul-1990
$!
$! This procedure can be called from the end of SYSTARTUP_V5.COM,
$! just before the call to LSSTARTUP which defines the required LSL environment.
$!
$! This file contains VMS system management commands which may or may not be
$! appropriate to your system, and are not strict prerequisites for the 
$! operation of LSL software. They may however be useful as reminders and
$! templates for setting up your VMS environment.
$!
$! Uncomment and modify any lines below which are relevant to your installation.
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$	WS "Entering LSSYSTARTUP.COM - Laser-Scan system startup file"
$!
$! Set parameters for the VMS Workstation Software for more windows.
$! Note that this line should only be uncommented if the appropriate values
$! for NPAGEDYN etc have been set in MODPARAMS.DAT (see VWS Installation Guide).
$!
$!!!!	DEFINE/SYSTEM/EXEC	UIS$QVSS_POOL_SIZE	1522300
$!
$! This command defines a message to be displayed before each user logs in. 
$	NODE=F$TRNLNM("SYS$NODE") - "::"
$	DEASSIGN /SYSTEM SYS$ANNOUNCE
$	DEFINE /SYSTEM SYS$ANNOUNCE -
	"	Welcome to Laser-Scan node ''NODE' running VAX/VMS ''F$GETSYI("VERSION")'"
$	DEFINE/SYSTEM	PSM$ANNOUNCE	"Laser-Scan node ''NODE'"
$!
$! odds and ends
$!!!	SET ACCOUNTING/DISABLE=(LOGIN_FAILURE,PRINT)
$!!!	PURGE SYS$MANAGER:OPERATOR.LOG/KEEP=2
$!
$	EXIT
