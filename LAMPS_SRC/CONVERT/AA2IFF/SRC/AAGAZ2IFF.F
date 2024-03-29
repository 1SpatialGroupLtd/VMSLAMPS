C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-04-17 18:10:44.000000000 +0100
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
	PROGRAM 	AAGAZ2IFF
CDEC$	IDENT	'17AP91'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					11-Jun-1990	John Cadogan
C
C Description:
C
C	Conversion for AA benchmark - AA ascii format to IFF
C
	IMPLICIT	NONE
C
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'
	INCLUDE 'CMN:FILE.CMN'
C
	LOGICAL		GAZOBEY
	INTEGER		STATUS
C
C-------------------------------------------------------------------------------
C
	CALL LSL_INIT		! Initialise LSLLIB
C
	STATUS = GAZOBEY()		! decode command line
	IF (.NOT.STATUS) GOTO 999
C
	CALL CONGAZ		! do the conversion
C
	CALL IFFCLO(IFFLUN)     ! Close IFF file
C
999	CALL LSL_EXIT(STATUS)
	END
C
