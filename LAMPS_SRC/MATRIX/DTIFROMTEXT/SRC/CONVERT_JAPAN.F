C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-11-22 12:30:02.000000000 +0000
C *
C * This program is free software: you can redistribute it and/or modify
C * it under the terms of the GNU General Public License as published by
C * the Free Software Foundation, version 3.
C *
C * This program is distributed in the hope that it will be useful, but
C * WITHOUT ANY WARRANTY; without even the implied warranty of
C * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
C * General Public License for more details.
C *
C * You should have received a copy of the GNU General Public License
C * along with this program. If not, see http://www.gnu.org/licenses/.
C
	LOGICAL FUNCTION CONVERT_JAPAN(A,B,C,D,XSIZE,YSIZE,TYPE)
C
CDEC$	IDENT	'22NO91'
C
C       Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Author		JB				20-Aug-1991
C
C Description
C
C	Read text values into DTI array from BINARY Japanese DEM file on disc
C
        IMPLICIT NONE
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'
	INCLUDE 'LSL$CMNDTI:DTIHDR.CMN'
	INCLUDE 'LSL$CMNDTI:DTIPAR.PAR'
	INCLUDE 'LSL$CMNDTI:DTIPROJ.CMN'
	INCLUDE 'HERE:DTIFROMTEXT.CMN'
C
C arguments
	INTEGER	TYPE		! data type
	INTEGER	XSIZE,YSIZE
C
	BYTE		A(*)	! one dimensional for speed
	INTEGER*2	B(*)	! one dimensional for speed
	INTEGER*4	C(*)	! one dimensional for speed
	REAL*4		D(*)
C
C functions
	LOGICAL	RDINT,RDLONG,RDREAL,RDCHS,RDNUM
	INTEGER	FLRLIN
C
C workspace
	INTEGER		STATUS
	INTEGER		X,Y
	REAL		XC,YC
	REAL		RVAL
	INTEGER*4	LVAL
	INTEGER*2	WVAL
	BYTE		BVAL
	BYTE		BV(2)
	EQUIVALENCE	(WVAL,BV)
	EQUIVALENCE	(RVAL,LVAL,WVAL,BVAL)
C
	BYTE		CH
	INTEGER		NLINES
	INTEGER		IND,I
	INTEGER		BUFMAX
	PARAMETER	(BUFMAX=255)
	INTEGER		BUFLEN
	BYTE		BUF(BUFMAX)
	LOGICAL		OK
C
	IND = 0
	NLINES = 0
	TXTPTR = 0
C
	CALL BSLN
C
11	NLINES = NLINES+1
C
10	STATUS = FLRLIN(BUF,BUFLEN,BUFMAX)
	IF (.NOT.STATUS) THEN
	   IF (STATUS.EQ.LSL__EOF) THEN
		STATUS = LSL__NORMAL
		CONVERT_JAPAN = .TRUE.
		GOTO 1000
	   ENDIF
	   CALL TTWSTR('Unexpected end of text file')
	   GOTO 999
	ENDIF
C
	IF (BUFLEN.LE.0) GOTO 11
C
	I = 1

12	IF (I.GT.BUFLEN-1) GOTO 10

	BV(1) = BUF(I)
	BV(2) = BUF(I+1)

	I = I + 2
	IND = IND+1

	IF (IND.GT.XSIZE*YSIZE) GOTO 10
C
	      IF (TYPE.EQ.DATA_REAL) THEN
		 D(IND) = WVAL
	      ELSEIF (TYPE.EQ.DATA_LONG) THEN
	         C(IND) = WVAL		! one dimensional for speed
	      ELSEIF (TYPE.EQ.DATA_WORD) THEN
	         B(IND) = WVAL		! one dimensional for speed
	      ELSE
		 WVAL = MAX(0,MIN(255,WVAL))
	         A(IND) = BVAL		! one dimensional for speed
CCC	         A(X,Y) = BVAL		! actual dimension
	      ENDIF
C
	GOTO 12
C
C Error exit
C
999	CALL WRITEF('Was reading text line %N',NLINES)
	CALL WRITEF('DTI position X=%N, Y=%N',X,Y)
	CONVERT_JAPAN = .FALSE.		! failed
C
1000	RETURN
	END
C
