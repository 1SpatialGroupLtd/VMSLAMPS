C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-01-13 13:56:04.000000000 +0000
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
	SUBROUTINE USRGAC(ACTYPE,ACIVAL,ACTXTL,ACTXT,RETCOD)
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
	INTEGER*4	ACTYPE		! type of AC
	INTEGER*4	ACIVAL		! AC value
					! note: to read a real AC value,
					! a copy of this will have to
					! be equivalenced to a real
	INTEGER*4	ACTXTL		! number of characters in ACTXT
	CHARACTER*(*)	ACTXT		! text (maximum of 255 chars)
	INTEGER*4	RETCOD		! return code
					! = 0 abort, don't call processing
					!     routine
					! = 1 for get more ACs if there
					!     are any, or start getting
					!     coords if reqd, or call
					!     USRDO if coords not reqd
					! = 2 stop getting ACs, start
					!     getting cooordinates
					! = 4 for call processing routine
					!     right away
C
C	All these arguments, apart from RETCOD, should be considered
C	as read only
C
C in this version, don't do anything
C
	RETCOD=0
C
	RETURN
	END
