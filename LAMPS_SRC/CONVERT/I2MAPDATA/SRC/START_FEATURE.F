C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-10-12 15:25:44.000000000 +0100
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
	SUBROUTINE START_FEATURE()
C
CDEC$	IDENT	'12OC94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created 					ST	06-Oct-1994
C
C	CONVERT I2MAPDATA Utility - Start MapData feature
C
C Description
C
C	Write the SEGMENT abd CODE lines of the current MapData feature.
C
	IMPLICIT NONE
C
C Parameter Files
C
!	INCLUDE	'LSL$CMNIFF:CB.STR'		! record structure definition
C
!	INCLUDE	'CMN:I2MAPDATAMSG.PAR'		! message definitions
C
C Common Blocks
C
	INCLUDE	'CMN:IFF.CMN'      		! IFF specific things
	INCLUDE 'CMN:TABLES.CMN'		! parameter tables
C
C------------------------------------------------------------------------------
C
	IF (.NOT.STARTED_FEATURE) THEN
	   SEGNUM = SEGNUM + 1
	   CALL WRITE_MD_SEG(SEGNUM)	 	! Write the `SEGMENT' line
	   CALL WRITE_MD_CODE(FC_STR(FC_IND))	! Write the `CODE' line
	   STARTED_FEATURE = .TRUE.
	ENDIF
C
	RETURN
	END
