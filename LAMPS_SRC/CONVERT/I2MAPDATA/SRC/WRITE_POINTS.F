C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-10-11 17:07:46.000000000 +0100
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
	SUBROUTINE WRITE_POINTS(IENDS)
C
***	IDENT	11OC94
***	MODULE	WRITE_POINTS
C
C	Copyright LaserScan Ltd., Cambridge, England
C
C	Created					ST	11-Oct-1994
C
C Description
C
C	Reads in points from the current CB entry
C
	IMPLICIT NONE
C
C Included Parameter Files
C
C
	INCLUDE		'($SSDEF)/NOLIST'
C
C Common Blocks
C
	INCLUDE	'CMN:IFF.CMN'      		! IFF specific things
	INCLUDE 'CMN:CONTROL.CMN'		! control variables
C
C Functions
C
	LOGICAL		KEEP_COORD
C
C Local Variables
C
	INTEGER*2	IENDS			! pen up/down marker
	INTEGER*4	I			! counter
	INTEGER*4	C_FLAG,P_FLAG		! flags
	REAL*4		X,Y,Z			! coord
	REAL*8		X_DBL,Y_DBL,Z_DBL	! double precision
	REAL*8		PX_DBL,PY_DBL		! Previous X_DBL & Y_DBL
C
	SAVE		PX_DBL,PY_DBL		! retain last point
C
C------------------------------------------------------------------------------
C Check each point and output it if neccessary
C
	DO 500 I = 1,NPTS
	   POINTNUM = POINTNUM + 1
	   X = XYZ(1,I)
	   Y = XYZ(2,I)
	   Z = XYZ(3,I)
	   C_FLAG = FLAGS(1,I)
	   P_FLAG = FLAGS(2,I)
C
	   CALL CHECK_FLAG(C_FLAG,.TRUE.)	! check CURVE flags
	   CALL CHECK_FLAG(P_FLAG,.FALSE.)	! check PRIORITY flags
	   CALL CHECK_COORD(X)			! check X coord for IFF_ABSENT
	   CALL CHECK_COORD(Y)			! check Y coord for IFF_ABSENT
	   CALL CHECK_COORD(Z)			! check Z coord for IFF_ABSENT
	   IF (KEEP_COORD(C_FLAG)) THEN
	      X_DBL = (X + XOFF) / DIVISOR
	      Y_DBL = (Y + YOFF) / DIVISOR
	      Z_DBL = Z
C
C If we have just started a new feature we don't need to check the first point
C but if we have a pen-down flag, we should test all points including the
C first against the previous.
C
	      IF (IENDS.EQ.0) THEN
		 IF (I.GT.1.AND.PX_DBL.EQ.X_DBL.AND.PY_DBL.EQ.Y_DBL) GOTO 500
	      ELSE
		 IF (PX_DBL.EQ.X_DBL.AND.PY_DBL.EQ.Y_DBL) GOTO 500
	      ENDIF
	      CALL WRITE_MD_COORD(X_DBL,Y_DBL,Z_DBL,C_FLAG,P_FLAG)
	      PX_DBL = X_DBL
	      PY_DBL = Y_DBL
	   ENDIF
500	CONTINUE
C
C Return
C
999	RETURN
	END
C
