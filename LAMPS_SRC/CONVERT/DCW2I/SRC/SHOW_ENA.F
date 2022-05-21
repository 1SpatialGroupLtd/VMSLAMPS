C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-07-07 16:51:26.000000000 +0100
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
	LOGICAL FUNCTION SHOW_ENA(CHOICE)
C
CDEC$	IDENT	'19AP92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	19-May-1992
C
C Description:
C
C	Function to show all or individual options selected.
C       CHOICE = 1   - show all settings
C       CHOICE = 2   - show reply
C       CHOICE = 3   - show verbose
C
	IMPLICIT NONE
C
C Common blocks
C
	INCLUDE 'GENERAL.CMN'
C
C Arguments
C
	INTEGER*4	CHOICE
C
C***********************************************************************
C
	IF (.NOT.HAD_ENA_REPLY .AND. CHOICE.GT.1) GOTO 100
C
C Show reply setting
C
	IF (CHOICE.EQ.1.OR.CHOICE.EQ.2) THEN
	   IF (HAD_ENA_REPLY) THEN
	      CALL WRITEF('Command reply : ENABLED')
	   ELSE
	      CALL WRITEF('Command reply : DISABLED')
	   ENDIF
	ENDIF
C
C Show verbose setting
C
	IF (CHOICE.EQ.1.OR.CHOICE.EQ.3) THEN
	   IF (HAD_ENA_VERB) THEN
	      CALL WRITEF('Verbose       : ENABLED')
	   ELSE
	      CALL WRITEF('Verbose       : DISABLED')
	   ENDIF
	ENDIF
C
	CALL WRITEF
100	RETURN
	END
