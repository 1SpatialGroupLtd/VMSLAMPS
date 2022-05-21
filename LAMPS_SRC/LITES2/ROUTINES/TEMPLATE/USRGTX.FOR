C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-01-13 14:02:26.000000000 +0000
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
	SUBROUTINE USRGTX(TEXT,TEXTL,TS,HEIGHT,ROTAT,AUX)
C
C       Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C       Author Ron Russell			RWR	13-Jan-1989
C
C Description
C
C	LITES2 cartographic editor user command routines.
C	Dummy user routine
C
        IMPLICIT NONE
C
C Arguments
C
	INTEGER*4	TEXTL		! number of characters in TEXT
	CHARACTER*(*)	TEXT		! text string, if text feature
	INTEGER*4	TS(4)		! text component status
	REAL		ROTAT		! rotation of text component
	INTEGER*4	HEIGHT		! height of text (in points or
					! 0.01mm)
	REAL*4		AUX(8)		! data about text (in IFF units)
					! AUX(1) = angle (in radians)
					! AUX(2) = cosine of angle
					! AUX(3) = sine of angle
					! AUX(4) = height (in IFF units)
					! AUX(5) = minumum X value 
					!         (rel to locating point)
					! AUX(6) = maximum X value
					! AUX(7) = minimum Y value 
					! AUX(8) = maximum Y value
C
C this is a dummy routine that does nothing
C
	RETURN
	END
