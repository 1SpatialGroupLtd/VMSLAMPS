C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-01-07 17:36:48.000000000 +0000
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
	SUBROUTINE WRITE_NEW_FEATURE(ENTRY,PREV)
C
CDEC$	IDENT	'12DE91'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	12-Dec-1991
C
C Description:
C       Write flags denoting feature information. For some of the information,
C       it need not be written if the values are unchanged.
C
        IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'CODES.CMN'
C
C Common Blocks
C
	INCLUDE	'GENERAL.CMN'		! General stuff
C
C Local Variables
C
	INTEGER*4	ENTRY
	INTEGER*4	PREV
	INTEGER*2	N,I
	INTEGER*2	NARRAY(3)
	LOGICAL*4	DIFF
C
C------------------------------------------------------------------------------
C
	DIFF = .TRUE.
C
C Start line
C
	CALL ADD_WORD(START_LINE)
C
C Font type (0..999)
C
	IF (PREV.NE.UNDEFINED) DIFF = PARRAY(2,ENTRY).NE.PARRAY(2,PREV)
	IF (PARRAY(2,ENTRY).NE.UNDEFINED.AND.DIFF) THEN
	   CALL ADD_WORD(FONT_TYPE)
	   CALL NUM_TO_CODES(PARRAY(2,ENTRY),N,NARRAY)
	   DO 10 I = 1,N
	      CALL ADD_WORD(DIG(NARRAY(I)))
10	   CONTINUE
	ENDIF
C
C Line width (1..99)
C
	IF (PREV.NE.UNDEFINED) DIFF = PARRAY(3,ENTRY).NE.PARRAY(3,PREV)
	IF (PARRAY(3,ENTRY).NE.UNDEFINED.AND.DIFF) THEN
	   CALL ADD_WORD(LINE_WIDTH)
	   CALL NUM_TO_CODES(PARRAY(3,ENTRY),N,NARRAY)
	   DO 20 I = 1,N
	      CALL ADD_WORD(DIG(NARRAY(I)))
20	   CONTINUE
	ENDIF
C
C Curve Type (1,2,3)
C
	IF (PREV.NE.UNDEFINED) DIFF = PARRAY(4,ENTRY).NE.PARRAY(4,PREV)
	IF (PARRAY(4,ENTRY).NE.UNDEFINED.AND.DIFF) THEN
	   CALL ADD_WORD(CURVE_TYPE)
	   CALL NUM_TO_CODES(PARRAY(4,ENTRY),N,NARRAY)
	   CALL ADD_WORD(DIG(NARRAY(1)))
	ENDIF
C
C Termination (4,5,9)
C
	IF (PARRAY(5,ENTRY).EQ.5) THEN
C
C Must have closed parameter for each line
C
	   CALL ADD_WORD(TERMINATION)
	   CALL NUM_TO_CODES(PARRAY(5,ENTRY),N,NARRAY)
	   CALL ADD_WORD(DIG(NARRAY(1)))
	ELSE
	   IF (PREV.NE.UNDEFINED) DIFF = (PARRAY(5,ENTRY).NE.PARRAY(5,PREV))
	   IF (PARRAY(5,ENTRY).NE.UNDEFINED.AND.DIFF) THEN
	      CALL ADD_WORD(TERMINATION)
	      CALL NUM_TO_CODES(PARRAY(5,ENTRY),N,NARRAY)
	      CALL ADD_WORD(DIG(NARRAY(1)))
	   ENDIF
	ENDIF
C
C Priority (6,7,8)
C
	IF (PREV.NE.UNDEFINED) DIFF = PARRAY(6,ENTRY).NE.PARRAY(6,PREV)
	IF (PARRAY(6,ENTRY).NE.UNDEFINED.AND.DIFF) THEN
	   CALL ADD_WORD(PRIORITY)
	   CALL NUM_TO_CODES(PARRAY(6,ENTRY),N,NARRAY)
	   CALL ADD_WORD(DIG(NARRAY(1)))
	ENDIF
C
C Colour (1..12)
C
	IF (PREV.NE.UNDEFINED) DIFF = PARRAY(7,ENTRY).NE.PARRAY(7,PREV)
	IF (PARRAY(7,ENTRY).NE.UNDEFINED.AND.DIFF) THEN
	   CALL ADD_WORD(COL(PARRAY(7,ENTRY)))
	ENDIF
C
	RETURN
	END

