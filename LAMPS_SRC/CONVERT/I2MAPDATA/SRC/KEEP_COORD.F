C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-10-10 15:33:44.000000000 +0100
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
	LOGICAL FUNCTION KEEP_COORD(CURVE_FLAG)
C
CDEC$	IDENT	'10OC94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						ST	10-Oct-1994
C
C	CONVERT I2MAPDATA Utility
C
C Description
C
C	Checks if the current point is to be kept based on the whether curve
C	flag is curved, unset or interpolated. The validity of the flag has
C	already been checked by CHECK_FLAG.
C
	IMPLICIT NONE
C
C Arguments
C
	INTEGER*4	CURVE_FLAG	! the curve flag as an int
C
C------------------------------------------------------------------------------
C
	KEEP_COORD = CURVE_FLAG.NE.'I   '
C
	RETURN
	END
