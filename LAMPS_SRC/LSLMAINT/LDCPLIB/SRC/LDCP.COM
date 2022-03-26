$	VER='F$VERIFY(0)
$	inquire CMP "Compile"
$	inquire BLD "Build"
$	inquire DBG "Debug"
$	if .not.DBG then DEB=""
$	if	DBG then DEB="/DEBUG"
$	inquire LST "Listing"
$	if .not.LST then LST=""
$	if	LST then LST="/LIST"
$	on error then goto QUIET
$	if .not.CMP then goto TRYBLD
$! compile
$	SET VERIFY
$	ADC CPPGEN=CPPGEN,DSUBST,DREPT
$	FORTRAN/NOI4'DEB''LST' CPPGEN
$	PVV CPPGEN
$	DELETE ADC.IDE;*
$
$	ADC LDCPLIB=LDCPLIB
$	FORTRAN/NOI4'DEB''LST' LDCPLIB
$	PVV LDCPLIB
$	DELETE ADC.IDE;*
$	V='F$VERIFY(0)
$! build
$TRYBLD:if .not.BLD then goto QUIET
$	SET VERIFY
$	LIB/CRE LDCPLIB LDCPLIB,CPPGEN
$	V='F$VERIFY(0)
$	DELETE LDCPLIB.OBJ;*,CPPGEN.OBJ;*
$	if DEB.EQS."" then DELETE LDCPLIB.FOR;*,CPPGEN.FOR;*
$	purge
$QUIET:	V='F$VERIFY(0)
$	IF VER THEN SET VERIFY
