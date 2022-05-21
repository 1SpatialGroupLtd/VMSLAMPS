C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-10-26 17:46:16.000000000 +0100
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
	LOGICAL FUNCTION DTISCAN
C
CDEC$	IDENT	'26OC89'
C
C	Copyright  		Laser-Scan Ltd., Cambridge, England.
C
C	Author 					RWR	22-Nov-1985
C
C	Modified				APB	25-Oct-1989
C	
C		Updated to use LSLLIB, DTILIB and standard messages
C
C Description:
C
C	1) Scans DTI file for max and min heights and first and 
C    	   start row of each column
C	2) Computes max and min height for whole DEM
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 	'LSL$CMNDTI:DTIPAR.PAR'	! DTILIB parameters
C
C Common blocks
C
        INCLUDE		'LSL$DTI2DEM:DEMA.CMN'
        INCLUDE		'LSL$DTI2DEM:GENERAL.CMN'
C
C Local variables
C
	INTEGER		I,J			! loop counters
	REAL*8		X,YS(2)
	REAL*8		R8DEL,R8
	INTEGER*2	HEIGHT
	INTEGER*2	HMAX,HMIN
	INTEGER		M
	INTEGER		STATUS
	INTEGER*2	MAX_WORD
	PARAMETER      (MAX_WORD = 32767)
C
C Functions
C
	LOGICAL		YBOUND
	LOGICAL		DTI_READ_DATA		! Read datum from DTI file
C
C-------------------------------------------------------------------------------
C
C Write out a reassuring message
C
	CALL WRITEF(' ')
	CALL WRITEF('Scanning DTI file %S for max and min values',
     &	                     INFILN(1:INFILNL))
	CALL WRITEF(' ')
C
C Look at each column of DTI and find where it cuts edge of map
C
	DO 200, I=1,NCOL
C
C Get UTM X value of this column
C
	   X=ORIGIN(1)+(I-1)*DEMDELX
C
C Check to see if we are in DEM yet
C
	   IF (X.LT.MINXDEM) GOTO 200
C
C Perhaps we are outside at the far end
C
	   IF (X.GT.MAXXDEM) GOTO 300		! so have finished
C
C Find out where this cuts boundaries of map
C
	   IF (.NOT.YBOUND(X,YS)) GOTO 200	! should not happen
C
C Are there any posts of this column in the map?
C
	   R8DEL=DEMDELY
	   J=YS(1)/R8DEL			! integer truncate
	   IF (MOD(YS(1),R8DEL).NE.0.0) J=J+1
	   IF (J*R8DEL.GT.YS(2)) GOTO 200	! no posts in map
C
C So this column is a possible first and last one
C
	   IF (FSTCOL.LT.0) FSTCOL=I
	   LSTCOL=I
C
C Work out first and last relevent row for this column
C
	   R8=((J*R8DEL-ORIGIN(2))/R8DEL)	! allow r*8 arithmetic
	   COLFST(I)=R8+1
	   J=YS(2)/R8DEL			! integer truncate
	   R8=((J*R8DEL-ORIGIN(2))/R8DEL)
	   COLLST(I)=R8+1
C
C Now get MAX and MIN height for this column
C
	   COLMAX(I) = DTI_NULL_WORD
	   COLMIN(I) = MAX_WORD
C
	   DO 100, J=COLFST(I),COLLST(I)
	      STATUS = DTI_READ_DATA( INLUN,HEIGHT,I,J )
	      COLMAX(I)=MAX(COLMAX(I),HEIGHT)
	      COLMIN(I) = MIN(COLMIN(I),HEIGHT)
  100	   CONTINUE
  200	CONTINUE
C
C Get max and min for whole DEM
C 
  300	CONTINUE
	HMIN=MAX_WORD
	HMAX=DTI_NULL_WORD
	DO 400, I=FSTCOL,LSTCOL
	   IF ( COLMIN(I).NE.DTI_NULL_WORD ) THEN
	      HMIN=MIN(HMIN,COLMIN(I))
	   ENDIF
	   HMAX=MAX(HMAX,COLMAX(I))
  400	CONTINUE
	DEMZRNG(1)=HMIN*DEMDELZ
	DEMZRNG(2)=HMAX*DEMDELZ
C
C and number of columns
C
	DEMNCOL(2)=LSTCOL-FSTCOL+1
C
	DTISCAN = STATUS
C
	RETURN
	END
