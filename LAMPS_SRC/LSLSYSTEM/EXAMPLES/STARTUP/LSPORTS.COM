$! LSPORTS.COM - set LSL terminal server ports. Called from LSSTARTUP.COM
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$! Creates the port devices, sets the terminal characteristics, protections, 
$! and logical names for any terminal server lines used by LSL software.
$! See also separate file called LSTERMS.COM for devices on direct serial lines.
$!
$! Uncomment any lines below which are relevant to your installation.
$! you will almost certainly need to modify lines to suit configuration.
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$!
$! first check that we are needed at all
$!
$	IF .NOT.F$GETDVI("LTA0","EXISTS") THEN EXIT
$!
$	WS "LSPORTS.COM - Setting up terminal server ports"
$!
$! Invoke LATCP and create and map the necessary ports.
$! Device naming scheme is LTA9spn where:
$!					s = server number
$!					p = port number
$!					n = 0-9 allowing merged ports
$! 					servers are named LSLDSA, LSLDSB, etc.
$!
$	RUN SYS$SYSTEM:LATCP
!!!CREATE PORT LTA9110: /NOLOG	! ALTEK digitising table for LITES2
!!!SET PORT LTA9110: /APPLICATION /NODE=LSLDSA /PORT=PORT_1 /NOLOG
!
!!!CREATE PORT LTA9120: /NOLOG	! Calcomp electrostatic plotter
!!!SET PORT LTA9120: /APPLICATION /NODE=LSLDSA /PORT=PORT_2 /NOLOG
!
!!!CREATE PORT LTA9130: /NOLOG	! LN03 printer
!!!SET PORT LTA9130: /APPLICATION /NODE=LSLDSA /PORT=PORT_3 /NOLOG
$!
$! Set up LSL logicals to the devices. See LSTERMS.COM and LITES2INI.COM
$! for hints on setting up the LSL$WSn_xxx logical names to tables, 
$! VDUs, and GDUs.
$!
$!!!	DEFINE/SYSTEM	LSL$WS1_VDU		LSLDSA_PORT_5	! for LITES2 VDU
$!!!	DEFINE/SYSTEM	LSL$WS1_TABLE		LTA9110:	! for LITES2
$!!!	DEFINE/SYSTEM	LSL$DIG1		LTA9110:	! Altek DIGSYS
$!!!	DEFINE/SYSTEM	LSL$MONITOR_TABLE	LTA9110:	! for TVES
$!!!	DEFINE/SYSTEM	LSL$CALCOMP		LTA9120:	! Calcomp
$!!!	DEFINE/SYSTEM	LSL$LNP			LTA9130:	! LN03 printer
$!
$! Stop broadcasts to the ports
$!
$!!!	SET TERM/PERM/NOBRO			LTA9110:	! Altek
$!!!	SET TERM/PERM/NOBRO			LTA9120:	! Calcomp
$!!!	SET TERM/PERM/NOBRO			LTA9130:	! LN03
$!
$! Set the protection, so we can allocate it
$!
$!!!	SET PROTECTION=(W:RWLP)/DEVICE/OWNER=[LSLSOFT] LTA9110:
$!!!	SET PROTECTION=(W:RWLP)/DEVICE/OWNER=[LSLSOFT] LTA9120:
$!!!	SET PROTECTION=(W:RWLP)/DEVICE/OWNER=[LSLSOFT] LTA9130:
$!
$	EXIT
