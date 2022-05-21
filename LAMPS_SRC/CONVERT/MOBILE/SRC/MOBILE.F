C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-04-24 12:36:28.000000000 +0100
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
	PROGRAM MOBILE
CDEC$	IDENT	'24AP91'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Mod					09-Apr-1991	Jon Barber
C
C Description:
C
C	Conversion for Mobile format to TEXT for IFROMTEXT
C
	IMPLICIT	NONE
C
	INTEGER		OBEY
	INTEGER		STATUS
C
C-------------------------------------------------------------------------------
C
	CALL LSL_INIT		! Initialise LSLLIB
C
	STATUS = OBEY()		! decode command line
	IF (.NOT.STATUS) GOTO 999
C
	CALL PROCESS		! do the conversion
C
999	CALL LSL_EXIT(STATUS)
	END
C
