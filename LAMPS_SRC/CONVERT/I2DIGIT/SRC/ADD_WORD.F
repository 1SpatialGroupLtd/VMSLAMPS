C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-09-02 11:18:46.000000000 +0100
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
	SUBROUTINE ADD_WORD(INWORD)
C
CDEC$	IDENT	'27NO91'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	27-Nov-1991
C
C Description:
C       Add the word to the output buffer. The bytes are swapped here.
C
        IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE	'COMMANDS.CMN'		! Commands line switches
	INCLUDE	'GENERAL.CMN'		! General variables
C
C Local Variables
C
	INTEGER*2	DBX,DBY
	INTEGER*2	INWORD
	INTEGER*2	COPYWORD
	INTEGER*2	NEWWORD
	BYTE		COPYBYTE(2)
	BYTE		NEWBYTE(2)
C
	EQUIVALENCE	(COPYWORD,COPYBYTE(1))
	EQUIVALENCE	(NEWWORD,NEWBYTE(1))
C
C------------------------------------------------------------------------------
C
	COPYWORD = INWORD
	NEWBYTE(1) = COPYBYTE(2)	! swap dem bytes around
	NEWBYTE(2) = COPYBYTE(1)
C
	IF (DISKBUFPTR.GT.DISKBUFSIZE) CALL FLUSH
	DBY = (DISKBUFPTR-1) / DISKBLOCKSIZE + 1
	DBX = (DISKBUFPTR-((DBY-1)*DISKBLOCKSIZE))
C
	DISKBLOCK(DBX,DBY)=NEWWORD	! for final output
C	DISKBLOCK(DBX,DBY)=COPYWORD 	! for debugging on VAX - but not needed
	DISKBUFPTR = DISKBUFPTR + 1	! now that MTDUMP has /SWAP
C
	RETURN
	END
