C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-10-10 16:41:56.000000000 +0100
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
	SUBROUTINE CHECK_COORD(COORD)
C
CDEC$	IDENT	'10OC94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						ST	10-Oct-1994
C
C	CONVERT I2MAPDATA Utility - Check coordinate
C
C Description
C
C	Checks an ordinate to see if it is absent
C
	IMPLICIT NONE
C
C Common blocks
C
	INCLUDE	'CMN:IFF.CMN'		! IFF stuff
C
C Arguments
C
	REAL*4		COORD		! the IFF ordinate value
C
C Local variables
C
	REAL*4		RCOORD		! local copy of COORD
	INTEGER*4	ICOORD		! local integer version of COORD
	EQUIVALENCE	(ICOORD,RCOORD)	! to check against IFF_ABSENT
C
C------------------------------------------------------------------------------
C
C Make a local copy of the argument as we need to check for IFF_ABSENT.
C IFF_ABSENT is an int and we can't equivalence this int on the argument -
C only the copy.
C
	RCOORD = COORD
C
C Check it for absence
C
	IF (ICOORD.EQ.IFF_ABSENT) COORD = 0.0
C
C Return
C
	RETURN
	END
