C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-06-26 12:47:38.000000000 +0100
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
	SUBROUTINE USRRET(CNDFLG,RTSTRL,RTSTR,RETCOD)
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Ron Russell			RWR	13-Jan-1989
C
C Description
C
C	LITES2 cartographic editor user command routines.
C	Dummy routine
C
        IMPLICIT NONE
C
C Arguments
C
	LOGICAL		CNDFLG		! LITES2 conditional flag
	INTEGER*4	RTSTRL		!  input: maximum size of RTSTR
					! output: size of RTSTR
	CHARACTER*(*)	RTSTR		! LITES2 command line, to be 
					! executed before any other
					! command
	INTEGER*4	RETCOD		! return code
					! = 0 for abort
					! = 1 for CNDFLG to be set
					!     and command to be executed
					! = 2 for call processing routine
					!     again
					! = 3 for call USRDEF, then call
					!     USRRET again
					! = 4 for call USRANO, then call
					!     USRRET again
					! = 5 for call USRDRW, then call
					!     USRRET again
C
C in this version, don't do anything
C
	RETCOD=0
C
	RETURN
	END
