C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-10-06 16:53:30.000000000 +0100
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
	LOGICAL FUNCTION PROCESS_INPUT
C
CDEC$	IDENT	'06OC92'
C
C Copyright Laser-Scan Ltd, Cambridge, England
C
C Author	SG		9-06-92
C
	IMPLICIT NONE
C
C Utility to compress LITES2 command macros into a more compact form.
C It does this by:
C	removing comments
C	compressing lines
C	shortening LITES2 commands to 4 characters
C
C .....................................................................
C Change history
C
C .....................................................................
C Commons:
C
	INCLUDE  'HERE:FILENAME.CMN'
	INCLUDE  'HERE:COMMANDS.CMN'
	INCLUDE  'HERE:LUNS.PAR'
	INCLUDE  'HERE:LCM.CMN'
C
C Functions:
C
	LOGICAL	READ_LINE
C
C Workspace:
	INTEGER		OK			! Function return
C
C .....................................................................
C
	OK = .TRUE.
C
	DO WHILE (OK)
	  OK = READ_LINE(IN_LUN)
	  IF (OK) THEN
	    LINE_COUNT = LINE_COUNT +1
	    CALL PROCESS_BUFFER()
	  ENDIF
	END DO	
C
	CALL FLUSH()				! flush the buffer
C
C .....................................................................
C
9999	PROCESS_INPUT = OK
	RETURN
	END
