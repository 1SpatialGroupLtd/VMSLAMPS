C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-07-03 14:07:12.000000000 +0100
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
	SUBROUTINE USRDRW(RTSTRL,RTSTR)
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Description
C
C	LITES2 cartographic editor user command routines .
C
        IMPLICIT NONE
C
	INTEGER*4	RTSTRL		! input: maximum size of RTSTR
					! output: size of RTSTR
					! if 0 is returned no DRAW command
					! is executed.
	CHARACTER*(*)	RTSTR		! secondary command (with
					! arguments) for the DRAW command
C
C all these arguments are writable.	
C
C in this version, don't do anything
C
	RETURN
	END
