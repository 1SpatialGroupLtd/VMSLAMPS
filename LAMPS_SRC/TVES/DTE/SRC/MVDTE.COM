$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1985-09-11 13:30:24.000000000 +0100
$! *
$! * This program is free software: you can redistribute it and/or modify
$! * it under the terms of the GNU General Public License as published by
$! * the Free Software Foundation, version 3.
$! *
$! * This program is distributed in the hope that it will be useful, but
$! * WITHOUT ANY WARRANTY; without even the implied warranty of
$! * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
$! * General Public License for more details.
$! *
$! * You should have received a copy of the GNU General Public License
$! * along with this program. If not, see http://www.gnu.org/licenses/.
$!
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
