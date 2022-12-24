C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-07-21 17:43:28.000000000 +0100
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
	LOGICAL FUNCTION SPAWN_CMD()
C
CDEC$	IDENT	'13AP92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	13-May-1992
C
C Description:
C
C	Function to SPAWN a DCL command from the text in TXTBUF
C	Command. If argument(s) are missing the user is prompted
C	Function returns .TRUE. if all is well.
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE	'DCW2IMSG.PAR'
C
C Local worspace
C
	BYTE		CH		! a character
	CHARACTER*128	DCLSTR		! for SPAWN command
	INTEGER		I 		! temp var
	LOGICAL		OK		! function return
C
C Functions
C
	LOGICAL		RDCH		! read from TXTBUF
	LOGICAL		LIB$SPAWN
C
C ......................................................................
C
	I=0
170	IF (RDCH(CH)) THEN
	   GOTO 180
	ELSE	
	   I=I+1
	   DCLSTR(I:I)=CHAR(CH)
	   GOTO 170
	ENDIF
C
180	IF (I.EQ.0) THEN
	   CALL LSL_PUTMSG(DCW2I__DCL)
	   CALL WRITEF
	   SPAWN_CMD=.FALSE.
	   GOTO 20
	ENDIF
C
	OK=LIB$SPAWN(DCLSTR(1:MIN(I,80)))
	IF (OK) THEN
	   SPAWN_CMD=.TRUE.
	ELSE
	   CALL LIB$STOP(%VAL(OK)) !error
	   CALL LSL_PUTMSG(DCW2I__CANTSPAWN)
	   CALL LSL_ADDMSG(OK)
	   CALL WRITEF
	   SPAWN_CMD=.FALSE.
	ENDIF
20	RETURN
	END
