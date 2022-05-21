C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-09-09 18:22:34.000000000 +0100
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
	SUBROUTINE PATCH_HEADER()
C
CDEC$	IDENT	'12DE91'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	12-Dec-1991
C
C Description:
C       Routine to insert various fields into the first and second sectors
C       of the first DIGIT block, just before writing it to tape
C
        IMPLICIT NONE
C
C Parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE 'CODES.CMN'
C
C Common Blocks
C
	INCLUDE	'GENERAL.CMN'			! General stuff
C
C Local Variables
C
	INTEGER*2	SECTOR_COUNT
C
C------------------------------------------------------------------------------
C
C Calculate sector count
C
	IF (MOD(TOTBUFSIZE,DIGITSECSIZE).EQ.0) THEN
	   SECTOR_COUNT = TOTBUFSIZE/DIGITSECSIZE
	ELSE
	   SECTOR_COUNT = TOTBUFSIZE/DIGITSECSIZE + 1
	ENDIF
C
C We don't care about DISKBUFPTR now so we can use it for inserting the fields
C The size we change DISKBUFPTR to will never force a flush
C
	DISKBUFPTR = 2
	CALL ADD_WORD(SECTOR_COUNT)
	DISKBUFPTR = 15
	CALL ADD_WORD(SECTOR_COUNT-1)
	DISKBUFPTR = 134
	CALL ADD_WORD(HEIGHT)		! height
	CALL ADD_WORD(WIDTH)		! width
	CALL ADD_WORD(RESOLUTION)	! resolution
	CALL ADD_WORD(OFFSET(2))	! min Y reference point
	CALL ADD_WORD(OFFSET(1))	! min X reference point
	CALL ADD_WORD(OFFSET(2)+HEIGHT)	! max Y reference point
	CALL ADD_WORD(OFFSET(1)+WIDTH)	! max X reference point
C
	RETURN
	END
