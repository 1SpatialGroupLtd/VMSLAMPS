C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-09-02 14:43:44.000000000 +0100
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
	SUBROUTINE WRITE_SECTOR_HEADER()
C
CDEC$	IDENT	'27NO91'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	27-Nov-1991
C
C Description:
C       Create a sector header with one partition name and other information.
C       Various unknown details will be filled in later when known.
C
        IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE	'GENERAL.CMN'		! General variables
C
C Parameters
C
	PARAMETER	MAX_PARTITIONS = 15
C
C Local Variables
C
	INTEGER*2	NUM_PARTITIONS
	INTEGER*2	I
C
C------------------------------------------------------------------------------
C
C At present the whole file is being written to one partition
C
	NUM_PARTITIONS = 1
C
C Words 1..8
C
	CALL ADD_WORD(310)	! File type
	CALL ADD_WORD(0)	! Number of sectors (unknown at present)
	CALL ADD_WORD(1)	! Number of headers
	CALL ADD_WORD(1)	! Number of partitions
	CALL ADD_WORD(9)	! Directory location
	CALL ADD_WORD(0)	! Reserved
	CALL ADD_WORD(0)	! Reserved
	CALL ADD_WORD(0)	! Reserved
C
C Words 9..16 (1st partition)
C
	CALL ADD_NAME(PARTNAME(1:10),10)
	CALL ADD_WORD(1)
	CALL ADD_WORD(0)	! sector size (unknown at present)
	CALL ADD_WORD(0)
C
C Fill rest of header sector with zeros. Probably quicker not to use ADD_WORD
C but lets keep it neat and tidy.
C
	DO 100 I = 1,8*(MAX_PARTITIONS-NUM_PARTITIONS)
	   CALL ADD_WORD(0)
100	CONTINUE
C
	RETURN
	END
