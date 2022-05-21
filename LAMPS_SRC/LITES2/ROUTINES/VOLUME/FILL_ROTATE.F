C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-05-15 17:31:02.000000000 +0100
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
	SUBROUTINE FILL_ROTATE(ANGLE,XX,YY)
C
CDEC$	IDENT	'15MY91'
C
C	Copyright LaserScan Laboratories Ltd., Cambridge, England
C
C Author CC Brunt, 11 February 1991
C
C This subroutine rotates the given X and Y coordinates by ANGLE
C It replaces the old ROT45
C
	IMPLICIT NONE
C
C arguments
C
	REAL		ANGLE		! angle to rotate by
	REAL		XX,YY		! coordinates to rotate
C
C workspace
C
	REAL		OLDANG,SINANG,COSANG
	SAVE		OLDANG,SINANG,COSANG
	DATA		OLDANG,SINANG,COSANG/0.0,0.0,1.0/
	REAL		SAVX		! preserve XX
C
C get new SIN and COS if required
C
	IF (ANGLE.NE.OLDANG) THEN
	   OLDANG = ANGLE
	   SINANG = SIN(OLDANG)
	   COSANG = COS(OLDANG)
	ENDIF
C
C preserve the original value of XX
C
	SAVX = XX
C
C now rotate
C
	XX = SAVX*COSANG - YY*SINANG
	YY = SAVX*SINANG + YY*COSANG
C
	RETURN
	END
