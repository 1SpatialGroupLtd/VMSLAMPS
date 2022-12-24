C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-09-25 17:25:24.000000000 +0100
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
	SUBROUTINE CHAR_CHECK(FSN,STRLEN,STR)
C
CDEC$	IDENT	'22MY92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	22-Sept-1992
C
C Description:
C
C       Routine to check the input string for special characters so that a
C       report can be made at the end of processing. This is so that strange
C       characters can be added to the TRI file .
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'DCW2IMSG.PAR'
C
C
C Common blocks
C
	INCLUDE 'GENERAL.CMN'
C
C Arguments
C
	BYTE		STR(*)		! the input string
	INTEGER*4	STRLEN		! the string length
	INTEGER*2	FSN		! the FSN in case of error
C
C Local workspace
C
	BYTE		TESTCH		! the character to check
	INTEGER*4	I,J,K		! counter
	LOGICAL*4	MATCH		! already in list?
C
C ......................................................................
C
	DO 300 I = 1,STRLEN
	   TESTCH = STR(I)
	   IF (TESTCH.GT.127) THEN
	      CALL LSL_PUTMSG(DCW2I__8BITASCII,FSN)
	   ELSEIF (TESTCH.EQ.27 .OR. TESTCH.EQ.14 .OR. TESTCH.EQ.15) THEN
	      CALL LSL_PUTMSG(DCW2I__CODEXT,FSN)
	   ENDIF
300	CONTINUE
C
C ......................................................................
C
999	RETURN
	END
