C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-03-05 12:16:18.000000000 +0000
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
	SUBROUTINE CHECK_RANGE(X,Y)
C
CDEC$	IDENT	'05MA92'
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	25-Oct-1991
C
C Description:
C	Routine to keep track of range for output file.
C
C
        IMPLICIT NONE
C
C Common blocks
C
	INCLUDE 'LSL$ICASE:IFFVARS.CMN'         ! IFF information
C
C Arguments
C
	REAL	X,Y				! Input coords
C
C-----------------------------------------------------------------------------
C
	IF (X.LT.RANGE(1)) RANGE(1) = X
	IF (X.GT.RANGE(2)) RANGE(2) = X
	IF (Y.LT.RANGE(3)) RANGE(3) = Y
	IF (Y.GT.RANGE(4)) RANGE(4) = Y
C
	RETURN
	END
