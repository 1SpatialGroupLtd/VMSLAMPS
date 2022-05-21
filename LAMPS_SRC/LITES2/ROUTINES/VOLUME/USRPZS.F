C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-05-16 13:55:38.000000000 +0100
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
	SUBROUTINE USRPZS(SIZE,USERXYZ,USRFLG,RETCOD)
C
CDEC$	IDENT	'16MY91'
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Clarke Brunt			CCB	15-May-1991
C
C Description
C
C	LITES2 cartographic editor user command routines
C	Volume calculation routine
C
        IMPLICIT NONE
C
C Arguments
C
	INTEGER*4	SIZE		! input:  maximum number of
					!         coords to pass back
					! output: actual number of
					!         coords passed back
					! with this call
	REAL		USERXYZ(3,SIZE)	! coords
	LOGICAL*1	USRFLG(SIZE)	! flags (visibility only)
	INTEGER*4	RETCOD		! return code
					! = 0 abort, dont call 
					!     completion routine
					! = 1 for write more coords, if
					!     there are any, or else
					!     call USRRET
					! = 4 for abort, call completion
					!     routine
C
C	All these arguments are writable.
C
	INCLUDE 'USRFEAT.CMN/LIST'		! common blocks
	INCLUDE 'USRKEEP.CMN/LIST'
C
C workspace
	INTEGER		I
C
	SIZE = MIN(SIZE,NPTS-OPTS)
	DO 10 I=1,SIZE
	   USERXYZ(1,I) = COORD(1,OPTS+I)
	   USERXYZ(2,I) = COORD(2,OPTS+I)
	   USERXYZ(3,I) = COORD(3,OPTS+I)
	   USRFLG(I)    = FLG(OPTS+I)
10	CONTINUE
	OPTS = OPTS+SIZE
C
	RETCOD = 1	! output more coords, or goto USRRET
C
	RETURN
	END
