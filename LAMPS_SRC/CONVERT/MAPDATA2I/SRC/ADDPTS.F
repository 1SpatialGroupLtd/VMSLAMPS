C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-09-23 17:46:22.000000000 +0100
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
	SUBROUTINE ADDPTS(NUMPTS,XY,DUMMY)
C
***     IDENT	23SE94
***     MODULE  ADDPTS
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created 					RJH	21-Oct-1986
CMOD	Used in MAPDATA2I to ensure compatibility	ST	20-Sep-1994
C       Mod 1400.
C
C Description
C       Used by COORDLIB to put AKIMA smoothed points into the LINE_OUT array.
C
        IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE	'($STSDEF)/NOLIST'
C
C Arguments
C
	INTEGER*4	NUMPTS		! number of points
	REAL		XY(2,NUMPTS)	! line string
	LOGICAL*1	DUMMY		! dummy argument
C
C Common Blocks
C
	INCLUDE 'CMN:LINES.CMN'
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'
C
C Local Variables
C
	INTEGER*4	I		! counter
	LOGICAL		OK_SO_FAR	! no blunders ?
C
C------------------------------------------------------------------------------
C Check there have been no errors
C
	OK_SO_FAR = LSL_STATUS .OR. 
     &		((LSL_STATUS .AND. STS$M_SEVERITY) .EQ. STS$K_WARNING)
	IF (OK_SO_FAR) THEN
	   I = 0
C
C While there are still points to add and the output line is not full ..
C
100	   IF ((I .EQ. NUMPTS) .OR. (NUM_OUT .EQ. MAXPTS)) GO TO 200
C
C ... add the next point
C
	   I = I + 1
	   NUM_OUT = NUM_OUT + 1
	   LINE_OUT(1,NUM_OUT) = XY(1,I)
	   LINE_OUT(2,NUM_OUT) = XY(2,I)
	   GO TO 100
C
	ENDIF
C
C------------------------------------------------------------------------------
C Return
C
200	RETURN
	END
