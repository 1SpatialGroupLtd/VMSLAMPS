$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1980-01-01 13:11:54.000000000 +0000
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
C
C Master common block for command program
C
	COMMON/MASTER/MESSAG,NUMINT,NUMREL,INTAR(8),REALAR(8),
     *         QUECOM,QUETIM,TKPERS,REDFOC,BLUFOC,
     *         FNUM,QDRNT,EOP,CPDONE,CPGOT,CCGOT,HADTIK,
     *         NSMESS(80),SYSNAM(40),IFFNAM(40)
C
	EQUIVALENCE (INTAR(1),INTARG)
	EQUIVALENCE (REALA1,REALAR(1)),(REALA2,REALAR(2))
C
	INTEGER MESSAG	! no. of message to output (in MAIN)
			!  <=0 - no message
	INTEGER NUMINT	! number of integer args present
	INTEGER NUMREL	!    "    "  real     "     "
	INTEGER INTAR	! array of integer arguments (INTARG is first)
	REAL    REALAR	! obvious, REALA1 & REALA2 are 1st 2
	INTEGER QUECOM	! queued command number
	INTEGER QUETIM	! queue time (in ticks)
	INTEGER TKPERS	! "ticks per second" - set up in init
	INTEGER REDFOC	! focus level for red beam
	INTEGER BLUFOC	! focus level for blue
	INTEGER FNUM(MAXOVR) ! NF number of feature
	INTEGER QDRNT	! quadrant of map (always zero if LA)
	LOGICAL*1 EOP	! end of plot
	LOGICAL*1 CPDONE! corner point measurement done
	LOGICAL*1 CPGOT	! know where CPs are, roughly
	LOGICAL*1 CCGOT	! read CCs in from data file
	LOGICAL*1 HADTIK ! tick overlay output
C three strings, all .ASCIZ:
	BYTE NSMESS	! new section message
	BYTE SYSNAM	! system parameter file name
	BYTE IFFNAM	! output file name
C
