C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-04-10 16:23:02.000000000 +0100
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
	SUBROUTINE 	FLUSH
CDEC$	IDENT	'10AP91'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created			12-Jan-1990			J.M. Cadogan
C
C Description:
C
C	Flush the coordinate buffer
C
	IMPLICIT	NONE
C
C common blocks
C
	INCLUDE	'CMN:IFF.CMN'
C
C workspace
C
	INTEGER*2	IENDS
	INTEGER		I,J			! loop counters
C
C-------------------------------------------------------------------------------
C if the buffer is empty, then RETURN at once, doing nothing
C
	IF ( ZSPTR.LE.0 ) GOTO 999
C
C if we have not yet output the information that goes before the
C first ZS, output it now
C
	IF (.NOT.DONE_START_FEATURE) CALL START_FEATURE
C
C and work out whether we are drawing through the ZS break
C
	IF ( PEN_UP ) THEN
	   IENDS = 0		! pen up to the ZS
	ELSE
	   IENDS = 1		! pen down to the ZS
	ENDIF
C
C output any data we may have in our buffer
C
	CALL IFFZS( ZSBUF(1,1), ZSPTR, IENDS )
C
C set the continuity point
C
	ZSPTR = 0
C
C and signal that we've output a ZS for this feature
C
	DONE_ZS = .TRUE.
C
C assume that we will be drawing through the next ZS break
C
	PEN_UP = .FALSE.
C
999	RETURN
	END
C
