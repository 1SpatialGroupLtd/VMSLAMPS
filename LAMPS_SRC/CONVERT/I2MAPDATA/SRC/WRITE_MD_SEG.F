C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-10-10 14:08:50.000000000 +0100
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
	SUBROUTINE WRITE_MD_SEG(WHICH_SEG)
C
CDEC$	IDENT	'10OC94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created 					RJH	26-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Write a MAPDATA SEGMENT entry
C
C Description
C
C	Writes a SEGMENT entry to the MAPDATA output file. The SEGMENT entry
C	includes a text string in the attribute field after the segment number.
C
C       Assumes the MAPDATA output file is already selected for writing.
C
	IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE	'CMN:IFF.CMN'      		! IFF specific things
C
C Arguments
C
	INTEGER*4	WHICH_SEG	! segment number
!!!!	CHARACTER*(*)	TEXT_STRING	! text string for attribute field
C
C Just write the SEGMENT entry, including the text string.
C
	CALL FLWRTF('SEGMENT %N  **  %A  **',WHICH_SEG,AC_BYTE)
C
C Return
C
10000	RETURN
	END
