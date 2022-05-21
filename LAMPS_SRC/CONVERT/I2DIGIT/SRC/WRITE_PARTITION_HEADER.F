C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-01-07 17:36:10.000000000 +0000
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
	SUBROUTINE WRITE_PARTITION_HEADER()
C
CDEC$	IDENT	'27NO91'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	27-Nov-1991
C
C Description:
C       Write partition name and other information held in the partition
C       header.
C
        IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE	'GENERAL.CMN'		! General stuff
C
C Local Variables
C
	INTEGER*2	I,N
C
C------------------------------------------------------------------------------
C
C Words 1..16
C
	CALL ADD_NAME(PARTNAME(1:10),10)
	CALL ADD_WORD(32767)
	CALL ADD_WORD(32767)
	CALL ADD_WORD(1)
	CALL ADD_WORD(1)
	CALL ADD_WORD(1)
	CALL ADD_WORD(32767)
	CALL ADD_WORD(32767)
	CALL ADD_WORD(0)
	CALL ADD_WORD(0)
	CALL ADD_WORD(0)
	CALL ADD_WORD(0)
C
	RETURN
	END
