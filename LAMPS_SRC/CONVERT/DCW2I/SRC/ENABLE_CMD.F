C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-07-17 11:58:06.000000000 +0100
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
	LOGICAL FUNCTION ENABLE_CMD(ENABLE)
C
CDEC$	IDENT	'13AP92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	19-May-1992
C
C Description:
C
C	Function to enable or disable various options
C	Called with .FALSE. argument to disable settings.
C	Function returns .TRUE. if all is well, .FALSE. if an error
C
	IMPLICIT NONE
C
C Common blocks
C
	INCLUDE 'GENERAL.CMN'
C
C Functions
C
	LOGICAL 	RDCOMM  	! read command from line
C
C Command table
C
	EXTERNAL	ENABLE_CMD_TABLE
	INTEGER		ENABLE_CMD_TABLE
C
C Arguments
C
	LOGICAL		ENABLE
C
C Local workspace
C
	INTEGER*4	CMD     	! decoded command number
	CHARACTER*8	STR		! name of command
	INTEGER*4	STRLEN		! length of STR
C
C ......................................................................
C
	ENABLE_CMD=.TRUE.		! assume success
C
C Note command name
C
	IF (ENABLE) THEN
	   STRLEN = 6
	   STR(1:STRLEN) = 'ENABLE'
	ELSE
	   STRLEN = 7
	   STR(1:STRLEN) = 'DISABLE'
	ENDIF
C
	CMD=RDCOMM(ENABLE_CMD_TABLE)	! get command
C
C Branch to deal with each sub command
C
	GOTO (
     &		10,	! nothing/error
     &		20,	! REPLY
     &		30	! VERBOSE
     &			), CMD+1
C
C Command not implemented
C
	ENABLE_CMD=.FALSE.
	GOTO 50
C
C ......................................................................
C Error
10	CALL WRITEF
	CALL WRITEF('Available %S command qualifiers are:',STR(1:STRLEN))
	CALL WRITEF
	CALL WRITEF('REPLY  VERBOSE')
	CALL WRITEF
	ENABLE_CMD=.FALSE.
	GOTO 50
C
C ......................................................................
C ENABLE REPLY command
C
20	HAD_ENA_REPLY = ENABLE
	CALL SHOW_ENA(2)
	GOTO 50
C
C ......................................................................
C ENABLE VERBOSE command
C
30	HAD_ENA_VERB = ENABLE
	CALL SHOW_ENA(3)
C
C ......................................................................
C
50	RETURN
	END
