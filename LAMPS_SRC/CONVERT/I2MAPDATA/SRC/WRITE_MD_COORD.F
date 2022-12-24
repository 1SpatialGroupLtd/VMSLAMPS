C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-09-27 17:54:48.000000000 +0100
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
	SUBROUTINE WRITE_MD_COORD(X_COORD,Y_COORD,Z_COORD,C_FLAG,P_FLAG)
C
CDEC$	IDENT	'27SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created 					RJH	26-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Write MAPDATA coordinates
C
C Description
C
C	Writes the coordinates of a single point, together with its flags, to
C	the MAPDATA output file.
C
C       Assumes the MAPDATA output file is already selected for writing.
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE	'CMN:GEN.PAR'			! general parameters
C
C Arguments
C
	REAL*8		X_COORD		! X coordinate
	REAL*8		Y_COORD		! Y coordinate
	REAL*8		Z_COORD		! Z coordinate
C
	INTEGER*4	C_FLAG		! curve flag
	INTEGER*4	P_FLAG		! priority flag
C
C Format the coordinates and flags, and then write the formatted line to the
C output file. Unset flags should contain a space, and are not output.
C
	CALL EXPAND('%^P%^D%F0.3 %F0.3 %F0.3',X_COORD,Y_COORD,Z_COORD)
C
	IF (C_FLAG .NE. UNSET_FLAG) CALL APPEND(' %^B%C',C_FLAG)
	IF (P_FLAG .NE. UNSET_FLAG) CALL APPEND(' %^B%C',P_FLAG)
C
	CALL FLWLIN
C
C Return
C
10000	RETURN
	END
