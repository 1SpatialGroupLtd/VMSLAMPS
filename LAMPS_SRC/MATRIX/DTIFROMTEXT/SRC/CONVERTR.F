C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-08-16 12:08:08.000000000 +0100
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
	LOGICAL FUNCTION CONVERTR(TYPE)
C
CDEC$	IDENT	'16AU91'
C
C       Copyright Laser-Scan Ltd., Cambridge, England.
C
C       Author CCB	Jiffy				21-May-1991
C	Mod		JB				13-Aug-1991
C	Standardised and extended
C
C Description
C
        IMPLICIT NONE
C
C arguments
	INTEGER	TYPE		! data type
C
	IF (TYPE.EQ.1) THEN
	   CALL TTWSTR('Creating BYTE file')
	ELSEIF (TYPE.EQ.2) THEN
	   CALL TTWSTR('Creating WORD file')
	ELSEIF (TYPE.EQ.3) THEN
	   CALL TTWSTR('Creating LONG DTI file')
	ELSEIF (TYPE.EQ.4) THEN
	   CALL TTWSTR('Creating REAL DTI file')
	ENDIF
C
	CONVERTR = .TRUE.		! success
C
1000	RETURN
	END
C
