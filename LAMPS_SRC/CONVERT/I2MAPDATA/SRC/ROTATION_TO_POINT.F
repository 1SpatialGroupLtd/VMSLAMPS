C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-11-02 10:04:48.000000000 +0000
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
	SUBROUTINE ROTATION_TO_POINT(ROTATE)
C
CDEC$	IDENT	'02NO94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						ST	10-Oct-1994
C
C       MOD 1417. Use SYM_LEN instead of 10 IFF units.	ST	2-Nov-1994
C       This is derived from the scale if present.
C
C Description
C
C	From the only point in the points buffer XYZ and the given angle,
C       this routine will generate a second point at a distance of 1 IFF
C       unit.
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE	'CMN:GEN.PAR'		! For UNSET_FLAG
C
C Common blocks
C
	INCLUDE	'CMN:IFF.CMN'		! IFF stuff
C
C Arguments
C
	REAL*4		ROTATE		! the orientation in radians
C
C------------------------------------------------------------------------------
C An orientation of zero results in a single point feature
C
	IF (ROTATE.EQ.0.0 .OR. NPTS.EQ.2) GOTO 9000
C
C SYM_LEN holds the length of the vector. This should be 4 sheet millimetres
C if the Map Descriptor scale is available to calculate this or 10 IFF units
C if not.
C
	XYZ(1,NPTS+1) = XYZ(1,NPTS) + (SYM_LEN * COS(ROTATE))
	XYZ(2,NPTS+1) = XYZ(2,NPTS) + (SYM_LEN * SIN(ROTATE))
	FLAGS(1,NPTS+1) = UNSET_FLAG
	FLAGS(2,NPTS+1) = UNSET_FLAG
	NPTS = NPTS + 1
C
C------------------------------------------------------------------------------
C Return
C
9000	RETURN
	END
