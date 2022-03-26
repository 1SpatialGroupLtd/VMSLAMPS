$!
$! command file to create a new GKSFERLIB for one workstation
$!
$ ver = 'f$verify(0)
$ set noon
$!
$	dbg = ""
$	inquire debug "with debug "
$	if debug then dbg = "/debug/noopt"
$!
$	inquire BLKD	"Block data "
$	inquire CONTROL	"Control    "
$	inquire ESCAPE	"Escape     "
$	inquire TRANS	"Transforms "
$	inquire LINE	"Polyline   "
$	inquire MARKER	"Polymarker "
$	inquire AREA	"Fill Area  "
$	inquire GDP	"GDP        "
$	inquire UTIL	"Utilities  "
$	inquire FER	"Ferranti   "
$!
$ set verify
$!
$	if .not.BLKD then goto noBLKD
$	   ADC		BLKDAT1=BLKDAT1
$	   FORTRAN'dbg'	BLKDAT1
$	   PVV		BLKDAT1
$	   DELETE	ADC.IDE;*
$	   PURGE	BLKDAT1.OBJ
$noBLKD:if .not.CONTROL then goto noCONTROL
$	   ADC		CONTROL=CONTROL
$	   FORTRAN'dbg'	CONTROL
$	   PVV		CONTROL
$	   DELETE	ADC.IDE;*
$	   PURGE	CONTROL.OBJ
$noCONTROL:if .not.ESCAPE then goto noESCAPE
$	   ADC		ESCAPE=ESCAPE
$	   FORTRAN'dbg'	ESCAPE
$	   PVV		ESCAPE
$	   DELETE	ADC.IDE;*
$	   PURGE	ESCAPE.OBJ
$noESCAPE:if .not.TRANS then goto noTRANS
$	   ADC		TRANS=TRANS
$	   FORTRAN'dbg'	TRANS
$	   PVV		TRANS
$	   DELETE	ADC.IDE;*
$	   PURGE	TRANS.OBJ
$noTRANS:if .not.LINE then goto noLINE
$	   ADC		LINE=LINE
$	   FORTRAN'dbg'	LINE
$	   PVV		LINE
$	   DELETE	ADC.IDE;*
$	   PURGE	LINE.OBJ
$noLINE:if .not.MARKER then goto noMARKER
$	   ADC		MARKER=MARKER
$	   FORTRAN'dbg'	MARKER
$	   PVV		MARKER
$	   DELETE	ADC.IDE;*
$	   PURGE	MARKER.OBJ
$noMARKER:if .not.AREA then goto noAREA
$	   ADC		AREA=AREA
$	   FORTRAN'dbg'	AREA
$	   PVV		AREA
$	   DELETE	ADC.IDE;*
$	   PURGE	AREA.OBJ
$noAREA:if .not.GDP then goto noGDP
$	   ADC		GDP=GDP
$	   FORTRAN'dbg'	GDP
$	   PVV		GDP
$	   DELETE	ADC.IDE;*
$	   PURGE	GDP.OBJ
$noGDP:if .not.UTIL then goto noUTIL
$	   ADC		UTIL=UTIL
$	   FORTRAN'dbg'	UTIL
$	   PVV		UTIL
$	   DELETE	ADC.IDE;*
$	   PURGE	UTIL.OBJ
$noUTIL:if .not.FER then goto noFER
$	   ADC		FER=FER
$	   FORTRAN'dbg'	FER
$	   PVV		FER
$	   DELETE	ADC.IDE;*
$	   PURGE	FER.OBJ
$noFER:
$!
$ if .not.debug then delete *.FOR;*
$!
$! FILLSIDEQ replaces FILL_SIDE routine, but FILLSIDE.OBJ still required for
$! sorting routines
$ LIBRARY/CREATE=(BL:50) GKSFERLIB -
		BLKDAT1,CONTROL,ESCAPE,TRANS,-
		LINE,MARKER,AREA,GDP,UTIL,FER,-
		[LSLMAINT.GKSLDLIB.FILL]FILLSIDE,FILLSIDEQ
$!	'F$VERIFY(0)
$	IF VER THEN SET VERIFY
$!
