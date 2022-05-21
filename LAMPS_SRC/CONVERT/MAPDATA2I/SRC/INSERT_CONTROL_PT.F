C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-10-01 18:48:24.000000000 +0100
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
	SUBROUTINE	INSERT_CONTROL_PT(PREV_X,PREV_Y,PREV_Z,
     &	     				  CURR_X,CURR_Y,CURR_Z,
     &	     				  NEW_PT)
C
CDEC$	IDENT	'01OC94'
C
C	Copyright (C)			Laser-Scan Ltd., Cambridge
C
C       Author				Steve Townrow	26-Jul-1994
C
C Description:
C       This routine is called from WRITE_CB when the current feature is
C       a curve (GT 6) which is to have the straight sections constrained by
C       the insertion of additional shape points.
C       This routine will put a point near to the point at (CURR_X,CURR_Y)
C       at a user-specified distance away (specified in CORNER_POINT_SEP)
C       It will also attempt to scale the Z height for the new point based
C       on the heights of the two points and how far away from the corner
C       it is to be.
C
C
	IMPLICIT	NONE
C
C Arguments
C
	REAL*4		PREV_X,PREV_Y,PREV_Z
	REAL*4		CURR_X,CURR_Y,CURR_Z
	REAL*4		NEW_PT(3)
C
C common blocks
C
	INCLUDE 'CMN:LINES.CMN'
	INCLUDE 'CMN:FILE.CMN'
	INCLUDE 'CMN:IFF.CMN'
C
C workspace
C
	REAL*4		X,Y,Z,DIST,DX,DY,DZ,HYP,FACTOR
C
C------------------------------------------------------------------------------
C
	DIST = SEPARATION_DIST
	X = CURR_X - PREV_X
	Y = CURR_Y - PREV_Y
	Z = CURR_Z - PREV_Z
	HYP = SQRT(ABS(X*X)+ABS(Y*Y))
C
C If the separation distance is more than half the length of line segment
C the line will double back on itself. We should therefore make it not
C exceed say a quarter of this distance to be safe
C
	DIST = MIN(HYP/4.0,DIST)
	FACTOR = HYP / DIST
	DX = X / FACTOR
	DY = Y / FACTOR
	IF (X.EQ.0.0 .AND. Y.EQ.0.0) THEN
	   DZ = 0.0
	ELSE
	   IF (X.EQ.0.0) THEN
	      DZ = DY * Z / Y
	   ELSE
	      DZ = DX * Z / X
	   ENDIF
	ENDIF
	NEW_PT(1) = CURR_X - DX
	NEW_PT(2) = CURR_Y - DY
	NEW_PT(3) = CURR_Z - DZ
C
C and that's it
C
	RETURN
	END
C
