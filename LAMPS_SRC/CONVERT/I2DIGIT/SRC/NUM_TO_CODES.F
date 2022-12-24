C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-01-07 16:36:34.000000000 +0000
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
	SUBROUTINE NUM_TO_CODES(NUMBER,NUMCODES,CODEARRAY)
C
CDEC$	IDENT	'12DE91'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	12-Decov-1991
C
C Description:
C       Convert the value of NUMBER into a set of individual digits
C       and store the result in CODEARRAY. The input number should never
C       exceed 999 so only three digits are required. NUMCODES is used by
C       the calling routine to tell how many values in CODEARRAY.
C
        IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'CODES.CMN'
C
C Local Variables
C
	INTEGER*2	NUMBER
	INTEGER*2	NUMCODES
	INTEGER*2	CODEARRAY(3)
C
C------------------------------------------------------------------------------
C
	IF (NUMBER.LT.10) THEN
	   CODEARRAY(1) = NUMBER
	   NUMCODES = 1
	ELSEIF (NUMBER.LT.100) THEN
	   CODEARRAY(1) = NUMBER / 10
	   CODEARRAY(2) = MOD(NUMBER,10)
	   NUMCODES = 2
	ELSEIF (NUMBER.LT.1000) THEN
	   CODEARRAY(1) = NUMBER / 100
	   CODEARRAY(2) = (MOD(NUMBER,100)) / 10
	   CODEARRAY(3) = MOD(NUMBER,10)
	   NUMCODES = 3
	ELSE
	   NUMCODES = 0
	ENDIF
C
	RETURN
	END
