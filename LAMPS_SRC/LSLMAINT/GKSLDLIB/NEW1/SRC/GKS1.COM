$!
$! command file to create a new GKSLDLIB for one workstation
$!
$ set noverify
$!
$	dbg = ""
$	inquire debug "with debug "
$	if debug then dbg = "/debug/noopt"
$!
$	inquire BLKD  "Block data "
$	inquire UNIT  "Units      "
$	inquire LINE  "GKS1       "
$	inquire AREA  "GFA1       "
$	inquire TEXT  "GTX1       "
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
$noBLKD:if .not.UNIT then goto noUNIT
$	   ADC		GKSMM1=GKSMM.TRU/TR,GKSUNI1
$	   FORTRAN'dbg'	GKSMM1
$	   PVV GKSMM1
$	   DELETE	ADC.IDE;*
$	   PURGE	GKSMM1.OBJ
$	   ADC		GKSCM1=GKSCM.TRU/TR,GKSUNI1
$	   FORTRAN'dbg'	GKSCM1
$	   PVV GKSCM1
$	   DELETE	ADC.IDE;*
$	   PURGE	GKSCM1.OBJ
$noUNIT:if .not.LINE then goto noLINE
$	   ADC		GKS1=GKS1
$	   FORTRAN'dbg'	GKS1
$	   PVV		GKS1
$	   DELETE	ADC.IDE;*
$	   PURGE	GKS1.OBJ
$noLINE:if .not.AREA then goto noAREA
$	   ADC		GFA1=GFA1
$	   FORTRAN'dbg'	GFA1
$	   PVV		GFA1
$	   DELETE	ADC.IDE;*
$	   PURGE	GFA1.OBJ
$noAREA:if .not.TEXT then goto noTEXT
$	   ADC		GTX1=GTX1
$	   FORTRAN'dbg'	GTX1
$	   PVV		GTX1
$	   DELETE	ADC.IDE;*
$	   PURGE	GTX1.OBJ
$noTEXT:if .not.DUMMY then goto noDUMMY
$	   ADC		GKDUMM=GKDUMM
$	   FORTRAN'dbg'	GKDUMM
$	   PVV		GKDUMM
$	   DELETE	ADC.IDE;*
$	   PURGE	GKDUMM.OBJ
$NODUMMY:$!
$ if .not.debug then delete *.FOR;*
$!
$! FILLSIDEQ replaces FILL_SIDE routine, but FILLSIDE.OBJ still required for
$! sorting routines
$ LIBRARY/CREATE=(BL:50) GKSLDLIB BLKDAT1,GKSMM1,GKS1,GFA1,GTX1,-
                         GKDUMM,[-.FILL]FILLSIDE,FILLSIDEQ
$ LIBRARY/INSERT/NOGLOBALS/LOG GKSLDLIB GKSCM1
$!
