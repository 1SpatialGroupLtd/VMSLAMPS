C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-01-07 16:36:12.000000000 +0000
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
	SUBROUTINE ADD_NAME(NAME,NAMELEN)
C
CDEC$	IDENT	'27NO91'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	27-Nov-1991
C
C Description:
C       Add a name (up to 80 characters) to the output buffer. As constants
C       may be passed in you can't alter NAME or NAMELEN. So a copy is made.
C       The bytes of the string are reversed here because ADD_WORD reverses
C       the order if bytes. This will make characters come out correct.
C       
        IMPLICIT NONE
C
C Arguments
C
	CHARACTER*(*)	NAME
	INTEGER*4	NAMELEN
C
C Local Variables
C

	INTEGER*4	I,LEN
	CHARACTER*80	NAMECOPY
	INTEGER*2	NAMEWORD
	BYTE		NAMEBYTE(2)
	BYTE		NAMEBUF(80)
C
	EQUIVALENCE	(NAMEWORD,NAMEBYTE(1))
	EQUIVALENCE	(NAMECOPY,NAMEBUF(1))
C
C------------------------------------------------------------------------------
C
	LEN = NAMELEN
	IF (LEN.LT.1.OR.LEN.GT.79) GOTO 999
C
	DO 50 I = 1,80
	   NAMECOPY(I:I)=' '
50	CONTINUE
	NAMECOPY(1:LEN)=NAME(1:LEN)
C
	IF (MOD(LEN,2).EQ.1) LEN = LEN + 1
C
	DO 100 I = 1,LEN,2
	   NAMEBYTE(1) = NAMEBUF(I+1)
	   NAMEBYTE(2) = NAMEBUF(I)
	   CALL ADD_WORD(NAMEWORD)
100	CONTINUE
C
999	RETURN
	END
