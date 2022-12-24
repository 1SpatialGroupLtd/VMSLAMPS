C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-10-12 15:25:42.000000000 +0100
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
	SUBROUTINE WRITE_MD_CODE(WHICH_CODE)
C
CDEC$	IDENT	'12OC94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created 					RJH	26-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Write a MAPDATA CODE entry
C
C Description
C
C	Writes the CODE entry for the current segment to the MAPDATA output
C	file.
C
C       Assumes the MAPDATA output file is already selected for writing.
C
	IMPLICIT NONE
C
C Arguments
C
	CHARACTER*(*)		WHICH_CODE	! MAPDATA code
C
C Functions
C
	INTEGER*4		SIGCHS
C
C Local variables
C
	CHARACTER*7		MDCHAR		! MapData feature code
	BYTE			MDCODE(7)	! MapData FC as byte array
	EQUIVALENCE		(MDCHAR,MDCODE)
C
C------------------------------------------------------------------------------
C Clear the byte array
C
	CALL VIOCLR(MDCODE,7,0)
	MDCHAR(1:SIGCHS(WHICH_CODE)) = WHICH_CODE
C
C Just write the CODE entry.
C
	CALL FLWRTF('CODE %A',MDCODE)
C
C Return
C
10000	RETURN
	END
