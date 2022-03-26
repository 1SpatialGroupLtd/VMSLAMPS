$! To link DTE with VSLIB for MicroVax
$	LINK/map=mvdte/exe=mvdte DTE,-	 ! main program
		DTE1,DTE2,DTE3,DTE4,-	 ! subroutines
		DTE5,DTE6,DTE7,DTE8,-
		DTE9,DTE10,DTE11,DTE12,-
		DTE13,DTE14,DTE15,-
		DTECMD,-		 ! command table
		DUA0:[LIB.VSLIB2.MICROVAX]VSOD,VSVG,VSSG,-
		LSL$LIBRARY:TABLIB/LIB,- ! for the ALTEK table monitor
		LSL$LIBRARY:VSLIB/LIB,-	 ! for the SIGMA args 7000 libr.
		LSL$LIBRARY:WOSPLIB/LIB,-! for the TEKTRONIX T4014 libr.
		LSL$LIBRARY:CMDLIB/LIB,- ! for DTE command interpretat'n
		LSL$LIBRARY:VIOLIB/LIB   ! for VDU I/O
$!
$	PURGE/LOG *.MAP
$	PURGE/LOG *.EXE
$!
