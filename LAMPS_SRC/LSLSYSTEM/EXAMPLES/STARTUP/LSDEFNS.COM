$! LSDEFNS.COM - define LSL logicals. Called from LSSTARTUP.COM
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!
$! sets up various LSL logical names to point to directories etc.
$!
$	SET NOON
$	WS="WRITE SYS$OUTPUT"
$	WS "LSDEFNS.COM - Defining LSL logical names"
$!
$! Define name for the directory(s) containing the subsequent LSL startup files
$! This will normally have been done in LSSTARTUP.COM, but checked here because
$! LSDEFNS is sometimes run in isolation during LSLINSTALL installation.
$!
$	IF F$TRNLNM("LSL$STARTUP").EQS."" THEN -
	   DEFINE/SYSTEM	LSL$STARTUP	SYS$MANAGER
$! 
$!
$!
$! Set up system logicals for main roots
$!
$	@LSL$STARTUP:LSDEFNS_ROOTS
$!
$! Set up any definitions local to this node
$!
$	IF F$SEARCH("LSL$STARTUP:LSDEFNS_LOCAL.COM").NES."" THEN -
	   @LSL$STARTUP:LSDEFNS_LOCAL
$!
$! Set up customer and site-specific definitions
$!
$	@LSL$STARTUP:LSDEFNS_SITE
$!
$! Set up search lists for public tree directories
$!
$	@LSL$STARTUP:LSDEFNS_SEARCHLISTS
$!
$!
$! Set up system logicals for devices 
$! (other than serial line ones done in LSPORTS.COM and LSTERMS.COM)
$!
$	@LSL$STARTUP:LSDEFNS_DEVICES
$!
$! Now for the package dependent definitions
$! First the central ones
$!
$! Package LSLSYSTEM
$!
$	Define/System	LSL$LSLSHR	LSL$LIBRARY:LSLSHR
$	Define/System	LSL$CMNLSL -
				LSL$PUBLIC_ROOT:[LSLSYSTEM.COMMON.LSLLIB]
$!
$! Package MAPPING
$!
$	Define/System	LSL$IFFSHR	LSL$LIBRARY:IFFSHR
$	Define/System	LSL$CMNFRT	LSL$PUBLIC_ROOT:[MAPPING.COMMON.FRTLIB]
$	Define/System	LSL$CMNIFF	LSL$PUBLIC_ROOT:[MAPPING.COMMON.IFFLIB]
$	Define/System	LSL$IF		LSL$DATA_ROOT:[LSL.IFF]
$	Define/System	IF		'F$LOGICAL("LSL$IF")'
$	Define/System	LSL$FRT		LSL$SITE_ROOT:[LSL.FRT]
$!
$! Package LITES2
$!
$	Define/System	LSL$LITES2JNL	LSL$LOCAL_ROOT:[LITES2.JNL]
$	Define/System	LSL$LITES2SETUP	LSL$LOCAL_ROOT:[LITES2.JNL]
$	Define/System	LSL$LITES2WORK	LSL$LOCAL_ROOT:[LITES2.WORK]
$	Define/System	LSL$MGMT	LSL$SITE_ROOT:[LSL.MGMT]
$!
$! Now for the non-central packages
$!
$!
$! Package PLOTTING
$!
$	Define/System	LSL$FPP		LSL$SITE_ROOT:[LSL.FPP]
$!
$! Package MATRIX
$!
$	Define/System	LSL$DTI		LSL$DATA_ROOT:[LSL.DTI]
$	Define/System	LSL$CMNDTI	LSL$PUBLIC_ROOT:[MATRIX.COMMON.DTILIB]
$!
$! Package VTRAK
$!
$!!!	Define/System	HLP$LIBRARY	LSL$PUBLIC_ROOT:[VTRAK.HELP]DIGITISER
$!
$	EXIT
