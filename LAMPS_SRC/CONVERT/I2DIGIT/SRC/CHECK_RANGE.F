C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-09-25 12:52:36.000000000 +0100
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
	LOGICAL FUNCTION CHECK_RANGE(X,Y,FSN)
C
CDEC$	IDENT	'13DEC91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	13-Dec-1991
C
C Description:
C
C	Module CHECK_RANGE called by I2DIGIT in package CONVERT.
C	Modifies MIN/MAX X and Y if X,Y of point lies outside
C
        IMPLICIT NONE
C
C Parameters
C
	INCLUDE	'I2DIGITMSG.PAR'		! I2DIGIT messages
C
C Common blocks
C
	INCLUDE	'GENERAL.CMN'		! Globals
C
C Arguments
C
	INTEGER*4	STATUS
	INTEGER*4	X,Y
	INTEGER*2	FSN
C
C------------------------------------------------------------------------------
C
	STATUS = .TRUE.
C
	IF (X.GT.32767 .OR. X.LT.1) THEN
	   CALL LSL_PUTMSG(I2DIGIT__OUTOFRANGE,FSN)
	   STATUS = .FALSE.
	   GOTO 999
	ENDIF
	IF (Y.GT.32767 .OR. Y.LT.1) THEN
	   CALL LSL_PUTMSG(I2DIGIT__OUTOFRANGE,FSN)
	   STATUS = .FALSE.
	   GOTO 999
	ENDIF
	MINX = MIN(X,MINX)
	MAXX = MAX(X,MAXX)
	MINY = MIN(Y,MINY)
	MAXY = MAX(Y,MAXY)
C
999	CHECK_RANGE = STATUS
	RETURN
	END
