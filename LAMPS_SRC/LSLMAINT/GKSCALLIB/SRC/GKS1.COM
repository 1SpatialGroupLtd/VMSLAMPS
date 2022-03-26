$!
$! command file to create a new GKSCAL5800LIB for one workstation
$!
$ set noverify
$!
$	dbg = ""
$	inquire debug "with debug "
$	if debug then dbg = "/debug/noopt"
$!
$	inquire BLKD "Block data "
$	inquire LINE "GKS1       "
$	inquire AREA "GFA1       "
$	inquire TEXT "GTX1       "
$	inquire PIX "GCA1       "
$	inquire GKSCOL "GKSCOL     "
$	inquire DUMMY "Dummy      "
$!
$ set verify
$!
$	if .not.BLKD then goto noBLKD
$	   ADC		BLKDAT1=BLKDAT1
$	   FORTRAN'dbg'	BLKDAT1
$	   PVV		BLKDAT1
$	   DELETE	ADC.IDE;*
$	   PURGE	BLKDAT1.OBJ
$ if .not.debug then delete BLKDAT1.FOR;*
$noBLKD:if .not.LINE then goto noLINE
$	   ADC		GKS1=GKS1,LINE
$	   FORTRAN'dbg'	GKS1
$	   PVV		GKS1
$	   DELETE	ADC.IDE;*
$	   PURGE	GKS1.OBJ
$ if .not.debug then delete GKS1.FOR;*
$noLINE:if .not.AREA then goto noAREA
$	   ADC		GFA1=GFA1,GKS_CLIP_AREA
$	   FORTRAN'dbg'	GFA1
$	   PVV		GFA1
$	   DELETE	ADC.IDE;*
$	   PURGE	GFA1.OBJ
$ if .not.debug then delete GFA1.FOR;*
$noAREA:if .not.TEXT then goto noTEXT
$	   ADC		GTX1=GTX1
$	   FORTRAN'dbg'	GTX1
$	   PVV		GTX1
$	   DELETE	ADC.IDE;*
$	   PURGE	GTX1.OBJ
$ if .not.debug then delete GTX1.FOR;*
$noTEXT:if .not.PIX then goto noPIX
$	   ADC		GCA1=GCA1
$	   FORTRAN'dbg'	GCA1
$	   PVV		GCA1
$	   DELETE	ADC.IDE;*
$	   PURGE	GCA1.OBJ
$	   MACRO	LSG_LOOP
$	   PURGE	LSG_LOOP.OBJ
$ if .not.debug then delete GCA1.FOR;*
$noPIX:if .not.GKSCOL then goto noGKSCOL
$	   ADC		GKSCOL=GKSCOL,LSG_SIZE
$	   FORTRAN'dbg'	GKSCOL
$	   PVV		GKSCOL
$	   DELETE	ADC.IDE;*
$	   PURGE	GKSCOL.OBJ
$ if .not.debug then delete GKSCOL.FOR;*
$noGKSCOL:if .not.DUMMY then goto noDUMMY
$	   ADC		GKDUMM=GKDUMM
$	   FORTRAN'dbg'	GKDUMM
$	   PVV		GKDUMM
$	   DELETE	ADC.IDE;*
$	   PURGE	GKDUMM.OBJ
$ if .not.debug then delete GKDUMM.FOR;*
$NODUMMY:
$!
$! FILLSIDEQ replaces FILL_SIDE routine, but FILLSIDE.OBJ still required for
$! sorting routines
$ LIBRARY/CREATE=(BL:50) GKSCAL5800LIB -
 BLKDAT1,GKS1,GFA1,GTX1,GCA1,LSG_LOOP,GKSCOL,GKDUMM, -
 LSL$SOURCE_ROOT:[LSLMAINT.GKSLDLIB.FILL]FILLSIDE,FILLSIDEQ,GKS_CLIP_POLY2
$!
$	set noverify
