C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-09-24 17:09:14.000000000 +0100
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
	LOGICAL FUNCTION CONVERT(A,B,C,D,XSIZE,YSIZE,TYPE)
C
CDEC$	IDENT	'24SE93'
C
C       Copyright Laser-Scan Ltd., Cambridge, England.
C
C       Author CCB	Jiffy				21-May-1991
C	Mod		JB				13-Aug-1991
C	Standardised and extended
C
C Description
C
C	Read text values into DTI array
C
        IMPLICIT NONE
C
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'
	INCLUDE 'LSL$CMNDTI:DTIHDR.CMN'
	INCLUDE 'LSL$CMNDTI:DTIPAR.PAR'
	INCLUDE 'LSL$CMNDTI:DTIPROJ.CMN'
C
	INCLUDE 'HERE:DTIFROMTEXTMSG.PAR'
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
	LOGICAL	RDINT,RDLONG,RDREAL,RDCHS
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
	EQUIVALENCE	(RVAL,LVAL,WVAL,BVAL)
C
	BYTE		CH
	INTEGER		NLINES
	INTEGER		IND
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
	DO 100 Y=1,YSIZE
	   DO 200 X=1,XSIZE
10	      IF (RDCHS(CH)) THEN
11	         NLINES = NLINES+1
C
		 STATUS = FLRLIN(BUF,BUFLEN,BUFMAX)
	         IF (.NOT.STATUS) THEN
	            CALL LSL_PUTMSG(DTIFT__TEXTEOFERR)
	            GOTO 999
	         ENDIF
C
	         IF (BUFLEN.LE.0) GOTO 11
	         CALL SETAUX(BUF,BUFLEN)
	         GOTO 10
	      ENDIF
C
	      CALL BSCH
C
C Assume x,y,z on same line
C
	      IF (HAD_XYZ) THEN
		 OK = RDREAL(XC)
		 OK = RDREAL(YC)
	      ENDIF

	      IF (TYPE.EQ.DATA_REAL) THEN
		 OK = RDREAL(RVAL)
	      ELSEIF (TYPE.EQ.DATA_LONG) THEN
		 OK = RDLONG(LVAL)
	      ELSE
		 OK = RDINT(WVAL)
	      ENDIF
C
	      IF (OK) THEN
		 CONVERT = DTIFT__BADDATAVALUE
		 CALL LSL_PUTMSG(DTIFT__BADDATAVALUE)
		 GOTO 999
	      ENDIF
C
	      IND = IND+1
C
	      IF (TYPE.EQ.DATA_REAL) THEN
		 D(IND) = RVAL
	      ELSEIF (TYPE.EQ.DATA_LONG) THEN
	         C(IND) = LVAL		! one dimensional for speed
	      ELSEIF (TYPE.EQ.DATA_WORD) THEN
	         B(IND) = WVAL		! one dimensional for speed
	      ELSE
		 WVAL = MAX(0,MIN(255,WVAL))
	         A(IND) = BVAL		! one dimensional for speed
CCC	         A(X,Y) = BVAL		! actual dimension
	      ENDIF
C
C Set origin ********* SPECIFIC TO AUSLIG ******************
C Overwrite index file values
C 
	      IF (NLINES.EQ.1 .AND. HAD_AUSLIG) THEN
		 DTIPROJ_ORIGIN(1,1) = XC
		 DTIPROJ_ORIGIN(2,1) = -1*YC
		 X_OFFSET(1) = XC
		 Y_OFFSET(1) = -1*YC
	      ENDIF
C
200	   CONTINUE
100	CONTINUE
C
	CONVERT = .TRUE.		! success
	GOTO 1000
C
999	CALL WRITEF('Was reading text line %N',NLINES)
	CALL WRITEF('DTI position X=%N, Y=%N',X,Y)
	CONVERT = .FALSE.		! failed
C
1000	RETURN
	END
C
